@module("../../../../../public/assets/sinsunhi-logo-renewal.svg")
external sinsunhiLogo: string = "default"

@module("../../../../../public/assets/header-heart.svg")
external heartIcon: string = "default"

@module("../../../../../public/assets/header-heart-selected.svg")
external heartSelectedIcon: string = "default"

@module("../../../../../public/assets/header-user.svg")
external userIcon: string = "default"

@module("../../../../../public/assets/header-user-selected.svg")
external userSelectedIcon: string = "default"

@module("../../../../../public/assets/header-cart.svg")
external cartIcon: string = "default"

@module("../../../../../public/assets/header-cart-selected.svg")
external cartSelectedIcon: string = "default"

module Buyer = {
  module Item = {
    @react.component
    let make = (~href, ~selected, ~icon, ~label) => {
      let buttonStyle = cx([
        %twc(
          "inline-flex h-14 items-center text-[#8B8D94] text-[15px] px-4  rounded-2xl mr-2 hover:bg-[#1F20240A] active:bg-[#1F202414] duration-200 ease-in-out"
        ),
        selected
          ? %twc("bg-[#1F20240A] hover:bg-[#1F202414] text-[#1F2024]")
          : %twc("bg-transparent"),
      ])

      <Next.Link href passHref=true>
        <a className=buttonStyle>
          <img src=icon className=%twc("w-6 h-6 mr-1") alt=label />
          {label->React.string}
        </a>
      </Next.Link>
    }
  }
  module CartItem = {
    @react.component
    let make = (~selected, ~icon, ~label) => {
      let (showLogin, setShowLogin) = React.Uncurried.useState(_ => false)

      let router = Next.Router.useRouter()

      let isSignInPage =
        router.pathname
        ->Js.String2.split("/")
        ->Array.keep(x => x !== "")
        ->Garter.Array.get(1)
        ->Option.mapWithDefault(false, path => path == "signin")

      let buttonStyle = cx([
        %twc(
          "inline-flex h-14 items-center text-[#8B8D94] text-[15px] px-4  rounded-2xl mr-2 hover:bg-[#1F20240A] active:bg-[#1F202414] duration-200 ease-in-out"
        ),
        selected
          ? %twc("bg-[#1F20240A] hover:bg-[#1F202414] text-[#1F2024]")
          : %twc("bg-transparent"),
      ])

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
        <button type_="button" onClick={_ => setShowLogin(._ => true)} className=buttonStyle>
          <img src=icon className=%twc("w-6 h-6 mr-1") alt=label />
          {label->React.string}
        </button>
      </>
    }
  }
  module AuthSection = {
    module Skeleton = {
      @react.component
      let make = () => {
        <div className=%twc("animate-pulse rounded-lg w-[70px] h-10 bg-gray-100") />
      }
    }
    module LogoutButton = {
      @react.component
      let make = () => {
        let (showLogoutDialog, setShowLogoutDialog) = React.Uncurried.useState(_ => Dialog.Hide)

        let onClick = _ => {
          setShowLogoutDialog(._ => Dialog.Show)
        }

        let onCancel = _ => {
          setShowLogoutDialog(._ => Dialog.Hide)
        }

        <>
          <button
            className=%twc("flex h-10 px-4 justify-center items-center bg-[#F0F2F5] rounded-lg")
            onClick>
            {`로그아웃`->React.string}
          </button>
          <PC_LogoutDialog isOpen=showLogoutDialog onCancel />
        </>
      }
    }
    module LoginButton = {
      @react.component
      let make = () => {
        <Next.Link href="/buyer/signin" passHref=true>
          <a>
            <div
              className=%twc(
                "flex h-10 px-4 justify-center items-center bg-green-gl rounded-lg text-white hover:bg-[#189346] active:bg-[#168040] ease-in-out duration-200"
              )>
              {`로그인`->React.string}
            </div>
          </a>
        </Next.Link>
      }
    }

    @react.component
    let make = (~currentPath) => {
      let user = CustomHooks.Auth.use()
      let isCsr = CustomHooks.useCsr()
      switch isCsr {
      | true =>
        switch user {
        | LoggedIn(_) =>
          <>
            <Item
              href="/saved-products?selected=like"
              selected={currentPath == #SavedProducts}
              icon={currentPath == #SavedProducts ? heartSelectedIcon : heartIcon}
              label="저장한 상품"
            />
            <Item
              href="/buyer/me"
              selected={currentPath == #MyInfo}
              icon={currentPath == #MyInfo ? userSelectedIcon : userIcon}
              label="마이페이지"
            />
            <Item
              href="/buyer/cart"
              selected={currentPath == #Cart}
              icon={currentPath == #Cart ? cartSelectedIcon : cartIcon}
              label="장바구니"
            />
            <LogoutButton />
          </>
        | NotLoggedIn =>
          <>
            <Item
              href="/buyer/signin?redirect=/saved-products?selected=like"
              selected={currentPath == #SavedProducts}
              icon={currentPath == #SavedProducts ? heartSelectedIcon : heartIcon}
              label="저장한 상품"
            />
            <Item
              href="/buyer/signin?redirect=/buyer/me"
              selected={currentPath == #MyInfo}
              icon={currentPath == #MyInfo ? userSelectedIcon : userIcon}
              label="마이페이지"
            />
            <CartItem
              selected={currentPath == #Cart}
              icon={currentPath == #Cart ? cartSelectedIcon : cartIcon}
              label="장바구니"
            />
            <LoginButton />
          </>
        | _ => <Skeleton />
        }
      | false => <Skeleton />
      }
    }
  }

  module Placeholder = {
    @react.component
    let make = () => {
      <div
        className=%twc(
          "w-full flex flex-col border-b-[1px] border-[#F0F2F5] sticky top-0 bg-white z-10 pc-content"
        )>
        <div
          className=%twc("flex flex-row h-[84px] bg-white justify-between items-center px-[60px]")>
          <div className=%twc("inline-flex items-center")>
            <Next.Link href="/" passHref=true>
              <a className=%twc("mr-[60px]")>
                <img src=sinsunhiLogo className=%twc("h-8 w-[114px] ") alt="신선하이 홈" />
              </a>
            </Next.Link>
            <PC_SearchInput_Buyer.Placeholder />
          </div>
          <div className=%twc("inline-flex items-center")>
            <AuthSection.Skeleton />
          </div>
        </div>
        <GnbBannerList_Buyer.Placeholder />
      </div>
    }
  }

  @react.component
  let make = () => {
    let router = Next.Router.useRouter()
    let currentPath = switch router.pathname
    ->Js.String2.split("/")
    ->Garter.Array.slice(~offset=1, ~len=2) {
    | ["saved-products"] => #SavedProducts
    | ["buyer", "me"] => #MyInfo
    | ["buyer", "cart"] => #Cart
    | _ => #none
    }

    <div
      className=%twc(
        "w-full flex flex-col border-b-[1px] border-[#F0F2F5] sticky top-0 bg-white z-10 pc-content"
      )>
      <div className=%twc("flex flex-row h-[84px] bg-white justify-between items-center px-[60px]")>
        <div className=%twc("inline-flex items-center")>
          <Next.Link href="/" passHref=true>
            <a className=%twc("mr-[60px]")>
              <img src=sinsunhiLogo className=%twc("h-8 w-[114px] ") alt="신선하이 홈" />
            </a>
          </Next.Link>
          <PC_SearchInput_Buyer />
        </div>
        <div className=%twc("inline-flex items-center")>
          <React.Suspense fallback={<AuthSection.Skeleton />}>
            <AuthSection currentPath />
          </React.Suspense>
        </div>
      </div>
      <GnbBannerList_Buyer />
    </div>
  }
}
