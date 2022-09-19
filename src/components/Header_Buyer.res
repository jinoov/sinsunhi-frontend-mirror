/*
 * 1. 컴포넌트 위치
 *    바이어 상단 Gnb
 *
 * 2. 역할
 *    바이어 페이지의 공통 헤더로써 네비게이션을 제공합니다
 *
 */
module Mobile = {
  module LoggedInUserMenu = {
    @react.component
    let make = () => {
      <>
        <CartLinkIcon />
        <Next.Link href="/buyer/me">
          <a>
            <img
              src="/icons/user-gray-circle-3x.png"
              className=%twc("w-7 h-7 object-cover ml-2")
              alt="user-icon"
            />
          </a>
        </Next.Link>
      </>
    }
  }

  module Normal = {
    @react.component
    let make = (~title) => {
      let router = Next.Router.useRouter()
      <>
        // position fixed
        <div className=%twc("w-full fixed top-0 left-0 z-10 bg-white")>
          <header className=%twc("w-full max-w-3xl mx-auto h-14 bg-white")>
            <div className=%twc("px-5 py-4 flex justify-between")>
              <button type_="button" onClick={_ => router->Next.Router.back}>
                <img src="/assets/arrow-right.svg" className=%twc("w-6 h-6 rotate-180") />
              </button>
              <div>
                <span className=%twc("font-bold text-xl")> {title->React.string} </span>
              </div>
              <HomeLinkIcon />
            </div>
          </header>
        </div>
        // placeholder
        <div className=%twc("w-full h-14") />
      </>
    }
  }

  module BackAndCart = {
    @react.component
    let make = (~title) => {
      let router = Next.Router.useRouter()
      <>
        // position fixed
        <div className=%twc("w-full fixed top-0 left-0 z-10 bg-white")>
          <header className=%twc("w-full max-w-3xl mx-auto h-14 bg-white")>
            <div className=%twc("px-5 py-4 flex items-center")>
              <div className=%twc("w-1/3 flex justify-start")>
                <button type_="button" onClick={_ => router->Next.Router.back}>
                  <img src="/assets/arrow-right.svg" className=%twc("w-6 h-6 rotate-180") />
                </button>
              </div>
              <div className=%twc("w-1/3 flex justify-center")>
                <span className=%twc("font-bold text-xl")> {title->React.string} </span>
              </div>
              <div className=%twc("w-1/3 flex gap-2 justify-end")>
                <CartLinkIcon />
                <HomeLinkIcon />
              </div>
            </div>
          </header>
        </div>
        // placeholder
        <div className=%twc("w-full h-14") />
      </>
    }
  }

  // 뒤로가기 버튼이 없는 해더
  module NoBack = {
    @react.component
    let make = (~title) => <>
      // position fixed
      <div className=%twc("w-full fixed top-0 left-0 z-10 bg-white")>
        <header className=%twc("w-full max-w-3xl mx-auto h-14 bg-white")>
          <div className=%twc("px-5 py-4 flex justify-between")>
            <div className=%twc("w-[24px]") />
            <div>
              <span className=%twc("font-bold text-xl")> {title->React.string} </span>
            </div>
            <HomeLinkIcon />
          </div>
        </header>
      </div>
      // placeholder
      <div className=%twc("w-full h-14") />
    </>
  }

  module NoHome = {
    @react.component
    let make = (~title) => {
      let router = Next.Router.useRouter()

      <>
        // position fixed
        <div className=%twc("w-full fixed top-0 left-0 z-10 bg-white")>
          <header className=%twc("w-full max-w-3xl mx-auto h-14 bg-white")>
            <div className=%twc("px-5 py-4 flex justify-between")>
              <button type_="button" onClick={_ => router->Next.Router.back}>
                <IconArrow height="24" width="24" fill="#262626" className=%twc("rotate-180") />
              </button>
              <div>
                <span className=%twc("font-bold text-xl")> {title->React.string} </span>
              </div>
              <div className=%twc("w-6") />
            </div>
          </header>
        </div>
        // placeholder
        <div className=%twc("w-full h-14") />
      </>
    }
  }

  module GnbHome = {
    @react.component
    let make = (~gnbBanners=?, ~displayCategories=?) => {
      let router = Next.Router.useRouter()

      let (isCsr, setCsr) = React.Uncurried.useState(_ => false)
      let user = CustomHooks.User.Buyer.use2()

      // category select 내에 query 때문에 ssr 이용시 hydration mismatch error 발생
      // csr 사용
      React.useEffect0(_ => {
        setCsr(._ => true)
        None
      })

      <div className=%twc("w-full bg-white")>
        <header className=%twc("w-full max-w-3xl mx-auto h-14 flex items-center px-3 bg-white")>
          <div className=%twc("flex flex-1")>
            {switch isCsr {
            | true =>
              <RescriptReactErrorBoundary fallback={_ => React.null}>
                <React.Suspense fallback=React.null>
                  {switch (gnbBanners, displayCategories) {
                  | (Some(gnbBanners), Some(displayCategories)) =>
                    <ShopCategorySelect_Buyer.Mobile gnbBanners displayCategories />
                  | _ => React.null
                  }}
                </React.Suspense>
              </RescriptReactErrorBoundary>
            | false => <IconHamburger width="24" height="24" fill="#12B564" />
            }}
          </div>
          <img
            src="/assets/sinsunhi-logo.svg"
            className=%twc("w-[88px] h-7 object-contain")
            alt="sinsunhi-logo-header-mobile"
          />
          <div className=%twc("flex flex-1 justify-end")>
            {
              let {makeWithDict, toString} = module(Webapi.Url.URLSearchParams)
              let redirectUrl = switch router.query->Js.Dict.get("redirect") {
              | Some(redirect) =>
                [("redirect", redirect)]->Js.Dict.fromArray->makeWithDict->toString
              | None => {
                  let isSignInOrUp =
                    router.asPath->Js.String2.includes("signin") ||
                      router.asPath->Js.String2.includes("signup")
                  if isSignInOrUp {
                    ""
                  } else {
                    [("redirect", router.asPath)]->Js.Dict.fromArray->makeWithDict->toString
                  }
                }
              }
              switch user {
              | LoggedIn(_) => <LoggedInUserMenu />
              | NotLoggedIn =>
                <div className=%twc("flex items-center gap-2")>
                  <CartLinkIcon />
                  <Next.Link href={`/buyer/signin?${redirectUrl}`}>
                    <a
                      className=%twc(
                        "px-3 py-[6px] bg-green-50 flex items-center justify-center rounded-full text-[15px] text-green-500"
                      )>
                      {`로그인`->React.string}
                    </a>
                  </Next.Link>
                </div>

              | Unknown => <div className=%twc("w-20 h-6 bg-gray-150 animate-pulse rounded-lg") />
              }
            }
          </div>
        </header>
      </div>
    }
  }

  module Search = {
    @react.component
    let make = () => {
      let router = Next.Router.useRouter()

      <>
        // position fixed
        <div className=%twc("w-full fixed top-0 left-0 z-10 bg-white")>
          <div
            className=%twc(
              "w-full max-w-3xl mx-auto h-14 py-2 px-3 bg-white flex items-center gap-2"
            )>
            <button type_="button" onClick={_ => router->Next.Router.back}>
              <img src="/assets/arrow-right.svg" className=%twc("w-6 h-6 rotate-180") />
            </button>
            <ShopSearchInput_Buyer.MO />
            <CartLinkIcon />
          </div>
        </div>
        // placeholder
        <div className=%twc("w-full h-14") />
      </>
    }
  }

  @react.component
  let make = () => {
    let router = Next.Router.useRouter()
    let pathnames = router.pathname->Js.String2.split("/")->Array.keep(x => x !== "")
    let first = pathnames->Array.get(0)
    let second = pathnames->Array.get(1)
    let third = pathnames->Array.get(2)

    <>
      <AppLink_Header />
      {switch (first, second, third) {
      | (Some("buyer"), Some("signin"), Some("find-id-password")) => <Normal title={``} />
      | (Some("buyer"), Some("signin"), _) => <Normal title={`로그인`} />
      | (Some("buyer"), Some("signup"), _) => <Normal title={`회원가입`} />
      | (Some("buyer"), Some("upload"), _) => <Normal title={`주문서 업로드`} />
      | (Some("buyer"), Some("orders"), _) => <Normal title={`주문 내역`} />
      | (Some("buyer"), Some("me"), Some("account")) => <NoHome title={`계정정보`} />
      | (Some("buyer"), Some("me"), Some("profile")) => <NoHome title={`프로필정보`} />
      | (Some("buyer"), Some("me"), _) => <NoHome title={`마이페이지`} />
      | (Some("buyer"), Some("download-center"), _) => <Normal title={`다운로드 센터`} />
      | (Some("buyer"), Some("transactions"), _) => <Normal title={`결제 내역`} />
      | (Some("buyer"), Some("products"), Some("advanced-search")) =>
        <Normal title={`상품 검색`} />
      | (Some("products"), Some("advanced-search"), None) => <Normal title={`상품 검색`} />
      | (Some("search"), _, _) => <Search />
      | (Some("buyer"), Some("web-order"), Some("complete")) => <NoBack title={`주문 완료`} />
      | (Some("buyer"), Some("web-order"), _) => <Normal title={`주문·결제`} />
      | (Some("delivery"), None, _) => <BackAndCart title={`신선배송`} />
      | (Some("delivery"), Some(_), _) => <BackAndCart title={`신선배송`} />
      | (Some("matching"), None, _) => <NoHome title={`신선매칭`} />
      | (Some("matching"), Some(_), _) => <Normal title={`신선매칭`} />
      | (Some("buyer"), Some("cart"), _) => <Normal title={`장바구니`} />
      | (Some("buyer"), None, _) => <GnbHome />
      | _ => <Normal title={``} />
      }}
    </>
  }
}

module PC_Old = {
  // warning: this module will be deprecated
  module LoggedInUserMenu = {
    @react.component
    let make = (~user: CustomHooks.Auth.user) => {
      let logOut = ReactEvents.interceptingHandler(_ => {
        CustomHooks.Auth.logOut()
        ChannelTalkHelper.logout()
        Redirect.setHref("/")
      })

      let itemStyle = %twc(
        "cursor-pointer w-full h-full py-3 px-8 whitespace-nowrap flex items-center justify-center"
      )

      open RadixUI.DropDown
      <div id="gnb-user" className=%twc("relative flex items-center h-16")>
        <Root>
          <Trigger className=%twc("focus:outline-none")>
            <div className=%twc("flex items-center")>
              <span className=%twc("text-base text-gray-800")>
                {user.email->Option.getWithDefault("")->React.string}
              </span>
              <span className=%twc("relative ml-1")>
                <IconArrowSelect height="22" width="22" fill="#262626" />
              </span>
            </div>
          </Trigger>
          <Content
            align=#end
            className=%twc(
              "dropdown-content p-1 w-[140px] bg-white rounded-lg shadow-md divide-y text-gray-800"
            )>
            <Item className=%twc("focus:outline-none")>
              <Next.Link href="/buyer/me">
                <a className=itemStyle>
                  <span> {`마이페이지`->React.string} </span>
                </a>
              </Next.Link>
            </Item>
            <Item className=%twc("focus:outline-none")>
              <Next.Link href="/buyer/orders">
                <a className=itemStyle>
                  <span> {`주문내역`->React.string} </span>
                </a>
              </Next.Link>
            </Item>
            <Item className=%twc("focus:outline-none")>
              <Next.Link href="/buyer/transactions">
                <a className=itemStyle>
                  <span> {`결제내역`->React.string} </span>
                </a>
              </Next.Link>
            </Item>
            <Item className=%twc("focus:outline-none")>
              <Next.Link href="/products/advanced-search">
                <a className=itemStyle>
                  <span> {`단품확인`->React.string} </span>
                </a>
              </Next.Link>
            </Item>
            <Item className=%twc("focus:outline-none")>
              <button type_="button" onClick={logOut} className=itemStyle>
                <span> {`로그아웃`->React.string} </span>
              </button>
            </Item>
          </Content>
        </Root>
      </div>
    }
  }

  module NotLoggedInUserMenu = {
    @react.component
    let make = () => {
      let router = Next.Router.useRouter()
      let {makeWithDict, toString} = module(Webapi.Url.URLSearchParams)
      let redirectUrl = switch router.query->Js.Dict.get("redirect") {
      | Some(redirect) => [("redirect", redirect)]->Js.Dict.fromArray->makeWithDict->toString
      | None => {
          let isSignInOrUp =
            router.asPath->Js.String2.includes("signin") ||
              router.asPath->Js.String2.includes("signup")
          if isSignInOrUp {
            ""
          } else {
            [("redirect", router.asPath)]->Js.Dict.fromArray->makeWithDict->toString
          }
        }
      }

      let buttonStyle = %twc(
        "ml-2 py-2 px-4 bg-green-50 flex items-center justify-center rounded-full text-sm text-green-500 cursor-pointer"
      )

      <div className=%twc("flex items-center justify-center h-16")>
        <Next.Link href={`/buyer/signin?${redirectUrl}`}>
          <a className=buttonStyle> {`로그인`->React.string} </a>
        </Next.Link>
        <Next.Link href={`/buyer/signup?${redirectUrl}`}>
          <a className=buttonStyle> {`회원가입`->React.string} </a>
        </Next.Link>
      </div>
    }
  }

  module GnbBanners = {
    @react.component
    let make = () => {
      let {gnbBanners} = GnbBannerList_Buyer.Query.use(~variables=(), ())
      <GnbBannerList_Buyer gnbBanners />
    }
  }

  module Categories = {
    @react.component
    let make = () => {
      let {displayCategories} = ShopCategorySelect_Buyer.Query.use(
        ~variables={onlyDisplayable: Some(true), types: Some([#NORMAL]), parentId: None},
        (),
      )
      <ShopCategorySelect_Buyer.PC displayCategories />
    }
  }

  @react.component
  let make = () => {
    let user = CustomHooks.User.Buyer.use2()
    let isCsr = CustomHooks.useCsr()

    <>
      <AppLink_Header />
      <header className=%twc("w-full fixed top-0 bg-white z-10")>
        <div className=%twc("w-full flex justify-between items-center py-4 px-10")>
          <div className=%twc("flex items-center")>
            // 로고
            <Next.Link href="/">
              <a>
                <img
                  src="/assets/sinsunhi-logo.svg"
                  className=%twc("w-[120px] h-10 object-contain")
                  alt="sinsunhi-logo-header-pc"
                />
              </a>
            </Next.Link>
            // 검색창
            <div className=%twc("ml-12")>
              <ShopSearchInput_Buyer />
            </div>
          </div>
          <div className=%twc("flex items-center")>
            <span>
              {switch user {
              | LoggedIn(user') =>
                <div className=%twc("flex items-center gap-5")>
                  <CartLinkIcon />
                  <LoggedInUserMenu user={user'} />
                </div>
              | NotLoggedIn =>
                <div className=%twc("flex items-center gap-2")>
                  <CartLinkIcon />
                  <NotLoggedInUserMenu />
                </div>
              | Unknown =>
                <div className=%twc("h-16 flex items-center")>
                  <div className=%twc("w-40 h-6 bg-gray-150 animate-pulse rounded-lg") />
                </div>
              }}
            </span>
          </div>
        </div>
        <nav className=%twc("flex items-center justify-between pr-10 pl-2 border-y")>
          <div className=%twc("h-14 flex items-center divide-x")>
            // 카테고리
            <RescriptReactErrorBoundary fallback={_ => React.null}>
              <React.Suspense fallback=React.null>
                {switch isCsr {
                | false => React.null
                | true => <Categories />
                }}
              </React.Suspense>
            </RescriptReactErrorBoundary>
            // Gnb Banners
            <RescriptReactErrorBoundary fallback={_ => React.null}>
              <React.Suspense fallback=React.null>
                {switch isCsr {
                | false => React.null
                | true => <GnbBanners />
                }}
              </React.Suspense>
            </RescriptReactErrorBoundary>
          </div>
          // 네비게이션
          <div className=%twc("flex items-center text-base text-gray-800")>
            {
              let (link, target) = switch user {
              | LoggedIn(_) => (
                  "https://drive.google.com/drive/u/0/folders/1DbaGUxpkYnJMrl4RPKRzpCqTfTUH7bYN",
                  "_blank",
                )
              | _ => ("/buyer/signin", "_self")
              }
              <Next.Link href=link>
                <a target className=%twc("ml-4 cursor-pointer")>
                  {`판매자료 다운로드`->React.string}
                </a>
              </Next.Link>
            }
            <Next.Link href="/buyer/upload">
              <a className=%twc("ml-4 cursor-pointer")> {`주문서 업로드`->React.string} </a>
            </Next.Link>
            <Next.Link href="https://shinsunmarket.co.kr/532">
              <a target="_blank" className=%twc("ml-4 cursor-pointer")>
                {`고객지원`->React.string}
              </a>
            </Next.Link>
          </div>
        </nav>
      </header>
      <div className=%twc("w-full h-[154px]") />
    </>
  }
}

module PC = {
  module LoggedInUserMenu = {
    @react.component
    let make = (~user: CustomHooks.Auth.user) => {
      let logOut = ReactEvents.interceptingHandler(_ => {
        CustomHooks.Auth.logOut()
        ChannelTalkHelper.logout()
        Redirect.setHref("/")
      })

      let itemStyle = %twc(
        "cursor-pointer w-full h-full py-3 px-8 whitespace-nowrap flex items-center justify-center"
      )

      open RadixUI.DropDown
      <div id="gnb-user" className=%twc("relative flex items-center h-16")>
        <Root>
          <Trigger className=%twc("focus:outline-none")>
            <div className=%twc("flex items-center")>
              <span className=%twc("text-base text-gray-800")>
                {user.email->Option.getWithDefault("")->React.string}
              </span>
              <span className=%twc("relative ml-1")>
                <IconArrowSelect height="22" width="22" fill="#262626" />
              </span>
            </div>
          </Trigger>
          <Content
            align=#end
            className=%twc(
              "dropdown-content p-1 w-[140px] bg-white rounded-lg shadow-md divide-y text-gray-800"
            )>
            <Item className=%twc("focus:outline-none")>
              <Next.Link href="/buyer/me">
                <a className=itemStyle>
                  <span> {`마이페이지`->React.string} </span>
                </a>
              </Next.Link>
            </Item>
            <Item className=%twc("focus:outline-none")>
              <Next.Link href="/buyer/orders">
                <a className=itemStyle>
                  <span> {`주문내역`->React.string} </span>
                </a>
              </Next.Link>
            </Item>
            <Item className=%twc("focus:outline-none")>
              <Next.Link href="/buyer/transactions">
                <a className=itemStyle>
                  <span> {`결제내역`->React.string} </span>
                </a>
              </Next.Link>
            </Item>
            <Item className=%twc("focus:outline-none")>
              <Next.Link href="/products/advanced-search">
                <a className=itemStyle>
                  <span> {`단품확인`->React.string} </span>
                </a>
              </Next.Link>
            </Item>
            <Item className=%twc("focus:outline-none")>
              <button type_="button" onClick={logOut} className=itemStyle>
                <span> {`로그아웃`->React.string} </span>
              </button>
            </Item>
          </Content>
        </Root>
      </div>
    }
  }

  module NotLoggedInUserMenu = {
    @react.component
    let make = () => {
      let router = Next.Router.useRouter()
      let {makeWithDict, toString} = module(Webapi.Url.URLSearchParams)
      let redirectUrl = switch router.query->Js.Dict.get("redirect") {
      | Some(redirect) => [("redirect", redirect)]->Js.Dict.fromArray->makeWithDict->toString
      | None => {
          let isSignInOrUp =
            router.asPath->Js.String2.includes("signin") ||
              router.asPath->Js.String2.includes("signup")
          if isSignInOrUp {
            ""
          } else {
            [("redirect", router.asPath)]->Js.Dict.fromArray->makeWithDict->toString
          }
        }
      }

      let buttonStyle = %twc(
        "ml-2 py-2 px-4 bg-green-50 flex items-center justify-center rounded-full text-sm text-green-500 cursor-pointer"
      )

      <div className=%twc("flex items-center justify-center h-16")>
        <Next.Link href={`/buyer/signin?${redirectUrl}`}>
          <a className=buttonStyle> {`로그인`->React.string} </a>
        </Next.Link>
        <Next.Link href={`/buyer/signup?${redirectUrl}`}>
          <a className=buttonStyle> {`회원가입`->React.string} </a>
        </Next.Link>
      </div>
    }
  }

  @react.component
  let make = (~gnbBanners, ~displayCategories) => {
    let user = CustomHooks.User.Buyer.use2()

    <>
      <AppLink_Header />
      <header className=%twc("w-full sticky top-0 bg-white z-10")>
        <div className=%twc("w-full flex justify-between items-center py-4 px-10")>
          <div className=%twc("flex items-center")>
            // 로고
            <Next.Link href="/">
              <a>
                <img
                  src="/assets/sinsunhi-logo.svg"
                  className=%twc("w-[120px] h-10 object-contain")
                  alt="sinsunhi-logo-header-pc"
                />
              </a>
            </Next.Link>
            // 검색창
            <div className=%twc("ml-12")>
              <ShopSearchInput_Buyer />
            </div>
          </div>
          <div className=%twc("flex items-center")>
            <span>
              {switch user {
              | LoggedIn(user') =>
                <div className=%twc("flex items-center gap-5")>
                  <CartLinkIcon />
                  <LoggedInUserMenu user={user'} />
                </div>
              | NotLoggedIn =>
                <div className=%twc("flex items-center gap-2")>
                  <CartLinkIcon />
                  <NotLoggedInUserMenu />
                </div>
              | Unknown =>
                <div className=%twc("h-16 flex items-center")>
                  <div className=%twc("w-40 h-6 bg-gray-150 animate-pulse rounded-lg") />
                </div>
              }}
            </span>
          </div>
        </div>
        <nav className=%twc("flex items-center justify-between pr-10 pl-2 border-y")>
          <div className=%twc("h-14 flex items-center divide-x")>
            // 카테고리
            <ShopCategorySelect_Buyer.PC displayCategories />
            // Gnb Banners
            <RescriptReactErrorBoundary fallback={_ => React.null}>
              <React.Suspense fallback=React.null>
                <GnbBannerList_Buyer gnbBanners />
              </React.Suspense>
            </RescriptReactErrorBoundary>
          </div>
          // 네비게이션
          <div className=%twc("flex items-center text-base text-gray-800")>
            {
              let (link, target) = switch user {
              | LoggedIn(_) => (
                  "https://drive.google.com/drive/u/0/folders/1DbaGUxpkYnJMrl4RPKRzpCqTfTUH7bYN",
                  "_blank",
                )
              | _ => ("/buyer/signin", "_self")
              }
              <Next.Link href=link>
                <a target className=%twc("ml-4 cursor-pointer")>
                  {`판매자료 다운로드`->React.string}
                </a>
              </Next.Link>
            }
            <Next.Link href="/buyer/upload">
              <a className=%twc("ml-4 cursor-pointer")> {`주문서 업로드`->React.string} </a>
            </Next.Link>
            <Next.Link href="https://shinsunmarket.co.kr/532">
              <a target="_blank" className=%twc("ml-4 cursor-pointer")>
                {`고객지원`->React.string}
              </a>
            </Next.Link>
          </div>
        </nav>
      </header>
    </>
  }
}
