module Main: {
  @react.component
  let make: unit => React.element
}

module Stack: {
  @react.component
  let make: (~title: string=?, ~right: React.element=?, ~className: string=?) => React.element
}
