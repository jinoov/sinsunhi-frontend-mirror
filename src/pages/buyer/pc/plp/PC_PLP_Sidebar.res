module Query = %relay(`
  query PCPLPSidebarQuery($onlyDisplayable: Boolean!) {
    mainDisplayCategories(onlyDisplayable: $onlyDisplayable) {
      id
      name
    }
  }
`)

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
  let {mainDisplayCategories} = Query.use(~variables={onlyDisplayable: true}, ())

  let router = Next.Router.useRouter()

  let isSelected = id => {
    router.query->Js.Dict.get("cid")->Option.map(cid => cid == id)->Option.getWithDefault(false)
  }

  let targetSection =
    router.query
    ->Js.Dict.get("section")
    ->Product_FilterOption.Section.fromUrlParameter
    ->Option.mapWithDefault("", Product_FilterOption.Section.toUrlParameter)

  <PC_Sidebar>
    {mainDisplayCategories
    ->Array.map(({id, name}) =>
      <PC_Sidebar.Item.Route
        displayName=name
        pathObj={
          pathname: `/categories/${id}`,
          query: [
            ("cid", id),
            ("sort", "POPULARITY_DESC"),
            ("section", targetSection),
          ]->Js.Dict.fromArray,
        }
        routeFn=#push
        selected={isSelected(id)}
        key=id
      />
    )
    ->React.array}
  </PC_Sidebar>
}
