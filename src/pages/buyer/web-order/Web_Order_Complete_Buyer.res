module Query = %relay(`
  query WebOrderCompleteBuyerQuery($orderNo: String!) {
    ...WebOrderCompleteProductInfoBuyerFragment @arguments(orderNo: $orderNo)
    ...WebOrderCompleteDeliveryInfoBuyerFragment @arguments(orderNo: $orderNo)
    ...WebOrderCompletePaymentInfoBuyerFragment @arguments(orderNo: $orderNo)
    wosOrder(orderNo: $orderNo) {
      orderNo
      totalDeliveryCost
      totalOrderPrice
      paymentMethod
      orderProducts {
        productName
        productId
        stockSku
        productOptionName
        quantity
        price
        deliveryType
      }
    }
  }
`)

@spice
type item = {
  @spice.key("item_id") itemId: string, // 상품 코드
  @spice.key("item_name") itemName: string, // 상품명
  currency: string, // "KRW" 고정
  @spice.key("item_variant") itemVariant: string, // 상품 sku
  price: int,
  quantity: int,
  index: int,
}

@spice
type ecommerce = {
  @spice.key("transaction_id") transactionId: string, // 주문번호
  currency: string, // "KRW" 고정
  value: int, // 총 결제 금액
  @spice.key("shipping_value") shippingValue: int, // 총 배송비
}

let toItems = (
  index,
  {
    productId,
    productName,
    stockSku,
    price,
    quantity,
  }: WebOrderCompleteBuyerQuery_graphql.Types.response_wosOrder_orderProducts,
) =>
  {
    itemId: productId->Int.toString,
    itemName: productName,
    currency: "KRW",
    itemVariant: stockSku,
    price,
    quantity,
    index,
  }->item_encode

module Placeholder = {
  @react.component
  let make = (~deviceType) => {
    let router = Next.Router.useRouter()

    <>
      {switch deviceType {
      | DeviceDetect.Unknown => React.null
      | DeviceDetect.PC => <Header_Buyer.PC_Old key=router.asPath />
      | DeviceDetect.Mobile => <Header_Buyer.Mobile />
      }}
      <main className=%twc("flex flex-col gap-5 xl:px-[16%] xl:py-20 bg-surface min-w-[375px]")>
        <label className=%twc("hidden xl:flex ml-5 mb-3 text-3xl font-bold text-enabled-L1")>
          {`주문 완료`->React.string}
        </label>
        <div className=%twc("flex flex-col xl:flex-row gap-4 xl:gap-5")>
          <article className=%twc("w-full xl:w-3/5 flex flex-col gap-5")>
            <section
              className=%twc("flex justify-center bg-white rounded-sm p-7 xl:p-0 min-w-[375px]")>
              <span
                className=%twc(
                  "w-full text-center text-base xl:text-xl p-6 font-bold text-text-L1 shadow-card-box xl:shadow-none"
                )>
                {`총 N건의 상품 주문이 완료되었습니다 📦`->React.string}
              </span>
            </section>
            <section className=%twc("flex flex-col p-7 gap-7 bg-white rounded-sm min-w-max")>
              <Web_Order_Complete_Product_Info_Buyer.Placeholder />
              <div className=%twc("h-px bg-border-default-L2") />
              <Web_Order_Complete_Orderer_Info_Buyer.Placeholder deviceType />
              <div className=%twc("h-px bg-border-default-L2") />
              <Web_Order_Complete_Delivery_Info_Buyer.Placeholder deviceType />
              <div className=%twc("h-px bg-border-default-L2") />
            </section>
          </article>
          <aside className=%twc("xl:w-2/5 min-w-[375px]")>
            <Web_Order_Complete_Payment_Info_Buyer.Placeholder deviceType />
          </aside>
        </div>
        <nav
          className=%twc(
            "w-full xl:w-[59%] flex flex-col xl:flex-row gap-2 p-7 pb-16 xl:pb-7 bg-white min-w-[375px]"
          )>
          <Next.Link href="/buyer/orders">
            <a
              className=%twc(
                "flex w-full xl:w-1/2 h-13 bg-surface rounded-lg justify-center items-center text-lg cursor-pointer text-enabled-L1"
              )>
              {`주문 상세내역 보기`->React.string}
            </a>
          </Next.Link>
          <Next.Link href="/buyer">
            <a
              className=%twc(
                "flex w-full xl:w-1/2 h-13 bg-green-100 rounded-lg justify-center items-center font-bold text-lg cursor-pointer text-primary"
              )>
              {`쇼핑 계속하기`->React.string}
            </a>
          </Next.Link>
        </nav>
      </main>
      {switch deviceType {
      | DeviceDetect.Unknown => React.null
      | DeviceDetect.PC => <Footer_Buyer.PC />
      | DeviceDetect.Mobile => <Footer_Buyer.MO />
      }}
    </>
  }
}

module PC = {
  @react.component
  let make = (~query, ~numberOfProductOptions, ~deviceType) => {
    <main className=%twc("flex flex-col gap-5 px-[16%] py-20 bg-surface min-w-[375px]")>
      <label className=%twc("flex ml-5 mb-3 text-3xl font-bold text-enabled-L1")>
        {`주문 완료`->React.string}
      </label>
      <div className=%twc("flex flex-row gap-5")>
        <article className=%twc("w-3/5 flex flex-col gap-5 min-w-[550px]")>
          <section className=%twc("flex justify-center bg-white rounded-sm p-0")>
            <span
              className=%twc("w-full text-center text-xl p-6 font-bold text-text-L1 shadow-none")>
              {`총 ${numberOfProductOptions->Int.toString}건의 상품 주문이 완료되었습니다 📦`->React.string}
            </span>
          </section>
          <section className=%twc("flex flex-col p-7 gap-7 bg-white rounded-sm min-w-max")>
            <Web_Order_Complete_Product_Info_Buyer query deviceType />
            <div className=%twc("h-px bg-border-default-L2") />
            <Web_Order_Complete_Orderer_Info_Buyer deviceType />
            <div className=%twc("h-px bg-border-default-L2") />
            <Web_Order_Complete_Delivery_Info_Buyer query deviceType />
          </section>
        </article>
        <aside className=%twc("w-2/5 min-w-[375px]")>
          <Web_Order_Complete_Payment_Info_Buyer query deviceType />
        </aside>
      </div>
      <nav className=%twc("w-[59%] flex flex-row gap-2 p-7 bg-white min-w-[550px]")>
        <Next.Link href="/buyer/orders">
          <a
            className=%twc(
              "flex w-1/2 h-13 bg-surface rounded-lg justify-center items-center text-lg cursor-pointer text-enabled-L1"
            )>
            {`주문 상세내역 보기`->React.string}
          </a>
        </Next.Link>
        <Next.Link href="/buyer">
          <a
            className=%twc(
              "flex w-1/2 h-13 bg-green-100 rounded-lg justify-center items-center font-bold text-lg cursor-pointer text-primary"
            )>
            {`쇼핑 계속하기`->React.string}
          </a>
        </Next.Link>
      </nav>
    </main>
  }
}

module MO = {
  @react.component
  let make = (~query, ~numberOfProductOptions, ~deviceType) => {
    <main className=%twc("flex flex-col gap-5 bg-surface min-w-[375px]")>
      <div className=%twc("flex flex-col gap-4")>
        <article className=%twc("w-full flex flex-col gap-5")>
          <section className=%twc("flex justify-center bg-white rounded-sm p-7 min-w-[375px]")>
            <span
              className=%twc(
                "w-full text-center text-base p-6 font-bold text-text-L1 shadow-card-box"
              )>
              {`총 ${numberOfProductOptions->Int.toString}건의 상품 주문이 완료되었습니다 📦`->React.string}
            </span>
          </section>
          <section className=%twc("flex flex-col p-7 gap-7 bg-white rounded-sm min-w-max")>
            <Web_Order_Complete_Product_Info_Buyer query deviceType />
            <div className=%twc("h-px bg-border-default-L2") />
            <Web_Order_Complete_Orderer_Info_Buyer deviceType />
            <div className=%twc("h-px bg-border-default-L2") />
            <Web_Order_Complete_Delivery_Info_Buyer query deviceType />
          </section>
        </article>
        <aside className=%twc("min-w-[375px]")>
          <Web_Order_Complete_Payment_Info_Buyer query deviceType />
        </aside>
      </div>
      <nav className=%twc("w-full flex flex-col gap-2 p-7 pb-16 bg-white min-w-[375px]")>
        <Next.Link href="/buyer/orders">
          <a
            className=%twc(
              "flex w-full h-13 bg-surface rounded-lg justify-center items-center text-lg cursor-pointer text-enabled-L1"
            )>
            {`주문 상세내역 보기`->React.string}
          </a>
        </Next.Link>
        <Next.Link href="/buyer">
          <a
            className=%twc(
              "flex w-full h-13 bg-green-100 rounded-lg justify-center items-center font-bold text-lg cursor-pointer text-primary"
            )>
            {`쇼핑 계속하기`->React.string}
          </a>
        </Next.Link>
      </nav>
    </main>
  }
}

module Container = {
  @react.component
  let make = (~nodeId, ~deviceType) => {
    let router = Next.Router.useRouter()
    let {wosOrder, fragmentRefs} = Query.use(
      ~variables={
        orderNo: nodeId,
      },
      (),
    )

    React.useEffect0(_ => {
      wosOrder->Option.forEach(wosOrder' => {
        {"ecommerce": Js.Nullable.null}->DataGtm.push
        {
          "event": "purchase",
          "ecommerce": {
            "transaction_id": wosOrder'.orderNo,
            "currency": "KRW",
            "value": wosOrder'.totalOrderPrice,
            "shipping_value": wosOrder'.totalDeliveryCost->Option.getWithDefault(0),
            "shipping_method": switch wosOrder'.orderProducts->Array.get(0) {
            | Some(Some({deliveryType})) =>
              deliveryType->Web_Order_Complete_Delivery_Info_Buyer.deliveryTypetoString
            | _ => ``
            },
            "payment_method": switch wosOrder'.paymentMethod {
            | Some(#CREDIT_CARD) => `신용카드`
            | Some(#VIRTUAL_ACCOUNT) => `가상계좌`
            | Some(#TRANSFER) => `계좌이체`
            | _ => ``
            },
            "items": wosOrder'.orderProducts
            ->Array.keepMap(Garter.Fn.identity)
            ->Array.mapWithIndex(toItems),
          },
        }
        ->DataGtm.mergeUserIdUnsafe
        ->DataGtm.push
      })

      wosOrder->Option.forEach(wosOrder' =>
        ChannelTalk.track(.
          "track",
          "CheckoutCompleted",
          {"price": wosOrder'.totalOrderPrice, "currency": "KRW"},
        )
      )

      wosOrder->Option.forEach(wosOrder => {
        Global.Window.ReactNativeWebView.PostMessage.airbridgeWithPayload(
          ~kind=#PURCHASE,
          ~payload={
            "transactionID": wosOrder.orderNo,
            "price": wosOrder.totalOrderPrice,
            "currency": "KRW",
            "items": wosOrder.orderProducts
            ->Array.keepMap(Garter.Fn.identity)
            ->Array.mapWithIndex(toItems),
            "quantity": wosOrder.orderProducts->Array.length,
          },
          (),
        )
      })

      None
    })

    let numberOfProductOptions =
      wosOrder->Option.mapWithDefault(0, w =>
        w.orderProducts->Array.keepMap(Garter_Fn.identity)->Array.length
      )

    {
      switch deviceType {
      | DeviceDetect.Unknown => React.null
      | DeviceDetect.PC =>
        <>
          <Header_Buyer.PC_Old key=router.asPath />
          <PC query=fragmentRefs numberOfProductOptions deviceType />
          <Footer_Buyer.PC />
        </>
      | DeviceDetect.Mobile =>
        <>
          <Header_Buyer.Mobile />
          <MO query=fragmentRefs numberOfProductOptions deviceType />
          <Footer_Buyer.MO />
        </>
      }
    }
  }
}

type props = {
  query: Js.Dict.t<string>,
  deviceType: DeviceDetect.deviceType,
  gnbBanners: array<GnbBannerListBuyerQuery_graphql.Types.response_gnbBanners>,
}
type params
type previewData

let default = (~props) => {
  let {deviceType} = props
  let router = Next.Router.useRouter()
  let orderId = router.query->Js.Dict.get("order-id")

  let (isCsr, setIsCsr) = React.Uncurried.useState(_ => false)

  React.useEffect0(() => {
    setIsCsr(._ => true)
    None
  })

  <>
    <Next.Head>
      <title> {`주문완료 - 신선하이`->React.string} </title>
    </Next.Head>
    <RescriptReactErrorBoundary fallback={_ => <NotFound />}>
      <React.Suspense fallback={<Placeholder deviceType />}>
        {switch (isCsr, orderId) {
        | (true, Some(nodeId)) => <Container nodeId deviceType />
        | _ => <Placeholder deviceType />
        }}
      </React.Suspense>
    </RescriptReactErrorBoundary>
  </>
}

let getServerSideProps = (ctx: Next.GetServerSideProps.context<props, params, previewData>) => {
  let deviceType = DeviceDetect.detectDeviceFromCtx2(ctx.req)
  GnbBannerList_Buyer.Query.fetchPromised(~environment=RelayEnv.envSinsunMarket, ~variables=(), ())
  |> Js.Promise.then_((res: GnbBannerListBuyerQuery_graphql.Types.response) =>
    Js.Promise.resolve({
      "props": {"query": ctx.query, "deviceType": deviceType, "gnbBanners": res.gnbBanners},
    })
  )
  |> Js.Promise.catch(err => {
    Js.log2("에러 GnbBannerListBuyerQuery", err)
    Js.Promise.resolve({
      "props": {"query": ctx.query, "deviceType": deviceType, "gnbBanners": []},
    })
  })
}
