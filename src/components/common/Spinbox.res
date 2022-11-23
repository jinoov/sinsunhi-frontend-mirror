/*
 * Spinbox
 * [- 숫자 +] 형태의 스핀박스 인풋. -, + 버튼 및 키보드 타이핑을 통해 숫자를 입력받는다.
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

let maxQuantity = 999

@react.component
let make = (~min=1, ~max=maxQuantity, ~value, ~onChange, ~onOverMaxQuantity=() => ()) => {
  let onChangeFromTyping = e => {
    let inputValue: string = (e->ReactEvent.Synthetic.target)["value"]

    let parseValue = v => v === "" ? min->Int.toString : v
    let validateValueForNumber = v => v->Js.String2.replaceByRe(%re("/[^0-9]/g"), "")

    let nextValue = inputValue->parseValue->validateValueForNumber->Int.fromString
    let finalValue = nextValue->Option.map(v => v->setIntInRange(min, max))

    nextValue->Option.map(x => x > max ? onOverMaxQuantity() : ())->ignore
    finalValue->Option.map(onChange)->ignore
  }

  <div className=%twc("w-[7.5rem] h-10 flex border rounded-xl divide-x")>
    <button
      className=%twc("w-9 flex items-center justify-center")
      onClick={_ => onChange(value - 1)}
      disabled={value == min}>
      <div>
        <Formula.Icon.MinusLineRegular color=#"gray-90" size=#lg />
      </div>
    </button>
    <div className=%twc("flex flex-1 items-center justify-center")>
      <input
        className=%twc("w-[46px] text-center focus:outline-none")
        value={value->Int.toString}
        onChange={onChangeFromTyping}
      />
    </div>
    <button
      className=%twc("w-9 flex items-center justify-center")
      onClick={_ => {
        let nextValue = value + 1
        switch nextValue > max {
        | true => onOverMaxQuantity()
        | false => onChange(nextValue)
        }
      }}>
      <div>
        <Formula.Icon.PlusLineRegular color=#"gray-90" size=#lg />
      </div>
    </button>
  </div>
}
