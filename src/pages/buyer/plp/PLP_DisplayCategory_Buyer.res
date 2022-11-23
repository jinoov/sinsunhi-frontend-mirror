module Query = %relay(`
  query PLPDisplayCategoryBuyerQuery(
    $displayCategoryId: ID!
    $cursor: ID
    $count: Int!
    $sort: DisplayCategoryProductsSort
    $orderBy: [ProductsOrderBy!]
    $onlyBuyable: Boolean
    $productType: [ProductType!]
  ) {
    node(id: $displayCategoryId) {
      ... on DisplayCategory {
        name
        ...PLPDisplayCategoryBuyerFragment
          @arguments(
            count: $count
            cursor: $cursor
            sort: $sort
            orderBy: $orderBy
            onlyBuyable: $onlyBuyable
            productType: $productType
          )
      }
    }
  }
`)

module Fragment = %relay(`
  fragment PLPDisplayCategoryBuyerFragment on DisplayCategory
  @refetchable(queryName: "PLPDisplayCategoryBuyerRefetchQuery")
  @argumentDefinitions(
    cursor: { type: "ID", defaultValue: null }
    onlyBuyable: { type: "Boolean", defaultValue: null }
    count: { type: "Int!" }
    sort: { type: "DisplayCategoryProductsSort", defaultValue: null }
    orderBy: {type: "[ProductsOrderBy!]", defaultValue: null}
    productType: { type: "[ProductType!]" }
  ) {
    name
    type_: type
    products(
      after: $cursor
      first: $count
      sort: $sort
      orderBy: $orderBy
      onlyBuyable: $onlyBuyable
      type: $productType
    ) @connection(key: "PLPDisplayCategory_products") {
      edges {
        cursor
        node {
          ...ShopProductListItemBuyerFragment
        }
      }
    }
  }
`)

let toOrderBy = (sort): array<PLPDisplayCategoryBuyerQuery_graphql.Types.productsOrderBy> =>
  switch sort {
  | #UPDATED_ASC => [
      {field: #STATUS_PRIORITY, direction: #ASC},
      {field: #UPDATED_AT, direction: #ASC},
    ]
  | #UPDATED_DESC => [
      {field: #STATUS_PRIORITY, direction: #ASC},
      {field: #UPDATED_AT, direction: #DESC},
    ]
  | #PRICE_ASC => [
      {field: #STATUS_PRIORITY, direction: #ASC},
      {field: #PRICE, direction: #ASC_NULLS_LAST},
      {field: #UPDATED_AT, direction: #DESC},
    ]
  | #PRICE_PER_KG_ASC => [
      {field: #STATUS_PRIORITY, direction: #ASC},
      {field: #PRICE_PER_KG, direction: #ASC_NULLS_LAST},
      {field: #UPDATED_AT, direction: #DESC},
    ]
  | #PRICE_DESC => [
      {field: #STATUS_PRIORITY, direction: #ASC},
      {field: #PRICE, direction: #DESC_NULLS_LAST},
      {field: #UPDATED_AT, direction: #DESC},
    ]
  | #PRICE_PER_KG_DESC => [
      {field: #STATUS_PRIORITY, direction: #ASC},
      {field: #PRICE_PER_KG, direction: #DESC_NULLS_LAST},
      {field: #UPDATED_AT, direction: #DESC},
    ]
  | #RELEVANCE_DESC => [
      {field: #STATUS_PRIORITY, direction: #ASC},
      {field: #POPULARITY, direction: #DESC},
    ]
  | #POPULARITY_DESC => [
      {field: #STATUS_PRIORITY, direction: #ASC},
      {field: #POPULARITY, direction: #DESC},
    ]
  }

module NewPC = {
  @react.component
  let make = (~query, ~displayCategoryId) => {
    let router = Next.Router.useRouter()

    let {data: {type_, products, name}, hasNext, loadNext} = query->Fragment.usePagination

    let loadMoreRef = Js.Nullable.null->React.useRef

    let isIntersecting = CustomHooks.IntersectionObserver.use(
      ~target=loadMoreRef,
      ~rootMargin="50px",
      ~thresholds=0.1,
      (),
    )

    let isNoneSectionType = router.query->Js.Dict.get("section")->Option.isNone

    React.useEffect1(_ => {
      if hasNext && isIntersecting {
        loadNext(~count=20, ())->ignore
      }
      None
    }, [hasNext, isIntersecting])

    React.useEffect0(_ => {
      Global.Window.ReactNativeWebView.PostMessage.airbridgeWithPayload(
        ~kind=#VIEW_PRODUCT_LIST,
        ~payload={"listID": displayCategoryId, "action": name},
        (),
      )

      None
    })

    <div className=%twc("w-full min-h-screen bg-[#F0F2F5]")>
      <Header_Buyer.PC key=router.asPath />
      {switch (products.edges, isNoneSectionType) {
      // 명시적으로 신선매칭/신선배송 모두 아닌 경우
      // 상품이 하나도 없는 경우
      | (_, true)
      | ([], _) =>
        <div className=%twc("flex pc-content bg-[#FAFBFC]")>
          <PC_PLP_Sidebar />
          <div
            className=%twc(
              "max-w-[1280px] min-w-[872px] w-full mt-10 pt-10 px-[50px] pb-16 mx-16 mr-auto min-h-full rounded-sm bg-white shadow-[0px_10px_40px_10px_rgba(0,0,0,0.03)] mb-14"
            )>
            <PC_PLP_ChipList parentId=displayCategoryId />
            <div className=%twc("mt-[64px]")>
              <div className=%twc("mb-12 w-full flex items-center justify-between")>
                <PLP_SectionCheckBoxGroup />
              </div>
            </div>
            <div className=%twc("pt-20 flex flex-col items-center justify-center text-gray-800")>
              <h1 className=%twc("text-3xl")>
                {`상품이 존재하지 않습니다`->React.string}
              </h1>
              <span className=%twc("mt-7")>
                {`해당 카테고리에 상품이 존재하지 않습니다.`->React.string}
              </span>
              <span> {`다른 카테고리를 선택해 주세요.`->React.string} </span>
            </div>
          </div>
        </div>

      // 상품이 1개 이상 있을 경우
      | (edges, _) =>
        <div className=%twc("flex pc-content bg-[#FAFBFC]")>
          <PC_PLP_Sidebar />
          <div
            className=%twc(
              "max-w-[1280px] min-w-[872px] w-full mt-10 pt-10 px-[50px] pb-16 mx-16 min-h-full rounded-sm bg-white shadow-[0px_10px_40px_10px_rgba(0,0,0,0.03)] mb-14"
            )>
            <PC_PLP_ChipList parentId=displayCategoryId />
            <div className=%twc("mt-[64px]")>
              {switch type_ {
              | #NORMAL =>
                <div className=%twc("mb-12 w-full flex items-center justify-between")>
                  <PLP_SectionCheckBoxGroup />
                  <PLP_SortSelect.PC />
                </div>
              | _ => React.null
              }}
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
        </div>
      }}
      <Footer_Buyer.PC />
    </div>
  }
}

module PC = {
  @react.component
  let make = (~query, ~displayCategoryId) => {
    let router = Next.Router.useRouter()

    let {data: {type_, products, name}, hasNext, loadNext} = query->Fragment.usePagination

    let loadMoreRef = Js.Nullable.null->React.useRef

    let isIntersecting = CustomHooks.IntersectionObserver.use(
      ~target=loadMoreRef,
      ~rootMargin="50px",
      ~thresholds=0.1,
      (),
    )

    let isNoneSectionType = router.query->Js.Dict.get("section")->Option.isNone

    React.useEffect1(_ => {
      if hasNext && isIntersecting {
        loadNext(~count=20, ())->ignore
      }
      None
    }, [hasNext, isIntersecting])

    React.useEffect0(_ => {
      Global.Window.ReactNativeWebView.PostMessage.airbridgeWithPayload(
        ~kind=#VIEW_PRODUCT_LIST,
        ~payload={"listID": displayCategoryId, "action": name},
        (),
      )

      None
    })

    <div className=%twc("w-full min-w-[1280px] min-h-screen")>
      <Header_Buyer.PC key=router.asPath />
      {switch (products.edges, isNoneSectionType) {
      // 명시적으로 신선매칭/신선배송 모두 아닌 경우
      // 상품이 하나도 없는 경우
      | (_, true)
      | ([], _) =>
        <>
          <div className=%twc("w-[1280px] pt-20 px-5 pb-16 mx-auto min-h-full")>
            <PLP_Scrollable_Header.PC parentId=displayCategoryId />
            <div className=%twc("mt-[64px]")>
              <div className=%twc("mb-12 w-full flex items-center justify-between")>
                <PLP_SectionCheckBoxGroup />
              </div>
            </div>
            <div className=%twc("pt-20 flex flex-col items-center justify-center text-gray-800")>
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

      // 상품이 1개 이상 있을 경우
      | (edges, _) =>
        <div className=%twc("w-[1280px] pt-20 px-5 pb-16 mx-auto min-h-full")>
          <PLP_Scrollable_Header.PC parentId=displayCategoryId />
          <div className=%twc("mt-[64px]")>
            {switch type_ {
            | #NORMAL =>
              <div className=%twc("mb-12 w-full flex items-center justify-between")>
                <PLP_SectionCheckBoxGroup />
                <PLP_SortSelect.PC />
              </div>
            | _ => React.null
            }}
            <ol className=%twc("grid grid-cols-4 gap-x-10 gap-y-16")>
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
      <Footer_Buyer.PC />
    </div>
  }
}

module MO = {
  @react.component
  let make = (~query, ~displayCategoryId) => {
    let router = Next.Router.useRouter()

    let {data: {type_, products, name}, hasNext, loadNext} = query->Fragment.usePagination

    let loadMoreRef = Js.Nullable.null->React.useRef

    let isIntersecting = CustomHooks.IntersectionObserver.use(
      ~target=loadMoreRef,
      ~rootMargin="50px",
      ~thresholds=0.1,
      (),
    )

    let isNoneSectionType = router.query->Js.Dict.get("section")->Option.isNone

    React.useEffect1(_ => {
      if hasNext && isIntersecting {
        loadNext(~count=20, ())->ignore
      }
      None
    }, [hasNext, isIntersecting])

    React.useEffect0(_ => {
      Global.Window.ReactNativeWebView.PostMessage.airbridgeWithPayload(
        ~kind=#VIEW_PRODUCT_LIST,
        ~payload={"listID": displayCategoryId, "action": name},
        (),
      )

      None
    })

    <div className=%twc("w-full min-h-screen bg-white")>
      <div className=%twc("w-full max-w-3xl mx-auto bg-white min-h-screen")>
        <PLP_Header_Buyer key=router.asPath />
        <PLP_Scrollable_Header.MO parentId=displayCategoryId />
        {switch (products.edges, isNoneSectionType) {
        // 상품이 하나도 없는 경우
        | (_, true)
        | ([], _) =>
          <div className=%twc("w-full pt-[18px] px-5")>
            <div className=%twc("mb-4 w-full flex items-center justify-between")>
              <PLP_SectionCheckBoxGroup />
            </div>
            <div
              className=%twc(
                "py-[126px] flex flex-col items-center justify-center text-gray-800 px-5"
              )>
              <h1 className=%twc("text-xl")>
                {`상품이 존재하지 않습니다`->React.string}
              </h1>
              <span className=%twc("mt-2 text-sm text-gray-600 text-center")>
                {`해당 카테고리에 상품이 존재하지 않습니다.`->React.string}
              </span>
              <span className=%twc("mt-2 text-sm text-gray-600 text-center")>
                {`다른 카테고리를 선택해 주세요.`->React.string}
              </span>
            </div>
          </div>
        // 상품이 1개 이상 있을 경우
        | (edges, _) =>
          <div className=%twc("w-full pt-[18px] px-5")>
            {switch type_ {
            | #NORMAL =>
              <div className=%twc("mb-4 w-full flex items-center justify-between")>
                <PLP_SectionCheckBoxGroup />
                <PLP_SortSelect.MO />
              </div>
            | _ => React.null
            }}
            <ol className=%twc("grid grid-cols-2 gap-x-4 gap-y-8")>
              {edges
              ->Array.map(({cursor, node}) => {
                <ShopProductListItem_Buyer.MO key=cursor query=node.fragmentRefs />
              })
              ->React.array}
            </ol>
            <div ref={ReactDOM.Ref.domRef(loadMoreRef)} className=%twc("h-20 w-full") />
          </div>
        }}
        <Footer_Buyer.MO />
      </div>
    </div>
  }
}

module Placeholder = {
  @react.component
  let make = (~deviceType) => {
    let router = Next.Router.useRouter()

    switch deviceType {
    | DeviceDetect.Unknown => React.null

    | DeviceDetect.PC => {
        let oldUI =
          <div className=%twc("w-full min-w-[1280px] min-h-screen")>
            <Header_Buyer.PC key=router.asPath />
            <div className=%twc("w-[1280px] pt-[92px] px-5 pb-16 mx-auto")>
              <PLP_Scrollable_Header.PC.Skeleton />
              <section className=%twc("w-full mt-[64px]")>
                <ol className=%twc("grid grid-cols-4 gap-x-10 gap-y-16")>
                  {Array.range(1, 300)
                  ->Array.map(number => {
                    <ShopProductListItem_Buyer.PC.Placeholder key={`box-${number->Int.toString}`} />
                  })
                  ->React.array}
                </ol>
              </section>
            </div>
            <Footer_Buyer.PC />
          </div>

        <FeatureFlagWrapper featureFlag=#HOME_UI_UX fallback=oldUI>
          <div className=%twc("w-full min-w-[1280px] min-h-screen bg-[#FAFBFC]")>
            <Header_Buyer.PC key=router.asPath />
            <div className=%twc("flex pc-content")>
              <PC_PLP_Sidebar.Skeleton />
              <div
                className=%twc(
                  "w-[1280px] mt-10 pt-10 px-[50px] pb-16 ml-16 mr-auto min-h-full rounded-sm bg-white shadow-[0px_10px_40px_10px_rgba(0,0,0,0.03)] mb-14"
                )>
                <PC_PLP_ChipList.Skeleton />
                <section className=%twc("w-full mt-[64px]")>
                  <ol className=%twc("grid plp-max:grid-cols-5 grid-cols-4 gap-x-10 gap-y-16")>
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
            </div>
            <Footer_Buyer.PC />
          </div>
        </FeatureFlagWrapper>
      }

    | DeviceDetect.Mobile =>
      <div className=%twc("w-full min-h-screen bg-white")>
        <div className=%twc("w-full max-w-3xl mx-auto bg-white min-h-screen")>
          <Header_Buyer.Mobile key=router.asPath />
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
          <Footer_Buyer.MO />
        </div>
      </div>
    }
  }
}

module NotFound = {
  @react.component
  let make = (~deviceType) => {
    let router = Next.Router.useRouter()
    switch deviceType {
    | DeviceDetect.Unknown => React.null

    | DeviceDetect.PC =>
      <div className=%twc("w-full min-w-[1280px] min-h-screen")>
        <Header_Buyer.PC key=router.asPath />
        <div
          className=%twc("pt-20 flex flex-col items-center justify-center text-gray-800 h-[800px]")>
          <h1 className=%twc("text-3xl")>
            {`카테고리를 찾을 수 없습니다`->React.string}
          </h1>
          <span className=%twc("mt-7")>
            {`해당 카테고리를 찾을 수 없습니다.`->React.string}
          </span>
          <span> {`다른 카테고리를 선택해 주세요.`->React.string} </span>
        </div>
        <Footer_Buyer.PC />
      </div>

    | DeviceDetect.Mobile =>
      <div className=%twc("w-full min-h-screen bg-white")>
        <div className=%twc("w-full max-w-3xl mx-auto bg-white min-h-screen")>
          <Header_Buyer.Mobile key=router.asPath />
          <div
            className=%twc(
              "pt-[126px] flex flex-col items-center justify-center text-gray-800 px-5"
            )>
            <h1 className=%twc("text-xl")>
              {`카테고리를 찾을 수 없습니다`->React.string}
            </h1>
            <span className=%twc("mt-2 text-sm text-gray-600 text-center")>
              {`해당 카테고리를 찾을 수 없습니다.`->React.string}
            </span>
            <span className=%twc("mt-2 text-sm text-gray-600 text-center")>
              {`다른 카테고리를 선택해 주세요.`->React.string}
            </span>
          </div>
          <Footer_Buyer.MO />
        </div>
      </div>
    }
  }
}

module Presenter = {
  @react.component
  let make = (~deviceType, ~query, ~displayCategoryId) => {
    switch deviceType {
    | DeviceDetect.Unknown => React.null
    | DeviceDetect.PC =>
      <FeatureFlagWrapper featureFlag=#HOME_UI_UX fallback={<PC query displayCategoryId />}>
        <NewPC query displayCategoryId />
      </FeatureFlagWrapper>

    | DeviceDetect.Mobile => <MO query displayCategoryId />
    }
  }
}

module Container = {
  @react.component
  let make = (~deviceType, ~displayCategoryId, ~sort) => {
    // 채널톡 버튼 사용
    ChannelTalkHelper.Hook.use()

    let router = Next.Router.useRouter()
    let sectionType =
      router.query
      ->Js.Dict.get("section")
      ->Product_FilterOption.Section.fromUrlParameter
      ->Option.map(Product_FilterOption.Section.toQueryParam)

    let variables = Query.makeVariables(
      ~displayCategoryId,
      ~orderBy=sort->toOrderBy,
      ~count=20,
      ~onlyBuyable=true,
      ~productType=sectionType->Option.getWithDefault([]),
      (),
    )
    let {node} = Query.use(~variables, ~fetchPolicy=RescriptRelay.StoreOrNetwork, ())

    switch node {
    | None => <NotFound deviceType />
    | Some({fragmentRefs, name}) =>
      <>
        <Next.Head>
          <title> {`신선하이 | ${name}`->React.string} </title>
          <meta
            name="description"
            content="농산물 소싱은 신선하이에서! 전국 70만 산지농가의 우수한 농산물을 싸고 편리하게 공급합니다. 국내 유일한 농산물 B2B 플랫폼 신선하이와 함께 매출을 올려보세요."
          />
        </Next.Head>
        <OpenGraph_Header
          title={`신선하이 | ${name}`} description={`${name} 상품입니다.`}
        />
        <Presenter query=fragmentRefs deviceType displayCategoryId />
      </>
    }
  }
}

@react.component
let make = (~deviceType, ~displayCategoryId) => {
  let router = Next.Router.useRouter()

  let sectionType =
    router.query->Js.Dict.get("section")->Product_FilterOption.Section.fromUrlParameter

  let sort =
    sectionType
    ->Option.flatMap(sectionType' =>
      sectionType'->Product_FilterOption.Sort.make(router.query->Js.Dict.get("sort"))
    )
    ->Option.getWithDefault(Product_FilterOption.Sort.defaultValue)

  <RescriptReactErrorBoundary fallback={_ => <Placeholder deviceType />}>
    <React.Suspense fallback={<Placeholder deviceType />}>
      <Container deviceType displayCategoryId sort />
    </React.Suspense>
  </RescriptReactErrorBoundary>
}
