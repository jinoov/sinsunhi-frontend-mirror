module Fragment = %relay(`
    fragment PCInterestedProductItemBuyer_Fragment on MatchingProduct {
      productId: number
      displayName
      image {
        thumb400x400
      }
      representativeWeight
      repMarketPriceDiff {
        latestDailyMarketPrice
        dailyMarketPriceDiffRate
        dailyMarketPriceDiff
      }
    }
`)

@react.component
let make = (~query) => {
  let {
    displayName,
    image: {thumb400x400},
    productId,
    repMarketPriceDiff,
    representativeWeight,
  } = Fragment.use(query)

  <React.Suspense fallback={<MatchingProductDiffPriceListItem.Placeholder />}>
    <Next.Link href={`/products/${productId->Int.toString}`}>
      <div
        className=%twc(
          "interactable cursor-pointer rounded-2xl hover:bg-[#1F20240A] active:bg-[#1F202414] duration-200 ease-in-out"
        )
        key={productId->Int.toString}>
        {switch repMarketPriceDiff {
        | Some(diff) =>
          <MatchingProductDiffPriceListItem
            image={thumb400x400}
            name={displayName}
            representativeWeight
            price={diff.latestDailyMarketPrice}
            diffPrice={diff.dailyMarketPriceDiff}
            diffRate={diff.dailyMarketPriceDiffRate}
          />
        | None =>
          <MatchingProductDiffPriceListItem
            image={thumb400x400}
            name={displayName}
            representativeWeight
            price={-1}
            diffPrice=None
            diffRate=None
          />
        }}
      </div>
    </Next.Link>
  </React.Suspense>
}
