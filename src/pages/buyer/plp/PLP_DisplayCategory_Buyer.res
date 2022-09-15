module Query = %relay(`
  query PLPDisplayCategoryBuyerQuery(
    $displayCategoryId: ID!
    $cursor: ID
    $count: Int!
    $sort: DisplayCategoryProductsSort
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
    productType: { type: "[ProductType!]" }
  ) {
    name
    type_: type
    products(
      after: $cursor
      first: $count
      sort: $sort
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

module PC = {
  @react.component
  let make = (~query, ~displayCategoryId, ~gnbBanners, ~displayCategories) => {
    let router = Next.Router.useRouter()

    let {data: {type_, products, name}, hasNext, loadNext} = query->Fragment.usePagination

    let loadMoreRef = Js.Nullable.null->React.useRef

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

    React.useEffect0(_ => {
      Global.Window.ReactNativeWebView.PostMessage.airbridgeWithPayload(
        ~kind=#VIEW_PRODUCT_LIST,
        ~payload={"listID": displayCategoryId, "action": name},
        (),
      )

      None
    })

    <div className=%twc("w-full min-w-[1280px] min-h-screen")>
      <Header_Buyer.PC key=router.asPath gnbBanners displayCategories />
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
                <PLP_SectionCheckBoxGroup.PC />
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
                <PLP_SectionCheckBoxGroup.PC />
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
              <PLP_SectionCheckBoxGroup.MO />
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
                <PLP_SectionCheckBoxGroup.MO />
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
  let make = (~deviceType, ~gnbBanners, ~displayCategories) => {
    let router = Next.Router.useRouter()

    switch deviceType {
    | DeviceDetect.Unknown => React.null

    | DeviceDetect.PC =>
      <div className=%twc("w-full min-w-[1280px] min-h-screen")>
        <Header_Buyer.PC key=router.asPath gnbBanners displayCategories />
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
  let make = (~deviceType, ~gnbBanners, ~displayCategories) => {
    let router = Next.Router.useRouter()
    switch deviceType {
    | DeviceDetect.Unknown => React.null

    | DeviceDetect.PC =>
      <div className=%twc("w-full min-w-[1280px] min-h-screen")>
        <Header_Buyer.PC key=router.asPath gnbBanners displayCategories />
        <div className=%twc("pt-20 flex flex-col items-center justify-center text-gray-800")>
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
  let make = (~deviceType, ~query, ~displayCategoryId, ~gnbBanners, ~displayCategories) => {
    switch deviceType {
    | DeviceDetect.Unknown => React.null
    | DeviceDetect.PC => <PC query displayCategoryId gnbBanners displayCategories />
    | DeviceDetect.Mobile => <MO query displayCategoryId />
    }
  }
}

module Container = {
  @react.component
  let make = (~deviceType, ~displayCategoryId, ~sort, ~gnbBanners, ~displayCategories) => {
    // 채널톡 버튼 사용
    ChannelTalkHelper.Hook.use()

    let router = Next.Router.useRouter()
    let productType =
      router.query
      ->Js.Dict.get("section-type")
      ->PLP_FilterOption.Section.make
      ->PLP_FilterOption.Section.toQueryParam

    let variables = Query.makeVariables(
      ~displayCategoryId,
      ~sort?,
      ~count=20,
      ~onlyBuyable=true,
      ~productType,
      (),
    )
    let {node} = Query.use(~variables, ~fetchPolicy=RescriptRelay.StoreOrNetwork, ())

    switch node {
    | None => <NotFound deviceType gnbBanners displayCategories />
    | Some({fragmentRefs}) =>
      <Presenter query=fragmentRefs deviceType displayCategoryId gnbBanners displayCategories />
    }
  }
}

@react.component
let make = (~deviceType, ~displayCategoryId, ~gnbBanners, ~displayCategories) => {
  let router = Next.Router.useRouter()

  let sectionType = router.query->Js.Dict.get("section-type")->PLP_FilterOption.Section.make

  let sort =
    router.query
    ->Js.Dict.get("sort")
    ->Option.map(sort => PLP_FilterOption.Sort.decodeSort(sectionType, sort))

  <RescriptReactErrorBoundary
    fallback={_ => <Placeholder deviceType gnbBanners displayCategories />}>
    <React.Suspense fallback={<Placeholder deviceType gnbBanners displayCategories />}>
      <Container deviceType displayCategoryId sort gnbBanners displayCategories />
    </React.Suspense>
  </RescriptReactErrorBoundary>
}
