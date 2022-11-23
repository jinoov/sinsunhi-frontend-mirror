module Fragment = %relay(`
    fragment MOMainReviewCarouselBuyer_Fragment on Query {
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
%%raw(`import 'swiper/css/pagination'`)

@react.component
let make = (~query) => {
  let {reviews} = Fragment.use(query)

  <div className=%twc("pt-[30px] pb-[14px] bg-[#F6F7F9]")>
    <h2 className=%twc("font-bold text-[19px] text-enabled-L1 pl-4")>
      {"거래후기"->React.string}
    </h2>
    <Swiper.Root
      loop=false
      modules=[Swiper.autoPlay]
      className=%twc("review-swiper")
      autoplay={"delay": 5000, "disableOnInteraction": false}
      slidesOffsetBefore=16
      slidesOffsetAfter=16
      spaceBetween=8
      slidesPerView="auto">
      {reviews
      ->Array.map(review => {
        <Swiper.Slide>
          <MO_Review_Card_Buyer
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
  </div>
}
