module Skeleton = {
  module Body = {
    @react.component
    let make = () => {
      <>
        <PC_Quick_Main_Buyer.Skeleton />
        <Footer_Buyer.PC />
      </>
    }
  }
  @react.component
  let make = () => {
    <div className=%twc("w-full min-w-[1280px] min-h-screen bg-[#FAFBFC]")>
      <div className=%twc("flex flex-col w-full") />
      <PC_Header.Buyer.Placeholder />
      <Body />
    </div>
  }
}

type tab = [#matching | #quick]

module DefaultTab = {
  module CheckOrder = {
    // 로그인 유저라면 견적요청진행 여부를 파악하여 탭을 이동시킨다.
    module Query = %relay(`
      query PCMainBuyerCheckOrderQuery {
        viewer {
          hasUsedRfq
        }
      }
    `)
    @react.component
    let make = () => {
      let router = Next.Router.useRouter()
      let {viewer} = Query.use(~variables=(), ())

      React.useEffect1(_ => {
        let newTab = switch viewer {
        | Some({hasUsedRfq}) if !hasUsedRfq => #quick
        | _ => #matching
        }

        //url 은 replace 해놓기.
        let newQuery = router.query
        newQuery->Js.Dict.set("tab", (newTab: tab :> string))
        router->Next.Router.replaceShallow({pathname: "/", query: newQuery})

        None
      }, [viewer])

      <Skeleton.Body />
    }
  }

  @react.component
  let make = () => {
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
            //url 은 replace 해놓기.
            let newQuery = router.query
            newQuery->Js.Dict.set("tab", (#quick: tab :> string))
            router->Next.Router.replaceShallow({pathname: "/", query: newQuery})
          }

        | Unknown => ()
        }
      }

      None
    }, (user, router.query))

    <>
      {switch needToCheckOrder {
      | true =>
        <React.Suspense fallback={React.null}>
          <CheckOrder />
        </React.Suspense>
      | false => <Skeleton.Body />
      }}
    </>
  }
}

module Container = {
  @react.component
  let make = () => {
    // 채널톡 버튼 사용
    ChannelTalkHelper.Hook.use()

    let router = Next.Router.useRouter()
    let subPage = router.query->Js.Dict.get("tab")

    <div className=%twc("min-w-[1360px] min-h-screen bg-[#FAFBFC]")>
      <React.Suspense fallback={<PC_Header.Buyer.Placeholder />}>
        <PC_Header.Buyer />
      </React.Suspense>
      <div className=%twc("w-[1280px] mx-auto")>
        {switch subPage {
        | None => <DefaultTab />
        | Some("quick") => <PC_Quick_Main_Buyer />
        | Some("matching") => <PC_Matching_Main_Buyer />
        | Some(_) => <Skeleton.Body />
        }}
      </div>
      <Footer_Buyer.PC />
    </div>
  }
}

@react.component
let make = () => {
  <>
    <Next.Head>
      <title> {`신선하이 | 농산물 소싱 온라인 플랫폼`->React.string} </title>
      <meta
        name="description"
        content="농산물 소싱은 신선하이에서! 전국 70만 산지농가의 우수한 농산물을 싸고 편리하게 공급합니다. 국내 유일한 농산물 B2B 플랫폼 신선하이와 함께 매출을 올려보세요."
      />
    </Next.Head>
    <OpenGraph_Header
      title="신선하이 | 농산물 소싱 온라인 플랫폼"
      description="농산물 소싱은 신선하이에서! 전국 70만 산지농가의 우수한 농산물을 싸고 편리하게 공급합니다. 국내 유일한 농산물 B2B 플랫폼 신선하이와 함께 매출을 올려보세요."
    />
    <RescriptReactErrorBoundary fallback={_ => <Skeleton />}>
      <React.Suspense fallback={<Skeleton />}>
        <Container />
      </React.Suspense>
    </RescriptReactErrorBoundary>
  </>
}
