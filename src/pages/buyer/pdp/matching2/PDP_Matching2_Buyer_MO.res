@get external style: Dom.element => Js.Dict.t<string> = "style"
module Fragment = %relay(`
  fragment PDPMatching2BuyerMO_fragment on MatchingProduct {
    productId: number
    description
    representativeWeight
    qualityStandards {
      name
      priceGroupPriority
    }
    recentMarketPrices {
      priceGroupPriority
      marketPrice {
        dealingDate
        mean
      }
    }
  
    ...PDPMatching2Title_fragment
    ...PDPMatching2Grade_fragment
    ...PDPMatching2Slider_fragment
    ...PDPMatching2Detail_fragment
    ...PDPMatching2Demeter_fragment
    ...PDPMatching2MarketPricePrevious_fragment
    ...PDPMatching2BuyableProducts_fragment
  }
`)

type quoteValues = {
  quotePrice: int,
  quoteWeight: int,
}
type sliderAction = SetPrice(int) | SetWeight(int) | Unset

module Matching2BuyerSeparator = {
  @react.component
  let make = (~class: option<string>=?, ()) => {
    <div
      className={"h-3 -mx-4 w-auto my-0 mb-5 bg-disabled-L3 " ++ class->Option.getWithDefault("")}
    />
  }
}

@react.component
let make = (~query) => {
  let {representativeWeight, qualityStandards, recentMarketPrices, fragmentRefs} =
    query->Fragment.use
  let wrapRef = React.useRef(Js.Nullable.null)

  // These 2 for the selected quality standards would be used in the other components.
  let ((selectedQuality, selectedPriority), setSelectedQuality) = React.Uncurried.useState(_ =>
    switch qualityStandards->Garter.Array.first {
    | Some(quality) => (quality.name, quality.priceGroupPriority)
    | None => ("", 0) // Using 0 is not safe...
    }
  )

  let (quoteValues, dispatch) = React.useReducer((state: quoteValues, action) => {
    switch action {
    | SetPrice(price) => {...state, quotePrice: price}
    | SetWeight(weight) => {...state, quoteWeight: weight}
    | _ => {quotePrice: 0, quoteWeight: 0}
    }
  }, {quotePrice: 0, quoteWeight: 1000})

  // To get the lastest market price for the selected quality standard, they need to query `qualityStandards` and `recentMarketprices`.
  // Then, struggling around the optionals to find out the price that makes it hard to keep the value while updating the UI.
  // So, let's keep it here, and set them free.
  let price = React.useMemo2(() => {
    switch recentMarketPrices
    ->Array.keep(marketPrice => marketPrice.priceGroupPriority === selectedPriority)
    ->Garter.Array.first {
    | None => None
    | Some({marketPrice}) => {
        // Set the market price, multiply by the representative weight
        // Slider is using the price that multiplied.
        (marketPrice.mean->Option.getWithDefault(0)->Int.toFloat *. representativeWeight)
        ->Float.toInt
        ->SetPrice
        ->dispatch
        // This will be used in any other places using the price per 1kg.
        marketPrice.mean
      }
    }
  }, (recentMarketPrices, selectedPriority))

  let setPrice = (quotePrice: int) => quotePrice->SetPrice->dispatch
  let setWeight = (quoteWeight: int) => quoteWeight->SetWeight->dispatch

  let onSubmitRefChanged = element => {
    element
    ->Js.Nullable.toOption
    ->Option.forEach(el => {
      let rect = ReactDOM.domElementToObj(el)["getBoundingClientRect"](.)

      wrapRef.current
      ->Js.Nullable.toOption
      ->Option.forEach(wrap => {
        wrap->style->Js.Dict.set("padding-bottom", `${rect["height"]}px`)
      })
    })
  }

  <div className="mx-auto max-w-3xl p-4" ref={ReactDOM.Ref.domRef(wrapRef)}>
    <Header_Buyer.Mobile.BackAndCart key="None" title="" />
    <PDP_Matching2_Title query=fragmentRefs />
    <PDP_Matching2_Grade query=fragmentRefs selectedQuality setSelectedQuality />
    <PDP_Matching2_Slider
      query=fragmentRefs
      quotePrice=quoteValues.quotePrice
      quoteWeight=quoteValues.quoteWeight
      setPrice
      setWeight
      price
    />
    <Matching2BuyerSeparator />
    {switch price {
    | Some(price) =>
      <PDP_Matching2_Compare price={(price->Int.toFloat *. representativeWeight)->Float.toInt} />

    | None => React.null
    }}
    <Matching2BuyerSeparator />
    <PDP_Matching2_Market_Price query=fragmentRefs selectedPriority />
    <Matching2BuyerSeparator />
    <PDP_Matching2_Detail query=fragmentRefs selectedQuality />
    // The component will determine whether show the separator or not according to the existence of the data.
    <PDP_Matching2_Buyable_Products query=fragmentRefs separator={<Matching2BuyerSeparator />} />
    <PDP_Matching2_Submit
      submitRef={ReactDOM.Ref.callbackDomRef(onSubmitRefChanged)}
      quotePrice=quoteValues.quotePrice
      quoteWeight=quoteValues.quoteWeight
      representativeWeight
    />
  </div>
}
