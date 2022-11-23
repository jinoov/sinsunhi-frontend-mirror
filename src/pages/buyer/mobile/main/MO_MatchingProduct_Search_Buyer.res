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

    <div className=%twc("bg-[#F0F2F5] p-[14px] rounded-[10px] mx-4")>
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
          className=%twc("w-full bg-[#F0F2F5] pl-7 pr-6 focus:outline-none caret-[#0BB25F]")
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
        className=%twc("px-4 py-3 text-[17px] bg-[#F0F2F5] rounded-3xl interactable")
        onClick={_ => onClick(txt)}>
        {txt->React.string}
      </button>
    }
  }

  @react.component
  let make = (~onClick) => {
    <div className=%twc("mt-6 px-4")>
      <span className=%twc("font-bold")> {"추천 검색어"->React.string} </span>
      <div className=%twc("mt-4")>
        <span className=%twc("text-[14px]")> {"농산"->React.string} </span>
        <div className=%twc("mt-2 flex gap-2 flex-wrap")>
          <Capsule txt="양파" onClick />
          <Capsule txt="배추" onClick />
          <Capsule txt="황금향" onClick />
          <Capsule txt="호박" onClick />
          <Capsule txt="감귤" onClick />
          <Capsule txt="사과" onClick />
          <Capsule txt="고구마" onClick />
          <Capsule txt="감" onClick />
          <Capsule txt="대파" onClick />
          <Capsule txt="무" onClick />
          <Capsule txt="방울토마토" onClick />
          <Capsule txt="표고" onClick />
          <Capsule txt="샤인머스켓" onClick />
          <Capsule txt="감자" onClick />
          <Capsule txt="메론" onClick />
        </div>
      </div>
      <div className=%twc("mt-6")>
        <span className=%twc("text-[14px]")> {"축산"->React.string} </span>
        <div className=%twc("mt-2 flex gap-2 flex-wrap")>
          <Capsule txt="갈비" onClick />
          <Capsule txt="부채살" onClick />
          <Capsule txt="목심" onClick />
          <Capsule txt="삼겹살" onClick />
          <Capsule txt="등심" onClick />
          <Capsule txt="채끝" onClick />
          <Capsule txt="살치살" onClick />
          <Capsule txt="안심" onClick />
          <Capsule txt="양지" onClick />
          <Capsule txt="토시살" onClick />
        </div>
      </div>
      <div className=%twc("mt-6")>
        <span className=%twc("text-[14px]")> {"수산"->React.string} </span>
        <div className=%twc("mt-2 flex gap-2 flex-wrap")>
          <Capsule txt="소라" onClick />
          <Capsule txt="오징어" onClick />
          <Capsule txt="전복" onClick />
          <Capsule txt="갈치" onClick />
          <Capsule txt="바지락" onClick />
        </div>
      </div>
    </div>
  }
}

module Result = {
  module Query = %relay(`
      query MOMatchingProductSearchBuyerQuery(
        $cursor: String
        $count: Int!
        $name: String
      ) {
        ...MOMatchingProductSearchBuyerFragment
          @arguments(count: $count, cursor: $cursor, name: $name)
      }
  `)

  module Fragment = %relay(`
    fragment MOMatchingProductSearchBuyerFragment on Query
    @refetchable(queryName: "SearchMatchingProductQuery")
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
        <button
          type_="button"
          onClick
          className=%twc("flex items-center w-full py-4 interactable px-4 gap-2")>
          <span className=%twc("flex-none")> {kind->React.string} </span>
          <IconArrow width="16" height="16" strokeWidth="5" />
          <span className=%twc("text-left")> {name->React.string} </span>
        </button>
      </li>
    }
  }

  module Product_NotFound = {
    @react.component
    let make = (~query) => {
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
          <Next.Link href="/menu">
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
    let {fragmentRefs} = Query.use(
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
      let newQuery = router.query
      newQuery->Js.Dict.set("search", query)

      // 검색 상태를 저장합니다.
      router->Next.Router.replaceShallow({pathname: "/", query: newQuery})

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
    onClose()
    let _ = Js.Global.setTimeout(() => setQuery(._ => ""), 500)
  }

  <DS_BottomDrawer.Root isShow full=true onClose={handleOnClose}>
    <DS_BottomDrawer.Header>
      <span className=%twc("text-[#1F2024] font-bold text-[17px]")>
        {"상품 검색"->React.string}
      </span>
    </DS_BottomDrawer.Header>
    <DS_BottomDrawer.Body scrollable=true>
      <div className=%twc("py-5")>
        <RescriptReactErrorBoundary
          fallback={_ =>
            <div className=%twc("flex items-center justify-center px-4")>
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
          <SearchInput
            query onChange={Helper.Debounce.make1WithoutPromise(q => setQuery(._ => q), 500)}
          />
          {switch query == "" {
          | true => <ShortcutQuery onClick={query => setQuery(._ => query)} />
          | false =>
            <React.Suspense fallback={React.null}>
              <Result query />
            </React.Suspense>
          }}
        </RescriptReactErrorBoundary>
      </div>
    </DS_BottomDrawer.Body>
  </DS_BottomDrawer.Root>
}
