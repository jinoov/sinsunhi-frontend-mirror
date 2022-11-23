@module("../../public/assets/hamburger.svg")
external hamburgerIcons: string = "default"

@module("../../public/assets/mypage.svg")
external userIcons: string = "default"

type currentPage =
  | Home
  | Search
  | Menu
  | Like
  | MyInfo
  | Other

module Item = {
  @react.component
  let make = (~children, ~path, ~loginRequired: bool=false) => {
    let user = CustomHooks.Auth.use()
    let path = switch loginRequired {
    | false => path
    | true =>
      switch user {
      | LoggedIn(_) => path
      | _ => `/buyer/signin?redirect=${path}`
      }
    }

    <Next.Link href=path>
      <a
        href=path
        className="navbar-button px-6 py-3 flex-1 flex justify-center items-center interactable">
        children
      </a>
    </Next.Link>
  }
}

module MenuButton = {
  @react.component
  let make = (~children) => {
    let router = Next.Router.useRouter()
    let onClick = _ => {
      let pathnames = router.asPath->Js.String.split("/")
      let firstPath = pathnames->Array.get(1)

      switch firstPath {
      | Some("categories") => {
          let cidParam =
            router.query
            ->Js.Dict.get("cid")
            ->Option.map(cid => `?cid=${cid}`)
            ->Option.getWithDefault("")

          router->Next.Router.push(`/menu${cidParam}`)
        }

      | _ => router->Next.Router.push("/menu")
      }
    }
    <button
      className=%twc("px-6 py-3 flex-1 flex justify-center items-center interactable") onClick>
      children
    </button>
  }
}
module Content = {
  @react.component
  let make = (~currentPath) => {
    <>
      <div className=%twc("h-[48px] bg-white") />
      <div
        className={cx([
          %twc("fixed bottom-0 w-full flex bg-white h-12 border-t-[1px] select-none z-[5]"),
          "",
        ])}>
        <Item path="/">
          <IconHomeBNB selected={currentPath == Home} />
        </Item>
        <Item path="/search">
          <IconSearchBNB selected={currentPath == Search} />
        </Item>
        <MenuButton>
          <IconHamburgerBNB selected={currentPath == Menu} />
        </MenuButton>
        <Item path="/saved-products?selected=like" loginRequired=true>
          <IconHeartBNB selected={currentPath == Like} />
        </Item>
        <Item path="/buyer/me" loginRequired=true>
          <IconUserBNB selected={currentPath == MyInfo} />
        </Item>
      </div>
    </>
  }
}

@react.component
let make = (~deviceType) => {
  let router = Next.Router.useRouter()
  let (currentPath, setCurrentPath) = React.Uncurried.useState(_ => Other)

  let pathnames = router.pathname->Js.String2.split("/")->Array.keep(x => x !== "")

  let firstPath = pathnames->Array.get(0)
  let secondPath = pathnames->Array.get(1)
  let thirdPath = pathnames->Array.get(2)

  React.useEffect2(_ => {
    setCurrentPath(._ =>
      switch (firstPath, secondPath) {
      | (Some("search"), _) => Search
      | (Some("menu"), _) => Menu
      | (Some("saved-products"), _) => Like
      | (Some("buyer"), Some("me")) => MyInfo
      | (Some("buyer"), Some("signin")) =>
        switch router.query->Js.Dict.get("redirect") {
        | Some(str) if str->Js.String2.includes("/saved-products") => Like
        | Some(str) if str->Js.String2.includes("/buyer/me") => MyInfo
        | _ => Other
        }
      | (None, None) => Home
      | _ => Other
      }
    )
    None
  }, (router.pathname, router.query))

  //bnb를 보여주지 않아야 하는 경우 처리
  switch deviceType {
  | DeviceDetect.PC => React.null
  | _ =>
    switch (firstPath, secondPath, thirdPath) {
    | (Some("buyer"), Some("me"), Some("like"))
    | (Some("buyer"), Some("me"), Some("recent-view"))
    | (Some("saved-products"), _, _) =>
      switch router.query->Js.Dict.get("mode") {
      | Some("EDIT") => React.null
      | _ => <Content currentPath />
      }

    | _ => <Content currentPath />
    }
  }
}
