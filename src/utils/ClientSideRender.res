@react.component
let make = (~fallback, ~children) => {
  let isCsr = CustomHooks.useCsr()

  {
    switch isCsr {
    | false => fallback
    | true => children
    }
  }
}
