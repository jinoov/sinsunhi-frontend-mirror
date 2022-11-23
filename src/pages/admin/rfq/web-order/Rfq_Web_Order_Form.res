@spice
type deliveryMethod = [
  | @spice.as("화물배송") #FREIGHT
  | @spice.as("택배배송") #COURIER
  | @spice.as("자체물류") #SELLER_DELIVERY
  | @spice.as("바이어 직접 수령") #BUYER_TAKE
  | @spice.as("선택") #NOT_SELECTED
]
let deliveryMethods: array<deliveryMethod> = [
  #NOT_SELECTED,
  #FREIGHT,
  #SELLER_DELIVERY,
  #BUYER_TAKE,
]
let methodToString = m => m->deliveryMethod_encode->Js.Json.decodeString->Option.getWithDefault("")

open HookForm
type fields = {
  @as("delivery-address") deliveryAddress: string,
  @as("delivery-method") deliveryMethod: deliveryMethod,
  @as("order-amount") orderAmount: string, // 주문량
  @as("first-amount") firstAmount: string, // 확정량
  @as("unit-supplied-price") unitSuppliedPrice: string, // 거래단위당 공급가
  @as("unit-price") unitPrice: string, // 거래당위당 판매가
  @as("delivery-fee") deliveryFee: string, // 배송비
  @as("delivery-confirm") deliveryConfirm: bool,
}

module Form = Make({
  type t = fields
})

module DeliveryConfirm = {
  module Field = Form.MakeInput({
    type t = bool
    let name = "delivery-confirm"
    let config = Rules.empty()
  })
  module Input = {
    @react.component
    let make = (~form, ~disabled) => {
      let {name, onChange, onBlur, ref} = form->Field.register()

      <div className=%twc("flex items-center gap-2")>
        <Checkbox.Uncontrolled id=name name onChange onBlur inputRef=ref disabled />
        <span className=%twc("ml-2 text-text-L1 text-sm")> {"배송확정"->React.string} </span>
      </div>
    }
  }
}

module DeliveryAddress = {
  module Field = Form.MakeInput({
    type t = string
    let name = "delivery-address"
    let config = Rules.makeWithErrorMessage({
      required: {value: true, message: "배송지를 입력해주세요."},
    })
  })

  module Input = {
    @react.component
    let make = (~form, ~isShowAddrSearch, ~setShowAddrSearch, ~disabled) => {
      let setDeliveryAddress = form->Field.setValueWithOption(~shouldValidate=true)
      let error = form->Field.error->Option.map(({message}) => message)

      let {name, onChange, onBlur, ref} = form->Field.register()
      let handleAddressOpen = _ => {
        setShowAddrSearch(._ => true)
      }
      let handleAddressOnComplete = (res: DaumPostCode.oncompleteResponse) => {
        setShowAddrSearch(._ => false)
        setDeliveryAddress(res.address, ())
      }

      <>
        <div
          className=%twc(
            "w-full flex items-center flex-auto text-[13px] border border-x-0 border-div-border-L2"
          )>
          <div className={%twc("flex items-center w-full h-[42px] max-h-[42px]")}>
            <div className={%twc("bg-div-shape-L2 pl-3 py-2.5 text-text-L2 w-[100px]")}>
              {"배송지"->React.string}
            </div>
            <div className=%twc("px-3 py-1.5 w-full flex items-center gap-2 justify-between")>
              <div className=%twc("w-full")>
                <Input
                  type_="text"
                  name
                  size=Input.Small
                  className={switch error {
                  | Some(_) => %twc("ring-2 ring-opacity-100 ring-notice")
                  | _ => ""
                  }}
                  placeholder={"주소검색을 해주세요 (직접입력 가능)"}
                  disabled
                  inputRef=ref
                  onBlur
                  onChange
                  error=None
                />
                {error->Option.mapWithDefault(React.null, errMsg =>
                  <ErrorText className=%twc("absolute") errMsg />
                )}
              </div>
              <button
                disabled
                type_="button"
                className=%twc("min-w-fit px-3 py-2 rounded-lg bg-[#F2F2F2] interactable")
                onClick={handleAddressOpen}>
                {"주소검색"->React.string}
              </button>
            </div>
          </div>
        </div>
        <SearchAddressEmbed
          isShow={isShowAddrSearch} onComplete={handleAddressOnComplete} height=10.
        />
      </>
    }
  }
}

module DeliveryMethod = {
  module Field = Form.MakeInput({
    type t = deliveryMethod
    let name = "delivery-method"
    let config = Rules.makeWithErrorMessage({
      pattern: {
        value: %re("/^((?!NOT_SELECTED).)*$/"),
        message: "배송방법을 입력해주세요.",
      },
    })
  })

  module Input = {
    @react.component
    let make = (~form, ~disabled) => {
      let currentValue = form->Field.watch
      let error = form->Field.error->Option.map(({message}) => message)

      <div className={%twc("flex items-center w-full h-[42px] max-h-[42px]")}>
        <div className={%twc("bg-div-shape-L2 pl-3 py-2.5 text-text-L2 w-[100px]")}>
          {"배송방법"->React.string}
        </div>
        <div>
          <div className=%twc("px-3 py-0.5")>
            <div>
              <label id="select" className=%twc("block text-sm font-medium text-gray-700") />
              <div className=%twc("relative")>
                <button
                  type_="button"
                  className={cx([
                    %twc(
                      "relative w-[100px] min-w-fit bg-white border rounded-lg py-1.5 pl-3 pr-8 border-border-default-L1 focus:outline-none focus:ring-1-gl remove-spin-button focus:border-gray-gl"
                    ),
                    switch disabled {
                    | true => %twc("bg-gray-100")
                    | false => %twc("")
                    },
                    switch error {
                    | Some(_) => %twc("ring-2 ring-opacity-100 ring-notice")
                    | None => %twc("")
                    },
                  ])}>
                  <span className=%twc("flex items-center text-text-L1")>
                    <span className=%twc("block truncate")>
                      {currentValue->methodToString->React.string}
                    </span>
                  </span>
                  <span className=%twc("absolute top-0.5 right-1")>
                    <IconArrowSelect height="28" width="28" fill="#121212" />
                  </span>
                </button>
                {form->Field.renderController(({field: {onChange, onBlur, ref, name}}) =>
                  <select
                    className=%twc("absolute left-0 w-full py-3 opacity-0")
                    name
                    ref
                    disabled
                    onBlur={_ => onBlur()}
                    onChange={e => {
                      let value = (e->ReactEvent.Synthetic.currentTarget)["value"]->Js.Json.string
                      switch value->deliveryMethod_decode {
                      | Ok(decode) => decode->onChange
                      | _ => ()
                      }
                    }}>
                    {deliveryMethods
                    ->Array.map(deliveryMethod => {
                      let stringDeliveryMethod = deliveryMethod->methodToString
                      <option key=stringDeliveryMethod value=stringDeliveryMethod>
                        {stringDeliveryMethod->React.string}
                      </option>
                    })
                    ->React.array}
                  </select>
                , ())}
              </div>
            </div>
            {error->Option.mapWithDefault(React.null, errMsg =>
              <ErrorText className=%twc("absolute") errMsg />
            )}
          </div>
        </div>
      </div>
    }
  }
}

module AmountAndPrice = {
  module OrderAmountField = Form.MakeInput({
    type t = string
    let name = "order-amount"
    let config = Rules.makeWithErrorMessage({
      required: {value: true, message: "주문량을 입력해주세요."},
      pattern: {
        value: %re("/\d+(?:\.\d{1,3})?/"),
        message: "주문량을 입력해주세요.",
      },
    })
  })
  module FirstAmountField = Form.MakeInput({
    type t = string
    let name = "first-amount"
    let config = Rules.empty()
  })
  module SuppliedPriceField = Form.MakeInput({
    type t = string
    let name = "unit-supplied-price"
    let config = Rules.makeWithErrorMessage({
      required: {value: true, message: "공급가를 입력해주세요."},
    })
  })
  module PriceField = Form.MakeInput({
    type t = string
    let name = "unit-price"
    let config = Rules.makeWithErrorMessage({
      required: {value: true, message: "판매가를 입력해주세요."},
    })
  })
  let handleOnChange = e => {
    let newValue =
      (e->ReactEvent.Synthetic.currentTarget)["value"]
      ->Js.String2.replaceByRe(%re("/[^.\d]/g"), "")
      ->Js.String2.replaceByRe(%re("/^(\d*\.?)|(\d*)\.?/g"), "$1$2")
      ->Js.String2.replaceByRe(%re("/(\d+\.\d{3})(\d+)/g"), "$1")

    newValue
  }
  module AmountInput = {
    @react.component
    let make = (~form, ~disabled) => {
      let firstAmountError = form->FirstAmountField.error->Option.map(({message}) => message)
      let orderError = form->OrderAmountField.error->Option.map(({message}) => message)

      <div
        className=%twc(
          "w-full flex items-center flex-auto text-[13px] border border-x-0 border-b-0 border-div-border-L2"
        )>
        <div className={%twc("flex items-center w-full h-[42px] max-h-[42px]")}>
          <div className={%twc("bg-div-shape-L2 pl-3 py-2.5 text-text-L2 w-[100px]")}>
            {"최초 주문량"->React.string}
          </div>
          <div className=%twc("flex gap-2 py-1.5 px-3 items-center")>
            {form->FirstAmountField.renderController(
              ({field: {onChange, onBlur, value, ref, name}}) =>
                <div>
                  <Input
                    type_="text"
                    name
                    disabled=true
                    className=%twc("w-[100px]")
                    size=Input.Small
                    placeholder={"주문량 입력"}
                    value
                    inputRef=ref
                    onBlur={_ => onBlur()}
                    onChange={e => e->handleOnChange->onChange}
                    error=None
                  />
                  {firstAmountError->Option.mapWithDefault(React.null, errMsg =>
                    <ErrorText className=%twc("absolute") errMsg />
                  )}
                </div>,
              (),
            )}
          </div>
        </div>
        <div className={%twc("flex items-center w-full h-[42px] max-h-[42px]")}>
          <div className={%twc("bg-div-shape-L2 pl-3 py-2.5 text-text-L2 w-[100px]")}>
            {"주문량"->React.string}
          </div>
          <div className=%twc("flex gap-1 py-1.5 px-3 items-center")>
            {form->OrderAmountField.renderController(
              ({field: {onChange, onBlur, value, ref, name}}) =>
                <div>
                  <Input
                    type_="text"
                    name
                    className={cx([
                      %twc("w-[100px]"),
                      switch orderError {
                      | Some(_) => %twc("ring-2 ring-opacity-100 ring-notice")
                      | _ => ""
                      },
                    ])}
                    size=Input.Small
                    placeholder={"주문량 입력"}
                    disabled
                    value
                    inputRef=ref
                    onBlur={_ => onBlur()}
                    onChange={e => e->handleOnChange->onChange}
                    error=None
                  />
                  {orderError->Option.mapWithDefault(React.null, errMsg =>
                    <ErrorText className=%twc("absolute") errMsg />
                  )}
                </div>,
              (),
            )}
          </div>
        </div>
      </div>
    }
  }
  module PriceInput = {
    @react.component
    let make = (~form, ~disabled) => {
      let suppliedPriceError = form->SuppliedPriceField.error->Option.map(({message}) => message)
      let priceError = form->PriceField.error->Option.map(({message}) => message)

      let handleOnChange = e => {
        let newValue =
          (e->ReactEvent.Synthetic.currentTarget)["value"]
          ->Js.String2.replaceByRe(%re("/[\D]/g"), "")
          ->Js.String2.replaceByRe(%re("/\d{1,3}(?=(\d{3})+(?!\d))/g"), "$&,")

        newValue
      }
      <div
        className=%twc(
          "w-full flex items-center flex-auto text-[13px] border border-x-0 border-b-0 border-div-border-L2"
        )>
        <div className={%twc("flex items-center w-full h-[42px] max-h-[42px]")}>
          <div className={%twc("bg-div-shape-L2 pl-3 py-2.5 text-text-L2 w-[180px]")}>
            {"거래단위당 공급가/판매가"->React.string}
          </div>
          <div className=%twc("flex gap-2 py-1.5 px-3 items-center")>
            {form->SuppliedPriceField.renderController(
              ({field: {onChange, onBlur, value, ref, name}}) =>
                <div>
                  <Input
                    type_="text"
                    name
                    className={cx([
                      %twc("w-40"),
                      switch suppliedPriceError {
                      | Some(_) => %twc("ring-2 ring-opacity-100 ring-notice")
                      | _ => ""
                      },
                    ])}
                    size=Input.Small
                    placeholder={"금액 입력"}
                    disabled
                    value
                    inputRef=ref
                    onBlur={_ => onBlur()}
                    onChange={e => e->handleOnChange->onChange}
                    error=None
                  />
                  {suppliedPriceError->Option.mapWithDefault(React.null, errMsg =>
                    <ErrorText className=%twc("absolute") errMsg />
                  )}
                </div>,
              (),
            )}
            {"/"->React.string}
            {form->PriceField.renderController(({field: {onChange, onBlur, value, ref, name}}) =>
              <div>
                <Input
                  type_="text"
                  name
                  className={cx([
                    %twc("w-40"),
                    switch priceError {
                    | Some(_) => %twc("ring-2 ring-opacity-100 ring-notice")
                    | _ => ""
                    },
                  ])}
                  size=Input.Small
                  placeholder={"금액 입력"}
                  disabled
                  value
                  inputRef=ref
                  onBlur={_ => onBlur()}
                  onChange={e => e->handleOnChange->onChange}
                  error=None
                />
                {priceError->Option.mapWithDefault(React.null, errMsg =>
                  <ErrorText className=%twc("absolute") errMsg />
                )}
              </div>
            , ())}
          </div>
        </div>
      </div>
    }
  }
  module ByOrderPriceInput = {
    @react.component
    let make = (~form) => {
      let orderAmount = form->OrderAmountField.watch->Float.fromString
      let unitSuppliedPrice =
        form->SuppliedPriceField.watch->Js.String2.replaceByRe(%re("/[\D]/g"), "")->Float.fromString
      let unitPrice =
        form->PriceField.watch->Js.String2.replaceByRe(%re("/[\D]/g"), "")->Float.fromString

      let suppliedValue = switch (orderAmount, unitSuppliedPrice) {
      | (Some(amount), Some(price)) => amount *. price
      | _ => 0.
      }
      let orderedValue = switch (orderAmount, unitPrice) {
      | (Some(amount), Some(price)) => amount *. price
      | _ => 0.
      }

      <div
        className=%twc(
          "w-full flex items-center flex-auto text-[13px] border border-x-0 border-b-0 border-div-border-L2"
        )>
        <div className={%twc("flex items-center w-full h-[42px] max-h-[42px]")}>
          <div className={%twc("bg-div-shape-L2 pl-3 py-2.5 text-text-L2 w-[180px]")}>
            {"최종 주문 총 공급액/총 매출액"->React.string}
          </div>
          <div className=%twc("flex gap-2 p-3 py-1.5 px-3 items-center")>
            <div
              className=%twc(
                "w-40 flex items-center rounded-md px-3 h-8 bg-disabled-L3 border border-border-default-L1 focus:outline-none focus:ring-1-gl remove-spin-button focus:border-border-active"
              )>
              {switch suppliedValue {
              | 0. => "-"
              | _ => suppliedValue->Locale.Float.round0->Locale.Float.show(~digits=3)
              }->React.string}
            </div>
            {"/"->React.string}
            <div
              className=%twc(
                "w-40 flex items-center rounded-md px-3 h-8 bg-disabled-L3 border border-border-default-L1 focus:outline-none focus:ring-1-gl remove-spin-button focus:border-border-active"
              )>
              {switch orderedValue {
              | 0. => "-"
              | _ => orderedValue->Locale.Float.round0->Locale.Float.show(~digits=3)
              }->React.string}
            </div>
          </div>
        </div>
      </div>
    }
  }
  module ByFirstAmountInput = {
    @react.component
    let make = (~form) => {
      let firstAmount = form->FirstAmountField.watch->Float.fromString
      let unitSuppliedPrice =
        form->SuppliedPriceField.watch->Js.String2.replaceByRe(%re("/[\D]/g"), "")->Float.fromString
      let unitPrice =
        form->PriceField.watch->Js.String2.replaceByRe(%re("/[\D]/g"), "")->Float.fromString

      let suppliedValue = switch (firstAmount, unitSuppliedPrice) {
      | (Some(amount), Some(price)) => amount *. price
      | _ => 0.
      }
      let orderedValue = switch (firstAmount, unitPrice) {
      | (Some(amount), Some(price)) => amount *. price
      | _ => 0.
      }
      <div
        className=%twc(
          "w-full flex items-center flex-auto text-[13px] border border-x-0 border-b-0 border-div-border-L2"
        )>
        <div className={%twc("flex items-center w-full h-[42px] max-h-[42px]")}>
          <div className={%twc("bg-div-shape-L2 pl-3 py-2.5 text-text-L2 w-[180px]")}>
            {"최초 주문 총 공급액/총 매출액"->React.string}
          </div>
          <div className=%twc("flex gap-2 p-3 py-1.5 px-3 items-center")>
            <div
              className=%twc(
                "w-40 flex items-center rounded-md px-3 h-8 bg-disabled-L3 border border-border-default-L1 focus:outline-none focus:ring-1-gl remove-spin-button focus:border-border-active"
              )>
              {switch suppliedValue {
              | 0. => "-"
              | _ => suppliedValue->Locale.Float.round0->Locale.Float.show(~digits=3)
              }->React.string}
            </div>
            {"/"->React.string}
            <div
              className=%twc(
                "w-40 flex items-center rounded-md px-3 h-8 bg-disabled-L3 border border-border-default-L1 focus:outline-none focus:ring-1-gl remove-spin-button focus:border-border-active"
              )>
              {switch orderedValue {
              | 0. => "-"
              | _ => orderedValue->Locale.Float.round0->Locale.Float.show(~digits=3)
              }->React.string}
            </div>
          </div>
        </div>
      </div>
    }
  }
}

module DeliveryFee = {
  module Field = Form.MakeInput({
    type t = string
    let name = "delivery-fee"
    let config = Rules.makeWithErrorMessage({
      required: {value: true, message: "배송비를 입력해주세요."},
    })
  })
  module Input = {
    @react.component
    let make = (~form, ~disabled) => {
      let error = form->Field.error->Option.map(({message}) => message)
      let handleOnChange = e => {
        let newValue =
          (e->ReactEvent.Synthetic.currentTarget)["value"]
          ->Js.String2.replaceByRe(%re("/[\D]/g"), "")
          ->Js.String2.replaceByRe(%re("/\d{1,3}(?=(\d{3})+(?!\d))/g"), "$&,")

        newValue
      }

      <div className=%twc("w-full flex items-center flex-auto text-[13px] ")>
        <div className={%twc("flex items-center w-full h-[42px] max-h-[42px]")}>
          <div className={%twc("bg-div-shape-L2 pl-3 py-2.5 text-text-L2 w-[100px]")}>
            {"배송비"->React.string}
          </div>
          <div className=%twc("flex gap-2 py-1.5 px-3 items-center")>
            {form->Field.renderController(({field: {onChange, onBlur, value, ref, name}}) =>
              <div>
                <Input
                  type_="text"
                  name
                  className={cx([
                    %twc("w-[180px]"),
                    switch error {
                    | Some(_) => %twc("ring-2 ring-opacity-100 ring-notice")
                    | _ => ""
                    },
                  ])}
                  size=Input.Small
                  placeholder={"배송비 입력"}
                  disabled
                  value
                  inputRef=ref
                  onBlur={_ => onBlur()}
                  onChange={e => e->handleOnChange->onChange}
                  error=None
                />
                {error->Option.mapWithDefault(React.null, errMsg =>
                  <ErrorText className=%twc("absolute z-10") errMsg />
                )}
              </div>
            , ())}
          </div>
        </div>
      </div>
    }
  }
}
