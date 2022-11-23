open HookForm
module Form = SignUp_Buyer_Form.Form
module Inputs = SignUp_Buyer_Form.Inputs

@spice
type response = {data: bool, message: string}

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

  let {isSubmitting} = form->Form.formState
  let error = form->Inputs.Email.error

  let (isLoading, setLoading) = React.Uncurried.useState(_ => false)
  let (showExisted, setShowExisted) = React.Uncurried.useState(_ => Dialog.Hide)

  // 중복확인 버튼 클릭이 불가능한 경우
  // 1. 로딩 중, 2. 서밋 중,
  let disabled = isLoading || isSubmitting

  let verify = _ => {
    setLoading(._ => true)
    let email = form->Inputs.Email.getValue

    FetchHelper.get(
      ~url=`${Env.restApiUrl}/user/check-duplicate-email?email=${email}`,
      ~onSuccess={
        json => {
          switch json->response_decode {
          | Ok({data}) if data => setShowExisted(._ => Dialog.Show)
          | Ok({data}) if !data =>
            // 미인증 에러가 있는 경우 제거
            if error->Option.mapWithDefault(false, ({type_}) => type_ == "verified") {
              form->Inputs.Email.clearError
            }
            setIsVerified(true)

          | Ok(_)
          | Error(_) => ()
          }
          setLoading(._ => false)
        }
      },
      ~onFailure={
        _ => {
          setLoading(._ => false)
        }
      },
    )->ignore
  }

  let withValidate = verify =>
    (
      _ => {
        // 인증이 불가능 한 경우
        // 1.초기상태(email="") 2. 이메일 형식 에러,
        let hasValidateError =
          form->Inputs.Email.getValue == "" ||
            error->Option.mapWithDefault(false, ({type_}) =>
              type_ == "required" || type_ == "pattern"
            )

        switch hasValidateError {
        | true => form->Inputs.Email.trigger->ignore
        | false => verify()
        }
      }
    )->ReactEvents.interceptingHandler

  // innerRef를 사용해야 하기 때문에 register를 사용
  let {onChange, onBlur, ref, name} = form->Inputs.Email.register(
    ~config=Rules.makeWithErrorMessage({
      onChange: _ => setIsVerified(false),
    }),
    (),
  )

  <div className=%twc("w-full")>
    <span className=%twc("text-base font-bold")>
      {`이메일`->React.string}
      <span className=%twc("ml-0.5 text-notice")> {"*"->React.string} </span>
    </span>
    <div className=%twc("flex w-full mt-2")>
      <div className=%twc("flex flex-1 relative")>
        <Input
          size=Input.Large
          name
          type_="text"
          placeholder={`이메일 입력`}
          className=%twc("pr-[68px]")
          onChange
          onBlur
          inputRef={ref}
          error={error->Option.map(({message}) => message)}
        />
        {switch isVerified {
        | true =>
          <span className=%twc("absolute top-3.5 right-2 sm:right-4 text-green-gl")>
            {`사용가능`->React.string}
          </span>
        | false => React.null
        }}
      </div>
      <span className=%twc("flex ml-2 w-24 h-13")>
        <button
          type_="button" className={getClassName(disabled)} disabled onClick={withValidate(verify)}>
          {`중복확인`->React.string}
        </button>
      </span>
    </div>
    <Dialog
      isShow=showExisted
      onCancel={_ => {
        form->Inputs.Email.setValueWithOption("", ~shouldValidate=true, ())
        setShowExisted(._ => Dialog.Hide)
      }}
      textOnCancel={`닫기`}
      onConfirm={_ => {
        let email = form->Inputs.Email.getValue
        router->Next.Router.push(`/buyer/signin/find-id-password?mode=reset-password&uid=${email}`)
      }}
      textOnConfirm={`비밀번호 찾기`}
      boxStyle=%twc("rounded-xl")>
      <p className=%twc("text-text-L1 text-center whitespace-pre-wrap")>
        {`이미 가입한 계정입니다.\n로그인하시거나 비밀번호 찾기를 해주세요.`->React.string}
      </p>
    </Dialog>
  </div>
}
