@module("../../../../../public/assets/demeter-chart-placeholder.svg")
external placeholderIcon: string = "default"

let echart = Next.Dynamic.dynamic(() => {
  Next.Dynamic.import_("../../../../bindings/Echarts.mjs") |> Js.Promise.then_(mod => mod["make"])
}, Next.Dynamic.options(~ssr=false, ()))

module Component = {
  type props = {
    id: string,
    option: Echarts.Instance.option,
    className: string,
  }

  @react.component
  let make = (~as_, ~id, ~option, ~className) => React.createElement(as_, {id, option, className})
}

module Fragment = %relay(`
  fragment PDPMatching2Demeter_fragment on MatchingProduct {
    number
    representativeWeight
    weeklyMarketPrices2 {
      priceGroupPriority
      marketPrices {
        dealingDate
        higher
        lower
        mean
      }
    }
  }
`)

@react.component
let make = (~query, ~selectedPriority) => {
  let {representativeWeight, number, weeklyMarketPrices2} = query->Fragment.use

  // 1. Find out the priceGroupPriority using the selected qualityStandard
  // 2. Get the matched price fluctuation
  open Product_Parser.Matching

  let weeklyPrice =
    weeklyMarketPrices2
    ->Array.keep(weeklyPrice => weeklyPrice.priceGroupPriority === selectedPriority)
    ->Garter.Array.first

  let prices = switch weeklyPrice {
  | None => None
  | Some({marketPrices}) =>
    marketPrices
    ->Array.map(price => {
      MarketPrice.make(
        ~dealingDate=price.dealingDate,
        ~higher=price.higher,
        ~lower=price.lower,
        ~mean=price.mean,
      )
    })
    ->Chart.Payload.make(~representativeWeight)
  }

  let id = {`chart-pdp-demeter-${number->Int.toString}-${selectedPriority->Int.toString}`}

  switch prices {
  | Some(prices) =>
    <Component key=id as_=echart id option={prices->Chart.Graph.make} className="h-80" />
  | None =>
    <div className="flex flex-col items-center justify-center h-40">
      <img src=placeholderIcon className="w-8 h-auto mb-2 brightness-150" />
      <div className="text-sm text-gray-500 font-light">
        {`지난 7일간 시세정보가 없습니다.`->React.string}
      </div>
    </div>
  }
}
