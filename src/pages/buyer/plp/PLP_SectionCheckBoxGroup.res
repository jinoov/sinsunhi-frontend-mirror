module PC = {
  @react.component
  let make = () => {
    let router = Next.Router.useRouter()

    let sectionType = router.query->Js.Dict.get("section-type")->PLP_FilterOption.Section.make

    let (matchingSelected, deliverySelected) =
      sectionType->PLP_FilterOption.Section.toCheckBoxSelection

    let onCheckBoxUpdate = (matching, delivery) => {
      ReactEvents.interceptingHandler(_ => {
        let sectionType = PLP_FilterOption.Section.fromCheckBoxSelection(matching, delivery)

        let sortType =
          router.query
          ->Js.Dict.get("sort")
          ->Option.getWithDefault("")
          ->(sort => PLP_FilterOption.Sort.decodeSort(sectionType, sort))

        let newQuery = router.query
        newQuery->Js.Dict.set("section-type", sectionType->PLP_FilterOption.Section.toString)
        newQuery->Js.Dict.set("sort", sortType->PLP_FilterOption.Sort.encodeSort)

        router->Next.Router.replaceObj({
          pathname: router.pathname,
          query: newQuery,
        })
      })
    }

    <div className=%twc("flex-row inline-flex gap-5")>
      <div className=%twc("inline-flex items-center gap-2")>
        <Checkbox
          id="matching-checkbox"
          name="matching"
          checked=matchingSelected
          onChange={onCheckBoxUpdate(!matchingSelected, deliverySelected)}
        />
        {`신선매칭`->React.string}
      </div>
      <div className=%twc("inline-flex items-center gap-2")>
        <Checkbox
          id="delivery-checkbox"
          name="delivery"
          checked=deliverySelected
          onChange={onCheckBoxUpdate(matchingSelected, !deliverySelected)}
        />
        {`신선배송`->React.string}
      </div>
    </div>
  }
}

module MO = {
  @react.component
  let make = () => {
    let router = Next.Router.useRouter()

    let sectionType = router.query->Js.Dict.get("section-type")->PLP_FilterOption.Section.make

    let (matchingSelected, deliverySelected) =
      sectionType->PLP_FilterOption.Section.toCheckBoxSelection

    let onCheckBoxUpdate = (matching, delivery) => {
      ReactEvents.interceptingHandler(_ => {
        let sectionType = PLP_FilterOption.Section.fromCheckBoxSelection(matching, delivery)

        let sortType =
          router.query
          ->Js.Dict.get("sort")
          ->Option.getWithDefault("")
          ->(sort => PLP_FilterOption.Sort.decodeSort(sectionType, sort))

        let newQuery = router.query
        newQuery->Js.Dict.set("section-type", sectionType->PLP_FilterOption.Section.toString)
        newQuery->Js.Dict.set("sort", sortType->PLP_FilterOption.Sort.encodeSort)

        router->Next.Router.replaceObj({
          pathname: router.pathname,
          query: newQuery,
        })
      })
    }

    <div className=%twc("flex-row inline-flex gap-5 text-sm")>
      <div className=%twc("inline-flex items-center gap-2")>
        <Checkbox
          id="matching-checkbox"
          name="matching"
          checked=matchingSelected
          onChange={onCheckBoxUpdate(!matchingSelected, deliverySelected)}
        />
        {`신선매칭`->React.string}
      </div>
      <div className=%twc("inline-flex items-center gap-2")>
        <Checkbox
          id="delivery-checkbox"
          name="delivery"
          checked=deliverySelected
          onChange={onCheckBoxUpdate(matchingSelected, !deliverySelected)}
        />
        {`신선배송`->React.string}
      </div>
    </div>
  }
}
