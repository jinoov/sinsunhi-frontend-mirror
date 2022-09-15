/*
 *
 * 1. 위치: 바이어센터 매장 상품 리스트 아이템
 *
 * 2. 역할: 상품 리스트 내에서 각 상품의 간략한 정보를 제공한다
 *
 */

module Fragments = {
  module Root = %relay(`
  fragment MatchingProductListItemFragment on Product {
    __typename
    displayName
    ...MatchingProductListItemQuotedFragment
    ...MatchingProductListItemMatchingFragment
  }
  `)

  module Quoted = %relay(`
    fragment MatchingProductListItemQuotedFragment on QuotedProduct {
      productId: number
      image {
        thumb400x400
      }
      displayName
      status
    }
  `)

  module Matching = %relay(`
    fragment MatchingProductListItemMatchingFragment on MatchingProduct {
      productId: number
      image {
        thumb400x400
      }
      displayName
      status
      price
      pricePerKg
      representativeWeight
    }
  `)
}

module Soldout = {
  module PC = {
    @react.component
    let make = (~show) => {
      switch show {
      | true =>
        <>
          <div
            className=%twc("w-full h-full absolute top-0 left-0 bg-white opacity-40 rounded-xl")
          />
          <div
            className=%twc(
              "absolute bottom-0 w-full h-8 bg-gray-600 flex items-center justify-center opacity-90"
            )>
            <span className=%twc("text-white font-bold")> {`품절`->React.string} </span>
          </div>
        </>
      | false => React.null
      }
    }
  }

  module MO = {
    @react.component
    let make = (~show) => {
      switch show {
      | true =>
        <>
          <div
            className=%twc("w-full h-full absolute top-0 left-0 bg-white opacity-40 rounded-xl")
          />
          <div
            className=%twc(
              "absolute bottom-0 w-full h-8 bg-gray-600 flex items-center justify-center opacity-90"
            )>
            <span className=%twc("text-white font-bold")> {`품절`->React.string} </span>
          </div>
        </>
      | false => React.null
      }
    }
  }
}

module Quoted = {
  module PC = {
    @react.component
    let make = (~query) => {
      let {useRouter, push} = module(Next.Router)
      let router = useRouter()

      let {productId, image, displayName, status} = query->Fragments.Quoted.use
      let isSoldout = status == #SOLDOUT

      let onClick = ReactEvents.interceptingHandler(_ => {
        router->push(`/products/${productId->Int.toString}`)
      })

      <div className=%twc("w-[280px] h-[376px] cursor-pointer") onClick>
        <div className=%twc("w-[280px] aspect-square rounded-xl overflow-hidden relative")>
          <Image
            src=image.thumb400x400
            className=%twc("w-full h-full object-cover")
            placeholder=Image.Placeholder.Sm
            alt={`product-${productId->Int.toString}`}
            loading=Image.Loading.Lazy
          />
          <div className=%twc("w-full h-full absolute top-0 left-0 bg-black/[.03] rounded-2xl") />
          <Soldout.PC show={isSoldout} />
        </div>
        <div className=%twc("flex flex-col mt-4")>
          <span className=%twc("text-gray-800 line-clamp-2")> {displayName->React.string} </span>
          <span className=%twc("mt-2 font-bold text-lg text-blue-500")>
            {`최저가 견적받기`->React.string}
          </span>
        </div>
      </div>
    }
  }

  module MO = {
    @react.component
    let make = (~query) => {
      let {useRouter, push} = module(Next.Router)
      let router = useRouter()

      let {productId, image, displayName, status} = query->Fragments.Quoted.use
      let isSoldout = status == #SOLDOUT

      let onClick = ReactEvents.interceptingHandler(_ => {
        router->push(`/products/${productId->Int.toString}`)
      })

      <div className=%twc("cursor-pointer") onClick>
        <div className=%twc("rounded-xl overflow-hidden relative aspect-square")>
          <Image
            src=image.thumb400x400
            className=%twc("w-full h-full object-cover")
            placeholder=Image.Placeholder.Sm
            alt={`product-${productId->Int.toString}`}
            loading=Image.Loading.Lazy
          />
          <div className=%twc("w-full h-full absolute top-0 left-0 bg-black/[.03] rounded-xl") />
          <Soldout.MO show={isSoldout} />
        </div>
        <div className=%twc("flex flex-col mt-3")>
          <span className=%twc("text-gray-800 line-clamp-2 text-sm")>
            {displayName->React.string}
          </span>
          <span className=%twc("mt-1 font-bold text-blue-500")>
            {`최저가 견적받기`->React.string}
          </span>
        </div>
      </div>
    }
  }
}

module Matching = {
  module PC = {
    @react.component
    let make = (~query) => {
      let {useRouter, push} = module(Next.Router)
      let router = useRouter()
      let user = CustomHooks.User.Buyer.use2()

      let {productId, image, displayName, pricePerKg, price, representativeWeight, status} =
        query->Fragments.Matching.use
      let isSoldout = status == #SOLDOUT

      <div
        className=%twc("w-[280px] h-[376px] cursor-pointer")
        onClick={_ => {
          router->push(`/products/${productId->Int.toString}`)
        }}>
        <div className=%twc("w-[280px] aspect-square rounded-xl overflow-hidden relative")>
          <Image
            src=image.thumb400x400
            className=%twc("w-full h-full object-cover")
            placeholder=Image.Placeholder.Sm
            alt={`product-${productId->Int.toString}`}
            loading=Image.Loading.Lazy
          />
          <div className=%twc("w-full h-full absolute top-0 left-0 bg-black/[.03] rounded-2xl") />
          <Soldout.PC show={isSoldout} />
        </div>
        <div className=%twc("flex flex-col mt-4")>
          <ShopProductListItem_Buyer.Matching.ProductName.PC
            productName={displayName} representativeWeight
          />
          {switch (price, pricePerKg, user) {
          | (Some(price), Some(pricePerKg), LoggedIn(_)) =>
            <ShopProductListItem_Buyer.Matching.PriceText.PC
              price={price->Int.toFloat} pricePerKg={pricePerKg->Int.toFloat} isSoldout
            />
          | (None, Some(pricePerKg), LoggedIn(_)) =>
            <ShopProductListItem_Buyer.Matching.PriceText.PC
              price={pricePerKg->Int.toFloat *. representativeWeight}
              pricePerKg={pricePerKg->Int.toFloat}
              isSoldout
            />
          | _ =>
            <span className=%twc("mt-1 font-bold text-lg text-green-500")>
              {`예상가 회원공개`->React.string}
            </span>
          }}
        </div>
      </div>
    }
  }

  module MO = {
    @react.component
    let make = (~query) => {
      let {useRouter, push} = module(Next.Router)
      let router = useRouter()
      let user = CustomHooks.User.Buyer.use2()

      let {productId, image, displayName, pricePerKg, price, representativeWeight, status} =
        query->Fragments.Matching.use
      let isSoldout = status == #SOLDOUT

      <div
        className=%twc("cursor-pointer")
        onClick={_ => {
          router->push(`/products/${productId->Int.toString}`)
        }}>
        <div className=%twc("rounded-xl overflow-hidden relative aspect-square")>
          <Image
            src=image.thumb400x400
            className=%twc("w-full h-full object-cover")
            placeholder=Image.Placeholder.Sm
            alt={`product-${productId->Int.toString}`}
            loading=Image.Loading.Lazy
          />
          <div className=%twc("w-full h-full absolute top-0 left-0 bg-black/[.03] rounded-xl") />
          <Soldout.MO show={isSoldout} />
        </div>
        <div className=%twc("flex flex-col mt-3")>
          <ShopProductListItem_Buyer.Matching.ProductName.MO
            productName={displayName} representativeWeight
          />
          {switch (price, pricePerKg, user) {
          | (Some(price), Some(pricePerKg), LoggedIn(_)) =>
            <ShopProductListItem_Buyer.Matching.PriceText.MO
              price={price->Int.toFloat} pricePerKg={pricePerKg->Int.toFloat} isSoldout
            />
          | (None, Some(pricePerKg), LoggedIn(_)) =>
            <ShopProductListItem_Buyer.Matching.PriceText.MO
              price={pricePerKg->Int.toFloat *. representativeWeight}
              pricePerKg={pricePerKg->Int.toFloat}
              isSoldout
            />
          | _ =>
            <span className=%twc("mt-2 font-bold  text-green-500")>
              {`예상가 회원공개`->React.string}
            </span>
          }}
          // </span>
        </div>
      </div>
    }
  }
}

module PC = {
  module Placeholder = {
    @react.component
    let make = () => {
      <div className=%twc("w-[280px] h-[376px]")>
        <div className=%twc("w-[280px] h-[280px] animate-pulse rounded-xl bg-gray-100") />
        <div className=%twc("mt-3 w-[244px] h-[24px] animate-pulse rounded-sm bg-gray-100") />
        <div className=%twc("mt-2 w-[88px] h-[24px] animate-pulse rounded-sm bg-gray-100") />
      </div>
    }
  }

  @react.component
  let make = (~query) => {
    let {__typename, fragmentRefs} = query->Fragments.Root.use

    switch __typename->Product_Parser.Type.decode {
    | Some(Quoted) => <Quoted.PC query=fragmentRefs />
    | Some(Matching) => <Matching.PC query=fragmentRefs />
    | _ => React.null
    }
  }
}

module MO = {
  module Placeholder = {
    @react.component
    let make = () => {
      <div>
        <div className=%twc("w-full aspect-square animate-pulse rounded-xl bg-gray-100") />
        <div className=%twc("mt-3 w-[132px] h-5 animate-pulse rounded-sm bg-gray-100") />
        <div className=%twc("mt-1 w-[68px] h-[22px] animate-pulse rounded-sm bg-gray-100") />
      </div>
    }
  }

  @react.component
  let make = (~query) => {
    let {__typename, fragmentRefs} = query->Fragments.Root.use

    switch __typename->Product_Parser.Type.decode {
    | Some(Quoted) => <Quoted.MO query=fragmentRefs />
    | Some(Matching) => <Matching.MO query=fragmentRefs />
    | _ => React.null
    }
  }
}
