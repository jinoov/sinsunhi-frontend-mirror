open RadixUI

module Mutation = %relay(`
  mutation UpdateCompanyNameBuyer_Mutation($input: UpdateUserInput!) {
    updateUser(input: $input) {
      ... on User {
        ...MyInfoAccountBuyer_Fragment
        ...MyInfoProfileSummaryBuyer_Fragment
        ...MyInfoProfileCompleteBuyer_Fragment
      }
      ... on Error {
        message
      }
    }
  }
`)

@react.component
let make = (~isOpen, ~onClose, ~defaultValue="") => {
  let (compnay, setCompany, _) = ValidatedState.use(
    ValidatedState.String,
    defaultValue,
    ~validators=[],
  )

  let (mutate, mutating) = Mutation.use()
  let {addToast} = ReactToastNotifications.useToasts()

  let reset = () => {
    setCompany(defaultValue, ())
  }

  let handleOnChange = e => {
    let value = (e->ReactEvent.Synthetic.target)["value"]

    setCompany(value, ~shouldValidate=true, ())
  }

  let handleOnSubmit = (
    _ => {
      mutate(
        ~variables={
          input: Mutation.make_updateUserInput(~name=compnay, ()),
        },
        ~onCompleted=({updateUser}, _) => {
          switch updateUser {
          | #User(_) => {
              addToast(.
                <div className=%twc("flex items-center")>
                  <IconCheck height="24" width="24" fill="#12B564" className=%twc("mr-2") />
                  {j`회사명이 저장되었습니다.`->React.string}
                </div>,
                {appearance: "success"},
              )

              onClose()
            }

          | #Error(err) =>
            addToast(.
              <div className=%twc("flex items-center")>
                <IconError height="24" width="24" className=%twc("mr-2") />
                {j`오류가 발생하였습니다. 회사명를 확인하세요.`->React.string}
                {err.message->Option.getWithDefault("")->React.string}
              </div>,
              {appearance: "error"},
            )
          | #UnselectedUnionMember(_) =>
            addToast(.
              <div className=%twc("flex items-center")>
                <IconError height="24" width="24" className=%twc("mr-2") />
                {j`오류가 발생하였습니다. 회사명를 확인하세요.`->React.string}
              </div>,
              {appearance: "error"},
            )
          }
        },
        ~onError={
          err => {
            addToast(.
              <div className=%twc("flex items-center")>
                <IconError height="24" width="24" className=%twc("mr-2") />
                {j`오류가 발생하였습니다. 회사명를 확인하세요.`->React.string}
                {err.message->React.string}
              </div>,
              {appearance: "error"},
            )
          }
        },
        (),
      )->ignore
    }
  )->ReactEvents.interceptingHandler

  // mobile 에서 뒤로가기로 닫혔을 때, 상태초기화
  React.useEffect1(_ => {
    if !isOpen {
      reset()
    }
    None
  }, [isOpen])

  <Dialog.Root _open={isOpen}>
    <Dialog.Overlay className=%twc("dialog-overlay") />
    <Dialog.Content
      className=%twc(
        "dialog-content-plain bottom-0 left-0 xl:bottom-auto xl:left-auto xl:rounded-2xl xl:state-open:top-1/2 xl:state-open:left-1/2 xl:state-open:-translate-x-1/2 xl:state-open:-translate-y-1/2"
      )
      onOpenAutoFocus={ReactEvent.Synthetic.preventDefault}>
      <div
        className=%twc(
          "fixed top-0 left-0 h-full xl:static bg-white w-full max-w-3xl xl:min-h-fit xl:min-w-min xl:w-[90vh] xl:max-w-[480px] xl:max-h-[85vh] "
        )>
        <section className=%twc("h-14 w-full xl:h-auto xl:w-auto xl:mt-10")>
          <div
            className=%twc(
              "flex items-center justify-between px-5 w-full py-4 xl:h-14 xl:w-full xl:pb-10"
            )>
            <div className=%twc("w-6 xl:hidden") />
            <div>
              <span className=%twc("font-bold xl:text-2xl")>
                {`회사명 수정`->React.string}
              </span>
            </div>
            <Dialog.Close className=%twc("focus:outline-none") onClick={_ => onClose()}>
              <IconClose height="24" width="24" fill="#262626" />
            </Dialog.Close>
          </div>
        </section>
        <section className=%twc("pt-12 xl:pt-3 mb-6 px-4")>
          <form onSubmit={handleOnSubmit}>
            <div className=%twc("flex flex-col ")>
              <div className=%twc("flex flex-col mb-10")>
                <div className=%twc("mb-2")>
                  <label className=%twc("font-bold")> {`회사명`->React.string} </label>
                </div>
                <input
                  value={compnay}
                  placeholder={`회사명을 입력해 주세요`}
                  onChange={handleOnChange}
                  className=%twc(
                    "w-full border border-border-default-L1 p-3 rounded-xl focus:outline-none"
                  )
                />
              </div>
              <button
                type_="submit"
                className={cx([
                  %twc("rounded-xl w-full py-4"),
                  compnay == "" ? %twc("bg-disabled-L2") : %twc("bg-green-500"),
                ])}
                disabled={compnay == "" || mutating}>
                <span className=%twc("text-white")> {`저장`->React.string} </span>
              </button>
            </div>
          </form>
        </section>
      </div>
    </Dialog.Content>
  </Dialog.Root>
}
