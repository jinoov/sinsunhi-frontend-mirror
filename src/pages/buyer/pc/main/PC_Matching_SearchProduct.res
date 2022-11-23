module SearchInput = {
  @module("/public/assets/search-bnb-disabled.svg")
  external searchIcon: string = "default"

  @module("/public/assets/close-input-gray.svg")
  external closeInput: string = "default"

  @react.component
  let make = (~query, ~onChange) => {
    let (localQuery, setLocalQuery) = React.Uncurried.useState(_ => query)
    let handleChange = e => {
      let value = (e->ReactEvent.Synthetic.target)["value"]

      onChange(value)
      setLocalQuery(._ => value)
    }

    let reset = _ => {
      onChange("")
      setLocalQuery(._ => "")
    }

    React.useEffect1(_ => {
      setLocalQuery(._ => query)

      None
    }, [query])

    <div className=%twc("bg-[#F0F2F5] p-[14px] rounded-[10px]")>
      <div className=%twc("relative")>
        <img
          src={searchIcon}
          className=%twc("flex absolute inset-y-0 left-0 items-center pointer-events-none")
          alt=""
        />
        <input
          value={localQuery}
          onChange={handleChange}
          type_="text"
          id="input-matching-product"
          placeholder="검색어를 입력하세요"
          className=%twc("w-full bg-[#F0F2F5] pl-7 pr-6 focus:outline-none")
        />
        {switch localQuery == "" {
        | true => React.null
        | false =>
          <button type_="button" className=%twc("absolute right-0 top-0") onClick={reset}>
            <img src={closeInput} className=%twc("w-6 h-6") alt="검색어 초기화" />
          </button>
        }}
      </div>
    </div>
  }
}

module ShortcutQuery = {
  module Capsule = {
    @react.component
    let make = (~txt, ~onClick) => {
      <button
        type_="button"
        className=%twc("px-4 py-3 text-[17px] bg-[#F0F2F5] rounded-3xl")
        onClick={_ => onClick(txt)}>
        {txt->React.string}
      </button>
    }
  }

  module Categories = {
    @react.component
    let make = (~title, ~items, ~onClick) => {
      <div className=%twc("mt-6")>
        <span className=%twc("text-[14px]")> {title->React.string} </span>
        <div className=%twc("mt-2 flex gap-2 flex-wrap")>
          {items->Array.map(name => <Capsule txt=name onClick key=name />)->React.array}
        </div>
      </div>
    }
  }

  @react.component
  let make = (~onClick) => {
    <div className=%twc("mt-6")>
      <span className=%twc("font-bold")> {"추천 검색어"->React.string} </span>
      {PC_Matching_Popular_Category.popularMap
      ->Js.Dict.entries
      ->Array.map(((category, items)) => {
        <Categories title=category items onClick />
      })
      ->React.array}
    </div>
  }
}

module Result = {
  module Query = {
    module SearchProductQuery = %relay(`
      query PCMatchingSearchProduct_Query(
        $cursor: String
        $count: Int!
        $name: String
      ) {
        ...PCMatchingSearchProduct_Fragment
          @arguments(count: $count, cursor: $cursor, name: $name)
      }
  `)
    module GetMainCategoryQuery = %relay(`
      query PCMatchingSearchProduct_GetMainCategory_Query {
        mainDisplayCategories(onlyDisplayable: true) {
          id
        }
      }
    `)
  }

  module Fragment = %relay(`
    fragment PCMatchingSearchProduct_Fragment on Query
    @refetchable(queryName: "MatchingSearchProduct_Query")
    @argumentDefinitions(
      cursor: { type: "String", defaultValue: null }
      count: { type: "Int!" }
      name: { type: "String", defaultValue: "" }
    ) {
      products: searchProducts(
        after: $cursor
        first: $count
        orderBy:[
          { field: STATUS_PRIORITY, direction: ASC }
          { field: RELEVANCE_SCORE, direction: DESC}
          { field: POPULARITY, direction: DESC}
        ] 
        onlyBuyable: true
        types: [MATCHING, QUOTED, QUOTABLE]
        name: $name
      ) @connection(key: "SearchMatchingProduct_products") {
        edges {
          cursor
          node {
            name: displayName
            productId: number
            category {
              parent {
                name
              }
            }
          }
        }
      }
    }
  `)

  module Item = {
    @react.component
    let make = (~kind, ~name, ~onClick) => {
      <li className=%twc("border-b border-[#EDEFF2]")>
        <button type_="button" onClick className=%twc("flex items-center w-full py-4 interactable")>
          {kind->React.string}
          <IconArrow width="16" height="16" strokeWidth="5" />
          <div className=%twc("flex-1 text-left text-ellipsis overflow-hidden whitespace-nowrap")>
            {name->React.string}
          </div>
        </button>
      </li>
    }
  }

  module Product_NotFound = {
    @react.component
    let make = (~query) => {
      let {mainDisplayCategories} = Query.GetMainCategoryQuery.use(~variables=(), ())

      let defaultCategoryLink = switch mainDisplayCategories->Array.get(0) {
      | Some(firstDisplayCategory) =>
        `/categories/${firstDisplayCategory.id}?sort=POPULARITY_ASC&section=matching`
      | None => "/products"
      }

      <div className=%twc("px-4")>
        <div className=%twc("mt-3 py-[42px] border-b border-[#EDEFF2]")>
          <p className=%twc("text-center")>
            <span className=%twc("font-bold break-all")> {`"${query}"`->React.string} </span>
            {" 검색결과가 없습니다"->React.string}
          </p>
          <br />
          <p className=%twc("text-center")>
            {"다른 검색어를 입력하시거나"->React.string}
            <br />
            {"철자와 띄어쓰기를 확인해 보세요."->React.string}
          </p>
        </div>
        <div className=%twc("w-full flex flex-col items-center justify-center mt-24")>
          <p className=%twc("text-center")>
            {"카테고리 방식으로도"->React.string}
            <br />
            {"상품을 찾으실 수 있어요."->React.string}
          </p>
          <Next.Link href=defaultCategoryLink>
            <a
              className=%twc(
                "py-3 px-4 bg-[#F0F2F5] rounded-[10px] flex gap-2 mt-7 interactable items-center"
              )>
              {"카테고리로 이동"->React.string}
              <img src="/assets/arrow-right.svg" className=%twc("w-5 h-5 pointer-events-none") />
            </a>
          </Next.Link>
        </div>
      </div>
    }
  }

  @react.component
  let make = (~query) => {
    let router = Next.Router.useRouter()
    let {fragmentRefs} = Query.SearchProductQuery.use(
      ~variables={
        name: Some(query),
        count: 20,
        cursor: None,
      },
      (),
    )
    let {data: {products}, hasNext, loadNext} = Fragment.usePagination(fragmentRefs)

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

    let handleItemClick = (productId, _) => {
      router->Next.Router.push(`/products/${productId->Int.toString}`)
    }

    {
      switch products.edges {
      | [] => <Product_NotFound query />
      | edges =>
        <ul className=%twc("mt-7")>
          {edges
          ->Array.map(({cursor, node: {category, name, productId}}) => {
            <Item
              key=cursor
              kind={category.parent->Option.mapWithDefault("", p => p.name)}
              name
              onClick={handleItemClick(productId)}
            />
          })
          ->React.array}
          <div ref={ReactDOM.Ref.domRef(loadMoreRef)} className=%twc("h-20 w-full") />
        </ul>
      }
    }
  }
}

@react.component
let make = (~isShow, ~onClose, ~defaultQuery="") => {
  let (query, setQuery) = React.Uncurried.useState(_ => defaultQuery)

  let handleOnClose = _ => {
    setQuery(._ => "")
    onClose()
  }

  <Dialog
    isShow
    onCancel=handleOnClose
    boxStyle=%twc(
      "rounded-2xl bg-[#F7F8FA] w-[488px] max-w-[488px] min-h-[720px] max-h-[calc(100%-140px)]  flex flex-col"
    )
    textOnCancel="닫기">
    <RescriptReactErrorBoundary
      fallback={_ =>
        <div className=%twc("flex items-center justify-center")>
          <contents className=%twc("flex flex-col items-center justify-center")>
            <IconNotFound width="160" height="160" />
            <h1 className=%twc("mt-7 text-2xl text-gray-800 font-bold")>
              {`처리중 오류가 발생하였습니다.`->React.string}
            </h1>
            <span className=%twc("mt-4 text-gray-800")>
              {`페이지를 불러오는 중에 문제가 발생하였습니다.`->React.string}
            </span>
            <span className=%twc("text-gray-800")>
              {`잠시 후 재시도해 주세요.`->React.string}
            </span>
          </contents>
        </div>}>
      <div className=%twc("flex flex-col max-h-[calc(100vh-284px)] min-h-[576px]")>
        <div className=%twc("flex items-center mb-8")>
          <span className=%twc("font-bold text-2xl")> {`상품 검색`->React.string} </span>
          <button type_="button" onClick=handleOnClose className=%twc("ml-auto")>
            <IconClose width="24" height="24" strokeWidth="5" />
          </button>
        </div>
        <SearchInput
          query onChange={Helper.Debounce.make1WithoutPromise(q => setQuery(._ => q), 500)}
        />
        <div className=%twc("flex-1 overflow-y-scroll scrollbar-hide")>
          {switch query == "" {
          | true => <ShortcutQuery onClick={query => setQuery(._ => query)} />
          | false =>
            <React.Suspense fallback={<div className=%twc("flex-1") />}>
              <Result query />
            </React.Suspense>
          }}
        </div>
      </div>
    </RescriptReactErrorBoundary>
  </Dialog>
}
