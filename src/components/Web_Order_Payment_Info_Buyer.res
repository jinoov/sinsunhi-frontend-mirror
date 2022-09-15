open ReactHookForm
module Form = Web_Order_Buyer_Form

module PlaceHolder = {
  open Skeleton
  module PC = {
    @react.component
    let make = () => {
      <div className=%twc("rounded-sm bg-white p-7 w-full sticky top-64")>
        <span className=%twc("text-xl text-enabled-L1 font-bold")>
          {`결제 정보`->React.string}
        </span>
        <ul
          className=%twc(
            "text-sm flex flex-col gap-4 py-7 border border-x-0 border-t-0 border-div-border-L2"
          )>
          <li key="product-price" className=%twc("flex justify-between items-center")>
            <span className=%twc("text-text-L2")> {`총 상품금액`->React.string} </span>
            <Box className=%twc("w-20") />
          </li>
          <li key="delivery-cost" className=%twc("flex justify-between items-center")>
            <span className=%twc("text-text-L2")> {`배송비`->React.string} </span>
            <Box className=%twc("w-20") />
          </li>
          <li key="total-price" className=%twc("flex justify-between items-center")>
            <span className=%twc("text-text-L2")> {`총 결제금액`->React.string} </span>
            <Box className=%twc("w-24") />
          </li>
        </ul>
        <div className=%twc("mt-7 mb-10 flex justify-center items-center text-text-L1")>
          <Box className=%twc("w-44") />
        </div>
        <Box className=%twc("w-full min-h-[3.5rem] rounded-xl") />
      </div>
    }
  }

  module MO = {
    @react.component
    let make = () => {
      <div className=%twc("rounded-sm bg-white p-5 w-full")>
        <span className=%twc("text-lg text-enabled-L1 font-bold")>
          {`결제 정보`->React.string}
        </span>
        <ul
          className=%twc(
            "text-sm flex flex-col gap-4 py-7 border border-x-0 border-t-0 border-div-border-L2"
          )>
          <li key="product-price" className=%twc("flex justify-between items-center")>
            <span className=%twc("text-text-L2")> {`총 상품금액`->React.string} </span>
            <Box className=%twc("w-20") />
          </li>
          <li key="delivery-cost" className=%twc("flex justify-between items-center")>
            <span className=%twc("text-text-L2")> {`배송비`->React.string} </span>
            <Box className=%twc("w-20") />
          </li>
          <li key="total-price" className=%twc("flex justify-between items-center")>
            <span className=%twc("text-text-L2")> {`총 결제금액`->React.string} </span>
            <Box className=%twc("w-24") />
          </li>
        </ul>
        <div className=%twc("mt-7 mb-10 flex justify-center items-center text-text-L1")>
          <Box className=%twc("w-44") />
        </div>
        <Box className=%twc("w-full min-h-[3.5rem] rounded-xl") />
      </div>
    }
  }
}

module PC = {
  @react.component
  let make = (~renderProductPrice, ~renderDeliveryPrice, ~totalOrderPrice) => {
    <div className={%twc("rounded-sm bg-white p-7 w-fit sticky top-64")}>
      <span className=%twc("text-xl text-enabled-L1 font-bold")>
        {`결제 정보`->React.string}
      </span>
      <ul
        className=%twc(
          "text-sm flex flex-col gap-5 py-7 border border-x-0 border-t-0 border-div-border-L2 w-[440px]"
        )>
        <li key="product-price" className=%twc("flex justify-between items-center")>
          <span className=%twc("text-text-L2")> {`총 상품금액`->React.string} </span>
          <span className=%twc("text-sm font-normal")>
            {`${renderProductPrice->Locale.Int.show}원`->React.string}
          </span>
        </li>
        <li key="delivery-cost" className=%twc("flex justify-between items-center")>
          <span className=%twc("text-text-L2")> {`배송비`->React.string} </span>
          <span className=%twc("text-sm font-normal")> {renderDeliveryPrice->React.string} </span>
        </li>
        <li key="total-price" className=%twc("flex justify-between items-center")>
          <span className=%twc("text-text-L2")> {`총 결제금액`->React.string} </span>
          <span className=%twc("text-lg text-primary font-bold")>
            {`${totalOrderPrice->Locale.Int.show}원`->React.string}
          </span>
        </li>
      </ul>
      <div className=%twc("mt-7 mb-10 text-center text-text-L1")>
        <span>
          {`주문 내용을 확인했으며, 정보 제공에 동의합니다.`->React.string}
        </span>
      </div>
      <button
        type_="submit"
        className=%twc(
          "w-full h-14 flex justify-center items-center bg-primary text-lg text-white rounded-xl"
        )>
        {`결제하기`->React.string}
      </button>
    </div>
  }
}

module MO = {
  @react.component
  let make = (~renderProductPrice, ~renderDeliveryPrice, ~totalOrderPrice) => {
    <div className={%twc("rounded-sm bg-white p-5 w-full")}>
      <span className=%twc("text-lg text-enabled-L1 font-bold")>
        {`결제 정보`->React.string}
      </span>
      <ul
        className=%twc(
          "text-sm flex flex-col gap-5 py-7 border border-x-0 border-t-0 border-div-border-L2"
        )>
        <li key="product-price" className=%twc("flex justify-between items-center")>
          <span className=%twc("text-text-L2")> {`총 상품금액`->React.string} </span>
          <span className=%twc("text-base font-bold")>
            {`${renderProductPrice->Locale.Int.show}원`->React.string}
          </span>
        </li>
        <li key="delivery-cost" className=%twc("flex justify-between items-center")>
          <span className=%twc("text-text-L2")> {`배송비`->React.string} </span>
          <span className=%twc("text-base font-bold")> {renderDeliveryPrice->React.string} </span>
        </li>
        <li key="total-price" className=%twc("flex justify-between items-center")>
          <span className=%twc("text-text-L2")> {`총 결제금액`->React.string} </span>
          <span className=%twc("text-xl text-primary font-bold")>
            {`${totalOrderPrice->Locale.Int.show}원`->React.string}
          </span>
        </li>
      </ul>
      <div className=%twc("mt-7 mb-10 text-center text-text-L1")>
        <span>
          {`주문 내용을 확인했으며, 정보 제공에 동의합니다.`->React.string}
        </span>
      </div>
      <button
        type_="submit"
        className=%twc(
          "w-full h-14 flex justify-center items-center bg-primary text-lg text-white rounded-xl"
        )>
        {`결제하기`->React.string}
      </button>
    </div>
  }
}

@react.component
let make = (~prefix, ~productInfos: array<Form.productInfo>, ~deviceType) => {
  let formNames = Form.names(prefix)

  let totalOrderPrice = productInfos->Array.map(info => info.totalPrice)->Garter_Math.sum_int

  let totalDeliveryCost =
    productInfos
    ->Array.map(info =>
      info.productOptions->Array.map(option =>
        switch option.isFreeShipping {
        | true => 0
        | false => option.deliveryCost * option.quantity
        }
      )
    )
    ->Array.concatMany
    ->Garter_Math.sum_int

  let deliveryType = Hooks.WatchValues.use(
    Hooks.WatchValues.Text,
    ~config=Hooks.WatchValues.config(~name=formNames.deliveryType, ()),
    (),
  )

  let (renderProductPrice, renderDeliveryPrice) = switch deliveryType {
  | Some(deliveryType') =>
    switch deliveryType'->Js.Json.string->Form.deliveryType_decode {
    | Ok(decode) =>
      switch decode {
      | #FREIGHT => (totalOrderPrice, `협의`)
      | #SELF => (totalOrderPrice, `0원`)
      | #PARCEL => (totalOrderPrice - totalDeliveryCost, `${totalDeliveryCost->Locale.Int.show}원`)
      }
    | Error(_) => (0, `0`)
    }
  | _ => (0, ``)
  }

  {
    switch deviceType {
    | DeviceDetect.Unknown => React.null
    | DeviceDetect.PC => <PC renderProductPrice renderDeliveryPrice totalOrderPrice />
    | DeviceDetect.Mobile => <MO renderProductPrice renderDeliveryPrice totalOrderPrice />
    }
  }
}
