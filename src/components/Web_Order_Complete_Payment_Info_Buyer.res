module Fragment = %relay(`
    fragment WebOrderCompletePaymentInfoBuyerFragment on Query
    @argumentDefinitions(orderNo: { type: "String!" }) {
      wosOrder(orderNo: $orderNo) {
        totalOrderPrice
        totalDeliveryCost
        orderProducts {
          deliveryType
        }
        status
        payment {
          paymentMethod: method
          virtualAccount {
            accountNo
            bank {
              name
            }
            expiredAt
          }
        }
      }
    }    
`)

let paymentMethodToString = m =>
  switch m {
  | Some(#CREDIT_CARD) => `카드결제`
  | Some(#VIRTUAL_ACCOUNT) => `가상계좌`
  | Some(#TRANSFER) => `계좌이체`
  | _ => `-`
  }

let makePrice = (o, d, m) =>
  switch m {
  | #SELF
  | #FREIGHT => (o, 0)
  | #PARCEL => (o - d, d)
  | _ => (0, 0)
  }

module ResponsiveTitle = {
  @react.component
  let make = (~deviceType, ~title, ~textColor=%twc("text-enabled-L1")) => {
    switch deviceType {
    | DeviceDetect.Unknown => React.null
    | DeviceDetect.PC =>
      <span className={cx([%twc("text-xl font-bold"), textColor])}> {title->React.string} </span>
    | DeviceDetect.Mobile =>
      <span className={cx([%twc("text-lg font-bold"), textColor])}> {title->React.string} </span>
    }
  }
}

module Placeholder = {
  @react.component
  let make = (~deviceType) => {
    open Skeleton
    <section className=%twc("flex flex-col rounded-sm bg-white w-full p-7 gap-7")>
      <ResponsiveTitle title={"결제 정보"} deviceType />
      <ul className=%twc("text-sm flex flex-col gap-5")>
        <li key="payment-method" className=%twc("flex justify-between items-center")>
          <span className=%twc("text-text-L2")> {`결제 수단`->React.string} </span>
          <Box className=%twc("h-6 my-0 w-20 text-base font-bold xl:text-sm") />
        </li>
        // 단기적으로 상품금액, 배송비 노출을 없애기로함 (7/6) -> isFreeShipping이 wosOrder에 추가되면 부활시킬 예정
        // <li key="product-price" className=%twc("flex justify-between items-center")>
        //   <span className=%twc("text-text-L2")> {`총 상품금액`->React.string} </span>
        //   <Box className=%twc("h-6 my-0 w-20 text-base font-bold xl:text-sm") />
        // </li>
        // <li key="delivery-cost" className=%twc("flex justify-between items-center")>
        //   <span className=%twc("text-text-L2")> {`배송비`->React.string} </span>
        //   <Box className=%twc("h-6 my-0 w-20 text-base font-bold xl:text-sm") />
        // </li>
        <li key="total-price" className=%twc("flex justify-between items-center")>
          <span className=%twc("text-text-L2")> {`총 결제금액`->React.string} </span>
          <Box className=%twc("h-6 my-0 w-24 text-base font-bold xl:text-sm") />
        </li>
      </ul>
    </section>
  }
}

@react.component
let make = (~query, ~deviceType) => {
  let {wosOrder} = Fragment.use(query)

  let {addToast} = ReactToastNotifications.useToasts()

  React.useEffect0(_ => {
    Clipboard.init(".btn-link")
    None
  })

  let showToastCopyToClipboard = _ => {
    addToast(.
      <div className=%twc("flex items-center ")>
        <IconCheck height="24" width="24" fill="#12B564" className=%twc("mr-2") />
        {"계좌번호가 클립보드에 복사되었습니다."->React.string}
      </div>,
      {appearance: "success"},
    )
  }

  switch wosOrder {
  | Some({totalOrderPrice, totalDeliveryCost, orderProducts, status, payment}) =>
    let deliveryType =
      orderProducts->Array.get(0)->Option.flatMap(a => a->Option.map(b => b.deliveryType))

    let (productPrice, deliveryPrice) =
      deliveryType->Option.mapWithDefault((0, 0), d =>
        makePrice(totalOrderPrice, totalDeliveryCost->Option.getWithDefault(0), d)
      )

    <section className=%twc("flex flex-col rounded-sm bg-white w-full p-7 gap-7")>
      <ResponsiveTitle title={"결제 정보"} deviceType />
      <ul className=%twc("text-sm flex flex-col gap-5")>
        <li key="payment-method" className=%twc("flex justify-between items-center h-6")>
          <span className=%twc("text-text-L2")> {`결제 수단`->React.string} </span>
          <span className=%twc("text-base font-bold xl:text-sm")>
            {payment->Option.flatMap(p => p.paymentMethod)->paymentMethodToString->React.string}
          </span>
        </li>
        // 단기적으로 상품금액, 배송비 노출을 없애기로함 (7/6) -> isFreeShipping이 wosOrder에 추가되면 부활시킬 예정
        // <li key="product-price" className=%twc("flex justify-between items-center h-6")>
        //   <span className=%twc("text-text-L2")> {`총 상품금액`->React.string} </span>
        //   <span className=%twc("text-base font-bold xl:text-sm")>
        //     {`${productPrice->Locale.Int.show}원`->React.string}
        //   </span>
        // </li>
        // <li key="delivery-cost" className=%twc("flex justify-between items-center h-6")>
        //   <span className=%twc("text-text-L2")> {`배송비`->React.string} </span>
        //   <span className=%twc("text-base font-bold xl:text-sm")>
        //     {`${deliveryPrice->Locale.Int.show}원`->React.string}
        //   </span>
        // </li>
        <li key="total-price" className=%twc("flex justify-between items-center h-6")>
          <span className=%twc("text-text-L2")> {`총 결제금액`->React.string} </span>
          <ResponsiveTitle
            title={`${(productPrice + deliveryPrice)->Locale.Int.show}원`}
            deviceType
            textColor=%twc("text-primary")
          />
        </li>
        {switch (status, payment->Option.flatMap(p => p.virtualAccount)) {
        | (#DEPOSIT_PENDING, Some({accountNo, bank: {name}, expiredAt})) =>
          <>
            <div className=%twc("h-px bg-border-default-L2") />
            <ResponsiveTitle title={"입금 정보"} deviceType />
            <li
              key="virtual-account-bank-name"
              className=%twc("flex justify-between items-center h-6")>
              <span className=%twc("text-text-L2")> {"가상계좌은행"->React.string} </span>
              <span className=%twc("text-base font-bold xl:text-sm")> {name->React.string} </span>
            </li>
            <li
              key="virtual-account-account-owner"
              className=%twc("flex justify-between items-center h-6")>
              <span className=%twc("text-text-L2")> {"계좌주"->React.string} </span>
              <span className=%twc("text-base font-bold xl:text-sm")>
                {"주식회사 그린랩스"->React.string}
              </span>
            </li>
            <li
              key="virtual-account-number" className=%twc("flex justify-between items-center h-6")>
              <span className=%twc("text-text-L2")> {"계좌번호"->React.string} </span>
              <span className=%twc("flex gap-1 items-center text-base font-bold xl:text-sm")>
                {accountNo->React.string}
                <ReactUtil.SpreadProps
                  props={
                    "data-clipboard-text": accountNo->Js.String2.replaceByRe(%re("/\D/g"), ""),
                  }>
                  <button
                    type_="button"
                    className="btn-link py-1 px-2 text-[#65666B] font-normal text-sm rounded-md bg-[#F7F8FA]"
                    onClick=showToastCopyToClipboard>
                    {"복사"->React.string}
                  </button>
                </ReactUtil.SpreadProps>
              </span>
            </li>
            <li
              key="virtual-account-expired-at"
              className=%twc("flex justify-between items-center h-6")>
              <span className=%twc("text-text-L2")> {"입금기한"->React.string} </span>
              <span className=%twc("text-base font-bold xl:text-sm")>
                {expiredAt->Js.Date.fromString->DateFns.format("yyyy/MM/dd HH:mm")->React.string}
              </span>
            </li>
          </>
        | _ => React.null
        }}
      </ul>
    </section>
  | _ => <Placeholder deviceType />
  }
}
