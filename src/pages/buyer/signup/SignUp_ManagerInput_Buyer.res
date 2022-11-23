module Form = SignUp_Buyer_Form.Form
module Inputs = SignUp_Buyer_Form.Inputs

@react.component
let make = (~form) => {
  let error = form->Inputs.Manager.error

  // innerRef를 사용해야 하기 때문에 register를 사용
  let {onChange, onBlur, name, ref} = form->Inputs.Manager.register()

  <div className=%twc("mt-5")>
    <span className=%twc("text-base font-bold mb-2")>
      {`담당자명`->React.string}
      <span className=%twc("ml-0.5 text-notice")> {"*"->React.string} </span>
    </span>
    <Input
      className=%twc("mt-2")
      name
      type_="text"
      size=Input.Large
      placeholder={`담당자명 입력`}
      onChange
      onBlur
      inputRef={ref}
      error={error->Option.map(({message}) => message)}
    />
  </div>
}
