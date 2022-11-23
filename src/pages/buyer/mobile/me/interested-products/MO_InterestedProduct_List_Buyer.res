module NotFound = {
  @react.component
  let make = () => {
    <div className=%twc("text-center mt-20 flex flex-col items-center")>
      <span className=%twc("text-gray-800 text-lg")>
        {"관심 상품이 없어요."->React.string}
      </span>
      <br />
      <p className=%twc("text-gray-500 mt-1")>
        {"시세 정보를 원하는 상품을 추가하면 관심상품에서"->React.string}
        <br />
        {"편하게 확인하고 관리할 수 있어요."->React.string}
      </p>
      <Next.Link href="/buyer/me/interested/add">
        <a
          className=%twc(
            "py-3 px-4 bg-[#F0F2F5] rounded-[10px] flex gap-2 mt-7 interactable items-center"
          )>
          <IconSpinnerPlus fill={"#1F2024"} />
          {"관심상품 추가하기"->React.string}
        </a>
      </Next.Link>
    </div>
  }
}
module Fragment = %relay(`
    fragment MOInterestedProductListBuyerFragment on User
    @refetchable(queryName: "InterestedProductListQuery")
    @argumentDefinitions(
      cursor: { type: "String", defaultValue: null }
      count: { type: "Int!" }
      orderBy: {
        type: "[LikedProductsOrderBy!]"
        defaultValue: [{field: RFQ_DISPLAY_ORDER, direction: ASC_NULLS_FIRST}, {field: LIKED_AT, direction: DESC}]
      }
      types: {
        type: "[ProductType!]"
        defaultValue: [MATCHING]
      }
    ) {
      likedProducts(after: $cursor, first: $count, orderBy: $orderBy, types:$types)
        @connection(key: "InterestedProductList_likedProducts") {
        __id
        edges {
          cursor
          node {
            id
            ...MOInterestedProductItemBuyer_Fragment
          }
        }
      }
    }
    
`)

module Partial = {
  @react.component
  let make = (~query, ~limit, ~empty) => {
    let {data: {likedProducts}} = Fragment.usePagination(query)

    switch likedProducts.edges {
    | [] => empty
    | _ =>
      <>
        <ol>
          {likedProducts.edges
          ->Array.slice(~offset=0, ~len=limit)
          ->Array.map(({node}) => {
            <MO_InterestedProduct_Item_Buyer query={node.fragmentRefs} key={node.id} />
          })
          ->React.array}
        </ol>
      </>
    }
  }
}

@react.component
let make = (~query) => {
  let {data: {likedProducts}, hasNext, loadNext} = Fragment.usePagination(query)

  let loadMoreRef = React.useRef(Js.Nullable.null)

  let isIntersecting = CustomHooks.IntersectionObserver.use(
    ~target=loadMoreRef,
    ~rootMargin="50px",
    ~thresholds=0.1,
    (),
  )

  React.useEffect1(_ => {
    if hasNext && isIntersecting {
      loadNext(~count=20, ())->ignore
    }

    None
  }, [hasNext, isIntersecting])

  {
    switch likedProducts.edges {
    | [] => <NotFound />
    | _ =>
      <>
        <ol>
          {likedProducts.edges
          ->Array.map(({node}) => {
            <MO_InterestedProduct_Item_Buyer query={node.fragmentRefs} key={node.id} />
          })
          ->React.array}
        </ol>
        <div ref={ReactDOM.Ref.domRef(loadMoreRef)} className=%twc("h-20 w-full") />
      </>
    }
  }
}
