let dynamicMo = Next.Dynamic.dynamic(
  () =>
    Next.Dynamic.import_(
      "src/pages/buyer/pdp/matching2/PDP_Matching2_Buyer_MO.mjs",
    ) |> Js.Promise.then_(mod => mod["make"]),
  Next.Dynamic.options(~ssr=true, ()),
)

@react.component
let make = (~deviceType, ~query) => {
  switch deviceType {
  | DeviceDetect.Unknown => React.null
  | DeviceDetect.PC | DeviceDetect.Mobile =>
    <ReactUtil.Component as_=dynamicMo props={"query": query} />
  }
}
