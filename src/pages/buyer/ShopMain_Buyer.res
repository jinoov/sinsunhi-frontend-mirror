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
  let make = (
    ~deviceType,
    ~gnbBanners,
    ~mainBanners,
    ~subBanners,
    ~categories,
    ~displayCategories,
  ) => {
    let router = Next.Router.useRouter()

    let isCsr = CustomHooks.useCsr()

    <div className=%twc("w-full min-w-[1280px] min-h-screen")>
      <Header_Buyer.PC key=router.asPath gnbBanners displayCategories />
      <main className=%twc("w-full bg-white pt-12 pb-20")>
        <div className=%twc("w-[1280px] mx-auto")>
          <div className=%twc("flex px-5")>
            <div className=%twc("w-[920px]")>
              // 메인배너
              <ShopMain_MainBanner_Buyer.PC mainBanners />
            </div>
            <div className=%twc("ml-5 w-[310px]")>
              // 서브배너
              <ShopMain_SubBanner_Buyer.PC subBanners />
            </div>
          </div>
          <div className=%twc("w-full mt-20")>
            // 카테고리
            <ShopMain_CategoryList_Buyer.PC categories />
          </div>
        </div>
      </main>
      {
        // 특별기획전 상품리스트
        switch isCsr {
        | true =>
          <RescriptReactErrorBoundary
            fallback={_ => <ShopMainSpecialShowcaseList_Buyer.PC.Placeholder />}>
            <React.Suspense fallback={<ShopMainSpecialShowcaseList_Buyer.PC.Placeholder />}>
              <ShopMainSpecialShowcaseList_Buyer.PC />
            </React.Suspense>
          </RescriptReactErrorBoundary>
        | false => <Placeholder deviceType />
        }
      }
      <Footer_Buyer.PC />
    </div>
  }
}

module MO = {
  @react.component
  let make = (
    ~deviceType,
    ~gnbBanners,
    ~mainBanners,
    ~subBanners,
    ~categories,
    ~displayCategories,
  ) => {
    let router = Next.Router.useRouter()

    let isCsr = CustomHooks.useCsr()

    <div className=%twc("w-full min-h-screen")>
      <div className=%twc("w-full bg-white")>
        <div className=%twc("w-full max-w-3xl mx-auto bg-white min-h-screen")>
          <Header_Buyer.Mobile.GnbHome key=router.asPath gnbBanners displayCategories />
          <div className=%twc("w-full p-3 pt-1 bg-white sticky top-0 z-10")>
            <ShopSearchInput_Buyer.MO />
          </div>
          <div className=%twc("w-full flex flex-col bg-white pb-16")>
            <section className=%twc("w-full px-5")>
              <div className=%twc("mt-5")>
                // 메인배너
                <ShopMain_MainBanner_Buyer.MO mainBanners />
              </div>
              <div className=%twc("mt-3")>
                // 서브배너
                <ShopMain_SubBanner_Buyer.MO subBanners />
              </div>
            </section>
            <section className=%twc("w-full mt-12")>
              // 카테고리
              <ShopMain_CategoryList_Buyer.MO categories />
            </section>
            {
              // 특별기획전 상품리스트
              switch isCsr {
              | true =>
                <RescriptReactErrorBoundary
                  fallback={_ => <ShopMainSpecialShowcaseList_Buyer.MO.Placeholder />}>
                  <React.Suspense fallback={<ShopMainSpecialShowcaseList_Buyer.MO.Placeholder />}>
                    <ShopMainSpecialShowcaseList_Buyer.MO />
                  </React.Suspense>
                </RescriptReactErrorBoundary>
              | false => <Placeholder deviceType />
              }
            }
          </div>
          <Footer_Buyer.MO />
        </div>
      </div>
    </div>
  }
}

module Container = {
  @react.component
  let make = (
    ~deviceType,
    ~gnbBanners,
    ~mainBanners,
    ~subBanners,
    ~categories,
    ~displayCategories,
  ) => {
    // 채널톡 버튼 사용
    ChannelTalkHelper.Hook.use()

    switch deviceType {
    | DeviceDetect.Unknown => React.null
    | DeviceDetect.PC =>
      <PC deviceType gnbBanners mainBanners subBanners categories displayCategories />
    | DeviceDetect.Mobile =>
      <MO deviceType gnbBanners mainBanners subBanners categories displayCategories />
    }
  }
}

@react.component
let make = (
  ~deviceType,
  ~gnbBanners,
  ~mainBanners,
  ~subBanners,
  ~categories,
  ~displayCategories,
) => {
  // RN일 경우 Airbridge에 이벤트를 전송한다
  React.useEffect0(_ => {
    Global.Window.ReactNativeWebView.PostMessage.airbridgeWithPayload(~kind=#VIEW_HOME, ())
    None
  })

  <>
    <Next.Head> <title> {`신선하이`->React.string} </title> </Next.Head>
    <RescriptReactErrorBoundary fallback={_ => <Placeholder deviceType />}>
      <React.Suspense fallback={<Placeholder deviceType />}>
        <Container deviceType gnbBanners mainBanners subBanners categories displayCategories />
      </React.Suspense>
    </RescriptReactErrorBoundary>
  </>
}
