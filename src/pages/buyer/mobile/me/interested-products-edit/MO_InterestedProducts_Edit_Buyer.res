module Query = %relay(`
query MOInterestedProductsEditBuyerQuery($count: Int!) {
  viewer {
    ...MOInterestedProductEditListBuyerFragment @arguments(count: $count)
  }
}
`)

module Content = {
  @react.component
  let make = () => {
    let {viewer} = Query.use(
      ~variables={
        //get all contents
        count: 100,
      },
      ~fetchPolicy=StoreAndNetwork,
      (),
    )

    <div className=%twc("w-full min-h-screen font-medium")>
      <div className=%twc("w-full bg-white")>
        <div className=%twc("w-full max-w-3xl mx-auto bg-white min-h-screen relative")>
          <MO_Headers_Buyer.Stack
            right={switch viewer {
            | None => React.null
            | Some(_) => <MO_InterestedProduct_DeleteAll_Button_Buyer />
            }}
          />
          {switch viewer {
          | None => <MO_Fallback_Buyer />
          | Some(viewer') => <MO_InterestedProduct_Edit_List_Buyer query={viewer'.fragmentRefs} />
          }}
        </div>
      </div>
    </div>
  }
}

module Placeholder = {
  @react.component
  let make = () => {
    <div className=%twc("w-full min-h-screen")>
      <div className=%twc("w-full bg-white")>
        <div className=%twc("w-full max-w-3xl mx-auto bg-white min-h-screen relative")>
          <MO_Headers_Buyer.Stack title="" />
          <ol>
            <MatchingProductDiffPriceListItem.Placeholder />
            <MatchingProductDiffPriceListItem.Placeholder />
            <MatchingProductDiffPriceListItem.Placeholder />
            <MatchingProductDiffPriceListItem.Placeholder />
            <MatchingProductDiffPriceListItem.Placeholder />
          </ol>
        </div>
      </div>
    </div>
  }
}

@react.component
let make = () => {
  <>
    <Next.Head>
      <title> {`신선하이 | 관심상품`->React.string} </title>
    </Next.Head>
    <Authorization.Buyer>
      <React.Suspense fallback={<Placeholder />}>
        <Content />
      </React.Suspense>
    </Authorization.Buyer>
  </>
}
