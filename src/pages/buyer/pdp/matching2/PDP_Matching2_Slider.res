module Fragment = %relay(`
  fragment PDPMatching2Slider_fragment on MatchingProduct {
    representativeWeight
    transportationFreights {
      availableWeight
      km50
      km150
    }
  }
`)

// Step for the slide
let priceStep = 100
// Cut the price by the step to set min/max price
let stepPrice = (price: float) =>
  ((price /. priceStep->Float.fromInt)->Js.Math.round *. priceStep->Float.fromInt)->Float.toInt
let maxWeight = 10000

type colored =
  | Green
  | Yellow
  | Red

let checkPriceColor = (newPrice: int, basePrice: option<int>) => {
  switch basePrice {
  | Some(basePrice) =>
    let bpFloat = basePrice->Int.toFloat
    let npFloat = newPrice->Int.toFloat

    if bpFloat *. 0.92 <= npFloat {
      // -8% 이상 ~ +20%
      Green
    } else if bpFloat *. 0.92 > npFloat && bpFloat *. 0.85 <= npFloat {
      // -15% 이상 ~ -8% 미만
      Yellow
    } else {
      // -20% 이상 ~ -15% 미만
      Red
    }
  | None => Red
  }
}

let checkWeightColor = (weight: int) => {
  if weight >= 500 {
    Green
  } else if weight >= 100 && weight < 500 {
    Yellow
  } else {
    Red
  }
}

type freight = PDPMatching2Slider_fragment_graphql.Types.fragment_transportationFreights

let sorter = (p: freight, n: freight) => p.availableWeight - n.availableWeight

let findPoint = (freightList: array<freight>, weight: int) => {
  freightList
  ->Array.keep(freight => freight.availableWeight >= weight)
  ->SortArray.stableSortBy(sorter)
  ->Garter.Array.first
}

type pricePerKg = int

@react.component
let make = (
  ~query,
  ~quotePrice,
  ~quoteWeight,
  ~setPrice,
  ~setWeight,
  ~price: option<pricePerKg>,
) => {
  let {representativeWeight, transportationFreights} = query->Fragment.use

  let (priceSliderBgColor, priceSliderTextColor, priceNotice) = switch checkPriceColor(
    quotePrice,
    price,
  ) {
  | Green => ("bg-primary", "text-primary", "합리적인")
  | Yellow => ("bg-yellow-600", "text-yellow-600", "낮은")
  | Red => ("bg-red-600", "text-red-600", "매우 낮은")
  }

  let weightType = checkWeightColor(quoteWeight)
  let (weightSliderBgColor, weightSliderTextColor, weightNotice) = switch weightType {
  | Green => ("bg-primary", "text-primary", "1.5일 이내")
  | Yellow => ("bg-yellow-600", "text-yellow-600", "2일 이내")
  | Red => ("bg-red-600", "text-red-600", "")
  }

  let freight = transportationFreights->findPoint(quoteWeight)

  <>
    <div className="py-2 mb-4">
      <div className="flex justify-between mb-5 items-baseline">
        <div className="font-light text-gray-500">
          {`${representativeWeight->Float.toString}kg 당 가격`->React.string}
        </div>
        <div className="font-semibold text-xl">
          {`${quotePrice->Locale.Int.show} 원`->React.string}
        </div>
      </div>
      <RadixUI.Slider.Root
        min={(price->Option.getWithDefault(0)->Int.toFloat *. 0.8 *. representativeWeight)
          ->stepPrice}
        max={(price->Option.getWithDefault(0)->Int.toFloat *. 1.2 *. representativeWeight)
          ->stepPrice}
        value=[quotePrice]
        step=priceStep
        onValueChange={arr => {
          switch arr {
          | [v] => v->setPrice
          | _ => ()
          }
        }}
        className="relative flex items-center rounded cursor-pointer">
        <RadixUI.Slider.Track className="relative flex-grow rounded-full h-2 mx-1 bg-slate-100">
          <RadixUI.Slider.Range
            className={`absolute rounded-2xl rounded-r-none h-full ${priceSliderBgColor} transition-colors duration-150`}
          />
        </RadixUI.Slider.Track>
        <RadixUI.Slider.Thumb asChild=true className="focus:outline-none">
          <div className="py-3 select-none touch-none ">
            <div
              className={`w-5 h-5 rounded-[50%] shadow-md shadow-gray-250 ${priceSliderBgColor} transition-colors duration-150`}
            />
          </div>
        </RadixUI.Slider.Thumb>
      </RadixUI.Slider.Root>
    </div>
    <div className="py-4 mb-6">
      <div className="flex justify-between mb-5 items-baseline">
        <div className="font-light text-gray-500"> {`주문량`->React.string} </div>
        <div className="font-semibold text-xl">
          {`${quoteWeight->Locale.Int.show} kg`->React.string}
        </div>
      </div>
      <RadixUI.Slider.Root
        min={representativeWeight->Float.toInt}
        max={Js.Math.floor(maxWeight->Int.toFloat /. representativeWeight) *
        representativeWeight->Float.toInt}
        value=[quoteWeight]
        step={representativeWeight->Float.toInt}
        onValueChange={arr => {
          switch arr {
          | [v] =>
            if v === 0 {
              10
            } else if v >= maxWeight && mod(maxWeight, representativeWeight->Float.toInt) !== 0 {
              v - representativeWeight->Float.toInt
            } else {
              v
            }->setWeight
          | _ => ()
          }
        }}
        className="relative flex items-center rounded cursor-pointer">
        <RadixUI.Slider.Track className="relative flex-grow rounded-full h-2 mx-1 bg-[#F0F2F5]">
          <RadixUI.Slider.Range
            className={`absolute rounded-2xl rounded-r-none h-full ${weightSliderBgColor} transition-colors duration-150`}
          />
        </RadixUI.Slider.Track>
        <RadixUI.Slider.Thumb asChild=true className="focus:outline-none">
          <div className="py-3 select-none touch-none ">
            <div
              className={`w-5 h-5 rounded-[50%] shadow-md shadow-gray-250 ${weightSliderBgColor} transition-colors duration-150`}
            />
          </div>
        </RadixUI.Slider.Thumb>
      </RadixUI.Slider.Root>
    </div>
    <div className="font-light mb-8">
      <div className="mb-2 flex items-baseline">
        <div className="w-6">
          <IconPouchWon className="w-4 h-4 -mb-1 fill-gray-400" />
        </div>
        <div className="w-full">
          <span> {`평균 시세 대비`->React.string} </span>
          <span className={`${priceSliderTextColor} font-semibold transition-colors duration-150`}>
            {` ${priceNotice} 수준`->React.string}
          </span>
          <span> {`입니다.`->React.string} </span>
        </div>
      </div>
      <div className="mb-2 flex items-baseline">
        <div className="w-6">
          <IconClock5 className="w-4 h-4 -mb-1 fill-gray-400" />
        </div>
        <div className="w-full">
          {switch weightType {
          | Green | Yellow =>
            <>
              <span> {`평균`->React.string} </span>
              <span
                className={`${weightSliderTextColor} font-semibold transition-colors duration-150`}>
                {` ${weightNotice}`->React.string}
              </span>
              <span> {` 매칭될 확률이 높습니다.`->React.string} </span>
            </>
          | Red =>
            <span>
              {`적은 수량의 경우, 생산자를 찾는데 오래걸릴 수 있습니다.`->React.string}
            </span>
          }}
        </div>
      </div>
      {switch freight {
      | Some(freight) =>
        <div className="flex items-baseline">
          <div className="w-6">
            <IconLocationMarker className="w-4 h-4 -mb-1 fill-gray-400" />
          </div>
          <div className="w-full">
            <div>
              <span> {`50km 기준 화물비`->React.string} </span>
              <span className="font-semibold">
                {` ${freight.km50->Locale.Int.show}원`->React.string}
              </span>
            </div>
            <div>
              <span> {`150km 기준 화물비`->React.string} </span>
              <span className="font-semibold">
                {` ${freight.km150->Locale.Int.show}원`->React.string}
              </span>
              <span> {`이 예상됩니다.`->React.string} </span>
            </div>
          </div>
        </div>

      | None => React.null
      }}
    </div>
  </>
}
