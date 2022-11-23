module Form = Edit_Rfq_Form_Admin

module Query = %relay(`
  query RfqPurchaseDetailAdminQuery($rfqId: Int!) {
    rfq(number: $rfqId) {
      ...RfqPurchaseDetailBuyerInfoAdminFragment
      ...RfqPurchaseDetailRequestInfoAdminFragment
      ...RfqPurchaseDetailAdminRfqFragment
      ...RfqPurchaseDetailRfqProductsListAdminFragment
    }
  }
`)

module Fragment = %relay(`
  fragment RfqPurchaseDetailAdminRfqFragment on Rfq {
    id
    number
  
    address
  
    contactMd {
      id
      name
    }
  
    sourcingMd1 {
      id
      name
    }
  
    sourcingMd2 {
      id
      name
    }
  
    sourcingMd3 {
      id
      name
    }
  }
`)

module Mutation = %relay(`
  mutation RfqPurchaseDetailAdminRfqMutation(
    $id: ID!
    $contactMdId: ID
    $sourcingMdId1: ID
    $sourcingMdId2: ID
    $sourcingMdId3: ID
    $address: String
    $rfqProducts: [UpdateRfqProductsInput!]!
  ) {
    updateRfq(
      input: {
        id: $id
        contactMdId: $contactMdId
        sourcingMdId1: $sourcingMdId1
        sourcingMdId2: $sourcingMdId2
        sourcingMdId3: $sourcingMdId3
        address: $address
      }
    ) {
      ... on UpdateRfqResult {
        updatedRfq {
          ...RfqPurchaseDetailBuyerInfoAdminFragment
          ...RfqPurchaseDetailRequestInfoAdminFragment
          ...RfqPurchaseDetailAdminRfqFragment
        }
      }
  
      ... on Error {
        code
        message
      }
    }
  
    updateRfqProducts(input: $rfqProducts) {
      ... on UpdateRfqProductsResult {
        updatedRfqProducts {
          id
          ...RfqPurchaseDetailRfqProductsListAdminListItemFragment
        }
      }
  
      ... on Error {
        code
        message
      }
    }
  }
`)

module Request = {
  let getAdminId = (item: SearchAdmin_Admin.Item.t) => {
    switch item {
    | NotSelected => None
    | Selected({id}) => id->Some
    }
  }

  let nonEmptyStr = s => s != ""
  let filterEmptyString = s => s == "" ? None : Some(s)

  type payload = {
    id: string,
    contactMdId: option<string>,
    sourcingMdId1: option<string>,
    sourcingMdId2: option<string>,
    sourcingMdId3: option<string>,
    address: option<string>,
  }

  let parseRfq = (form: Form.t, ~rfqNodeId) => {
    {
      id: rfqNodeId,
      contactMdId: form.contactMd->getAdminId,
      sourcingMdId1: form.sourcingMd1->getAdminId,
      sourcingMdId2: form.sourcingMd2->getAdminId,
      sourcingMdId3: form.sourcingMd3->getAdminId,
      address: form.address->filterEmptyString,
    }
  }

  let parseRfqProducts = rfqProducts => {
    open Rfq_PurchaseDetail_RfqProducts_List_Admin.ListItem.Updater
    let asArray = rfqProducts->Map.String.toArray

    switch asArray->Array.getBy(((_k, v)) => v == NotAvailable) {
    | Some(_) => None
    | None =>
      Some(
        asArray->Array.keepMap(((rfqProductId, available)) => {
          switch available {
          | NotAvailable => None
          | Available({
              amount,
              unitPrice,
              sellerPrice,
              deliveryFee,
              deliveryMethod,
              status,
              statusInfo,
              promotedProductId,
              sellerId,
            }) =>
            Some((
              rfqProductId,
              {
                amount,
                unitPrice,
                sellerPrice,
                deliveryFee,
                deliveryMethod,
                status,
                statusInfo,
                promotedProductId,
                sellerId,
              },
            ))
          }
        }),
      )
    }
  }
}

module Toast = {
  type appearance =
    | Success
    | Failure

  let use = () => {
    let {addToast} = ReactToastNotifications.useToasts()

    (message, appearance) => {
      switch appearance {
      | Success =>
        addToast(.
          <div className=%twc("flex items-center")>
            <IconCheck height="24" width="24" fill="#12B564" className=%twc("mr-2") />
            {message->React.string}
          </div>,
          {appearance: "success"},
        )

      | Failure =>
        addToast(.
          <div className=%twc("flex items-center")>
            <IconError height="24" width="24" className=%twc("mr-2") />
            {message->React.string}
          </div>,
          {appearance: "error"},
        )
      }
    }
  }
}

module NotFound = {
  @react.component
  let make = () => React.null
}

module Page = {
  @react.component
  let make = (~rfqId) => {
    let showToast = Toast.use()
    let {rfq} = Query.use(~variables=Query.makeVariables(~rfqId), ())
    let {id, number, contactMd, sourcingMd1, sourcingMd2, sourcingMd3, address} =
      rfq.fragmentRefs->Fragment.use

    let defaultRfq: Form.t = {
      open SearchAdmin_Admin.Item

      {
        contactMd: contactMd->Option.mapWithDefault(NotSelected, ({id, name}) => Selected({
          id,
          label: name,
        })),
        sourcingMd1: sourcingMd1->Option.mapWithDefault(NotSelected, ({id, name}) => Selected({
          id,
          label: name,
        })),
        sourcingMd2: sourcingMd2->Option.mapWithDefault(NotSelected, ({id, name}) => Selected({
          id,
          label: name,
        })),
        sourcingMd3: sourcingMd3->Option.mapWithDefault(NotSelected, ({id, name}) => Selected({
          id,
          label: name,
        })),
        address: address->Option.getWithDefault(""),
      }
    }

    let (updateRfq, isUpdating) = Mutation.use()
    let (rfqProducts, setRfqProducts) = React.Uncurried.useState(_ => Map.String.fromArray([]))
    let (resetKey, setResetKey) = React.Uncurried.useState(_ =>
      UniqueId.make(~prefix="rfq-form-reset", ())
    )
    let softRefresh = _ => setResetKey(._ => UniqueId.make(~prefix="rfq-form-reset", ()))

    let form = Form.FormHandler.use(
      ~config={
        mode: #onChange,
        defaultValues: defaultRfq,
      },
    )

    let isSomethingChanged = {
      let defaults = defaultRfq
      let values = form->Form.FormHandler.getValues

      switch (defaults == values, rfqProducts->Map.String.toArray) {
      | (true, []) => false
      | _ => true
      }
    }

    let submit = form->Form.FormHandler.handleSubmit((data, _) => {
      rfqProducts
      ->Request.parseRfqProducts
      ->Option.map(rfqProducts' => {
        let {id, contactMdId, sourcingMdId1, sourcingMdId2, sourcingMdId3, address} =
          data->Request.parseRfq(~rfqNodeId=id)

        let variables = Mutation.makeVariables(
          ~id,
          ~contactMdId?,
          ~sourcingMdId1?,
          ~sourcingMdId2?,
          ~sourcingMdId3?,
          ~address?,
          ~rfqProducts={
            rfqProducts'->Array.map(
              ((
                rfqProductId,
                {
                  amount,
                  unitPrice,
                  sellerPrice,
                  deliveryFee,
                  deliveryMethod,
                  status,
                  statusInfo,
                  promotedProductId,
                  sellerId,
                },
              )): RfqPurchaseDetailAdminRfqMutation_graphql.Types.updateRfqProductsInput => {
                id: rfqProductId,
                amount,
                unitPrice,
                sellerPrice,
                deliveryFee,
                deliveryMethod: deliveryMethod->Option.flatMap(
                  Edit_RfqProduct_Form_Admin.DeliveryMethod.toValue,
                ),
                status: status->Option.flatMap(Edit_RfqProduct_Form_Admin.Status.toValue),
                statusInfo: statusInfo->Option.flatMap(
                  Edit_RfqProduct_Form_Admin.StatusInfo.toValue,
                ),
                promotedProductId,
                sellerId,
                amountUnit: None,
                meatBrandId: None,
                meatGradeId: None,
                memo: None,
                origin: None,
                packageAmount: None,
                previousPrice: None,
                processingMethod: None,
                requestedDeliveredAt: None,
                storageMethod: None,
                tradeCycle: None,
                usage: None,
                description: None,
                isCrossSelling: None,
              },
            )
          },
          (),
        )

        updateRfq(
          ~variables,
          ~onCompleted={
            ({updateRfq}, _) => {
              switch updateRfq {
              | Some(#UpdateRfqResult(_)) => {
                  `견적서가 수정되었습니다.`->showToast(Success)
                  softRefresh()
                }

              | _ => `견적서 수정에 실패하였습니다.`->showToast(Failure)
              }
            }
          },
          ~onError={_ => `견적 등록에 실패하였습니다.`->showToast(Failure)},
          (),
        )->ignore
      })
      ->ignore
    })

    <main className=%twc("relative min-h-full min-w-[1080px] bg-gray-100")>
      <form onSubmit=submit>
        <section className=%twc("w-full p-5 relative flex flex-col flex-1 mb-[60px]")>
          <Rfq_PurchaseDetail_BreadCrumb_Admin />
          <h1 className=%twc("mt-5 text-xl text-text-L1 font-bold")>
            {`구매 신청 상세(${number->Int.toString})`->React.string}
          </h1>
          <section
            className=%twc(
              "mt-4 w-full pb-2 bg-white rounded-sm text-text-L1 grid grid-cols-3 divide-x"
            )>
            <Rfq_PurchaseDetail_BuyerInfo_Admin query=rfq.fragmentRefs />
            <Rfq_PurchaseDetail_RequestInfo_Admin form query=rfq.fragmentRefs />
            <Rfq_PurchaseDetail_MdInfo_Admin form />
          </section>
          <Rfq_PurchaseDetail_RfqProducts_List_Admin
            resetKey
            softRefresh
            query=rfq.fragmentRefs
            onChangeList={(id, nextV) => {
              let prevV = rfqProducts->Map.String.get(id)
              switch (prevV, nextV) {
              | (Some(prevV'), Some(nextV')) if prevV' != nextV' =>
                setRfqProducts(.prev => prev->Map.String.set(id, nextV'))
              | (Some(_), Some(_)) => ()
              | (Some(_), None) => setRfqProducts(.prev => prev->Map.String.remove(id))
              | (None, Some(nextV')) => setRfqProducts(.prev => prev->Map.String.set(id, nextV'))
              | (None, None) => ()
              }
            }}
          />
        </section>
        <section
          className=%twc(
            "fixed right-0 bottom-0 w-[calc(100%-288px)] h-[60px] bg-white border-t flex items-center justify-end"
          )>
          {switch (isSomethingChanged, isUpdating) {
          | (false, _) | (_, true) =>
            <button
              type_="submit"
              className=%twc("mr-5 px-3 py-[6px] bg-gray-100 rounded-md text-text-L3")
              disabled=true>
              {`저장`->React.string}
            </button>

          | _ =>
            <button
              type_="submit"
              className=%twc("mr-5 px-3 py-[6px] bg-primary rounded-md text-white")
              disabled=false>
              {`저장`->React.string}
            </button>
          }}
        </section>
      </form>
    </main>
  }
}

@react.component
let make = () => {
  let router = Next.Router.useRouter()
  let rfqId = router.query->Js.Dict.get("pid")

  <Authorization.Admin title={`관리자 구매 신청 상세`}>
    <RescriptReactErrorBoundary fallback={_ => `에러`->React.string}>
      <React.Suspense fallback={React.null}>
        {switch rfqId->Option.flatMap(Int.fromString) {
        | None => <NotFound />
        | Some(rfqId') => <Page rfqId=rfqId' />
        }}
      </React.Suspense>
    </RescriptReactErrorBoundary>
  </Authorization.Admin>
}
