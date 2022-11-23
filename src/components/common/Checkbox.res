@module("../../../public/assets/input-check.svg")
external inputCheckIcon: string = "default"

@react.component
let make = (~id=?, ~name=?, ~checked=?, ~onChange=?, ~disabled=?, ~alt=?) => {
  let style = switch disabled {
  | Some(true) =>
    %twc(
      "w-5 h-5 border-2 border-gray-200 bg-gray-100 rounded-[5px] flex justify-center items-center"
    )
  | Some(false)
  | None =>
    switch checked {
    | Some(true) =>
      %twc("w-5 h-5 bg-green-gl rounded-[5px] flex justify-center items-center cursor-pointer")
    | Some(false) =>
      %twc(
        "w-5 h-5 bg-white border-2 border-gray-300 rounded-[5px] flex justify-center items-center cursor-pointer"
      )
    | None =>
      %twc(
        "w-5 h-5 border-2 border-gray-200 bg-gray-100 rounded-[5px] flex justify-center items-center"
      )
    }
  }

  <>
    <input type_="checkbox" ?id ?name className=%twc("hidden") ?checked ?onChange ?disabled />
    <label htmlFor={id->Option.getWithDefault("")} className=style>
      {checked->Option.mapWithDefault(React.null, checked' =>
        checked'
          ? <img
              className=%twc("w-[14px] h-3") src=inputCheckIcon alt={alt->Option.getWithDefault("")}
            />
          : React.null
      )}
    </label>
  </>
}

module Uncontrolled = {
  @react.component
  let make = (
    ~id=?,
    ~name=?,
    ~defaultChecked=?,
    ~onBlur=?,
    ~onChange=?,
    ~disabled=?,
    ~readOnly=?,
    ~inputRef=?,
  ) => {
    module PeerStyles = {
      let default = %twc("peer-default:bg-white border-2 peer-default:border-gray-300 ")
      let checked = %twc("peer-checked:bg-green-gl ")
      let disabled = %twc(
        "peer-disabled:border-2 peer-disabled:border-gray-200 peer-disabled:bg-gray-100"
      )
    }

    <>
      <input
        type_="checkbox"
        ?id
        ?name
        className={"peer " ++ %twc("hidden")}
        ?defaultChecked
        ?onChange
        ?onBlur
        ?disabled
        ?readOnly
        ref=?inputRef
      />
      <label
        htmlFor={id->Option.getWithDefault("")}
        className={%twc("w-5 h-5 rounded-[5px] flex justify-center items-center ") ++
        PeerStyles.default ++
        PeerStyles.checked ++
        PeerStyles.disabled}>
        <Formula.Icon.CheckLineBold color=#white size=#sm />
      </label>
    </>
  }
}
