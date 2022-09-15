module QuotationType = {
  @spice
  type t =
    | @spice.as(`TRADEMATCH_AQUATIC`) TRADEMATCH_AQUATIC // 수산견적
    | @spice.as(`RFQ_LIVESTOCK`) RFQ_LIVESTOCK // 축산견적

  let makeLabel = v => {
    switch v {
    | TRADEMATCH_AQUATIC => `수산견적`
    | RFQ_LIVESTOCK => `축산견적`
    }
  }

  let stringify = v => {
    switch v {
    | #TRADEMATCH_AQUATIC => "TRADEMATCH_AQUATIC"
    | #RFQ_LIVESTOCK => "RFQ_LIVESTOCK"
    | _ => ""
    }
  }
}

@react.component
let make = (~status, ~onChange, ~forwardRef: ReactDOM.domRef, ~disabled=?) => {
  let label =
    status->Option.map(QuotationType.makeLabel)->Option.getWithDefault(`견적 유형 선택`)

  let value =
    status
    ->Option.flatMap(v => v->QuotationType.t_encode->Js.Json.decodeString)
    ->Option.getWithDefault("")

  let handleChange = e => {
    (e->ReactEvent.Synthetic.target)["value"]->QuotationType.t_decode->Result.map(onChange)->ignore
  }

  let defaultStyle = %twc(
    "flex px-3 py-2 border items-center border-border-default-L1 rounded-lg h-9 text-enabled-L1 focus:outline"
  )

  <span>
    <label className=%twc("block relative")>
      <span
        className={disabled->Option.mapWithDefault(cx([defaultStyle, %twc("bg-white")]), d =>
          d
            ? cx([defaultStyle, %twc("bg-disabled-L3 text-gray-400")])
            : cx([defaultStyle, %twc("bg-white")])
        )}>
        {label->React.string}
      </span>
      <span className=%twc("absolute top-1.5 right-2")>
        <IconArrowSelect height="24" width="24" fill="#121212" />
      </span>
      <select
        ref=forwardRef
        value
        onChange=handleChange
        className=%twc("block w-full h-full absolute top-0 opacity-0")
        ?disabled>
        <option value="" disabled=true hidden={value == "" ? false : true}>
          {`견적 유형 선택`->React.string}
        </option>
        {[QuotationType.TRADEMATCH_AQUATIC, RFQ_LIVESTOCK]
        ->Array.map(v => {
          let value = v->QuotationType.t_encode->Js.Json.decodeString->Option.getWithDefault("")
          <option key={value} value> {v->QuotationType.makeLabel->React.string} </option>
        })
        ->React.array}
      </select>
    </label>
  </span>
}
