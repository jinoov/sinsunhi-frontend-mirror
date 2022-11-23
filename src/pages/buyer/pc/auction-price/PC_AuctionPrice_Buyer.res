module Query = %relay(`
    query PCAuctionPriceBuyerQuery(
      $cursor: String
      $count: Int!
      $marketPriceDiffFilter: MarketPriceDiffFilter!
      $orderBy: [ProductsOrderBy!]
    ) {
      ...PCAuctionPriceListBuyerFragment
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
      ->Option.flatMap(PC_AuctionPrice_Chips_Buyer.Chip.fromString)
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

    let onClickHandler = _ => {
      router->Next.Router.back
    }

    let onClickChip = (filter: PC_AuctionPrice_Chips_Buyer.Chip.t) => {
      setFilter(._ => filter)
    }

    <div
      className=%twc(
        "flex flex-col w-[1280px] mx-auto mt-8 rounded-sm bg-white shadow-[0px_10px_40px_10px_rgba(0,0,0,0.03)] overflow-hidden px-[34px] mb-14"
      )>
      <div className=%twc("inline-flex text-[26px] font-bold items-center ml-3 pt-10 mb-[42px] ")>
        <button type_="button" onClick=onClickHandler className=%twc("cursor-pointer")>
          <IconArrow
            width="36px" height="36px" fill="#1F2024" className=%twc("rotate-180 mr-[10px]")
          />
        </button>
        <h2> {`전국 농산물 경매가`->React.string} </h2>
      </div>
      <PC_AuctionPrice_Lists_Buyer query={query.fragmentRefs} setFilter={onClickChip} />
    </div>
  }
}

module Placeholder = {
  @react.component
  let make = () => {
    <div
      className=%twc(
        "flex flex-col w-[1280px] mx-auto mt-8 rounded-sm bg-white shadow-[0px_10px_40px_10px_rgba(0,0,0,0.03)] overflow-hidden px-[34px] mb-14"
      )>
      <div className=%twc("inline-flex text-[26px] font-bold items-center ml-3 pt-10 mb-[42px] ")>
        <button type_="button" className=%twc("cursor-pointer")>
          <IconArrow
            width="36px" height="36px" fill="#1F2024" className=%twc("rotate-180 mr-[10px]")
          />
        </button>
        <h2> {`전국 농산물 경매가`->React.string} </h2>
      </div>
      <ol className=%twc("mb-8 h-[6000px]")>
        {Array.range(0, 9)
        ->Array.map(i => <MatchingProductDiffPriceListItem.Placeholder key={i->Int.toString} />)
        ->React.array}
      </ol>
    </div>
  }
}

@react.component
let make = () => {
  <>
    <Next.Head>
      <title> {`신선하이 | 전국 농산물 경매가`->React.string} </title>
    </Next.Head>
    <div className=%twc("w-full min-h-screen")>
      <div className=%twc("w-full bg-[#F0F2F5]")>
        <React.Suspense fallback={<PC_Header.Buyer.Placeholder />}>
          <PC_Header.Buyer />
        </React.Suspense>
        <div className=%twc("flex pc-content bg-[#FAFBFC]")>
          <ClientSideRender fallback={<Placeholder />}>
            <React.Suspense fallback={<Placeholder />}>
              <Content />
            </React.Suspense>
          </ClientSideRender>
        </div>
        <Footer_Buyer.PC />
      </div>
    </div>
  </>
}
