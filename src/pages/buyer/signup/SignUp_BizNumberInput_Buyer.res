open HookForm
module Form = SignUp_Buyer_Form.Form
module Inputs = SignUp_Buyer_Form.Inputs

@spice
type message =
  | @spice.as("VALID") VALID
  | @spice.as("NOT_REGISTERED") NOT_REGISTERED
  | @spice.as("SUSPEND") SUSPEND
  | @spice.as("CLOSE") CLOSE

@spice
type response = {message: message}

let getClassName = disabled =>
  cx([
    %twc("w-full rounded-xl whitespace-nowrap focus:outline-none focus:ring-2 focus:ring-offset-1"),
    disabled
      ? %twc("bg-[#F7F8FA] text-gray-300 focus:ring-gray-300 ")
      : %twc("bg-[#DCFAE0]  text-primary focus:ring-gray-500"),
  ])

let dictToQueryStr = dict => {
  dict->Webapi.Url.URLSearchParams.makeWithDict->Webapi.Url.URLSearchParams.toString
}

@react.component
let make = (~form, ~isVerified, ~setIsVerified) => {
  let {isSubmitting} = form->Form.formState
  let error = form->Inputs.BizNumber.error

  let (isLoading, setLoading) = React.Uncurried.useState(_ => false)

  //인증 버튼 클릭이 불가능한 경우
  // 1. 로딩 중, 2. 서밋 중, 3.인증성공
  let disabled = isLoading || isSubmitting || isVerified

  let handleOnChange = e => {
    let newValue =
      (e->ReactEvent.Synthetic.currentTarget)["value"]
      ->Js.String2.replaceByRe(%re("/[^\d]/g"), "")
      ->Js.String2.replaceByRe(%re("/(^\d{3})(\d+)?(\d{5})$/"), "$1-$2-$3")
      ->Js.String2.replace("--", "-")

    setIsVerified(false)
    setLoading(._ => false)

    newValue
  }

  let verify = _ => {
    setLoading(._ => true)

    let bizNumber =
      form
      ->Inputs.BizNumber.getValue
      ->Garter.String.replaceByRe(Js.Re.fromStringWithFlags("\\-", ~flags="g"), "")

    let queryStr = list{("b-no", bizNumber)}->Js.Dict.fromList->dictToQueryStr

    FetchHelper.get(
      ~url=`${Env.restApiUrl}/user/validate-business-number?${queryStr}`,
      ~onSuccess={
        json => {
          let result = json->response_decode->Result.map(({message}) => message)

          switch result {
          | Ok(VALID) => {
              // 미인증 에러가 있는 경우 제거
              if error->Option.mapWithDefault(false, ({type_}) => type_ == "verified") {
                form->Inputs.BizNumber.clearError
              }
              setIsVerified(true)
            }

          | Ok(NOT_REGISTERED)
          | Ok(SUSPEND)
          | Ok(CLOSE) => {
              form->Inputs.BizNumber.setErrorWithOption(
                {type_: "verified", message: `유효하지 않은 사업자입니다.`},
                ~shouldFocus=true,
              )
              setIsVerified(false)
            }

          | Error(_) => {
              form->Inputs.BizNumber.setErrorWithOption(
                {
                  type_: "verified",
                  message: `인증에 실패하였습니다. 다시 한번 시도해주세요.`,
                },
                ~shouldFocus=true,
              )
              setIsVerified(false)
            }
          }

          setLoading(._ => false)
        }
      },
      ~onFailure={
        _ => {
          form->Inputs.BizNumber.setErrorWithOption(
            {
              type_: "verified",
              message: `인증에 실패하였습니다. 다시 한번 시도해주세요.`,
            },
            ~shouldFocus=true,
          )
          setIsVerified(false)
          setLoading(._ => false)
        }
      },
    )->ignore
  }

  let withValidate = verify =>
    (
      _ => {
        // 인증 불가 경우
        // 3. 초기상태("") 2. 번호 형식에러
        let hasValidateError =
          form->Inputs.BizNumber.getValue == "" ||
            error->Option.mapWithDefault(false, ({type_}) =>
              type_ == "required" || type_ == "pattern"
            )

        switch hasValidateError {
        | true => form->Inputs.BizNumber.trigger->ignore
        | false => verify()
        }
      }
    )->ReactEvents.interceptingHandler

  <div className=%twc("mt-5")>
    <span className=%twc("text-base font-bold mb-2")>
      {`사업자 등록번호`->React.string}
      <span className=%twc("ml-0.5 text-notice")> {"*"->React.string} </span>
    </span>
    <div className=%twc("mt-2")>
      <div className=%twc("w-full flex")>
        <div className=%twc("w-full relative")>
          {form->Inputs.BizNumber.renderController(
            ({field: {onChange, onBlur, value, ref, name}}) =>
              <Input
                type_="text"
                name
                size=Input.Large
                placeholder={`사업자 등록번호 입력`}
                value
                inputRef=ref
                onBlur={_ => onBlur()}
                onChange={e => e->handleOnChange->onChange}
                error={error->Option.map(({message}) => message)}
              />,
            (),
          )}
          {switch isVerified {
          | true =>
            <span className=%twc("absolute top-3.5 right-4 text-green-gl")>
              {`인증됨`->React.string}
            </span>
          | false => React.null
          }}
        </div>
        <span className=%twc("flex ml-2 w-24 h-13")>
          <button
            type_="button"
            className={getClassName(disabled)}
            disabled={disabled || isVerified}
            onClick={withValidate(verify)}>
            {`인증`->React.string}
          </button>
        </span>
      </div>
    </div>
  </div>
}
