@module("../../../public/assets/heart-bnb-enabled.svg")
external heartBnbEnabled: string = "default"

@module("../../../public/assets/heart-bnb-disabled.svg")
external heartBnbDisabled: string = "default"

@react.component
let make = (~selected) => {
  switch selected {
  | true => <img src=heartBnbEnabled className=%twc("w-6 h-6") alt="관심상품" />

  | false => <img src=heartBnbDisabled className=%twc("w-6 h-6") alt="관심상품" />
  }
}
