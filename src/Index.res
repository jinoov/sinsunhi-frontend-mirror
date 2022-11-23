type props = {deviceType: DeviceDetect.deviceType}
type params
type previewData

module Container = {
  @react.component
  let make = (~deviceType) => {
    let {features} = FeatureFlagWrapper.Query.use(~variables=(), ())

    let isMainRenewal =
      features
      ->Array.keep(({featureType}) => featureType == #HOME_UI_UX)
      ->Garter.Array.first
      ->Option.mapWithDefault(false, ({active}) => active)

    // 메인 홈 개편 피쳐플래그
    switch isMainRenewal {
    | false => <ShopMain_Buyer deviceType />
    | true =>
      switch deviceType {
      | DeviceDetect.Mobile => <MO_Main_Buyer />
      | DeviceDetect.PC
      | DeviceDetect.Unknown =>
        <PC_Main_Buyer />
      }
    }
  }
}

let default = (~props) => {
  let {deviceType} = props

  <React.Suspense fallback={`Loading...`->React.string}>
    <Container deviceType />
  </React.Suspense>
}

let getServerSideProps = (ctx: Next.GetServerSideProps.context<props, params, previewData>) => {
  open ServerSideHelper
  let deviceType = DeviceDetect.detectDeviceFromCtx2(ctx.req)
  let environment = SinsunMarket(Env.graphqlApiUrl)->RelayEnv.environment
  let features = environment->featureFlags

  FeatureFlagWrapper.Query.fetchPromised(~environment, ~variables=(), ())
  |> Js.Promise.then_((response: FeatureFlagWrapperQuery_graphql.Types.response) => {
    let homeUiUx =
      response.features
      ->Array.keep(({featureType}) => featureType == #HOME_UI_UX)
      ->Garter.Array.first
      ->Option.map(({active}) => active)

    Js.Promise.resolve(homeUiUx)
  })
  |> Js.Promise.then_((homeUiUx: option<bool>) => {
    switch (homeUiUx, deviceType) {
    | (Some(true), DeviceDetect.Mobile) => {
        let tab = ctx.query->Js.Dict.get("tab")
        let auc = ctx.query->Js.Dict.get("auction-price")

        switch (tab, auc) {
        | (Some(_), t) => {
            let auction =
              t
              ->Option.flatMap(MO_AuctionPrice_Chips_Buyer.Chip.fromString)
              ->Option.getWithDefault(#TODAY_RISE)

            let p1 = MO_Main_Buyer.ServerSideWithParamQuery.fetchPromised(
              ~environment,
              ~variables={
                marketPriceDiffFilter: switch auction {
                | #TODAY_RISE => {isFromLatestBusinessDay: Some(true), sign: #PLUS, unit: #DAILY}
                | #TODAY_FALL => {isFromLatestBusinessDay: Some(true), sign: #MINUS, unit: #DAILY}
                | #WEEK_RISE => {isFromLatestBusinessDay: Some(true), sign: #PLUS, unit: #WEEKLY}
                | #WEEK_FALL => {isFromLatestBusinessDay: Some(true), sign: #MINUS, unit: #WEEKLY}
                },
              },
              (),
            )

            Promise.allSettled2((features, p1))->makeResultWithQuery(
              ~environment,
              ~extraProps={"deviceType": deviceType},
            )
          }

        | (None, _) =>
          let p1 = MO_Main_Buyer.ServerSideQuery.fetchPromised(~environment, ~variables=(), ())

          Promise.allSettled2((features, p1))->makeResultWithQuery(
            ~environment,
            ~extraProps={"deviceType": deviceType},
          )
        }
      }

    | _ => {
        let gnbAndCategoryQuery = environment->gnbAndCategory

        let p1 = ShopMain_MainBanner_Buyer.Query.fetchPromised(~environment, ~variables=(), ())
        let p2 = ShopMain_SubBanner_Buyer.Query.fetchPromised(~environment, ~variables=(), ())
        let p3 = ShopMain_CategoryList_Buyer.Query.fetchPromised(
          ~environment,
          ~variables={onlyDisplayable: true},
          (),
        )

        Promise.allSettled5((gnbAndCategoryQuery, features, p1, p2, p3))->makeResultWithQuery(
          ~environment,
          ~extraProps={"deviceType": deviceType},
        )
      }
    }
  })
}
