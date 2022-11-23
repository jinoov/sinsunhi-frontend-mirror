module Inputs = SignUp_Buyer_Form.Inputs

@react.component
let make = (~form) => {
  let basicError = form->Inputs.BasicTerm.error
  let privacyError = form->Inputs.PrivacyTerm.error

  //에러 중 하나 pick
  let finalErrorMessage = switch (basicError, privacyError) {
  | (Some(error), _) => Some(error)
  | (None, Some(error)) => Some(error)
  | (None, None) => None
  }->Option.map(({message}) => message)

  let handleChange = e => {
    let checked = (e->ReactEvent.Synthetic.target)["checked"]

    form->Inputs.BasicTerm.setValueWithOption(checked, ~shouldValidate=true, ())
    form->Inputs.PrivacyTerm.setValueWithOption(checked, ~shouldValidate=true, ())
    form->Inputs.MarketingTerm.setValueWithOption(checked, ~shouldValidate=true, ())
  }

  let basicTerm = form->Inputs.BasicTerm.register()
  let privacyTerm = form->Inputs.PrivacyTerm.register()
  let marketingTerm = form->Inputs.MarketingTerm.register()

  <>
    <div className=%twc("flex items-center mt-7")>
      <Checkbox.Uncontrolled id="term-all" name="term-all" onChange={handleChange} />
      <span className=%twc("ml-2 font-bold text-base")>
        {`전체 내용에 동의합니다`->React.string}
      </span>
    </div>
    // 신선하이 이용약관
    <div className=%twc("flex items-center justify-between mt-5")>
      <div className=%twc("flex items-center")>
        <Checkbox.Uncontrolled
          id=basicTerm.name
          name=basicTerm.name
          onChange=basicTerm.onChange
          onBlur=basicTerm.onBlur
          inputRef=basicTerm.ref
        />
        <span className=%twc("ml-2 text-base")>
          {`신선하이 이용약관 (필수)`->React.string}
          <span className=%twc("ml-0.5 text-notice")> {"*"->React.string} </span>
        </span>
      </div>
      <Next.Link href={Env.termsUrl}>
        <a target="_blank">
          <IconArrow height="18" width="18" strokeWidth="0" fill="#DDDDDD" stroke="#DDDDDD" />
        </a>
      </Next.Link>
    </div>
    // 개인정보 수집·이용(필수)
    <div className=%twc("flex items-center justify-between mt-4")>
      <div className=%twc("flex items-center")>
        <Checkbox.Uncontrolled
          id=privacyTerm.name
          name=privacyTerm.name
          onChange=privacyTerm.onChange
          onBlur=privacyTerm.onBlur
          inputRef=privacyTerm.ref
        />
        <span className=%twc("ml-2 text-base")>
          {`개인정보 수집이용 동의 (필수)`->React.string}
          <span className=%twc("ml-0.5 text-notice")> {"*"->React.string} </span>
        </span>
      </div>
      <Next.Link href={Env.privacyAgreeUrl}>
        <a target="_blank">
          <IconArrow height="18" width="18" strokeWidth="0" fill="#DDDDDD" stroke="#DDDDDD" />
        </a>
      </Next.Link>
    </div>
    // 맞춤 소싱 제안 등 마케팅 정보 수신(선택)
    <div className=%twc("flex items-center justify-between mt-4")>
      <div className=%twc("flex items-center")>
        <Checkbox.Uncontrolled
          id=marketingTerm.name
          name=marketingTerm.name
          onChange=marketingTerm.onChange
          onBlur=marketingTerm.onBlur
          inputRef=marketingTerm.ref
        />
        <span className=%twc("ml-2 text-base")>
          {`맞춤 소싱 제안 등 마케팅 정보 수신 (선택)`->React.string}
        </span>
      </div>
      <Next.Link href={Env.privacyMarketing}>
        <a target="_blank">
          <IconArrow height="18" width="18" strokeWidth="0" fill="#DDDDDD" stroke="#DDDDDD" />
        </a>
      </Next.Link>
    </div>
    {switch finalErrorMessage {
    | Some(message) =>
      <div className=%twc("mt-2 flex items-center")>
        <IconError width="20" height="20" />
        <span className=%twc("text-notice ml-1")> {message->React.string} </span>
      </div>

    | None => React.null
    }}
  </>
}
