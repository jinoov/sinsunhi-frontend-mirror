@module("../../../public/assets/hamburger-bnb-enabled.svg")
external hamburgerBnbEnabled: string = "default"

@module("../../../public/assets/hamburger-bnb-disabled.svg")
external hamburgerBnbDisabled: string = "default"

@react.component
let make = (~selected) => {
  switch selected {
  | true => <img src={hamburgerBnbEnabled} className=%twc("w-6 h-6") alt="메뉴" />

  | false => <img src={hamburgerBnbDisabled} className=%twc("w-6 h-6") alt="메뉴" />
  }
}
