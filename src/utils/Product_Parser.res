module Type = {
  // 서비스에서 지원하는 상품 타입을 관리한다.
  /*
   * Normal: 일반
   * Quotable: 일반 + 견적문의 가능
   * Quoted: 견적
   * Matching: 매칭
   */
  type t = Normal | Quotable | Quoted | Matching

  let decode = (s: string) => {
    switch s {
    | "NormalProduct" => Some(Normal)
    | "QuotableProduct" => Some(Quotable)
    | "QuotedProduct" => Some(Quoted)
    | "MatchingProduct" => Some(Matching)
    | _ => None
    }
  }

  let encode = t => {
    switch t {
    | Normal => "NormalProduct"
    | Quotable => "QuotableProduct"
    | Quoted => "QuotedProduct"
    | Matching => "MatchingProduct"
    }
  }
}

module Matching = {
  module MarketPrice = {
    type t = {
      dealingDate: string,
      higher: option<int>,
      mean: option<int>,
      lower: option<int>,
    }

    let make = (~dealingDate, ~higher, ~mean, ~lower) => {
      dealingDate: dealingDate,
      higher: higher,
      mean: mean,
      lower: lower,
    }
  }

  module Chart = {
    module Payload = {
      type t = {
        dates: array<string>,
        highers: array<option<float>>,
        means: array<option<float>>,
        lowers: array<option<float>>,
      }

      let isEmpty = (raw: array<MarketPrice.t>) => {
        raw->Array.every(({higher, mean, lower}) => {
          higher->Option.isNone && mean->Option.isNone && lower->Option.isNone
        })
      }

      let make = (marketPrices: array<MarketPrice.t>, ~representativeWeight) => {
        switch marketPrices->isEmpty {
        // 7일치의 모든 데이터가 null인 경우
        | true => None

        | false => {
            let init = (list{}, list{}, list{}, list{})

            let (dateList, higherList, meanList, lowerList) = marketPrices->Array.reduce(init, (
              prev,
              curr,
            ) => {
              let (prevDates, prevHighers, prevMeans, prevLowers) = prev
              let formatDate = dateStr => dateStr->DateFns.parseISO->DateFns.format("M.dd")
              let multiply = (f, i) => (i->Int.toFloat *. f)->Locale.Float.round0 // 금액이므로 소수점 이하는 반올림한다

              (
                list{curr.dealingDate->formatDate, ...prevDates},
                list{curr.higher->Option.map(representativeWeight->multiply), ...prevHighers},
                list{curr.mean->Option.map(representativeWeight->multiply), ...prevMeans},
                list{curr.lower->Option.map(representativeWeight->multiply), ...prevLowers},
              )
            })

            Some({
              dates: dateList->List.reverse->List.toArray,
              highers: higherList->List.reverse->List.toArray,
              means: meanList->List.reverse->List.toArray,
              lowers: lowerList->List.reverse->List.toArray,
            })
          }
        }
      }
    }

    module Group = {
      type t = {
        high: option<Payload.t>,
        medium: option<Payload.t>,
        low: option<Payload.t>,
      }

      let make = (~high, ~medium, ~low) => {
        high: high,
        medium: medium,
        low: low,
      }
    }

    module Graph = {
      let make = (chartData: Payload.t) => {
        let {dates, highers, means, lowers} = chartData

        Echarts.Instance.option(
          ~tooltip=Echarts.Instance.ChartOption({
            "trigger": "axis",
            "backgroundColor": "rgba(38,38,38,1)",
            "textStyle": {
              "color": "rgba(255, 255, 255, 1)",
            },
          }),
          ~grid=Echarts.Instance.ChartOption({
            "right": "16px",
            "left": "50px",
          }),
          ~xAxis=Echarts.Instance.ChartOption({
            "boundaryGap": false,
            "data": dates,
            "axisTick": {"show": false},
            "axisPointer": {
              "show": true,
            },
          }),
          ~yAxis=Echarts.Instance.ChartOption({
            "type": "value",
          }),
          ~series=[
            Echarts.Instance.ChartOption({
              "type": "line",
              "name": "",
              "data": highers,
              "connectNulls": true,
              "itemStyle": {"color": "#ffddbd"},
              "lineStyle": {"color": "#ffddbd"},
            }),
            Echarts.Instance.ChartOption({
              "type": "line",
              "name": "",
              "data": means,
              "connectNulls": true,
              "itemStyle": {"color": "#0bb25f"},
              "lineStyle": {"color": "#0bb25f"},
            }),
            Echarts.Instance.ChartOption({
              "type": "line",
              "name": "",
              "data": lowers,
              "connectNulls": true,
              "itemStyle": {"color": "#dcdfe3"},
              "lineStyle": {"color": "#dcdfe3"},
            }),
          ],
          (),
        )
      }
    }

    module Table = {
      type t = {
        higherMax: float,
        higherMin: float,
        meanMax: float,
        meanMin: float,
        lowerMax: float,
        lowerMin: float,
      }

      let reduce = (arr, init, fn) => arr->Array.keepMap(x => x)->Array.reduce(init, fn)
      let getMax = arr => arr->reduce(min_float, max)
      let getMin = arr => arr->reduce(max_float, min)

      let make = ({highers, means, lowers}: Payload.t) => {
        higherMax: highers->getMax,
        higherMin: highers->getMin,
        meanMax: means->getMax,
        meanMin: means->getMin,
        lowerMax: lowers->getMax,
        lowerMin: lowers->getMin,
      }
    }
  }
}
