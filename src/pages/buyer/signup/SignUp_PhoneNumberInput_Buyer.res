module Form = SignUp_Buyer_Form.Form
module Inputs = SignUp_Buyer_Form.Inputs

type status = SMSSent({loading: bool}) | Verifying({loading: bool})

let getClassName = disabled =>
  cx([
    %twc("w-full rounded-xl whitespace-nowrap focus:outline-none focus:ring-2 focus:ring-offset-1"),
    disabled
      ? %twc("bg-[#F7F8FA] text-gray-300 focus:ring-gray-300 ")
      : %twc("bg-[#DCFAE0]  text-primary focus:ring-gray-500"),
  ])

@react.component
let make = (~form, ~isVerified, ~setIsVerified) => {
  let router = Next.Router.useRouter()

  let error = form->Inputs.PhoneNumber.error

  let (status, setStatus) = React.Uncurried.useState(_ => None)
  let (code, setCode) = React.Uncurried.useState(_ => "")
  let (isShowDuplicated, setShowDuplicated) = React.Uncurried.useState(_ => Dialog.Hide)
  let (isShowVerifyError, setShowVerifyError) = React.Uncurried.useState(_ => false)

  let codeInput = React.useRef(Js.Nullable.null)

  // 인증/전송 버튼 클릭이 불가능한 경우
  // 1. 로딩 중
  let disabled =
    status == Some(SMSSent({loading: true})) || status == Some(Verifying({loading: true}))

  let handleOnChange = e => {
    let newValue =
      (e->ReactEvent.Synthetic.currentTarget)["value"]
      ->Js.String2.replaceByRe(%re("/[^0-9]/g"), "")
      ->Js.String2.replaceByRe(%re("/(^1[0-9]{3}|^0[0-9]{2})([0-9]+)?([0-9]{4})$/"), "$1-$2-$3")
      ->Js.String2.replace("--", "-")

    setIsVerified(false)
    setStatus(._ => None)
    setCode(._ => "")

    newValue
  }

  let sendSMS = _ => {
    setIsVerified(false)
    setStatus(._ => Some(SMSSent({loading: true})))

    let phoneNumber =
      form
      ->Inputs.PhoneNumber.getValue
      ->Garter.String.replaceByRe(Js.Re.fromStringWithFlags("\\-", ~flags="g"), "")

    {
      "recipient-no": phoneNumber,
    }
    ->Js.Json.stringifyAny
    ->Option.map(body => {
      FetchHelper.post(
        ~url=`${Env.restApiUrl}/user/sms`,
        ~body,
        ~onSuccess={
          _ => {
            setStatus(._ => Some(SMSSent({loading: false})))
            ReactUtil.focusElementByRef(codeInput)
          }
        },
        ~onFailure={
          _ => {
            setStatus(._ => None)
          }
        },
      )
    })
    ->ignore
    setShowVerifyError(._ => false)
  }

  let withValidate = fn =>
    (
      _ => {
        // 인증문자 보낼 수 없는 경우
        // 1.휴대전화번호 초기상태("") 2.휴대전화 번호 형식 에러
        let hasValidateError =
          form->Inputs.PhoneNumber.getValue == "" ||
            error->Option.mapWithDefault(false, ({type_}) =>
              type_ == "required" || type_ == "pattern"
            )

        switch hasValidateError {
        | true => form->Inputs.PhoneNumber.trigger->ignore
        | false => fn()
        }
      }
    )->ReactEvents.interceptingHandler

  let verify = _ => {
    setStatus(._ => Some(Verifying({loading: true})))

    let phoneNumber =
      form
      ->Inputs.PhoneNumber.getValue
      ->Garter.String.replaceByRe(Js.Re.fromStringWithFlags("\\-", ~flags="g"), "")

    {
      "recipient-no": phoneNumber,
      "confirmed-no": code,
      "role": "buyer",
    }
    ->Js.Json.stringifyAny
    ->Option.map(body =>
      FetchHelper.post(
        ~url=`${Env.restApiUrl}/user/sms/check-duplicated-member`,
        ~body,
        ~onSuccess={
          _ => {
            // 미인증 에러가 있는 경우 제거
            if error->Option.mapWithDefault(false, ({type_}) => type_ == "verified") {
              form->Inputs.PhoneNumber.clearError
            }
            setIsVerified(true)
            setStatus(._ => None)
          }
        },
        ~onFailure={
          err => {
            let customError = err->FetchHelper.convertFromJsPromiseError
            if customError.status === 409 {
              form->Inputs.PhoneNumber.resetField
              setCode(._ => "")
              setStatus(._ => None)
              setShowDuplicated(._ => Dialog.Show)
            } else {
              setStatus(._ => Some(Verifying({loading: false})))
              setShowVerifyError(._ => true)
            }
            setIsVerified(false)
          }
        },
      )
    )
    ->ignore
  }

  <div className=%twc("mt-5")>
    <span className=%twc("text-base font-bold")>
      {`휴대전화번호`->React.string}
      <span className=%twc("ml-0.5 text-notice")> {"*"->React.string} </span>
    </span>
    <div className=%twc("py-2")>
      <div className=%twc("flex")>
        {form->Inputs.PhoneNumber.renderController(
          ({field: {onChange, onBlur, value, ref, name}}) =>
            <Input
              type_="text"
              name
              size=Input.Large
              placeholder={`휴대전화번호`}
              className=%twc("flex-1")
              value
              inputRef=ref
              onBlur={_ => onBlur()}
              onChange={e => e->handleOnChange->onChange}
              error={error->Option.map(({message}) => message)}
            />,
          (),
        )}
        <span className=%twc("flex ml-2 w-24 h-13")>
          {
            let innerText = switch (status, isVerified) {
            // 초기 상태
            | (None, false) => `보내기`
            // 인증 완료, 인증 중
            | (_, true)
            | (Some(SMSSent(_)), _)
            | (Some(Verifying(_)), _) => `재전송`
            }

            <button
              type_="button"
              className={getClassName(disabled)}
              disabled
              onClick={withValidate(sendSMS)}>
              {innerText->React.string}
            </button>
          }
        </span>
      </div>
      <label htmlFor="verify-phone-number" className=%twc("block mt-3") />
      <div className=%twc("relative")>
        <Input
          inputRef={ReactDOM.Ref.domRef(codeInput)}
          type_="number"
          name="verify-phone-number"
          size=Input.Large
          placeholder={`인증번호`}
          value=code
          onChange={e => {
            let value = (e->ReactEvent.Synthetic.target)["value"]
            setCode(._ => value)
            setShowVerifyError(._ => false)
          }}
          error={isShowVerifyError ? Some(`인증번호가 일치하지 않습니다.`) : None}
          disabled={status->Option.isNone}
        />
        {switch status {
        | Some(Verifying(_))
        | Some(SMSSent({loading: false})) =>
          <Timer
            className=%twc("absolute top-3 right-4 text-red-gl")
            status=Timer.Start
            onChangeStatus={s => {
              if s == Timer.Stop {
                setStatus(._ => None)
              }
            }}
            startTimeInSec=180
          />
        | Some(SMSSent({loading: true}))
        | None => React.null
        }}
        {switch isVerified {
        | true =>
          <div className=%twc("absolute top-3.5 right-4 text-green-gl")>
            {`인증됨`->React.string}
          </div>
        | false => React.null
        }}
      </div>
      <span className=%twc("flex h-13 mt-3")>
        {
          let className = switch status {
          | None
          | Some(SMSSent({loading: true}))
          | Some(Verifying({loading: true})) =>
            getClassName(true)
          | Some(SMSSent({loading: false}))
          | Some(Verifying({loading: false})) =>
            getClassName(false)
          }
          //인증 버튼은 기존 disabled 조건에 인증 비활성화 및 성공일 때 추가
          <button
            type_="button"
            className
            onClick={verify}
            disabled={disabled || status == None || isVerified}>
            {`인증`->React.string}
          </button>
        }
      </span>
    </div>
    <Dialog
      isShow=isShowDuplicated
      onCancel={_ => {
        setShowDuplicated(._ => Dialog.Hide)
      }}
      textOnCancel={`아니오`}
      onConfirm={_ =>
        router->Next.Router.push(
          `/buyer/signin/find-id-password?mode=find-id&phone-number=${form->Inputs.PhoneNumber.getValue}`,
        )}
      textOnConfirm={`아이디 찾기`}>
      <p className=%twc("text-gray-500 text-center whitespace-pre-wrap")>
        {`이미 가입된 회원입니다.아이디 찾기 또는 다른 전화번호를 사용해주세요`->React.string}
      </p>
    </Dialog>
  </div>
}
