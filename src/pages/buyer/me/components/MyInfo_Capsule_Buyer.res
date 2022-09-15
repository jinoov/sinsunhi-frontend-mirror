@react.component
let make = (~content) => {
  <div className=%twc("text-primary bg-primary-light px-2 rounded text-sm")>
    {content->React.string}
  </div>
}
