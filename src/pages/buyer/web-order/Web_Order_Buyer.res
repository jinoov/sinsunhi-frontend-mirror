module Query = %relay(`
    query WebOrderBuyer_TempWosOrder_Query($tempWosOrderId: Int!) {
      tempWosOrder(tempWosOrderId: $tempWosOrderId) {
        order {
          status
        }
        data {
          productOptions {
            quantity
            updatedAt: cartUpdatedAt
            product {
              image {
                thumb100x100
              }
              displayName
              number
              ... on NormalProduct {
                isCourierAvailable
                isVat
              }
              ... on QuotableProduct {
                isCourierAvailable
                isVat
              }
            }
            productOption {
              grade
              optionName
              stockSku
              price
              isFreeShipping
              productOptionCost {
                deliveryCost
              }
            }
          }
        }
      }
    }
`)

module Mutation = {
  module UpdateTempWosOrder = %relay(`
  mutation WebOrderBuyer_UpdateTempWosOrder_Mutation(
    $orderUserId: Int!
    $paymentPurpose: String!
    $productOptions: [WosProductOptionInput!]!
    $totalDeliveryCost: Int!
    $totalOrderPrice: Int!
    $tempOrderId: Int!
  ) {
    updateTempWosOrder(
      input: {
        orderUserId: $orderUserId
        paymentPurpose: $paymentPurpose
        productOptions: $productOptions
        totalDeliveryCost: $totalDeliveryCost
        totalOrderPrice: $totalOrderPrice
        tempOrderId: $tempOrderId
      }
    ) {
      ... on CreateWosOrderResult {
        orderNo
        tempOrderId
      }
      ... on Error {
        # code
        message
      }
      ... on WosError {
        code
        message
      }
    }
  }
`)
  module RequestPayment = %relay(`
  mutation WebOrderBuyer_RequestPayment_Mutation(
    $paymentMethod: PaymentMethod!
    $amount: Int!
    $purpose: PaymentPurpose!
  ) {
    requestPayment(
      input: { paymentMethod: $paymentMethod, amount: $amount, purpose: $purpose }
    ) {
      ... on RequestPaymentKCPResult {
        siteCd
        siteKey
        siteName
        ordrIdxx
        currency
        buyrName
      }
      ... on RequestPaymentTossPaymentsResult {
        orderId
        amount
        clientKey
        customerName
        customerEmail
        paymentId
      }
      ... on Error {
        code
        message
      }
    }
  }
`)
}

open ReactHookForm
module Form = Web_Order_Buyer_Form
module PlaceHolder = Web_Order_Item_Buyer.PlaceHolder

let makeMutationVariable = (formData: Form.formData, tempOrderId) => {
  let {productInfos} = formData
  let totalOrderPrice = productInfos->Array.map(info => info.totalPrice)->Garter_Math.sum_int
  let totalDeliveryCost =
    productInfos
    ->Array.map(info =>
      info.productOptions->Array.map(({deliveryCost, quantity}) => deliveryCost * quantity)
    )
    ->Array.concatMany
    ->Garter_Math.sum_int
  Mutation.UpdateTempWosOrder.makeVariables(
    ~orderUserId=formData.orderUserId,
    ~paymentPurpose="ORDER",
    ~totalDeliveryCost,
    ~totalOrderPrice,
    ~tempOrderId,
    ~productOptions=productInfos
    ->Array.map(info => info.productOptions)
    ->Array.concatMany
    ->Array.map(option => {
      Mutation.UpdateTempWosOrder.make_wosProductOptionInput(
        ~deliveryCost=option.deliveryCost,
        ~deliveryDesiredDate=?formData.deliveryDesiredDate,
        ~deliveryMessage=?formData.deliveryMessage,
        ~deliveryType=formData.deliveryType,
        ~isTaxFree=option.isTaxFree,
        ~ordererName=formData.ordererName,
        ~ordererPhone=formData.ordererPhone,
        ~productId=option.productId,
        ~receiverAddress={
          formData.receiverAddress->Option.getWithDefault("") ++
            formData.receiverDetailAddress->Option.mapWithDefault("", str => ` ${str}`)
        },
        ~receiverName=?formData.receiverName,
        ~receiverPhone=?formData.receiverPhone,
        ~receiverZipCode=?formData.receiverZipCode,
        ~stockSku=option.stockSku,
        (),
      )
    }),
  )
}

module FreightComfirmDialog = {
  @react.component
  let make = (~isShow, ~confirmFn, ~cancel) => {
    <Dialog isShow onConfirm={_ => confirmFn()} onCancel={cancel} textOnConfirm={"결제"}>
      <span className=%twc("flex justify-center text-center whitespace-pre text-text-L1 pt-3")>
        {"화물배송의 경우 배송지에 따라
추가배송비(화물비)가 후청구 됩니다.
담당MD가 화물비를 알려드리기 위해
별도로 연락을 드릴 예정입니다.
위 사항이 확인되셨다면
결제를 눌러 다음 단계를 진행해 주세요."->React.string}
      </span>
    </Dialog>
  }
}

module CompletedOrderDialog = {
  @react.component
  let make = (
    ~order: WebOrderBuyer_TempWosOrder_Query_graphql.Types.response_tempWosOrder_order,
  ) => {
    let {useRouter, replace} = module(Next.Router)
    let router = useRouter()

    let isShow = switch order.status {
    | #DEPOSIT_PENDING
    | #SUCCESS
    | #COMPLETE =>
      Dialog.Show
    | _ => Dialog.Hide
    }

    <Dialog isShow onConfirm={_ => router->replace("/")}>
      <span className=%twc("flex justify-center")>
        {"이미 주문·결제가 완료된 주문서 입니다."->React.string}
      </span>
    </Dialog>
  }
}

@val @scope(("window", "location"))
external origin: string = "origin"

@val @scope(("window", "location"))
external pathname: string = "pathname"

@val @scope(("window", "location"))
external search: string = "search"

module Container = {
  @react.component
  let make = (~tempOrderId, ~deviceType) => {
    let {tempWosOrder} = Query.use(~variables={tempWosOrderId: tempOrderId}, ())

    let (updateTempWosOrderMutate, _) = Mutation.UpdateTempWosOrder.use()

    let (requestPaymentMutate, _) = Mutation.RequestPayment.use()
    let (freightDialogShow, setFreightDialogShow) = React.Uncurried.useState(_ => Dialog.Hide)
    let (confirmFn, setConfirmFn) = React.Uncurried.useState(_ => ignore)

    let {addToast} = ReactToastNotifications.useToasts()
    let availableButton = ToggleOrderAndPayment.use()

    let handleOnCancel = ReactEvents.interceptingHandler(_ => {
      setFreightDialogShow(._ => Dialog.Hide)
      setConfirmFn(._ => ignore)
    })

    let handleError = (~message=?, ()) => {
      setConfirmFn(._ => ignore)
      addToast(.
        <div className=%twc("flex items-center w-full whitespace-pre-wrap")>
          <IconError height="24" width="24" className=%twc("mr-2") />
          {j`결제가 실패하였습니다. ${message->Option.getWithDefault("")}`->React.string}
        </div>,
        {appearance: "error"},
      )
    }

    let methods = Hooks.Form.use(.
      ~config=Hooks.Form.config(
        ~mode=#onSubmit,
        ~defaultValues=[
          (
            Form.name,
            [("payment-method", Js.Json.string("virtual"))]->Js.Dict.fromArray->Js.Json.object_,
          ),
        ]
        ->Js.Dict.fromArray
        ->Js.Json.object_,
        (),
      ),
      (),
    )
    let {handleSubmit} = methods

    let onSubmit = (data: Js.Json.t, _) => {
      switch data->Form.submit_decode {
      | Ok({webOrder: data'}) =>
        let confirm = () =>
          {
            let {productInfos} = data'
            setFreightDialogShow(._ => Dialog.Hide)
            // 토스 페이먼츠 결제 화면을 띄우기 직전에 화물배송확인 dialog를 닫는다
            updateTempWosOrderMutate(
              ~variables=makeMutationVariable(data', tempOrderId),
              ~onCompleted={
                ({updateTempWosOrder}, _) => {
                  switch updateTempWosOrder {
                  | Some(result) =>
                    switch result {
                    | #CreateWosOrderResult({orderNo, tempOrderId}) =>
                      let taxFreeAmount = Some(
                        productInfos
                        ->Array.map(info =>
                          switch info.isTaxFree {
                          | true => info.totalPrice
                          | false => 0
                          }
                        )
                        ->Garter_Math.sum_int,
                      )

                      let totalOrderPrice =
                        productInfos->Array.map(info => info.totalPrice)->Garter_Math.sum_int

                      requestPaymentMutate(
                        ~variables={
                          paymentMethod: data'.paymentMethod,
                          amount: totalOrderPrice,
                          purpose: #ORDER,
                        },
                        ~onCompleted={
                          ({requestPayment}, _) => {
                            switch requestPayment {
                            | Some(result) =>
                              switch result {
                              | #RequestPaymentTossPaymentsResult(tossPaymentResult) => {
                                  let productOptions =
                                    productInfos
                                    ->Array.map(info => info.productOptions)
                                    ->Array.concatMany

                                  let orderName = switch productOptions->Array.get(0) {
                                  | None => `신선하이`
                                  | Some(productOption) =>
                                    productOption.productOptionName ++
                                    switch productOptions->Array.length {
                                    | num if num > 1 => ` 외 ${(num - 1)->Int.toString}건`
                                    | _ => ""
                                    }
                                  }

                                  Payments.requestTossPayment(.
                                    data'.paymentMethod->Payments.methodToTossValue,
                                    {
                                      amount: totalOrderPrice,
                                      orderId: "order-" ++
                                      tossPaymentResult.paymentId->Int.toString,
                                      orderName,
                                      taxFreeAmount,
                                      customerName: tossPaymentResult.customerName,
                                      validHours: data'.paymentMethod->Payments.tossPaymentsValidHours,
                                      successUrl: `${origin}/buyer/toss-payments/success?order-no=${orderNo}&payment-id=${tossPaymentResult.paymentId->Int.toString}&temp-order-id=${tempOrderId->Int.toString}`,
                                      failUrl: `${origin}/buyer/toss-payments/fail?temp-order-id=${tempOrderId->Int.toString}`,
                                      cashReceipt: data'.paymentMethod->Payments.tossPaymentsCashReceipt,
                                      appScheme: Global.Window.ReactNativeWebView.tOpt->Option.map(
                                        _ =>
                                          Js.Global.encodeURIComponent(
                                            `sinsunhi://com.greenlabs.sinsunhi/buyer/toss-payments/success?order-no=${orderNo}&payment-id=${tossPaymentResult.paymentId->Int.toString}&temp-order-id=${tempOrderId->Int.toString}`,
                                          ),
                                      ),
                                    },
                                  )
                                }

                              | #Error(err) =>
                                err.message->Option.forEach(message => handleError(~message, ()))
                                Js.log(err)
                              | _ =>
                                handleError(~message=`주문 생성에 실패하였습니다.`, ())
                              }
                            | None =>
                              handleError(~message=`주문 생성에 실패하였습니다.`, ())
                            }
                          }
                        },
                        ~onError={
                          err => handleError(~message=err.message, ())
                        },
                        (),
                      )->ignore
                    | #WosError({code, _}) =>
                      switch code {
                      | #INVALID_DELIVERY =>
                        handleError(~message=`유효하지 않은 배송 정보입니다.`, ())
                      | #INVALID_ORDER =>
                        handleError(~message=`유효하지 않은 주문 정보입니다.`, ())
                      | #INVALID_PAYMENT_PURPOSE =>
                        handleError(~message=`유효하지 않은 결제 목적입니다.`, ())
                      | #INVALID_PRODUCT =>
                        handleError(~message=`유효하지 않은 상품 정보입니다.`, ())
                      | #ADHOC_STOCK_SOLD_OUT =>
                        handleError(~message=`잔여 수량이 부족합니다.`, ())
                      | _ => handleError()
                      }
                    | #Error(_)
                    | _ =>
                      handleError(~message=`주문 생성 에러`, ())
                    }
                  | _ => handleError(~message=`주문 생성 요청 실패`, ())
                  }
                }
              },
              ~onError={
                err => handleError(~message=err.message, ())
              },
              (),
            )
          }->ignore

        switch (availableButton, data'.paymentMethod) {
        | (false, #VIRTUAL_ACCOUNT) =>
          Global.jsAlert(`서비스 점검으로 인해 가상계좌 주문 기능을 이용할 수 없습니다.`)
        | _ =>
          switch data'.deliveryType {
          | #FREIGHT => {
              setConfirmFn(._ => confirm)
              setFreightDialogShow(._ => Dialog.Show)
            }

          | _ => confirm()
          }
        }

      | Error(msg) => {
          Js.log(msg)
          handleError(~message=msg.message, ())
        }
      }
    }

    <>
      <ReactHookForm.Provider methods>
        <form onSubmit={handleSubmit(. onSubmit)}>
          {switch tempWosOrder {
          | Some(tempWosOrder') =>
            <>
              <Web_Order_Item_Buyer
                deviceType
                productOptions={tempWosOrder'.data->Option.mapWithDefault([], d =>
                  d.productOptions->Array.keepMap(Garter_Fn.identity)
                )}
              />
              <FreightComfirmDialog confirmFn cancel=handleOnCancel isShow=freightDialogShow />
              <CompletedOrderDialog order={tempWosOrder'.order} />
            </>
          | None => <PlaceHolder deviceType />
          }}
        </form>
      </ReactHookForm.Provider>
    </>
  }
}

type props = {deviceType: DeviceDetect.deviceType}
type params
type previewData

let default = (~props) => {
  let {deviceType} = props

  let router = Next.Router.useRouter()
  let tid = router.query->Js.Dict.get("tid")->Option.flatMap(Int.fromString)

  <Authorization.Buyer title={j`주문하기`} fallback={<PlaceHolder deviceType />}>
    <Next.Script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js" />
    <React.Suspense fallback={<PlaceHolder deviceType />}>
      {switch tid {
      | Some(tempOrderId) => <Container tempOrderId deviceType />
      | _ => <PlaceHolder deviceType />
      }}
    </React.Suspense>
  </Authorization.Buyer>
}

let getServerSideProps = (ctx: Next.GetServerSideProps.context<props, params, previewData>) => {
  let deviceType = DeviceDetect.detectDeviceFromCtx2(ctx.req)
  Js.Promise.resolve({
    "props": {"deviceType": deviceType},
  })
}
