module Fragment = %relay(`
    fragment MOInterestedProductEditListBuyerFragment on User
    @refetchable(queryName: "InterestedProductEditListRefetchQuery")
    @argumentDefinitions(
      cursor: { type: "String", defaultValue: null }
      count: { type: "Int!" }
      orderBy: {
        type: "[LikedProductsOrderBy!]"
        defaultValue: [{field: RFQ_DISPLAY_ORDER, direction: ASC_NULLS_FIRST}, {field: LIKED_AT, direction: DESC}]
      }
      types:{
        type:"[ProductType!]"
        defaultValue:[MATCHING]
      }
    ) {
      likedProducts(after: $cursor, first: $count, orderBy: $orderBy, types:$types)
        @connection(key: "InterestedProductEditList_likedProducts") {
        __id
        edges {
          cursor
          node {
            id
            displayName
            image {
              thumb400x400
            }
          }
        }
        totalCount
      }
    }
`)

@react.component
let make = (~query) => {
  let {data: {likedProducts}, loadNext} = Fragment.usePagination(query)

  // 편집시 관심상품 전체를 불러온다.
  React.useEffect1(_ => {
    if likedProducts.edges->Array.length < likedProducts.totalCount {
      loadNext(~count=likedProducts.totalCount, ())->ignore
    }
    None
  }, [likedProducts])

  <>
    <MO_InterestedProduct_Edit_Droppable_List_Buyer
      likedProducts key={UniqueId.make(~prefix="likedProducts", ())}
    />
  </>
}
