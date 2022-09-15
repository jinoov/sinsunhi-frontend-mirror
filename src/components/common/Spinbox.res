/*
 * Spinbox
 * [- 숫자 +] 형태의 스핀박스 인풋. -, + 버튼을 통해 숫자를 입력받는다.
 */

let setIntInRange = (number, min, max) => {
  if number < min {
    min
  } else if number > max {
    max
  } else {
    number
  }
}

@react.component
let make = (~min=1, ~max=999, ~value, ~onChange) => {
  let onChangeValue = e => {
    let parsed = switch (e->ReactEvent.Synthetic.target)["value"] {
    | "" => min->Some
    | nonEmptyStr =>
      nonEmptyStr
      ->Js.String2.replaceByRe(%re("/[^0-9]/g"), "")
      ->Int.fromString
      ->Option.map(v' => v'->setIntInRange(min, max))
    }

    parsed->Option.map(onChange)->ignore
  }

  <div className=%twc("w-[7.5rem] h-10 flex border rounded-xl divide-x")>
    <button
      className=%twc("w-9 flex items-center justify-center")
      onClick={_ => onChange(value - 1)}
      disabled={value == min}>
      <IconSpinnerMinus fill={value == min ? "#cccccc" : "#262626"} />
    </button>
    <div className=%twc("flex flex-1 items-center justify-center")>
      <input
        className=%twc("w-[46px] text-center focus:outline-none")
        value={value->Int.toString}
        onChange={onChangeValue}
      />
    </div>
    <button
      className=%twc("w-9 flex items-center justify-center")
      onClick={_ => onChange(value + 1)}
      disabled={value == max}>
      <IconSpinnerPlus fill={value == max ? "#cccccc" : "#262626"} />
    </button>
  </div>
}
