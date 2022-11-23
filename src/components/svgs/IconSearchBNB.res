@module("../../../public/assets/search-bnb-enabled.svg")
external searchBnbEnabled: string = "default"

@module("../../../public/assets/search-bnb-disabled.svg")
external searchBnbDisabled: string = "default"

@react.component
let make = (~selected) => {
  switch selected {
  | true => <img src=searchBnbEnabled className=%twc("w-6 h-6") alt="검색" />

  | false => <img src=searchBnbDisabled className=%twc("w-6 h-6") alt="검색" />
  }
}
