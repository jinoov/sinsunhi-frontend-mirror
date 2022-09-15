@module("../../../../../public/assets/demeter-chart-placeholder.svg")
external placeholderIcon: string = "default"

module Fragment = %relay(`
  fragment PDPMatchingDemeterBuyer_fragment on MatchingProduct {
    number
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

module ChartHook = {
  module Data = {
    let use = (~query) => {
      let {weeklyMarketPrices, representativeWeight} = query->Fragment.use

      switch weeklyMarketPrices {
      | None => None

      | Some({high, medium, low}) =>
        open Product_Parser.Matching
        Some(
          Chart.Group.make(
            ~high=high
            ->Array.map(({dealingDate, higher, mean, lower}) =>
              MarketPrice.make(~dealingDate, ~higher, ~mean, ~lower)
            )
            ->Chart.Payload.make(~representativeWeight),
            ~medium=medium
            ->Array.map(({dealingDate, higher, mean, lower}) =>
              MarketPrice.make(~dealingDate, ~higher, ~mean, ~lower)
            )
            ->Chart.Payload.make(~representativeWeight),
            ~low=low
            ->Array.map(({dealingDate, higher, mean, lower}) =>
              MarketPrice.make(~dealingDate, ~higher, ~mean, ~lower)
            )
            ->Chart.Payload.make(~representativeWeight),
          ),
        )
      }
    }
  }

  module Status = {
    open Product_Parser.Matching
    type t =
      | Unknown // SSR
      | Unauthorized // 미인증
      | Empty // 최근 7일치의 시세 데이터가 모두 없음
      | Ok(Chart.Payload.t) // 표현할 데이터가 정상적으로 존재함

    let use = chart => {
      let user = CustomHooks.User.Buyer.use2()
      switch (user, chart) {
      | (Unknown, _) => Unknown
      | (NotLoggedIn, _) => Unauthorized
      | (LoggedIn(_), None) => Empty
      | (LoggedIn(_), Some(chart')) => Ok(chart')
      }
    }
  }
}

@react.component
let make = (~query, ~selectedGroup) => {
  let router = Next.Router.useRouter()
  let chartGroup = ChartHook.Data.use(~query)
  let {number} = query->Fragment.use
  let selectedChart = {
    switch chartGroup {
    | Some({high}) if selectedGroup == "high" => high
    | Some({medium}) if selectedGroup == "medium" => medium
    | Some({low}) if selectedGroup == "low" => low
    | _ => None
    }
  }

  switch selectedChart->ChartHook.Status.use {
  | Unknown =>
    <div className=%twc("w-full pt-[113%] relative")>
      <img
        className=%twc("w-full h-full object-contain absolute top-0 left-0")
        src="/images/chart_placeholder.png"
      />
    </div>

  | Unauthorized =>
    <div className=%twc("w-full pt-[113%] relative")>
      <img
        className=%twc("w-full h-full object-contain absolute top-0 left-0")
        src="/images/chart_placeholder.png"
      />
      <div
        className=%twc("absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 text-center")>
        <div className=%twc("text-center mb-4")>
          {`회원 로그인 후\n전국 도매시장 주간 시세를 확인해보세요`->ReactNl2br.nl2br}
        </div>
        <Next.Link href={`/buyer/signin?redirect=${router.asPath}`}>
          <a>
            <span className=%twc("mt-2 px-3 py-2 rounded-xl border border-primary text-primary")>
              {`로그인하고 시세 확인하기`->React.string}
            </span>
          </a>
        </Next.Link>
      </div>
    </div>

  | Empty =>
    <div className=%twc("w-full h-[112px] flex flex-col items-center justify-center")>
      <img className=%twc("w-6 h-6 object-contain") src=placeholderIcon />
      <span className=%twc("mt-3 text-gray-600 text-[13px]")>
        {`아직 시세 정보가 없습니다.`->React.string}
      </span>
    </div>

  | Ok(data) =>
    open Product_Parser.Matching

    let chartId = `pdp-demeter-chart-${number->Int.toString}-${selectedGroup}`
    let graphOption = data->Chart.Graph.make
    let tableData = data->Chart.Table.make

    <>
      <Echarts key=chartId id=chartId className=%twc("w-full h-[400px] px-3") option=graphOption />
      <div>
        <div className=%twc("px-5 grid grid-rows-4 grid-flow-col mb-2")>
          <div className=%twc("grid grid-cols-4 grid-flow-row pb-1 border-b")>
            <div className=%twc("col-start-3 text-right")> {`주간 최고`->React.string} </div>
            <div className=%twc("col-start-4 text-right")> {`주간 최저`->React.string} </div>
          </div>
          <div className=%twc("grid grid-cols-4 grid-flow-row py-2")>
            <div className=%twc("text-left inline-flex items-center")>
              <div className=%twc("w-2 h-2 rounded-full bg-orange-500 mr-1") />
              {`최대가`->React.string}
            </div>
            <div className=%twc("col-start-3 text-right")>
              <span className=%twc("font-bold")>
                {`${tableData.higherMax->Locale.Float.show(~digits=0)}원`->React.string}
              </span>
            </div>
            <div className=%twc("col-start-4 text-right")>
              <span className=%twc("font-bold")>
                {`${tableData.higherMin->Locale.Float.show(~digits=0)}원`->React.string}
              </span>
            </div>
          </div>
          <div className=%twc("grid grid-cols-4 grid-flow-row py-2")>
            <div className=%twc("text-left inline-flex items-center")>
              <div className=%twc("w-2 h-2 rounded-full bg-green-500 mr-1") />
              {`평균가`->React.string}
            </div>
            <div className=%twc("col-start-3 text-right")>
              <span className=%twc("font-bold")>
                {`${tableData.meanMax->Locale.Float.show(~digits=0)}원`->React.string}
              </span>
            </div>
            <div className=%twc("col-start-4 text-right")>
              <span className=%twc("font-bold")>
                {`${tableData.meanMin->Locale.Float.show(~digits=0)}원`->React.string}
              </span>
            </div>
          </div>
          <div className=%twc("grid grid-cols-4 grid-flow-row py-2")>
            <div className=%twc("text-left inline-flex items-center")>
              <div className=%twc("w-2 h-2 rounded-full bg-blue-500 mr-1") />
              {`최소가`->React.string}
            </div>
            <div className=%twc("col-start-3 text-right")>
              <span className=%twc("font-bold")>
                {`${tableData.lowerMax->Locale.Float.show(~digits=0)}원`->React.string}
              </span>
            </div>
            <div className=%twc("col-start-4 text-right")>
              <span className=%twc("font-bold")>
                {`${tableData.lowerMin->Locale.Float.show(~digits=0)}원`->React.string}
              </span>
            </div>
          </div>
        </div>
        <div className=%twc("text-right text-xs text-gray-500 px-5")>
          {`농림수산부식품교육문화정보원\n전국 도매시장 평균 거래가`->ReactNl2br.nl2br}
        </div>
      </div>
    </>
  }
}
