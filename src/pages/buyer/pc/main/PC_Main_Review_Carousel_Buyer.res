module Fragment = %relay(`
    fragment PCMainReviewCarouselBuyerQuery_Fragment on Query {
      reviews {
        amountUnit
        totalAmount
        category {
          name
        }
        id
        content
        productScore
        profileImageUrl
        purchasedAt
        shippingScore
        businessSector
      }
    }
`)

%%raw(`import 'swiper/css'`)
%%raw(`import 'swiper/css/autoplay'`)

@react.component
let make = (~query) => {
  let {reviews} = Fragment.use(query)
  let nextRef = React.useRef(Js.Nullable.null)
  let prevRef = React.useRef(Js.Nullable.null)
  let (nextRefState, setNextRefState) = React.Uncurried.useState(_ => Js.Nullable.null)

  let (prevRefState, setPrevRefState) = React.Uncurried.useState(_ => Js.Nullable.null)

  React.useEffect2(_ => {
    setNextRefState(._ => nextRef.current)
    setPrevRefState(._ => prevRef.current)
    None
  }, (nextRef, prevRef))

  <div className=%twc("pt-14 pb-[30px] w-full")>
    <h2 className=%twc("font-bold text-[19px] text-enabled-L1 pl-[50px]")>
      {"거래후기"->React.string}
    </h2>
    <div className=%twc("relative")>
      <div className=%twc("overflow-hidden")>
        <Swiper.Root
          loop=false
          modules=[Swiper.autoPlay, Swiper.navigation]
          className=%twc("pc-review-swiper")
          autoplay={"delay": 5000}
          slidesOffsetBefore=50
          slidesOffsetAfter=50
          spaceBetween=16
          slidesPerView="auto"
          navigation={
            "prevEl": prevRefState,
            "nextEl": nextRefState,
          }>
          {reviews
          ->Array.map(review => {
            <Swiper.Slide>
              <PC_Review_Card_Buyer
                title={`${review.category.name}, ${review.totalAmount->Float.toString}${switch review.amountUnit {
                  | #G => "g"
                  | #KG => "kg"
                  | #T => "T"
                  | #EA => "EA"
                  | #ML => "ML"
                  | #L => "L"
                  | _ => ""
                  }}`}
                content={review.content}
                profile={review.businessSector}
                date={review.purchasedAt->Js.Date.fromString->DateFns.format("yyyy.MM.dd")}
                profileImage=?{review.profileImageUrl}
                productScore={review.productScore->Float.toInt}
                shippingScore={review.shippingScore->Float.toInt}
              />
            </Swiper.Slide>
          })
          ->React.array}
        </Swiper.Root>
        <div
          className=%twc(
            "flex w-[1336px] absolute z-[2] top-[50%] -translate-y-[50%] justify-between -translate-x-[28px] pointer-events-none"
          )>
          <div
            className=%twc(
              "w-14 h-14 rounded-full shadow-[0px_2px_12px_2px_rgba(0,0,0,0.08)] bg-white rotate-180 inline-flex justify-center items-center cursor-pointer pointer-events-auto hover:bg-[#f4f4f4] active:bg-[#e9e9e9] ease-in-out duration-200"
            )
            ref={ReactDOM.Ref.domRef(prevRef)}>
            <IconArrow width="32px" height="32px" fill="#8B8D94" />
          </div>
          <div
            className=%twc(
              "w-14 h-14 rounded-full shadow-[0px_2px_12px_2px_rgba(0,0,0,0.08)] bg-white rotate-180 inline-flex justify-center items-center cursor-pointer pointer-events-auto hover:bg-[#f4f4f4] active:bg-[#e9e9e9] ease-in-out duration-200"
            )
            ref={ReactDOM.Ref.domRef(nextRef)}>
            <IconArrow width="32px" height="32px" fill="#8B8D94" className=%twc("rotate-180") />
          </div>
        </div>
      </div>
    </div>
  </div>
}
