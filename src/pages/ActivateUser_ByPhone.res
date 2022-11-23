module VerifyPhoneNumberFormFields = %lenses(type state = {phoneNumber: string})

module VerifyPhoneNumberForm = ReForm.Make(VerifyPhoneNumberFormFields)

let initialStateVerifyPhoneNumber: VerifyPhoneNumberFormFields.state = {
  phoneNumber: "",
}

type statusSendingSMS = BeforeSendSMS | SendingSMS | SuccessToSendSMS | FailureToSendSMS

let sendBtnStyle = %twc(
  "w-full bg-primary rounded-xl text-white font-bold whitespace-nowrap focus:outline-none focus:ring-2 focus:ring-gray-700 focus:ring-offset-1 h-14"
)
let resendBtnStyle = %twc(
  "w-full bg-gray-50 rounded-xl whitespace-nowrap focus:outline-none focus:ring-2 focus:ring-gray-300 focus:ring-offset-1 h-14"
)

module SendPhoneNumber = {
  @react.component
  let make = (~uid, ~role) => {
    let {addToast} = ReactToastNotifications.useToasts()
    let router = Next.Router.useRouter()
    let (sms, setSMS) = React.Uncurried.useState(_ => BeforeSendSMS)

    // 휴대전화 인증 번호 전송
    let onSubmitVerifyPhoneNumber = ({state}: VerifyPhoneNumberForm.onSubmitAPI) => {
      setSMS(._ => SendingSMS)
      // 입력된 폰 번호 형식 "010-1234-5678" -> "01012345678" 로 변경해야함.
      let phoneNumber =
        state.values
        ->VerifyPhoneNumberFormFields.get(VerifyPhoneNumberFormFields.PhoneNumber)
        ->Garter.String.replaceByRe(Js.Re.fromStringWithFlags("\-", ~flags="g"), "")

      {
        "recipient-no": phoneNumber,
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
              let query =
                router.query
                ->Webapi.Url.URLSearchParams.makeWithDict
                ->Webapi.Url.URLSearchParams.toString
              let role = if role == "farmer" {
                "seller"
              } else {
                role
              }
              router->Next.Router.push(`/${role}/activate-user?${query}&phone=${phoneNumber}`)
            }
          },
          ~onFailure={
            err => {
              setSMS(._ => FailureToSendSMS)
              addToast(.
                <div className=%twc("flex items-center")>
                  <IconError height="24" width="24" className=%twc("mr-2") />
                  {`휴대폰 번호가 일치하지 않아요`->React.string}
                </div>,
                {appearance: "error"},
              )
            }
          },
        )
      })
      ->ignore
      None
    }

    let verifyPhoneNumberForm: VerifyPhoneNumberForm.api = VerifyPhoneNumberForm.use(
      ~validationStrategy=VerifyPhoneNumberForm.OnChange,
      ~onSubmit=onSubmitVerifyPhoneNumber,
      ~initialState=initialStateVerifyPhoneNumber,
      ~schema={
        open VerifyPhoneNumberForm.Validation
        Schema(
          [
            regExp(
              PhoneNumber,
              ~matches="^\\d{3}-\\d{3,4}-\\d{4}$",
              ~error=`휴대전화 번호를 다시 확인해주세요.`,
            ),
          ]->Array.concatMany,
        )
      },
      (),
    )

    let handleOnSubmit = (
      _ => {
        verifyPhoneNumberForm.submit()
      }
    )->ReactEvents.interceptingHandler

    let handleOnChangePhoneNumber = e => {
      let newValue =
        (e->ReactEvent.Synthetic.currentTarget)["value"]
        ->Js.String2.replaceByRe(%re("/[^0-9]/g"), "")
        ->Js.String2.replaceByRe(%re("/(^1[0-9]{3}|^0[0-9]{2})([0-9]+)?([0-9]{4})$/"), "$1-$2-$3")
        ->Js.String2.replace("--", "-")

      newValue->Js.log

      VerifyPhoneNumberFormFields.PhoneNumber->verifyPhoneNumberForm.setFieldValue(
        newValue,
        ~shouldValidate=true,
        (),
      )
    }

    // 인증 초기화
    let reset = () => {
      setSMS(._ => BeforeSendSMS)
      VerifyPhoneNumberFormFields.PhoneNumber->verifyPhoneNumberForm.setFieldValue(
        "",
        ~shouldValidate=false,
        (),
      )
    }

    let handleOnSubmitPhoneNumber = (
      _ => {
        switch sms {
        | SuccessToSendSMS => reset()
        | FailureToSendSMS
        | BeforeSendSMS =>
          verifyPhoneNumberForm.submit()
        | SendingSMS => ()
        }
      }
    )->ReactEvents.interceptingHandler

    let isDisabledVerifyPhoneNumberForm = switch sms {
    | BeforeSendSMS => false
    | SendingSMS => true
    | SuccessToSendSMS => true
    | FailureToSendSMS => false
    }

    let isDisabledVerifyPhoneNumberButton = switch sms {
    | BeforeSendSMS => false
    | SendingSMS => true
    | SuccessToSendSMS => false
    | FailureToSendSMS => false
    }

    <>
      <Next.Head>
        <title> {j`휴대폰으로 휴면계정 해제`->React.string} </title>
      </Next.Head>
      <div
        className=%twc(
          "container mx-auto max-w-lg min-h-buyer relative flex flex-col justify-center pb-20"
        )>
        <div className=%twc("flex-auto flex flex-col xl:justify-center items-center")>
          <div className=%twc("w-full p-5 xl:py-12 text-text-L1")>
            <h2 className=%twc("text-xl font-bold whitespace-pre")>
              {`휴면 상태를 해제하시려면\n휴대폰 번호 인증이 필요해요`->React.string}
            </h2>
            <div className=%twc("mt-12 mb-1")>
              <span className=%twc("text-sm text-text-L2")>
                {`휴대폰 번호`->React.string}
              </span>
            </div>
            <form onSubmit={handleOnSubmit}>
              <Input
                type_="text"
                name="phone-number"
                size=Input.Large
                placeholder={`휴대폰 번호를 입력해주세요`}
                className=%twc("flex-1")
                value={verifyPhoneNumberForm.values->VerifyPhoneNumberFormFields.get(
                  VerifyPhoneNumberFormFields.PhoneNumber,
                )}
                onChange=handleOnChangePhoneNumber
                error={VerifyPhoneNumberFormFields.PhoneNumber
                ->VerifyPhoneNumberForm.ReSchema.Field
                ->verifyPhoneNumberForm.getFieldError}
                disabled=isDisabledVerifyPhoneNumberForm
              />
            </form>
          </div>
          <div className=%twc("w-full px-5")>
            <button
              type_="button"
              className={switch sms {
              | BeforeSendSMS => sendBtnStyle
              | SendingSMS => resendBtnStyle
              | SuccessToSendSMS => resendBtnStyle
              | FailureToSendSMS => sendBtnStyle
              }}
              disabled={isDisabledVerifyPhoneNumberButton}
              onClick=handleOnSubmitPhoneNumber>
              {`확인`->React.string}
            </button>
          </div>
        </div>
      </div>
    </>
  }
}

module Error = {
  @react.component
  let make = (~message) => {
    React.useEffect0(_ => {
      Global.jsAlert(message)

      None
    })

    <div
      className=%twc(
        "container mx-auto max-w-lg min-h-buyer relative flex flex-col justify-center"
      )>
      <Skeleton.Box className=%twc("h-10") />
    </div>
  }
}

@react.component
let make = (~skipEmail, ~phone=?, ~uid=?, ~role=?) => {
  switch (phone, role, uid) {
  | (Some(phone), Some(role), Some(uid)) =>
    <ActivateUser_ByPhone_VerificationCode phone skipEmail uid role />
  | (None, Some(role), Some(uid)) => <SendPhoneNumber uid role />
  | _ => <Error message={`잘못된 접근 입니다.`} />
  }
}
