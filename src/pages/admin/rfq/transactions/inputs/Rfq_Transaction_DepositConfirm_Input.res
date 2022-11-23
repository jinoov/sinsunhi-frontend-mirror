module Inputs = Rfq_Transactions_Admin_Form.Inputs

@react.component
let make = (~form, ~disabled) => {
  let {name, onChange, onBlur, ref} = form->Inputs.DepositConfirm.register()

  <div className=%twc("flex items-center gap-2")>
    <Checkbox.Uncontrolled id=name name onChange onBlur inputRef=ref disabled />
    <span className=%twc("ml-2 text-text-L1 text-sm")> {"입금완료 처리"->React.string} </span>
  </div>
}
