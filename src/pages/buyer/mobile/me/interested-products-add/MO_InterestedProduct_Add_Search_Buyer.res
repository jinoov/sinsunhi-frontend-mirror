module Result = {
  module Query = %relay(`
        query MOInterestedProductAddSearchBuyerQuery(
          $cursor: String
          $count: Int!
          $name: String
        ) {
          ...MOInterestedProductAddSearchBuyerFragment
            @arguments(count: $count, cursor: $cursor, name: $name)
        }
    `)

  module Fragment = %relay(`
    fragment MOInterestedProductAddSearchBuyerFragment on Query
    @refetchable(queryName: "InterestedProductAddSearchQuery")
    @argumentDefinitions(
      cursor: { type: "String", defaultValue: null }
      count: { type: "Int!" }
      name: { type: "String", defaultValue: "" }
    ) {
      searchProducts(
        after: $cursor
        first: $count
        orderBy: [
          { field: STATUS_PRIORITY, direction: ASC }
          { field: UPDATED_AT, direction: DESC }
        ]
        excludeLikedProducts: true
        onlyBuyable: true
        types: [MATCHING]
        name: $name
      ) @connection(key: "InterestedProductAddSearch_searchProducts") {
        edges {
          cursor
          node {
            id
            ...MOInterestedProductAddItemBuyer_Fragment
          }
        }
      }
    }
  `)

  module Product_NotFound = {
    @react.component
    let make = (~query) => {
      <div className=%twc("px-4")>
        <div className=%twc("mt-3 py-[42px] border-b border-[#EDEFF2]")>
          <p className=%twc("text-center")>
            <span className=%twc("font-bold")> {query->React.string} </span>
            {" 검색결과가 없습니다"->React.string}
          </p>
          <br />
          <p className=%twc("text-center")>
            {"다른 검색어를 입력하시거나"->React.string}
            <br />
            {"철자와 띄어쓰기를 확인해 보세요."->React.string}
          </p>
        </div>
      </div>
    }
  }

  @react.component
  let make = (~query, ~checkedSet, ~onItemClick) => {
    let {fragmentRefs} = Query.use(
      ~variables={
        name: switch query {
        | "" => None
        | _ => Some(query)
        },
        count: 20,
        cursor: None,
      },
      ~fetchPolicy=StoreAndNetwork,
      (),
    )

    let {data: {searchProducts}, hasNext, loadNext} = Fragment.usePagination(fragmentRefs)

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
      switch searchProducts.edges {
      | [] => <Product_NotFound query />
      | edges =>
        <>
          <ul className=%twc("w-full grid items-stretch grid-cols-2 gap-4 mt-5")>
            {edges
            ->Array.map(({cursor, node}) => {
              <MO_InterestedProduct_Add_Item_Buyer
                key={cursor}
                query=node.fragmentRefs
                checked={checkedSet->Set.String.has(node.id)}
                onChange={_ => onItemClick(node.id)}
              />
            })
            ->React.array}
          </ul>
          <div ref={ReactDOM.Ref.domRef(loadMoreRef)} className=%twc("h-20 w-full") />
        </>
      }
    }
  }
}

module Spinner = {
  @react.component
  let make = () => {
    <div role="status" className=%twc("text-center mt-5")>
      <svg
        className="inline mr-2 w-8 h-8 text-gray-200 animate-spin dark:text-gray-600 fill-gray-600 dark:fill-gray-300"
        viewBox="0 0 100 101"
        fill="none"
        xmlns="http://www.w3.org/2000/svg">
        <path
          d="M100 50.5908C100 78.2051 77.6142 100.591 50 100.591C22.3858 100.591 0 78.2051 0 50.5908C0 22.9766 22.3858 0.59082 50 0.59082C77.6142 0.59082 100 22.9766 100 50.5908ZM9.08144 50.5908C9.08144 73.1895 27.4013 91.5094 50 91.5094C72.5987 91.5094 90.9186 73.1895 90.9186 50.5908C90.9186 27.9921 72.5987 9.67226 50 9.67226C27.4013 9.67226 9.08144 27.9921 9.08144 50.5908Z"
          fill="currentColor"
        />
        <path
          d="M93.9676 39.0409C96.393 38.4038 97.8624 35.9116 97.0079 33.5539C95.2932 28.8227 92.871 24.3692 89.8167 20.348C85.8452 15.1192 80.8826 10.7238 75.2124 7.41289C69.5422 4.10194 63.2754 1.94025 56.7698 1.05124C51.7666 0.367541 46.6976 0.446843 41.7345 1.27873C39.2613 1.69328 37.813 4.19778 38.4501 6.62326C39.0873 9.04874 41.5694 10.4717 44.0505 10.1071C47.8511 9.54855 51.7191 9.52689 55.5402 10.0491C60.8642 10.7766 65.9928 12.5457 70.6331 15.2552C75.2735 17.9648 79.3347 21.5619 82.5849 25.841C84.9175 28.9121 86.7997 32.2913 88.1811 35.8758C89.083 38.2158 91.5421 39.6781 93.9676 39.0409Z"
          fill="currentFill"
        />
      </svg>
      <div className="sr-only"> {"검색중"->React.string} </div>
    </div>
  }
}

@react.component
let make = (~checkedSet, ~onItemClick) => {
  let router = Next.Router.useRouter()
  let defaultQuery = router.query->Js.Dict.get("search")

  let (query, setQuery) = React.Uncurried.useState(_ => defaultQuery->Option.getWithDefault(""))

  <div className=%twc("px-5")>
    <RescriptReactErrorBoundary fallback={_ => <MO_Fallback_Buyer />}>
      <MO_InterestedProduct_SearchInput_Buyer
        defaultQuery=?{defaultQuery}
        onChange={Helper.Debounce.make1WithoutPromise(q => setQuery(._ => q), 500)}
      />
      <React.Suspense fallback={<Spinner />}>
        <Result query checkedSet onItemClick />
      </React.Suspense>
    </RescriptReactErrorBoundary>
  </div>
}
