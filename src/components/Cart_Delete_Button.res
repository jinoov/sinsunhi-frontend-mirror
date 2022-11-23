module Form = Cart_Buyer_Form

module Mutation = %relay(`
  mutation CartDeleteButtonMutation($optionIds: [Int]!) {
    deleteCartItems(input: { productOptionIds: $optionIds }) {
      ... on DeleteCartItemsSuccess {
        count
      }
      ... on Error {
        message
      }
    }
  }
`)

module CartQuery = %relay(`
    query CartDeleteButtonCartQuery {
      cartItemCount
    }
  `)

module Dialog = {
  @react.component
  let make = (~show, ~setShow, ~n, ~confirmFn=ignore, ~cancelFn=ignore) => {
    <RadixUI.Dialog.Root _open=show>
      <RadixUI.Dialog.Portal>
        <RadixUI.Dialog.Overlay className=%twc("dialog-overlay") />
        <RadixUI.Dialog.Content
          onOpenAutoFocus={ReactEvent.Synthetic.preventDefault}
          className=%twc(
            "dialog-content p-7 bg-white rounded-xl w-[480px] flex flex-col gap-7 items-center justify-center"
          )>
          <span className=%twc("whitespace-pre text-center text-text-L1 pt-3")>
            {`선택하신 상품 ${n->Int.toString}개를
장바구니에서 삭제하시겠어요?`->React.string}
          </span>
          <div className=%twc("flex w-full justify-center items-center gap-2")>
            <button
              className=%twc("w-1/2 rounded-xl h-13 bg-enabled-L5")
              onClick={ReactEvents.interceptingHandler(_ => {
                setShow(._ => false)
                cancelFn()
              })}>
              {`취소`->React.string}
            </button>
            <button
              className=%twc("w-1/2 rounded-xl h-13 bg-red-100 text-notice font-bold")
              onClick={ReactEvents.interceptingHandler(_ => {
                confirmFn()
                setShow(._ => false)
              })}>
              {`삭제`->React.string}
            </button>
          </div>
        </RadixUI.Dialog.Content>
      </RadixUI.Dialog.Portal>
    </RadixUI.Dialog.Root>
  }
}

module NoSelectDialog = {
  @react.component
  let make = (~show, ~setShow) => {
    <RadixUI.Dialog.Root _open=show>
      <RadixUI.Dialog.Portal>
        <RadixUI.Dialog.Overlay className=%twc("dialog-overlay") />
        <RadixUI.Dialog.Content
          onOpenAutoFocus={ReactEvent.Synthetic.preventDefault}
          className=%twc(
            "dialog-content p-7 bg-white rounded-xl w-[480px] flex flex-col gap-7 items-center justify-center"
          )>
          <span className=%twc("whitespace-pre text-center text-text-L1 pt-3")>
            {`삭제하실 상품을 선택해주세요`->React.string}
          </span>
          <div className=%twc("flex w-full justify-center items-center gap-2")>
            <button
              className=%twc("w-1/2 rounded-xl h-13 bg-enabled-L5")
              onClick={ReactEvents.interceptingHandler(_ => {
                setShow(._ => false)
              })}>
              {`확인`->React.string}
            </button>
          </div>
        </RadixUI.Dialog.Content>
      </RadixUI.Dialog.Portal>
    </RadixUI.Dialog.Root>
  }
}

@react.component
let make = (
  ~productOptions: Form.productOptions,
  ~refetchCart,
  ~width="1rem",
  ~height="1rem",
  ~fill="#727272",
  ~children=React.null,
  ~isIcon=true,
) => {
  let {addToast} = ReactToastNotifications.useToasts()
  let (show, setShow) = React.Uncurried.useState(_ => false)
  let (showNoSelect, setShowNoSelect) = React.Uncurried.useState(_ => false)

  let handleError = (~message=?, ()) => {
    addToast(.
      <div className=%twc("flex items-center w-full whitespace-pre-wrap")>
        <IconError height="24" width="24" className=%twc("mr-2") />
        {j`상품 삭제에 실패하였습니다. ${message->Option.getWithDefault(
            "",
          )}`->React.string}
      </div>,
      {appearance: "error"},
    )
  }

  let (mutate, _) = Mutation.use()
  let (_, refreshCount, _) = CartQuery.useLoader()

  let confirmFn = () => {
    switch productOptions {
    | [] => handleError(~message=`삭제할 상품을 선택해주세요.`, ())
    | _ =>
      mutate(
        ~variables={
          optionIds: {productOptions->Array.map(option => Some(option.productOptionId))},
        },
        ~onCompleted={
          ({deleteCartItems}, _) =>
            switch deleteCartItems {
            | #DeleteCartItemsSuccess({count}) =>
              addToast(.
                <div className=%twc("flex items-center")>
                  <IconCheck height="24" width="24" fill="#12B564" className=%twc("mr-2") />
                  {j`${count->Int.toString}개의 상품이 장바구니에서 삭제되었습니다.`->React.string}
                </div>,
                {appearance: "success"},
              )
              refreshCount(~variables=(), ~fetchPolicy=RescriptRelay.StoreAndNetwork, ())
              refetchCart()
            | #Error(err) => handleError(~message=err.message->Option.getWithDefault(""), ())
            | _ => handleError()
            }
        },
        ~onError=err => handleError(~message=err.message, ()),
        (),
      )->ignore
    }
  }

  <>
    <Dialog show setShow confirmFn n={productOptions->Array.length} />
    <NoSelectDialog show=showNoSelect setShow=setShowNoSelect />
    <button
      className=%twc("self-baseline mt-1")
      onClick={ReactEvents.interceptingHandler(_ =>
        switch productOptions {
        | [] => setShowNoSelect(._ => true)
        | _ => setShow(._ => true)
        }
      )}>
      {switch isIcon {
      | true => <IconClose height width fill />
      | false => children
      }}
    </button>
  </>
}
