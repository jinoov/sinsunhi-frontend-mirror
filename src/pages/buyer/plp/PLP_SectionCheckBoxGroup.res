@react.component
let make = () => {
  let router = Next.Router.useRouter()

  let sectionType =
    router.query->Js.Dict.get("section")->Product_FilterOption.Section.fromUrlParameter

  let (matchingSelected, deliverySelected) = switch sectionType {
  | Some(sectionType) => sectionType->Product_FilterOption.Section.toCheckBoxSelection
  | _ => (false, false)
  }

  let onCheckBoxUpdate = (matching, delivery) => {
    ReactEvents.interceptingHandler(_ => {
      let sectionType = Product_FilterOption.Section.fromCheckBoxSelection(matching, delivery)

      let sortType =
        sectionType->Option.flatMap(sectionType' =>
          sectionType'->Product_FilterOption.Sort.make(router.query->Js.Dict.get("sort"))
        )

      let sortUrlParameter = sortType

      let sectionUrlParameter = sectionType->Option.map(Product_FilterOption.Section.toUrlParameter)

      let newQuery = switch sortUrlParameter {
      | Some(sortUrlParameter') => {
          let newQuery = router.query
          newQuery->Js.Dict.set("sort", sortUrlParameter'->Product_FilterOption.Sort.toString)
          newQuery
        }

      | None =>
        router.query->Js.Dict.entries->Array.keep(((key, _)) => key != "sort")->Js.Dict.fromArray
      }
      let newQuery = switch sectionUrlParameter {
      | Some(sectionUrlParameter') => {
          newQuery->Js.Dict.set("section", sectionUrlParameter')
          newQuery
        }

      | None =>
        router.query->Js.Dict.entries->Array.keep(((key, _)) => key != "section")->Js.Dict.fromArray
      }
      router->Next.Router.replaceObj({
        pathname: router.pathname,
        query: newQuery,
      })
    })
  }

  <div className=%twc("flex-row inline-flex gap-5 xl:text-base")>
    <div className=%twc("inline-flex items-center gap-2")>
      <Checkbox
        id="matching-checkbox"
        name="matching"
        checked=matchingSelected
        onChange={onCheckBoxUpdate(!matchingSelected, deliverySelected)}
        alt={matchingSelected
          ? `${Product_FilterOption.Section.toLabel(#MATCHING)} 상품을 선택합니다`
          : `${Product_FilterOption.Section.toLabel(#MATCHING)} 상품을 선택해제합니다`}
      />
      {Product_FilterOption.Section.toLabel(#MATCHING)->React.string}
    </div>
    <div className=%twc("inline-flex items-center gap-2")>
      <Checkbox
        id="delivery-checkbox"
        name="delivery"
        checked=deliverySelected
        onChange={onCheckBoxUpdate(matchingSelected, !deliverySelected)}
        alt={deliverySelected
          ? `${Product_FilterOption.Section.toLabel(#DELIVERY)} 상품을 선택합니다`
          : `${Product_FilterOption.Section.toLabel(#DELIVERY)} 상품을 선택해제합니다`}
      />
      {Product_FilterOption.Section.toLabel(#DELIVERY)->React.string}
    </div>
  </div>
}
