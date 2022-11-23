module Form = SignUp_Buyer_Form.Form
module Inputs = SignUp_Buyer_Form.Inputs

@react.component
let make = (~form) => {
  let (showPassword, setShowPassword) = React.Uncurried.useState(_ => false)
  let error = form->Inputs.Password.error

  // innerRef를 사용해야 하기 때문에 register를 사용
  let {onChange, onBlur, name, ref} = form->Inputs.Password.register()

  <div className=%twc("mt-5")>
    <span className=%twc("text-base font-bold mb-2")>
      {`비밀번호`->React.string}
      <span className=%twc("ml-0.5 text-notice")> {"*"->React.string} </span>
    </span>
    <Input
      className=%twc("mt-2")
      name
      type_={showPassword ? "text" : "password"}
      size=Input.Large
      placeholder={`비밀번호 입력 (영문, 숫자 조합 6~15자)`}
      onChange
      onBlur
      inputRef=ref
      error={error->Option.map(({message}) => message)}
    />
    <div className=%twc("flex items-center mt-2")>
      <Checkbox
        id="show-password"
        name="show-password"
        checked=showPassword
        onChange={_ => setShowPassword(._ => !showPassword)}
      />
      <label htmlFor="show-password" className=%twc("ml-2 cursor-pointer")>
        {`비밀번호 표시`->React.string}
      </label>
    </div>
  </div>
}
