module Fragment = %relay(`
  fragment MOQuickBannerBuyerFragment on Query {
    mainBanners {
      id
      imageUrlMobile
      isNewTabMobile
      landingUrl
    }
  }
`)

%%raw(`import 'swiper/css'`)
%%raw(`import 'swiper/css/autoplay'`)
%%raw(`import 'swiper/css/pagination'`)

@react.component
let make = (~query) => {
  let {mainBanners: banners} = Fragment.use(query)

  <Swiper.Root
    loop=true
    modules=[Swiper.autoPlay, Swiper.pagination]
    pagination={
      "type": "bullets",
    }
    className="direct-swiper"
    tag="section"
    autoplay={"delay": 3000, "disableOnInteraction": false}>
    {banners
    ->Array.map(banner => {
      <Swiper.Slide key=banner.id>
        <div className=%twc("w-full relative aspect-[360/260] overflow-hidden ")>
          <Next.Link href={banner.landingUrl}>
            <a rel="noopener" target={banner.isNewTabMobile ? "_blank" : ""}>
              <Next.Image
                src={banner.imageUrlMobile}
                alt="신선하이 즉시구매"
                layout=#fill
                objectFit=#cover
                priority=true
              />
            </a>
          </Next.Link>
        </div>
      </Swiper.Slide>
    })
    ->React.array}
  </Swiper.Root>
}
