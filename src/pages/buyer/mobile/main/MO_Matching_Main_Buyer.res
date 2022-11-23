module MatchingProduct_Banner = {
  @module("/public/assets/search-bnb-enabled.svg")
  external searchBnbEnabled: string = "default"

  @react.component
  let make = () => {
    let router = Next.Router.useRouter()
    let isShowDrawer = router.query->Js.Dict.get("search")->Option.isSome

    let searchQuery = router.query->Js.Dict.get("search")

    let handleOnClick = _ => {
      let newQuery = router.query
      newQuery->Js.Dict.set("search", "")
      router->Next.Router.pushShallow({pathname: "/", query: newQuery})
    }

    let handleOnClose = _ => {
      let newQuery =
        router.query->Js.Dict.entries->Array.keep(((key, _)) => key != "search")->Js.Dict.fromArray

      // 검색 쿼리를 제거합니다.
      router->Next.Router.replaceShallow({pathname: "/", query: newQuery})
    }

    <section className=%twc("relative")>
      <MO_Matching_Banner_Buyer />
      <div className=%twc("absolute z-10 top-0 w-full h-full p-7 flex flex-col")>
        <h1 className=%twc("mt-3 text-white text-2xl font-bold leading-8")>
          {"원하는 상품, 수량 입력하고"->React.string}
          <br />
          {"산지 직거래 견적 받으세요"->React.string}
        </h1>
        <p className=%twc("mt-2 text-white text-[15px] font-medium")>
          {"믿고 거래할 수 있는 산지에서 소싱하세요"->React.string}
        </p>
        <button
          type_="button"
          className=%twc(
            "bg-white w-full py-4 text-center rounded-xl mt-auto relative interactable"
          )
          onClick={handleOnClick}>
          <div className=%twc("flex items-center justify-center")>
            <img className=%twc("w-5 h-5 mr-1") src=searchBnbEnabled alt="" />
            <span className=%twc("font-bold")> {"견적 상품 찾기"->React.string} </span>
          </div>
        </button>
      </div>
      <MO_MatchingProduct_Search_Buyer
        isShow={isShowDrawer} onClose={handleOnClose} defaultQuery=?{searchQuery}
      />
    </section>
  }
}

module InterestedProduct_List = {
  @react.component
  let make = () => {
    <section className=%twc("mt-[18px] font-medium")>
      <MO_InterestedProduct_Main_Buyer />
    </section>
  }
}

module AuctionPrice_List = {
  module Query = %relay(`
    query MOMatchingMainBuyerQuery(
      $count: Int!
      $marketPriceDiffFilter: MarketPriceDiffFilter!
      $orderBy: [ProductsOrderBy!]
    ) {
      ...MOAuctionPriceListBuyerFragment
        @arguments(
          count: $count
          marketPriceDiffFilter: $marketPriceDiffFilter
          orderBy: $orderBy
        )
    }
  `)

  module Content = {
    @react.component
    let make = () => {
      let router = Next.Router.useRouter()

      let value =
        router.query
        ->Js.Dict.get("auction-price")
        ->Option.flatMap(PC_AuctionPrice_Chips_Buyer.Chip.fromString)
        ->Option.getWithDefault(#TODAY_RISE)

      let (filter, setFilter) = React.Uncurried.useState(_ => value)

      let query = Query.use(
        ~variables={
          count: 20,
          marketPriceDiffFilter: switch filter {
          | #TODAY_RISE => {isFromLatestBusinessDay: Some(true), sign: #PLUS, unit: #DAILY}
          | #TODAY_FALL => {isFromLatestBusinessDay: Some(true), sign: #MINUS, unit: #DAILY}
          | #WEEK_RISE => {isFromLatestBusinessDay: Some(true), sign: #PLUS, unit: #WEEKLY}
          | #WEEK_FALL => {isFromLatestBusinessDay: Some(true), sign: #MINUS, unit: #WEEKLY}
          },
          orderBy: switch filter {
          | #TODAY_RISE => Some([{field: #DAILY_MARKET_PRICE_DIFF_RATE, direction: #DESC}])
          | #TODAY_FALL => Some([{field: #DAILY_MARKET_PRICE_DIFF_RATE, direction: #ASC}])
          | #WEEK_RISE => Some([{field: #WEEKLY_MARKET_PRICE_DIFF_RATE, direction: #DESC}])
          | #WEEK_FALL => Some([{field: #WEEKLY_MARKET_PRICE_DIFF_RATE, direction: #ASC}])
          },
        },
        (),
      )

      let onClick = (filter: MO_AuctionPrice_Chips_Buyer.Chip.t) => {
        setFilter(._ => filter)
      }

      <section className=%twc("mt-[18px] mb-[30px] font-medium")>
        <MO_AuctionPrice_Main_Buyer query={query.fragmentRefs} setFilter={onClick} />
        <div className=%twc("px-4")>
          <Next.Link
            href={`auction-price/?type=${(value: PC_AuctionPrice_Chips_Buyer.Chip.t :> string)}`}>
            <button
              type_="button"
              className=%twc(
                "px-4 mt-4 rounded-lg py-2 text-center border border-[#DCDFE3] w-full interactable"
              )>
              {"더보기"->React.string}
            </button>
          </Next.Link>
        </div>
      </section>
    }
  }

  @react.component
  let make = () => {
    <React.Suspense fallback={<div />}>
      <Content />
    </React.Suspense>
  }
}

module CustomerCompanies = {
  @react.component
  let make = () => {
    <section className=%twc("mt-[30px] mb-9")>
      <div className=%twc("pb-6 px-4 text-[19px] font-bold text-[#1F2024]")>
        <h2> {`대표 고객사`->React.string} </h2>
      </div>
      <MO_CustomerCompanies_Buyer />
    </section>
  }
}

module ViewByUserStatus = {
  @react.component
  let make = (~loggedIn, ~notLoggedIn) => {
    let user = CustomHooks.User.Buyer.use2()

    {
      switch user {
      | LoggedIn(_) => loggedIn
      | NotLoggedIn => notLoggedIn
      | Unknown => React.null
      }
    }
  }
}

module Placeholder = {
  @react.component
  let make = () => {
    <>
      <div className=%twc("flex justify-center mt-10 h-[510px]")>
        <Spinner />
      </div>
      <div className=%twc("flex justify-center mt-10 h-[500px]")>
        <Spinner />
      </div>
      <div className=%twc("flex justify-center mt-10 h-[500px]")>
        <Spinner />
      </div>
    </>
  }
}

@react.component
let make = (~query) => {
  <div>
    // 견적요청 배너
    <MatchingProduct_Banner />
    <ClientSideRender fallback={<Placeholder />}>
      <ViewByUserStatus
        loggedIn={<>
          // 관심상품
          <InterestedProduct_List />
          <React.Suspense fallback={<div />}>
            // 경매가
            <AuctionPrice_List />
          </React.Suspense>
          // 거래 후기
          <MO_Main_Review_Carousel_Buyer query />
          <CustomerCompanies />
        </>}
        notLoggedIn={<>
          // 거래 후기
          <MO_Main_Review_Carousel_Buyer query />
          <React.Suspense fallback={<div />}>
            // 경매가
            <AuctionPrice_List />
          </React.Suspense>
          <CustomerCompanies />
        </>}
      />
    </ClientSideRender>
  </div>
}
