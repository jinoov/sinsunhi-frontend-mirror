@react.component
let make = (~className=?, ~errMsg) => {
  <span className={%twc("flex items-center ") ++ className->Option.getWithDefault("")}>
    <IconError width="20" height="20" />
    <span className=%twc("text-sm text-notice ml-1")> {errMsg->React.string} </span>
  </span>
}
