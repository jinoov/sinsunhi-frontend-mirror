module Form = Add_RfqProduct_Form_Admin

module Fragment = %relay(`
  fragment EditRfqProductModalAdminFragment on RfqProduct {
    id
    number
    category {
      id
      fullyQualifiedName {
        name
      }
    }
    amount
    amountUnit
    unitPrice
    sellerPrice
    price
    deliveryFee
    deliveryMethod
    seller {
      name
    }
    status
    meatGrade {
      id
    }
    meatBrand {
      id
    }
    memo
    description
    origin
    packageAmount
    previousPrice
    processingMethod
    requestedDeliveredAt
    storageMethod
    tradeCycle
    usage
    isCrossSelling
  }
`)

module Mutation = %relay(`
  mutation EditRfqProductModalAdminMutation($input: [UpdateRfqProductsInput!]!) {
    updateRfqProducts(input: $input) {
      ... on UpdateRfqProductsResult {
        updatedRfqProducts {
          id
          number
          category {
            fullyQualifiedName {
              name
            }
          }
          amount
          amountUnit
          unitPrice
          sellerPrice
          price
          deliveryFee
          deliveryMethod
          seller {
            name
          }
          status
          meatGrade {
            id
          }
          meatBrand {
            id
          }
          memo
          description
          origin
          packageAmount
          previousPrice
          processingMethod
          requestedDeliveredAt
          storageMethod
          tradeCycle
          usage
          isCrossSelling
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
  type submit = {
    rfqId: string,
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
        rfqId,
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

  let make = (form: Form.t, ~rfqId): option<
    EditRfqProductModalAdminMutation_graphql.Types.variables,
  > => {
    switch form->parseVariables(~rfqId) {
    | Some(payload) =>
      let {
        amount,
        amountUnit,
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
        ~input=[
          {
            id: payload.rfqId,
            amount: Some(amount),
            amountUnit: Some(amountUnit),
            unitPrice: Some(unitPrice),
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
            usage,
            description,
            isCrossSelling,
            sellerId: None,
            deliveryFee: None,
            deliveryMethod: None,
            promotedProductId: None,
            sellerPrice: None,
            status: None,
            statusInfo: None,
          },
        ],
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
  let make = (~form, ~closeModal, ~isSubmitDisabled, ~title, ~submit, ~categoryId) => {
    <RadixUI.Dialog.Content
      className=%twc("dialog-content-base bg-white w-[722px] p-5")
      onPointerDownOutside={_ => closeModal()}
      onOpenAutoFocus={ReactEvent.Synthetic.preventDefault}>
      <div className=%twc("text-text-L1")>
        <Modal.Header title={`${title} 견적 상품 조회`} closeModal />
        <div className=%twc("divide-y mt-7")>
          <section className=%twc("pt-5 pb-7")>
            <Label text={`표준 카테고리`} required=true />
            <Form.Category.ReadOnly categoryId />
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
            <section className=%twc("flex items-center")>
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
            disabled=isSubmitDisabled
            onClick={_ => submit()}
            className=%twc(
              "ml-[10px] px-3 py-[6px] text-[15px] text-white rounded-lg bg-primary hover:bg-primary-variant"
            )>
            {`저장`->React.string}
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

@react.component
let make = (~query, ~rfqNodeId, ~showModal, ~setShowModal, ~title, ~softRefresh) => {
  let data = query->Fragment.use

  let (createRfqProduct, isCreating) = Mutation.use()
  let showToast = Toast.use()

  let init: Form.t = {
    category: data.category.id,
    amount: data.amount->Float.toString,
    amountUnit: data.amountUnit->Add_RfqProduct_Form_Admin.AmountUnit.toString,
    meatBrandId: data.meatBrand->Option.mapWithDefault("", ({id}) => id),
    meatGradeId: data.meatGrade->Option.mapWithDefault("", ({id}) => id),
    memo: data.memo->Option.getWithDefault(""),
    description: data.description->Option.getWithDefault(""),
    unitPrice: data.unitPrice->Int.toString,
    origin: data.origin->Option.mapWithDefault("", Add_RfqProduct_Form_Admin.Origin.toString),
    packageAmount: data.packageAmount->Option.mapWithDefault("", Int.toString),
    previousPrice: data.previousPrice->Option.mapWithDefault("", Int.toString),
    processingMethod: data.processingMethod->Option.getWithDefault(""),
    requestedDeliveredAt: data.requestedDeliveredAt->Option.getWithDefault(""),
    storageMethod: data.storageMethod->Option.mapWithDefault(
      "",
      Add_RfqProduct_Form_Admin.StorageMethod.toString,
    ),
    tradeCycle: data.tradeCycle->Option.mapWithDefault(
      "",
      Add_RfqProduct_Form_Admin.TradeCycle.toString,
    ),
    usage: data.usage->Option.getWithDefault(""),
    isCrossSelling: data.isCrossSelling,
  }

  let form = Form.FormHandler.use(
    ~config={
      defaultValues: init,
      mode: #onChange,
    },
  )

  let resetAndClose = () => {
    softRefresh()
    form->Form.FormHandler.reset(init)
    setShowModal(._ => Modal.Hide)
  }

  let submit = _ => {
    // trigger validation
    form->Form.FormHandler.trigger->ignore

    form
    ->Form.FormHandler.getValues
    ->Request.make(~rfqId=rfqNodeId)
    ->Option.map(variables => {
      createRfqProduct(
        ~variables,
        ~onCompleted=({updateRfqProducts}, _) => {
          switch updateRfqProducts {
          | Some(#UpdateRfqProductsResult(_)) =>
            `견적이 수정되었습니다.`->showToast(Success)
            resetAndClose()

          | _ => `견적 수정에 실패하였습니다.`->showToast(Failure)
          }
        },
        ~onError={
          _ => `견적 수정에 실패하였습니다.`->showToast(Failure)
        },
        (),
      )
    })
    ->ignore
  }

  <Modal showModal>
    <React.Suspense fallback={React.null}>
      <AddRfqProductForm
        form
        closeModal=resetAndClose
        isSubmitDisabled=isCreating
        title
        submit
        categoryId=data.category.id
      />
    </React.Suspense>
  </Modal>
}
