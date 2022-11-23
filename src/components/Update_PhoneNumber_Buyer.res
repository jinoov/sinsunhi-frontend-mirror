open RadixUI

module Mutation = %relay(`
  mutation UpdatePhoneNumberBuyer_Mutation($input: UpdateUserInput!) {
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

type smsStatus =
  | Sending
  | Sent
  | Verifying
  | Timeout

let formatValidator: ValidatedState.validator<string> = (phoneNumber: string) => {
  let exp = Js.Re.fromString("^\\d{3}-\\d{3,4}-\\d{4}$")
  switch exp->Js.Re.test_(phoneNumber) {
  | true => Result.Ok(phoneNumber)
  | false =>
    Result.Error({
      type_: "format",
      message: `휴대전화번호를 다시 확인해 주세요.`,
    })
  }
}

@react.component
let make = (~isOpen, ~onClose) => {
  let {addToast} = ReactToastNotifications.useToasts()
  let (phoneNumber, setPhoneNumber, state) = ValidatedState.use(
    ValidatedState.String,
    "",
    ~validators=[formatValidator],
  )
  let (verificationCode, setVerificationCode) = React.Uncurried.useState(_ => None)
  let (verificationCodeError, setVerificationCodeError) = React.Uncurried.useState(_ => None)

  let (mutate, _) = Mutation.use()

  let (smsStatus, setSmsStatus) = React.Uncurried.useState(_ => None)

  let inputVerificationCodeRef = React.useRef(Js.Nullable.null)

  let handleOnChangePhoneNumber = e => {
    let newValue =
      (e->ReactEvent.Synthetic.currentTarget)["value"]
      ->Js.String2.replaceByRe(%re("/[^0-9]/g"), "")
      ->Js.String2.replaceByRe(%re("/(^1[0-9]{3}|^0[0-9]{2})([0-9]+)?([0-9]{4})$/"), "$1-$2-$3")
      ->Js.String2.replace("--", "-")

    setPhoneNumber(newValue, ~shouldValidate=true, ())
    setVerificationCode(._ => None)
    setVerificationCodeError(._ => None)
    setSmsStatus(._ => None)
  }

  let handleOnClickSendSMS = _ => {
    setSmsStatus(._ => Some(Sending))

    let recipientNo =
      phoneNumber->Garter.String.replaceByRe(Js.Re.fromStringWithFlags("\-", ~flags="g"), "")

    {
      "recipient-no": recipientNo,
    }
    ->Js.Json.stringifyAny
    ->Option.map(body => {
      FetchHelper.post(
        ~url=`${Env.restApiUrl}/user/sms`,
        ~body,
        ~onSuccess={
          _ => {
            setSmsStatus(._ => Some(Sent))
            ReactUtil.focusElementByRef(inputVerificationCodeRef)
          }
        },
        ~onFailure={
          err => {
            setSmsStatus(._ => None)
            addToast(.
              <div className=%twc("flex items-center")>
                <IconError height="24" width="24" className=%twc("mr-2") />
                {`잠시후 다시 시도해주세요.`->React.string}
              </div>,
              {appearance: "error"},
            )
          }
        },
      )
    })
    ->ignore
  }

  let handleOnChangeVerficiationCode = e => {
    let target = (e->ReactEvent.Synthetic.currentTarget)["value"]

    setVerificationCode(._ => target)
  }

  let reset = _ => {
    setPhoneNumber("", ())
    setVerificationCode(._ => None)
    setVerificationCodeError(._ => None)
    setSmsStatus(._ => None)
  }

  let handleOnClickVerify = _ => {
    setSmsStatus(._ => Some(Verifying))

    let recipientNo =
      phoneNumber->Garter.String.replaceByRe(Js.Re.fromStringWithFlags("\-", ~flags="g"), "")

    {
      "recipient-no": recipientNo,
      "confirmed-no": verificationCode,
      "role": "buyer",
    }
    ->Js.Json.stringifyAny
    ->Option.map(body =>
      FetchHelper.post(
        ~url=`${Env.restApiUrl}/user/sms/check`,
        ~body,
        ~onSuccess={
          _ => {
            //User 정보 뮤테이션 진행 해야함.
            mutate(
              ~variables={
                input: Mutation.make_updateUserInput(~phone=recipientNo, ()),
              },
              ~onCompleted=({updateUser}, _) => {
                switch updateUser {
                | #User(_) =>
                  addToast(.
                    <div className=%twc("flex items-center")>
                      <IconCheck height="24" width="24" fill="#12B564" className=%twc("mr-2") />
                      {j`휴대전화번호가 저장되었습니다.`->React.string}
                    </div>,
                    {appearance: "success"},
                  )
                | #Error(err) =>
                  addToast(.
                    <div className=%twc("flex items-center")>
                      <IconError height="24" width="24" className=%twc("mr-2") />
                      {j`오류가 발생하였습니다. 휴대전화번호를 확인하세요.`->React.string}
                      {err.message->Option.getWithDefault("")->React.string}
                    </div>,
                    {appearance: "error"},
                  )
                | #UnselectedUnionMember(_) =>
                  addToast(.
                    <div className=%twc("flex items-center")>
                      <IconError height="24" width="24" className=%twc("mr-2") />
                      {j`오류가 발생하였습니다. 휴대전화번호를 확인하세요.`->React.string}
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
                      {j`오류가 발생하였습니다. 휴대전화번호를 확인하세요.`->React.string}
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
        },
        ~onFailure={
          err => {
            setVerificationCodeError(._ => Some(`인증번호가 일치 하지 않습니다.`))
            setSmsStatus(._ => Some(Sent))
          }
        },
      )
    )
    ->ignore
  }

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
          <div className=%twc("flex items-center justify-between px-5 h-14 xl:pb-10")>
            <div className=%twc("w-6 xl:hidden") />
            <div>
              <span className=%twc("font-bold xl:text-2xl")>
                {`휴대전화번호 변경`->React.string}
              </span>
            </div>
            <Dialog.Close className=%twc("focus:outline-none") onClick={_ => onClose()}>
              <IconClose height="24" width="24" fill="#262626" />
            </Dialog.Close>
          </div>
        </section>
        <section className=%twc("pt-12 xl:pt-3 mb-6 px-4")>
          <div className=%twc("flex flex-col ")>
            <div className=%twc("flex flex-col mb-10")>
              <div className=%twc("mb-2")>
                <label className=%twc("font-bold")>
                  {`새 휴대전화번호 입력`->React.string}
                </label>
              </div>
              <div className=%twc("flex mb-3")>
                <Input
                  type_="text"
                  name="phone-number"
                  size=Input.Large
                  placeholder={`휴대전화번호`}
                  className=%twc("w-full")
                  value={phoneNumber}
                  onChange={handleOnChangePhoneNumber}
                  error={state.error->Option.map(({message}) => message)}
                  disabled={false}
                />
                {switch smsStatus {
                | None =>
                  <button
                    className=%twc("py-3 px-6 w-[120px] rounded-xl bg-blue-gray-700 ml-2 h-13")
                    disabled={state.error->Option.isSome || phoneNumber == ""}
                    onClick={handleOnClickSendSMS}>
                    <span className=%twc("text-white")> {`보내기`->React.string} </span>
                  </button>
                | Some(Sending) =>
                  <button
                    className=%twc("py-3 px-6 w-[120px] rounded-xl bg-surface ml-2 h-13")
                    disabled={true}>
                    <span> {`전송중`->React.string} </span>
                  </button>
                | Some(Verifying) =>
                  <button
                    className=%twc("py-3 px-6 w-[120px] rounded-xl bg-surface ml-2 h-13")
                    disabled={true}>
                    <span> {`인증중`->React.string} </span>
                  </button>
                | Some(Sent)
                | Some(Timeout) =>
                  <button
                    className=%twc("py-3 px-6 w-[120px] rounded-xl bg-surface ml-2 h-13")
                    onClick={handleOnClickSendSMS}>
                    <span> {`재전송`->React.string} </span>
                  </button>
                }}
              </div>
              <div className=%twc("relative")>
                <Input
                  inputRef={ReactDOM.Ref.domRef(inputVerificationCodeRef)}
                  type_="number"
                  name="verify-number"
                  size=Input.Large
                  placeholder={`인증번호`}
                  className=%twc("w-full")
                  value={verificationCode->Option.mapWithDefault("", Int.toString)}
                  onChange={handleOnChangeVerficiationCode}
                  error={verificationCodeError}
                  disabled={switch smsStatus {
                  | None
                  | Some(Sending)
                  | Some(Verifying) => true
                  | Some(Sent)
                  | Some(Timeout) => false
                  }}
                />
                {switch smsStatus {
                | None
                | Some(Sending) => React.null
                | Some(Verifying)
                | Some(Sent) =>
                  <Timer
                    className=%twc("absolute top-3 right-4 text-red-gl")
                    status=Timer.Start
                    onChangeStatus={status =>
                      switch status {
                      | Timer.Stop =>
                        setVerificationCodeError(.
                          _ => Some(`입력가능한 시간이 지났습니다.`),
                        )
                        setSmsStatus(._ => Some(Timeout))
                      | _ => ()
                      }}
                    startTimeInSec=180
                  />
                | Some(Timeout) =>
                  <Timer
                    className=%twc("absolute top-3 right-4 text-red-gl")
                    status=Timer.Stop
                    onChangeStatus={_ => ()}
                    startTimeInSec=0
                  />
                }}
              </div>
            </div>
            {switch smsStatus {
            | None
            | Some(Sending) =>
              <button className=%twc("bg-disabled-L2 rounded-xl w-full py-4") disabled={true}>
                <span className=%twc("text-white")> {`인증`->React.string} </span>
              </button>
            | Some(Sent)
            | Some(Timeout) =>
              <button
                className=%twc("bg-green-500 rounded-xl w-full py-4")
                disabled={smsStatus == Some(Timeout) ? true : false}
                onClick={handleOnClickVerify}>
                <span className=%twc("text-white")> {`인증`->React.string} </span>
              </button>
            | Some(Verifying) =>
              <button className=%twc("bg-disabled-L2 rounded-xl w-full py-4") disabled={true}>
                <span className=%twc("text-white")> {`인증 중`->React.string} </span>
              </button>
            }}
          </div>
        </section>
      </div>
    </Dialog.Content>
  </Dialog.Root>
}
