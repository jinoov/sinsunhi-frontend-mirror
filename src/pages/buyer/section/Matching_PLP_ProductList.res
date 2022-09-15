module Query = %relay(`
  query MatchingPLPProductListQuery(
    $displayCategoryId: ID!
    $cursor: ID
    $count: Int!
    $sort: DisplayCategoryProductsSort
    $onlyBuyable: Boolean
  ) {
    node(id: $displayCategoryId) {
      ... on DisplayCategory {
        name
        ...MatchingPLPProductListFragment
          @arguments(
            count: $count
            cursor: $cursor
            sort: $sort
            onlyBuyable: $onlyBuyable
          )
      }
    }
  }
`)

module Fragment = %relay(`
  fragment MatchingPLPProductListFragment on DisplayCategory
  @refetchable(queryName: "MatchingPLPProductListRefetchQuery")
  @argumentDefinitions(
    cursor: { type: "ID", defaultValue: null }
    onlyBuyable: { type: "Boolean", defaultValue: null }
    count: { type: "Int", defaultValue: 20 }
    sort: { type: "DisplayCategoryProductsSort" }
  ) {
    name
    type_: type
  
    products(
      after: $cursor
      first: $count
      sort: $sort
      onlyBuyable: $onlyBuyable
      type: [MATCHING, QUOTED]
    ) @connection(key: "SectionMatchingAll_products") {
      edges {
        cursor
        node {
          ...MatchingProductListItemFragment
        }
      }
    }
  }
`)

module PC = {
  module Skeleton = {
    @react.component
    let make = () => {
      <div className=%twc("w-[1280px] pt-20 px-5 pb-16 mx-auto")>
        <div className=%twc("w-[160px] h-[44px] rounded-lg animate-pulse bg-gray-150") />
        <section className=%twc("w-full mt-[88px]")>
          <ol className=%twc("grid grid-cols-4 gap-x-10 gap-y-16")>
            {Array.range(1, 300)
            ->Array.map(number => {
              <ShopProductListItem_Buyer.PC.Placeholder key={`box-${number->Int.toString}`} />
            })
            ->React.array}
          </ol>
        </section>
      </div>
    }
  }
  module Empty = {
    @react.component
    let make = (~subCategoryName) => {
      <>
        <div className=%twc("w-[1280px] pt-20 pb-16 mx-auto min-h-full")>
          <div className=%twc("font-bold text-2xl text-gray-800")>
            {`${subCategoryName} 상품`->React.string}
          </div>
          <div className=%twc("mt-20 flex flex-col items-center justify-center text-gray-800")>
            <h1 className=%twc("text-3xl")>
              {`상품이 존재하지 않습니다`->React.string}
            </h1>
            <span className=%twc("mt-7")>
              {`해당 카테고리에 상품이 존재하지 않습니다.`->React.string}
            </span>
            <span> {`다른 카테고리를 선택해 주세요.`->React.string} </span>
          </div>
        </div>
      </>
    }
  }
  module View = {
    @react.component
    let make = (~query, ~subCategoryName) => {
      let {data: {products}, hasNext, loadNext} = query->Fragment.usePagination

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

      <div className=%twc("w-[1280px] pt-20 pb-16 mx-auto min-h-full")>
        <div className=%twc("flex justify-between")>
          <div className=%twc("font-bold text-2xl text-gray-800")>
            {`${subCategoryName} 상품`->React.string}
          </div>
          <div className=%twc("mb-12 flex-1 flex items-center justify-end")>
            <MatchingSortSelect />
          </div>
        </div>
        <ol className=%twc("grid grid-cols-4 gap-x-10 gap-y-16")>
          {products.edges
          ->Array.map(({cursor, node}) => {
            <MatchingProductListItem.PC key=cursor query=node.fragmentRefs />
          })
          ->React.array}
        </ol>
        <div ref={ReactDOM.Ref.domRef(loadMoreRef)} className=%twc("h-20 w-full") />
      </div>
    }
  }
  module Container = {
    @react.component
    let make = (~subCategoryName) => {
      let router = Next.Router.useRouter()
      let sort =
        router.query
        ->Js.Dict.get("sort")
        ->Option.flatMap(MatchingSortSelect.decodeSort)
        ->Option.getWithDefault(#UPDATED_DESC)

      let categoryId = router.query->Js.Dict.get("category-id")->Option.getWithDefault("")
      let subCategoryId = router.query->Js.Dict.get("sub-category-id")

      let {node} = Query.use(
        ~variables=Query.makeVariables(
          ~displayCategoryId=subCategoryId->Option.getWithDefault(categoryId),
          ~sort,
          ~count=20,
          ~onlyBuyable=true,
          (),
        ),
        ~fetchPolicy=RescriptRelay.StoreOrNetwork,
        (),
      )

      switch node {
      | None => <Empty subCategoryName />
      | Some({fragmentRefs}) => <View query={fragmentRefs} subCategoryName />
      }
    }
  }

  @react.component
  let make = (~subCategoryName) => {
    let (_isCsr, setIsCsr) = React.Uncurried.useState(_ => false)

    React.useEffect0(() => {
      setIsCsr(._ => true)
      None
    })

    <RescriptReactErrorBoundary fallback={_ => <Skeleton />}>
      <React.Suspense fallback={<Skeleton />}> <Container subCategoryName /> </React.Suspense>
    </RescriptReactErrorBoundary>
  }
}

module MO = {
  module Skeleton = {
    @react.component
    let make = () => {
      <div className=%twc("w-full py-4 px-5")>
        <div className=%twc("mb-4 w-full flex items-center justify-end")>
          <div className=%twc("w-12 h-5 bg-gray-150 rounded-lg animate-pulse") />
        </div>
        <ol className=%twc("grid grid-cols-2 gap-x-4 gap-y-8")>
          {Array.range(1, 300)
          ->Array.map(num => {
            <ShopProductListItem_Buyer.MO.Placeholder
              key={`list-item-skeleton-${num->Int.toString}`}
            />
          })
          ->React.array}
        </ol>
      </div>
    }
  }
  module Empty = {
    @react.component
    let make = () => {
      <>
        <div
          className=%twc("mt-[126px] flex flex-col items-center justify-center text-gray-800 px-5")>
          <h1 className=%twc("text-xl")> {`상품이 존재하지 않습니다`->React.string} </h1>
          <span className=%twc("mt-2 text-sm text-gray-600 text-center")>
            {`해당 카테고리에 상품이 존재하지 않습니다.`->React.string}
          </span>
          <span className=%twc("mt-2 text-sm text-gray-600 text-center")>
            {`다른 카테고리를 선택해 주세요.`->React.string}
          </span>
        </div>
      </>
    }
  }
  module View = {
    @react.component
    let make = (~query, ~subCategoryName) => {
      let {data: {products}, hasNext, loadNext} = query->Fragment.usePagination

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

      switch products.edges->Array.length == 0 {
      | true => <Empty />
      | false =>
        <div className=%twc("w-full pt-1 px-5")>
          <div className=%twc("mt-6 mb-4 w-full flex items-center justify-between text-gray-800")>
            <span className=%twc("font-bold")> {`${subCategoryName} 상품`->React.string} </span>
            <MatchingSortSelect.MO />
          </div>
          <ol className=%twc("grid grid-cols-2 gap-x-4 gap-y-8")>
            {products.edges
            ->Array.map(({cursor, node}) => {
              <MatchingProductListItem.MO key=cursor query=node.fragmentRefs />
            })
            ->React.array}
          </ol>
          <div ref={ReactDOM.Ref.domRef(loadMoreRef)} className=%twc("h-20 w-full") />
        </div>
      }
    }
  }
  module Container = {
    @react.component
    let make = (~subCategoryName) => {
      let router = Next.Router.useRouter()
      let sort =
        router.query
        ->Js.Dict.get("sort")
        ->Option.flatMap(MatchingSortSelect.decodeSort)
        ->Option.getWithDefault(#UPDATED_DESC)

      let categoryId = router.query->Js.Dict.get("category-id")->Option.getWithDefault("")
      let subCategoryId = router.query->Js.Dict.get("sub-category-id")

      let {node} = Query.use(
        ~variables=Query.makeVariables(
          ~displayCategoryId=subCategoryId->Option.getWithDefault(categoryId),
          ~sort,
          ~count=20,
          ~onlyBuyable=true,
          (),
        ),
        ~fetchPolicy=RescriptRelay.StoreOrNetwork,
        (),
      )

      switch node {
      | None => <Empty />
      | Some({fragmentRefs}) => <View query={fragmentRefs} subCategoryName />
      }
    }
  }

  @react.component
  let make = (~subCategoryName) => {
    let (_isCsr, setIsCsr) = React.Uncurried.useState(_ => false)

    React.useEffect0(() => {
      setIsCsr(._ => true)
      None
    })
    <RescriptReactErrorBoundary fallback={_ => <Skeleton />}>
      <React.Suspense fallback={<Skeleton />}> <Container subCategoryName /> </React.Suspense>
    </RescriptReactErrorBoundary>
  }
}
