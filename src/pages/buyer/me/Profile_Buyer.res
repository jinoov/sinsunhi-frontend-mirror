module Query = %relay(`
  query ProfileBuyer_Query {
    viewer {
      ...MyInfoProfileBuyer_Fragment
      ...MyInfoProfileSummaryBuyer_Fragment
    }
  }
`)

module Content = {
  module PC = {
    @react.component
    let make = () => {
      let queryData = Query.use(~variables=(), ())

      {
        switch queryData.viewer {
        | Some(viewer) => <MyInfo_Profile_Buyer.PC query={viewer.fragmentRefs} />
        | None => <div> {`계정정보를 가져오는데 실패했습니다`->React.string} </div>
        }
      }
    }
  }

  module Mobile = {
    @react.component
    let make = () => {
      let queryData = Query.use(~variables=(), ())

      {
        switch queryData.viewer {
        | Some(viewer) => <> <MyInfo_Profile_Buyer.Mobile query={viewer.fragmentRefs} /> </>
        | None => <div> {`계정정보를 가져오는데 실패했습니다`->React.string} </div>
        }
      }
    }
  }
}

type props = {
  deviceType: DeviceDetect.deviceType,
  gnbBanners: array<GnbBannerListBuyerQuery_graphql.Types.response_gnbBanners>,
  displayCategories: array<ShopCategorySelectBuyerQuery_graphql.Types.response_displayCategories>,
}
type params
type previewData

let default = ({deviceType, gnbBanners, displayCategories}) => {
  let router = Next.Router.useRouter()
  <>
    <div className=%twc("w-full min-h-screen")>
      {switch deviceType {
      | DeviceDetect.PC => <>
          <div className=%twc("flex")>
            <Header_Buyer.PC key=router.asPath gnbBanners displayCategories />
          </div>
          <Authorization.Buyer title=`신선하이` ssrFallback={<MyInfo_Skeleton_Buyer.PC />}>
            <RescriptReactErrorBoundary
              fallback={_ =>
                <div> {`계정정보를 가져오는데 실패했습니다`->React.string} </div>}>
              <React.Suspense fallback={<MyInfo_Skeleton_Buyer.PC />}>
                <Content.PC />
              </React.Suspense>
            </RescriptReactErrorBoundary>
          </Authorization.Buyer>
          <Footer_Buyer.PC />
        </>
      | DeviceDetect.Unknown
      | DeviceDetect.Mobile => <>
          <Header_Buyer.Mobile key=router.asPath />
          <RescriptReactErrorBoundary
            fallback={_ =>
              <div> {`계정정보를 가져오는데 실패했습니다`->React.string} </div>}>
            <React.Suspense fallback={React.null}>
              <Authorization.Buyer title=`신선하이`> <Content.Mobile /> </Authorization.Buyer>
            </React.Suspense>
          </RescriptReactErrorBoundary>
        </>
      }}
    </div>
  </>
}

let getServerSideProps = (ctx: Next.GetServerSideProps.context<props, params, previewData>) => {
  let deviceType = DeviceDetect.detectDeviceFromCtx2(ctx.req)

  let gnb = () =>
    GnbBannerList_Buyer.Query.fetchPromised(
      ~environment=RelayEnv.envSinsunMarket,
      ~variables=(),
      (),
    )
  let displayCategories = () =>
    ShopCategorySelect_Buyer.Query.fetchPromised(
      ~environment=RelayEnv.envSinsunMarket,
      ~variables={onlyDisplayable: Some(true), types: Some([#NORMAL]), parentId: None},
      (),
    )

  Js.Promise.all2((gnb(), displayCategories()))
  |> Js.Promise.then_(((
    gnb: GnbBannerListBuyerQuery_graphql.Types.response,
    displayCategories: ShopCategorySelectBuyerQuery_graphql.Types.response,
  )) => {
    Js.Promise.resolve({
      "props": {
        "deviceType": deviceType,
        "gnbBanners": gnb.gnbBanners,
        "displayCategories": displayCategories.displayCategories,
      },
    })
  })
  |> Js.Promise.catch(err => {
    Js.log2(`에러 gnb preload`, err)
    Js.Promise.resolve({
      "props": {
        "deviceType": deviceType,
        "gnbBanners": [],
        "displayCategories": [],
      },
    })
  })
}
