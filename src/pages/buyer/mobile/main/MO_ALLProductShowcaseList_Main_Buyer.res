/*
 * 1. 컴포넌트 위치
 *    바이어 메인 - 카테고리 기획전 리스트
 *
 * 2. 역할
 *    전체 상품중 TOP10을 소개합니다. 그에 속한 상품 리스트를 표현합니다.
 */

module Placeholder = {
  @react.component
  let make = () => {
    <div>
      <section key={`showcase-skeleton-top10`} className=%twc("w-full px-5 mt-12")>
        <div className=%twc("w-full")>
          <div className=%twc("w-[107px] h-[26px] animate-pulse bg-gray-150 rounded-lg") />
          <ol className=%twc("mt-4 grid grid-cols-2 gap-x-4 gap-y-8")>
            {Array.range(1, 6)
            ->Array.map(idx => {
              <ShopProductListItem_Buyer.MO.Placeholder
                key={`category-top10-product-skeleton-${idx->Int.toString}`}
              />
            })
            ->React.array}
          </ol>
        </div>
      </section>
    </div>
  }
}

module Query = %relay(`
    query MOALLProductShowcaseListMainBuyerQuery( $first:Int!) {
        products(
            first: $first
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
 `)

@react.component
let make = () => {
  let variables = Query.makeVariables(~first=10)
  let {products} = Query.use(~variables, ())

  <section key={`main-top10-mobile`} className=%twc("w-full px-5 mt-12")>
    <div className=%twc("w-full")>
      <h2 className=%twc("text-[19px] font-bold text-[#1F2024]")>
        {`이달의 상품`->React.string}
      </h2>
      <ol className=%twc("mt-4 grid grid-cols-2 gap-x-4 gap-y-8")>
        {products.edges
        ->Array.map(({cursor, node: {fragmentRefs}}) => {
          <React.Suspense
            key={`main-special-category-top10-list-item-${cursor}-mobile`}
            fallback={<ShopProductListItem_Buyer.MO.Placeholder />}>
            <ShopProductListItem_Buyer.MO query=fragmentRefs />
          </React.Suspense>
        })
        ->React.array}
      </ol>
    </div>
  </section>
}
