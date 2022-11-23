module Fragment = %relay(`
  fragment MOAuctionPriceListBuyerFragment on Query
  @refetchable(queryName: "AuctionPriceListRefetchQuery")
  @argumentDefinitions(
    cursor: { type: "String", defaultValue: null }
    count: { type: "Int!" }
    marketPriceDiffFilter: { type: "MarketPriceDiffFilter!" }
    orderBy: { type: "[ProductsOrderBy!]", defaultValue: [] }
  ) {
    products(
      after: $cursor
      first: $count
      type: [MATCHING]
      onlyBuyable: true
      orderBy: $orderBy
      marketPriceDiffFilter: $marketPriceDiffFilter
    ) @connection(key: "AuctionPriceList_products") {
      __id
      edges {
        cursor
        node {
          id
          ...MOAuctionPriceItemBuyer_Fragment
        }
      }
    }
  }
`)

module Partial = {
  @react.component
  let make = (~query, ~diffTerm, ~limit) => {
    let {data: {products}} = Fragment.usePagination(query)

    <ol>
      {products.edges
      ->Array.slice(~offset=0, ~len=limit)
      ->Array.map(({node}) => {
        <MO_AuctionPrice_Item_Buyer key={node.id} query={node.fragmentRefs} diffTerm />
      })
      ->React.array}
    </ol>
  }
}

@react.component
let make = (~query, ~diffTerm) => {
  let {data: {products}, hasNext, loadNext} = Fragment.usePagination(query)

  let loadMoreRef = React.useRef(Js.Nullable.null)

  let isIntersecting = CustomHooks.IntersectionObserver.use(
    ~target=loadMoreRef,
    ~rootMargin="50px",
    ~thresholds=0.1,
    (),
  )

  React.useEffect1(_ => {
    if hasNext && isIntersecting {
      loadNext(~count=20, ())->ignore
    }

    None
  }, [hasNext, isIntersecting])

  <ol>
    {products.edges
    ->Array.map(({node}) => {
      <MO_AuctionPrice_Item_Buyer key={node.id} query={node.fragmentRefs} diffTerm />
    })
    ->React.array}
    <div ref={ReactDOM.Ref.domRef(loadMoreRef)} className=%twc("h-20 w-full") />
  </ol>
}
