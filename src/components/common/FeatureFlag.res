module Query = %relay(`
  query FeatureFlagQuery {
    features {
      featureType: type
      active
      description
    }
  }
`)

module Context = {
  type featureFlags = array<FeatureFlagQuery_graphql.Types.response_features>
  let context = React.createContext(([]: featureFlags))

  module Provider = {
    let provider = React.Context.provider(context)

    @react.component
    let make = (~value, ~children) => {
      React.createElement(provider, {"value": value, "children": children})
    }
  }
}
