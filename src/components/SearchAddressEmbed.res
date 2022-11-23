@react.component
let make = (~onComplete, ~isShow, ~height=?, ~width=?) => {
  React.useLayoutEffect1(_ => {
    if isShow {
      open DaumPostCode
      open Webapi
      let iframeWrapper = Dom.document->Dom.Document.getElementById("iframe-embed-addr")
      let drawerHeaderHeight = 56

      switch iframeWrapper {
      | Some(iframeWrapper') => {
          let (w, h) = (
            iframeWrapper'->Dom.Element.clientWidth,
            Dom.window->Dom.Window.innerHeight - drawerHeaderHeight,
          )
          let option = makeOption(
            ~oncomplete=onComplete,
            ~width=width->Option.getWithDefault(w->Float.fromInt),
            ~height=height->Option.getWithDefault(h->Float.fromInt),
            ~submitMode=false,
            (),
          )
          let daumPostCode = option->make
          let openOption = makeEmbedOption(~q="", ~autoClose=true)
          daumPostCode->embedPostCode(iframeWrapper', openOption)
          iframeWrapper'->Dom.Element.setAttribute("style", "display: block;")
        }

      | _ => ()
      }
    }
    None
  }, [isShow])

  <div id="iframe-embed-addr" />
}
