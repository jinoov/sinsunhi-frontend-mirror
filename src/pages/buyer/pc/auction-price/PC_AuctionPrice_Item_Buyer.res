module Fragment = %relay(`
    fragment PCAuctionPriceItemBuyer_Fragment on MatchingProduct {
      productId: number
      displayName
      image {
        thumb400x400
      }
      representativeWeight
      repMarketPriceDiff {
        latestDailyMarketPrice
        dailyMarketPriceDiff
        dailyMarketPriceDiffRate
        weeklyMarketPriceDiffRate
        weeklyMarketPriceDiff
      }
    }
`)

@react.component
let make = (~query, ~diffTerm) => {
  let {
    displayName,
    image: {thumb400x400},
    productId,
    representativeWeight,
    repMarketPriceDiff,
  } = Fragment.use(query)

  <React.Suspense fallback={<MatchingProductDiffPriceListItem.Placeholder />}>
    <Next.Link href={`/products/${productId->Int.toString}`}>
      <div
        className=%twc(
          "interactable cursor-pointer rounded-2xl hover:bg-[#1F20240A] active:bg-[#1F202414] duration-200 ease-in-out"
        )>
        {switch (repMarketPriceDiff, diffTerm) {
        | (Some(diff), #day) =>
          <MatchingProductDiffPriceListItem
            image={thumb400x400}
            name={displayName}
            representativeWeight
            price={diff.latestDailyMarketPrice}
            diffPrice={diff.dailyMarketPriceDiff}
            diffRate={diff.dailyMarketPriceDiffRate}
            diffTerm=#day
          />
        | (Some(diff), #week) =>
          <MatchingProductDiffPriceListItem
            image={thumb400x400}
            name={displayName}
            representativeWeight
            price={diff.latestDailyMarketPrice}
            diffPrice={diff.weeklyMarketPriceDiff}
            diffRate={diff.weeklyMarketPriceDiffRate}
            diffTerm=#week
          />
        | (None, _) =>
          <MatchingProductDiffPriceListItem
            image={thumb400x400}
            name={displayName}
            representativeWeight
            price={-1}
            diffPrice=None
            diffRate=None
            diffTerm
          />
        }}
      </div>
    </Next.Link>
  </React.Suspense>
}
