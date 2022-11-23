%%raw(`import 'swiper/css'`)
%%raw(`import 'swiper/css/autoplay'`)

let bannerCdnUrl = `${Env.s3PublicUrl}/banner/`

@react.component
let make = () =>
  <Swiper.Root allowTouchMove=false loop=true modules=[Swiper.autoPlay] autoplay={"delay": 2000}>
    <Swiper.Slide>
      <div className=%twc("w-full h-[260px] relative")>
        <Next.Image
          src={bannerCdnUrl ++ "mobile-matching-main-bg1.png"}
          alt="농산 사진"
          layout=#fill
          objectFit=#cover
          priority=true
        />
      </div>
    </Swiper.Slide>
    <Swiper.Slide>
      <div className=%twc("w-full h-[260px] relative")>
        <Next.Image
          src={bannerCdnUrl ++ "mobile-matching-main-bg2.png"}
          alt="수산 사진"
          layout=#fill
          objectFit=#cover
          priority=true
        />
      </div>
    </Swiper.Slide>
    <Swiper.Slide>
      <div className=%twc("w-full h-[260px] relative")>
        <Next.Image
          src={bannerCdnUrl ++ "mobile-matching-main-bg3.png"}
          alt="축산 사진"
          layout=#fill
          objectFit=#cover
          priority=true
        />
      </div>
    </Swiper.Slide>
  </Swiper.Root>
