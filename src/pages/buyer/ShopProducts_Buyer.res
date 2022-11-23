/*
 * 1. 컴포넌트 위치
 *    구 전체상품 페이지
 *
 * 2. 역할
 *    기존 전체상품 url 변경(/products/all -> /products)
 *    기존에 공유된 url 진입에 대응하기 위해, 구 url로 진입하는 경우 신 url로 redirect 시켜준다.
 *    적용일: 2022.07.04
 *    제거 예정일: 2022.08.01
 */

type props = {
  query: Js.Dict.t<string>,
  deviceType: DeviceDetect.deviceType,
}
type params
type previewData

let default = (~props) => {
  let {deviceType} = props
  let {useRouter, replace} = module(Next.Router)
  let router = useRouter()
  React.useEffect0(() => {
    router->replace(`/products`)
    None
  })

  <PLP_DisplayCategory_Buyer.Placeholder deviceType />
}

let getServerSideProps = (ctx: Next.GetServerSideProps.context<props, params, previewData>) => {
  open ServerSideHelper
  let environment = SinsunMarket(Env.graphqlApiUrl)->RelayEnv.environment
  let gnbAndCategoryQuery = environment->gnbAndCategory

  let deviceType = DeviceDetect.detectDeviceFromCtx2(ctx.req)

  gnbAndCategoryQuery->makeResultWithQuery(~environment, ~extraProps={"deviceType": deviceType})
}
