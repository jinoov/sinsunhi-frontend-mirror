module Query = %relay(`
  query FeatureFlagWrapperQuery {
    features {
      featureType: type
      active
    }
  }
`)

module Content = {
  @react.component
  let make = (
    ~children,
    ~fallback=React.null,
    ~featureFlag: FeatureFlagWrapperQuery_graphql.Types.enum_FeatureType,
  ) => {
    let {features} = Query.use(~variables=(), ())

    let flag =
      features
      ->Array.keep(({featureType}) => featureType == featureFlag)
      ->Garter.Array.first
      ->Option.mapWithDefault(false, ({active}) => active)

    {
      switch flag {
      | true => children
      | false => fallback
      }
    }
  }
}

//TODO: FeatureFlag와 관련된 내용은 Context로 변경할 예정
@react.component
let make = (~children, ~fallback, ~featureFlag, ~suspenseFallback=<div />) => {
  <React.Suspense fallback=suspenseFallback>
    <Content featureFlag fallback> {children} </Content>
  </React.Suspense>
}
