module Query = %relay(`
  query PCMatchingMainBuyer_Query {
    ...PCMainReviewCarouselBuyerQuery_Fragment
  }
`)

module InterestedProduct_List = {
  @react.component
  let make = () => {
    <section className=%twc("flex-1 px-[50px] mb-[34px]")>
      <PC_InterestedProduct_Main_Buyer />
    </section>
  }
}

module AuctionPrice_List = {
  module Query = %relay(`
    query PCMatchingMainBuyerQuery(
      $count: Int!
      $marketPriceDiffFilter: MarketPriceDiffFilter!
      $orderBy: [ProductsOrderBy!]
    ) {
      ...PCAuctionPriceListBuyerFragment
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

      let onChipClick = (filter: PC_AuctionPrice_Chips_Buyer.Chip.t) => {
        setFilter(._ => filter)
      }

      <section className=%twc("mb-10 flex-1 pl-[34px] pr-[50px]")>
        <PC_AuctionPrice_Main_Buyer query={query.fragmentRefs} setFilter={onChipClick} />
        <div className=%twc("px-4")>
          <Next.Link
            href={`/auction-price?type=${(value: PC_AuctionPrice_Chips_Buyer.Chip.t :> string)}`}>
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

  module Placeholder = {
    @react.component
    let make = () => {
      <section className=%twc("mb-10 flex-1 pl-[34px] pr-[50px]")>
        <div className=%twc("px-4")>
          <Next.Link href="/auction-price">
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
    <React.Suspense fallback={<Placeholder />}>
      <Content />
    </React.Suspense>
  }
}

module LoggedInView = {
  @react.component
  let make = (~query) => {
    <section className=%twc("pt-14")>
      <div className=%twc("flex")>
        <React.Suspense fallback={<AuctionPrice_List.Placeholder />}>
          <AuctionPrice_List />
        </React.Suspense>
        <InterestedProduct_List />
      </div>
      <div className=%twc("mb-20 w-full")>
        <PC_Main_Review_Carousel_Buyer query />
      </div>
      <PC_Main_Clients widthVariant=PC_Main_Clients.Wide />
    </section>
  }
}

module NotLoggedInView = {
  @react.component
  let make = (~query) => {
    <>
      <div className=%twc("mb-[38px]")>
        <PC_Main_Review_Carousel_Buyer query />
      </div>
      <div className=%twc("flex flex-1 mb-7")>
        <React.Suspense fallback={<AuctionPrice_List.Placeholder />}>
          <AuctionPrice_List />
        </React.Suspense>
        <PC_Main_Clients widthVariant=PC_Main_Clients.Narrow />
      </div>
    </>
  }
}

@react.component
let make = () => {
  let {fragmentRefs} = Query.use(~variables=(), ())
  let user = CustomHooks.Auth.use()
  let isCsr = CustomHooks.useCsr()

  switch isCsr {
  | true =>
    <div
      className=%twc(
        "flex flex-col relative w-[1280px] mx-auto mt-8 rounded-sm bg-white shadow-[0px_10px_40px_10px_rgba(0,0,0,0.03)] mb-[76px]"
      )>
      <PC_Matching_Banner_Buyer />
      {switch user {
      | LoggedIn(_) => <LoggedInView query=fragmentRefs />
      | Unknown
      | NotLoggedIn =>
        <NotLoggedInView query=fragmentRefs />
      }}
    </div>
  | false => <div className=%twc("min-h-screen") />
  }
}
