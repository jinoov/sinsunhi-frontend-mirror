module AddRfqForm = Add_Rfq_Form_Admin
module AddRfqProductForm = Add_RfqProduct_Form_Admin

module Mutation = %relay(`
  mutation AddRfqButtonAdminMutation($input: CreateRfqInput!) {
    createRfq(input: $input) {
      ... on CreateRfqResult {
        createdRfq {
          id
        }
      }
  
      ... on Error {
        message
      }
    }
  }
`)

module RequestParser = {
  let filterEmptyString = s => s != "" ? Some(s) : None
  let makeIsoDate = s => {
    s->filterEmptyString->Option.map(Js.Date.fromString)->Option.map(Js.Date.toISOString)
  }

  module Rfq = {
    type t = {
      buyerId: string,
      requestedFrom: AddRfqForm.RequestedFrom.value,
      address: option<string>,
    }

    let make = (form: AddRfqForm.t) => {
      switch (
        form.buyerId,
        form.requestedFrom->AddRfqForm.RequestedFrom.toValue,
        form.address->filterEmptyString,
      ) {
      | (buyerId, Some(requestedFrom), address) =>
        Some({
          buyerId,
          requestedFrom,
          address,
        })
      | _ => None
      }
    }
  }

  module RfqProduct = {
    type t = {
      amount: float,
      amountUnit: AddRfqProductForm.AmountUnit.t,
      categoryId: string,
      meatBrandId: option<string>,
      meatGradeId: option<string>,
      memo: option<string>,
      origin: option<AddRfqProductForm.Origin.t>,
      packageAmount: option<int>,
      previousPrice: option<int>,
      processingMethod: option<string>,
      requestedDeliveredAt: option<string>, // iso date string
      rfqId: option<string>,
      storageMethod: option<AddRfqProductForm.StorageMethod.t>,
      tradeCycle: option<AddRfqProductForm.TradeCycle.t>,
      unitPrice: int,
      usage: option<string>,
      description: option<string>,
      isCrossSelling: option<bool>,
    }

    let make = (form: AddRfqProductForm.t) => {
      switch (
        form.amount->Float.fromString,
        form.amountUnit->AddRfqProductForm.AmountUnit.toValue,
        form.category->filterEmptyString,
        form.meatBrandId->filterEmptyString,
        form.meatGradeId->filterEmptyString,
        form.memo->filterEmptyString,
        form.origin->AddRfqProductForm.Origin.toValue,
        form.packageAmount->Int.fromString,
        form.previousPrice->Int.fromString,
        form.processingMethod->filterEmptyString,
        form.requestedDeliveredAt->filterEmptyString->Option.flatMap(makeIsoDate),
        form.storageMethod->AddRfqProductForm.StorageMethod.toValue,
        form.tradeCycle->AddRfqProductForm.TradeCycle.toValue,
        form.unitPrice->Int.fromString,
        form.usage->filterEmptyString,
        form.description->filterEmptyString,
        form.isCrossSelling,
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
          description,
          isCrossSelling,
        ) =>
        Some({
          rfqId: None, // 현 지점에선 rfq + rfqProduct를 동시에 생성하기때문에 rfqId가 없다.
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
          isCrossSelling: Some(isCrossSelling),
        })
      | _ => None
      }
    }
  }

  let makeVariables = (~rfq: AddRfqForm.t, ~rfqProduct: AddRfqProductForm.t) => {
    switch (rfq->Rfq.make, rfqProduct->RfqProduct.make) {
    | (
        Some({buyerId, requestedFrom, address}),
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
          description,
          isCrossSelling,
        }),
      ) =>
      Mutation.makeVariables(
        ~input={
          buyerId,
          requestedFrom,
          address,
          rfqProduct: {
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
            description,
            isCrossSelling,
          },
        },
      )->Some
    | _ => None
    }
  }
}

module Toast = {
  type appearance =
    | Success
    | Warning
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

      | Warning =>
        addToast(.
          <div className=%twc("flex items-center")>
            <IconWarning height="24" width="24" className=%twc("mr-2") />
            {message->React.string}
          </div>,
          {appearance: "warning"},
        )
      }
    }
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

module ModalHeader = {
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

module ActionButtons = {
  @react.component
  let make = (~className=%twc(""), ~closeModal, ~submitText=`다음`) => {
    <div className={cx([%twc("flex items-center justify-center"), className])}>
      <button
        onClick={_ => closeModal()}
        className=%twc("px-3 py-[6px] text-[15px] bg-gray-100 rounded-lg")>
        {`닫기`->React.string}
      </button>
      <button
        type_="submit"
        className=%twc(
          "ml-[10px] px-3 py-[6px] text-[15px] text-white rounded-lg bg-primary hover:bg-primary-variant"
        )>
        {submitText->React.string}
      </button>
    </div>
  }
}

module AddRfq = {
  module InputWrapper = {
    @react.component
    let make = (~label, ~children) => {
      <div className=%twc("mt-7")>
        <span> {label->React.string} </span>
        <div className=%twc("mt-2")> children </div>
      </div>
    }
  }

  @react.component
  let make = (~form, ~closeModal) => {
    <RadixUI.Dialog.Content
      className=%twc("dialog-content-base bg-white w-[360px] p-5")
      onPointerDownOutside={_ => closeModal()}
      onOpenAutoFocus={ReactEvent.Synthetic.preventDefault}>
      <div className=%twc("text-text-L1")>
        <ModalHeader title={`견적 등록`} closeModal />
        <div className=%twc("mt-7")>
          <Label text={`신청구분`} />
          <div className=%twc("mt-2")>
            <AddRfqForm.RequestType.Select form disabled=true />
          </div>
        </div>
        <div className=%twc("mt-7")>
          <Label text={`유입경로`} required=true />
          <div className=%twc("mt-2")>
            <AddRfqForm.RequestedFrom.Select form />
          </div>
        </div>
        <div className=%twc("mt-7")>
          <Label text={`바이어 정보`} required=true />
          <div className=%twc("mt-2")>
            <AddRfqForm.BuyerId.Search form />
          </div>
        </div>
        <div className=%twc("mt-7")>
          <Label text={`배송지`} required=false />
          <div className=%twc("mt-2")>
            <AddRfqForm.Address.Input form />
          </div>
        </div>
        <ActionButtons className=%twc("mt-8") closeModal />
      </div>
    </RadixUI.Dialog.Content>
  }
}

module AddRfqProduct = {
  @react.component
  let make = (~form, ~closeModal) => {
    <RadixUI.Dialog.Content
      className=%twc("dialog-content-base bg-white w-[722px] p-5")
      onPointerDownOutside={_ => closeModal()}
      onOpenAutoFocus={ReactEvent.Synthetic.preventDefault}>
      <div className=%twc("text-text-L1")>
        <ModalHeader title={`견적 상품 추가`} closeModal />
        <div className=%twc("divide-y mt-7")>
          <section className=%twc("pt-5 pb-7")>
            <Label text={`표준 카테고리`} required=true />
            <AddRfqProductForm.Category.Select form />
          </section>
          <section className=%twc("pt-5 pb-7 grid grid-cols-3 gap-4")>
            <div>
              <Label text={`중량 / 수량 / 용량`} required=true />
              <div className=%twc("mt-2 flex items-center")>
                <AddRfqProductForm.Amount.Input form />
                <AddRfqProductForm.AmountUnit.Select form className=%twc("ml-1") />
              </div>
            </div>
            <div>
              <Label text={`단위당 희망가`} required=true />
              <div className=%twc("mt-2 w-full flex items-center")>
                <AddRfqProductForm.UnitPrice.Input form />
              </div>
            </div>
            <div>
              <Label text={`포장물 수량`} required=false />
              <div className=%twc("mt-2 flex items-center")>
                <AddRfqProductForm.PackageAmount.Input form />
              </div>
            </div>
          </section>
          <section className=%twc("py-5 grid grid-cols-3 gap-x-4 gap-y-5")>
            <div>
              <Label text={`가공방식`} required=false />
              <div className=%twc("mt-2 flex items-center")>
                <AddRfqProductForm.ProcessingMethod.Input form />
              </div>
            </div>
            <div>
              <Label text={`보관방식`} required=false />
              <div className=%twc("mt-2 w-full flex items-center")>
                <AddRfqProductForm.StorageMethod.Select form />
              </div>
            </div>
            <div>
              <Label text={`희망 배송일`} required=false />
              <div className=%twc("mt-2 flex items-center")>
                <AddRfqProductForm.RequestedDeliveredAt.DateInput form />
              </div>
            </div>
            <div>
              <Label text={`원산지`} required=false />
              <div className=%twc("mt-2 flex items-center")>
                <AddRfqProductForm.Origin.Select form />
              </div>
            </div>
            <div>
              <Label text={`(축산)등급`} required=false />
              <div className=%twc("mt-2 flex items-center")>
                <AddRfqProductForm.MeatGrade.Select form />
              </div>
            </div>
            <div>
              <Label text={`(축산)브랜드`} required=false />
              <div className=%twc("mt-2 flex items-center")>
                <AddRfqProductForm.MeatBrand.Select form />
              </div>
            </div>
            <div>
              <Label text={`사용 용도`} required=false />
              <div className=%twc("mt-2 flex items-center")>
                <AddRfqProductForm.Usage.Input form />
              </div>
            </div>
            <div>
              <Label text={`거래주기`} required=false />
              <div className=%twc("mt-2 flex items-center")>
                <AddRfqProductForm.TradeCycle.Select form />
              </div>
            </div>
            <div>
              <Label text={`기존 납품가(kg)`} required=false />
              <div className=%twc("mt-2 flex items-center")>
                <AddRfqProductForm.PreviousPrice.Input form />
              </div>
            </div>
            <section>
              <AddRfqProductForm.IsCrossSelling.Checkbox form />
            </section>
          </section>
          <section className=%twc("py-5 grid grid-cols-2 gap-x-2")>
            <div>
              <Label text={`메모`} required=false />
              <div className=%twc("mt-2 flex items-center")>
                <AddRfqProductForm.Memo.Input form />
              </div>
            </div>
            <div>
              <Label text={`판매입찰 메모`} required=false />
              <div className=%twc("mt-2 flex items-center")>
                <AddRfqProductForm.Description.Input form />
              </div>
            </div>
          </section>
        </div>
        <ActionButtons className=%twc("mt-1") closeModal submitText={`생성`} />
      </div>
    </RadixUI.Dialog.Content>
  }
}

module AddRfqModal = {
  // 견적을 만들고 나서, 해당 견적의 견적상품을 만듬
  type step =
    | Rfq // 견적 폼
    | RfqProduct(AddRfqForm.t) // 견적상품 폼

  let rfqInit: AddRfqForm.t = {
    requestType: #Purchase,
    requestedFrom: "",
    buyerId: "",
    address: "",
  }

  let rfqProductInit: AddRfqProductForm.t = {
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
  let make = (~showModal, ~setShowModal) => {
    let (step, setStep) = React.Uncurried.useState(_ => Rfq)
    let (createRfq, _isCreatingRfq) = Mutation.use()
    let showToast = Toast.use()

    let rfqForm = AddRfqForm.FormHandler.use(
      ~config={
        defaultValues: rfqInit,
        mode: #onChange,
      },
    )

    let rfqProductForm = AddRfqProductForm.FormHandler.use(
      ~config={
        defaultValues: rfqProductInit,
        mode: #onChange,
      },
    )

    let reset = () => {
      setStep(._ => Rfq)
      rfqForm->AddRfqForm.FormHandler.reset(rfqInit)
      rfqProductForm->AddRfqProductForm.FormHandler.reset(rfqProductInit)
    }

    let closeModal = () => {
      setShowModal(._ => Modal.Hide)
      reset()
      switch step {
      | Rfq => ()
      | RfqProduct(_) => `견적 등록이 취소되었습니다.`->showToast(Warning)
      }
    }

    let next = rfqForm->AddRfqForm.FormHandler.handleSubmit((data, _) => {
      setStep(._ => RfqProduct(data))
    })

    let makeSubmit = rfq => {
      rfqProductForm->AddRfqProductForm.FormHandler.handleSubmit((rfqProduct, _) => {
        RequestParser.makeVariables(~rfq, ~rfqProduct)
        ->Option.map(variables' => {
          createRfq(
            ~variables=variables',
            ~onCompleted=({createRfq}, _) => {
              switch createRfq {
              | Some(#CreateRfqResult(_)) => {
                  `견적이 등록되었습니다.`->showToast(Success)
                  Redirect.setHref("/admin/matching/purchases")
                }

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
      })
    }

    <Modal showModal>
      <React.Suspense fallback={React.null}>
        {switch step {
        | Rfq =>
          <form onSubmit=next>
            <AddRfq form=rfqForm closeModal />
          </form>

        | RfqProduct(rfq) =>
          <form onSubmit={makeSubmit(rfq)}>
            <AddRfqProduct form=rfqProductForm closeModal />
          </form>
        }}
      </React.Suspense>
    </Modal>
  }
}

@react.component
let make = () => {
  let (showModal, setShowModal) = React.Uncurried.useState(_ => Modal.Hide)

  <>
    <button
      onClick={_ => setShowModal(._ => Show)}
      className=%twc(
        "h-9 text-sm text-primary border-primary border rounded-lg px-3 hover:border-primary-variant hover:text-primary-variant"
      )>
      {`+ 견적 거래 등록`->React.string}
    </button>
    <AddRfqModal showModal setShowModal />
  </>
}
