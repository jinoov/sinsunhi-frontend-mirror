module Fragment = %relay(`
  fragment PCQuickBannerSlideBuyerFragment on Query {
    mainBanners {
      id
      imageUrlPc
      landingUrl
    }
  }
`)

%%raw(`import 'swiper/css'`)
%%raw(`import 'swiper/css/autoplay'`)
%%raw(`import 'swiper/css/pagination'`)

module Skeleton = {
  @react.component
  let make = () => {
    <div className=%twc("bg-slate-100 h-[300px] w-full animate-pulse") />
  }
}

@react.component
let make = (~query) => {
  let {mainBanners: banners} = Fragment.use(query)
  let nextRef = React.useRef(Js.Nullable.null)
  let prevRef = React.useRef(Js.Nullable.null)

  let arrow = %twc(
    "w-14 h-14 rounded-full flex items-center justify-center shadow-[0px_2px_12px_2px_rgba(0,0,0,0.08)] bg-white"
  )
  let position = %twc("absolute z-[2] top-1/2 -translate-y-1/2")

  <section className=%twc("relative w-full")>
    <Swiper.Root
      allowTouchMove=false
      loop=true
      modules=[Swiper.autoPlay, Swiper.navigation, Swiper.pagination]
      autoplay={"delay": 2000}
      className=%twc("rounded-sm overflow-hidden pc-swiper")
      pagination={
        "type": "bullets",
      }
      navigation={
        "prevEl": prevRef.current,
        "nextEl": nextRef.current,
      }>
      {banners
      ->Array.map(({landingUrl, imageUrlPc}) => {
        <Swiper.Slide>
          <Next.Link href=landingUrl passHref=true>
            <a>
              <div className=%twc("w-full h-[300px] relative")>
                <Next.Image
                  src={imageUrlPc}
                  alt="배경 이미지1"
                  layout=#fill
                  objectFit=#cover
                  priority=true
                />
              </div>
            </a>
          </Next.Link>
        </Swiper.Slide>
      })
      ->React.array}
    </Swiper.Root>
    <button
      ref={ReactDOM.Ref.domRef(prevRef)}
      className={cx([arrow, position, %twc("-left-7 rotate-180")])}>
      <IconArrow width="32px" height="32px" fill="#8B8D94" />
    </button>
    <button ref={ReactDOM.Ref.domRef(nextRef)} className={cx([arrow, position, %twc("-right-7")])}>
      <IconArrow width="32px" height="32px" fill="#8B8D94" />
    </button>
  </section>
}
