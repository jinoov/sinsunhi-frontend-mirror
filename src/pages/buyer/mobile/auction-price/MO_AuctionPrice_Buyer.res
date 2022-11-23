module Query = %relay(`
    query MOAuctionPriceBuyerQuery(
      $cursor: String
      $count: Int!
      $marketPriceDiffFilter: MarketPriceDiffFilter!
      $orderBy: [ProductsOrderBy!]
    ) {
      ...MOAuctionPriceListBuyerFragment
        @arguments(
          count: $count
          cursor: $cursor
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
      ->Js.Dict.get("type")
      ->Option.flatMap(MO_AuctionPrice_Chips_Buyer.Chip.fromString)
      ->Option.getWithDefault(#TODAY_RISE)

    let (filter, setFilter) = React.Uncurried.useState(_ => value)

    let query = Query.use(
      ~variables={
        cursor: None,
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

    <div className=%twc("w-full min-h-screen")>
      <div className=%twc("w-full bg-white")>
        <div className=%twc("w-full max-w-3xl mx-auto bg-white min-h-screen relative")>
          <MO_Headers_Buyer.Stack
            className=%twc("sticky top-0") title="전국 농산물 경매가"
          />
          <MO_AuctionPrice_Lists_Buyer query={query.fragmentRefs} setFilter={onClick} />
        </div>
      </div>
    </div>
  }
}

module Placeholder = {
  @react.component
  let make = () => {
    <div className=%twc("w-full min-h-screen")>
      <div className=%twc("w-full bg-white")>
        <div className=%twc("w-full max-w-3xl mx-auto bg-white min-h-screen relative")>
          <MO_Headers_Buyer.Stack
            title="전국 농산물 경매가" className=%twc("sticky top-0")
          />
          <MO_AuctionPrice_Lists_Buyer.Chips setFilter={_ => ()} />
          <ol className=%twc("h-[5000px]")>
            <MatchingProductDiffPriceListItem.Placeholder />
            <MatchingProductDiffPriceListItem.Placeholder />
            <MatchingProductDiffPriceListItem.Placeholder />
            <MatchingProductDiffPriceListItem.Placeholder />
            <MatchingProductDiffPriceListItem.Placeholder />
          </ol>
        </div>
      </div>
    </div>
  }
}

@react.component
let make = () => {
  <>
    <Next.Head>
      <title> {`신선하이 | 전국 농산물 경매가`->React.string} </title>
    </Next.Head>
    <AppLink_Header />
    <ClientSideRender fallback={<Placeholder />}>
      <React.Suspense fallback={<Placeholder />}>
        <Content />
      </React.Suspense>
    </ClientSideRender>
  </>
}
