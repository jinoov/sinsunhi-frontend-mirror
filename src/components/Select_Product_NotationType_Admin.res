module type Status = {
  type status

  let options: array<status>
  let toDisplay: status => string
  let status_encode: status => Js.Json.t
  let status_decode: Js.Json.t => Result.t<status, Spice.decodeError>
}

module Select = (Status: Status) => {
  include Status

  let toString = status => status->status_encode->Js.Json.decodeString

  let defaultStyle = %twc(
    "flex px-3 py-2 border items-center border-border-default-L1 rounded-lg h-9 text-enabled-L1 focus:outline"
  )

  @react.component
  let make = (~status, ~onChange, ~forwardRef: ReactDOM.domRef, ~disabled=?) => {
    let displayStatus =
      status
      ->Option.map(Status.toDisplay)
      ->Option.getWithDefault(`필수 표기정보 유형 선택`)

    let value = status->Option.flatMap(toString)->Option.getWithDefault("")

    let handleProductOperationStatus = e => {
      let status = (e->ReactEvent.Synthetic.target)["value"]

      switch status->status_decode {
      | Ok(status') => onChange(status')
      | _ => ignore()
      }
    }

    <span>
      <label className=%twc("block relative")>
        <span
          className={disabled->Option.mapWithDefault(cx([defaultStyle, %twc("bg-white")]), d =>
            d ? cx([defaultStyle, %twc("bg-disabled-L3")]) : cx([defaultStyle, %twc("bg-white")])
          )}>
          {displayStatus->React.string}
        </span>
        <span className=%twc("absolute top-1.5 right-2")>
          <IconArrowSelect height="24" width="24" fill="#121212" />
        </span>
        <select
          value
          className=%twc("block w-full h-full absolute top-0 opacity-0")
          onChange={handleProductOperationStatus}
          ?disabled
          ref={forwardRef}>
          <option value="" disabled=true hidden={value == "" ? false : true}>
            {`필수 표기정보 유형 선택`->React.string}
          </option>
          {Status.options
          ->Array.map(s => {
            let value = s->toString->Option.getWithDefault("")
            <option key={value} value> {s->Status.toDisplay->React.string} </option>
          })
          ->React.array}
        </select>
      </label>
    </span>
  }
}
module NotationStatus = {
  @spice
  type status =
    | @spice.as(`PROCESSED_FOOD`) PROCESSED_FOOD
    | @spice.as(`WHOLE_FOOD`) WHOLE_FOOD

  let toDisplay = status =>
    switch status {
    | WHOLE_FOOD => `농축수산물`
    | PROCESSED_FOOD => `가공식품`
    }

  let options = [PROCESSED_FOOD, WHOLE_FOOD]
}

module Notation = Select(NotationStatus)
