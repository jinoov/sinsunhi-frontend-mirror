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
    <section key={`showcase-skeleton-top10`} className=%twc("w-full bg-[#F9F9F9] py-16")>
      <div className=%twc("w-[1280px] mx-auto px-5")>
        <div className=%twc("w-[155px] h-[38px] animate-pulse bg-gray-150 rounded-lg") />
        <ol className=%twc("mt-12 grid grid-cols-4 gap-x-10 gap-y-16")>
          {Array.range(1, 8)
          ->Array.map(idx => {
            <ShopProductListItem_Buyer.PC.Placeholder
              key={`category-top10-product-skeleton-${idx->Int.toString}`}
            />
          })
          ->React.array}
        </ol>
      </div>
    </section>
  }
}

module Query = %relay(`
    query PCALLProductShowcaseListMainBuyerQuery( $first:Int!) {
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

  <section
    key={`main-special-category-top10-pc`}
    className=%twc(
      "mt-4 text-gray-800 w-[1280px] mx-auto rounded-sm bg-white shadow-[0px_10px_40px_10px_rgba(0,0,0,0.03)] py-14 last-of-type:mb-[144px]"
    )>
    <div className=%twc("w-[1280px] mx-auto px-[50px]")>
      <h2 className=%twc("text-[26px] font-bold")> {`이달의 상품`->React.string} </h2>
      <ol className=%twc("mt-12 grid grid-cols-5 gap-x-4 gap-y-16 mx-auto")>
        {products.edges
        ->Array.map(({cursor, node: {fragmentRefs}}) => {
          <React.Suspense
            key={`main-special-category-top10-list-item-${cursor}-pc`}
            fallback={<ShopProductListItem_Buyer.PC.Placeholder />}>
            <ShopProductListItem_Buyer.PC query=fragmentRefs />
          </React.Suspense>
        })
        ->React.array}
      </ol>
    </div>
  </section>
}
