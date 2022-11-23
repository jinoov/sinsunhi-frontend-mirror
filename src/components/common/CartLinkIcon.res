module Query = %relay(`
  query CartLinkIconQuery {
    cartItemCount
  }
`)

@module("../../../public/assets/icon_cart.svg")
external cartIcon: string = "default"

module PlaceHolder = {
  @react.component
  let make = () =>
    <Next.Link href="/buyer/cart">
      <a>
        <img
          src=cartIcon
          alt={`cart-icon`}
          className=%twc("w-6 h-6 min-w-[32px] min-h-[32px] place-self-center")
        />
      </a>
    </Next.Link>
}

module NotLoggedIn = {
  @react.component
  let make = () => {
    let (showLogin, setShowLogin) = React.Uncurried.useState(_ => false)

    let router = Next.Router.useRouter()

    let isSignInPage =
      router.pathname
      ->Js.String2.split("/")
      ->Array.keep(x => x !== "")
      ->Garter.Array.get(1)
      ->Option.mapWithDefault(false, path => path == "signin")

    <>
      <RadixUI.Dialog.Root _open=showLogin>
        <RadixUI.Dialog.Portal>
          <RadixUI.Dialog.Overlay className=%twc("dialog-overlay") />
          <RadixUI.Dialog.Content
            className=%twc(
              "dialog-content p-7 bg-white rounded-xl w-[480px] flex flex-col gap-7 items-center justify-center"
            )
            onOpenAutoFocus={ReactEvent.Synthetic.preventDefault}>
            <span className=%twc("whitespace-pre text-center text-text-L1 pt-3")>
              {`로그인 후에
확인하실 수 있습니다`->React.string}
            </span>
            <div className=%twc("flex w-full justify-center items-center gap-2")>
              <button
                className=%twc(
                  "w-1/2 h-13 rounded-xl flex items-center justify-center bg-enabled-L5"
                )
                onClick={ReactEvents.interceptingHandler(_ => setShowLogin(._ => false))}>
                {`닫기`->React.string}
              </button>
              <button // Next.Link를 안쓰는 이유: 로그인 페이지에서 href="~/signin ~"으로 하면 다이어로그 동작을 하지 않기 때문 == 같은 url이라서
                onClick={ReactEvents.interceptingHandler(_ => {
                  setShowLogin(._ => false)
                  switch isSignInPage {
                  | true => ()
                  | false => router->Next.Router.push("/buyer/signin?redirect=/buyer/cart")
                  }
                })}
                className=%twc(
                  "w-1/2 h-13 rounded-xl flex items-center justify-center bg-primary hover:bg-primary-variant text-white font-bold"
                )>
                {`로그인`->React.string}
              </button>
            </div>
          </RadixUI.Dialog.Content>
        </RadixUI.Dialog.Portal>
      </RadixUI.Dialog.Root>
      <button type_="button" onClick={_ => setShowLogin(._ => true)}>
        <img src=cartIcon alt={`cart-icon`} className=%twc("w-6 h-6 min-w-[32px] min-h-[32px]") />
      </button>
    </>
  }
}

module Container = {
  @react.component
  let make = () => {
    let queryData = Query.use(~variables=(), ~fetchPolicy=RescriptRelay.StoreAndNetwork, ())
    let router = Next.Router.useRouter()
    // '현재 장바구니에 몇개 남겨있는지 or 담겨있는지 아닌지' 상태를 조회하여 표시
    // 적용 되어야하는 페이지 (메인, PLP, 전용관-신선배송만, 기획전(못찾음), PDP)

    <DataGtm dataGtm="click_cart">
      <button
        type_="button"
        className=%twc("relative w-6 h-6 min-w-[32px] min-h-[32px] place-self-center")
        onClick={_ => router->Next.Router.push("/buyer/cart")}>
        {switch queryData.cartItemCount {
        | 0 => React.null
        | count =>
          <div
            className={cx([
              %twc(
                "flex justify-center items-center rounded-[10px] bg-emphasis h-4 text-white text-xs absolute font-bold -top-1 leading-[14.4px]"
              ),
              switch count >= 10 {
              | true => %twc("-right-2 w-[23px]")
              | false => %twc("-right-1 w-4")
              },
            ])}>
            {count->Int.toString->React.string}
          </div>
        }}
        <img
          src=cartIcon
          alt={`cart-icon`}
          className=%twc("w-6 h-6 min-w-[32px] min-h-[32px] place-self-center")
        />
      </button>
    </DataGtm>
  }
}

@react.component
let make = () => {
  let user = CustomHooks.Auth.use()

  let isLoggedIn = switch user {
  | LoggedIn(user') if user'.role == Buyer => Some(true)
  | LoggedIn(_)
  | NotLoggedIn =>
    Some(false)
  | Unknown => None
  }

  switch isLoggedIn {
  | Some(true) =>
    <React.Suspense fallback={<PlaceHolder />}>
      <Container />
    </React.Suspense>

  | Some(false) => <NotLoggedIn />
  | None => <PlaceHolder />
  }
}
