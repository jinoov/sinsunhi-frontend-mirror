module Query = %relay(`
  query LikeBuyer_Query {
    viewer {
      ...MyInfoProfileSummaryBuyer_Fragment
    }
  }
`)

module Content = {
  module PC = {
    @react.component
    let make = () => {
      let {viewer} = Query.use(~variables=(), ())

      {
        switch viewer {
        | Some(viewer') =>
          <MyInfo_Layout_Buyer query={viewer'.fragmentRefs}>
            <div
              className=%twc(
                "bg-white ml-4 rounded overflow-hidden w-full flex flex-col shadow-pane"
              )>
              <Like_List.PC />
            </div>
          </MyInfo_Layout_Buyer>
        | None => <div> {`계정정보를 가져오는데 실패했습니다`->React.string} </div>
        }
      }
    }
  }

  module MO = {
    @react.component
    let make = () => {
      <>
        <Like_List.MO />
      </>
    }
  }
}

type props = {
  deviceType: DeviceDetect.deviceType,
  gnbBanners: array<GnbBannerListBuyerQuery_graphql.Types.response_gnbBanners>,
  displayCategories: array<
    ShopCategorySelectBuyerQuery_graphql.Types.response_rootDisplayCategories,
  >,
}
type params
type previewData

let default = ({deviceType}) => {
  let router = Next.Router.useRouter()
  let (isCsr, setIsCsr) = React.Uncurried.useState(_ => false)

  React.useEffect0(_ => {
    setIsCsr(._ => true)
    None
  })

  switch isCsr {
  | true =>
    switch deviceType {
    | DeviceDetect.PC =>
      <div className=%twc("w-full h-screen flex flex-col")>
        <Header_Buyer.PC key=router.asPath />
        <Authorization.Buyer title={`신선하이`} ssrFallback={<MyInfo_Skeleton_Buyer.PC />}>
          <RescriptReactErrorBoundary
            fallback={_ =>
              <div> {`계정정보를 가져오는데 실패했습니다`->React.string} </div>}>
            <React.Suspense fallback={<MyInfo_Skeleton_Buyer.PC />}>
              <Content.PC />
            </React.Suspense>
          </RescriptReactErrorBoundary>
        </Authorization.Buyer>
        <Footer_Buyer.PC />
      </div>
    | DeviceDetect.Unknown
    | DeviceDetect.Mobile =>
      <>
        <Header_Buyer.Mobile key=router.asPath />
        <Authorization.Buyer
          title={`신선하이`} ssrFallback={<MyInfo_Skeleton_Buyer.Mobile.Main />}>
          <RescriptReactErrorBoundary
            fallback={_ =>
              <div> {`계정정보를 가져오는데 실패했습니다`->React.string} </div>}>
            <React.Suspense fallback={React.null}>
              <div className=%twc("flex-1")>
                <Content.MO />
              </div>
            </React.Suspense>
          </RescriptReactErrorBoundary>
        </Authorization.Buyer>
        <Bottom_Navbar deviceType />
      </>
    }

  | false => React.null
  }
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
      ~variables={onlyDisplayable: Some(true), types: Some([#NORMAL])},
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
        "displayCategories": displayCategories.rootDisplayCategories,
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
