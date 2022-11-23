module Fragment = %relay(`
    fragment PCInterestedProductAddItemBuyer_Fragment on MatchingProduct {
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

@module("/public/assets/box.svg")
external placeholder: string = "default"

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
let make = (~query, ~checked, ~onChange) => {
  let (animation, setAnimation) = React.Uncurried.useState(_ => "")
  let product = Fragment.use(query)

  let handleOnChange = (fn, _) => {
    switch checked {
    | true => setAnimation(._ => "pdp-dislike-action")
    | false => setAnimation(._ => "pdp-like-action")
    }

    fn()
  }

  <React.Suspense fallback={<Placeholder />}>
    <button type_="button" className=%twc("relative h-fit") onClick={handleOnChange(onChange)}>
      <div className=%twc("rounded-xl overflow-hidden relative aspect-square ")>
        <Next.Image
          src={product.image.thumb800x800}
          layout=#fill
          alt={product.displayName}
          placeholder=#blur
          blurDataURL=placeholder
          className=%twc("bg-[#b0b3b51f]")
        />
        <div className=%twc("absolute right-2 bottom-2  bg-[#F0F2F5] rounded-xl")>
          <div className=%twc("w-full interactable p-2 rounded-xl")>
            <IconHeart
              className={cx([checked ? "pdp-liked" : "pdp-disliked", animation])}
              width="24px"
              height="24px"
            />
          </div>
        </div>
      </div>
      <div className=%twc("text-left mt-3 text-sm")> {product.displayName->React.string} </div>
      {switch product.price {
      | Some(p') =>
        <div className=%twc("text-left font-bold")>
          {`${p'->Int.toFloat->Locale.Float.show(~digits=0)}원`->React.string}
        </div>
      | None => React.null
      }}
    </button>
  </React.Suspense>
}
