module Query = %relay(`
    query TradematchBuyProductApplyBuyer_Query($productNumber: Int!) {
      product(number: $productNumber) {
        ... on QuotableProduct {
          salesType
        }
        ... on QuotedProduct {
          salesType
        }
        ... on MatchingProduct {
          id
        }
      }
    }
`)

module Content = {
  @react.component
  let make = (~pNumber: int) => {
    let {product} = Query.use(~variables={productNumber: pNumber}, ())

    <div className=%twc("bg-gray-100")>
      <div className=%twc("relative container bg-white max-w-3xl mx-auto min-h-screen")>
        <RescriptReactErrorBoundary
          fallback={_ => <>
            <Tradematch_Header_Buyer />
            <Tradematch_Skeleton_Buyer />
            <Tradematch_NotFound_Buyer />
          </>}>
          <React.Suspense
            fallback={<>
              <Tradematch_Header_Buyer />
              <Tradematch_Skeleton_Buyer />
            </>}>
            {switch product {
            | Some(#MatchingProduct(_)) => <Tradematch_Buy_Farm_Product_Apply_Buyer pNumber />
            | Some(#QuotableProduct(_))
            | Some(#QuotedProduct(_)) =>
              <Tradematch_Buy_Aqua_Product_Apply_Buyer pNumber />
            | Some(#UnselectedUnionMember(_))
            | None =>
              <>
                <Tradematch_Header_Buyer title="" />
                <Tradematch_Skeleton_Buyer />
                <Tradematch_NotFound_Buyer />
              </>
            }}
          </React.Suspense>
        </RescriptReactErrorBoundary>
      </div>
    </div>
  }
}

@react.component
let make = (~pid: string) => {
  <Authorization.Buyer title={j`견적 신청`}>
    {switch pid->Int.fromString {
    | Some(pNumber) => <Content pNumber />
    | None =>
      <>
        <Tradematch_Header_Buyer />
        <Tradematch_Skeleton_Buyer />
        <Tradematch_NotFound_Buyer />
      </>
    }}
  </Authorization.Buyer>
}
