module Query = %relay(`
  query MatchingPLPGetCategoryNameQuery($displayCategoryId: ID!) {
    node(id: $displayCategoryId) {
      ... on DisplayCategory {
        name
      }
    }
  }
`)

module PC = {
  module View = {
    @react.component
    let make = (~categoryName, ~subCategoryName) => {
      <>
        <SectionMain_PC_Title title={`신선매칭`} />
        <Matching_PLP_Category.PC categoryName />
        <Matching_PLP_ProductList.PC subCategoryName />
      </>
    }
  }
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
  @react.component
  let make = () => {
    let router = Next.Router.useRouter()
    let categoryId = router.query->Js.Dict.get("category-id")->Option.getWithDefault("")
    let subCategoryId = router.query->Js.Dict.get("sub-category-id")->Option.getWithDefault("")
    let categoryName =
      Query.use(
        ~variables={displayCategoryId: categoryId},
        (),
      ).node->Option.mapWithDefault(`전체 상품`, node => `${node.name} 전체`)

    let subCategoryName =
      Query.use(
        ~variables={displayCategoryId: subCategoryId},
        (),
      ).node->Option.mapWithDefault(categoryName, node => node.name)
    <View categoryName subCategoryName />
  }
}

module MO = {
  module View = {
    @react.component
    let make = (~categoryName, ~subCategoryName) => {
      <>
        <Matching_PLP_Category.MO categoryName /> <Matching_PLP_ProductList.MO subCategoryName />
      </>
    }
  }
  module Skeleton = {
    @react.component
    let make = () => {
      <div className=%twc("w-full")>
        <Matching_PLP_Category.MO.Skeleton />
        <ol className=%twc("grid grid-cols-2 gap-x-4 gap-y-8  px-5")>
          {Array.range(1, 100)
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
  @react.component
  let make = () => {
    let router = Next.Router.useRouter()
    let categoryId = router.query->Js.Dict.get("category-id")->Option.getWithDefault("")
    let subCategoryId = router.query->Js.Dict.get("sub-category-id")->Option.getWithDefault("")
    let categoryName =
      Query.use(
        ~variables={displayCategoryId: categoryId},
        (),
      ).node->Option.mapWithDefault(`전체 상품`, node => `${node.name} 전체`)

    let subCategoryName =
      Query.use(
        ~variables={displayCategoryId: subCategoryId},
        (),
      ).node->Option.mapWithDefault(categoryName, node => node.name)
    <View categoryName subCategoryName />
  }
}

module Skeleton = {
  @react.component
  let make = (~deviceType) => {
    switch deviceType {
    | DeviceDetect.Mobile => <MO.Skeleton />
    | DeviceDetect.PC => <PC.Skeleton />
    | DeviceDetect.Unknown => React.null
    }
  }
}

module Container = {
  @react.component
  let make = (~deviceType) => {
    ChannelTalkHelper.Hook.use()
    switch deviceType {
    | DeviceDetect.Mobile => <MO />
    | DeviceDetect.PC => <PC />
    | DeviceDetect.Unknown => React.null
    }
  }
}

@react.component
let make = (~deviceType) => {
  let (isCsr, setIsCsr) = React.Uncurried.useState(_ => false)

  React.useEffect0(() => {
    setIsCsr(._ => true)
    None
  })
  <>
    <Next.Head> <title> {`신선하이 신선매칭`->React.string} </title> </Next.Head>
    <RescriptReactErrorBoundary fallback={_ => <Skeleton deviceType />}>
      <React.Suspense fallback={<Skeleton deviceType />}>
        {switch isCsr {
        | true => <Container deviceType />
        | false => <Skeleton deviceType />
        }}
      </React.Suspense>
    </RescriptReactErrorBoundary>
  </>
}
