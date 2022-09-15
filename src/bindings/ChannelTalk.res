// <script async /> 로 로딩되는 ChannelIO가 window에 존재하지 않을 수 있다.
@val @scope("window") @return(nullable)
external makeExn: option<(. string, {..}) => unit> = "ChannelIO"

// window에 존재하지 않은 상황에서 호출되는 경우 ChannelIO를 사용할 수 없기 때문에
// interval을 이용하여 window에 ChannelIO가 있을 때까지 시도하고 실행한다.
let make = (. str, option) => {
  let id = ref(Js.Nullable.null)
  id := Js.Nullable.return(Js.Global.setInterval(_ => {
        switch makeExn {
        | Some(makeExn) => {
            id.contents->Js.Nullable.toOption->Option.forEach(Js.Global.clearInterval)
            makeExn(. str, option)
          }

        | None => ()
        }
      }, 200))
}

@val @scope("window") @return(nullable)
external makeWithCallbackExn: option<(. string, {..}, (_, {..}) => unit) => unit> = "ChannelIO"

let makeWithCallback = (. str, option, cb) => {
  let id = ref(Js.Nullable.null)
  id := Js.Nullable.return(Js.Global.setInterval(_ => {
        switch makeWithCallbackExn {
        | Some(makeWithCallback) => {
            id.contents->Js.Nullable.toOption->Option.forEach(Js.Global.clearInterval)
            makeWithCallback(. str, option, cb)
          }

        | None => ()
        }
      }, 200))
}

@val @scope("window") @return(nullable)
external trackExn: option<(. string, string, {..}) => unit> = "ChannelIO"

let track = (. str1, str2, option) => {
  let id = ref(Js.Nullable.null)
  id := Js.Nullable.return(Js.Global.setInterval(_ => {
        switch trackExn {
        | Some(track) => {
            id.contents->Js.Nullable.toOption->Option.forEach(Js.Global.clearInterval)
            track(. str1, str2, option)
          }

        | None => ()
        }
      }, 200))
}

@val @scope("window") @return(nullable)
external doExn: option<
  (. [#shutdown | #showMessenger | #showChannelButton | #hideChannelButton]) => unit,
> = "ChannelIO"

let do = (. action) => {
  let id = ref(Js.Nullable.null)
  id := Js.Nullable.return(Js.Global.setInterval(_ => {
        switch doExn {
        | Some(do) => {
            id.contents->Js.Nullable.toOption->Option.forEach(Js.Global.clearInterval)
            do(. action)
          }

        | None => ()
        }
      }, 200))
}

let shutdown = () => do(. #shutdown)
let showMessenger = () => do(. #showMessenger)
let showChannelButton = () => do(. #showChannelButton)
let hideChannelButton = () => do(. #hideChannelButton)
