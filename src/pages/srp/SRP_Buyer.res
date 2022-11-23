module Query = %relay(`
  query SRPBuyer_Query(
    $count: Int!
    $cursor: String
    $name: String!
    $orderBy: [SearchProductsOrderBy!]
    $onlyBuyable: Boolean
    $type_: [ProductType!]
  ) {
    ...SRPBuyer_fragment
      @arguments(
        count: $count
        cursor: $cursor
        name: $name
        orderBy: $orderBy
        onlyBuyable: $onlyBuyable
        type: $type_
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
    orderBy: { type: "[SearchProductsOrderBy!]" }
    type: { type: "[ProductType!]" }
  ) {
    searchProducts(
      first: $count
      after: $cursor
      name: $name
      orderBy: $orderBy
      onlyBuyable: $onlyBuyable
      types: $type
    ) @connection(key: "ShopSearchBuyer_searchProducts") {
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
  let make = (~deviceType) => {
    let router = Next.Router.useRouter()
    switch deviceType {
    | DeviceDetect.Unknown => React.null

    | DeviceDetect.PC => {
        let oldUI =
          <div className=%twc("w-full min-w-[1280px] min-h-screen flex flex-col")>
            <Header_Buyer.PC key=router.asPath />
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
                      <ShopProductListItem_Buyer.PC.Placeholder
                        key={`box-${number->Int.toString}`}
                      />
                    })
                    ->React.array}
                  </ol>
                </section>
              </div>
            </main>
            <Footer_Buyer.PC />
          </div>

        <FeatureFlagWrapper featureFlag=#HOME_UI_UX fallback=oldUI>
          <div className=%twc("w-full min-w-[1280px] min-h-screen flex flex-col bg-[#FAFBFC]")>
            <Header_Buyer.PC key=router.asPath />
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
                      <ShopProductListItem_Buyer.PC.Placeholder
                        key={`box-${number->Int.toString}`}
                      />
                    })
                    ->React.array}
                  </ol>
                </section>
              </div>
            </main>
            <Footer_Buyer.PC />
          </div>
        </FeatureFlagWrapper>
      }

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
      </div>
    }
  }
}

module Error = {
  @react.component
  let make = (~deviceType) => {
    let router = Next.Router.useRouter()

    switch deviceType {
    | DeviceDetect.Unknown => React.null

    | DeviceDetect.PC =>
      <div className=%twc("w-full min-w-[1280px] min-h-screen flex flex-col")>
        <Header_Buyer.PC key=router.asPath />
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
      </div>
    }
  }
}

module PC = {
  @react.component
  let make = (~keyword, ~query, ~section: Product_FilterOption.Section.t) => {
    let router = Next.Router.useRouter()

    let {data: {searchProducts}, hasNext, loadNext} = query->Fragment.usePagination
    let loadMoreRef = React.useRef(Js.Nullable.null)

    let isIntersecting = CustomHooks.IntersectionObserver.use(
      ~target=loadMoreRef,
      ~rootMargin="50px",
      ~thresholds=0.1,
      (),
    )

    let resultObjLabel = switch section {
    | #MATCHING => `신선매칭 상품이`
    | #DELIVERY => `신선배송 상품이`
    | #ALL => `검색결과가`
    }

    React.useEffect1(_ => {
      if hasNext && isIntersecting {
        loadNext(~count=20, ())->ignore
      }

      None
    }, [hasNext, isIntersecting])

    let oldUI =
      <div className=%twc("w-full min-w-[1280px] min-h-screen flex flex-col")>
        <Header_Buyer.PC key=router.asPath />
        <main className=%twc("flex flex-col grow w-full h-full bg-white")>
          {switch keyword {
          | Some(keyword) =>
            <>
              <div className=%twc("w-[1280px] mt-16 mx-auto h-12 px-5")>
                <SRP_Tab currentSection=section />
              </div>
              {switch searchProducts.edges {
              // 검색결과 없음
              | [] =>
                <div className=%twc("my-40")>
                  <div className=%twc("w-full flex items-center justify-center")>
                    <span className=%twc("text-3xl text-gray-800")>
                      <span className=%twc("font-bold")> {`"${keyword}"`->React.string} </span>
                      {`에 대한 검색결과`->React.string}
                    </span>
                  </div>
                  <div className=%twc("mt-7 w-full flex flex-col items-center justify-center")>
                    <span className=%twc("text-gray-800")>
                      <span className=%twc("text-green-500 font-bold")>
                        {`"${keyword}"`->React.string}
                      </span>
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
                      {`총 ${searchProducts.totalCount->Int.toString}개`->React.string}
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
            </>
          | None => React.null
          }}
        </main>
        <Footer_Buyer.PC />
      </div>

    <FeatureFlagWrapper featureFlag=#HOME_UI_UX fallback=oldUI>
      <div className=%twc("w-full min-w-[1280px] min-h-screen flex flex-col bg-[#FAFBFC]")>
        <Header_Buyer.PC key=router.asPath />
        <main
          className=%twc(
            "max-w-[1280px] min-w-[872px] mx-auto m-10 py-10 flex flex-col grow w-full h-full rounded-sm bg-white shadow-[0px_10px_40px_10px_rgba(0,0,0,0.03)] px-[50px] min-h-[720px]"
          )>
          {switch keyword {
          | Some(keyword) =>
            <>
              {switch searchProducts.edges {
              // 검색결과 없음
              | [] =>
                <>
                  <h3 className=%twc("text-[26px] font-bold")> {`'${keyword}'`->React.string} </h3>
                  <div
                    className=%twc(
                      "max-w-[1280px] min-w-[872px] w-full h-full flex-1 mt-[60px] flex flex-col"
                    )>
                    <div
                      className=%twc(
                        "flex flex-1  flex-col justify-center items-center text-[17px] text-gray-800 mb-[100px]"
                      )>
                      <span className=%twc("font-bold mb-6")>
                        {"검색결과가 없습니다."->React.string}
                      </span>
                      <span> {"다른 검색어를 입력하시거나"->React.string} </span>
                      <span>
                        {"철자와 띄어쓰기를 확인해 보세요."->React.string}
                      </span>
                    </div>
                  </div>
                </>

              | edges =>
                <>
                  <h3 className=%twc("text-[26px] font-bold")> {`'${keyword}'`->React.string} </h3>
                  <div className=%twc("max-w-[1280px] min-w-[872px] w-full min-h-full mt-[60px]")>
                    <div className=%twc(" w-full flex items-center justify-between mb-8")>
                      <PLP_SectionCheckBoxGroup />
                      <SRP_SortSelect.PC />
                    </div>
                    <div>
                      <ol className=%twc("grid plp-max:grid-cols-5 grid-cols-4 gap-x-10 gap-y-16")>
                        {edges
                        ->Array.map(({cursor, node}) => {
                          <ShopProductListItem_Buyer.PC key=cursor query=node.fragmentRefs />
                        })
                        ->React.array}
                      </ol>
                      <div ref={ReactDOM.Ref.domRef(loadMoreRef)} className=%twc("h-20 w-full") />
                    </div>
                  </div>
                </>
              }}
            </>
          | None => React.null
          }}
        </main>
        <Footer_Buyer.PC />
      </div>
    </FeatureFlagWrapper>
  }
}

module MO = {
  @react.component
  let make = (~keyword, ~query, ~section: Product_FilterOption.Section.t) => {
    let router = Next.Router.useRouter()

    let {data: {searchProducts}, hasNext, loadNext} = query->Fragment.usePagination
    let loadMoreRef = React.useRef(Js.Nullable.null)

    let isIntersecting = CustomHooks.IntersectionObserver.use(
      ~target=loadMoreRef,
      ~rootMargin="50px",
      ~thresholds=0.1,
      (),
    )

    let resultObjLabel = switch section {
    | #MATCHING => `신선매칭 상품이`
    | #DELIVERY => `신선배송 상품이`
    | #ALL => `검색결과가`
    }

    React.useEffect1(_ => {
      if hasNext && isIntersecting {
        loadNext(~count=20, ())->ignore
      }

      None
    }, [hasNext, isIntersecting])

    <div className=%twc("w-full bg-white")>
      <Header_Buyer.Mobile key=router.asPath />
      <main className=%twc("w-full max-w-3xl mx-auto relative bg-white h-full")>
        {switch keyword {
        | Some(keyword) =>
          <>
            <SRP_Tab currentSection=section />
            {switch searchProducts.edges {
            // 검색결과 없음
            | [] =>
              <>
                <div className=%twc("w-full flex items-center justify-center pt-[134px] px-5")>
                  <span className=%twc("text-gray-800 text-xl text-center")>
                    <span className=%twc("font-bold")> {`"${keyword}"`->React.string} </span>
                    {`에 대한 검색결과`->React.string}
                  </span>
                </div>
                <div
                  className=%twc(
                    "mt-2 w-full flex flex-col items-center justify-center text-center text-base text-gray-600"
                  )>
                  <span>
                    <span className=%twc("text-green-500 font-bold")>
                      {`"${keyword}"`->React.string}
                    </span>
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
                    {`총 ${searchProducts.totalCount->Int.toString}개`->React.string}
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
          </>
        | None => <SRP_RecentSearchList />
        }}
      </main>
    </div>
  }
}

module Container = {
  @react.component
  let make = (~deviceType, ~keyword, ~sort, ~section) => {
    // 채널톡 버튼 사용
    ChannelTalkHelper.Hook.use()

    let {fragmentRefs} = Query.use(
      ~variables=Query.makeVariables(
        ~name=keyword->Option.getWithDefault(""),
        ~count=20,
        ~orderBy=sort->Product_FilterOption.Sort.toSearchProductParam->Option.getWithDefault([]),
        ~onlyBuyable=true,
        ~type_=section->Product_FilterOption.Section.toQueryParam,
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
    | DeviceDetect.PC => <PC keyword query=fragmentRefs section />
    | DeviceDetect.Mobile => <MO keyword query=fragmentRefs section />
    }
  }
}

type props = {deviceType: DeviceDetect.deviceType}
type params
type previewData

let default = (~props) => {
  let {deviceType} = props
  let router = Next.Router.useRouter()
  let keyword = router.query->Js.Dict.get("keyword")->Option.map(Js.Global.decodeURIComponent)

  let section =
    router.query
    ->Js.Dict.get("section")
    ->Product_FilterOption.Section.fromUrlParameter
    ->Option.getWithDefault(#ALL)

  let sort =
    section
    ->Product_FilterOption.Sort.makeSearch(router.query->Js.Dict.get("sort"))
    ->Option.getWithDefault(Product_FilterOption.Sort.defaultValue)

  let isCsr = CustomHooks.useCsr()

  React.useEffect0(() => {
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
      <title>
        {`신선하이 | ${keyword->Option.getWithDefault("상품검색")}`->React.string}
      </title>
      <meta
        name="description"
        content={`농산물 소싱은 신선하이에서! ${keyword->Option.getWithDefault(
            "",
          )}에 대한 검색결과입니다.`}
      />
    </Next.Head>
    <OpenGraph_Header
      title={`${keyword->Option.getWithDefault("")} 검색결과`}
      description={`${keyword->Option.getWithDefault("")}에 대한 검색결과입니다.`}
    />
    <RescriptReactErrorBoundary fallback={_ => <Error deviceType />}>
      <React.Suspense fallback={<Placeholder deviceType />}>
        {switch isCsr {
        | true => <Container deviceType keyword sort section />

        | _ => <Placeholder deviceType />
        }}
      </React.Suspense>
    </RescriptReactErrorBoundary>
    <Bottom_Navbar deviceType />
  </>
}

let getServerSideProps = (ctx: Next.GetServerSideProps.context<props, params, previewData>) => {
  open ServerSideHelper
  let environment = SinsunMarket(Env.graphqlApiUrl)->RelayEnv.environment
  let gnbAndCategoryQuery = environment->gnbAndCategory

  let deviceType = DeviceDetect.detectDeviceFromCtx2(ctx.req)

  // TEMP: 가격노출조건 개선 전까지, SSR disable, CSR Only
  gnbAndCategoryQuery->makeResultWithQuery(~environment, ~extraProps={"deviceType": deviceType})
  // let keyword = ctx.query->Js.Dict.get("keyword")->Option.map(Js.Global.decodeURIComponent)
  // let section = ctx.query->Js.Dict.get("section")->PLP_FilterOption.Section.make
  // let sort =
  //   ctx.query
  //   ->Js.Dict.get("sort")
  //   ->Option.map(sortStr => PLP_FilterOption.Sort.decodeSort(section, sortStr))
  //   ->Option.getWithDefault(#UPDATED_DESC)

  // let resolveEnv = _ => {
  //   {"props": environment->RelayEnv.createDehydrateProps()}->Js.Promise.resolve
  // }

  // switch keyword {
  // | None => resolveEnv()

  // | Some(keyword') =>
  //   Query.fetchPromised(
  //     ~environment,
  //     ~variables=Query.makeVariables(
  //       ~name=keyword',
  //       ~count=20,
  //       ~sort,
  //       ~onlyBuyable=true,
  //       ~types=section->PLP_FilterOption.Section.toQueryParam,
  //       (),
  //     ),
  //     (),
  //   )
  //   |> Js.Promise.then_(resolveEnv)
  //   |> Js.Promise.catch(resolveEnv)
  // }
}
