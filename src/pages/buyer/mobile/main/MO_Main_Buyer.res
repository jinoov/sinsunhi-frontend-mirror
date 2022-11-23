module Tab = MO_Main_Tabs_Buyer

module Query = %relay(`
  query MOMainBuyer_Query {
    ...MOMainReviewCarouselBuyer_Fragment
    ...MOQuickBannerBuyerFragment
  }
`)

module Container = {
  @react.component
  let make = () => {
    let {fragmentRefs} = Query.use(~variables=(), ())

    // RN일 경우 Airbridge에 이벤트를 전송한다
    React.useEffect0(_ => {
      Global.Window.ReactNativeWebView.PostMessage.airbridgeWithPayload(~kind=#VIEW_HOME, ())
      None
    })

    // 채널톡 버튼 사용
    ChannelTalkHelper.Hook.use()

    <div className=%twc("w-full min-h-screen")>
      <div className=%twc("w-full bg-white")>
        <div className=%twc("w-full max-w-3xl mx-auto bg-white min-h-screen")>
          <MO_Headers_Buyer.Main />
          <MO_Main_Tabs_Buyer
            matching={<MO_Matching_Main_Buyer query={fragmentRefs} />}
            quick={<MO_Quick_Main_Buyer query={fragmentRefs} />}
          />
          <Bottom_Navbar deviceType={DeviceDetect.Mobile} />
        </div>
      </div>
    </div>
  }
}

@react.component
let make = () => {
  <>
    <Next.Head>
      <title> {`신선하이 | 농산물 소싱 온라인 플랫폼`->React.string} </title>
      <meta
        name="description"
        content="농산물 소싱은 신선하이에서! 전국 70만 산지농가의 우수한 농산물을 싸고 편리하게 공급합니다. 국내 유일한 농산물 B2B 플랫폼 신선하이와 함께 매출을 올려보세요."
      />
    </Next.Head>
    <AppLink_Header />
    <OpenGraph_Header
      title="신선하이 | 농산물 소싱 온라인 플랫폼"
      description="농산물 소싱은 신선하이에서! 전국 70만 산지농가의 우수한 농산물을 싸고 편리하게 공급합니다. 국내 유일한 농산물 B2B 플랫폼 신선하이와 함께 매출을 올려보세요."
    />
    <RescriptReactErrorBoundary fallback={_ => React.null}>
      <React.Suspense fallback={React.null}>
        <Container />
      </React.Suspense>
    </RescriptReactErrorBoundary>
  </>
}

module ServerSideWithParamQuery = %relay(`
query MOMainBuyerServerSideWithParamQuery($marketPriceDiffFilter: MarketPriceDiffFilter!){
    ...MOMainReviewCarouselBuyer_Fragment
    ...MOAuctionPriceListBuyerFragment@arguments(count: 20, marketPriceDiffFilter: $marketPriceDiffFilter )
    ...MOQuickBannerBuyerFragment
      mainDisplayCategories(onlyDisplayable: true) {
      id
      image {
        original
      }
      name
    }
  }
`)

module ServerSideQuery = %relay(`
 query MOMainBuyerServerSideQuery {
    ...MOMainReviewCarouselBuyer_Fragment
    ...MOQuickBannerBuyerFragment
    mainDisplayCategories(onlyDisplayable: true) {
      id
      image {
        original
      }
      name
    }
  } 
`)
