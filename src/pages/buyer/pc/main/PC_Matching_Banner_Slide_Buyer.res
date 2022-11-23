%%raw(`import 'swiper/css'`)
%%raw(`import 'swiper/css/autoplay'`)

let bannerCdnUrl = `${Env.s3PublicUrl}/banner/`

@react.component
let make = () =>
  <Swiper.Root
    allowTouchMove=false
    loop=true
    modules=[Swiper.autoPlay]
    autoplay={"delay": 2000, "disableOnInteraction": false}
    className=%twc("rounded-sm overflow-hidden")>
    <Swiper.Slide>
      <div className=%twc("w-full h-[300px] relative")>
        <Next.Image
          src={bannerCdnUrl ++ `pc-matching-main-bg1.png`}
          alt="농산"
          layout=#fill
          objectFit=#cover
          priority=true
        />
      </div>
    </Swiper.Slide>
    <Swiper.Slide>
      <div className=%twc("w-full h-[300px] relative")>
        <Next.Image
          src={bannerCdnUrl ++ `pc-matching-main-bg2.png`}
          alt="수산"
          layout=#fill
          objectFit=#cover
          priority=true
        />
      </div>
    </Swiper.Slide>
    <Swiper.Slide>
      <div className=%twc("w-full h-[300px] relative")>
        <Next.Image
          src={bannerCdnUrl ++ `pc-matching-main-bg3.png`}
          alt="축산"
          layout=#fill
          objectFit=#cover
          priority=true
        />
      </div>
    </Swiper.Slide>
  </Swiper.Root>
