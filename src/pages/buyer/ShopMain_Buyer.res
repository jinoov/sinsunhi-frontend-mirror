/*
 * 1. 컴포넌트 위치
 *    바이어 메인 페이지
 *
 * 2. 역할
 *    신선하이 대문
 *
 * 3. 특이사항
 *    데이터를 가져오는 쿼리를
 *    페이지 루트레벨에서 한벌로 처리하면, request는 한번만 간다는 장점이 있지만
 *    가장 늦게 응답하는 쿼리 기준으로 모든 데이터의 응답속도가 하향평준화 된다는 단점이 있다. (단일 요청으로 처리하였기 때문에)
 *    메인페이지 하단의 특별기획전 상품리스트 데이터를 만들어내기 위한 컴퓨팅 비용이 비싸므로,
 *    단일요청으로 처리하여 오래 기다리는것보다, 각자 별도의 쿼리로 처리하여, 먼저 보여줄 수 있는 데이터는 먼저 보여주도록 한다.
 */

module Placeholder = {
  @react.component
  let make = (~deviceType) => {
    switch deviceType {
    | DeviceDetect.Unknown => React.null
    | DeviceDetect.Mobile => <ShopMainSpecialShowcaseList_Buyer.MO.Placeholder />
    | DeviceDetect.PC => <ShopMainSpecialShowcaseList_Buyer.PC.Placeholder />
    }
  }
}

module PC = {
  @react.component
  let make = () => {
    let router = Next.Router.useRouter()

    let isCsr = CustomHooks.useCsr()

    <div className=%twc("w-full min-w-[1280px] min-h-screen")>
      <Header_Buyer.PC key=router.asPath />
      <main className=%twc("w-full bg-white pt-12 pb-20")>
        <div className=%twc("w-[1280px] mx-auto")>
          <div className=%twc("flex px-5")>
            <div className=%twc("w-[920px]")>
              // 메인배너
              <RescriptReactErrorBoundary
                fallback={_ => <ShopMain_MainBanner_Buyer.PC.Placeholder />}>
                <React.Suspense fallback={<ShopMain_MainBanner_Buyer.PC.Placeholder />}>
                  <ShopMain_MainBanner_Buyer.PC />
                </React.Suspense>
              </RescriptReactErrorBoundary>
            </div>
            <div className=%twc("ml-5 w-[310px]")>
              // 서브배너
              <RescriptReactErrorBoundary
                fallback={_ => <ShopMain_SubBanner_Buyer.PC.Placeholder />}>
                <React.Suspense fallback={<ShopMain_SubBanner_Buyer.PC.Placeholder />}>
                  <ShopMain_SubBanner_Buyer.PC />
                </React.Suspense>
              </RescriptReactErrorBoundary>
            </div>
          </div>
          <div className=%twc("w-full mt-20")>
            // 카테고리
            <RescriptReactErrorBoundary
              fallback={_ => <ShopMain_CategoryList_Buyer.PC.Placeholder />}>
              <React.Suspense fallback={<ShopMain_CategoryList_Buyer.PC.Placeholder />}>
                <ShopMain_CategoryList_Buyer.PC />
              </React.Suspense>
            </RescriptReactErrorBoundary>
          </div>
        </div>
      </main>
      // 특별기획전 상품리스트
      {switch isCsr {
      | true =>
        <RescriptReactErrorBoundary
          fallback={_ => <ShopMainSpecialShowcaseList_Buyer.PC.Placeholder />}>
          <React.Suspense fallback={<ShopMainSpecialShowcaseList_Buyer.PC.Placeholder />}>
            <ShopMainSpecialShowcaseList_Buyer.PC />
          </React.Suspense>
        </RescriptReactErrorBoundary>
      | false => <ShopMainSpecialShowcaseList_Buyer.PC.Placeholder />
      }}
      <Footer_Buyer.PC />
    </div>
  }
}

module MO = {
  @react.component
  let make = (~deviceType) => {
    let router = Next.Router.useRouter()

    let isCsr = CustomHooks.useCsr()

    <div className=%twc("w-full min-h-screen")>
      <div className=%twc("w-full bg-white")>
        <div className=%twc("w-full max-w-3xl mx-auto bg-white min-h-screen")>
          <Header_Buyer.Mobile.GnbHome key=router.asPath />
          <div className=%twc("w-full p-3 bg-white sticky top-0 z-10")>
            <ShopMainSearchInput_Buyer/>
          </div>
          <div className=%twc("w-full flex flex-col bg-white pb-16")>
            <section className=%twc("w-full px-5")>
              <div className=%twc("mt-5")>
                // 메인배너
                <RescriptReactErrorBoundary
                  fallback={_ => <ShopMain_MainBanner_Buyer.MO.Placeholder />}>
                  <React.Suspense fallback={<ShopMain_MainBanner_Buyer.MO.Placeholder />}>
                    <ShopMain_MainBanner_Buyer.MO />
                  </React.Suspense>
                </RescriptReactErrorBoundary>
              </div>
              <div className=%twc("mt-3")>
                // 서브배너
                <RescriptReactErrorBoundary
                  fallback={_ => <ShopMain_SubBanner_Buyer.MO.Placeholder />}>
                  <React.Suspense fallback={<ShopMain_SubBanner_Buyer.MO.Placeholder />}>
                    <ShopMain_SubBanner_Buyer.MO />
                  </React.Suspense>
                </RescriptReactErrorBoundary>
              </div>
            </section>
            <section className=%twc("w-full mt-12")>
              // 카테고리
              <RescriptReactErrorBoundary
                fallback={_ => <ShopMain_CategoryList_Buyer.MO.Placeholder />}>
                <React.Suspense fallback={<ShopMain_CategoryList_Buyer.MO.Placeholder />}>
                  <ShopMain_CategoryList_Buyer.MO />
                </React.Suspense>
              </RescriptReactErrorBoundary>
            </section>
            // 특별기획전 상품리스트
            {switch isCsr {
            | true =>
              <RescriptReactErrorBoundary
                fallback={_ => <ShopMainSpecialShowcaseList_Buyer.MO.Placeholder />}>
                <React.Suspense fallback={<ShopMainSpecialShowcaseList_Buyer.MO.Placeholder />}>
                  <ShopMainSpecialShowcaseList_Buyer.MO />
                </React.Suspense>
              </RescriptReactErrorBoundary>

            | false => <ShopMainSpecialShowcaseList_Buyer.MO.Placeholder />
            }}
          </div>
        </div>
      </div>
      <Bottom_Navbar deviceType />
    </div>
  }
}

module Container = {
  @react.component
  let make = (~deviceType) => {
    // 채널톡 버튼 사용
    ChannelTalkHelper.Hook.use()

    switch deviceType {
    | DeviceDetect.Unknown => React.null
    | DeviceDetect.PC => <PC />
    | DeviceDetect.Mobile => <MO deviceType/>
    }
  }
}

@react.component
let make = (~deviceType) => {
  // RN일 경우 Airbridge에 이벤트를 전송한다
  React.useEffect0(_ => {
    Global.Window.ReactNativeWebView.PostMessage.airbridgeWithPayload(~kind=#VIEW_HOME, ())
    None
  })

  <>
    <Next.Head>
      <title> {`신선하이 | 농산물 소싱 온라인 플랫폼`->React.string} </title>
      <meta
        name="description"
        content="농산물 소싱은 신선하이에서! 전국 70만 산지농가의 우수한 농산물을 싸고 편리하게 공급합니다. 국내 유일한 농산물 B2B 플랫폼 신선하이와 함께 매출을 올려보세요."
      />
    </Next.Head>
    <OpenGraph_Header
      title="신선하이 | 농산물 소싱 온라인 플랫폼"
      description="농산물 소싱은 신선하이에서! 전국 70만 산지농가의 우수한 농산물을 싸고 편리하게 공급합니다. 국내 유일한 농산물 B2B 플랫폼 신선하이와 함께 매출을 올려보세요."
    />
    <RescriptReactErrorBoundary fallback={_ => <Placeholder deviceType />}>
      <React.Suspense fallback={<Placeholder deviceType />}>
        <Container deviceType />
      </React.Suspense>
    </RescriptReactErrorBoundary>
  </>
}
