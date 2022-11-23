module Query = %relay(`
  query PCInterestedProductsBuyerQuery($cursor: String, $count: Int!) {
    viewer {
      ...PCInterestedProductListBuyerFragment
        @arguments(count: $count, cursor: $cursor)
  
      likedProducts(
        first: $count
        after: $cursor
        types: [MATCHING]
        orderBy: [
          { field: RFQ_DISPLAY_ORDER, direction: ASC_NULLS_FIRST }
          { field: LIKED_AT, direction: DESC }
        ]
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
      ~fetchPolicy=StoreAndNetwork,
      (),
    )

    <div className=%twc("w-full min-h-screen bg-[#F0F2F5]")>
      <div className=%twc("w-full ")>
        <React.Suspense fallback={<PC_Header.Buyer.Placeholder />}>
          <PC_Header.Buyer />
        </React.Suspense>
        <div className=%twc("flex pc-content bg-[#FAFBFC]")>
          <div
            className=%twc(
              "flex flex-col w-[1280px] mx-auto mt-8 rounded-sm bg-white shadow-[0px_10px_40px_10px_rgba(0,0,0,0.03)] overflow-hidden px-[34px] mb-14"
            )>
            {switch viewer {
            | None => <MO_Fallback_Buyer />
            | Some(viewer') => <PC_InterestedProduct_List_Buyer query={viewer'.fragmentRefs} />
            }}
          </div>
        </div>
        <Footer_Buyer.PC />
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
