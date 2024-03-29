/*
 * 1. 컴포넌트 위치
 *    매장 메인 - 화면 상단 카테고리 리스트
 *
 * 2. 역할
 *    카테고리 리스트를 Horizontal List형태로 제공합니다
 *
 */

module Query = %relay(`
  query ShopMainCategoryListBuyerQuery($onlyDisplayable: Boolean!) {
    mainDisplayCategories(onlyDisplayable: $onlyDisplayable) {
      id
      image {
        original
      }
      name
    }
  }
`)

module PC = {
  module Placeholder = {
    @react.component
    let make = () => {
      <div>
        <div className=%twc("h-9 w-[138px] rounded-lg bg-gray-150 animate-pulse ml-5") />
        <ol className=%twc("flex items-center mt-6")>
          {Array.range(1, 8)
          ->Array.map(idx => {
            <div
              key={`category-skeleton-${idx->Int.toString}`}
              className=%twc("mx-6 w-[112px] max-w-[112px] flex flex-col items-center")>
              <div className=%twc("w-[112px] h-[112px] rounded-lg animate-pulse bg-gray-150") />
              <div className=%twc("mt-2 w-16 h-6 rounded-lg animate-pulse bg-gray-150") />
            </div>
          })
          ->React.array}
        </ol>
      </div>
    }
  }

  @react.component
  let make = () => {
    let {mainDisplayCategories} = Query.use(~variables={onlyDisplayable: true}, ())

    let oldUI =
      <div className=%twc("w-full")>
        <span className=%twc("text-2xl text-gray-800 font-bold ml-5")>
          {`전체 카테고리`->React.string}
        </span>
        <ol className=%twc("mt-6 w-full flex items-center")>
          {mainDisplayCategories
          ->Array.map(({id, name, image}) => {
            let key = `display-category-${id}-pc`
            let src =
              image->Option.mapWithDefault(Image.Placeholder.Sm->Image.Placeholder.getSrc, image' =>
                image'.original
              )

            <li key className=%twc("mx-6 w-[112px]")>
              <Next.Link
                href={`/categories/${id}?${Product_FilterOption.defaultFilterOptionUrlParam}`}>
                <a>
                  <div className=%twc("w-28 aspect-square rounded-lg overflow-hidden")>
                    <Image
                      src
                      placeholder=Image.Placeholder.Sm
                      className=%twc("w-full h-full object-cover")
                      alt=key
                    />
                  </div>
                  <p className=%twc("text-gray-800 font-bold text-center")>
                    {name->React.string}
                  </p>
                </a>
              </Next.Link>
            </li>
          })
          ->React.array}
          <li className=%twc("mx-6 w-[112px] max-w-[112px]")>
            <Next.Link href={`/products`}>
              <a>
                <img
                  src="https://public.sinsunhi.com/images/20220512/category_all.png"
                  className=%twc("w-28 h-28")
                  alt={`display-category-all`}
                />
                <p className=%twc("w-[112px] text-gray-800 font-bold text-center")>
                  {`전체 상품`->React.string}
                </p>
              </a>
            </Next.Link>
          </li>
        </ol>
      </div>

    <FeatureFlagWrapper featureFlag=#HOME_UI_UX fallback=oldUI>
      <div className=%twc("w-full mx-7 flex flex-col my-14")>
        <span className=%twc("text-2xl text-gray-800 font-bold ml-5")>
          {`전체 카테고리`->React.string}
        </span>
        <ol className=%twc("mt-6 w-full flex items-center")>
          {mainDisplayCategories
          ->Array.map(({id, name, image}) => {
            let key = `display-category-${id}-pc`
            let src =
              image->Option.mapWithDefault(Image.Placeholder.Sm->Image.Placeholder.getSrc, image' =>
                image'.original
              )

            <li key className=%twc("mx-6 w-23")>
              <Next.Link href={`/categories/${id}?sort=POPULARITY_DESC&section=delivery`}>
                <a>
                  <div className=%twc("w-23 aspect-square rounded-lg overflow-hidden")>
                    <Image
                      src
                      placeholder=Image.Placeholder.Sm
                      className=%twc("w-full h-full object-cover")
                      alt=key
                    />
                  </div>
                  <p className=%twc("text-gray-800 font-bold text-center")>
                    {name->React.string}
                  </p>
                </a>
              </Next.Link>
            </li>
          })
          ->React.array}
          <li className=%twc("mx-6 w-23 max-w-[92px]")>
            <Next.Link href={`/products?section=delivery&sort=POPULARITY_DESC`}>
              <a>
                <img
                  src="https://public.sinsunhi.com/images/20220512/category_all.png"
                  className=%twc("w-23 h-[92px]")
                  alt={`display-category-all`}
                />
                <p className=%twc("w-23 text-gray-800 font-bold text-center")>
                  {`전체 상품`->React.string}
                </p>
              </a>
            </Next.Link>
          </li>
        </ol>
      </div>
    </FeatureFlagWrapper>
  }
}

module MO = {
  module Placeholder = {
    @react.component
    let make = () => {
      <div className=%twc("w-full")>
        <div className=%twc("ml-5 h-5 w-[90px] rounded-lg bg-gray-150 animate-pulse") />
        <ol className=%twc("mt-6 w-full grid grid-cols-4 gap-y-3")>
          {Array.range(1, 8)
          ->Array.map(idx => {
            <li
              key={`category-skeleton-${idx->Int.toString}`}
              className=%twc("w-full flex items-center justify-center")>
              <div className=%twc("w-[90px] flex flex-col items-center")>
                <div className=%twc("w-14 aspect-square rounded-lg animate-pulse bg-gray-150") />
                <div className=%twc("mt-1 w-16 h-5 rounded-md animate-pulse bg-gray-150") />
              </div>
            </li>
          })
          ->React.array}
        </ol>
      </div>
    }
  }

  @react.component
  let make = () => {
    let {mainDisplayCategories} = Query.use(~variables={onlyDisplayable: true}, ())

    let oldUI =
      <div className=%twc("w-full")>
        <span className=%twc("ml-5 text-lg text-gray-800 font-bold")>
          {`전체 카테고리`->React.string}
        </span>
        <ol className=%twc("mt-6 w-full grid grid-cols-4 gap-y-3")>
          <li className=%twc("w-full flex items-center justify-center")>
            <Next.Link href={`/products`}>
              <a>
                <div className=%twc("w-[90px] flex flex-col items-center justify-center")>
                  <img
                    src="https://public.sinsunhi.com/images/20220512/category_all.png"
                    className=%twc("w-14 aspect-square object-cover")
                    alt={`display-category-all`}
                  />
                  <p className=%twc("text-gray-800 text-sm")> {`전체 상품`->React.string} </p>
                </div>
              </a>
            </Next.Link>
          </li>
          {mainDisplayCategories
          ->Array.map(({id, name, image}) => {
            let key = `display-category-${id}-mobile`

            <li key className=%twc("w-full flex items-center justify-center")>
              <Next.Link
                href={`/categories/${id}?${Product_FilterOption.defaultFilterOptionUrlParam}`}>
                <a>
                  <div className=%twc("w-[90px] flex flex-col items-center justify-center")>
                    <div className=%twc("w-14 aspect-square rounded-lg overflow-hidden")>
                      <Image
                        src=?{image->Option.map(({original}) => original)}
                        placeholder=Image.Placeholder.Sm
                        className=%twc("w-full h-full object-cover")
                        alt=key
                      />
                    </div>
                    <p className=%twc("text-gray-800 text-sm")> {name->React.string} </p>
                  </div>
                </a>
              </Next.Link>
            </li>
          })
          ->React.array}
        </ol>
      </div>

    <FeatureFlagWrapper featureFlag=#HOME_UI_UX fallback={oldUI}>
      <div className=%twc("w-full")>
        <span className=%twc("ml-3 text-[19px] text-[#1F2024] font-bold")>
          {`전체 카테고리`->React.string}
        </span>
        <ol className=%twc("mt-6 w-full grid grid-cols-4 gap-y-3")>
          {mainDisplayCategories
          ->Array.map(({id, name, image}) => {
            let key = `display-category-${id}-mobile`

            <li key className=%twc("w-full flex items-center justify-center")>
              <Next.Link href={`/categories/${id}?sort=POPULARITY_DESC&section=delivery`}>
                <a>
                  <div className=%twc("w-[90px] flex flex-col items-center justify-center")>
                    <div className=%twc("w-14 aspect-square rounded-lg overflow-hidden")>
                      <Image
                        src=?{image->Option.map(({original}) => original)}
                        placeholder=Image.Placeholder.Sm
                        className=%twc("w-full h-full object-cover")
                        alt=key
                      />
                    </div>
                    <p className=%twc("text-gray-800 text-sm")> {name->React.string} </p>
                  </div>
                </a>
              </Next.Link>
            </li>
          })
          ->React.array}
          <li className=%twc("w-full flex items-center justify-center")>
            <Next.Link href={`/products?sort=POPULARITY_DESC&section=delivery`}>
              <a>
                <div className=%twc("w-[90px] flex flex-col items-center justify-center")>
                  <img
                    src="https://public.sinsunhi.com/images/20220512/category_all.png"
                    className=%twc("w-14 aspect-square object-cover")
                    alt={`display-category-all`}
                  />
                  <p className=%twc("text-gray-800 text-sm")> {`전체 상품`->React.string} </p>
                </div>
              </a>
            </Next.Link>
          </li>
        </ol>
      </div>
    </FeatureFlagWrapper>
  }
}
