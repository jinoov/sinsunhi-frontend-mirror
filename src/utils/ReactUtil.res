module SpreadProps = {
  @react.component
  let make = (~children, ~props) => {
    React.cloneElement(children, props)
  }
}

let focusElementByRef = (ref: React.ref<Js.Nullable.t<'a>>) => {
  open Webapi.Dom
  let htmlInputElement =
    ref.current->Js.Nullable.toOption->Option.flatMap(HtmlInputElement.ofElement)

  htmlInputElement->Option.forEach(HtmlInputElement.focus)
}

let setValueElementByRef = (ref: React.ref<Js.Nullable.t<'a>>, value) => {
  open Webapi.Dom
  let htmlInputElement =
    ref.current->Js.Nullable.toOption->Option.flatMap(HtmlInputElement.ofElement)

  htmlInputElement->Option.forEach(el => el->HtmlInputElement.setValue(value))
}

module Component = {
  @react.component
  let make = (~as_, ~props=Js.Obj.empty(), ~children=?) =>
    React.createElement(as_, Js.Obj.assign({"children": children}, props))
}
