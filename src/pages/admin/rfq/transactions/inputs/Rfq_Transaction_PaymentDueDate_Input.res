module Inputs = Rfq_Transactions_Admin_Form.Inputs

@react.component
let make = (~form, ~disabled=false) => {
  let (value, setValue) =
    form->(
      Inputs.PaymentDueDate.watch,
      Inputs.PaymentDueDate.setValueWithOption(~shouldValidate=true),
    )
  let error = form->Inputs.PaymentDueDate.error->Option.map(({message}) => message)

  let handleOnChangeDate = e => {
    let newDate = (e->DuetDatePicker.DuetOnChangeEvent.detail).valueAsDate
    switch newDate {
    | Some(newDate') => setValue(newDate', ())
    | _ => ()
    }
  }
  <span className=%twc("p-3")>
    <DatePicker
      disabled
      id="payment-due-date"
      date={value}
      onChange={handleOnChangeDate}
      minDate={Js.Date.make()->DateFns.format("yyyy-MM-dd")}
      firstDayOfWeek=0
    />
    {error->Option.mapWithDefault(React.null, errMsg =>
      <ErrorText className=%twc("absolute") errMsg />
    )}
  </span>
}
