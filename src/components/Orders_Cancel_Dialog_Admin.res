module Mutation = %relay(`
  mutation OrdersCancelDialogAdmin_Mutation(
    $input: CancelWosOrderProductOptionInput!
  ) {
    cancelWosOrderProductOption(input: $input) {
      ... on CancelWosOrderProductOptionResult {
        successProductOptionCount
      }
      ... on Error {
        message
      }
    }
  }
`)

let toString = r =>
  switch r {
  | #DELIVERY_NOT_POSSIBLE => "배송불가"
  | #DELIVERY_ACCIDENT => "배송사고"
  | #DELIVERY_DELAY => "배송지연"
  | #CHANGED_MIND => "단순변심"
  | #PRODUCT_SOLDOUT => "상품품절"
  | #DUPLICATED_ORDER => "중복주문"
  | #ETC => "기타"
  }

module Scroll = {
  @react.component
  let make = (~children) => {
    open RadixUI.ScrollArea
    <Root className=%twc("max-h-[400px] flex flex-col overflow-hidden w-full")>
      <Viewport className=%twc("w-full h-full")> {children} </Viewport>
      <Scrollbar>
        <Thumb />
      </Scrollbar>
    </Root>
  }
}

module Item = {
  @react.component
  let make = (~reason, ~setReason) => {
    open RadixUI
    <DropDown.Item className=%twc("focus:outline-none w-80")>
      <div
        onClick={_ => setReason(._ => Some(reason))}
        className=%twc("rounded-lg py-3 px-2 hover:bg-gray-100 w-full")>
        <span className=%twc("text-gray-800 w-full")>
          <span className=%twc("w-full")> {reason->toString->React.string} </span>
        </span>
      </div>
    </DropDown.Item>
  }
}

@react.component
let make = (~isShowCancelConfirm, ~setShowCancelConfirm, ~selectedOrders, ~confirmFn) => {
  let {addToast} = ReactToastNotifications.useToasts()

  let (reason, setReason) = React.Uncurried.useState(_ => None)
  let (reasonDetail, setReasonDetail) = React.Uncurried.useState(_ => None)

  let (mutate, _) = Mutation.use()

  let reset = () => {
    setShowCancelConfirm(._ => Dialog.Hide)
    setReason(._ => None)
    setReasonDetail(._ => None)
  }

  let handleError = message =>
    addToast(.
      <div className=%twc("flex items-center")>
        <IconError height="24" width="24" className=%twc("mr-2") />
        {message->React.string}
      </div>,
      {appearance: "error"},
    )

  let onSuccess = () => {
    confirmFn()
    reset()
    addToast(.
      <div className=%twc("flex items-center")>
        <IconCheck height="24" width="24" fill="#12B564" className=%twc("mr-2") />
        {"주문이 취소되었습니다."->React.string}
      </div>,
      {appearance: "success"},
    )
  }

  let onConfirm = () => {
    switch reason {
    | None => handleError("주문취소사유를 선택해주세요.")
    | Some(_) =>
      mutate(
        ~variables={
          input: {
            detailReason: reasonDetail,
            idsToCancel: {selectedOrders},
            reason,
          },
        },
        ~onCompleted=({cancelWosOrderProductOption}, _) => {
          switch cancelWosOrderProductOption {
          | Some(#CancelWosOrderProductOptionResult(_)) => onSuccess()
          | Some(#Error({message})) =>
            handleError(message->Option.getWithDefault("주문 취소에 실패하였습니다."))
          | _ => handleError("주문 취소에 실패하였습니다.")
          }
        },
        ~onError={err => handleError(err.message)},
        (),
      )->ignore
    }
  }

  <Dialog
    isShow=isShowCancelConfirm
    textOnCancel={"닫기"}
    onCancel={_ => reset()}
    textOnConfirm={"취소 완료하기"}
    onConfirm={_ => onConfirm()}>
    <div className=%twc("text-black-gl text-center whitespace-pre-wrap w-full")>
      <div className=%twc("flex justify-between items-center")>
        <span className=%twc("text-text-L1 font-bold text-xl")>
          {"주문 취소"->React.string}
        </span>
        <button type_="button" onClick={_ => reset()}>
          <IconClose width="24" height="24" fill="#1F2024" />
        </button>
      </div>
      <div className=%twc("mt-7 flex justify-between items-center")>
        <span className=%twc("text-text-L1 text-sm")> {"취소할 주문 수"->React.string} </span>
        <span className=%twc("text-text-L1 text-sm font-bold")>
          {`${selectedOrders->Array.length->Int.toString}개 선택됨`->React.string}
        </span>
      </div>
      <div className=%twc("my-5 bg-[#EDEFF2] h-px w-full") />
      <div className=%twc("flex w-full flex-col gap-2 items-start")>
        <span className=%twc("text-text-L1 text-sm")> {"취소사유(필수)"->React.string} </span>
        <div className=%twc("w-full")>
          <RadixUI.DropDown.Root>
            <RadixUI.DropDown.Trigger className=%twc("focus:outline-none w-full")>
              <div
                className=%twc(
                  "w-full h-13 p-3 flex items-center justify-between border rounded-xl"
                )>
                <span className=%twc("text-gray-600")>
                  {reason->Option.mapWithDefault("선택해주세요", toString)->React.string}
                </span>
                <IconArrowSelect height="20" width="20" fill="#121212" />
              </div>
            </RadixUI.DropDown.Trigger>
            <RadixUI.DropDown.Content
              align=#start sideOffset=4 className=%twc("bg-white border rounded-lg shadow-md p-1")>
              <Scroll>
                {[
                  #DELIVERY_NOT_POSSIBLE,
                  #DELIVERY_ACCIDENT,
                  #DELIVERY_DELAY,
                  #CHANGED_MIND,
                  #PRODUCT_SOLDOUT,
                  #DUPLICATED_ORDER,
                  #ETC,
                ]
                ->Array.map(reason => <Item reason key={reason->toString} setReason />)
                ->React.array}
              </Scroll>
            </RadixUI.DropDown.Content>
          </RadixUI.DropDown.Root>
        </div>
        <div className=%twc("mt-5 flex flex-col gap-2 items-start w-full")>
          <span className=%twc("text-text-L1 text-sm")>
            {"취소상세사유(선택)"->React.string}
          </span>
          <textarea
            placeholder={"취소상세사유를 입력하실 수 있습니다."}
            value={reasonDetail->Option.getWithDefault("")}
            maxLength={1000}
            onChange={e => setReasonDetail(._ => (e->ReactEvent.Synthetic.target)["value"])}
            className=%twc("p-3 w-full border border-border-default-L1 rounded-lg")
          />
          <span className=%twc("text-[#8B8D94] text-sm text-left")>
            {"*주문 취소 완료 후에는 취소사유, 취소상세사유가 변경되지 않습니다."->React.string}
          </span>
        </div>
      </div>
    </div>
  </Dialog>
}
