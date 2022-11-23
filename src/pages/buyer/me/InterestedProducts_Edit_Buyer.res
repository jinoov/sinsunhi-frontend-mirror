type props = {deviceType: DeviceDetect.deviceType}
type params
type previewData
@unboxed
type rec result = Result({..}): result

let default = ({deviceType}) => {
  let isCsr = CustomHooks.useCsr()
  switch isCsr {
  | true =>
    <React.Suspense fallback={React.null}>
      {switch deviceType {
      | DeviceDetect.PC => <PC_InterestedProducts_Edit_Buyer />
      | DeviceDetect.Unknown
      | DeviceDetect.Mobile =>
        <MO_InterestedProducts_Edit_Buyer />
      }}
    </React.Suspense>
  | false => React.null
  }
}

let getServerSideProps = (ctx: Next.GetServerSideProps.context<props, params, previewData>) => {
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
    switch homeUiUx {
    | true => Js.Promise.resolve(Result({"props": {"deviceType": deviceType}}))

    | false =>
      Js.Promise.resolve(
        Result({
          "notFound": true,
        }),
      )
    }
  })
}
