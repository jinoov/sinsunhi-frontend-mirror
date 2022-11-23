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
        | Some(viewer) =>
          <>
            <MyInfo_Profile_Buyer.Mobile query={viewer.fragmentRefs} />
          </>
        | None => <div> {`계정정보를 가져오는데 실패했습니다`->React.string} </div>
        }
      }
    }
  }
}

type props = {deviceType: DeviceDetect.deviceType}
type params
type previewData

let default = ({deviceType}) => {
  let router = Next.Router.useRouter()
  <>
    {switch deviceType {
    | DeviceDetect.PC => {
        let oldUI =
          <div className=%twc("w-full min-h-screen")>
            <Header_Buyer.PC key=router.asPath />
            <Authorization.Buyer ssrFallback={<MyInfo_Skeleton_Buyer.PC />}>
              <RescriptReactErrorBoundary
                fallback={_ =>
                  <div>
                    {`계정정보를 가져오는데 실패했습니다`->React.string}
                  </div>}>
                <React.Suspense fallback={<MyInfo_Skeleton_Buyer.PC />}>
                  <Content.PC />
                </React.Suspense>
              </RescriptReactErrorBoundary>
            </Authorization.Buyer>
            <Footer_Buyer.PC />
          </div>

        <FeatureFlagWrapper featureFlag=#HOME_UI_UX fallback=oldUI>
          <div className=%twc("w-full min-h-screen bg-[#F0F2F5]")>
            <Header_Buyer.PC key=router.asPath />
            <Authorization.Buyer ssrFallback={<MyInfo_Skeleton_Buyer.PC />}>
              <RescriptReactErrorBoundary
                fallback={_ =>
                  <div>
                    {`계정정보를 가져오는데 실패했습니다`->React.string}
                  </div>}>
                <React.Suspense fallback={<MyInfo_Skeleton_Buyer.PC />}>
                  <Content.PC />
                </React.Suspense>
              </RescriptReactErrorBoundary>
            </Authorization.Buyer>
            <Footer_Buyer.PC />
          </div>
        </FeatureFlagWrapper>
      }

    | DeviceDetect.Unknown
    | DeviceDetect.Mobile =>
      <div className=%twc("w-full min-h-screen")>
        <Header_Buyer.Mobile key=router.asPath />
        <RescriptReactErrorBoundary
          fallback={_ =>
            <div> {`계정정보를 가져오는데 실패했습니다`->React.string} </div>}>
          <React.Suspense fallback={React.null}>
            <Authorization.Buyer title={`신선하이`}>
              <Content.Mobile />
            </Authorization.Buyer>
          </React.Suspense>
        </RescriptReactErrorBoundary>
        <Bottom_Navbar deviceType />
      </div>
    }}
  </>
}

let getServerSideProps = (ctx: Next.GetServerSideProps.context<props, params, previewData>) => {
  open ServerSideHelper
  let environment = SinsunMarket(Env.graphqlApiUrl)->RelayEnv.environment
  let gnbAndCategoryQuery = environment->gnbAndCategory

  let deviceType = DeviceDetect.detectDeviceFromCtx2(ctx.req)

  gnbAndCategoryQuery->makeResultWithQuery(~environment, ~extraProps={"deviceType": deviceType})
}
