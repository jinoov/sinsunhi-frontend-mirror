module Select = {
  @react.component
  let make = (
    ~currentValue,
    ~values,
    ~register: HookForm.Register.t,
    ~className,
    ~defaultValue,
  ) => {
    let {name, onBlur, onChange, ref} = register
    let label = switch currentValue {
    | "" => defaultValue
    | _ => currentValue
    }

    <div>
      <label id="select" className=%twc("block text-sm font-medium text-gray-700") />
      <div className=%twc("relative")>
        <button
          type_="button"
          className={cx([
            %twc(
              "relative bg-white border rounded-lg py-1.5 px-3 border-border-default-L1 focus:outline-none focus:ring-1-gl remove-spin-button focus:border-gray-gl"
            ),
            className,
          ])}>
          <span className=%twc("flex items-center text-text-L1")>
            <span className=%twc("block truncate")> {label->React.string} </span>
          </span>
          <span className=%twc("absolute top-0.5 right-1")>
            <IconArrowSelect height="28" width="28" fill="#121212" />
          </span>
        </button>
        <select className=%twc("absolute left-0 w-full py-3 opacity-0") name ref onBlur onChange>
          {values
          ->Array.map(value => <option key=value value> {value->React.string} </option>)
          ->React.array}
        </select>
      </div>
    </div>
  }
}
