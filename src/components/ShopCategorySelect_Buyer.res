/*
 *
 * 1. 위치: 바이어센터 메인 상단 전체 카테고리
 *
 * 2. 역할: 전시 카테고리 리스트를 Cascader 형태로 표현한다
 *
 */

module Query = %relay(`
  query ShopCategorySelectBuyerQuery(
    $types: [DisplayCategoryType!]
    $onlyDisplayable: Boolean
  ) {
    rootDisplayCategories(types: $types, onlyDisplayable: $onlyDisplayable) {
      id
      name
      children {
        id
        name
      }
    }
  }
`)

module Sub = {
  @react.component
  let make = (
    ~displayCategories: array<
      ShopCategorySelectBuyerQuery_graphql.Types.response_rootDisplayCategories_children,
    >,
  ) => {
    let {push, useRouter} = module(Next.Router)
    let router = useRouter()

    switch displayCategories {
    | [] => React.null
    | _ =>
      <>
        <div className=%twc("w-[222px] px-8 py-5 flex flex-col")>
          {displayCategories
          ->Array.map(({id, name}) => {
            <Hoverable key=id className=%twc("mt-3")>
              <div
                onClick={ReactEvents.interceptingHandler(_ => {
                  router->push(
                    `/categories/${id}?${Product_FilterOption.defaultFilterOptionUrlParam}`,
                  )
                })}
                className=%twc(
                  "w-full flex items-center justify-between group cursor-pointer group"
                )>
                <span
                  className=%twc(
                    "text-[15px] text-gray-800 group-hover:text-green-600 group-hover:font-bold"
                  )>
                  {name->React.string}
                </span>
                <span className=%twc("w-4 h-4")>
                  <IconArrow
                    className=%twc("hidden group-hover:block")
                    width="16"
                    height="16"
                    stroke="#12B564"
                  />
                </span>
              </div>
            </Hoverable>
          })
          ->React.array}
        </div>
      </>
    }
  }
}

@react.component
let make = () => {
  let {rootDisplayCategories} = Query.use(
    ~variables={onlyDisplayable: Some(true), types: Some([#NORMAL])},
    (),
  )

  let {push, useRouter} = module(Next.Router)
  let router = useRouter()

  let (isHovered, setIsHovered) = React.Uncurried.useState(_ => false)
  let (hoveredId, setHoveredId) = React.Uncurried.useState((_): option<string> => None)

  let triggerStyle = %twc("flex items-center w-56 h-[54px] px-7 whitespace-nowrap ")
  let textStyle = %twc("mx-2 text-lg font-bold ")

  let makeHoverChange = (~id, ~children, _) => {
    switch children {
    | [] => setHoveredId(._ => None)
    | _ => setHoveredId(._ => Some(id))
    }
  }

  <div>
    <Hoverable onHoverChange={to_ => setIsHovered(._ => to_)}>
      {switch isHovered {
      | false =>
        <div className={triggerStyle ++ %twc("border-t border-x border-transparent")}>
          <IconHamburger width="24" height="24" fill="#12B564" />
          <span className={textStyle ++ %twc("text-text-L1")}>
            {`전체 카테고리`->React.string}
          </span>
          <IconArrow className=%twc("rotate-90") fill="#B2B2B2" width="20" height="20" />
        </div>
      | true =>
        <>
          <div className={triggerStyle ++ %twc("border-t border-x border-primary")}>
            <IconHamburger width="24" height="24" fill="#12B564" />
            <span className={textStyle ++ %twc("text-primary")}>
              {`전체 카테고리`->React.string}
            </span>
            <IconArrow className=%twc("-rotate-90") fill="#12B564" width="20" height="20" />
          </div>
          <div className=%twc("relative")>
            <div
              className=%twc(
                "h-[434px] bg-white absolute top-0 border border-green-500 flex divide-x"
              )>
              <div className=%twc("w-[222px] px-8 py-5 flex flex-col")>
                <Hoverable
                  className=%twc("mt-3")
                  onHoverChange={makeHoverChange(~id="buyer-products", ~children=[])}>
                  <Next.Link href="/products">
                    <a
                      className=%twc(
                        "w-full flex items-center justify-between group cursor-pointer group"
                      )>
                      <span
                        className=%twc(
                          "text-[15px] text-gray-800 group-hover:text-green-600 group-hover:font-bold"
                        )>
                        {`전체 상품`->React.string}
                      </span>
                      <span className=%twc("w-4 h-4")>
                        <IconArrow
                          className=%twc("hidden group-hover:block")
                          width="16"
                          height="16"
                          stroke="#12B564"
                        />
                      </span>
                    </a>
                  </Next.Link>
                </Hoverable>
                {rootDisplayCategories
                ->Array.map(({id, name, children}) => {
                  <Hoverable
                    key=id className=%twc("mt-3") onHoverChange={makeHoverChange(~id, ~children)}>
                    <div
                      onClick={ReactEvents.interceptingHandler(_ => {
                        router->push(
                          `/categories/${id}?${Product_FilterOption.defaultFilterOptionUrlParam}`,
                        )
                      })}
                      className=%twc(
                        "w-full flex items-center justify-between group cursor-pointer group"
                      )>
                      <span
                        className=%twc(
                          "text-[15px] text-gray-800 group-hover:text-green-600 group-hover:font-bold"
                        )>
                        {name->React.string}
                      </span>
                      <span className=%twc("w-4 h-4")>
                        <IconArrow
                          className=%twc("hidden group-hover:block")
                          width="16"
                          height="16"
                          stroke="#12B564"
                        />
                      </span>
                    </div>
                  </Hoverable>
                })
                ->React.array}
              </div>
              {hoveredId->Option.mapWithDefault(React.null, hoveredId' => {
                <Sub
                  key=hoveredId'
                  displayCategories={rootDisplayCategories
                  ->Array.keep(displayCategory => displayCategory.id == hoveredId')
                  ->Garter.Array.first
                  ->Option.mapWithDefault([], displayCategory => displayCategory.children)}
                />
              })}
            </div>
            <div className=%twc("w-[222px] bg-white absolute top-0 left-[1px] h-1") />
          </div>
        </>
      }}
    </Hoverable>
  </div>
}
