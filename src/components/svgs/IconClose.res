@module("../../../public/assets/close.svg?react") @react.component
external make: (
  ~height: string,
  ~width: string,
  ~fill: string=?,
  ~stroke: string=?,
  ~strokeWidth: string=?,
) => React.element = "default"
