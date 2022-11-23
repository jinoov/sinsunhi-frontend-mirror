module Form = Rfq_Transactions_Admin_Form
module Inputs = Form.Inputs

let isFactorings: array<Form.isFactoring> = [#NOT_SELECTED, #N, #Y]
let isFactoringToString = m =>
  m->Form.isFactoring_encode->Js.Json.decodeString->Option.getWithDefault("")

@react.component
let make = (~form, ~disabled=false) => {
  let currentValue = form->Inputs.IsPactoring.watch
  let error = form->Inputs.IsPactoring.error->Option.map(({message}) => message)

  <div>
    <div>
      <label id="select" className=%twc("block text-sm font-medium text-gray-700") />
      <div className=%twc("relative")>
        <button
          type_="button"
          className={cx([
            %twc(
              "w-16 relative bg-white border rounded-lg py-1.5 px-3 border-border-default-L1 focus:outline-none focus:ring-1-gl remove-spin-button focus:border-gray-gl"
            ),
            disabled ? %twc("bg-gray-100") : %twc("bg-white"),
          ])}>
          <span className=%twc("flex items-center text-text-L1")>
            <span className=%twc("block truncate")>
              {currentValue->isFactoringToString->React.string}
            </span>
          </span>
          <span className=%twc("absolute top-0.5 right-1")>
            <IconArrowSelect height="28" width="28" fill="#121212" />
          </span>
        </button>
        {form->Inputs.IsPactoring.renderController(({field: {onChange, onBlur, ref, name}}) =>
          <select
            className=%twc("absolute left-0 w-full py-3 opacity-0")
            disabled
            name
            ref
            onBlur={_ => onBlur()}
            onChange={e => {
              let value = (e->ReactEvent.Synthetic.currentTarget)["value"]->Js.Json.string
              switch value->Form.isFactoring_decode {
              | Ok(decode) => decode->onChange
              | _ => ()
              }
            }}>
            {isFactorings
            ->Array.map(isFactoring => {
              let stringStatus = isFactoring->isFactoringToString
              <option key=stringStatus value=stringStatus> {stringStatus->React.string} </option>
            })
            ->React.array}
          </select>
        , ())}
      </div>
    </div>
    {error->Option.mapWithDefault(React.null, errMsg =>
      <ErrorText className=%twc("absolute") errMsg />
    )}
  </div>
}
