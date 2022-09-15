let setHref = path =>
  %external(window)
  ->Option.map(_ => {
    open Webapi
    Dom.location->Dom.Location.setHref(path)
  })
  ->ignore

let redirectByRole = () => {
  open Webapi
  let currentPathname = Dom.location->Dom.Location.pathname
  let firstPath = currentPathname->Js.String2.split("/")->Array.keep(x => x != "")->Array.get(0)
  let signInUrl = switch firstPath {
  | Some("seller") => `/seller/signin?redirect=${currentPathname}`
  | Some("admin") => `/admin/signin?redirect=${currentPathname}`
  | Some("buyer") | _ => `/buyer/signin?redirect=${currentPathname}`
  }

  setHref(signInUrl)
}

@react.component
let make = (~path, ~message=?) => {
  React.useEffect0(() => {
    setHref(path)
    None
  })
  <div>
    {switch message {
    | Some(m) => m->React.string
    | None =>
      <div className="container mx-auto flex justify-center items-center h-screen">
        {`페이지 전환 중 입니다.`->React.string}
      </div>
    }}
  </div>
}
