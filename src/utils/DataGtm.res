@val @scope("window") @return(nullable)
external dataLayer: option<Js.Array2.t<{..}>> = "dataLayer"

let push = (data: {..}) => {
  switch dataLayer {
  | Some(layer) => layer->Js.Array2.push(data)->ignore
  | None => Js.Console.error("window.dataLayer is not defined")
  }
}

@react.component
let make = (~children, ~dataGtm: string) => {
  <ReactUtil.SpreadProps props={"data-gtm": dataGtm}> {children} </ReactUtil.SpreadProps>
}

// Object에 {"user_id": user.id}를 merge 합니다.
// user.id가 없는 경우 null을 merge 합니다.
let mergeUserIdUnsafe = data => {
  let userIdOrNull =
    CustomHooks.Auth.getUser()->Option.mapWithDefault(Js.Nullable.null, user =>
      Js.Nullable.return(user.id)
    )

  data->Js.Obj.assign({
    "user_id": userIdOrNull,
    "crm_id": userIdOrNull,
  })
}
