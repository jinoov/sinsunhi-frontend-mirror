/*
 * 1. 컴포넌트 위치
 *    바이어 메인 - 카테고리 기획전 리스트
 *
 * 2. 역할
 *    특정 카테고리 리스트와 그에 속한 상품 리스트를 표현합니다.
 */

module Placeholder = {
  @react.component
  let make = () => {
    <div>
      {Array.range(1, 5)
      ->Array.map(categoryIdx => {
        let containerStyle =
          categoryIdx == 1 ? %twc("w-full bg-[#F9F9F9] py-16") : %twc("w-full bg-white py-16")

        <section key={`showcase-skeleton-${categoryIdx->Int.toString}`} className=containerStyle>
          <div className=%twc("w-[1280px] mx-auto px-5")>
            <div className=%twc("w-[155px] h-[38px] animate-pulse bg-gray-150 rounded-lg") />
            <ol className=%twc("mt-12 grid grid-cols-5 gap-x-10 gap-y-16")>
              {Array.range(1, 10)
              ->Array.map(idx => {
                <ShopProductListItem_Buyer.PC.Placeholder
                  key={`category-${categoryIdx->Int.toString}-product-skeleton-${idx->Int.toString}`}
                />
              })
              ->React.array}
            </ol>
          </div>
        </section>
      })
      ->React.array}
    </div>
  }
}

module Query = %relay(`
    query PCCategoryShowcaseListMainBuyerQuery($after:ID, $first:Int!) {
        mainDisplayCategories(onlyDisplayable: true) {
            id
            name
            products(
                first: $first
                after: $after
                orderBy:[
                    {field: STATUS_PRIORITY, direction: ASC},
                    {field: POPULARITY, direction: DESC},
                ]
                onlyBuyable: true
                type:[NORMAL, QUOTABLE]
            ) {
                pageInfo {
                    hasNextPage
                }
                edges {
                    cursor
                    node {
                        ...ShopProductListItemBuyerFragment
                    }
                }
            }
        }
    }
 `)

@react.component
let make = () => {
  let displayCategories = ["과일", "채소", "축산물", "수산물", "가공식품"]

  let variables = Query.makeVariables(~first=10, ())
  let {mainDisplayCategories} = Query.use(~variables, ())

  mainDisplayCategories
  ->Array.keep(({name}) => Js.Array2.includes(displayCategories, name))
  ->Array.keep(({products}) => !(products.edges->Garter.Array.isEmpty))
  ->Array.map(({id, name, products}) => {
    <section
      key={`main-special-category-${id}-pc`}
      className=%twc(
        "mt-4 text-gray-800 w-[1280px] mx-auto rounded-sm bg-white shadow-[0px_10px_40px_10px_rgba(0,0,0,0.03)] py-14 last-of-type:mb-[144px]"
      )>
      <div className=%twc("w-[1280px] mx-auto px-[50px]")>
        <h2 className=%twc("text-[26px] font-bold")> {`${name} BEST`->React.string} </h2>
        <ol className=%twc("mt-12 grid grid-cols-5 gap-x-4 gap-y-16 mx-auto")>
          {products.edges
          ->Array.map(({cursor, node: {fragmentRefs}}) => {
            <React.Suspense
              key={`main-special-category-${id}-list-item-${cursor}-pc`}
              fallback={<ShopProductListItem_Buyer.PC.Placeholder />}>
              <ShopProductListItem_Buyer.PC query=fragmentRefs />
            </React.Suspense>
          })
          ->React.array}
        </ol>
        // {switch products.pageInfo.hasNextPage {
        // | false => React.null

        // | true =>
        //   <div className=%twc("mt-12 flex items-center justify-center")>
        //     <button
        //       onClick={ReactEvents.interceptingHandler(_ => {
        //         router->push(
        //           `/categories/${id}?${Product_FilterOption.defaultFilterOptionUrlParam}`,
        //         )
        //       })}
        //       className=%twc("px-6 py-3 bg-gray-100 rounded-full text-sm flex items-center")>
        //       {`전체보기`->React.string}
        //       <IconArrow className=%twc("ml-1") width="16" height="16" stroke="#262626" />
        //     </button>
        //   </div>
        // }}
      </div>
    </section>
  })
  ->React.array
}
