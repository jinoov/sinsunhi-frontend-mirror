@module("../../../public/assets/user-bnb-enabled.svg")
external userBnbEnabled: string = "default"

@module("../../../public/assets/user-bnb-disabled.svg")
external userBnbDisabled: string = "default"

@react.component
let make = (~selected) => {
  switch selected {
  | true => <img src=userBnbEnabled className=%twc("w-6 h-6") alt="마이페이지" />

  | false => <img src=userBnbDisabled className=%twc("w-6 h-6") alt="마이페이지" />
  }
}
