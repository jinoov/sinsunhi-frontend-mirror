let dynamicMo = Next.Dynamic.dynamic(
  () =>
    Next.Dynamic.import_(
      "src/pages/buyer/pdp/matching/PDP_Matching_Buyer_MO.mjs",
    ) |> Js.Promise.then_(mod => mod["make"]),
  Next.Dynamic.options(~ssr=true, ()),
)

@react.component
let make = (~deviceType, ~query) => {
  switch deviceType {
  | DeviceDetect.Unknown => React.null
  | DeviceDetect.PC | DeviceDetect.Mobile =>
    <ReactUtil.Component as_=dynamicMo props={"query": query} /> // 초기 버전에선 모바일 뷰만 제공
  }
}
