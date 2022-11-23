module Fragment = %relay(`
    fragment MOInterestedProductItemBuyer_Fragment on MatchingProduct {
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
      <div className=%twc("interactable")>
        <MatchingProductDiffPriceListItem
          image={thumb400x400}
          name={displayName}
          representativeWeight
          price={repMarketPriceDiff
          ->Option.map(({latestDailyMarketPrice}) => latestDailyMarketPrice)
          ->Option.getWithDefault(-1)}
          diffPrice={repMarketPriceDiff->Option.flatMap(({dailyMarketPriceDiff}) =>
            dailyMarketPriceDiff
          )}
          diffRate={repMarketPriceDiff->Option.flatMap(({dailyMarketPriceDiffRate}) =>
            dailyMarketPriceDiffRate
          )}
        />
      </div>
    </Next.Link>
  </React.Suspense>
}
