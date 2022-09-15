open ReactHookForm
module Form = Cart_Buyer_Form
module Util = Cart_Buyer_Util

@module("../../public/assets/checkbox-disable.svg")
external checkboxDisableIcon: string = "default"

module SoldOut = {
  @react.component
  let make = (~productOption: Form.productOption, ~refetchCart, ~prefix) => {
    let {control} = Hooks.Context.use(. ~config=Hooks.Form.config(~mode=#onChange, ()), ())
    let {productOptionName, price} = productOption
    let formNames = Form.names(prefix)

    <div className=%twc("w-full p-3 flex flex-col gap-1 bg-gray-50 rounded-md")>
      <div className=%twc("w-full flex justify-between items-center")>
        <div className=%twc("flex items-center gap-2")>
          <img
            src={checkboxDisableIcon}
            alt="check-disable-icon"
            className=%twc("w-6 h-6 min-w-max self-start")
          />
          <span className=%twc("pr-5 text-sm text-gray-600")>
            {productOptionName->Option.getWithDefault("")->React.string}
          </span>
        </div>
        <Controller
          control
          name=formNames.checked
          defaultValue={true->Js.Json.boolean}
          render={_ => <Cart_Delete_Button refetchCart productOptions=[productOption] />}
        />
      </div>
      <div className=%twc("flex justify-end items-center pl-8 mt-1 gap-2")>
        <span className=%twc("text-sm text-gray-800 bg-gray-200 rounded-[4px] px-2")>
          {`품절`->React.string}
        </span>
        <span className=%twc("text-gray-400 font-bold text-sm")>
          {`${price->Locale.Int.show} 원`->React.string}
        </span>
      </div>
    </div>
  }
}

module Container = {
  @react.component
  let make = (~productOption: Form.productOption, ~prefix, ~refetchCart) => {
    let {productOptionName, quantity, price, cartId, optionStatus} = productOption
    let formNames = Form.names(prefix)

    let watchQuantity =
      Hooks.WatchValues.use(
        Hooks.WatchValues.Text,
        ~config=Hooks.WatchValues.config(~name=formNames.quantity, ()),
        (),
      )
      ->Option.flatMap(Int.fromString)
      ->Option.getWithDefault(quantity)

    <div className=%twc("w-full p-3 flex flex-col gap-1 bg-gray-50 rounded-md")>
      <div className=%twc("w-full flex justify-between items-center")>
        <div className=%twc("flex items-center gap-2")>
          <Util.Checkbox
            name=formNames.checked status=optionStatus targetNames=[formNames.checked]
          />
          <span className=%twc("pr-5 text-sm text-gray-800")>
            {productOptionName->Option.getWithDefault("")->React.string}
          </span>
        </div>
        <Cart_Delete_Button refetchCart productOptions=[productOption] />
      </div>
      <div className=%twc("flex justify-between items-center pl-8 mt-1")>
        <Cart_QuantitySelector prefix quantity cartId />
        <span className=%twc("text-text-L1 font-bold text-sm")>
          {`${(watchQuantity * price)->Locale.Int.show} 원`->React.string}
        </span>
      </div>
    </div>
  }
}

@react.component
let make = (
  ~productOption: Form.productOption,
  ~refetchCart,
  ~prefix,
  ~productStatus: Form.productStatus,
) => {
  switch (productOption.optionStatus->Form.soldable, productStatus->Form.soldable) {
  | (true, true) => <Container refetchCart productOption prefix />
  | _ => <SoldOut refetchCart productOption prefix />
  }
}
