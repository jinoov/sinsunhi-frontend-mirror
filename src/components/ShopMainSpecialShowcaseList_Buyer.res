/*
 * 1. 컴포넌트 위치
 *    바이어 메인 - 특별 기획전 리스트
 *
 * 2. 역할
 *    특별 기획전 리스트와 그에 속한 상품 리스트를 표현합니다.
 *
 */

module Query = %relay(`
  query ShopMainSpecialShowcaseListBuyerQuery($after: ID, $first: Int!) {
    specialDisplayCategories(onlyDisplayable: true) {
      id
      name
      products(
        first: $first
        after: $after
        orderBy: [
        {field: STATUS_PRIORITY, direction: ASC},
        {field: POPULARITY, direction: DESC},
        ]
        onlyBuyable: true
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

module PC = {
  module Placeholder = {
    @react.component
    let make = () => {
      let oldUI =
        <div>
          {Array.range(1, 10)
          ->Array.map(categoryIdx => {
            let containerStyle =
              categoryIdx == 1 ? %twc("w-full bg-[#F9F9F9] py-16") : %twc("w-full bg-white py-16")

            <section
              key={`showcase-skeleton-${categoryIdx->Int.toString}`} className=containerStyle>
              <div className=%twc("w-[1280px] mx-auto px-5")>
                <div className=%twc("w-[155px] h-[38px] animate-pulse bg-gray-150 rounded-lg") />
                <ol className=%twc("mt-12 grid grid-cols-4 gap-x-10 gap-y-16")>
                  {Array.range(1, 8)
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

      <FeatureFlagWrapper featureFlag=#HOME_UI_UX fallback=oldUI>
        <div>
          {Array.range(1, 10)
          ->Array.map(categoryIdx => {
            let containerStyle =
              categoryIdx == 1 ? %twc("w-full bg-[#F9F9F9] py-16") : %twc("w-full bg-white py-16")

            <section
              key={`showcase-skeleton-${categoryIdx->Int.toString}`} className=containerStyle>
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
      </FeatureFlagWrapper>
    }
  }

  module OldUI = {
    @react.component
    let make = () => {
      let {useRouter, push} = module(Next.Router)
      let router = useRouter()

      let variables = Query.makeVariables(~first=8, ())

      let {specialDisplayCategories} = Query.use(~variables, ())

      {
        specialDisplayCategories
        ->Array.mapWithIndex((idx, {id, name, products: {edges, pageInfo}}) => {
          let containerStyle =
            idx == 0
              ? %twc("w-full bg-[#F9F9F9] py-16 mb-[144px] text-gray-800")
              : %twc("w-full mb-[144px] bg-white text-gray-800")

          switch edges {
          | [] => React.null

          | _ =>
            <section key={`main-special-category-${id}-pc`} className=containerStyle>
              <div className=%twc("w-[1280px] mx-auto px-5")>
                <h1 className=%twc("text-2xl font-bold")> {name->React.string} </h1>
                <ol className=%twc("mt-12 grid grid-cols-4 gap-x-10 gap-y-16")>
                  {edges
                  ->Array.map(({cursor, node: {fragmentRefs}}) => {
                    <React.Suspense
                      key={`main-special-category-${id}-list-item-${cursor}-pc`}
                      fallback={<ShopProductListItem_Buyer.PC.Placeholder />}>
                      <ShopProductListItem_Buyer.PC query=fragmentRefs />
                    </React.Suspense>
                  })
                  ->React.array}
                </ol>
                {switch pageInfo.hasNextPage {
                | false => React.null

                | true =>
                  <div className=%twc("mt-12 flex items-center justify-center")>
                    <button
                      onClick={ReactEvents.interceptingHandler(_ => {
                        router->push(
                          `/categories/${id}?${Product_FilterOption.defaultFilterOptionUrlParam}`,
                        )
                      })}
                      className=%twc(
                        "px-6 py-3 bg-gray-100 rounded-full text-sm flex items-center interactable"
                      )>
                      {`전체보기`->React.string}
                      <IconArrow className=%twc("ml-1") width="16" height="16" stroke="#262626" />
                    </button>
                  </div>
                }}
              </div>
            </section>
          }
        })
        ->React.array
      }
    }
  }

  @react.component
  let make = () => {
    let {useRouter, push} = module(Next.Router)
    let router = useRouter()
    let variables = Query.makeVariables(~first=10, ())

    let {specialDisplayCategories} = Query.use(~variables, ())

    <FeatureFlagWrapper featureFlag=#HOME_UI_UX fallback={<OldUI />}>
      {specialDisplayCategories
      ->Array.map(({id, name, products: {edges, pageInfo}}) => {
        let containerStyle = %twc(
          "mt-4 text-gray-800 w-[1280px] mx-auto rounded-sm bg-white shadow-[0px_10px_40px_10px_rgba(0,0,0,0.03)] py-14 last-of-type:mb-[144px]"
        )

        switch edges {
        | [] => React.null

        | _ =>
          <section key={`main-special-category-${id}-pc`} className=containerStyle>
            <div className=%twc("w-[1280px] mx-auto px-[50px]")>
              <h1 className=%twc("text-[26px] font-bold")> {name->React.string} </h1>
              <ol className=%twc("mt-12 grid grid-cols-5 gap-x-4 gap-y-16 mx-auto")>
                {edges
                ->Array.map(({cursor, node: {fragmentRefs}}) => {
                  <React.Suspense
                    key={`main-special-category-${id}-list-item-${cursor}-pc`}
                    fallback={<ShopProductListItem_Buyer.PC.Placeholder />}>
                    <ShopProductListItem_Buyer.PC query=fragmentRefs />
                  </React.Suspense>
                })
                ->React.array}
              </ol>
              {switch pageInfo.hasNextPage {
              | false => React.null

              | true =>
                <div className=%twc("mt-8 flex items-center justify-center")>
                  <button
                    onClick={ReactEvents.interceptingHandler(_ => {
                      router->push(
                        `/categories/${id}?${Product_FilterOption.defaultFilterOptionUrlParam}`,
                      )
                    })}
                    className=%twc(
                      "px-[18px] py-[10px] bg-gray-100 rounded-full text-sm flex items-center"
                    )>
                    {`전체보기`->React.string}
                    <IconArrow className=%twc("ml-1") width="16" height="16" stroke="#262626" />
                  </button>
                </div>
              }}
            </div>
          </section>
        }
      })
      ->React.array}
    </FeatureFlagWrapper>
  }
}

module MO = {
  module Placeholder = {
    @react.component
    let make = () => {
      <div>
        {Array.range(1, 10)
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

  module OldUI = {
    @react.component
    let make = () => {
      let {useRouter, push} = module(Next.Router)
      let router = useRouter()

      let variables = Query.makeVariables(~first=8, ())

      let {specialDisplayCategories} = Query.use(~variables, ())

      specialDisplayCategories
      ->Array.map(({id, name, products: {edges, pageInfo}}) => {
        switch edges {
        | [] => React.null

        | _ =>
          <section key={`main-special-category-${id}-mobile`} className=%twc("w-full px-5 mt-12")>
            <div className=%twc("w-full")>
              <h1 className=%twc("text-lg font-bold")> {name->React.string} </h1>
              <ol className=%twc("mt-4 grid grid-cols-2 gap-x-4 gap-y-8")>
                {edges
                ->Array.map(({cursor, node: {fragmentRefs}}) => {
                  <React.Suspense
                    key={`main-special-category-${id}-list-item-${cursor}-mobile`}
                    fallback={<ShopProductListItem_Buyer.MO.Placeholder />}>
                    <ShopProductListItem_Buyer.MO query=fragmentRefs />
                  </React.Suspense>
                })
                ->React.array}
              </ol>
              {switch pageInfo.hasNextPage {
              | false => React.null

              | true =>
                <div className=%twc("mt-8 flex items-center justify-center")>
                  <button
                    onClick={ReactEvents.interceptingHandler(_ => {
                      router->push(
                        `/categories/${id}?${Product_FilterOption.defaultFilterOptionUrlParam}`,
                      )
                    })}
                    className=%twc(
                      "px-[18px] py-[10px] bg-gray-100 rounded-full text-sm flex items-center"
                    )>
                    {`전체보기`->React.string}
                    <IconArrow className=%twc("ml-1") width="16" height="16" stroke="#262626" />
                  </button>
                </div>
              }}
            </div>
          </section>
        }
      })
      ->React.array
    }
  }

  @react.component
  let make = () => {
    let {useRouter, push} = module(Next.Router)
    let router = useRouter()
    let variables = Query.makeVariables(~first=10, ())

    let {specialDisplayCategories} = Query.use(~variables, ())

    <FeatureFlagWrapper featureFlag=#HOME_UI_UX fallback={<OldUI />}>
      {specialDisplayCategories
      ->Array.map(({id, name, products: {edges, pageInfo}}) => {
        switch edges {
        | [] => React.null

        | _ =>
          <section key={`main-special-category-${id}-mobile`} className=%twc("w-full px-5 mt-12")>
            <div className=%twc("w-full")>
              <h1 className=%twc("text-[19px] font-bold text-[#1F2024]")> {name->React.string} </h1>
              <ol className=%twc("mt-4 grid grid-cols-2 gap-x-4 gap-y-8")>
                {edges
                ->Array.map(({cursor, node: {fragmentRefs}}) => {
                  <React.Suspense
                    key={`main-special-category-${id}-list-item-${cursor}-mobile`}
                    fallback={<ShopProductListItem_Buyer.MO.Placeholder />}>
                    <ShopProductListItem_Buyer.MO query=fragmentRefs />
                  </React.Suspense>
                })
                ->React.array}
              </ol>
              {switch pageInfo.hasNextPage {
              | false => React.null

              | true =>
                <div className=%twc("mt-8 flex items-center justify-center")>
                  <button
                    onClick={ReactEvents.interceptingHandler(_ => {
                      router->push(
                        `/categories/${id}?${Product_FilterOption.defaultFilterOptionUrlParam}`,
                      )
                    })}
                    className=%twc(
                      "px-[18px] py-[10px] bg-gray-100 rounded-full text-sm flex items-center"
                    )>
                    {`전체보기`->React.string}
                    <IconArrow className=%twc("ml-1") width="16" height="16" stroke="#262626" />
                  </button>
                </div>
              }}
            </div>
          </section>
        }
      })
      ->React.array}
    </FeatureFlagWrapper>
  }
}
