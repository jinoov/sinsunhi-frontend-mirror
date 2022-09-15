module VerificationCodeFormFields = %lenses(type state = {verificationCode: string})

module VerificationCodeForm = ReForm.Make(VerificationCodeFormFields)

let initialStateVerificationCode: VerificationCodeFormFields.state = {
  verificationCode: "",
}

type statusVerificationCode =
  BeforeSendVerificationCode | SendingVerificationCode | SuccessToVerifyCode | FailureToVerifyCode

let sendBtnStyle = %twc(
  "w-full bg-primary rounded-xl text-white font-bold whitespace-nowrap focus:outline-none focus:ring-2 focus:ring-gray-700 focus:ring-offset-1 h-14"
)
let resendBtnStyle = %twc(
  "w-full bg-gray-50 rounded-xl whitespace-nowrap focus:outline-none focus:ring-2 focus:ring-gray-300 focus:ring-offset-1 h-14"
)

@react.component
let make = (~phone, ~skipEmail, ~uid, ~role) => {
  let {addToast} = ReactToastNotifications.useToasts()
  let limitToTry = React.useRef(3)
  let inputVerificationCodeRef = React.useRef(Js.Nullable.null)
  let router = Next.Router.useRouter()

  let (verificationCode, setVerificationCode) = React.Uncurried.useState(_ =>
    BeforeSendVerificationCode
  )
  let (isShowVerifyError, setShowVerifyError) = React.Uncurried.useState(_ => Dialog.Hide)
  let (isShowTryLimitError, setShowTryLimitError) = React.Uncurried.useState(_ => Dialog.Hide)
  let (isTimeover, setTimeover) = React.Uncurried.useState(_ => false)

  // 인증 번호 다시 받기
  let getVerificationCodeAgain = () => {
    {
      "recipient-no": phone,
      "uid": uid,
      "cert-type": "reset-dormant",
    }
    ->Js.Json.stringifyAny
    ->Option.map(body => {
      FetchHelper.post(
        ~url=`${Env.restApiUrl}/user/sms`,
        ~body,
        ~onSuccess={
          _ => {
            addToast(.
              <div className=%twc("flex items-center")>
                <IconCheck height="24" width="24" fill="#12B564" className=%twc("mr-2") />
                {`문자를 다시 전송했어요`->React.string}
              </div>,
              {appearance: "success"},
            )
            setVerificationCode(._ => BeforeSendVerificationCode)
          }
        },
        ~onFailure={
          err => {
            addToast(.
              <div className=%twc("flex items-center")>
                <IconError height="24" width="24" className=%twc("mr-2") />
                {`다시 시도해주세요`->React.string}
              </div>,
              {appearance: "error"},
            )
          }
        },
      )
    })
    ->ignore
  }

  // 인증번호 전송
  let onSubmitVerificationCode = ({state}: VerificationCodeForm.onSubmitAPI) => {
    setVerificationCode(._ => SendingVerificationCode)

    let code =
      state.values->VerificationCodeFormFields.get(VerificationCodeFormFields.VerificationCode)

    {
      "uid": uid,
      "recipient-no": phone,
      "confirmed-no": code,
    }
    ->Js.Json.stringifyAny
    ->Option.map(body =>
      FetchHelper.post(
        ~url=`${Env.restApiUrl}/user/dormant/reset-phone`,
        ~body,
        ~onSuccess={
          _ => {
            let role = if role == "farmer" {
              "seller"
            } else {
              role
            }
            router->Next.Router.push(`/${role}/signin`)
          }
        },
        ~onFailure={
          err => {
            // 재시도 <= 10
            limitToTry.current = limitToTry.current + 1
            if limitToTry.current >= 10 {
              setShowTryLimitError(._ => Dialog.Show)
              setVerificationCode(._ => FailureToVerifyCode)
            } else {
              setShowVerifyError(._ => Dialog.Show)
            }
          }
        },
      )
    )
    ->ignore
    None
  }

  let verificationCodeForm: VerificationCodeForm.api = VerificationCodeForm.use(
    ~validationStrategy=VerificationCodeForm.OnChange,
    ~onSubmit=onSubmitVerificationCode,
    ~initialState=initialStateVerificationCode,
    ~schema={
      open VerificationCodeForm.Validation
      Schema(
        [
          nonEmpty(VerificationCode, ~error=`인증번호를 입력해주세요.`),
        ]->Array.concatMany,
      )
    },
    (),
  )

  let isDisabledVerifyCodeForm = switch verificationCode {
  | BeforeSendVerificationCode => false
  | SendingVerificationCode => true
  | SuccessToVerifyCode => true
  | FailureToVerifyCode => true
  }

  let timerStatus = switch verificationCode {
  | BeforeSendVerificationCode => Timer.Resume
  | SendingVerificationCode => Timer.Pause
  | SuccessToVerifyCode => Timer.Pause
  | FailureToVerifyCode => Timer.Stop
  }

  let onChangeStatus = status => {
    switch status {
    | Timer.Stop => {
        setVerificationCode(._ => FailureToVerifyCode)
        setTimeover(._ => true)
      }
    | _ => ()
    }
  }

  React.useEffect1(_ => {
    if (
      verificationCodeForm.values
      ->VerificationCodeFormFields.get(VerificationCodeFormFields.VerificationCode)
      ->Js.String2.length == 6
    ) {
      verificationCodeForm.submit()
    } else {
      ()
    }
    None
  }, [
    verificationCodeForm.values->VerificationCodeFormFields.get(
      VerificationCodeFormFields.VerificationCode,
    ),
  ])

  React.useEffect0(_ => {
    let _ = Js.Global.setTimeout(_ => ReactUtil.focusElementByRef(inputVerificationCodeRef), 0)

    None
  })

  <>
    <Next.Head> <title> {j`휴대폰으로 휴면계정 해제`->React.string} </title> </Next.Head>
    <div
      className=%twc(
        "container mx-auto max-w-lg min-h-buyer relative flex flex-col justify-center pb-20"
      )>
      <div className=%twc("flex-auto flex flex-col xl:justify-center items-center")>
        <div className=%twc("w-full p-5 xl:py-12 text-text-L1")>
          <h2 className=%twc("text-xl font-bold whitespace-pre")>
            {`문자로 받은\n인증번호 6자리를 입력해주세요`->React.string}
          </h2>
          <div className=%twc("mt-12 mb-1")>
            <span className=%twc("text-sm text-text-L2")> {`인증번호`->React.string} </span>
          </div>
          <div className=%twc("relative")>
            <Input
              inputRef={ReactDOM.Ref.domRef(inputVerificationCodeRef)}
              type_="number"
              name="verify-number"
              size=Input.Large
              placeholder=`6자리 숫자를 입력해주세요`
              value={verificationCodeForm.values->VerificationCodeFormFields.get(
                VerificationCodeFormFields.VerificationCode,
              )}
              onChange={VerificationCodeFormFields.VerificationCode
              ->verificationCodeForm.handleChange
              ->ReForm.Helpers.handleChange}
              error={VerificationCodeFormFields.VerificationCode
              ->VerificationCodeForm.ReSchema.Field
              ->verificationCodeForm.getFieldError}
              disabled={isDisabledVerifyCodeForm}
            />
            {switch verificationCode {
            | BeforeSendVerificationCode
            | SendingVerificationCode
            | FailureToVerifyCode =>
              <Timer
                className=%twc("absolute top-3 right-4 text-primary")
                status=timerStatus
                onChangeStatus
                startTimeInSec=180
              />
            | SuccessToVerifyCode =>
              <div className=%twc("absolute top-3.5 right-4 text-green-gl")>
                {`인증됨`->React.string}
              </div>
            }}
          </div>
          {switch isTimeover {
          | true =>
            <div className=%twc("mt-4")>
              <button
                className=%twc("bg-enabled-L5 rounded-lg text-sm px-3 py-1")
                onClick={_ => getVerificationCodeAgain()}>
                {`문자 다시 받기`->React.string}
              </button>
            </div>
          | false => React.null
          }}
        </div>
      </div>
    </div>
    <Dialog
      isShow=isShowVerifyError
      onConfirm={_ => {
        VerificationCodeFormFields.VerificationCode->verificationCodeForm.setFieldValue(
          "",
          ~shouldValidate=false,
          (),
        )
        setVerificationCode(._ => BeforeSendVerificationCode)
        setShowVerifyError(._ => Dialog.Hide)
        let _ = Js.Global.setTimeout(_ => ReactUtil.focusElementByRef(inputVerificationCodeRef), 0)
      }}
      textOnConfirm=`확인`>
      <p className=%twc("text-gray-500 text-center whitespace-pre-wrap")>
        {`인증번호가 일치하지 않습니다.`->React.string}
      </p>
    </Dialog>
    <Dialog
      isShow=isShowTryLimitError
      onCancel={_ => {
        router->Next.Router.back
      }}
      onConfirm={_ => {
        let role = if role == "farmer" {
          "seller"
        } else {
          role
        }
        if skipEmail {
          router->Next.Router.push(`/${role}/activate-user`)
        } else {
          router->Next.Router.push(`/${role}/activate-user?mode=email`)
        }
      }}
      textOnConfirm=`확인`>
      <p className=%twc("text-gray-500 text-center whitespace-pre-wrap")>
        {`휴대폰 번호를 10회 이상 틀렸어요\n이메일 인증을 하시겠어요?`->React.string}
      </p>
    </Dialog>
  </>
}
