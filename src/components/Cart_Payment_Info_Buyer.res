open ReactHookForm
open Skeleton
module Form = Cart_Buyer_Form

module PlaceHolder = {
  module PC = {
    @react.component
    let make = () =>
      <div className={%twc("rounded-sm bg-white p-7 w-fit sticky top-64")}>
        <Box className=%twc("block w-10") />
        <div
          className=%twc(
            "text-sm flex flex-col gap-5 py-7 border border-x-0 border-t-0 border-div-border-L2 w-[440px]"
          )>
          <div className=%twc("flex justify-between items-center")>
            <Box className=%twc("w-16") />
            <Box className=%twc("w-8") />
          </div>
          <div className=%twc("flex justify-between items-center")>
            <Box className=%twc("w-16") />
            <Box className=%twc("w-8") />
          </div>
          <div className=%twc("flex justify-between items-center")>
            <div className=%twc("flex flex-col")>
              <Box className=%twc("w-16") />
            </div>
            <Box className=%twc("w-8") />
          </div>
        </div>
        <Box className=%twc("w-full h-14 mt-7 flex justify-center items-center rounded-xl") />
      </div>
  }
  module MO = {
    @react.component
    let make = () =>
      <div className={%twc("rounded-sm bg-white px-4 pb-4 w-full")}>
        <div className=%twc("text-sm flex flex-col gap-5 py-7 border-0 border-div-border-L2")>
          <div className=%twc("flex justify-between items-center")>
            <div className=%twc("flex flex-col")>
              <Box className=%twc("w-16") />
              <Box className=%twc("block w-16") />
            </div>
            <Box className=%twc("w-8") />
          </div>
        </div>
        <Box className=%twc("w-full h-14  flex justify-center items-center rounded-xl") />
      </div>
  }
}

module PC = {
  @react.component
  let make = (~prefix) => {
    let watchOptions = Hooks.WatchValues.use(
      Hooks.WatchValues.Object,
      ~config=Hooks.WatchValues.config(~name=prefix, ()),
      (),
    )

    let (totalOrderPrice, totalNumber) = switch watchOptions->Option.map(Form.cart_decode) {
    | Some(Ok(decode)) => {
        let checked =
          decode.cartItems
          ->Option.getWithDefault([])
          ->Array.map(c =>
            c.productOptions->Array.keep(o =>
              c.productStatus->Form.soldable && o.optionStatus->Form.soldable && o.checked
            )
          )
          ->Array.concatMany
        let totalOrderPrice = checked->Array.map(c => c.price * c.quantity)->Garter_Math.sum_int
        let totalNum = checked->Array.length
        (totalOrderPrice, totalNum)
      }
    | _ => (0, 0)
    }

    <div className=%twc("rounded-sm bg-white p-7 w-fit sticky top-64")>
      <span className=%twc("block text-xl text-enabled-L1 font-bold")>
        {`주문 정보`->React.string}
      </span>
      <div
        className=%twc(
          "text-sm flex flex-col gap-5 py-7 border border-x-0 border-t-0 border-div-border-L2 w-[440px]"
        )>
        <div className=%twc("flex justify-between items-center")>
          <span className=%twc("text-text-L2")> {`총 상품금액`->React.string} </span>
          <span className=%twc("text-base font-bold xl:text-sm xl:font-normal")>
            {`${totalOrderPrice->Locale.Int.show}원`->React.string}
          </span>
        </div>
        <div className=%twc("flex justify-between items-center")>
          <span className=%twc("text-text-L2")> {`배송비`->React.string} </span>
          <span className=%twc("text-sm text-gray-600 xl:text-text-L1")>
            {`배송타입 선택 후 배송비 확인 가능`->React.string}
          </span>
        </div>
        <div className=%twc("flex justify-between items-center")>
          <div className=%twc("flex flex-col")>
            <span className=%twc("font-normal text-text-L2")>
              {`총 결제금액`->React.string}
            </span>
          </div>
          <span className=%twc("text-lg text-primary font-bold")>
            {`${totalOrderPrice->Locale.Int.show}원`->React.string}
          </span>
        </div>
      </div>
      {switch totalNumber {
      | 0 =>
        <div
          className=%twc(
            "w-full h-14 mt-7 flex justify-center items-center bg-disabled-L1 text-lg text-white rounded-xl"
          )>
          {`총 0건 주문하기`->React.string}
        </div>
      | n =>
        <button
          type_="submit"
          className=%twc(
            "w-full h-14 mt-7 flex justify-center items-center bg-primary text-lg text-white rounded-xl"
          )>
          {`총 ${n->Locale.Int.show}건 주문하기`->React.string}
        </button>
      }}
    </div>
  }
}

module MO = {
  @react.component
  let make = (~prefix) => {
    let watchOptions = Hooks.WatchValues.use(
      Hooks.WatchValues.Object,
      ~config=Hooks.WatchValues.config(~name=prefix, ()),
      (),
    )

    let (totalOrderPrice, totalNumber) = switch watchOptions->Option.map(Form.cart_decode) {
    | Some(Ok(decode)) => {
        let checked =
          decode.cartItems
          ->Option.getWithDefault([])
          ->Array.map(c =>
            c.productOptions->Array.keep(o =>
              c.productStatus->Form.soldable && o.optionStatus->Form.soldable && o.checked
            )
          )
          ->Array.concatMany
        let totalOrderPrice = checked->Array.map(c => c.price * c.quantity)->Garter_Math.sum_int
        let totalNum = checked->Array.length
        (totalOrderPrice, totalNum)
      }

    | _ => (0, 0)
    }

    <div className=%twc("rounded-sm bg-white px-4 pb-4 w-full top-64")>
      <div className=%twc("text-sm flex flex-col gap-5 py-7 border-0 border-div-border-L2")>
        <div className=%twc("flex justify-between items-center")>
          <div className=%twc("flex flex-col")>
            <span className=%twc("text-black font-bold")> {`총 결제금액`->React.string} </span>
            <span className=%twc("block text-gray-600 text-xs")>
              {`배송타입 선택 후 배송비 확인 가능`->React.string}
            </span>
          </div>
          <span className=%twc("text-xl text-primary font-bold")>
            {`${totalOrderPrice->Locale.Int.show}원`->React.string}
          </span>
        </div>
      </div>
      {switch totalNumber {
      | 0 =>
        <div
          className=%twc(
            "w-full h-14 flex justify-center items-center bg-disabled-L1 text-lg text-white rounded-xl"
          )>
          {`총 0건 주문하기`->React.string}
        </div>
      | n =>
        <button
          type_="submit"
          className=%twc(
            "w-full h-14 flex justify-center items-center bg-primary text-lg text-white rounded-xl"
          )>
          {`총 ${n->Locale.Int.show}건 주문하기`->React.string}
        </button>
      }}
    </div>
  }
}
