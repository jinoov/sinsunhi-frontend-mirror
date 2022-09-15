module Query = %relay(`
  query PDPBuyerQuery($number: Int!) {
    product(number: $number) {
      ...PDPBuyerFragment
    }
  }
`)

module Fragment = %relay(`
  fragment PDPBuyerFragment on Product {
    # Commons
    __typename
    id
    productId: number
    name
    displayName
    category {
      name
      fullyQualifiedName {
        name
      }
    }
  
    ... on NormalProduct {
      price
      producer {
        producerCode
      }
    }
    ... on QuotableProduct {
      price
      producer {
        producerCode
      }
    }
    ... on QuotedProduct {
      producer {
        producerCode
      }
    }
  
    # Fragments
    ...PDPNormalBuyerFragment
    ...PDPQuotedBuyerFragment
    ...PDPMatchingBuyer_fragment
  }
`)

module PageViewGtm = {
  let make = (product: PDPBuyerFragment_graphql.Types.fragment) => {
    let {__typename, productId, displayName, producer, price, category} = product
    let categoryNames = category.fullyQualifiedName->Array.map(({name}) => name)
    let producerCode = producer->Option.map(({producerCode}) => producerCode)
    let typename = {
      switch __typename {
      | "NormalProduct" | "QuotableProduct" => Some(`일반`)
      | "QuotedProduct" => Some(`견적`)
      | "MatchingProduct" => Some(`매칭`)
      | _ => None
      }
    }

    {
      "event": "view_item", // 이벤트 타입: 상품페이지 진입 시
      "ecommerce": {
        "items": [
          {
            "item_id": productId->Int.toString, // 상품 코드
            "item_type": typename->Js.Nullable.fromOption, // 상품 유형
            "item_name": displayName, // 상품명
            "currency": "KRW", // 화폐 KRW 고정
            "price": price->Js.Nullable.fromOption, // 상품 가격 (바이어 판매가) - nullable
            "item_brand": producerCode->Js.Nullable.fromOption, // maker - 생산자코드
            "item_category": categoryNames->Array.get(0)->Js.Nullable.fromOption, // 표준 카테고리 Depth 1
            "item_category2": categoryNames->Array.get(1)->Js.Nullable.fromOption, // 표준 카테고리 Depth 2
            "item_category3": categoryNames->Array.get(2)->Js.Nullable.fromOption, // 표준 카테고리 Depth 3
            "item_category4": categoryNames->Array.get(3)->Js.Nullable.fromOption, // 표준 카테고리 Depth 4
            "item_category5": categoryNames->Array.get(4)->Js.Nullable.fromOption, // 표준 카테고리 Depth 5
          },
        ],
      },
    }
  }
}

module Placeholder = {
  @react.component
  let make = (~deviceType, ~gnbBanners, ~displayCategories) => {
    let router = Next.Router.useRouter()

    switch deviceType {
    | DeviceDetect.Unknown => React.null

    | DeviceDetect.PC =>
      <div className=%twc("w-full min-w-[1280px] min-h-screen")>
        <Header_Buyer.PC key=router.asPath gnbBanners displayCategories />
        <div className=%twc("w-[1280px] mx-auto min-h-full")>
          <div className=%twc("w-full pt-16 px-5")>
            <section className=%twc("w-full flex justify-between")>
              <div>
                <div
                  className=%twc("w-[664px] aspect-square rounded-xl bg-gray-150 animate-pulse")
                />
                <div
                  className=%twc("mt-12 w-[664px] h-[92px] rounded-xl bg-gray-150 animate-pulse")
                />
                <div
                  className=%twc("mt-4 w-[563px] h-[23px] rounded-lg bg-gray-150 animate-pulse")
                />
              </div>
              <div>
                <div className=%twc("w-[496px] h-[44px] rounded-lg bg-gray-150 animate-pulse") />
                <div
                  className=%twc("mt-4 w-[123px] h-[44px] rounded-lg bg-gray-150 animate-pulse")
                />
                <div
                  className=%twc("mt-4 w-[496px] h-[56px] rounded-xl bg-gray-150 animate-pulse")
                />
                <div className=%twc("mt-4 w-[496px] rounded-xl border border-gray-200 px-6 py-8")>
                  <div className=%twc("w-[80px] h-[26px] rounded-md bg-gray-150 animate-pulse") />
                  <div className=%twc("mt-5 flex items-center justify-between")>
                    <div className=%twc("w-[88px] h-[24px] rounded-md bg-gray-150 animate-pulse") />
                    <div className=%twc("w-[68px] h-[24px] rounded-md bg-gray-150 animate-pulse") />
                  </div>
                  <div className=%twc("mt-1 flex items-center justify-between")>
                    <div className=%twc("w-[56px] h-[24px] rounded-md bg-gray-150 animate-pulse") />
                    <div className=%twc("w-[48px] h-[24px] rounded-md bg-gray-150 animate-pulse") />
                  </div>
                  <div className=%twc("mt-1 flex items-center justify-between")>
                    <div className=%twc("w-[72px] h-[24px] rounded-md bg-gray-150 animate-pulse") />
                    <div className=%twc("w-[56px] h-[24px] rounded-md bg-gray-150 animate-pulse") />
                  </div>
                  <div className=%twc("mt-1 flex items-center justify-between")>
                    <div className=%twc("w-[64px] h-[24px] rounded-md bg-gray-150 animate-pulse") />
                    <div className=%twc("w-[48px] h-[24px] rounded-md bg-gray-150 animate-pulse") />
                  </div>
                  <RadixUI.Separator.Root className=%twc("h-px bg-gray-100 my-4") />
                  <div
                    className=%twc("mt-6 w-[40px] h-[24px] rounded-md bg-gray-150 animate-pulse")
                  />
                  <div
                    className=%twc("mt-4 w-[440px] h-[80px] rounded-md bg-gray-150 animate-pulse")
                  />
                  <div
                    className=%twc("mt-6 w-[40px] h-[24px] rounded-md bg-gray-150 animate-pulse")
                  />
                  <div
                    className=%twc("mt-4 w-[440px] h-[80px] rounded-md bg-gray-150 animate-pulse")
                  />
                  <div className=%twc("mt-12 flex items-center justify-between")>
                    <div className=%twc("w-[86px] h-[26px] rounded-md bg-gray-150 animate-pulse") />
                    <div
                      className=%twc("w-[117px] h-[38px] rounded-md bg-gray-150 animate-pulse")
                    />
                  </div>
                </div>
              </div>
            </section>
            <RadixUI.Separator.Root className=%twc("h-px bg-gray-100 my-12") />
            <section>
              <div className=%twc("mt-4 w-[144px] h-[38px] rounded-md bg-gray-150 animate-pulse") />
              <div
                className=%twc("mt-14 w-[1240px] h-[176px] rounded-lg bg-gray-150 animate-pulse")
              />
              <div className=%twc("mt-14 flex flex-col items-center justify-center")>
                <div className=%twc("w-[640px] h-[44px] rounded-md bg-gray-150 animate-pulse") />
                <div
                  className=%twc(
                    "mt-[10px] w-[440px] h-[24px] rounded-md bg-gray-150 animate-pulse"
                  )
                />
              </div>
              <div
                className=%twc("mt-14 w-[1240px] h-[640px] rounded-lg bg-gray-150 animate-pulse")
              />
            </section>
          </div>
        </div>
        <Footer_Buyer.PC />
      </div>

    | DeviceDetect.Mobile =>
      <div className=%twc("w-full min-h-screen")>
        <div className=%twc("w-full bg-white")>
          <div className=%twc("w-full max-w-3xl mx-auto bg-white min-h-screen")>
            <Header_Buyer.Mobile key=router.asPath />
            <div className=%twc("w-full")>
              <div className=%twc("w-full aspect-square bg-gray-150 animate-pulse") />
              <section className=%twc("px-5 flex flex-col gap-2")>
                <div className=%twc("w-full mt-5 bg-gray-150 rounded-lg animate-pulse") />
                <div className=%twc("w-20 h-6 bg-gray-150 rounded-lg animate-pulse") />
                <div className=%twc("w-full bg-gray-150 rounded-lg animate-pulse") />
                <div className=%twc("w-full bg-gray-150 rounded-lg animate-pulse") />
                <div className=%twc("w-full h-[100px] bg-gray-150 rounded-lg animate-pulse") />
              </section>
            </div>
            <Footer_Buyer.MO />
          </div>
        </div>
      </div>
    }
  }
}

module NotFound = {
  @react.component
  let make = (~deviceType, ~gnbBanners, ~displayCategories) => {
    let router = Next.Router.useRouter()

    switch deviceType {
    | DeviceDetect.Unknown => React.null

    | DeviceDetect.PC =>
      <div className=%twc("w-full min-w-[1280px] min-h-screen flex flex-col")>
        <Header_Buyer.PC key=router.asPath gnbBanners displayCategories />
        <div className=%twc("flex flex-col flex-1 w-[1280px] px-5 py-16 mx-auto")>
          <div className=%twc("mt-14")>
            <div className=%twc("w-full flex items-center justify-center")>
              <span className=%twc("text-3xl text-gray-800")>
                {`상품이 존재하지 않습니다`->React.string}
              </span>
            </div>
            <div className=%twc("mt-7 w-full flex flex-col items-center justify-center")>
              <span className=%twc("text-gray-800")>
                {`상품 URL이 정확한지 확인해주세요.`->React.string}
              </span>
              <span className=%twc("text-gray-800")>
                {`상품이 없을 경우 다른 카테고리의 상품을 선택해주세요.`->React.string}
              </span>
            </div>
          </div>
        </div>
        <Footer_Buyer.PC />
      </div>

    | DeviceDetect.Mobile =>
      <div className=%twc("w-full min-h-screen")>
        <div className=%twc("w-full bg-white")>
          <div className=%twc("w-full max-w-3xl mx-auto bg-white min-h-screen")>
            <Header_Buyer.Mobile key=router.asPath />
            <div className=%twc("w-full px-5 pt-[126px]")>
              <div className=%twc("flex flex-col items-center text-base text-text-L2")>
                <span className=%twc("mb-2 text-xl text-text-L1")>
                  {`상품이 존재하지 않습니다`->React.string}
                </span>
                <span> {`상품 URL이 정확한지 확인해주세요.`->React.string} </span>
                <span>
                  {`상품이 없을 경우 다른 카테고리의 상품을 선택해주세요.`->React.string}
                </span>
              </div>
            </div>
            <Footer_Buyer.MO />
          </div>
        </div>
      </div>
    }
  }
}

module Error = {
  @react.component
  let make = (~deviceType, ~gnbBanners, ~displayCategories) => {
    let router = Next.Router.useRouter()

    switch deviceType {
    | DeviceDetect.Unknown => React.null

    | DeviceDetect.PC =>
      <div className=%twc("w-full min-w-[1280px] min-h-screen")>
        <Header_Buyer.PC key=router.asPath gnbBanners displayCategories />
        <div className=%twc("w-[1280px] px-5 py-16 mx-auto")>
          <div className=%twc("mt-14")>
            <div className=%twc("w-full flex items-center justify-center")>
              <span className=%twc("text-3xl text-gray-800")>
                {`상품을 가져오는데 실패하였습니다`->React.string}
              </span>
            </div>
            <div className=%twc("mt-7 w-full flex flex-col items-center justify-center")>
              <span className=%twc("text-gray-800")>
                {`상품 URL이 정확한지 확인해주세요.`->React.string}
              </span>
              <span className=%twc("text-gray-800")>
                {`상품이 없을 경우 다른 카테고리의 상품을 선택해주세요.`->React.string}
              </span>
            </div>
          </div>
        </div>
        <Footer_Buyer.PC />
      </div>

    | DeviceDetect.Mobile =>
      <div className=%twc("w-full min-h-screen")>
        <div className=%twc("w-full bg-white")>
          <div className=%twc("w-full max-w-3xl mx-auto bg-white min-h-screen")>
            <Header_Buyer.Mobile key=router.asPath />
            <div className=%twc("w-full px-5 pt-[126px]")>
              <div className=%twc("flex flex-col items-center text-base text-text-L2")>
                <span className=%twc("mb-2 text-xl text-text-L1")>
                  {`상품을 가져오는데 실패하였습니다`->React.string}
                </span>
                <span> {`상품 URL이 정확한지 확인해주세요.`->React.string} </span>
                <span>
                  {`상품이 없을 경우 다른 카테고리의 상품을 선택해주세요.`->React.string}
                </span>
              </div>
            </div>
            <Footer_Buyer.MO />
          </div>
        </div>
      </div>
    }
  }
}

module Presenter = {
  @react.component
  let make = (~deviceType, ~query, ~gnbBanners, ~displayCategories) => {
    let product = query->Fragment.use
    let {
      id,
      name,
      __typename,
      productId,
      category: {name: categoryName},
      displayName,
      fragmentRefs,
    } = product

    ChannelTalkHelper.Hook.use(
      ~viewMode=ChannelTalkHelper.Hook.PcOnly,
      ~trackData={
        eventName: `최근 본 상품`,
        eventProperty: {"productId": id, "productName": name},
      },
      (),
    )

    React.useEffect0(() => {
      Global.Window.ReactNativeWebView.PostMessage.airbridgeWithPayload(
        ~kind=#VIEW_PRODUCT_DETAIL,
        ~payload={
          "products": [
            {"ID": id, "number": productId, "name": displayName, "category": categoryName},
          ],
        },
        (),
      )
      None
    })

    React.useEffect1(() => {
      {"ecommerce": Js.Nullable.null}->DataGtm.push
      product->PageViewGtm.make->DataGtm.mergeUserIdUnsafe->DataGtm.push
      None
    }, [product])

    switch __typename->Product_Parser.Type.decode {
    // 일반 / 일반 + 견적 상품
    | Some(Normal) | Some(Quotable) =>
      <PDP_Normal_Buyer deviceType query=fragmentRefs gnbBanners displayCategories />

    // 견적 상품
    | Some(Quoted) =>
      <PDP_Quoted_Buyer deviceType query=fragmentRefs gnbBanners displayCategories />

    // 매칭 상품
    | Some(Matching) => <PDP_Matching_Buyer deviceType query=fragmentRefs /> // 초기 버전에선 모바일 뷰만 제공

    // Unknown
    | None => React.null
    }
  }
}

module Container = {
  @react.component
  let make = (~deviceType, ~productId, ~gnbBanners, ~displayCategories) => {
    let {product} = Query.use(
      ~variables=Query.makeVariables(~number=productId),
      ~fetchPolicy=RescriptRelay.StoreAndNetwork,
      (),
    )

    switch product {
    | None => <NotFound deviceType gnbBanners displayCategories />
    | Some({fragmentRefs}) =>
      <Presenter deviceType query=fragmentRefs gnbBanners displayCategories />
    }
  }
}

module RedirectOldUrl = {
  // PDP의 Url이 /products/{node-id} -> /products/{product-id}로 개편되면서
  // 기존에 crm등을 통해 공유된 유저의 진입을 보장하기 위해
  // 일시적으로 node-id를 통해 진입하는 유저를 product-id기반의 url로 redirect 시킨다. (한달 정도 유지할 예정)
  // 접근한 url이 node-id라는것은 int변환이 정상적이지 않은 query 스트링을 가졌을 경우
  // node-id라고 판단한다. 불안정한 로직이지만, 기존 유저의 하위호환을 일시적으로 보장하기 위한
  // 장치이므로 이 이상의 정교한 로직은 불필요하다고 생각된다.
  // 적용일: 2022.07.21
  // 제거 예정일: 2022.08.21

  module Redirector = {
    module Query = %relay(`
      query PDPBuyerRedirectQuery($id: ID!) {
        node(id: $id) {
          ... on Product {
            number
          }
        }
      }
    `)

    @react.component
    let make = (~nodeId, ~deviceType, ~gnbBanners, ~displayCategories) => {
      let {useRouter, replace} = module(Next.Router)
      let router = useRouter()

      let {node} = Query.use(~variables=Query.makeVariables(~id=nodeId), ())

      switch node {
      | None => <NotFound deviceType gnbBanners displayCategories />
      | Some({number}) =>
        switch number {
        | None => <NotFound deviceType gnbBanners displayCategories />
        | Some(number') =>
          router->replace(`/products/${number'->Int.toString}`)
          <> </>
        }
      }
    }
  }

  @react.component
  let make = (~pid, ~deviceType, ~gnbBanners, ~displayCategories) => {
    switch pid->Int.fromString {
    // int변환이 정상적으로 될 경우 product-id라고 판단
    | Some(productId) => <Container productId deviceType gnbBanners displayCategories />

    // int변환이 실패할 경우 node-id로 판단
    | None => <Redirector nodeId=pid deviceType gnbBanners displayCategories />
    }
  }
}

type props = {
  query: Js.Dict.t<string>,
  deviceType: DeviceDetect.deviceType,
  gnbBanners: array<GnbBannerListBuyerQuery_graphql.Types.response_gnbBanners>,
  displayCategories: array<ShopCategorySelectBuyerQuery_graphql.Types.response_displayCategories>,
}
type params
type previewData

let default = (~props) => {
  let {deviceType, gnbBanners, displayCategories} = props
  let router = Next.Router.useRouter()
  let pid = router.query->Js.Dict.get("pid")

  let (isCsr, setIsCsr) = React.Uncurried.useState(_ => false)

  React.useEffect0(() => {
    setIsCsr(._ => true)
    None
  })

  <>
    <Next.Head>
      <title> {`신선하이`->React.string} </title>
    </Next.Head>
    <RescriptReactErrorBoundary fallback={_ => <Error deviceType gnbBanners displayCategories />}>
      <React.Suspense fallback={React.null}>
        {switch (isCsr, pid) {
        | (true, Some(pid')) => <RedirectOldUrl deviceType pid=pid' gnbBanners displayCategories />
        | _ => React.null
        }}
      </React.Suspense>
    </RescriptReactErrorBoundary>
  </>
}

let getServerSideProps = (ctx: Next.GetServerSideProps.context<props, params, previewData>) => {
  let deviceType = DeviceDetect.detectDeviceFromCtx2(ctx.req)
  GnbBannerList_Buyer.Query.fetchPromised(~environment=RelayEnv.envSinsunMarket, ~variables=(), ())
  |> Js.Promise.then_((res: GnbBannerListBuyerQuery_graphql.Types.response) =>
    ShopCategorySelect_Buyer.Query.fetchPromised(
      ~environment=RelayEnv.envSinsunMarket,
      ~variables={onlyDisplayable: Some(true), types: Some([#NORMAL]), parentId: None},
      (),
    ) |> Js.Promise.then_((res1: ShopCategorySelectBuyerQuery_graphql.Types.response) => {
      Js.Promise.resolve({
        "props": {
          "query": ctx.query,
          "deviceType": deviceType,
          "gnbBanners": res.gnbBanners,
          "displayCategories": res1.displayCategories,
        },
      })
    })
  )
  |> Js.Promise.catch(err => {
    Js.log2("에러 GnbBannerListBuyerQuery", err)
    Js.Promise.resolve({
      "props": {
        "query": ctx.query,
        "deviceType": deviceType,
        "gnbBanners": [],
        "displayCategories": [],
      },
    })
  })
}
