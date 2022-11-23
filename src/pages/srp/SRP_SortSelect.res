/*
 *
 * 1. 위치:  바이어센터 매장 검색결과 상단 정렬기준
 *          바이어센터 매장 전시카테고리 상품 리스트 상단 정렬기준
 *
 * 2. 역할: 상품리스트의 정렬기준을 선택할 수 있다
 *
 */

@module("../../../public/assets/arrow-gray800-up-down.svg")
external arrowUpDownIcon: string = "default"

module SortSelectDropDownItem = {
  @react.component
  let make = (~sortOption, ~itemWidth, ~makeOnSelect) => {
    open RadixUI.DropDown

    <Item
      onSelect={sortOption->makeOnSelect}
      className={Cn.make([
        itemWidth,
        %twc("p-2 focus:outline-none text-gray-800 hover:bg-gray-100 rounded-lg"),
      ])}>
      {sortOption->Product_FilterOption.Sort.toSortLabel->React.string}
    </Item>
  }
}
module PC = {
  @react.component
  let make = () => {
    let router = Next.Router.useRouter()

    let sectionType =
      router.query->Js.Dict.get("section")->Product_FilterOption.Section.fromUrlParameter

    let sort =
      sectionType
      ->Option.flatMap(sectionType' =>
        sectionType'->Product_FilterOption.Sort.makeSearch(router.query->Js.Dict.get("sort"))
      )
      ->Option.getWithDefault(Product_FilterOption.Sort.searchDefaultValue)

    let label = sort->Product_FilterOption.Sort.toSortLabel

    let itemWidth = switch sectionType {
    | Some(#MATCHING) => %twc("w-[140px]")
    | _ => %twc("w-[120px]")
    }

    let (_open, setOpen) = React.Uncurried.useState(_ => false)

    let makeOnSelect = sort => {
      ReactEvents.interceptingHandler(_ => {
        setOpen(._ => false)
        let newQuery = router.query

        newQuery->Js.Dict.set("sort", sort->Product_FilterOption.Sort.toString)

        router->Next.Router.replaceObj({
          pathname: router.pathname,
          query: newQuery,
        })
      })
    }

    open RadixUI.DropDown
    <div className=%twc("flex items-center")>
      <span className=%twc("text-gray-600 text-sm")> {`정렬기준: `->React.string} </span>
      <Root _open onOpenChange={to_ => setOpen(._ => to_)}>
        <Trigger className=%twc("focus:outline-none")>
          <div className=%twc("ml-2 flex items-center justify-center")>
            <span className=%twc("text-sm mr-1 text-gray-800")> {label->React.string} </span>
            <img src=arrowUpDownIcon />
          </div>
        </Trigger>
        <Content
          align=#start
          className=%twc(
            "dropdown-content bg-white shadow-lg p-1 border border-[#cccccc] rounded-lg cursor-pointer"
          )>
          <SortSelectDropDownItem sortOption=#RELEVANCE_DESC itemWidth makeOnSelect />
          <SortSelectDropDownItem sortOption=#POPULARITY_DESC itemWidth makeOnSelect />
          <SortSelectDropDownItem sortOption=#UPDATED_DESC itemWidth makeOnSelect />
          <SortSelectDropDownItem
            sortOption={switch sectionType {
            | Some(#MATCHING) => #PRICE_PER_KG_ASC
            | _ => #PRICE_ASC
            }}
            itemWidth
            makeOnSelect
          />
        </Content>
      </Root>
    </div>
  }
}

module MO = {
  @react.component
  let make = () => {
    let router = Next.Router.useRouter()

    let sectionType =
      router.query->Js.Dict.get("section")->Product_FilterOption.Section.fromUrlParameter

    let sort =
      sectionType
      ->Option.flatMap(sectionType' =>
        sectionType'->Product_FilterOption.Sort.makeSearch(router.query->Js.Dict.get("sort"))
      )
      ->Option.getWithDefault(Product_FilterOption.Sort.searchDefaultValue)

    let label = sort->Product_FilterOption.Sort.toSortLabel

    let itemWidth = switch sectionType {
    | Some(#MATCHING) => %twc("w-[140px]")
    | _ => %twc("w-[120px]")
    }

    let (_open, setOpen) = React.Uncurried.useState(_ => false)

    let makeOnSelect = sort => {
      ReactEvents.interceptingHandler(_ => {
        setOpen(._ => false)
        let newQuery = router.query

        newQuery->Js.Dict.set("sort", sort->Product_FilterOption.Sort.toString)

        router->Next.Router.replaceObj({
          pathname: router.pathname,
          query: newQuery,
        })
      })
    }

    open RadixUI.DropDown
    <div className=%twc("flex items-center")>
      <Root _open onOpenChange={to_ => setOpen(._ => to_)}>
        <Trigger className=%twc("focus:outline-none")>
          <div className=%twc("ml-2 flex items-center justify-center")>
            <span className=%twc("text-sm mr-1 text-gray-800")> {label->React.string} </span>
            <img src=arrowUpDownIcon />
          </div>
        </Trigger>
        <Content
          align=#start
          className=%twc(
            "dropdown-content bg-white shadow-lg p-1 border border-[#cccccc] rounded-lg cursor-pointer"
          )>
          <SortSelectDropDownItem sortOption=#RELEVANCE_DESC itemWidth makeOnSelect />
          <SortSelectDropDownItem sortOption=#POPULARITY_DESC itemWidth makeOnSelect />
          <SortSelectDropDownItem sortOption=#UPDATED_DESC itemWidth makeOnSelect />
          <SortSelectDropDownItem
            sortOption={switch sectionType {
            | Some(#MATCHING) => #PRICE_PER_KG_ASC
            | _ => #PRICE_ASC
            }}
            itemWidth
            makeOnSelect
          />
        </Content>
      </Root>
    </div>
  }
}
