module Query = %relay(`
  query MOInterestedProductsBuyerQuery($cursor: String, $count: Int!) {
    viewer {
      ...MOInterestedProductListBuyerFragment
        @arguments(count: $count, cursor: $cursor)
  
      likedProducts(
        first: $count
        after: $cursor
        types:[MATCHING]
        orderBy: [{field: RFQ_DISPLAY_ORDER, direction: ASC_NULLS_FIRST}, {field: LIKED_AT, direction: DESC}]
      ) {
        totalCount
      }
    }
  }

`)
module Content = {
  @react.component
  let make = () => {
    let {viewer} = Query.use(
      ~variables={
        cursor: None,
        count: 20,
      },
      // ~fetchPolicy=StoreAndNetwork,
      (),
    )

    let totalCount =
      viewer
      ->Option.map(({likedProducts: {totalCount}}) => totalCount)
      ->Option.mapWithDefault("0", Int.toString)

    <div className=%twc("w-full min-h-screen font-medium")>
      <div className=%twc("w-full bg-white")>
        <div className=%twc("w-full max-w-3xl mx-auto bg-white min-h-screen relative")>
          <MO_Headers_Buyer.Stack
            className=%twc("sticky top-0")
            title={`관심 상품(${totalCount})`}
            right={switch viewer {
            | None => React.null
            | Some({likedProducts: {totalCount}}) if totalCount == 0 => React.null
            | Some(_) =>
              <div>
                <Next.Link href="/buyer/me/interested/edit">
                  <a
                    className=%twc(
                      "align-middle text-[15px] text-primary cursor-pointer font-medium"
                    )>
                    {"편집하기"->React.string}
                  </a>
                </Next.Link>
              </div>
            }}
          />
          {switch viewer {
          | None => <MO_Fallback_Buyer />
          | Some(viewer') => <MO_InterestedProduct_List_Buyer query={viewer'.fragmentRefs} />
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
          <MO_Headers_Buyer.Stack title="관심 상품" />
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
