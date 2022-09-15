module Query = %relay(`
  query PLPAllBuyerQuery(
    $cursor: String
    $count: Int!
    $sort: ProductsQueryInputSort
    $onlyBuyable: Boolean
    $productType: [ProductType!]
  ) {
    ...PLPAllBuyerFragment
      @arguments(
        count: $count
        cursor: $cursor
        sort: $sort
        onlyBuyable: $onlyBuyable
        productType: $productType
      )
  }
`)

module Fragment = %relay(`
  fragment PLPAllBuyerFragment on Query
  @refetchable(queryName: "PLPAllBuyerRefetchQuery")
  @argumentDefinitions(
    cursor: { type: "String", defaultValue: null }
    onlyBuyable: { type: "Boolean", defaultValue: null }
    count: { type: "Int!" }
    sort: { type: "ProductsQueryInputSort", defaultValue: UPDATED_DESC }
    productType: { type: "[ProductType!]" }
  ) {
    products(
      after: $cursor
      first: $count
      sort: $sort
      onlyBuyable: $onlyBuyable
      type: $productType
    ) @connection(key: "PLPAllBuyer_products") {
      edges {
        cursor
        node {
          ...ShopProductListItemBuyerFragment
        }
      }
    }
  }
`)

module PC = {
  @react.component
  let make = (~query, ~gnbBanners, ~displayCategories) => {
    let router = Next.Router.useRouter()
    let {data: {products}, hasNext, loadNext} = query->Fragment.usePagination

    let loadMoreRef = React.useRef(Js.Nullable.null)

    let isIntersecting = CustomHooks.IntersectionObserver.use(
      ~target=loadMoreRef,
      ~rootMargin="50px",
      ~thresholds=0.1,
      (),
    )

    let isNoneSectionType =
      router.query
      ->Js.Dict.get("section-type")
      ->Option.map(sectionType => sectionType == "none")
      ->Option.getWithDefault(false)

    React.useEffect1(_ => {
      if hasNext && isIntersecting {
        loadNext(~count=20, ())->ignore
      }
      None
    }, [hasNext, isIntersecting])

    <div className=%twc("w-full min-w-[1280px] min-h-screen")>
      <Header_Buyer.PC key=router.asPath gnbBanners displayCategories />
      {switch (products.edges, isNoneSectionType) {
      // 명시적으로 신선매칭/신선배송 모두 아닌 경우
      // 상품이 하나도 없는 경우
      | (_, true)
      | ([], _) =>
        <div className=%twc("w-[1280px] pt-20 px-5 pb-16 mx-auto min-h-full")>
          <div className=%twc("font-bold text-3xl text-gray-800 mb-[29px]")>
            {`전체 상품`->React.string}
          </div>
          <div className=%twc("mt-[84px] flex flex-col items-center justify-center text-gray-800")>
            <h1 className=%twc("text-3xl")>
              {`상품이 존재하지 않습니다`->React.string}
            </h1>
            <span className=%twc("mt-7")>
              {`해당 카테고리에 상품이 존재하지 않습니다.`->React.string}
            </span>
            <span> {`다른 카테고리를 선택해 주세요.`->React.string} </span>
          </div>
        </div>

      // 상품이 1개 이상 있을 경우
      | (edges, _) =>
        <div className=%twc("w-[1280px] pt-20 px-5 pb-16 mx-auto min-h-full")>
          <div className=%twc("font-bold text-3xl text-gray-800 mb-[29px]")>
            {`전체 상품`->React.string}
          </div>
          <div className=%twc("mt-[64px]")>
            <div className=%twc("mb-12 w-full flex items-center justify-end")>
              <ShopProductsSortSelect_Buyer />
            </div>
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
  let make = (~query) => {
    let router = Next.Router.useRouter()

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

    <div className=%twc("w-full min-h-screen bg-white")>
      <div className=%twc("w-full max-w-3xl mx-auto bg-white min-h-screen")>
        <PLP_Header_Buyer key=router.asPath />
        {switch products.edges {
        // 상품이 하나도 없는 경우
        | [] =>
          <div
            className=%twc(
              "mt-[126px] flex flex-col items-center justify-center text-gray-800 px-5"
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

        // 상품이 1개 이상 있을 경우
        | edges =>
          <div className=%twc("w-full pt-4 px-5")>
            <div className=%twc("mb-4 w-full flex items-center justify-end")>
              <ShopProductsSortSelect_Buyer.MO />
            </div>
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
  let make = (~deviceType, ~gnbBanners, ~displayCategories) => {
    let router = Next.Router.useRouter()

    switch deviceType {
    | DeviceDetect.Unknown => React.null

    | DeviceDetect.PC =>
      <div className=%twc("w-full min-w-[1280px] min-h-screen")>
        <Header_Buyer.PC key=router.asPath gnbBanners displayCategories />
        <div className=%twc("w-[1280px] pt-[92px] px-5 pb-16 mx-auto")>
          <div
            className=%twc("w-[160px] h-[44px] rounded-lg animate-pulse bg-gray-150 mb-[29px]")
          />
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

    | DeviceDetect.Mobile =>
      <div className=%twc("w-full min-h-screen bg-white")>
        <div className=%twc("w-full max-w-3xl mx-auto bg-white min-h-screen")>
          <PLP_Header_Buyer key=router.asPath />
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

module Container = {
  @react.component
  let make = (~deviceType, ~sort, ~gnbBanners, ~displayCategories) => {
    // 채널톡 버튼 사용
    ChannelTalkHelper.Hook.use()

    let variables = Query.makeVariables(~sort, ~count=20, ~onlyBuyable=true, ())
    let {fragmentRefs} = Query.use(~variables, ~fetchPolicy=RescriptRelay.StoreOrNetwork, ())

    switch deviceType {
    | DeviceDetect.Unknown => React.null
    | DeviceDetect.PC => <PC query=fragmentRefs gnbBanners displayCategories />
    | DeviceDetect.Mobile => <MO query=fragmentRefs />
    }
  }
}

@react.component
let make = (~deviceType, ~gnbBanners, ~displayCategories) => {
  let router = Next.Router.useRouter()
  let sort = {
    router.query
    ->Js.Dict.get("sort")
    ->Option.flatMap(ShopProductsSortSelect_Buyer.decodeSort)
    ->Option.getWithDefault(#UPDATED_DESC)
  }

  React.useEffect0(_ => {
    Global.Window.ReactNativeWebView.PostMessage.airbridgeWithPayload(
      ~kind=#VIEW_PRODUCT_LIST,
      ~payload={"action": `전체 상품`},
      (),
    )
    None
  })

  <RescriptReactErrorBoundary
    fallback={_ => <Placeholder deviceType gnbBanners displayCategories />}>
    <React.Suspense fallback={<Placeholder deviceType gnbBanners displayCategories />}>
      <Container deviceType sort gnbBanners displayCategories />
    </React.Suspense>
  </RescriptReactErrorBoundary>
}
