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
    | Some({fragmentRefs: query}) =>
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
    | None => React.null
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

type props = {
  deviceType: DeviceDetect.deviceType,
  gnbBanners: array<GnbBannerListBuyerQuery_graphql.Types.response_gnbBanners>,
  displayCategories: array<ShopCategorySelectBuyerQuery_graphql.Types.response_displayCategories>,
}
type params
type previewData

// props를 구조분해 해줘야 함
let default = ({deviceType, gnbBanners, displayCategories}) => {
  let router = Next.Router.useRouter()

  <div className=%twc("w-full min-h-screen")>
    {switch deviceType {
    | DeviceDetect.PC =>
      <>
        <div className=%twc("flex")>
          <Header_Buyer.PC key=router.asPath gnbBanners displayCategories />
        </div>
        <Authorization.Buyer title={`신선하이`} ssrFallback={<MyInfo_Skeleton_Buyer.PC />}>
          <RescriptReactErrorBoundary
            fallback={_ =>
              <div> {`계정정보를 가져오는데 실패했습니다`->React.string} </div>}>
            <React.Suspense fallback={<MyInfo_Skeleton_Buyer.PC />}>
              <PC />
            </React.Suspense>
          </RescriptReactErrorBoundary>
        </Authorization.Buyer>
        <Footer_Buyer.PC />
      </>
    | DeviceDetect.Unknown
    | DeviceDetect.Mobile =>
      <>
        <Header_Buyer.Mobile key=router.asPath />
        <Authorization.Buyer
          title={`신선하이`} ssrFallback={<MyInfo_Skeleton_Buyer.Mobile.Main />}>
          <RescriptReactErrorBoundary
            fallback={_ =>
              <div> {`계정정보를 가져오는데 실패했습니다`->React.string} </div>}>
            <React.Suspense fallback={<MyInfo_Skeleton_Buyer.Mobile.Main />}>
              <Mobile />
            </React.Suspense>
          </RescriptReactErrorBoundary>
        </Authorization.Buyer>
      </>
    }}
  </div>
}

let getServerSideProps = (ctx: Next.GetServerSideProps.context<props, params, previewData>) => {
  let deviceType = DeviceDetect.detectDeviceFromCtx2(ctx.req)

  let gnb = () =>
    GnbBannerList_Buyer.Query.fetchPromised(
      ~environment=RelayEnv.envSinsunMarket,
      ~variables=(),
      (),
    )
  let displayCategories = () =>
    ShopCategorySelect_Buyer.Query.fetchPromised(
      ~environment=RelayEnv.envSinsunMarket,
      ~variables={onlyDisplayable: Some(true), types: Some([#NORMAL]), parentId: None},
      (),
    )

  Js.Promise.all2((gnb(), displayCategories()))
  |> Js.Promise.then_(((
    gnb: GnbBannerListBuyerQuery_graphql.Types.response,
    displayCategories: ShopCategorySelectBuyerQuery_graphql.Types.response,
  )) => {
    Js.Promise.resolve({
      "props": {
        "deviceType": deviceType,
        "gnbBanners": gnb.gnbBanners,
        "displayCategories": displayCategories.displayCategories,
      },
    })
  })
  |> Js.Promise.catch(err => {
    Js.log2(`에러 gnb preload`, err)
    Js.Promise.resolve({
      "props": {
        "deviceType": deviceType,
        "gnbBanners": [],
        "displayCategories": [],
      },
    })
  })
}
