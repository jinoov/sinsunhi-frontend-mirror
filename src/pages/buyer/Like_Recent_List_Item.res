module Fragment = %relay(`
  fragment LikeRecentListItem_Fragment on Product {
    id
    status
    image {
      thumb400x400
    }
    displayName
    ...LikeRecentListItem_PriceLabel_Fragment
  }
`)

module PriceLabelFragment = %relay(`
  fragment LikeRecentListItem_PriceLabel_Fragment on Product {
    ... on NormalProduct {
      price
    }
    ... on MatchingProduct {
      price
      pricePerKg
    }
    ... on QuotedProduct {
      id
    }
    ... on QuotableProduct {
      price
    }
  }
`)

@module("../../../public/assets/input-check.svg")
external inputCheckIcon: string = "default"

module Common_View = {
  module StatusLabel = {
    @react.component
    let make = (~text) => {
      let dimmedStyle = %twc(
        "w-full h-full absolute top-0 left-0 bg-white opacity-40 rounded-[10px]"
      )
      let labelContainerStyle = %twc(
        "absolute bottom-0 w-full h-6 bg-gray-600 flex items-center justify-center opacity-90"
      )
      let labelTextStyle = %twc("text-white font-bold")

      <>
        <div className=dimmedStyle />
        <div className=labelContainerStyle>
          <span className=labelTextStyle> {text->React.string} </span>
        </div>
      </>
    }
  }
  module PriceLabel = {
    module CommonView = {
      @react.component
      let make = (~query) => {
        <span className=%twc("font-bold text-base")>
          {switch query->PriceLabelFragment.use {
          | #QuotableProduct({price})
          | #NormalProduct({price}) =>
            <span className=%twc("font-bold ")>
              {`${price
                ->Option.getWithDefault(0)
                ->Int.toFloat
                ->Locale.Float.show(~digits=0)}원`->React.string}
            </span>
          | #QuotedProduct(_) =>
            <span className=%twc("font-bold text-blue-500")>
              {`최저가 견적받기`->React.string}
            </span>
          | #MatchingProduct({price, pricePerKg}) =>
            <div className=%twc("flex flex-col items-start")>
              <span className=%twc("font-bold ")>
                {`${price
                  ->Option.getWithDefault(0)
                  ->Int.toFloat
                  ->Locale.Float.show(~digits=0)}원`->React.string}
              </span>
              <span className=%twc("text-sm font-normal text-text-L2 ")>
                {`kg당 ${pricePerKg
                  ->Option.getWithDefault(0)
                  ->Int.toFloat
                  ->Locale.Float.show(~digits=0)}원`->React.string}
              </span>
            </div>
          | _ => React.null
          }}
        </span>
      }
    }
    @react.component
    let make = (~query, ~status) => {
      switch status {
      | #SALE => <CommonView query />
      | _ =>
        <span className=%twc("!text-gray-400")>
          <CommonView query />
        </span>
      }
    }
  }
  module ProductImage = {
    @react.component
    let make = (~image, ~status) => {
      <div className=%twc("w-[100px] aspect-square rounded-[10px] overflow-hidden relative z-0")>
        <Image src=image className=%twc("w-full h-full object-cover") loading=Image.Loading.Lazy />
        <div className=%twc("w-full h-full absolute top-0 left-0 bg-black/[.03]") />
        <div className=%twc("w-full h-full absolute top-0 left-0 bg-black/[.03] rounded-[10px]") />
        {switch status {
        | #SOLDOUT => <StatusLabel text={`품절`} />
        | #HIDDEN_SALE => <StatusLabel text={`비공개 판매`} />
        | #NOSALE => <StatusLabel text={`숨김`} />
        | _ => React.null
        }}
      </div>
    }
  }
  module ProductName = {
    @react.component
    let make = (~displayName) => {
      <span className=%twc("line-clamp-2 text-base text-left")>
        {`${displayName}`->React.string}
      </span>
    }
  }
  @react.component
  let make = (~query) => {
    let {__typename, id, image: {thumb400x400}, displayName, status, fragmentRefs} =
      query->Fragment.use

    <div className=%twc("flex flex-row gap-3 flex-1  p-2 rounded-2xl transition-colors") id>
      <ProductImage image={thumb400x400} status />
      <div className=%twc("flex flex-col flex-1 gap-1 text-gray-800 items-start")>
        <ProductName displayName />
        <PriceLabel query=fragmentRefs status />
      </div>
    </div>
  }
}
module Edit = {
  @react.component
  let make = (~query, ~isChecked, ~onClick) => {
    let checkboxClassName = Cn.make([
      isChecked ? %twc("bg-green-gl") : %twc("bg-white border-2 border-gray-300 "),
      %twc("rounded-[5px] flex justify-center items-center w-5 h-5 "),
    ])

    let oldUI =
      <button
        type_="button"
        onClick
        className=%twc(
          "flex cursor-pointer px-5 xl:px-7 gap-4 w-full items-center active:bg-gray-50 xl:hover:bg-gray-50"
        )>
        {switch isChecked {
        | true =>
          <div className=checkboxClassName>
            <img src=inputCheckIcon />
          </div>
        | false => <div className=checkboxClassName />
        }}
        <Common_View query />
      </button>

    <FeatureFlagWrapper featureFlag=#HOME_UI_UX fallback=oldUI>
      <button
        type_="button"
        onClick
        className=%twc(
          "flex cursor-pointer px-5 lg:px-[50px] gap-4 w-full items-center active:bg-gray-50 xl:hover:bg-gray-50 ease-in-out duration-200"
        )>
        {switch isChecked {
        | true =>
          <div className=checkboxClassName>
            <img src=inputCheckIcon />
          </div>
        | false => <div className=checkboxClassName />
        }}
        <Common_View query />
      </button>
    </FeatureFlagWrapper>
  }
}
module View = {
  @react.component
  let make = (~query, ~pid) => {
    let oldUI =
      <Next.Link href={`/products/${pid->Int.toString}`}>
        <a
          href={`/products/${pid->Int.toString}`}
          className=%twc("px-3 xl:px-5 active:bg-gray-50 xl:hover:bg-gray-50")>
          <Common_View query />
        </a>
      </Next.Link>

    <FeatureFlagWrapper featureFlag=#HOME_UI_UX fallback=oldUI>
      <Next.Link href={`/products/${pid->Int.toString}`}>
        <a
          href={`/products/${pid->Int.toString}`}
          className=%twc(
            "px-3 lg:px-[42px] active:bg-gray-50 lg:hover:bg-gray-50 ease-in-out duration-200"
          )>
          <Common_View query />
        </a>
      </Next.Link>
    </FeatureFlagWrapper>
  }
}
