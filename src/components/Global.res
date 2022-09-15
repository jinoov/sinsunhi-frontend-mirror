type window
let window: option<window> = %external(window)

module Window = {
  type windowName = string
  type windowFeatures = string
  @send
  external openLink: (
    window,
    ~url: string,
    ~windowName: windowName=?,
    ~windowFeatures: windowFeatures,
    unit,
  ) => unit = "open"

  @val @scope(("window", "navigator", "serviceWorker"))
  external serviceWorkerRegister: string => Js.Promise.t<Js.Nullable.t<'a>> = "register"

  module ReactNativeWebView = {
    type t
    @val @scope("window") @return(nullable)
    external tOpt: option<t> = "ReactNativeWebView"

    @send
    external postMessage: (t, string) => unit = "postMessage"

    // Airbridge
    // "VIEW_HOME"
    // "VIEW_PRODUCT_LIST"
    // "VIEW_PRODUCT_DETAIL"
    // "VIEW_SEARCH_RESULT"
    // "ADD_TO_CART"
    // "PURCHASE"
    // "CUSTOM_EVENT"
    module PostMessage = {
      let signUp = userId =>
        switch tOpt {
        | Some(webView) =>
          {"type": "SIGN_UP", "userId": userId}
          ->Js.Json.stringifyAny
          ->Option.forEach(payload => webView->postMessage(payload))
        | None => ()
        }
      let signIn = userId =>
        switch tOpt {
        | Some(webView) =>
          {"type": "SIGN_IN", "userId": userId}
          ->Js.Json.stringifyAny
          ->Option.forEach(payload => webView->postMessage(payload))
        | None => ()
        }
      let airbridgeWithPayload = (
        ~kind: [
          | #VIEW_HOME
          | #VIEW_PRODUCT_LIST
          | #VIEW_PRODUCT_DETAIL
          | #VIEW_SEARCH_RESULT
          | #ADD_TO_CART
          | #PURCHASE
          | #CUSTOM_EVENT
        ],
        ~payload=?,
        (),
      ) =>
        switch tOpt {
        | Some(webView) =>
          {"type": kind, "payload": payload}
          ->Js.Json.stringifyAny
          ->Option.forEach(payload => webView->postMessage(payload))
        | None => ()
        }
    }
  }
}

@val
external import_: string => Js.Promise.t<Js.Nullable.t<'a>> = "import"

@val @scope("window")
external jsAlert: string => unit = "alert"
