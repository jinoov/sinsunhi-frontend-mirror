open RadixUI

module Mutation = %relay(`
  mutation UpdateBusinessNumberBuyer_Mutation($input: UpdateUserInput!) {
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

@spice
type message = | @spice.as("VALID") VALID

@spice
type response = {message: message}

let formatValidator: ValidatedState.validator<string> = (businessNumber: string) => {
  let exp = Js.Re.fromString("^\\d{3}-\\d{2}-\\d{5}$")
  switch exp->Js.Re.test_(businessNumber) {
  | true => Result.Ok(businessNumber)
  | false =>
    Result.Error({
      type_: "format",
      message: `사업자 등록번호 형식을 확인해주세요.`,
    })
  }
}

@react.component
let make = (~isOpen, ~onClose, ~defaultValue="") => {
  let {addToast} = ReactToastNotifications.useToasts()
  let (businessNumber, setBusinessNumber, state) = ValidatedState.use(
    ValidatedState.String,
    defaultValue,
    ~validators=[formatValidator],
  )

  let (mutate, _) = Mutation.use()

  let (isVerifying, setIsVerifying) = React.Uncurried.useState(_ => false)

  let handleOnChangeBusinessNumber = e => {
    let newValue =
      (e->ReactEvent.Synthetic.currentTarget)["value"]
      ->Js.String2.replaceByRe(%re("/[^\d]/g"), "")
      ->Js.String2.replaceByRe(%re("/(^\d{3})(\d+)?(\d{5})$/"), "$1-$2-$3")
      ->Js.String2.replace("--", "-")

    setBusinessNumber(newValue, ~shouldValidate=true, ())
  }

  let reset = _ => {
    setBusinessNumber("", ())
    setIsVerifying(._ => false)
  }

  let handleOnClickVerify = (
    _ => {
      setIsVerifying(._ => true)
      let bNo =
        businessNumber->Garter.String.replaceByRe(Js.Re.fromStringWithFlags("\-", ~flags="g"), "")

      let queryStr =
        list{("b-no", bNo)}
        ->Js.Dict.fromList
        ->Webapi.Url.URLSearchParams.makeWithDict
        ->Webapi.Url.URLSearchParams.toString

      FetchHelper.get(
        ~url=`${Env.restApiUrl}/user/validate-business-number?${queryStr}`,
        ~onSuccess={
          json => {
            switch json->response_decode {
            | Ok(json') =>
              switch json'.message {
              | VALID => {
                  //User 정보 뮤테이션 진행 해야함.
                  mutate(
                    ~variables={
                      input: Mutation.make_updateUserInput(~businessRegistrationNumber=bNo, ()),
                    },
                    ~onCompleted=({updateUser}, _) => {
                      switch updateUser {
                      | #User(_) =>
                        addToast(.
                          <div className=%twc("flex items-center")>
                            <IconCheck
                              height="24" width="24" fill="#12B564" className=%twc("mr-2")
                            />
                            {j`사업자 등록번호가 저장되었습니다.`->React.string}
                          </div>,
                          {appearance: "success"},
                        )
                      | #Error(err) =>
                        addToast(.
                          <div className=%twc("flex items-center")>
                            <IconError height="24" width="24" className=%twc("mr-2") />
                            {j`오류가 발생하였습니다. 사업자 등록번호를 확인하세요.`->React.string}
                            {err.message->Option.getWithDefault("")->React.string}
                          </div>,
                          {appearance: "error"},
                        )
                      | #UnselectedUnionMember(_) =>
                        addToast(.
                          <div className=%twc("flex items-center")>
                            <IconError height="24" width="24" className=%twc("mr-2") />
                            {j`오류가 발생하였습니다. 사업자 등록번호를 확인하세요.`->React.string}
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
                            {j`오류가 발생하였습니다. 사업자 등록번호를 확인하세요.`->React.string}
                            {err.message->React.string}
                          </div>,
                          {appearance: "error"},
                        )
                      }
                    },
                    (),
                  )->ignore

                  reset()
                  onClose()
                }
              }
            | Error(_) =>
              addToast(.
                <div className=%twc("flex items-center")>
                  <IconError height="24" width="24" className=%twc("mr-2") />
                  {`유효하지 않은 사업자번호 입니다.`->React.string}
                </div>,
                {appearance: "error"},
              )
            }
            setIsVerifying(._ => false)
          }
        },
        ~onFailure={
          _ => {
            addToast(.
              <div className=%twc("flex items-center")>
                <IconError height="24" width="24" className=%twc("mr-2") />
                {`잠시후 다시 시도해주세요.`->React.string}
              </div>,
              {appearance: "error"},
            )
            setIsVerifying(._ => false)
          }
        },
      )->ignore
    }
  )->ReactEvents.interceptingHandler

  <Dialog.Root _open={isOpen} onOpenChange={reset}>
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
                {`사업자 등록번호 수정`->React.string}
              </span>
            </div>
            <Dialog.Close className=%twc("focus:outline-none") onClick={_ => onClose()}>
              <IconClose height="24" width="24" fill="#262626" />
            </Dialog.Close>
          </div>
        </section>
        <section className=%twc("pt-12 xl:pt-3 mb-6 px-4")>
          <form onSubmit={handleOnClickVerify}>
            <div className=%twc("flex flex-col ")>
              <div className=%twc("flex flex-col mb-10")>
                <div className=%twc("mb-2")>
                  <label className=%twc("font-bold")>
                    {`사업자 등록번호`->React.string}
                  </label>
                </div>
                <Input
                  type_="text"
                  name="business-number"
                  size=Input.Large
                  placeholder={`사업자 등록번호를 입력해주세요.`}
                  className=%twc("w-full")
                  value={businessNumber}
                  onChange={handleOnChangeBusinessNumber}
                  error={state.error->Option.map(({message}) => message)}
                  disabled={isVerifying}
                />
              </div>
              <button
                className=%twc("bg-green-500 rounded-xl w-full py-4")
                disabled={state.error->Option.isSome || businessNumber == "" || isVerifying}
                type_="submit">
                <span className=%twc("text-white")> {`인증`->React.string} </span>
              </button>
            </div>
          </form>
        </section>
      </div>
    </Dialog.Content>
  </Dialog.Root>
}
