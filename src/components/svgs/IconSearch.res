@module("../../../public/assets/search.svg?react") @react.component
external make: (
  ~width: string,
  ~height: string,
  ~fill: string=?,
  ~className: string=?,
  ~stroke: string=?,
  ~strokeWidth: string=?,
) => React.element = "default"
