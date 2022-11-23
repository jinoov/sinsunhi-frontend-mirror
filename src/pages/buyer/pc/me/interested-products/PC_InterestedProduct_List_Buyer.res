module NoItem = {
  @react.component
  let make = () => {
    let {useRouter, back} = module(Next.Router)
    let router = useRouter()
    let onClickHandler = _ => {
      router->back
    }
    <>
      <div className=%twc("flex justify-between")>
        <div className=%twc("inline-flex text-[26px] font-bold items-center ml-3 pt-10 mb-[42px]")>
          <button type_="button" onClick=onClickHandler className=%twc("cursor-pointer")>
            <IconArrow
              width="36px" height="36px" fill="#1F2024" className=%twc("rotate-180 mr-[10px]")
            />
          </button>
          <h2> {"관심 상품"->React.string} </h2>
        </div>
      </div>
      <div className=%twc("text-center flex flex-col items-center py-[60px]")>
        <span className=%twc("text-gray-800 text-lg")>
          {"관심 상품이 없어요."->React.string}
        </span>
        <br />
        <p className=%twc("text-gray-500 mt-1")>
          {"시세 정보를 원하는 상품을 추가하면 관심상품에서"->React.string}
          <br />
          {"편하게 확인하고 관리할 수 있어요."->React.string}
        </p>
        <Next.Link href="/?tab=matching&add-interested=true">
          <a
            className=%twc(
              "py-3 px-4 bg-[#F0F2F5] rounded-[10px] flex gap-2 mt-7 interactable items-center"
            )>
            <IconSpinnerPlus fill={"#1F2024"} />
            {"관심상품 추가하기"->React.string}
          </a>
        </Next.Link>
      </div>
    </>
  }
}
module Fragment = %relay(`
    fragment PCInterestedProductListBuyerFragment on User
    @refetchable(queryName: "PCInterestedProductListQuery")
    @argumentDefinitions(
      cursor: { type: "String", defaultValue: null }
      count: { type: "Int!" }
      orderBy: {
        type: "[LikedProductsOrderBy!]"
        defaultValue: [
          { field: RFQ_DISPLAY_ORDER, direction: ASC_NULLS_FIRST }
          { field: LIKED_AT, direction: DESC }
        ]
      }
      types: { type: "[ProductType!]", defaultValue: [MATCHING] }
    ) {
      likedProducts(
        after: $cursor
        first: $count
        orderBy: $orderBy
        types: $types
      ) @connection(key: "PCInterestedProductList_likedProducts") {
        __id
        edges {
          cursor
          node {
            id
            ...PCInterestedProductItemBuyer_Fragment
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
          ->Array.map(({cursor, node}) => {
            <PC_InterestedProduct_Item_Buyer query={node.fragmentRefs} key={cursor} />
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
  let {useRouter, back} = module(Next.Router)
  let router = useRouter()

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
  let onClickHandler = _ => {
    router->back
  }

  {
    switch likedProducts.edges {
    | [] => <NoItem />
    | _ =>
      <>
        <div className=%twc("flex justify-between items-center")>
          <div
            className=%twc("inline-flex text-[26px] font-bold items-center ml-3 pt-10 mb-[42px]")>
            <button type_="button" onClick=onClickHandler className=%twc("cursor-pointer")>
              <IconArrow
                width="36px" height="36px" fill="#1F2024" className=%twc("rotate-180 mr-[10px]")
              />
            </button>
            <h2> {"관심 상품"->React.string} </h2>
          </div>
          <div className=%twc("inline-flex items-center h-fit")>
            <Next.Link href="/buyer/me/interested/edit" passHref=true>
              <a
                className=%twc(
                  "px-3 py-[6px] text-sm text-[#65666B] rounded-lg bg-[#F0F2F5] font-bold hover:bg-[#AEB0B5] active:bg-[#A7A9AF] ease-in-out duration-200"
                )>
                {"편집하기"->React.string}
              </a>
            </Next.Link>
          </div>
        </div>
        <ol>
          {likedProducts.edges
          ->Array.map(({node}) => {
            <PC_InterestedProduct_Item_Buyer query={node.fragmentRefs} key={node.id} />
          })
          ->React.array}
        </ol>
        <div ref={ReactDOM.Ref.domRef(loadMoreRef)} className=%twc("h-5 w-full") />
      </>
    }
  }
}
