module Fragment = %relay(`
  fragment MyInfoMarketingTermSwitcherBuyer_Fragment on User {
    terms(first: 10) {
      edges {
        node {
          agreement
          id
        }
      }
    }
  }
`)

module Mutation = %relay(`
  mutation MyInfoMarketingTermSwitcherBuyer_Mutation($isAgree: Boolean!) {
    updateUser(
      input: { terms: [{ agreement: "marketing", isAgreedByViewer: $isAgree }] }
    ) {
      ... on User {
        ...MyInfoAccountBuyer_Fragment
        ...MyInfoProfileSummaryBuyer_Fragment
        ...MyInfoProfileCompleteBuyer_Fragment
        ...UpdateMarketingTermBuyer_Fragment
      }
      ... on Error {
        message
      }
    }
  }
`)

@react.component
let make = (~query) => {
  let {terms: {edges}} = Fragment.use(query)
  let (mutate, isMutating) = Mutation.use()

  let status =
    edges
    ->Array.map(({node: {agreement, id}}) => (agreement, (agreement, id)))
    ->List.fromArray
    ->List.getAssoc("marketing", (a, b) => a == b)
    ->Option.isSome

  let handleChange = _ => {
    mutate(~variables={isAgree: !status}, ())->ignore
  }

  <Switcher checked={status} onCheckedChange={handleChange} disabled={isMutating} />
}
