/*
 *
 * 1. 위치: 바이어센터 매장 상품 리스트 아이템
 *
 * 2. 역할: 상품 리스트 내에서 각 상품의 간략한 정보를 제공한다
 *
 */

module Fragments = {
  module Root = %relay(`
  fragment ShopProductListItemBuyerFragment on Product {
    __typename
    ...ShopProductListItemBuyerNormalFragment
    ...ShopProductListItemBuyerQuotedFragment
    ...ShopProductListItemBuyerMatchingFragment
  }
  `)

  module Normal = %relay(`
    fragment ShopProductListItemBuyerNormalFragment on Product {
      productId: number
      image {
        thumb800x800
      }
      status
      displayName
      ... on NormalProduct {
        price
      }
      ... on QuotableProduct {
        price
      }
    }
  `)

  module Quoted = %relay(`
    fragment ShopProductListItemBuyerQuotedFragment on QuotedProduct {
      productId: number
      image {
        thumb800x800
      }
      displayName
      status
    }
  `)

  module Matching = %relay(`
    fragment ShopProductListItemBuyerMatchingFragment on MatchingProduct {
      productId: number
      image {
        thumb800x800
      }
      displayName
      status
      price
      pricePerKg
      representativeWeight
    }
  `)
}

module StatusLabel = {
  @react.component
  let make = (~text) => {
    let dimmedStyle = %twc("w-full h-full absolute top-0 left-0 bg-white opacity-40 rounded-xl")
    let labelContainerStyle = %twc(
      "absolute bottom-0 w-full h-10 bg-gray-600 flex items-center justify-center opacity-90"
    )
    let labelTextStyle = %twc("text-white text-xl font-bold")

    <>
      <div className=dimmedStyle />
      <div className=labelContainerStyle>
        <span className=labelTextStyle> {text->React.string} </span>
      </div>
    </>
  }
}

module Normal = {
  module PC = {
    @react.component
    let make = (~query) => {
      let {useRouter, push} = module(Next.Router)
      let router = useRouter()
      let user = CustomHooks.User.Buyer.use2()

      let {productId, displayName, price, image, status} = query->Fragments.Normal.use

      let priceLabel = {
        price->Option.mapWithDefault("", price' =>
          `${price'->Int.toFloat->Locale.Float.show(~digits=0)}원`
        )
      }

      <div
        className=%twc("w-[280px] h-[376px] cursor-pointer")
        onClick={_ => router->push(`/products/${productId->Int.toString}`)}>
        <div className=%twc("w-[280px] aspect-square rounded-xl overflow-hidden relative")>
          <Image
            src=image.thumb800x800
            className=%twc("w-full h-full object-cover")
            placeholder=Image.Placeholder.Sm
            alt={`product-${productId->Int.toString}`}
            loading=Image.Loading.Lazy
          />
          <div className=%twc("w-full h-full absolute top-0 left-0 bg-black/[.03] rounded-2xl") />
          {switch status {
          | #SOLDOUT => <StatusLabel text={`품절`} />
          | #HIDDEN_SALE => <StatusLabel text={`비공개 판매`} />
          | #NOSALE => <StatusLabel text={`숨김`} />
          | _ => React.null
          }}
        </div>
        <div className=%twc("flex flex-col mt-4")>
          <span className=%twc("text-gray-800 line-clamp-2")> {displayName->React.string} </span>
          {switch user {
          | Unknown => <Skeleton.Box />

          | NotLoggedIn =>
            <span className=%twc("mt-2 font-bold text-lg text-green-500")>
              {`공급가 회원공개`->React.string}
            </span>

          | LoggedIn(_) =>
            let textColor = switch status {
            | #SOLDOUT | #HIDDEN_SALE => %twc(" text-gray-400")
            | _ => %twc(" text-text-L1")
            }
            <span className={%twc("mt-2 font-bold text-lg") ++ textColor}>
              {priceLabel->React.string}
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

      let {productId, displayName, price, image, status} = query->Fragments.Normal.use
      let isSoldout = status == #SOLDOUT

      let priceLabel = {
        price->Option.mapWithDefault("", price' =>
          `${price'->Int.toFloat->Locale.Float.show(~digits=0)}원`
        )
      }

      <div
        className=%twc("cursor-pointer")
        onClick={_ => router->push(`/products/${productId->Int.toString}`)}>
        <div className=%twc("rounded-xl overflow-hidden relative aspect-square")>
          <Image
            src=image.thumb800x800
            className=%twc("w-full h-full object-cover")
            placeholder=Image.Placeholder.Sm
            alt={`product-${productId->Int.toString}`}
            loading=Image.Loading.Lazy
          />
          <div className=%twc("w-full h-full absolute top-0 left-0 bg-black/[.03] rounded-xl") />
          {switch status {
          | #SOLDOUT => <StatusLabel text={`품절`} />
          | #HIDDEN_SALE => <StatusLabel text={`비공개 판매`} />
          | #NOSALE => <StatusLabel text={`숨김`} />
          | _ => React.null
          }}
        </div>
        <div className=%twc("flex flex-col mt-3")>
          <span className=%twc("text-gray-800 line-clamp-2 text-sm")>
            {displayName->React.string}
          </span>
          {switch user {
          | LoggedIn(_) =>
            let textColor = isSoldout ? %twc(" text-gray-400") : %twc(" text-text-L1")
            <span className={%twc("mt-1 font-bold") ++ textColor}>
              {priceLabel->React.string}
            </span>
          | NotLoggedIn =>
            <span className=%twc("mt-1 font-bold text-green-500")>
              {`공급가 회원공개`->React.string}
            </span>
          | Unknown => <Skeleton.Box />
          }}
        </div>
      </div>
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

      <div
        className=%twc("w-[280px] h-[376px] cursor-pointer")
        onClick={_ => router->push(`/products/${productId->Int.toString}`)}>
        <div className=%twc("w-[280px] aspect-square rounded-xl overflow-hidden relative")>
          <Image
            src=image.thumb800x800
            className=%twc("w-full h-full object-cover")
            placeholder=Image.Placeholder.Sm
            alt={`product-${productId->Int.toString}`}
            loading=Image.Loading.Lazy
          />
          <div className=%twc("w-full h-full absolute top-0 left-0 bg-black/[.03] rounded-2xl") />
          {switch status {
          | #SOLDOUT => <StatusLabel text={`품절`} />
          | #HIDDEN_SALE => <StatusLabel text={`비공개 판매`} />
          | #NOSALE => <StatusLabel text={`숨김`} />
          | _ => React.null
          }}
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

      <div
        className=%twc("cursor-pointer")
        onClick={_ => router->push(`/products/${productId->Int.toString}`)}>
        <div className=%twc("rounded-xl overflow-hidden relative aspect-square")>
          <Image
            src=image.thumb800x800
            className=%twc("w-full h-full object-cover")
            placeholder=Image.Placeholder.Sm
            alt={`product-${productId->Int.toString}`}
            loading=Image.Loading.Lazy
          />
          <div className=%twc("w-full h-full absolute top-0 left-0 bg-black/[.03] rounded-xl") />
          {switch status {
          | #SOLDOUT => <StatusLabel text={`품절`} />
          | #HIDDEN_SALE => <StatusLabel text={`비공개 판매`} />
          | #NOSALE => <StatusLabel text={`숨김`} />
          | _ => React.null
          }}
        </div>
        <div className=%twc("flex flex-col mt-3")>
          <span className=%twc("text-text-L1 line-clamp-2 text-sm")>
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
  module ProductName = {
    module PC = {
      @react.component
      let make = (~productName, ~representativeWeight) => {
        <span className=%twc("text-gray-800 flex-wrap overflow-hidden gap-1")>
          <span> {productName->React.string} </span>
          <span> {`,${representativeWeight->Locale.Float.show(~digits=1)}Kg `->React.string} </span>
        </span>
      }
    }

    module MO = {
      @react.component
      let make = (~productName, ~representativeWeight) => {
        <span className=%twc("text-gray-800 line-clamp-2 text-sm")>
          <span> {productName->React.string} </span>
          <span> {`,${representativeWeight->Locale.Float.show(~digits=1)}Kg`->React.string} </span>
        </span>
      }
    }
  }
  module PriceText = {
    module PC = {
      @react.component
      let make = (~price, ~pricePerKg, ~isSoldout) => {
        <div className={%twc("inline-flex flex-col")}>
          <span
            className={Cn.make([
              %twc("mt-1 font-bold text-lg"),
              isSoldout ? %twc("text-text-L3") : %twc("text-text-L1"),
            ])}>
            {`${price->Locale.Float.show(~digits=0)}원`->React.string}
          </span>
          <span className=%twc("text-sm text-text-L2")>
            {`kg당 ${pricePerKg->Locale.Float.show(~digits=0)}원`->React.string}
          </span>
        </div>
      }
    }

    module MO = {
      @react.component
      let make = (~price, ~pricePerKg, ~isSoldout) => {
        <div className=%twc("inline-flex flex-col")>
          <span
            className={Cn.make([
              %twc("mt-1 font-bold"),
              isSoldout ? %twc("text-text-L3") : %twc("text-text-L1"),
            ])}>
            {`${price->Locale.Float.show(~digits=0)}원`->React.string}
          </span>
          <span className=%twc("text-sm text-text-L2")>
            {`kg당 ${pricePerKg->Locale.Float.show(~digits=0)}원`->React.string}
          </span>
        </div>
      }
    }
  }
  module PC = {
    @react.component
    let make = (~query) => {
      let {useRouter, push} = module(Next.Router)
      let router = useRouter()
      let user = CustomHooks.User.Buyer.use2()

      let {productId, image, displayName, status, price, pricePerKg, representativeWeight} =
        query->Fragments.Matching.use

      <div
        className=%twc("w-[280px] h-[376px] cursor-pointer")
        onClick={_ => router->push(`/products/${productId->Int.toString}`)}>
        <div className=%twc("w-[280px] aspect-square rounded-xl overflow-hidden relative")>
          <Image
            src=image.thumb800x800
            className=%twc("w-full h-full object-cover")
            placeholder=Image.Placeholder.Sm
            alt={`product-${productId->Int.toString}`}
            loading=Image.Loading.Lazy
          />
          <div className=%twc("w-full h-full absolute top-0 left-0 bg-black/[.03] rounded-2xl") />
          {switch status {
          | #SOLDOUT => <StatusLabel text={`품절`} />
          | #HIDDEN_SALE => <StatusLabel text={`비공개 판매`} />
          | #NOSALE => <StatusLabel text={`숨김`} />
          | _ => React.null
          }}
        </div>
        <div className=%twc("flex flex-col mt-4")>
          <ProductName.PC productName={displayName} representativeWeight={representativeWeight} />
          {switch (price, pricePerKg, user) {
          | (Some(price), Some(pricePerKg), LoggedIn(_)) =>
            let isSoldout = status == #SOLDOUT
            <PriceText.PC
              price={price->Int.toFloat} pricePerKg={pricePerKg->Int.toFloat} isSoldout
            />

          | (None, Some(pricePerKg), LoggedIn(_)) =>
            let isSoldout = status == #SOLDOUT
            <PriceText.PC
              price={pricePerKg->Int.toFloat *. representativeWeight}
              pricePerKg={pricePerKg->Int.toFloat}
              isSoldout
            />

          | _ =>
            <span className=%twc("mt-2 font-bold text-lg text-green-500")>
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

      let {productId, image, displayName, status, price, pricePerKg, representativeWeight} =
        query->Fragments.Matching.use

      <div
        className=%twc("cursor-pointer")
        onClick={_ => router->push(`/products/${productId->Int.toString}`)}>
        <div className=%twc("rounded-xl overflow-hidden relative aspect-square")>
          <Image
            src=image.thumb800x800
            className=%twc("w-full h-full object-cover")
            placeholder=Image.Placeholder.Sm
            alt={`product-${productId->Int.toString}`}
            loading=Image.Loading.Lazy
          />
          <div className=%twc("w-full h-full absolute top-0 left-0 bg-black/[.03] rounded-xl") />
          {switch status {
          | #SOLDOUT => <StatusLabel text={`품절`} />
          | #HIDDEN_SALE => <StatusLabel text={`비공개 판매`} />
          | #NOSALE => <StatusLabel text={`숨김`} />
          | _ => React.null
          }}
        </div>
        <div className=%twc("flex flex-col mt-3")>
          <ProductName.MO productName={displayName} representativeWeight={representativeWeight} />
          {switch (price, pricePerKg, user) {
          | (Some(price), Some(pricePerKg), LoggedIn(_)) =>
            let isSoldout = status == #SOLDOUT
            <PriceText.MO
              price={price->Int.toFloat} pricePerKg={pricePerKg->Int.toFloat} isSoldout
            />

          | (None, Some(pricePerKg), LoggedIn(_)) =>
            let isSoldout = status == #SOLDOUT
            <PriceText.MO
              price={pricePerKg->Int.toFloat *. representativeWeight}
              pricePerKg={pricePerKg->Int.toFloat}
              isSoldout
            />

          | _ =>
            <span className=%twc("mt-2 font-bold text-lg text-green-500")>
              {`예상가 회원공개`->React.string}
            </span>
          }}
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
    | Some(Quotable) | Some(Normal) => <Normal.PC query=fragmentRefs />
    | Some(Quoted) => <Quoted.PC query=fragmentRefs />
    | Some(Matching) => <Matching.PC query=fragmentRefs />
    | None => React.null
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
    | Some(Quotable) | Some(Normal) => <Normal.MO query=fragmentRefs />
    | Some(Quoted) => <Quoted.MO query=fragmentRefs />
    | Some(Matching) => <Matching.MO query=fragmentRefs />
    | None => React.null
    }
  }
}
