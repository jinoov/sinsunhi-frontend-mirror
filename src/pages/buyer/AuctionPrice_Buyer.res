type props = {deviceType: DeviceDetect.deviceType}

let default = ({deviceType}: props) => {
  switch deviceType {
  | PC => <PC_AuctionPrice_Buyer />
  | Mobile
  | Unknown =>
    <MO_AuctionPrice_Buyer />
  }
}

type params
type previewData

@unboxed
type rec result = Result({..}): result

let getServerSideProps = (ctx: Next.GetServerSideProps.context<props, params, previewData>) => {
  open ServerSideHelper
  let deviceType = DeviceDetect.detectDeviceFromCtx2(ctx.req)
  let environment = SinsunMarket(Env.graphqlApiUrl)->RelayEnv.environment

  FeatureFlagWrapper.Query.fetchPromised(~environment, ~variables=(), ())
  |> Js.Promise.then_((response: FeatureFlagWrapperQuery_graphql.Types.response) => {
    let homeUiUx =
      response.features
      ->Array.keep(({featureType}) => featureType == #HOME_UI_UX)
      ->Garter.Array.first
      ->Option.map(({active}) => active)
      ->Option.getWithDefault(false)

    Js.Promise.resolve(homeUiUx)
  })
  |> Js.Promise.then_(homeUiUx => {
    switch (homeUiUx, deviceType) {
    | (true, DeviceDetect.Mobile) =>
      Js.Promise.resolve(Result({"props": {"deviceType": deviceType}}))
    | (true, DeviceDetect.Unknown)
    | (true, DeviceDetect.PC) => {
        let gnbAndCategoryQuery = environment->gnbAndCategory

        gnbAndCategoryQuery->makeResultWithQuery(
          ~environment,
          ~extraProps={"deviceType": deviceType},
        ) |> Js.Promise.then_(prop => Js.Promise.resolve(Result(prop)))
      }

    | (false, _) =>
      Js.Promise.resolve(
        Result({
          "notFound": true,
        }),
      )
    }
  })
}
