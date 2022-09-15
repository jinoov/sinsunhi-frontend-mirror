module Fragment = %relay(`
  fragment PDPMatchingEstimatorBuyer_fragment on MatchingProduct {
    representativeWeight
    weeklyMarketPrices {
      high {
        dealingDate
        higher
        mean
        lower
      }
      medium {
        dealingDate
        higher
        mean
        lower
      }
      low {
        dealingDate
        higher
        mean
        lower
      }
    }
  }
`)

module PriceVariation = {
  type color =
    | Green
    | Yellow
    | Red

  let make = (price, avgPrice) => {
    if price >= avgPrice {
      // 평균가 이상일 경우 녹색
      Green
    } else if price >= avgPrice *. 0.9 {
      // 평균가 미만 / 평균가의 90% 가격까진 주황색
      Yellow
    } else {
      // 평균가 90% 미만은 빨간색
      Red
    }
  }
}

module WeightVariation = {
  type expectDuration =
    | OneAndHalfDay
    | TwoDays
    | ThreeDays
    | FourDays
    | FiveDays
    | SixDays
    | SevenDaysOrLonger

  let makeExpectDuration = weight => {
    if weight >= 500 {
      OneAndHalfDay
    } else if weight >= 100 {
      TwoDays
    } else if weight >= 90 {
      ThreeDays
    } else if weight >= 80 {
      FourDays
    } else if weight >= 70 {
      FiveDays
    } else if weight >= 60 {
      SixDays
    } else {
      SevenDaysOrLonger
    }
  }

  type color =
    | Green
    | Yellow
    | Red

  let makeColor = weight => {
    if weight >= 500 {
      Green
    } else if weight >= 100 {
      Yellow
    } else {
      Red
    }
  }
}

type priceRange = {
  dealingDate: string,
  min: float,
  avg: float,
  max: float,
}

let makePriceRange = (~dealingDate, ~higher, ~mean, ~lower, ~representativeWeight) => {
  // 규격 변경으로 lower(최소가격)은 더이상 쓰이지 않지만, 데이터 유효성 검증차원에서 유무 검사는 유지한다.
  switch (higher, mean, lower) {
  | (Some(max), Some(avg), Some(_)) =>
    let multiply = (f1, f2) => (f1 *. f2)->Locale.Float.round0

    // min = 평균가의 70%
    {
      dealingDate,
      min: (avg->Int.toFloat *. 0.7)->multiply(representativeWeight),
      avg: avg->Int.toFloat->multiply(representativeWeight),
      max: max->Int.toFloat->multiply(representativeWeight),
    }->Some

  | _ => None
  }
}

// 유효한 최근 시세 정보를 가져온다
let makeLastAvailablePriceRange = (marketPrices: array<option<priceRange>>) => {
  marketPrices->Array.keepMap(x => x)->List.fromArray->List.reverse->List.head
}

let getLastAvailablePriceRange = (
  weeklyMarketPrices: PDPMatchingEstimatorBuyer_fragment_graphql.Types.fragment_weeklyMarketPrices,
  ~selectedGroup,
  ~representativeWeight,
) => {
  let {high, medium, low} = weeklyMarketPrices

  switch selectedGroup {
  | "high" =>
    high
    ->Array.map(({dealingDate, higher, mean, lower}) => {
      makePriceRange(~dealingDate, ~higher, ~mean, ~lower, ~representativeWeight)
    })
    ->makeLastAvailablePriceRange

  | "medium" =>
    medium
    ->Array.map(({dealingDate, higher, mean, lower}) => {
      makePriceRange(~dealingDate, ~higher, ~mean, ~lower, ~representativeWeight)
    })
    ->makeLastAvailablePriceRange

  | "low" =>
    low
    ->Array.map(({dealingDate, higher, mean, lower}) => {
      makePriceRange(~dealingDate, ~higher, ~mean, ~lower, ~representativeWeight)
    })
    ->makeLastAvailablePriceRange

  | _ => None
  }
}

module PriceSlider = {
  @react.component
  let make = (~weightLabel, ~priceLabel, ~value, ~setValue, ~color) => {
    <div className=%twc("flex flex-1 flex-col")>
      <span className=%twc("text-sm text-gray-600")> {weightLabel->React.string} </span>
      <span className=%twc("mt-1 text-2xl font-bold")> {priceLabel->React.string} </span>
      <div className=%twc("mt-3")>
        <RadixUI.Slider.Root
          min=0
          max=100
          value=[value]
          onValueChange={arr => {
            switch arr {
            | [v] => setValue(._ => v)
            | _ => ()
            }
          }}
          orientation={#horizontal}
          className=%twc("relative w-full h-1 flex items-center rounded-full cursor-pointer")>
          <RadixUI.Slider.Track
            className={%twc("relative flex-grow rounded-full h-1 bg-[#F0F2F5]")}>
            <RadixUI.Slider.Range className={%twc("absolute rounded-full h-full ") ++ color} />
          </RadixUI.Slider.Track>
          <RadixUI.Slider.Thumb asChild=true className=%twc("focus:outline-none")>
            <div className=%twc("w-4 h-8 flex items-center justify-center select-none touch-none ")>
              <div className={%twc("w-4 h-4 rounded-full bg-primary ") ++ color} />
            </div>
          </RadixUI.Slider.Thumb>
        </RadixUI.Slider.Root>
      </div>
    </div>
  }
}

module WeightSlider = {
  @react.component
  let make = (~value, ~setValue, ~color) => {
    let displayWeight = {
      if value == 1000 {
        `1T`
      } else if value >= 100 && value < 200 {
        `100Kg`
      } else if value == 0 {
        `10Kg`
      } else {
        `${value->Int.toString}Kg`
      }
    }
    let step = value <= 100 ? 10 : 100

    <div className=%twc("flex flex-1 flex-col")>
      <span className=%twc("text-sm text-gray-600")> {`주문량`->React.string} </span>
      <span className=%twc("mt-1  text-2xl font-bold")>
        {`${displayWeight} 이상`->React.string}
      </span>
      <div className=%twc("mt-3")>
        <RadixUI.Slider.Root
          min=0
          max=1000
          value=[value]
          onValueChange={arr => {
            switch arr {
            | [v] =>
              if v >= 100 && v < 200 {
                setValue(._ => 100)
              } else if v == 0 {
                setValue(._ => 10)
              } else {
                setValue(._ => v)
              }

            | _ => ()
            }
          }}
          orientation={#horizontal}
          step
          className=%twc("relative w-full h-1 flex items-center rounded-full cursor-pointer")>
          <RadixUI.Slider.Track
            className={%twc("relative flex-grow rounded-full h-1 bg-[#F0F2F5]")}>
            <RadixUI.Slider.Range className={%twc("absolute rounded-full h-full ") ++ color} />
          </RadixUI.Slider.Track>
          <RadixUI.Slider.Thumb asChild=true className=%twc("focus:outline-none")>
            <div className=%twc("w-4 h-8 flex items-center justify-center select-none touch-none ")>
              <div className={%twc("w-4 h-4 rounded-full bg-primary ") ++ color} />
            </div>
          </RadixUI.Slider.Thumb>
        </RadixUI.Slider.Root>
      </div>
    </div>
  }
}

module Estimator = {
  @react.component
  let make = (~representativeWeight, ~priceRange) => {
    let (pricePercent, setPricePercent) = React.Uncurried.useState(_ => 100)
    let (weight, setWeight) = React.Uncurried.useState(_ => 1000)

    let displayPrice = {
      let {min, max} = priceRange
      // 1% 당 가격: (최대가 - 최소가) / 100
      let perStep = (max -. min) /. 100.
      max -. (100. -. pricePercent->Int.toFloat) *. perStep
    }

    let priceVariation = {
      displayPrice->PriceVariation.make(priceRange.avg)
    }

    <div className=%twc("w-full py-6")>
      <span className=%twc("text-black font-bold text-lg")>
        {`매칭 계산기`->React.string}
      </span>
      <div className=%twc("w-full mt-5 flex")>
        {
          let color = switch priceVariation {
          | Green => %twc("bg-primary")
          | Yellow => %twc("bg-yellow-600")
          | Red => %twc("bg-red-600")
          }
          <PriceSlider
            value=pricePercent
            setValue=setPricePercent
            weightLabel={`${representativeWeight->Float.toString}kg 당 가격`}
            priceLabel={`${displayPrice->Locale.Float.show(~digits=0)}원`}
            color
          />
        }
        <div className=%twc("w-5") />
        {
          let color = switch weight->WeightVariation.makeColor {
          | Green => %twc("bg-primary")
          | Yellow => %twc("bg-yellow-600")
          | Red => %twc("bg-red-600")
          }
          <WeightSlider value=weight setValue=setWeight color />
        }
      </div>
      <div className=%twc("mt-5")>
        <div className=%twc("text-base text-gray-800 flex items-center")>
          <div className=%twc("w-1 h-1 rounded-full bg-gray-600 mr-2") />
          <span>
            {`평균 매칭가격 대비 `->React.string}
            {switch priceVariation {
            | Green =>
              <span className=%twc("text-primary font-bold")>
                {`합리적인 수준`->React.string}
              </span>
            | Yellow =>
              <span className=%twc("text-yellow-600 font-bold")>
                {`낮은 수준`->React.string}
              </span>
            | Red =>
              <span className=%twc("text-red-600 font-bold")>
                {`매우 낮은 수준`->React.string}
              </span>
            }}
            {`입니다.`->React.string}
          </span>
        </div>
        <div className=%twc("mt-2 text-base text-gray-800 flex items-center")>
          <div className=%twc("w-1 h-1 rounded-full bg-gray-600 mr-2") />
          {
            let textColor = switch weight->WeightVariation.makeColor {
            | Green => %twc(" text-primary")
            | Yellow => %twc(" text-yellow-600")
            | Red => %twc(" text-red-600")
            }

            switch weight->WeightVariation.makeExpectDuration {
            | OneAndHalfDay =>
              <span>
                {`평균`->React.string}
                <span className={%twc("font-bold") ++ textColor}>
                  {` 1.5일 이내 `->React.string}
                </span>
                {`매칭될 확률이 높습니다.`->React.string}
              </span>

            | TwoDays =>
              <span>
                {`평균`->React.string}
                <span className={%twc("font-bold") ++ textColor}>
                  {` 2일 이내 `->React.string}
                </span>
                {`매칭될 확률이 높습니다.`->React.string}
              </span>
            | ThreeDays =>
              <span>
                {`평균`->React.string}
                <span className={%twc("font-bold") ++ textColor}>
                  {` 3일 이내 `->React.string}
                </span>
                {`매칭될 확률이 높습니다.`->React.string}
              </span>
            | FourDays =>
              <span>
                {`평균`->React.string}
                <span className={%twc("font-bold") ++ textColor}>
                  {` 4일 이내 `->React.string}
                </span>
                {`매칭될 확률이 높습니다.`->React.string}
              </span>
            | FiveDays =>
              <span>
                {`평균`->React.string}
                <span className={%twc("font-bold") ++ textColor}>
                  {` 5일 이내 `->React.string}
                </span>
                {`매칭될 확률이 높습니다.`->React.string}
              </span>
            | SixDays =>
              <span>
                {`평균`->React.string}
                <span className={%twc("font-bold") ++ textColor}>
                  {` 6일 이내 `->React.string}
                </span>
                {`매칭될 확률이 높습니다.`->React.string}
              </span>
            | SevenDaysOrLonger =>
              <span>
                {`적은 수량의 경우, 생산자를 찾는데 오래걸릴 수 있습니다.`->React.string}
              </span>
            }
          }
        </div>
      </div>
    </div>
  }
}

@react.component
let make = (~selectedGroup, ~query) => {
  let {weeklyMarketPrices, representativeWeight} = query->Fragment.use

  let priceRange = {
    weeklyMarketPrices->Option.flatMap(
      getLastAvailablePriceRange(~selectedGroup, ~representativeWeight),
    )
  }

  switch priceRange {
  | None => React.null
  | Some(priceRange') =>
    <>
      <section className=%twc("px-4")>
        <Estimator priceRange=priceRange' representativeWeight />
      </section>
      <div className=%twc("w-full h-3 bg-gray-100") />
    </>
  }
}
