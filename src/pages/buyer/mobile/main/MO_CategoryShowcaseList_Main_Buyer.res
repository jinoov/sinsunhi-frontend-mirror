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
        <section
          key={`showcase-skeleton-${categoryIdx->Int.toString}`}
          className=%twc("w-full px-5 mt-12")>
          <div className=%twc("w-full")>
            <div className=%twc("w-[107px] h-[26px] animate-pulse bg-gray-150 rounded-lg") />
            <ol className=%twc("mt-4 grid grid-cols-2 gap-x-4 gap-y-8")>
              {Array.range(1, 6)
              ->Array.map(idx => {
                <ShopProductListItem_Buyer.MO.Placeholder
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
    query MOCategoryShowcaseListMainBuyerQuery($after:ID, $first:Int!) {
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
    <section key={`main-special-category-${id}-mobile`} className=%twc("w-full px-5 mt-12")>
      <div className=%twc("w-full")>
        <h2 className=%twc("text-[19px] font-bold text-[#1F2024]")>
          {`${name} BEST`->React.string}
        </h2>
        <ol className=%twc("mt-4 grid grid-cols-2 gap-x-4 gap-y-8")>
          {products.edges
          ->Array.map(({cursor, node: {fragmentRefs}}) => {
            <React.Suspense
              key={`main-special-category-${id}-list-item-${cursor}-mobile`}
              fallback={<ShopProductListItem_Buyer.MO.Placeholder />}>
              <ShopProductListItem_Buyer.MO query=fragmentRefs />
            </React.Suspense>
          })
          ->React.array}
        </ol>
        // {switch products.pageInfo.hasNextPage {
        // | false => React.null

        // | true =>
        //   <div className=%twc("mt-8 flex items-center justify-center")>
        //     <button
        //       onClick={ReactEvents.interceptingHandler(_ => {
        //         router->push(
        //           `/categories/${id}?${Product_FilterOption.defaultFilterOptionUrlParam}`,
        //         )
        //       })}
        //       className=%twc(
        //         "px-[18px] py-[10px] bg-gray-100 rounded-full text-sm flex items-center"
        //       )>
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
