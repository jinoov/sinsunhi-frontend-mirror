module Query = %relay(`
  query SRPBuyerQuery(
    $count: Int!
    $cursor: String
    $name: String!
    $sort: ProductsQueryInputSort!
    $onlyBuyable: Boolean
    $types: [ProductType!]
  ) {
    ...SRPBuyer_fragment
      @arguments(
        count: $count
        cursor: $cursor
        name: $name
        sort: $sort
        onlyBuyable: $onlyBuyable
        types: $types
      )
  }
`)

module Fragment = %relay(`
  fragment SRPBuyer_fragment on Query
  @refetchable(queryName: "ShopSearchBuyerRefetchQuery")
  @argumentDefinitions(
    count: { type: "Int", defaultValue: 20 }
    onlyBuyable: { type: "Boolean", defaultValue: null }
    cursor: { type: "String", defaultValue: null }
    name: { type: "String!" }
    sort: { type: "ProductsQueryInputSort!" }
    types: { type: "[ProductType!]" }
  ) {
    products(
      first: $count
      after: $cursor
      name: $name
      sort: $sort
      onlyBuyable: $onlyBuyable
      type: $types
    ) @connection(key: "ShopSearchBuyer_products") {
      edges {
        cursor
        node {
          ...ShopProductListItemBuyerFragment
        }
      }
      totalCount
    }
  }
`)

module Placeholder = {
  @react.component
  let make = (~deviceType, ~gnbBanners, ~displayCategories) => {
    let router = Next.Router.useRouter()
    switch deviceType {
    | DeviceDetect.Unknown => React.null

    | DeviceDetect.PC =>
      <div className=%twc("w-full min-w-[1280px] min-h-screen flex flex-col")>
        <Header_Buyer.PC key=router.asPath gnbBanners displayCategories />
        <main className=%twc("flex flex-col grow w-full h-full bg-white")>
          <div className=%twc("w-[1280px] pt-20 mx-auto")>
            <section className=%twc("w-full flex items-center justify-center")>
              <div className=%twc("bg-gray-150 animate-pulse rounded-xl w-[400px] h-[48px]") />
            </section>
            <section className=%twc("mt-20 w-full flex items-center justify-end")>
              <div className=%twc("bg-gray-150 animate-pulse rounded-xl w-32 h-5") />
            </section>
            <section className=%twc("w-full mt-12")>
              <ol className=%twc("grid grid-cols-4 gap-x-10 gap-y-16")>
                {Array.range(1, 300)
                ->Array.map(number => {
                  <ShopProductListItem_Buyer.PC.Placeholder key={`box-${number->Int.toString}`} />
                })
                ->React.array}
              </ol>
            </section>
          </div>
        </main>
        <Footer_Buyer.PC />
      </div>

    | DeviceDetect.Mobile =>
      <div className=%twc("w-full bg-white")>
        <Header_Buyer.Mobile key=router.asPath />
        <main className=%twc("w-full max-w-3xl mx-auto relative bg-white min-h-screen")>
          <div className=%twc("w-full pb-8 px-5")>
            <div className=%twc("w-full py-4  flex items-center justify-end")>
              <div className=%twc("w-12 h-5 rounded-lg animate-pulse bg-gray-150") />
            </div>
            <div>
              <ol className=%twc("grid grid-cols-2 gap-x-4 gap-y-8")>
                {Array.range(1, 300)
                ->Array.map(idx => {
                  <ShopProductListItem_Buyer.MO.Placeholder
                    key={`search-result-skeleton-${idx->Int.toString}`}
                  />
                })
                ->React.array}
              </ol>
            </div>
          </div>
        </main>
        <Footer_Buyer.MO />
      </div>
    }
  }
}

module Error = {
  @react.component
  let make = (~deviceType, ~gnbBanners, ~displayCategories) => {
    let router = Next.Router.useRouter()

    switch deviceType {
    | DeviceDetect.Unknown => React.null

    | DeviceDetect.PC =>
      <div className=%twc("w-full min-w-[1280px] min-h-screen flex flex-col")>
        <Header_Buyer.PC key=router.asPath gnbBanners displayCategories />
        <main className=%twc("flex flex-col grow w-full h-full bg-white")>
          <div className=%twc("w-full flex items-center justify-center mt-40")>
            <span className=%twc("text-3xl text-gray-800")>
              {`검색에 실패하였습니다`->React.string}
            </span>
          </div>
        </main>
        <Footer_Buyer.PC />
      </div>

    | DeviceDetect.Mobile =>
      <div className=%twc("w-full bg-white")>
        <Header_Buyer.Mobile key=router.asPath />
        <main className=%twc("w-full max-w-3xl mx-auto relative bg-white min-h-screen")>
          <div className=%twc("w-full flex items-center justify-center pt-[134px] px-5")>
            <span className=%twc("text-gray-800 text-xl text-center")>
              {`검색에 실패하였습니다`->React.string}
            </span>
          </div>
        </main>
        <Footer_Buyer.MO />
      </div>
    }
  }
}

module PC = {
  @react.component
  let make = (~keyword, ~query, ~gnbBanners, ~displayCategories) => {
    let router = Next.Router.useRouter()

    let {data: {products}, hasNext, loadNext} = Fragment.usePagination(query)
    let loadMoreRef = React.useRef(Js.Nullable.null)

    let isIntersecting = CustomHooks.IntersectionObserver.use(
      ~target=loadMoreRef,
      ~rootMargin="50px",
      ~thresholds=0.1,
      (),
    )

    let currentSection = router.query->Js.Dict.get("section")->Product_FilterOption.Section.make

    let selected = keyword => {
      currentSection == keyword
    }

    let resultObjLabel = switch currentSection {
    | #MATCHING => `신선매칭 상품이`
    | #DELIVERY => `신선배송 상품이`
    | _ => `검색결과가`
    }

    React.useEffect1(_ => {
      if hasNext && isIntersecting {
        loadNext(~count=20, ())->ignore
      }

      None
    }, [hasNext, isIntersecting])

    let onTabClickHandler = section => {
      let newRouteQueryParam = router.query

      let sortOption =
        router.query
        ->Js.Dict.get("sort")
        ->Option.map(sort' => Product_FilterOption.Sort.decodeSort(section, sort'))
        ->Option.getWithDefault(#UPDATED_DESC)

      newRouteQueryParam->Js.Dict.set("section", section->Product_FilterOption.Section.toString)

      newRouteQueryParam->Js.Dict.set("sort", sortOption->Product_FilterOption.Sort.encodeSort)

      router->Next.Router.replaceObj({pathname: router.pathname, query: newRouteQueryParam})
    }

    <div className=%twc("w-full min-w-[1280px] min-h-screen flex flex-col")>
      <Header_Buyer.PC key=router.asPath gnbBanners displayCategories />
      <main className=%twc("flex flex-col grow w-full h-full bg-white")>
        <div className=%twc("w-[1280px] mt-16 mx-auto h-12 px-5")>
          <div
            className=%twc(
              "flex flex-row justify-start border-b-[1px] border-gray-100 gap-[10px] "
            )>
            <button
              onClick={_ => onTabClickHandler(#ALL)}
              className={Cn.make([
                selected(#ALL) ? %twc("text-gray-800") : %twc("text-gray-400"),
                %twc("flex justify-center items-center h-full"),
              ])}>
              <div className=%twc("flex flex-col w-full h-full justify-center items-center")>
                <div
                  className=%twc(
                    "inline-flex flex-1 items-center justify-center font-bold px-[10px] py-3"
                  )>
                  {`전체`->React.string}
                </div>
                <div
                  className={Cn.make([
                    selected(#ALL) ? %twc("bg-gray-800") : %twc("bg-transparent"),
                    %twc("h-[2px] w-full rounded -mt-[3px]"),
                  ])}
                />
              </div>
            </button>
            <button
              onClick={_ => onTabClickHandler(#DELIVERY)}
              className={Cn.make([
                selected(#DELIVERY) ? %twc("text-gray-800") : %twc("text-gray-400"),
                %twc("flex justify-center items-center h-full"),
              ])}>
              <div className=%twc("flex flex-col w-full h-full justify-center items-center")>
                <div
                  className=%twc(
                    "inline-flex flex-1 items-center justify-center font-bold px-[10px] py-3"
                  )>
                  {`신선배송`->React.string}
                </div>
                <div
                  className={Cn.make([
                    selected(#DELIVERY) ? %twc("bg-gray-800") : %twc("bg-transparent"),
                    %twc("h-[2px] w-full rounded -mt-[3px]"),
                  ])}
                />
              </div>
            </button>
            <button
              onClick={_ => onTabClickHandler(#MATCHING)}
              className={Cn.make([
                selected(#MATCHING) ? %twc("text-gray-800") : %twc("text-gray-400"),
                %twc("flex justify-center items-center h-full"),
              ])}>
              <div className=%twc("flex flex-col w-full h-full justify-center items-center")>
                <div
                  className=%twc(
                    "inline-flex flex-1 items-center justify-center font-bold px-[10px] py-3"
                  )>
                  {`신선매칭`->React.string}
                </div>
                <div
                  className={Cn.make([
                    selected(#MATCHING) ? %twc("bg-gray-800") : %twc("bg-transparent"),
                    %twc("h-[2px] w-full rounded -mt-[3px]"),
                  ])}
                />
              </div>
            </button>
          </div>
        </div>
        {switch products.edges {
        // 검색결과 없음
        | [] =>
          <div className=%twc("my-40")>
            <div className=%twc("w-full flex items-center justify-center")>
              <span className=%twc("text-3xl text-gray-800")>
                <span className=%twc("font-bold")> {keyword->React.string} </span>
                {`에 대한 검색결과`->React.string}
              </span>
            </div>
            <div className=%twc("mt-7 w-full flex flex-col items-center justify-center")>
              <span className=%twc("text-gray-800")>
                <span className=%twc("text-green-500 font-bold")> {keyword->React.string} </span>
                {`의 ${resultObjLabel} 없습니다.`->React.string}
              </span>
              <span className=%twc("text-gray-800")>
                {`다른 검색어를 입력하시거나 철자와 띄어쓰기를 확인해 보세요.`->React.string}
              </span>
            </div>
          </div>
        | edges =>
          <div className=%twc("w-[1280px] mx-auto min-h-full px-5")>
            <div className=%twc("mt-10 w-full flex items-center justify-between")>
              <div className=%twc("text-sm mr-1 text-gray-800")>
                {`총 ${products.totalCount->Int.toString}개`->React.string}
              </div>
              <SRP_SortSelect.PC />
            </div>
            <div>
              <ol className=%twc("mt-6 grid grid-cols-4 gap-x-10 gap-y-16")>
                {edges
                ->Array.map(({cursor, node}) => {
                  <ShopProductListItem_Buyer.PC key=cursor query=node.fragmentRefs />
                })
                ->React.array}
              </ol>
              <div ref={ReactDOM.Ref.domRef(loadMoreRef)} className=%twc("h-20 w-full") />
            </div>
          </div>
        }}
      </main>
      <Footer_Buyer.PC />
    </div>
  }
}

module MO = {
  @react.component
  let make = (~keyword, ~query) => {
    let router = Next.Router.useRouter()

    let {data: {products}, hasNext, loadNext} = Fragment.usePagination(query)
    let loadMoreRef = React.useRef(Js.Nullable.null)

    let isIntersecting = CustomHooks.IntersectionObserver.use(
      ~target=loadMoreRef,
      ~rootMargin="50px",
      ~thresholds=0.1,
      (),
    )

    let currentSection = router.query->Js.Dict.get("section")->Product_FilterOption.Section.make

    let selected = keyword => {
      currentSection == keyword
    }

    let resultObjLabel = switch currentSection {
    | #MATCHING => `신선매칭 상품이`
    | #DELIVERY => `신선배송 상품이`
    | _ => `검색결과가`
    }

    React.useEffect1(_ => {
      if hasNext && isIntersecting {
        loadNext(~count=20, ())->ignore
      }

      None
    }, [hasNext, isIntersecting])

    let onTabClickHandler = section => {
      let newRouteQueryParam = router.query

      let sortOption =
        router.query
        ->Js.Dict.get("sort")
        ->Option.map(sort' => Product_FilterOption.Sort.decodeSort(section, sort'))
        ->Option.getWithDefault(#UPDATED_DESC)

      newRouteQueryParam->Js.Dict.set("section", section->Product_FilterOption.Section.toString)

      newRouteQueryParam->Js.Dict.set("sort", sortOption->Product_FilterOption.Sort.encodeSort)

      router->Next.Router.replaceObj({pathname: router.pathname, query: newRouteQueryParam})
    }

    <div className=%twc("w-full bg-white")>
      <Header_Buyer.Mobile key=router.asPath />
      <main className=%twc("w-full max-w-3xl mx-auto relative bg-white min-h-screen")>
        <div className=%twc("flex flex-row  h-12 border-b-[1px] border-gray-100 mt-[2px]")>
          <button
            onClick={_ => onTabClickHandler(#ALL)}
            className={Cn.make([
              selected(#ALL) ? %twc("text-gray-800") : %twc("text-gray-400"),
              %twc("flex flex-1 justify-center items-center h-full "),
            ])}>
            <div className=%twc("flex flex-col w-full h-full justify-center items-center px-5")>
              <div className=%twc("inline-flex flex-1 items-center justify-center font-bold")>
                {`전체`->React.string}
              </div>
              <div
                className={Cn.make([
                  selected(#ALL) ? %twc("bg-gray-800") : %twc("bg-transparent"),
                  %twc("h-[2px] w-full rounded"),
                ])}
              />
            </div>
          </button>
          <button
            onClick={_ => onTabClickHandler(#DELIVERY)}
            className={Cn.make([
              selected(#DELIVERY) ? %twc("text-gray-800") : %twc("text-gray-400"),
              %twc("flex flex-1 justify-center items-center h-full "),
            ])}>
            <div className=%twc("flex flex-col w-full h-full justify-center items-center px-5")>
              <div className=%twc("inline-flex flex-1 items-center justify-center font-bold")>
                {`신선배송`->React.string}
              </div>
              <div
                className={Cn.make([
                  selected(#DELIVERY) ? %twc("bg-gray-800") : %twc("bg-transparent"),
                  %twc("h-[2px] w-full rounded"),
                ])}
              />
            </div>
          </button>
          <button
            onClick={_ => onTabClickHandler(#MATCHING)}
            className={Cn.make([
              selected(#MATCHING) ? %twc("text-gray-800") : %twc("text-gray-400"),
              %twc("flex flex-1 justify-center items-center h-full "),
            ])}>
            <div className=%twc("flex flex-col w-full h-full justify-center items-center px-5")>
              <div className=%twc("inline-flex flex-1 items-center justify-center font-bold")>
                {`신선매칭`->React.string}
              </div>
              <div
                className={Cn.make([
                  selected(#MATCHING) ? %twc("bg-gray-800") : %twc("bg-transparent"),
                  %twc("h-[2px] w-full rounded"),
                ])}
              />
            </div>
          </button>
        </div>
        {switch products.edges {
        // 검색결과 없음
        | [] =>
          <>
            <div className=%twc("w-full flex items-center justify-center pt-[134px] px-5")>
              <span className=%twc("text-gray-800 text-xl text-center")>
                <span className=%twc("font-bold")> {keyword->React.string} </span>
                {`에 대한 검색결과`->React.string}
              </span>
            </div>
            <div
              className=%twc(
                "mt-2 w-full flex flex-col items-center justify-center text-center text-base text-gray-600"
              )>
              <span>
                <span className=%twc("text-green-500 font-bold")> {keyword->React.string} </span>
                {`의 ${resultObjLabel} 없습니다.`->React.string}
              </span>
              <span> {`다른 검색어를 입력하시거나`->React.string} </span>
              <span> {`철자와 띄어쓰기를 확인해 보세요.`->React.string} </span>
            </div>
          </>

        | edges =>
          <div className=%twc("w-full px-5")>
            <div className=%twc("pt-5 pb-4 w-full flex items-center justify-between")>
              <div className=%twc("text-gray-800 text-sm")>
                {`총 ${products.totalCount->Int.toString}개`->React.string}
              </div>
              <SRP_SortSelect.MO />
            </div>
            <div>
              <ol className=%twc("grid grid-cols-2 gap-x-4 gap-y-8")>
                {edges
                ->Array.map(({cursor, node}) => {
                  <ShopProductListItem_Buyer.MO key=cursor query=node.fragmentRefs />
                })
                ->React.array}
              </ol>
              <div ref={ReactDOM.Ref.domRef(loadMoreRef)} className=%twc("h-20 w-full") />
            </div>
          </div>
        }}
      </main>
      <Footer_Buyer.MO />
    </div>
  }
}

module Container = {
  @react.component
  let make = (~deviceType, ~keyword, ~sort, ~gnbBanners, ~displayCategories, ~section) => {
    // 채널톡 버튼 사용
    ChannelTalkHelper.Hook.use()

    let {fragmentRefs} = Query.use(
      ~variables=Query.makeVariables(
        ~name=keyword,
        ~count=20,
        ~sort,
        ~onlyBuyable=true,
        ~types=section->PLP_FilterOption.Section.toQueryParam,
        (),
      ),
      ~fetchPolicy=RescriptRelay.StoreOrNetwork,
      (),
    )

    React.useEffect1(() => {
      {
        "event": "view_search_results", // 이벤트 타입: 상품 검색 시
        "keyword": keyword, // 검색어
      }
      ->DataGtm.mergeUserIdUnsafe
      ->DataGtm.push

      None
    }, [keyword])

    switch deviceType {
    | DeviceDetect.Unknown => React.null
    | DeviceDetect.PC => <PC keyword query=fragmentRefs gnbBanners displayCategories />
    | DeviceDetect.Mobile => <MO keyword query=fragmentRefs />
    }
  }
}

type props = {
  query: Js.Dict.t<string>,
  deviceType: DeviceDetect.deviceType,
  gnbBanners: array<GnbBannerListBuyerQuery_graphql.Types.response_gnbBanners>,
  displayCategories: array<ShopCategorySelectBuyerQuery_graphql.Types.response_displayCategories>,
}
type params
type previewData

let default = (~props) => {
  let {deviceType, gnbBanners, displayCategories} = props
  let router = Next.Router.useRouter()
  let keyword = router.query->Js.Dict.get("keyword")->Option.map(Js.Global.decodeURIComponent)

  let section = router.query->Js.Dict.get("section")->PLP_FilterOption.Section.make

  let sort =
    router.query
    ->Js.Dict.get("sort")
    ->Option.map(sortStr => PLP_FilterOption.Sort.decodeSort(section, sortStr))
    ->Option.getWithDefault(#UPDATED_DESC)

  let (isCsr, setIsCsr) = React.Uncurried.useState(_ => false)

  React.useEffect0(() => {
    setIsCsr(._ => true)

    keyword->Option.forEach(keyword =>
      Global.Window.ReactNativeWebView.PostMessage.airbridgeWithPayload(
        ~kind=#VIEW_SEARCH_RESULT,
        ~payload={"query": keyword},
        (),
      )
    )

    None
  })

  <>
    <Next.Head>
      <title> {`신선하이`->React.string} </title>
    </Next.Head>
    <RescriptReactErrorBoundary fallback={_ => <Error deviceType gnbBanners displayCategories />}>
      <React.Suspense fallback={<Placeholder deviceType gnbBanners displayCategories />}>
        {switch (isCsr, keyword) {
        | (true, Some(keyword')) =>
          <Container deviceType keyword=keyword' sort gnbBanners displayCategories section />
        | _ => <Placeholder deviceType gnbBanners displayCategories />
        }}
      </React.Suspense>
    </RescriptReactErrorBoundary>
  </>
}

let getServerSideProps = (ctx: Next.GetServerSideProps.context<props, params, previewData>) => {
  let deviceType = DeviceDetect.detectDeviceFromCtx2(ctx.req)
  GnbBannerList_Buyer.Query.fetchPromised(~environment=RelayEnv.envSinsunMarket, ~variables=(), ())
  |> Js.Promise.then_((res: GnbBannerListBuyerQuery_graphql.Types.response) =>
    Js.Promise.resolve({
      "props": {"query": ctx.query, "deviceType": deviceType, "gnbBanners": res.gnbBanners},
    })
  )
  |> Js.Promise.catch(err => {
    Js.log2("에러 GnbBannerListBuyerQuery", err)
    Js.Promise.resolve({
      "props": {"query": ctx.query, "deviceType": deviceType, "gnbBanners": []},
    })
  })
}
