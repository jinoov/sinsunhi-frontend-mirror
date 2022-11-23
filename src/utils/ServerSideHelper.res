let gnbAndCategory = (environment: RescriptRelay.Environment.t) => {
  let gnb = GnbBannerList_Buyer.Query.fetchPromised(~environment, ~variables=(), ())
  let category = ShopCategorySelect_Buyer.Query.fetchPromised(
    ~environment,
    ~variables={onlyDisplayable: Some(true), types: Some([#NORMAL])},
    (),
  )

  Promise.allSettled2((gnb, category))
}

let makeResultWithQuery = (querys, ~environment, ~extraProps) => {
  let resolveResult = _ => {
    {
      "props": environment->RelayEnv.createDehydrateProps(~extraProps, ()),
    }->Js.Promise.resolve
  }

  querys |> Js.Promise.then_(resolveResult) |> Js.Promise.catch(resolveResult)
}

let featureFlags = (environment: RescriptRelay.Environment.t) => {
  FeatureFlag.Query.fetchPromised(~environment, ~variables=(), ())
}
