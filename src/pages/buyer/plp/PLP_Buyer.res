/*
 * 1. 컴포넌트 위치
 *    PLP
 *
 * 2. 역할
 *    전시카테고리(category-id)가 파라메터가 전달되거나, `/categories/[cid]`인 경우 특정 전시 카테고리 내 상품리스트,
      전시카테고리(category-id)가 파라메터가 전달되지 않고, `/categories/[cid]`로 접근하지 않은 경우 전체 상품
 *
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
  let router = Next.Router.useRouter()
  let displayCategoryId = switch router.query->Js.Dict.get("cid") {
  | Some(_) as cid => cid
  | None => router.query->Js.Dict.get("category-id")
  }

  let (isCsr, setIsCsr) = React.Uncurried.useState(_ => false)

  React.useEffect0(() => {
    setIsCsr(._ => true)
    None
  })

  <>
    <Next.Head>
      <title> {`신선하이`->React.string} </title>
    </Next.Head>
    {switch isCsr {
    | false => <PLP_DisplayCategory_Buyer.Placeholder deviceType gnbBanners displayCategories />

    | true =>
      switch displayCategoryId {
      // 전체 상품
      | None => <PLP_All_Buyer deviceType gnbBanners displayCategories />

      // 특정 전시카테고리 내 상품
      | Some(displayCategoryId') =>
        <PLP_DisplayCategory_Buyer
          deviceType displayCategoryId=displayCategoryId' gnbBanners displayCategories
        />
      }
    }}
  </>
}

let getServerSideProps = (ctx: Next.GetServerSideProps.context<props, params, previewData>) => {
  let deviceType = DeviceDetect.detectDeviceFromCtx2(ctx.req)
  GnbBannerList_Buyer.Query.fetchPromised(~environment=RelayEnv.envSinsunMarket, ~variables=(), ())
  |> Js.Promise.then_((res1: GnbBannerListBuyerQuery_graphql.Types.response) =>
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
      })
    )
  )
  |> Js.Promise.catch(err => {
    Js.log2("에러 GnbBannerListBuyerQuery", err)
    Js.Promise.resolve({
      "props": {
        "query": ctx.query,
        "deviceType": deviceType,
        "gnbBanners": [],
        "displayCategories": [],
      },
    })
  })
}
