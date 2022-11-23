//코드 스플리팅으로 결정하게 되면 본 컴포넌트를 삭제해도 좋을 것 같습니다.
module Item = {
  @react.component
  let make = (~section, ~isSelected) => {
    let router = Next.Router.useRouter()
    let onTabClickHandler = section => {
      let newRouteQueryParam = router.query

      let sectionUrlParam = section->Product_FilterOption.Section.toUrlParameter
      newRouteQueryParam->Js.Dict.set("section", sectionUrlParam)

      router->Next.Router.replaceObj({pathname: router.pathname, query: newRouteQueryParam})
    }

    <button
      type_="button"
      onClick={_ => onTabClickHandler(section)}
      className={Cn.make([
        isSelected ? %twc("text-gray-800") : %twc("text-gray-400"),
        %twc("flex justify-center items-center h-full flex-1 xl:flex-initial"),
      ])}>
      <div className=%twc("flex flex-col w-full h-full justify-center items-center px-5 xl:px-0")>
        <div
          className=%twc(
            "inline-flex flex-1 items-center justify-center font-bold xl:px-[10px] xl:py-3"
          )>
          {section->Product_FilterOption.Section.toLabel->React.string}
        </div>
        <div
          className={Cn.make([
            isSelected ? %twc("bg-gray-800") : %twc("bg-transparent"),
            %twc("h-[2px] w-full rounded xl:-mt-[3px]"),
          ])}
        />
      </div>
    </button>
  }
}

@react.component
let make = (~currentSection) => {
  <div
    className=%twc(
      "flex flex-row  border-b-[1px] border-gray-100 gap-[10px] h-12 mt-0.5 xl:mt-0 xl:justify-start xl:h-auto"
    )>
    <Item section=#ALL isSelected={currentSection == #ALL} />
    <Item section=#DELIVERY isSelected={currentSection == #DELIVERY} />
    <Item section=#MATCHING isSelected={currentSection == #MATCHING} />
  </div>
}
