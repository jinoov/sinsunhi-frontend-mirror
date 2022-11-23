module Query = %relay(`
    query RfqTransactionFactoringBankInputQuery {
      factoring {
        id
        displayName
        bank {
          name
        }
      }
    }
`)

module Inputs = Rfq_Transactions_Admin_Form.Inputs

module Skeleton = {
  @react.component
  let make = () => {
    <Skeleton.Box className=%twc("w-44") />
  }
}

@react.component
let make = (~form, ~disabled=false) => {
  let {factoring} = Query.use(~variables=(), ())

  let currentValue = form->Inputs.FactoringBank.watch
  let {ref, name, onBlur, onChange} = form->Inputs.FactoringBank.register()
  let error = form->Inputs.FactoringBank.error->Option.map(({message}) => message)

  let factoringList =
    factoring->Option.mapWithDefault([], l =>
      l->Array.map(f => (
        f.id,
        f.displayName ++ f.bank->Option.mapWithDefault("", b => "-" ++ b.name),
      ))
    )
  let factoringMap = factoringList->Map.String.fromArray

  let label = factoringMap->Map.String.get(currentValue)->Option.getWithDefault("선택")

  <div>
    <div>
      <label id="select" className=%twc("block text-sm font-medium text-gray-700") />
      <div className=%twc("relative")>
        <button
          type_="button"
          className={cx([
            %twc(
              "w-40 min-w-fit relative border rounded-lg py-1.5 px-3 border-border-default-L1 focus:outline-none focus:ring-1-gl remove-spin-button focus:border-gray-gl"
            ),
            disabled ? %twc("bg-gray-100") : %twc("bg-white"),
          ])}>
          <span className=%twc("flex items-center text-text-L1")>
            <span className=%twc("block truncate")> {label->React.string} </span>
          </span>
          <span className=%twc("absolute top-0.5 right-1")>
            <IconArrowSelect height="28" width="28" fill="#121212" />
          </span>
        </button>
        <select className=%twc("absolute left-0 w-full py-3 opacity-0") name ref onBlur onChange>
          {factoringList
          ->Array.map(((id, displayName)) =>
            <option key=id value=id> {displayName->React.string} </option>
          )
          ->React.array}
        </select>
      </div>
    </div>
    {error->Option.mapWithDefault(React.null, errMsg =>
      <ErrorText className=%twc("absolute") errMsg />
    )}
  </div>
}
