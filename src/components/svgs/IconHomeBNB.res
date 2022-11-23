@module("../../../public/assets/home-bnb-enabled.svg")
external homeBnbEnabled: string = "default"

@module("../../../public/assets/home-bnb-disabled.svg")
external homeBnbDisabled: string = "default"

@react.component
let make = (~selected) => {
  switch selected {
  | true => <img src=homeBnbEnabled className=%twc("w-6 h-6") alt="홈" />

  | false => <img src=homeBnbDisabled className=%twc("w-6 h-6") alt="홈" />
  }
}
