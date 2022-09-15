/*
 *
 * 1. 위치: 바이어센터 매장 상품 리스트 아이템
 *
 * 2. 역할: 상품 리스트 내에서 각 상품의 간략한 정보를 제공한다
 *
 */

module Fragments = {
  module Root = %relay(`
  fragment DeliveryProductListItemFragment on Product {
    __typename
    displayName
    ...DeliveryProductListItemNormalFragment
    ...DeliveryProductListItemQuotableFragment
  }
  `)

  module Normal = %relay(`
    fragment DeliveryProductListItemNormalFragment on NormalProduct {
      productId: number
      image {
        thumb400x400
      }
      price
      displayName
      status
    }
  `)

  module Quotable = %relay(`
    fragment DeliveryProductListItemQuotableFragment on QuotableProduct {
      productId: number
      image {
        thumb400x400
      }
      displayName
      status
      price
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

module Normal = {
  module PC = {
    @react.component
    let make = (~query) => {
      let {useRouter, push} = module(Next.Router)
      let user = CustomHooks.User.Buyer.use2()
      let router = useRouter()

      let {productId, image, displayName, status, price} = query->Fragments.Normal.use
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
          {switch (price, user) {
          | (Some(price), LoggedIn(_)) =>
            <span className=%twc("mt-1 font-bold text-lg text-gray-800")>
              {`${price->Int.toFloat->Locale.Float.show(~digits=0)}원`->React.string}
            </span>

          | _ =>
            <span className=%twc("mt-1 font-bold text-lg text-green-500")>
              {`공급가 회원공개`->React.string}
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
      let user = CustomHooks.User.Buyer.use2()
      let router = useRouter()

      let {productId, image, displayName, status, price} = query->Fragments.Normal.use
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
          {switch (price, user) {
          | (Some(price), LoggedIn(_)) =>
            <span className=%twc("mt-1 font-bold text-lg text-gray-800")>
              {`${price->Int.toFloat->Locale.Float.show(~digits=0)}원`->React.string}
            </span>

          | _ =>
            <span className=%twc("mt-1 font-bold text-lg text-green-500")>
              {`공급가 회원공개`->React.string}
            </span>
          }}
        </div>
      </div>
    }
  }
}

module Quotable = {
  module PC = {
    @react.component
    let make = (~query) => {
      let {useRouter, push} = module(Next.Router)
      let router = useRouter()
      let user = CustomHooks.User.Buyer.use2()

      let {productId, image, displayName, price, status} = query->Fragments.Quotable.use
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
          <span className=%twc("text-gray-800 line-clamp-2")> {displayName->React.string} </span>
          {switch (price, user) {
          | (Some(price), LoggedIn(_)) =>
            <span className=%twc("mt-1 font-bold text-lg text-gray-800")>
              {`${price->Int.toFloat->Locale.Float.show(~digits=0)}원`->React.string}
            </span>

          | _ =>
            <span className=%twc("mt-1 font-bold text-lg text-green-500")>
              {`공급가 회원공개`->React.string}
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

      user->Js.log

      let {productId, image, displayName, price, status} = query->Fragments.Quotable.use
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
          <span className=%twc("text-gray-800 line-clamp-2 text-sm")>
            {displayName->React.string}
          </span>
          {switch (price, user) {
          | (Some(price), LoggedIn(_)) =>
            <span className=%twc("mt-1 font-bold text-lg text-gray-800")>
              {`${price->Int.toFloat->Locale.Float.show(~digits=0)}원`->React.string}
            </span>

          | _ =>
            <span className=%twc("mt-1 font-bold text-lg text-green-500")>
              {`공급가 회원공개`->React.string}
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
    | Some(Normal) => <Normal.PC query=fragmentRefs />
    | Some(Quotable) => <Quotable.PC query=fragmentRefs />
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
    | Some(Normal) => <Normal.MO query=fragmentRefs />
    | Some(Quotable) => <Quotable.MO query=fragmentRefs />
    | _ => React.null
    }
  }
}
