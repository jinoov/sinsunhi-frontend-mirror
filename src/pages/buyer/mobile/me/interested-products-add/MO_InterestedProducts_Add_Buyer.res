module Container = {
  @react.component
  let make = () => {
    let (checkedSet, setCheckedSet) = React.Uncurried.useState(_ => Set.String.empty)

    let handleOnChange = (id: string) => {
      switch checkedSet->Set.String.has(id) {
      | true => setCheckedSet(._ => checkedSet->Set.String.remove(id))
      | false => setCheckedSet(.prev => prev->Set.String.add(id))
      }
    }

    <div className=%twc("w-full min-h-screen font-medium")>
      <div className=%twc("w-full bg-white")>
        <div className=%twc("w-full max-w-3xl mx-auto bg-white min-h-screen relative")>
          <MO_Headers_Buyer.Stack
            title="관심 상품 추가" className=%twc("sticky top-0 z-10")
          />
          <MO_InterestedProduct_Add_Search_Buyer checkedSet onItemClick={handleOnChange} />
          <React.Suspense fallback={React.null}>
            <MO_InterestedProduct_Add_Button_Buyer checkedSet />
          </React.Suspense>
        </div>
      </div>
    </div>
  }
}

let default = () => {
  <>
    <Next.Head>
      <title> {`신선하이 | 관심상품 추가하기`->React.string} </title>
    </Next.Head>
    <Authorization.Buyer>
      <Container />
    </Authorization.Buyer>
  </>
}

type props
type params
type previewData
@unboxed
type rec result = Result({..}): result

module FeatureFlag = %relay(`
  query MOInterestedProductsAddBuyerFeatureFlagQuery {
    features {
      featureType: type
      active
    }
  }
`)

let getServerSideProps = (ctx: Next.GetServerSideProps.context<props, params, previewData>) => {
  let deviceType = DeviceDetect.detectDeviceFromCtx2(ctx.req)
  let environment = SinsunMarket(Env.graphqlApiUrl)->RelayEnv.environment

  FeatureFlag.fetchPromised(~environment, ~variables=(), ())
  |> Js.Promise.then_((
    response: MOInterestedProductsAddBuyerFeatureFlagQuery_graphql.Types.response,
  ) => {
    let homeUiUx =
      response.features
      ->Array.keep(({featureType}) => featureType == #HOME_UI_UX)
      ->Garter.Array.first
      ->Option.map(({active}) => active)

    Js.Promise.resolve(homeUiUx)
  })
  |> Js.Promise.then_((homeUiUx: option<bool>) => {
    switch homeUiUx {
    | Some(true) =>
      switch deviceType {
      | DeviceDetect.Mobile => Js.Promise.resolve(Result({"props": Js.Obj.empty()}))
      | DeviceDetect.PC
      | DeviceDetect.Unknown =>
        Js.Promise.resolve(
          Result({
            "redirect": {
              "permanent": true,
              "destination": "/",
            },
          }),
        )
      }
    | Some(false)
    | None =>
      Js.Promise.resolve(
        Result({
          "notFound": true,
        }),
      )
    }
  })
}
