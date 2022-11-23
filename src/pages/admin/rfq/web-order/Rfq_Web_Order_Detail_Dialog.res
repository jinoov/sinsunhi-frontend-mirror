module Fragment = %relay(`
  fragment RfqWebOrderDetailDialogFragment on RfqWosOrderProduct {
    buyer {
      name
    }
    seller {
      name
    }
  
    category {
      fullyQualifiedName {
        name
      }
    }
    rfqProduct {
      number
      firstAmount: amount
    }
    rfqWosOrderProductNo
    amountUnit
    deliveryMethod
    deliveryFee
    createdAt
    requestedDeliveredAt
    paidAmountAcc
    amount
    sellerPrice
    unitPrice
    address
    status
  }
`)

module Mutation = %relay(`
  mutation RfqWebOrderDetailDialogMutation(
    $address: String!
    $amount: DecimalNumber!
    $deliveryFee: Int!
    $deliveryMethod: RfqProductDeliveryMethod
    $rfqWosOrderProductNo: Int!
    $status: RfqWosOrderProductStatus!
    $unitPrice: Int!
    $sellerPrice: Int!
  ) {
    updateRfqWosOrderProduct(
      input: {
        address: $address
        amount: $amount
        deliveryFee: $deliveryFee
        deliveryMethod: $deliveryMethod
        rfqWosOrderProductNo: $rfqWosOrderProductNo
        status: $status
        unitPrice: $unitPrice
        sellerPrice: $sellerPrice
      }
    ) {
      ... on RfqWosOrderProduct {
        ...RfqWebOrderAdminFragment
      }
      ... on Error {
        code
        message
      }
    }
  }
`)

open Rfq_Web_Order_Form

module Column = {
  type size = Small | Large

  @react.component
  let make = (~title, ~size=Small, ~children) => {
    let titleWidth = switch size {
    | Small => %twc("w-[100px] min-w-[100px]")
    | Large => %twc("w-[180px] min-w-[180px]")
    }

    <div className={%twc("flex items-center w-full h-[42px] max-h-[42px]")}>
      <div className={cx([%twc("bg-div-shape-L2 pl-3 py-2.5 text-text-L2"), titleWidth])}>
        {title->React.string}
      </div>
      {children}
    </div>
  }
}

@react.component
let make = (~query, ~num) => {
  let {
    buyer,
    seller,
    createdAt,
    rfqWosOrderProductNo,
    category: {fullyQualifiedName},
    rfqProduct,
    amountUnit,
    requestedDeliveredAt,
    deliveryMethod,
    deliveryFee,
    amount,
    sellerPrice,
    unitPrice,
    address,
    paidAmountAcc,
    status,
  } = Fragment.use(query)

  let convertDeliveryMethod: RfqWebOrderDetailDialogFragment_graphql.Types.enum_RfqProductDeliveryMethod => deliveryMethod = d =>
    switch d {
    | #FREIGHT => #FREIGHT
    | #SELLER_DELIVERY => #SELLER_DELIVERY
    | #BUYER_TAKE => #BUYER_TAKE
    | _ => #NOT_SELECTED
    }

  let toPriceWithComma = s =>
    s
    ->Js.String2.replaceByRe(%re("/[\D]/g"), "")
    ->Js.String2.replaceByRe(%re("/\d{1,3}(?=(\d{3})+(?!\d))/g"), "$&,")

  let toPrice = s => s->Js.String2.replaceByRe(%re("/[\D]/g"), "")

  let defaultValues = {
    deliveryAddress: address->Option.getWithDefault(""),
    deliveryMethod: deliveryMethod->Option.mapWithDefault(#NOT_SELECTED, convertDeliveryMethod),
    orderAmount: amount->Float.fromString->Option.mapWithDefault("", Float.toString),
    firstAmount: rfqProduct.firstAmount->Float.toString,
    unitSuppliedPrice: sellerPrice->Option.mapWithDefault("", i =>
      i->Int.toString->toPriceWithComma
    ),
    unitPrice: unitPrice->Int.toString->toPriceWithComma,
    deliveryFee: deliveryFee->Option.mapWithDefault("", i => i->Int.toString->toPriceWithComma),
    deliveryConfirm: status == #AMOUNT_CONFIRMED,
  }

  let form = Form.use(~config={defaultValues, mode: #onChange})
  let reset = () => form->Form.reset(defaultValues)

  let orderAmount =
    form->AmountAndPrice.OrderAmountField.watch->Float.fromString->Option.getWithDefault(0.)
  let unitPrice =
    form->AmountAndPrice.PriceField.watch->toPrice->Float.fromString->Option.getWithDefault(0.)
  let alreadyPaidPrice =
    paidAmountAcc->Option.flatMap(s => s->toPrice->Float.fromString)->Option.getWithDefault(0.)
  let deliveryFee =
    form->DeliveryFee.Field.watch->toPrice->Float.fromString->Option.getWithDefault(0.)

  let disabled = status == #AMOUNT_CONFIRMED
  let balance = (orderAmount *. unitPrice +. deliveryFee -. alreadyPaidPrice)->Locale.Float.round0
  let (isShowAddrSearch, setShowAddrSearch) = React.Uncurried.useState(_ => false)
  let formatDate = d => d->Js.Date.fromString->DateFns.format("yyyy/MM/dd")

  let (mutate, _) = Mutation.use()
  let {addToast} = ReactToastNotifications.useToasts()

  let matchDeliveryMethod = (d: deliveryMethod) =>
    switch d {
    | #FREIGHT => Some(#FREIGHT)
    | #SELLER_DELIVERY => Some(#SELLER_DELIVERY)
    | #BUYER_TAKE => Some(#BUYER_TAKE)
    | _ => None
    }

  let handleOnSubmit = (data: fields, _) => {
    mutate(
      ~variables={
        address: data.deliveryAddress,
        amount: data.orderAmount,
        deliveryFee: data.deliveryFee->toPrice->Int.fromString->Option.getWithDefault(0),
        deliveryMethod: data.deliveryMethod->matchDeliveryMethod,
        rfqWosOrderProductNo,
        status: data.deliveryConfirm ? #AMOUNT_CONFIRMED : #CREATED,
        unitPrice: data.unitPrice->toPrice->Int.fromString->Option.getWithDefault(0),
        sellerPrice: data.unitSuppliedPrice->toPrice->Int.fromString->Option.getWithDefault(0),
      },
      ~onCompleted=({updateRfqWosOrderProduct}, _) => {
        switch updateRfqWosOrderProduct {
        | Some(#RfqWosOrderProduct(_)) =>
          addToast(.
            <div className=%twc("flex items-center")>
              <IconCheck height="24" width="24" fill="#12B564" className=%twc("mr-2") />
              {"저장되었습니다."->React.string}
            </div>,
            {appearance: "success"},
          )
        | Some(#Error({message})) =>
          addToast(.
            <div className=%twc("flex items-center")>
              <IconError height="24" width="24" className=%twc("mr-2") />
              {message
              ->Option.getWithDefault("견적정보 저장에 실패하였습니다.")
              ->React.string}
            </div>,
            {appearance: "error"},
          )
        | _ =>
          addToast(.
            <div className=%twc("flex items-center")>
              <IconError height="24" width="24" className=%twc("mr-2") />
              {"견적정보 저장에 실패하였습니다."->React.string}
            </div>,
            {appearance: "error"},
          )
        }
      },
      (),
    )->ignore
  }

  let onOpenChange = _ => {
    setShowAddrSearch(._ => false)
    reset()
  }

  open RadixUI.Dialog
  <Root onOpenChange>
    <Trigger>
      <div className=%twc("text-blue-400 underline")> {num->React.string} </div>
    </Trigger>
    <Portal>
      <Overlay className=%twc("dialog-overlay") />
      <Content
        className=%twc("w-1/2 dialog-content-nosize min-w-[700px]")
        onOpenAutoFocus={ReactEvent.Synthetic.preventDefault}>
        <form onSubmit={form->Form.handleSubmit(handleOnSubmit)}>
          <div className=%twc("p-5 text-sm overflow-y-scroll max-h-[800px]")>
            <div className=%twc("flex items-center justify-between")>
              <h2 className=%twc("text-xl font-bold")> {"견적·주문 상세"->React.string} </h2>
              <Close className=%twc("inline-block p-1 focus:outline-none ml-auto")>
                <IconClose height="24" width="24" fill="#262626" />
              </Close>
            </div>
            <div>
              <h3 className=%twc("mt-4 mb-2.5 text-text-L1 font-bold")>
                {"견적정보"->React.string}
              </h3>
              <div
                className=%twc(
                  "w-full flex items-center flex-auto text-[13px] border border-x-0 border-div-border-L2"
                )>
                <Column title="바이어">
                  <span className=%twc("p-3")>
                    {buyer->Option.mapWithDefault("-", b => b.name)->React.string}
                  </span>
                </Column>
                <Column title="매칭 셀러">
                  <span className=%twc("p-3")>
                    {seller->Option.mapWithDefault("-", s => s.name)->React.string}
                  </span>
                </Column>
                <Column title="견적확정일">
                  <span className=%twc("p-3")>
                    {createdAt->Option.mapWithDefault("-", formatDate)->React.string}
                  </span>
                </Column>
              </div>
            </div>
            //
            <div>
              <h3 className=%twc("mt-4 mb-2.5 text-text-L1 font-bold")>
                {"견적·주문 상세 정보"->React.string}
              </h3>
              <div
                className=%twc(
                  "w-full flex items-center flex-auto text-[13px] border border-x-0 border-b-0 border-div-border-L2"
                )>
                <Column title="견적상품번호">
                  <span className=%twc("p-3")>
                    {rfqProduct.number->Int.toString->React.string}
                  </span>
                </Column>
                <Column title="주문상품번호">
                  <span className=%twc("p-3")>
                    {rfqWosOrderProductNo->Int.toString->React.string}
                  </span>
                </Column>
              </div>
              <div
                className=%twc(
                  "w-full flex items-center flex-auto text-[13px] border border-x-0 border-b-0 border-div-border-L2"
                )>
                <Column title="품목/품종">
                  <span className=%twc("p-3")>
                    {fullyQualifiedName->Garter.Array.joinWith(" > ", f => f.name)->React.string}
                  </span>
                </Column>
                <Column title="희망배송일">
                  <span className=%twc("p-3")>
                    {requestedDeliveredAt->Option.mapWithDefault("-", formatDate)->React.string}
                  </span>
                </Column>
              </div>
              <div
                className=%twc(
                  "w-full flex items-center flex-auto text-[13px] border border-x-0 border-b-0 border-div-border-L2"
                )>
                <Column title="거래단위">
                  <span className=%twc("p-3")> {amountUnit->React.string} </span>
                </Column>
                <DeliveryMethod.Input form disabled />
              </div>
              <AmountAndPrice.AmountInput form disabled />
              <AmountAndPrice.PriceInput form disabled />
              <AmountAndPrice.ByFirstAmountInput form />
              <AmountAndPrice.ByOrderPriceInput form />
              <div
                className=%twc(
                  "w-full flex items-center flex-auto text-[13px] border border-x-0 border-b-0 border-div-border-L2"
                )>
                <Column title="누적 결제액(잔액)" size=Column.Large>
                  <span className=%twc("p-3")>
                    {`${alreadyPaidPrice->Locale.Float.show(
                        ~digits=3,
                      )}원(${balance->Locale.Float.show(~digits=3)}원)`->React.string}
                  </span>
                </Column>
                <DeliveryFee.Input form disabled />
              </div>
              <DeliveryAddress.Input form isShowAddrSearch setShowAddrSearch disabled />
            </div>
            <div className=%twc("mt-3 w-full flex items-center justify-between")>
              <DeliveryConfirm.Input form disabled />
              <button
                disabled
                className=%twc("py-1.5 px-3 rounded-[10px] bg-primary text-inverted interactable")>
                {"저장"->React.string}
              </button>
            </div>
          </div>
        </form>
      </Content>
    </Portal>
  </Root>
}
