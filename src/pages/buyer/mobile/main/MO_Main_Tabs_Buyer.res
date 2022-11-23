open RadixUI

type tab = Matching | Quick

let toString = t => {
  switch t {
  | Matching => `견적요청`
  | Quick => `즉시구매`
  }
}

let toHash = t => {
  switch t {
  | Matching => `matching`
  | Quick => `quick`
  }
}

let toTab = str => {
  if str == `견적요청` {
    Matching
  } else if str == `즉시구매` {
    Quick
  } else {
    Matching
  }
}
let matchingDisplayName = Matching->toString
let quickDisplayName = Quick->toString
module Skeleton = {
  //Server side render 시 자연스럽게 나올수 있는 것으로 준비.
  @react.component
  let make = () => {
    <Tabs.Root defaultValue={"1"}>
      <Tabs.List className=%twc("px-4 flex border-b border-[#F0F2F5]")>
        <Tabs.Trigger
          value={""}
          className=%twc(
            "py-3 flex-1 state-active:text-gray-900 state-active:font-bold tab-bottom text-[#8B8D94] font-medium text-[17px]"
          )>
          {quickDisplayName->React.string}
        </Tabs.Trigger>
        <Tabs.Trigger
          value={""}
          className=%twc(
            "py-3 flex-1 state-active:text-gray-900 state-active:font-bold tab-bottom text-[#8B8D94] font-medium text-[17px]"
          )>
          {matchingDisplayName->React.string}
        </Tabs.Trigger>
      </Tabs.List>
      <Tabs.Content value={"1"}>
        <div className=%twc("h-[260px] w-full bg-gray-150") />
        <div className=%twc("mt-12 px-3")>
          <ShopMain_CategoryList_Buyer.MO.Placeholder />
        </div>
        <ShopMainSpecialShowcaseList_Buyer.MO.Placeholder />
        <div className=%twc("mt-10")>
          <Footer_Buyer.MO />
        </div>
      </Tabs.Content>
      <Tabs.Content value={"2"}>
        <div className=%twc("h-[260px] w-full bg-gray-150") />
        <div className=%twc("mt-12 px-3")>
          <ShopMain_CategoryList_Buyer.MO.Placeholder />
        </div>
        <ShopMainSpecialShowcaseList_Buyer.MO.Placeholder />
        <div className=%twc("mt-10")>
          <Footer_Buyer.MO />
        </div>
      </Tabs.Content>
    </Tabs.Root>
  }
}

module SelectDefaultTab = {
  // 1. 비로그인 유저의 경우 항상 견적요청 탭으로 이동시킨다.
  // 2. 로그인 유저의 경우 견적요청을 진행하지 않으면 즉시구매 탭으로 이동시킨다.

  module CheckOrder = {
    // 로그인 유저라면 견적요청진행 여부를 파악하여 탭을 이동시킨다.
    module Query = %relay(`
      query MOMainTabsBuyerCheckOrderQuery {
        viewer {
          hasUsedRfq
        }
      }
    `)
    @react.component
    let make = (~setTab) => {
      let router = Next.Router.useRouter()
      let {viewer} = Query.use(~variables=(), ())

      React.useEffect1(_ => {
        let newTab = switch viewer {
        | Some({hasUsedRfq}) if !hasUsedRfq => Quick
        | _ => Matching
        }

        setTab(._ => Some(newTab))

        //url 은 replace 해놓기.
        let newQuery = router.query
        newQuery->Js.Dict.set("tab", newTab->toHash)
        router->Next.Router.replaceShallow({pathname: "/", query: newQuery})

        None
      }, [viewer])

      <div />
    }
  }

  @react.component
  let make = (~setTab) => {
    let router = Next.Router.useRouter()
    let user = CustomHooks.User.Buyer.use2()
    let (needToCheckOrder, setNeedToCheckOrder) = React.Uncurried.useState(_ => false)

    React.useEffect2(() => {
      let tabQuery = router.query->Js.Dict.get("tab")

      //tab 쿼리파람이 없을 경우 디폴트값 선택
      if tabQuery->Option.isNone {
        switch user {
        | LoggedIn(_) => setNeedToCheckOrder(._ => true)
        | NotLoggedIn => {
            setTab(._ => Some(Quick))

            //url 은 replace 해놓기.
            let newQuery = router.query
            newQuery->Js.Dict.set("tab", Quick->toHash)
            router->Next.Router.replaceShallow({pathname: "/", query: newQuery})
          }

        | Unknown => ()
        }
      }

      None
    }, (user, router.query))

    <>
      <Skeleton />
      {switch needToCheckOrder {
      | true =>
        <React.Suspense fallback={React.null}>
          <CheckOrder setTab />
        </React.Suspense>
      | false => React.null
      }}
    </>
  }
}

@react.component
let make = (~matching, ~quick) => {
  let router = Next.Router.useRouter()

  let (tab, setTab) = React.Uncurried.useState(_ => {
    //default 값은 쿼리파람에 따라 정함.
    let tabQuery = router.query->Js.Dict.get("tab")

    switch tabQuery {
    | Some("matching") => Some(Matching)
    | Some("quick") => Some(Quick)
    | _ => None
    }
  })

  let handleOnValueChange = value => {
    //tab 전환마다 쿼리 변경
    let newQuery = router.query
    newQuery->Js.Dict.set("tab", value->toHash)
    router->Next.Router.replaceShallow({pathname: "/", query: newQuery})

    setTab(._ => Some(value))
  }

  switch tab {
  | None =>
    // TODO:
    // 유저 정보에 따라 뷰가 달라지므로 CSR로 합니다.
    // 현재 유저정보가 SSR에서는 제공되지 않고 있습니다.
    <ClientSideRender fallback={<Skeleton />}>
      <SelectDefaultTab setTab />
    </ClientSideRender>
  | Some(tab') =>
    <Tabs.Root value={tab'->toString} onValueChange={v => handleOnValueChange(v->toTab)}>
      <Tabs.List className=%twc("px-4 flex border-b border-[#F0F2F5]")>
        <Tabs.Trigger
          value={quickDisplayName}
          className=%twc(
            "py-3 flex-1 state-active:text-gray-900 state-active:font-bold tab-bottom text-[#8B8D94] text-[17px] font-medium"
          )>
          {quickDisplayName->React.string}
        </Tabs.Trigger>
        <Tabs.Trigger
          value={matchingDisplayName}
          className=%twc(
            "py-3 flex-1 state-active:text-gray-900 state-active:font-bold tab-bottom text-[#8B8D94] text-[17px] font-medium"
          )>
          {matchingDisplayName->React.string}
        </Tabs.Trigger>
      </Tabs.List>
      //scroll restoration 유지를 위해 탭 컨텐츠의 최소 높이를 유지한다.
      //탭 콘텐츠는 Footer 까지 포함한 전체 화면으로 구성
      <Tabs.Content value={matchingDisplayName}>
        {matching}
        <div className=%twc("mt-10")>
          <Footer_Buyer.MO />
        </div>
      </Tabs.Content>
      <Tabs.Content value={quickDisplayName}>
        {quick}
        <div className=%twc("mt-10")>
          <Footer_Buyer.MO />
        </div>
      </Tabs.Content>
    </Tabs.Root>
  }
}
