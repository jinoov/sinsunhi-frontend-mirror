type props = {
  query: Js.Dict.t<string>,
  deviceType: DeviceDetect.deviceType,
  gnbBanners: array<GnbBannerListBuyerQuery_graphql.Types.response_gnbBanners>,
  mainBanners: array<ShopMainMainBannerBuyerQuery_graphql.Types.response_mainBanners>,
  subBanners: array<ShopMainSubBannerBuyerQuery_graphql.Types.response_subBanners>,
  categories: array<ShopMainCategoryListBuyerQuery_graphql.Types.response_mainDisplayCategories>,
  displayCategories: array<ShopCategorySelectBuyerQuery_graphql.Types.response_displayCategories>,
}
type params
type previewData

let default = (~props) => {
  let {deviceType, gnbBanners, mainBanners, subBanners, categories, displayCategories} = props
  <ShopMain_Buyer deviceType gnbBanners mainBanners subBanners categories displayCategories />
}

let getServerSideProps = (ctx: Next.GetServerSideProps.context<props, params, previewData>) => {
  let deviceType = DeviceDetect.detectDeviceFromCtx2(ctx.req)
  GnbBannerList_Buyer.Query.fetchPromised(~environment=RelayEnv.envSinsunMarket, ~variables=(), ())
  |> Js.Promise.then_((res1: GnbBannerListBuyerQuery_graphql.Types.response) => {
    ShopMain_MainBanner_Buyer.Query.fetchPromised(
      ~environment=RelayEnv.envSinsunMarket,
      ~variables=(),
      (),
    ) |> Js.Promise.then_((res2: ShopMainMainBannerBuyerQuery_graphql.Types.response) => {
      ShopMain_SubBanner_Buyer.Query.fetchPromised(
        ~environment=RelayEnv.envSinsunMarket,
        ~variables=(),
        (),
      ) |> Js.Promise.then_((res3: ShopMainSubBannerBuyerQuery_graphql.Types.response) => {
        ShopMain_CategoryList_Buyer.Query.fetchPromised(
          ~environment=RelayEnv.envSinsunMarket,
          ~variables={onlyDisplayable: true},
          (),
        ) |> Js.Promise.then_((res4: ShopMainCategoryListBuyerQuery_graphql.Types.response) => {
          ShopCategorySelect_Buyer.Query.fetchPromised(
            ~environment=RelayEnv.envSinsunMarket,
            ~variables={onlyDisplayable: Some(true), types: Some([#NORMAL]), parentId: None},
            (),
          ) |> Js.Promise.then_((res5: ShopCategorySelectBuyerQuery_graphql.Types.response) => {
            Js.Promise.resolve({
              "props": {
                "query": ctx.query,
                "deviceType": deviceType,
                "gnbBanners": res1.gnbBanners,
                "mainBanners": res2.mainBanners,
                "subBanners": res3.subBanners,
                "categories": res4.mainDisplayCategories,
                "displayCategories": res5.displayCategories,
              },
            })
          })
        })
      })
    })
  })
  |> Js.Promise.catch(err => {
    Js.log2("에러 GnbBannerListBuyerQuery", err)
    Js.Promise.resolve({
      "props": {
        "query": ctx.query,
        "deviceType": deviceType,
        "gnbBanners": [],
        "mainBanners": [],
        "subBanners": [],
        "categories": [],
        "displayCategories": [],
      },
    })
  })
}
