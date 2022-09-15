/*
 *
 * 1. 위치:  바이어센터 매장 검색결과 상단 정렬기준
 *          바이어센터 매장 전시카테고리 상품 리스트 상단 정렬기준
 *
 * 2. 역할: 상품리스트의 정렬기준을 선택할 수 있다
 *
 */

@module("../../../../public/assets/arrow-gray800-up-down.svg")
external arrowUpDownIcon: string = "default"

module PC = {
  @react.component
  let make = () => {
    let router = Next.Router.useRouter()

    let sectionType = router.query->Js.Dict.get("section-type")->PLP_FilterOption.Section.make

    let label =
      router.query
      ->Js.Dict.get("sort")
      ->Option.map(PLP_FilterOption.Sort.decodeSort(sectionType))
      ->Option.getWithDefault(#UPDATED_DESC)
      ->PLP_FilterOption.Sort.makeSortLabel

    let priceOption = switch sectionType {
    | #MATCHING => #PRICE_PER_KG_ASC
    | _ => #PRICE_ASC
    }

    let itemWidth = switch sectionType {
    | #MATCHING => %twc("w-[140px]")
    | _ => %twc("w-[120px]")
    }

    let (_open, setOpen) = React.Uncurried.useState(_ => false)

    let makeOnSelect = sort => {
      ReactEvents.interceptingHandler(_ => {
        setOpen(._ => false)
        let newQuery = router.query
        newQuery->Js.Dict.set("sort", sort->PLP_FilterOption.Sort.encodeSort)

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
          <Item
            onSelect={#UPDATED_DESC->makeOnSelect}
            className={Cn.make([
              itemWidth,
              %twc("p-2 focus:outline-none text-gray-800 hover:bg-gray-100 rounded-lg"),
            ])}>
            {#UPDATED_DESC->PLP_FilterOption.Sort.makeSortLabel->React.string}
          </Item>
          <Item
            onSelect={priceOption->makeOnSelect}
            className={Cn.make([
              itemWidth,
              %twc(" p-2 focus:outline-none text-gray-800 hover:bg-gray-100 rounded-lg"),
            ])}>
            {priceOption->PLP_FilterOption.Sort.makeSortLabel->React.string}
          </Item>
        </Content>
      </Root>
    </div>
  }
}

module MO = {
  @react.component
  let make = () => {
    let router = Next.Router.useRouter()

    let sectionType = router.query->Js.Dict.get("section-type")->PLP_FilterOption.Section.make

    let label =
      router.query
      ->Js.Dict.get("sort")
      ->Option.map(PLP_FilterOption.Sort.decodeSort(sectionType))
      ->Option.getWithDefault(#UPDATED_DESC)
      ->PLP_FilterOption.Sort.makeSortLabel

    let (_open, setOpen) = React.Uncurried.useState(_ => false)

    let priceOption = switch sectionType {
    | #MATCHING => #PRICE_PER_KG_ASC
    | _ => #PRICE_ASC
    }

    let itemWidth = switch sectionType {
    | #MATCHING => %twc("w-[140px]")
    | _ => %twc("w-[120px]")
    }

    let makeOnSelect = sort => {
      ReactEvents.interceptingHandler(_ => {
        setOpen(._ => false)
        let newQuery = router.query
        newQuery->Js.Dict.set("sort", sort->PLP_FilterOption.Sort.encodeSort)

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
          <Item
            onSelect={#UPDATED_DESC->makeOnSelect}
            className={Cn.make([
              itemWidth,
              %twc("p-2 focus:outline-none text-gray-800 hover:bg-gray-100 rounded-lg"),
            ])}>
            {#UPDATED_DESC->PLP_FilterOption.Sort.makeSortLabel->React.string}
          </Item>
          <Item
            onSelect={priceOption->makeOnSelect}
            className={Cn.make([
              itemWidth,
              %twc("p-2 focus:outline-none text-gray-800 hover:bg-gray-100 rounded-lg"),
            ])}>
            {priceOption->PLP_FilterOption.Sort.makeSortLabel->React.string}
          </Item>
        </Content>
      </Root>
    </div>
  }
}
