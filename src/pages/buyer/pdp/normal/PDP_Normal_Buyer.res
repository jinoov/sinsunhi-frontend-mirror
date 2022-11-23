/*
  1. 컴포넌트 위치
  PDP > 일반 상품
  
  2. 역할
  일반 상품의 상품 정보를 표현합니다.
*/

let dynamicPC = Next.Dynamic.dynamic(
  () =>
    Next.Dynamic.import_(
      "src/pages/buyer/pdp/normal/PDP_Normal_Buyer_PC.mjs",
    ) |> Js.Promise.then_(mod => mod["make"]),
  Next.Dynamic.options(~ssr=true, ()),
)

let dynamicMo = Next.Dynamic.dynamic(
  () =>
    Next.Dynamic.import_(
      "src/pages/buyer/pdp/normal/PDP_Normal_Buyer_MO.mjs",
    ) |> Js.Promise.then_(mod => mod["make"]),
  Next.Dynamic.options(~ssr=true, ()),
)

@react.component
let make = (~deviceType, ~query) => {
  switch deviceType {
  | DeviceDetect.Unknown => React.null
  | DeviceDetect.PC => <ReactUtil.Component as_=dynamicPC props={"query": query} />
  | DeviceDetect.Mobile => <ReactUtil.Component as_=dynamicMo props={"query": query} />
  }
}
