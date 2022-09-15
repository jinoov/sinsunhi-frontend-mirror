open ReactHookForm
open Skeleton
module Form = Cart_Buyer_Form
module Card = Cart_Card_Buyer
module Util = Cart_Buyer_Util
module Hidden = Util.Hidden

module ProductNameAndDelete = {
  @react.component
  let make = (~cartItem: Form.cartItem, ~refetchCart) => {
    let {productName, productOptions, productId} = cartItem
    <div className=%twc("flex w-full justify-between items-baseline")>
      <Next.Link href={`/products/${productId->Int.toString}`}>
        <a className=%twc("text-text-L1 font-bold self-start underline-offset-4 hover:underline")>
          {productName->Option.getWithDefault("")->React.string}
        </a>
      </Next.Link>
      <Cart_Delete_Button
        refetchCart productOptions width="1.5rem" height="1.5rem" fill="#000000"
      />
    </div>
  }
}

module List = {
  @react.component
  let make = (
    ~productOptions: Form.productOptions,
    ~formNames: Form.inputNames,
    ~refetchCart,
    ~productStatus,
  ) => {
    <div className=%twc("mt-5 flex flex-col gap-2")>
      {productOptions
      ->Array.mapWithIndex((cardIndex, productOption) =>
        <Card
          refetchCart
          productStatus
          key={`${formNames.productOptions}.${cardIndex->Int.toString}`}
          productOption
          prefix={`${formNames.productOptions}.${cardIndex->Int.toString}`}
        />
      )
      ->React.array}
    </div>
  }
}

module BuyNow = {
  @react.component
  let make = (~totalPrice, ~cartIds, ~cartItems) => {
    <div className=%twc("flex justify-between items-center mt-4")>
      <Create_Temp_Order_Button_Buyer cartIds cartItems />
      <div className={%twc("flex flex-col items-end text-lg")}>
        <span className=%twc("text-[13px] text-gray-600 min-w-max")>
          {`배송타입에 따라 배송비 상이`->React.string}
        </span>
        <span className=%twc("text-text-L1 font-bold min-w-max")>
          {`${totalPrice->Locale.Int.show}원`->React.string}
        </span>
      </div>
    </div>
  }
}

module PC = {
  module PlaceHolder = {
    @react.component
    let make = () => {
      <div className=%twc("flex gap-4 w-full")>
        <Box className=%twc("min-w-[1.5rem]") />
        <Box className=%twc("min-w-[5rem] min-h-[5rem] rounded-[10px]") />
        <div className={%twc("w-full flex flex-col pb-4")}>
          <div className=%twc("flex w-full justify-between items-baseline")>
            <Box className=%twc("w-32") />
            <Box className=%twc("w-6 h-6") />
          </div>
          <Box className=%twc("mt-5 flex flex-col gap-2 min-h-[6rem]") />
          <div className=%twc("flex justify-between items-center mt-4")>
            <Box className=%twc("w-20 h-10") />
            <Box className={%twc("w-64")} />
          </div>
        </div>
      </div>
    }
  }
  @react.component
  let make = (
    ~formNames: Form.inputNames,
    ~cartItem: Form.cartItem,
    ~targetNames,
    ~totalPrice,
    ~isLast,
    ~refetchCart,
    ~checkedCartIds,
  ) => {
    let {productOptions, productName, imageUrl, productStatus, productId} = cartItem

    <div className=%twc("flex gap-4 w-full")>
      <Util.Checkbox
        name=formNames.checked targetNames watchNames=targetNames status=productStatus
      />
      <Next.Link href={`/products/${productId->Int.toString}`}>
        <a>
          <img
            src={imageUrl->Option.getWithDefault("")}
            alt={`${productName->Option.getWithDefault("")}-image`}
            className=%twc("min-w-[80px] min-h-[80px] w-20 h-20 rounded-[10px]")
          />
        </a>
      </Next.Link>
      <div
        className={cx([
          %twc("w-full flex flex-col pb-4"),
          isLast ? %twc("") : %twc("border border-x-0 border-t-0 border-div-border-L2"),
        ])}>
        <ProductNameAndDelete refetchCart cartItem />
        <List refetchCart formNames productOptions productStatus />
        <BuyNow cartIds=checkedCartIds totalPrice cartItems=[cartItem] />
      </div>
    </div>
  }
}

module MO = {
  module PlaceHolder = {
    @react.component
    let make = () => {
      <div className=%twc("flex flex-col w-full mt-4")>
        <div className=%twc("flex w-full gap-2")>
          <div className=%twc("flex gap-2 min-w-max")>
            <Box className=%twc("min-w-[1.5rem]") />
            <Box className=%twc("w-20 h-20 rounded-[10px]") />
          </div>
          <div className=%twc("flex justify-between w-full")>
            <Box className=%twc("w-32") />
            <Box className=%twc("w-6 h-6") />
          </div>
        </div>
        <div className=%twc("w-full")>
          <Box className=%twc("mt-5 flex flex-col gap-2 min-h-[6rem]") />
          <div className=%twc("flex justify-between items-center mt-4")>
            <Box className=%twc("w-20 h-10") />
            <Box className={%twc("w-64")} />
          </div>
        </div>
      </div>
    }
  }
  @react.component
  let make = (
    ~formNames: Form.inputNames,
    ~cartItem: Form.cartItem,
    ~targetNames,
    ~totalPrice,
    ~refetchCart,
    ~checkedCartIds,
  ) => {
    let {productName, imageUrl, productOptions, productStatus, productId} = cartItem

    <div className=%twc("flex flex-col w-full mt-4")>
      <div className=%twc("flex w-full gap-2")>
        <div className=%twc("flex gap-2 min-w-max")>
          <Util.Checkbox
            name=formNames.checked targetNames watchNames=targetNames status=productStatus
          />
          <Next.Link href={`/products/${productId->Int.toString}`}>
            <a>
              <img
                src={imageUrl->Option.getWithDefault("")}
                alt={`${productName->Option.getWithDefault("")}-image`}
                className=%twc("w-20 h-20 rounded-[10px]")
              />
            </a>
          </Next.Link>
        </div>
        <ProductNameAndDelete refetchCart cartItem />
      </div>
      <div className=%twc("w-full")>
        <List refetchCart formNames productOptions productStatus />
        <BuyNow cartIds=checkedCartIds totalPrice cartItems=[cartItem] />
      </div>
    </div>
  }
}

module PlaceHolder = {
  @react.component
  let make = (~deviceType) => {
    <div className=%twc("flex bg-white w-full p-4 xl:p-0")>
      {switch deviceType {
      | DeviceDetect.Unknown => React.null
      | DeviceDetect.PC => <PC.PlaceHolder />
      | DeviceDetect.Mobile => <MO.PlaceHolder />
      }}
    </div>
  }
}

@react.component
let make = (~cartItem: Form.cartItem, ~refetchCart, ~prefix, ~isLast, ~deviceType) => {
  let {setValue} = Hooks.Context.use(.
    ~config=Hooks.Form.config(~mode=#onChange, ~shouldUnregister=true, ()),
    (),
  )
  let {productOptions} = cartItem
  let formNames = Form.names(prefix)

  let watchOptions = Hooks.WatchValues.use(
    Hooks.WatchValues.NullableObjects,
    ~config=Hooks.WatchValues.config(~name=formNames.productOptions, ()),
    (),
  )

  let parsed =
    watchOptions
    ->Option.map(a =>
      a->Array.keepMap(o =>
        o
        ->Js.Nullable.toOption
        ->Option.flatMap(
          a =>
            switch a->Form.productOption_decode {
            | Ok(decode) => Some(decode)
            | Error(_) => None
            },
        )
      )
    )
    ->Option.map(options => {
      options->Array.keep(option => option.optionStatus->Form.soldable)
    })

  let targetNames =
    productOptions
    ->Array.mapWithIndex((i, option) => {
      switch option.optionStatus->Form.soldable {
      | true => Some(Form.names(`${formNames.productOptions}.${i->Int.toString}`).checked)
      | false => None
      }
    })
    ->Array.keepMap(Garter_Fn.identity)

  let soldable =
    productOptions->Array.keep(option => option.checked && option.optionStatus->Form.soldable)

  let defaultTotalPrice =
    soldable->Array.map(option => option.quantity * option.price)->Garter_Math.sum_int
  let defaultChecked = soldable->Array.length
  let defaultCheckedCartIds = soldable->Array.map(option => option.cartId)

  let (totalPrice, totalNumber, checkedAll, checkedCartIds) = parsed->Option.mapWithDefault(
    (defaultTotalPrice, defaultChecked, true, defaultCheckedCartIds),
    options => {
      let filtered = options->Array.keep(option => option.checked)
      (
        filtered->Array.map(o => o.price * o.quantity)->Garter_Math.sum_int,
        filtered->Array.length,
        defaultChecked == filtered->Array.length,
        filtered->Array.map(o => o.cartId),
      )
    },
  )

  React.useEffect3(_ => {
    setValue(. formNames.checkedNumber, Js.Json.number(totalNumber->Int.toFloat))
    setValue(. formNames.checked, Js.Json.boolean(checkedAll))
    None
  }, (totalPrice, totalNumber, checkedAll))

  <div className=%twc("flex bg-white p-4 xl:p-0")>
    {switch deviceType {
    | DeviceDetect.Unknown => React.null
    | DeviceDetect.PC =>
      <PC formNames cartItem targetNames totalPrice isLast refetchCart checkedCartIds />
    | DeviceDetect.Mobile =>
      <MO formNames cartItem targetNames totalPrice refetchCart checkedCartIds />
    }}
  </div>
}
