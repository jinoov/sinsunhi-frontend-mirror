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
  gnbBanners: array<GnbBannerListBuyerQuery_graphql.Types.response_gnbBanners>,
  displayCategories: array<ShopCategorySelectBuyerQuery_graphql.Types.response_displayCategories>,
}
type params
type previewData

let default = (~props) => {
  let {deviceType, gnbBanners, displayCategories} = props
  let {useRouter, replace} = module(Next.Router)
  let router = useRouter()
  React.useEffect0(() => {
    router->replace(`/products`)
    None
  })

  <PLP_DisplayCategory_Buyer.Placeholder deviceType gnbBanners displayCategories />
}

let getServerSideProps = (ctx: Next.GetServerSideProps.context<props, params, previewData>) => {
  let deviceType = DeviceDetect.detectDeviceFromCtx2(ctx.req)
  GnbBannerList_Buyer.Query.fetchPromised(
    ~environment=RelayEnv.envSinsunMarket,
    ~variables=(),
    (),
  ) |> Js.Promise.then_((res1: GnbBannerListBuyerQuery_graphql.Types.response) =>
    ShopCategorySelect_Buyer.Query.fetchPromised(
      ~environment=RelayEnv.envSinsunMarket,
      ~variables={onlyDisplayable: Some(true), types: Some([#NORMAL]), parentId: None},
      (),
    ) |> Js.Promise.then_((res2: ShopCategorySelectBuyerQuery_graphql.Types.response) =>
      Js.Promise.resolve({
        "props": {
          "query": ctx.query,
          "deviceType": deviceType,
          "gnbBanners": res1.gnbBanners,
          "displayCategories": res2.displayCategories,
        },
      }) |> Js.Promise.catch(
        err => {
          Js.log2("에러 GnbBannerListBuyerQuery", err)
          Js.Promise.resolve({
            "props": {
              "query": ctx.query,
              "deviceType": deviceType,
              "gnbBanners": [],
              "displayCategories": [],
            },
          })
        },
      )
    )
  )
}
