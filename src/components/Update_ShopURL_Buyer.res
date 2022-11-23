open RadixUI

module Mutation = %relay(`
  mutation UpdateShopURLBuyer_Mutation($input: UpdateUserInput!) {
    updateUser(input: $input) {
      ... on User {
        ...MyInfoAccountBuyer_Fragment
        ...MyInfoProfileSummaryBuyer_Fragment
        ...MyInfoProfileCompleteBuyer_Fragment
        shopUrl
      }
      ... on Error {
        message
      }
    }
  }
`)

let formatValidator: ValidatedState.validator<string> = (url: string) => {
  let exp = %re(
    "/[(http(s)?):\/\/(www\.)?a-zA-Z0-9@:%._\+~#=]{2,256}\.[a-z]{2,6}\b([-a-zA-Z0-9@:%_\+.~#?&//=]*)/ig"
  )
  switch exp->Js.Re.test_(url) {
  | true => Result.Ok(url)
  | false =>
    Result.Error({
      type_: "format",
      message: `sinsunhi.com 과 같은 형식으로 입력해주세요.`,
    })
  }
}

@react.component
let make = (~isOpen, ~onClose, ~defaultValue="") => {
  let (shopUrl, setShopUrl, state) = ValidatedState.use(
    ValidatedState.String,
    defaultValue,
    ~validators=[formatValidator],
  )

  let (mutate, mutating) = Mutation.use()
  let {addToast} = ReactToastNotifications.useToasts()

  let reset = () => {
    setShopUrl(defaultValue, ())
  }

  let handleOnChange = e => {
    let value = (e->ReactEvent.Synthetic.target)["value"]

    setShopUrl(value, ~shouldValidate=true, ())
  }

  let handleOnSubmit = (
    _ => {
      mutate(
        ~variables={
          input: Mutation.make_updateUserInput(~shopUrl, ()),
        },
        ~onCompleted=({updateUser}, _) => {
          switch updateUser {
          | #User(_) => {
              addToast(.
                <div className=%twc("flex items-center")>
                  <IconCheck height="24" width="24" fill="#12B564" className=%twc("mr-2") />
                  {j`쇼핑몰URL이 저장되었습니다.`->React.string}
                </div>,
                {appearance: "success"},
              )

              onClose()
            }

          | #Error(err) =>
            addToast(.
              <div className=%twc("flex items-center")>
                <IconError height="24" width="24" className=%twc("mr-2") />
                {j`오류가 발생하였습니다. 쇼핑몰URL을 확인하세요.`->React.string}
                {err.message->Option.getWithDefault("")->React.string}
              </div>,
              {appearance: "error"},
            )
          | #UnselectedUnionMember(_) =>
            addToast(.
              <div className=%twc("flex items-center")>
                <IconError height="24" width="24" className=%twc("mr-2") />
                {j`오류가 발생하였습니다. 쇼핑몰URL 확인하세요.`->React.string}
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
                {j`오류가 발생하였습니다. 쇼핑몰URL을 확인하세요.`->React.string}
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

  let disabled = shopUrl == "" || state.error->Option.isSome || mutating

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
      )>
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
                {`쇼핑몰URL 수정`->React.string}
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
                  <label className=%twc("font-bold")> {`쇼핑몰 URL`->React.string} </label>
                </div>
                <Input
                  type_="text"
                  name="shop-url"
                  size=Input.Large
                  value={shopUrl}
                  placeholder={`https://sinsunhi.com`}
                  onChange={handleOnChange}
                  error={state.error->Option.map(({message}) => message)}
                />
              </div>
              <button
                type_="submit"
                className={cx([
                  %twc("rounded-xl w-full py-4"),
                  disabled ? %twc("bg-disabled-L2") : %twc("bg-green-500"),
                ])}
                disabled>
                <span className=%twc("text-white")> {`저장`->React.string} </span>
              </button>
            </div>
          </form>
        </section>
      </div>
    </Dialog.Content>
  </Dialog.Root>
}
