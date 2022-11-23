@react.component
let make = (~query, ~selectedPriority) => {
  <div className="mb-6">
    <div className="font-semibold text-lg"> {`도매시장 경매가`->React.string} </div>
    <PDP_Matching2_Demeter query selectedPriority />
    // By the renewal of PDP in 4Q 2022, the chart and the prices will be shown whether user logs in or not.
    // Forecast for the coming week and 2 weeks should be hidden for the guest users.
    <PDP_Matching2_Market_Price_Previous query selectedPriority />
    // <PDP_Matching2_Market_Price_Forecast />
    <div className="text-right text-xs text-gray-300 font-light">
      {`농림수산식품교육문화정보원 출처\n전국 도매시장 경매가`->ReactNl2br.nl2br}
    </div>
  </div>
}
