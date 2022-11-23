@module("../../public/images/push_dialog.svg")
external dialogImage: string = "default"

type rec braze = {
  initialize: (. string, config) => unit,
  requestPushPermission: (. unit) => unit,
  openSession: (. unit) => unit,
  changeUser: (. string) => unit,
  isPushSupported: unit => bool,
  isPushPermissionGranted: unit => bool,
  isPushBlocked: unit => bool,
  automaticallyShowInAppMessages: (. unit) => unit,
  getUser: unit => user,
  wipeData: (. unit) => unit,
}
and config = {
  baseUrl: string,
  enableLogging: bool,
  manageServiceWorkerExternally: bool,
  safariWebsitePushId: string,
}
and user = {getUserId: (. Js.Nullable.t<string> => unit) => unit}

let use = () => {
  let (braze, setBraze) = React.Uncurried.useState(_ => None)

  React.useEffect0(_ => {
    switch Global.Window.ReactNativeWebView.tOpt {
    | Some(_) => ()
    | None =>
      try {
        (Global.import_("@braze/web-sdk")
        |> Js.Promise.then_((sdk: Js.Nullable.t<braze>) => {
          setBraze(. _ => sdk->Js.Nullable.toOption)
          Js.Promise.resolve()
        })
        |> Js.Promise.catch(err => {
          Js.log2("braze init error: ", err)
          Js.Promise.resolve()
        }))->ignore
      } catch {
      | err => Js.log2("fail to initize braze: ", err)
      }
    }

    None
  })

  React.useEffect1(_ => {
    switch Global.Window.ReactNativeWebView.tOpt {
    | Some(_) => ()
    | None =>
      let _ = try {
        Global.Window.serviceWorkerRegister("/service-worker.js")
        |> Js.Promise.then_(_ => {
          switch braze {
          // (주의) 서비스워커가 등록된 다음에 세션을 오픈해야함
          | Some(braze') => braze'.openSession(.)
          | None => ()
          }
          Js.Promise.resolve()
        })
        |> Js.Promise.catch(err => {
          Js.log2("Failed to register service worker : ", err)
          Js.Promise.resolve()
        })
      } catch {
      | err => {
          Js.log2("fail to initize braze: ", err)
          Js.Promise.resolve()
        }
      }

      switch braze {
      | Some(braze') =>
        braze'.initialize(.
          Env.brazeWebApiKey,
          {
            baseUrl: "sdk.iad-06.braze.com",
            enableLogging: false, // 로그를 확인하려면 true로 바꿔서 사용 (배포전에는 반드시 false)
            manageServiceWorkerExternally: true,
            safariWebsitePushId: "web.com.sinsunhi.app",
          },
        )
      | None => ()
      }
    }

    None
  }, [braze])

  braze
}

let changeUser = (user: CustomHooks.Auth.user, braze) => {
  switch user.role {
  | Seller
  | Buyer =>
    switch Env.vercelEnv {
    | "production" => braze.changeUser(. user.id->Int.toString)
    | _ => braze.changeUser(. `${user.id->Int.toString}-dev`)
    }
  | Admin | ExternalStaff => ()
  }
}

open Webapi
module PushNotificationRequestDialog = {
  let trigger = () => {
    let dialogTrigger = Dom.document->Dom.Document.getElementById("braze-notification-trigger")
    dialogTrigger
    ->Option.flatMap(dialogTrigger' => {
      dialogTrigger'->Dom.Element.asHtmlElement
    })
    ->Option.forEach(dialogTrigger' => {
      dialogTrigger'->Dom.HtmlElement.click
    })
    ->ignore
  }

  @react.component
  let make = () => {
    // braze Init
    let braze = use()
    let user = CustomHooks.Auth.use()

    let (availableShow, setAvailableShow) = React.Uncurried.useState(_ => false)
    let (show, setShow) = React.Uncurried.useState(_ => false)

    let requestPushNotification = _ => {
      setShow(._ => false)
      switch (Global.Window.ReactNativeWebView.tOpt, braze, user) {
      | (None, Some(braze'), LoggedIn(user')) =>
        // 참고 사항
        // 유저가 동록되어 있는 상태에서 푸시 허가를 물어봐야한다.
        // 그렇지 않으면 허락한 시점의 유저를 braze가 찾지 못해 푸시 메세지를 보내지 못한다.
        changeUser(user', braze')
        braze'.requestPushPermission(.)
      | _ => ()
      }
    }

    React.useEffect2(_ => {
      braze->Option.forEach(braze' =>
        setAvailableShow(.
          _ =>
            braze'.isPushSupported() &&
            !braze'.isPushPermissionGranted() &&
            !braze'.isPushBlocked(),
        )
      )
      None
    }, (braze, show))

    <RadixUI.Dialog.Root _open={show && availableShow}>
      <RadixUI.Dialog.Trigger
        onClick={_ => setShow(._ => true)} id="braze-notification-trigger" className=%twc("hidden")>
        {j``->React.string}
      </RadixUI.Dialog.Trigger>
      <RadixUI.Dialog.Portal>
        <RadixUI.Dialog.Overlay className=%twc("dialog-overlay") />
        <RadixUI.Dialog.Content
          onOpenAutoFocus={ReactEvent.Synthetic.preventDefault} // 자동으로 버튼에 포커스되는 것을 막기위함
          className=%twc(
            "dialog-content-fix rounded-xl w-fit flex flex-col items-center justify-center pb-7"
          )>
          <img src=dialogImage className=%twc("rounded-xl") alt={`push-notification-dialog`} />
          <div className=%twc("mt-5 flex justify-center items-center gap-2 text-[17px]")>
            <button
              type_="button"
              onClick={_ => setShow(._ => false)}
              className=%twc("w-36 h-13 rounded-xl bg-enabled-L5 text-enabled-L1")>
              {"나중에"->React.string}
            </button>
            <button
              type_="button"
              onClick={requestPushNotification}
              className=%twc("w-36 h-13 rounded-xl bg-primary text-inverted font-bold")>
              {"알림동의"->React.string}
            </button>
          </div>
        </RadixUI.Dialog.Content>
      </RadixUI.Dialog.Portal>
    </RadixUI.Dialog.Root>
  }
}
