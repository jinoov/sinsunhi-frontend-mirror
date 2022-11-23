module Form = Add_RfqProduct_Form_Admin

module Mutation = %relay(`
  mutation AddRfqProductButtonAdminMutation(
    $input: CreateRfqProductInput!
    $connections: [ID!]!
  ) {
    createRfqProduct(input: $input) {
      ... on CreateRfqProductResult {
        createdRfqProduct
          @appendNode(connections: $connections, edgeTypeName: "RfqProductEdge") {
          id
          ...RfqPurchaseDetailRfqProductsListAdminListItemFragment
        }
      }
  
      ... on Error {
        message
      }
    }
  }
`)

module Request = {
  type submit = {
    amount: float,
    amountUnit: Form.AmountUnit.t,
    categoryId: string,
    meatBrandId: option<string>,
    meatGradeId: option<string>,
    memo: option<string>,
    origin: option<Form.Origin.t>,
    packageAmount: option<int>,
    previousPrice: option<int>,
    processingMethod: option<string>,
    requestedDeliveredAt: option<string>, // iso date string
    rfqId: option<string>,
    storageMethod: option<Form.StorageMethod.t>,
    tradeCycle: option<Form.TradeCycle.t>,
    unitPrice: int,
    usage: option<string>,
    isCrossSelling: option<bool>,
    description: option<string>,
  }

  let filterEmptyString = s => s != "" ? Some(s) : None
  let makeIsoDate = s => {
    s->filterEmptyString->Option.map(Js.Date.fromString)->Option.map(Js.Date.toISOString)
  }

  let parseVariables = (form: Form.t, ~rfqId) => {
    switch (
      form.amount->Float.fromString,
      form.amountUnit->Form.AmountUnit.toValue,
      form.category->filterEmptyString,
      form.meatBrandId->filterEmptyString,
      form.meatGradeId->filterEmptyString,
      form.memo->filterEmptyString,
      form.origin->Form.Origin.toValue,
      form.packageAmount->Int.fromString,
      form.previousPrice->Int.fromString,
      form.processingMethod->filterEmptyString,
      form.requestedDeliveredAt->makeIsoDate,
      form.storageMethod->Form.StorageMethod.toValue,
      form.tradeCycle->Form.TradeCycle.toValue,
      form.unitPrice->Int.fromString,
      form.usage->filterEmptyString,
      form.isCrossSelling,
      form.description->filterEmptyString,
    ) {
    | (
        Some(amount),
        Some(amountUnit),
        Some(categoryId),
        meatBrandId,
        meatGradeId,
        memo,
        origin,
        packageAmount,
        previousPrice,
        processingMethod,
        requestedDeliveredAt,
        storageMethod,
        tradeCycle,
        Some(unitPrice),
        usage,
        isCrossSelling,
        description,
      ) =>
      Some({
        rfqId: rfqId->Some,
        amount,
        amountUnit,
        categoryId,
        meatBrandId,
        meatGradeId,
        memo,
        origin,
        packageAmount,
        previousPrice,
        processingMethod,
        requestedDeliveredAt,
        storageMethod,
        tradeCycle,
        unitPrice,
        usage,
        isCrossSelling: Some(isCrossSelling),
        description,
      })
    | _ => None
    }
  }

  let make = (form: Form.t, ~rfqId, ~connections): option<
    AddRfqProductButtonAdminMutation_graphql.Types.variables,
  > => {
    switch form->parseVariables(~rfqId) {
    | Some(payload) =>
      let {
        amount,
        amountUnit,
        categoryId,
        meatBrandId,
        meatGradeId,
        memo,
        origin,
        packageAmount,
        previousPrice,
        processingMethod,
        requestedDeliveredAt,
        storageMethod,
        tradeCycle,
        unitPrice,
        usage,
        isCrossSelling,
        description,
      } = payload
      Mutation.makeVariables(
        ~input={
          rfqId: payload.rfqId,
          amount,
          amountUnit,
          categoryId,
          meatBrandId,
          meatGradeId,
          memo,
          origin,
          packageAmount,
          previousPrice,
          processingMethod,
          requestedDeliveredAt,
          storageMethod,
          tradeCycle,
          unitPrice,
          usage,
          description,
          isCrossSelling,
        },
        ~connections,
      )->Some

    | _ => None
    }
  }
}

module Modal = {
  type show =
    | Show
    | Hide

  let toBool = v => {
    switch v {
    | Show => true
    | Hide => false
    }
  }

  module Header = {
    @react.component
    let make = (~title, ~closeModal) => {
      <header className=%twc("flex items-center justify-between")>
        <h1 className=%twc("text-xl font-bold")> {title->React.string} </h1>
        <button onClick={_ => closeModal()}>
          <DS_Icon.Common.CloseLarge2 height="28" width="28" />
        </button>
      </header>
    }
  }

  @react.component
  let make = (~showModal, ~children) => {
    <RadixUI.Dialog.Root _open={showModal->toBool}>
      <RadixUI.Dialog.Portal>
        <RadixUI.Dialog.Overlay className=%twc("dialog-overlay") />
        children
      </RadixUI.Dialog.Portal>
    </RadixUI.Dialog.Root>
  }
}

module Label = {
  @react.component
  let make = (~text=``, ~required=false) => {
    <>
      <span> {text->React.string} </span>
      {switch required {
      | false => React.null
      | true => <span className=%twc("text-red-500")> {`*`->React.string} </span>
      }}
    </>
  }
}

module AddRfqProductForm = {
  @react.component
  let make = (~form, ~closeModal, ~isSubmitDisabled, ~submit) => {
    <RadixUI.Dialog.Content
      className=%twc("dialog-content-base bg-white w-[722px] p-5")
      onPointerDownOutside={_ => closeModal()}
      onOpenAutoFocus={ReactEvent.Synthetic.preventDefault}>
      <div className=%twc("text-text-L1")>
        <Modal.Header title={`견적 상품 추가`} closeModal />
        <div className=%twc("divide-y mt-7")>
          <section className=%twc("pt-5 pb-7")>
            <Label text={`표준 카테고리`} required=true />
            <Form.Category.Select form />
          </section>
          <section className=%twc("pt-5 pb-7 grid grid-cols-3 gap-4")>
            <div>
              <Label text={`중량 / 수량 / 용량`} required=true />
              <div className=%twc("mt-2 flex items-center")>
                <Form.Amount.Input form />
                <Form.AmountUnit.Select form className=%twc("ml-1") />
              </div>
            </div>
            <div>
              <Label text={`단위당 희망가`} required=true />
              <div className=%twc("mt-2 w-full flex items-center")>
                <Form.UnitPrice.Input form />
              </div>
            </div>
            <div>
              <Label text={`포장물 수량`} required=false />
              <div className=%twc("mt-2 flex items-center")>
                <Form.PackageAmount.Input form />
              </div>
            </div>
          </section>
          <section className=%twc("py-5 grid grid-cols-3 gap-x-4 gap-y-5")>
            <div>
              <Label text={`가공방식`} required=false />
              <div className=%twc("mt-2 flex items-center")>
                <Form.ProcessingMethod.Input form />
              </div>
            </div>
            <div>
              <Label text={`보관방식`} required=false />
              <div className=%twc("mt-2 w-full flex items-center")>
                <Form.StorageMethod.Select form />
              </div>
            </div>
            <div>
              <Label text={`희망 배송일`} required=false />
              <div className=%twc("mt-2 flex items-center")>
                <Form.RequestedDeliveredAt.DateInput form />
              </div>
            </div>
            <div>
              <Label text={`원산지`} required=false />
              <div className=%twc("mt-2 flex items-center")>
                <Form.Origin.Select form />
              </div>
            </div>
            <div>
              <Label text={`(축산)등급`} required=false />
              <div className=%twc("mt-2 flex items-center")>
                <Form.MeatGrade.Select form />
              </div>
            </div>
            <div>
              <Label text={`(축산)브랜드`} required=false />
              <div className=%twc("mt-2 flex items-center")>
                <Form.MeatBrand.Select form />
              </div>
            </div>
            <div>
              <Label text={`사용 용도`} required=false />
              <div className=%twc("mt-2 flex items-center")>
                <Form.Usage.Input form />
              </div>
            </div>
            <div>
              <Label text={`거래주기`} required=false />
              <div className=%twc("mt-2 flex items-center")>
                <Form.TradeCycle.Select form />
              </div>
            </div>
            <div>
              <Label text={`기존 납품가(kg)`} required=false />
              <div className=%twc("mt-2 flex items-center")>
                <Form.PreviousPrice.Input form />
              </div>
            </div>
            <section>
              <Form.IsCrossSelling.Checkbox form />
            </section>
          </section>
          <section className=%twc("py-5 grid grid-cols-2 gap-x-2")>
            <div>
              <Label text={`메모`} required=false />
              <div className=%twc("mt-2 flex items-center")>
                <Form.Memo.Input form />
              </div>
            </div>
            <div>
              <Label text={`판매입찰 메모`} required=false />
              <div className=%twc("mt-2 flex items-center")>
                <Form.Description.Input form />
              </div>
            </div>
          </section>
        </div>
        <div className=%twc("flex items-center justify-center")>
          <button
            type_="button"
            onClick={_ => closeModal()}
            className=%twc("px-3 py-[6px] text-[15px] bg-gray-100 rounded-lg")>
            {`닫기`->React.string}
          </button>
          <button
            type_="button"
            onClick={_ => submit()}
            disabled=isSubmitDisabled
            className=%twc(
              "ml-[10px] px-3 py-[6px] text-[15px] text-white rounded-lg bg-primary hover:bg-primary-variant"
            )>
            {`생성`->React.string}
          </button>
        </div>
      </div>
    </RadixUI.Dialog.Content>
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

let init: Form.t = {
  category: "",
  amount: "",
  amountUnit: "kg",
  meatBrandId: "",
  meatGradeId: "",
  memo: "",
  origin: "",
  packageAmount: "",
  previousPrice: "",
  processingMethod: "",
  requestedDeliveredAt: "",
  storageMethod: "",
  tradeCycle: "",
  unitPrice: "",
  usage: "",
  description: "",
  isCrossSelling: false,
}

@react.component
let make = (~rfqNodeId, ~connectionId) => {
  let (showModal, setShowModal) = React.Uncurried.useState(_ => Modal.Hide)
  let (createRfqProduct, isCreating) = Mutation.use()
  let showToast = Toast.use()

  let form = Form.FormHandler.use(
    ~config={
      defaultValues: init,
      mode: #onChange,
    },
  )

  let resetAndClose = () => {
    setShowModal(._ => Hide)
    form->Form.FormHandler.reset(init)
  }

  let submit = _ => {
    // trigger validation
    form->Form.FormHandler.trigger->ignore

    form
    ->Form.FormHandler.getValues
    ->Request.make(~rfqId=rfqNodeId, ~connections=[connectionId->RescriptRelay.makeDataId])
    ->Option.map(variables => {
      createRfqProduct(
        ~variables,
        ~onCompleted=({createRfqProduct}, _) => {
          switch createRfqProduct {
          | Some(#CreateRfqProductResult(_)) =>
            `견적이 등록되었습니다.`->showToast(Success)
            resetAndClose()

          | _ => `견적 등록에 실패하였습니다.`->showToast(Failure)
          }
        },
        ~onError={
          _ => `견적 등록에 실패하였습니다.`->showToast(Failure)
        },
        (),
      )
    })
    ->ignore
  }

  <>
    <button
      type_="button"
      onClick={_ => setShowModal(._ => Show)}
      className=%twc(
        "text-sm text-primary border-primary border rounded-lg px-3 py-2 hover:border-primary-variant hover:text-primary-variant"
      )>
      {`+ 상품 추가`->React.string}
    </button>
    <Modal showModal>
      <React.Suspense fallback={React.null}>
        <AddRfqProductForm form closeModal=resetAndClose isSubmitDisabled=isCreating submit />
      </React.Suspense>
    </Modal>
  </>
}
