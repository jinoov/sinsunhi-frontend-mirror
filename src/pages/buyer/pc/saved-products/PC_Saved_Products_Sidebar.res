module Skeleton = {
  @react.component
  let make = () => {
    <PC_Sidebar>
      <div />
    </PC_Sidebar>
  }
}

@react.component
let make = () => {
  let router = Next.Router.useRouter()

  let isSelected = subPage => {
    let isInterestedProducts = router.pathname == "/saved-products"

    let isCurrentSubPage =
      router.query
      ->Js.Dict.get("selected")
      ->Option.map(selectedSubPage => selectedSubPage == subPage)
      ->Option.getWithDefault(false)

    isInterestedProducts && isCurrentSubPage
  }

  <PC_Sidebar>
    <PC_Sidebar.Item.Route
      displayName="찜한 상품"
      pathObj={
        pathname: `/saved-products`,
        query: [("selected", "like"), ("mode", "VIEW")]->Js.Dict.fromArray,
      }
      routeFn=#push
      selected={isSelected("like")}
    />
    <PC_Sidebar.Item.Route
      displayName="최근 본 상품"
      pathObj={
        pathname: `/saved-products`,
        query: [("selected", "recent"), ("mode", "VIEW")]->Js.Dict.fromArray,
      }
      routeFn=#push
      selected={isSelected("recent")}
    />
  </PC_Sidebar>
}
