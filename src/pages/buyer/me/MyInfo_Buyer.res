module Query = %relay(`
  query MyInfoBuyer_Query($from: String!, $to: String!) {
    viewer {
      ...MyInfoProfileSummaryBuyer_Fragment
      ...MyInfoProcessingOrderBuyer_Fragment @arguments(from: $from, to: $to)
      ...MyInfoCashRemainBuyer_Fragment
      ...MyInfoProfileCompleteBuyer_Fragment
    }
  }
`)

module PC = {
  @react.component
  let make = () => {
    let to = Js.Date.make()
    let from = to->DateFns.subMonths(1)

    let queryData = Query.use(
      ~variables={from: from->DateFns.format("yyyyMMdd"), to: to->DateFns.format("yyyyMMdd")},
      (),
    )

    switch queryData.viewer {
    | Some({fragmentRefs: query}) => {
        let oldUI =
          <MyInfo_Layout_Buyer query>
            <div className=%twc("ml-4 flex flex-col w-full items-stretch")>
              <div className=%twc("w-full bg-white")>
                <MyInfo_Cash_Remain_Buyer.PC query />
              </div>
              <div className=%twc("w-full mt-4 bg-white")>
                <MyInfo_Processing_Order_Buyer.PC query />
              </div>
              <MyInfo_Profile_Complete_Buyer.PC query />
            </div>
          </MyInfo_Layout_Buyer>

        <FeatureFlagWrapper featureFlag=#HOME_UI_UX fallback=oldUI>
          <MyInfo_Layout_Buyer query>
            <div className=%twc("flex flex-col w-full mb-14")>
              <div
                className=%twc(
                  "w-full rounded-sm bg-white shadow-[0px_10px_40px_10px_rgba(0,0,0,0.03)] mb-4 px-[50px] pt-10 pb-5"
                )>
                <div className=%twc("flex flex-col")>
                  <Formula.Text className=%twc("mb-[15px]") variant=#headline size=#lg weight=#bold>
                    {"마이홈"->React.string}
                  </Formula.Text>
                  <MyInfo_ProfileSummary_Buyer.PC query />
                </div>
              </div>
              <div
                className=%twc(
                  "w-full rounded-sm bg-white shadow-[0px_10px_40px_10px_rgba(0,0,0,0.03)] mb-4 px-[22px]"
                )>
                <MyInfo_Cash_Remain_Buyer.PC query />
              </div>
              <div
                className=%twc(
                  "w-full rounded-sm bg-white shadow-[0px_10px_40px_10px_rgba(0,0,0,0.03)] mb-4 px-[26px]"
                )>
                <MyInfo_Processing_Order_Buyer.PC query />
              </div>
              <MyInfo_Profile_Complete_Buyer.PC query />
            </div>
          </MyInfo_Layout_Buyer>
        </FeatureFlagWrapper>
      }

    | None => <MyInfo_Skeleton_Buyer.PC />
    }
  }
}
module Mobile = {
  module Main = {
    @react.component
    let make = (~query) => {
      <section>
        <div className=%twc("px-5 pt-5 pb-6")>
          <div className=%twc("mb-10")>
            <MyInfo_ProfileSummary_Buyer.Mobile query />
          </div>
          <div className=%twc("mb-12")>
            <MyInfo_Cash_Remain_Buyer.Mobile query />
          </div>
          <div className=%twc("mb-12")>
            <MyInfo_Processing_Order_Buyer.Mobile query />
          </div>
          <MyInfo_Profile_Complete_Buyer.Mobile query />
        </div>
        <div className=%twc("h-3 bg-gray-100") />
      </section>
    }
  }
  @react.component
  let make = () => {
    let to = Js.Date.make()
    let from = to->DateFns.subMonths(1)

    let queryData = Query.use(
      ~variables={from: from->DateFns.format("yyyyMMdd"), to: to->DateFns.format("yyyyMMdd")},
      (),
    )

    switch queryData.viewer {
    | Some(viewer) =>
      <div className=%twc("w-full bg-white absolute top-0 pt-14 min-h-screen")>
        <div className=%twc("w-full max-w-3xl mx-auto bg-white h-full")>
          <div>
            <div className=%twc("flex flex-col")>
              <Main query={viewer.fragmentRefs} />
              <section className=%twc("px-4 mb-[60px]")>
                <ol>
                  <Next.Link href="/buyer/me/account">
                    <li
                      className=%twc(
                        "py-5 flex justify-between items-center border-b border-gray-100"
                      )>
                      <span className=%twc("font-bold")> {`계정정보`->React.string} </span>
                      <IconArrow height="16" width="16" fill="#B2B2B2" />
                    </li>
                  </Next.Link>
                  <Next.Link href="/buyer/upload">
                    <li
                      className=%twc(
                        "py-5 flex justify-between items-center border-b border-gray-100"
                      )>
                      <span className=%twc("font-bold")>
                        {`주문서 업로드`->React.string}
                      </span>
                      <IconArrow height="16" width="16" fill="#B2B2B2" />
                    </li>
                  </Next.Link>
                  <Next.Link href="/buyer/orders">
                    <li
                      className=%twc(
                        "py-5 flex justify-between items-center border-b border-gray-100"
                      )>
                      <span className=%twc("font-bold")> {`주문 내역`->React.string} </span>
                      <IconArrow height="16" width="16" fill="#B2B2B2" />
                    </li>
                  </Next.Link>
                  <Next.Link href="/buyer/transactions">
                    <li
                      className=%twc(
                        "py-5 flex justify-between items-center border-b border-gray-100"
                      )>
                      <span className=%twc("font-bold")> {`결제 내역`->React.string} </span>
                      <IconArrow height="16" width="16" fill="#B2B2B2" />
                    </li>
                  </Next.Link>
                  <Next.Link href="/products/advanced-search">
                    <li
                      className=%twc(
                        "py-5 flex justify-between items-center border-b border-gray-100"
                      )>
                      <span className=%twc("font-bold")> {`단품 확인`->React.string} </span>
                      <IconArrow height="16" width="16" fill="#B2B2B2" />
                    </li>
                  </Next.Link>
                  <Next.Link href="/buyer/me/like?mode=VIEW">
                    <li
                      className=%twc(
                        "py-5 flex justify-between items-center border-b border-gray-100"
                      )>
                      <span className=%twc("font-bold")> {`찜한 상품`->React.string} </span>
                      <IconArrow height="16" width="16" fill="#B2B2B2" />
                    </li>
                  </Next.Link>
                  <Next.Link href="/buyer/me/recent-view?mode=VIEW">
                    <li
                      className=%twc(
                        "py-5 flex justify-between items-center border-b border-gray-100"
                      )>
                      <span className=%twc("font-bold")> {`최근 본 상품`->React.string} </span>
                      <IconArrow height="16" width="16" fill="#B2B2B2" />
                    </li>
                  </Next.Link>
                  <Next.Link href="/buyer/download-center">
                    <li
                      className=%twc(
                        "py-5 flex justify-between items-center border-b border-gray-100"
                      )>
                      <span className=%twc("font-bold")>
                        {`다운로드 센터`->React.string}
                      </span>
                      <IconArrow height="16" width="16" fill="#B2B2B2" />
                    </li>
                  </Next.Link>
                  <Next.Link
                    href="https://drive.google.com/drive/u/0/folders/1DbaGUxpkYnJMrl4RPKRzpCqTfTUH7bYN">
                    <a target="_blank" rel="noopener">
                      <li
                        className=%twc(
                          "py-5 flex justify-between items-center border-b border-gray-100"
                        )>
                        <span className=%twc("font-bold")>
                          {`판매자료 다운로드`->React.string}
                        </span>
                        <IconArrow height="16" width="16" fill="#B2B2B2" />
                      </li>
                    </a>
                  </Next.Link>
                  <Next.Link href="https://shinsunmarket.co.kr/532">
                    <a target="_blank">
                      <li
                        className=%twc(
                          "py-5 flex justify-between items-center border-b border-gray-100"
                        )>
                        <span className=%twc("font-bold")> {`공지사항`->React.string} </span>
                        <IconArrow height="16" width="16" fill="#B2B2B2" />
                      </li>
                    </a>
                  </Next.Link>
                  <li
                    className=%twc(
                      "py-5 flex justify-between items-center border-b border-gray-100"
                    )
                    onClick={_ => ChannelTalk.showMessenger()}>
                    <span className=%twc("font-bold")> {`1:1 문의하기`->React.string} </span>
                    <IconArrow height="16" width="16" fill="#B2B2B2" />
                  </li>
                </ol>
              </section>
            </div>
          </div>
        </div>
      </div>
    | None => React.null
    }
  }
}

type props = {deviceType: DeviceDetect.deviceType}
type params
type previewData

// props를 구조분해 해줘야 함
let default = ({deviceType}) => {
  let router = Next.Router.useRouter()

  {
    switch deviceType {
    | DeviceDetect.PC => {
        let oldUI =
          <div className=%twc("w-full min-h-screen")>
            <Header_Buyer.PC key=router.asPath />
            <Authorization.Buyer ssrFallback={<MyInfo_Skeleton_Buyer.PC />}>
              <RescriptReactErrorBoundary
                fallback={_ =>
                  <div>
                    {`계정정보를 가져오는데 실패했습니다`->React.string}
                  </div>}>
                <React.Suspense fallback={<MyInfo_Skeleton_Buyer.PC />}>
                  <PC />
                </React.Suspense>
              </RescriptReactErrorBoundary>
            </Authorization.Buyer>
            <Footer_Buyer.PC />
          </div>
        <FeatureFlagWrapper featureFlag=#HOME_UI_UX fallback=oldUI>
          <div className=%twc("w-full min-h-screen bg-[#F0F2F5]")>
            <Header_Buyer.PC key=router.asPath />
            <Authorization.Buyer ssrFallback={<MyInfo_Skeleton_Buyer.PC />}>
              <RescriptReactErrorBoundary
                fallback={_ =>
                  <div>
                    {`계정정보를 가져오는데 실패했습니다`->React.string}
                  </div>}>
                <React.Suspense fallback={<MyInfo_Skeleton_Buyer.PC />}>
                  <PC />
                </React.Suspense>
              </RescriptReactErrorBoundary>
            </Authorization.Buyer>
            <Footer_Buyer.PC />
          </div>
        </FeatureFlagWrapper>
      }

    | DeviceDetect.Unknown
    | DeviceDetect.Mobile =>
      <div className=%twc("w-full min-h-screen")>
        <Header_Buyer.Mobile key=router.asPath />
        <Authorization.Buyer ssrFallback={<MyInfo_Skeleton_Buyer.Mobile.Main />}>
          <RescriptReactErrorBoundary
            fallback={_ =>
              <div> {`계정정보를 가져오는데 실패했습니다`->React.string} </div>}>
            <React.Suspense fallback={<MyInfo_Skeleton_Buyer.Mobile.Main />}>
              <Mobile />
            </React.Suspense>
          </RescriptReactErrorBoundary>
        </Authorization.Buyer>
        <Bottom_Navbar deviceType />
      </div>
    }
  }
}

let getServerSideProps = (ctx: Next.GetServerSideProps.context<props, params, previewData>) => {
  open ServerSideHelper
  let environment = SinsunMarket(Env.graphqlApiUrl)->RelayEnv.environment
  let gnbAndCategoryQuery = environment->gnbAndCategory

  let deviceType = DeviceDetect.detectDeviceFromCtx2(ctx.req)

  gnbAndCategoryQuery->makeResultWithQuery(~environment, ~extraProps={"deviceType": deviceType})
}
