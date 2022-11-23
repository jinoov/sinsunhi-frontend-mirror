module Fragment = %relay(`
  fragment PDPMatching2MarketPricePrevious_fragment on MatchingProduct {
    qualityStandards {
      name
      priceGroupPriority
    }
    marketPriceDiffs {
      marketPriceDiff {
        dailyMarketPriceDiffRate
        latestDailyMarketPrice
        previousDailyMarketPrice
        previousWeeklyMarketPrice
        weeklyMarketPriceDiffRate
      }
      priceGroupPriority
    }
  }
`)

let renderDiff = (~price, ~compare, ~rate) => {
  let diff = price - compare
  let color = switch diff {
  | 0 => ""
  | diff => diff > 0 ? "text-red-600" : "text-blue-500"
  }

  <div className=color>
    <div title={compare->Locale.Int.show}>
      {(diff > 0 ? `+` : "")->React.string}
      {`${diff->Locale.Int.show}원`->React.string}
    </div>
    <div> {`(${(rate *. 100.)->Locale.Float.round1->Float.toString}%)`->React.string} </div>
  </div>
}

@react.component
let make = (~query, ~selectedPriority) => {
  let {marketPriceDiffs} = query->Fragment.use

  let diff =
    marketPriceDiffs
    ->Array.keep(diff => diff.priceGroupPriority === selectedPriority)
    ->Garter.Array.first

  switch diff {
  | None => React.null
  | Some({marketPriceDiff}) =>
    <div className="mb-12">
      <div className="font-semibold text-lg mb-5"> {`지난 7일 시세`->React.string} </div>
      <div
        className="grid grid-cols-3 py-2 px-3 text-[0.8125rem] bg-gray-50 rounded-lg font-light tracking-tighter">
        <div className=""> {`최종 평균가`->React.string} </div>
        <div className=""> {`전일 평균보다`->React.string} </div>
        <div className=""> {`지난 7일 평균보다`->React.string} </div>
      </div>
      <div className="grid grid-cols-3 p-3 text-sm items-center border-b">
        <div className="font-semibold">
          {`${marketPriceDiff.latestDailyMarketPrice->Locale.Int.show}원`->React.string}
        </div>
        {switch (
          marketPriceDiff.previousDailyMarketPrice,
          marketPriceDiff.dailyMarketPriceDiffRate,
        ) {
        | (Some(compare), Some(rate)) =>
          renderDiff(~price=marketPriceDiff.latestDailyMarketPrice, ~compare, ~rate)
        | _ => <div> {`-`->React.string} </div>
        }}
        {switch (
          marketPriceDiff.previousWeeklyMarketPrice,
          marketPriceDiff.weeklyMarketPriceDiffRate,
        ) {
        | (Some(compare), Some(rate)) =>
          renderDiff(~price=marketPriceDiff.latestDailyMarketPrice, ~compare, ~rate)
        | _ => <div> {`-`->React.string} </div>
        }}
      </div>
    </div>
  }
}
