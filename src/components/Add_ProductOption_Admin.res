open ReactHookForm
module Select_Unit = Select_Product_Option_Unit

@module("../../public/assets/checkbox-checked.svg")
external checkboxCheckedIcon: string = "default"

@module("../../public/assets/checkbox-unchecked.svg")
external checkboxUncheckedIcon: string = "default"

module Form = {
  @spice
  type cost = {
    @spice.key("raw-cost") rawCost: int,
    @spice.key("working-cost") workingCost: int,
    @spice.key("delivery-cost") deliveryCost: option<int>,
    @spice.key("cost-type") costType: string,
    @spice.key("buyer-price") buyerPrice: int,
  }

  @spice
  type submit = {
    name: option<string>,
    grade: option<string>,
    package: option<string>,
    amount: float,
    each: option<Product_Option_Each_Admin.Form.each>,
    @spice.key("amount-unit") amountUnit: Select_Unit.Amount.status,
    @spice.key("operation-status") operationStatus: string,
    cost: cost,
    @spice.key("cut-off-time") cutOffTime: option<string>,
    @spice.key("memo") memo: option<string>,
    @spice.key("show-each") showEach: bool,
    @spice.key("is-free-shipping") isFreeShipping: Select_Product_Shipping_Type.status,
    @spice.key("shipping-unit-quantity") shippingUnitQuantity: int,
    @spice.key("adhoc-stock-is-limited") adhocStockIsLimited: bool,
    @spice.key("adhoc-stock-num-limit") adhocStockNumLimit: option<int>,
    @spice.key("adhoc-stock-is-num-remaining-visible") adhocStockIsNumRemainingVisible: bool,
  }

  type inputNames = {
    name: string,
    autoCompleteName: string,
    grade: string,
    package: string,
    amount: string,
    amountUnit: string,
    operationStatus: string,
    isFreeShipping: string,
    buyerPrice: string,
    cost: string,
    rawCost: string,
    workingCost: string,
    deliveryCost: string,
    costType: string,
    cutOffTime: string,
    memo: string,
    each: string,
    showEach: string,
    shippingUnitQuantity: string,
    adhocStockIsLimited: string,
    adhocStockNumLimit: string,
    adhocStockIsNumRemainingVisible: string,
  }

  let makeNames = prefix => {
    name: `${prefix}.name`,
    autoCompleteName: `${prefix}.autoCompleteName`,
    grade: `${prefix}.grade`,
    package: `${prefix}.package`,
    amount: `${prefix}.amount`,
    amountUnit: `${prefix}.amount-unit`,
    operationStatus: `${prefix}.operation-status`,
    isFreeShipping: `${prefix}.is-free-shipping`,
    buyerPrice: `${prefix}.cost.buyer-price`,
    cost: `${prefix}.cost.cost`,
    rawCost: `${prefix}.cost.raw-cost`,
    workingCost: `${prefix}.cost.working-cost`,
    deliveryCost: `${prefix}.cost.delivery-cost`,
    costType: `${prefix}.cost.cost-type`,
    cutOffTime: `${prefix}.cut-off-time`,
    memo: `${prefix}.memo`,
    each: `${prefix}.each`,
    showEach: `${prefix}.show-each`,
    shippingUnitQuantity: `${prefix}.shipping-unit-quantity`,
    adhocStockIsLimited: `${prefix}.adhoc-stock-is-limited`,
    adhocStockNumLimit: `${prefix}.adhoc-stock-num-limit`,
    adhocStockIsNumRemainingVisible: `${prefix}.adhoc-stock-is-num-remaining-visible`,
  }

  let names = {
    name: "name",
    autoCompleteName: "autoCompleteName",
    grade: "grade",
    package: "package",
    amount: "amount",
    amountUnit: "amount-unit",
    operationStatus: "operation-status",
    isFreeShipping: "is-free-shipping",
    buyerPrice: "cost.buyer-price",
    cost: "cost.cost",
    rawCost: "cost.raw-cost",
    workingCost: "cost.working-cost",
    deliveryCost: "cost.delivery-cost",
    costType: "cost.cost-type",
    cutOffTime: "cut-off-time",
    memo: "memo",
    each: "each",
    showEach: "show-each",
    shippingUnitQuantity: "shipping-unit-quantity",
    adhocStockIsLimited: "adhoc-stock-is-limited",
    adhocStockNumLimit: "adhoc-stock-num-limit",
    adhocStockIsNumRemainingVisible: "adhoc-stock-is-num-remaining-visible",
  }

  let defaultValue =
    [
      (names.name, Js.Json.null),
      (names.autoCompleteName, Js.Json.null),
      (names.grade, Js.Json.null),
      // TODO: valueAsNumber 제거 후 resolver 에서 validation 처리하기
      // (names.weight, Js.Json.null),
      (names.amountUnit, Select_Unit.AmountStatus.KG->Select_Unit.Amount.status_encode),
      (names.operationStatus, Js.Json.null),
      (names.isFreeShipping, Js.Json.null),
      (names.buyerPrice, Js.Json.null),
      (
        "cost",
        [
          ("raw-cost", Js.Json.null),
          ("working-cost", Js.Json.null),
          ("delivery-cost", Js.Json.null),
          ("buyer-price", Js.Json.null),
        ]
        ->Js.Dict.fromArray
        ->Js.Json.object_,
      ),
      (
        names.cutOffTime,
        Js.Json.string(`10시 이전 발주 완료건에 한해 당일 출고(단, 산지 상황에 따라 출고 일정은 변경 될 수 있습니다.)`),
      ),
      (names.memo, Js.Json.null),
      (names.shippingUnitQuantity, Js.Json.string("1")),
      (names.adhocStockIsLimited, Js.Json.boolean(false)),
      (names.adhocStockNumLimit, Js.Json.null),
      (names.adhocStockIsNumRemainingVisible, Js.Json.boolean(false)),
    ]
    ->Js.Dict.fromArray
    ->Js.Json.object_
}

let makeAutoGeneratedName = (
  ~grade,
  ~package,
  ~amount,
  ~amountUnit,
  ~numMin,
  ~numMax,
  ~perAmountUnit,
  ~sizeMin,
  ~sizeMax,
  ~sizeUnit,
  ~showEach,
  (),
) => {
  let basicNames = [
    Helper.Option.map2(amount->Option.flatMap(Float.fromString), amountUnit, (a, au) =>
      `${a->Float.toString}${au}`
    ),
    grade->Option.flatMap(str => str === "" ? None : Some(str)),
    package->Option.flatMap(str => str === "" ? None : Some(str)),
  ]

  // 입수정보가 체크되어 있으면 자동생성에 반영한다.
  let additiveNames = switch showEach {
  | true => [
      Helper.Option.map2(numMin, numMax, (min, max) => `상자당 ${min}~${max}`),
      switch (amount, amountUnit, numMin, numMax, perAmountUnit) {
      | (Some(amount'), Some(amountUnit'), Some(numMin'), Some(numMax'), Some(unit)) =>
        switch (
          amount'->Float.fromString,
          amountUnit'->Js.Json.string->Select_Unit.Amount.status_decode,
          numMin'->Float.fromString,
          numMax'->Float.fromString,
          unit->Js.Json.string->Select_Unit.Amount.status_decode,
        ) {
        | (Some(weight''), Ok(weightUnit''), Some(numMin''), Some(numMax''), Ok(unit'')) => {
            let {getPerAmount} = module(Product_Option_Each_Admin)
            Some(
              `${getPerAmount(weight'', weightUnit'', numMax'', Some(unit''))}~` ++
              `${getPerAmount(weight'', weightUnit'', numMin'', Some(unit''))}${unit}`,
            )
          }

        | _ => None
        }
      | _ => None
      },
      switch (sizeMin, sizeMax, sizeUnit) {
      | (Some(min), Some(max), Some(unit)) => Some(`${min}~${max}${unit}`)
      | _ => None
      },
    ]
  | false => []
  }

  basicNames->Array.concat(additiveNames)->Array.keep(Option.isSome)->Js.Array2.joinWith("/")
}

module NameInput = {
  @react.component
  let make = (~inputName) => {
    let {register} = Hooks.Context.use(. ~config=Hooks.Form.config(~mode=#onChange, ()), ())
    let {ref, name, onChange, onBlur} = register(. inputName, None)

    <input
      id=name
      ref
      name
      onChange
      onBlur
      className=%twc("px-3 py-2 border border-border-default-L1 rounded-lg h-9 w-1/3 max-w-sm")
      placeholder={`단품명 입력(커스텀)`}
    />
  }
}

module AutoGeneratedName = {
  @react.component
  let make = (~inputNames: Form.inputNames) => {
    let {control} = Hooks.Context.use(. ~config=Hooks.Form.config(~mode=#onChange, ()), ())

    let watchValues = Hooks.WatchValues.use(
      Hooks.WatchValues.NullableTexts,
      ~config=Hooks.WatchValues.config(
        ~control,
        ~name=[
          inputNames.grade,
          inputNames.package,
          inputNames.amount,
          inputNames.amountUnit,
          `${inputNames.each}.${Product_Option_Each_Admin.Form.names.minNum}`,
          `${inputNames.each}.${Product_Option_Each_Admin.Form.names.maxNum}`,
          `${inputNames.each}.${Product_Option_Each_Admin.Form.names.unitAmount}`,
          `${inputNames.each}.${Product_Option_Each_Admin.Form.names.minSize}`,
          `${inputNames.each}.${Product_Option_Each_Admin.Form.names.maxSize}`,
          `${inputNames.each}.${Product_Option_Each_Admin.Form.names.unitSize}`,
        ],
        (),
      ),
      (),
    )

    let showEach = Hooks.WatchValues.use(
      Hooks.WatchValues.Checkbox,
      ~config=Hooks.WatchValues.config(~control, ~name=inputNames.showEach, ()),
      (),
    )

    let generatedName = switch watchValues {
    | Some(values) =>
      switch values->Array.map(Js.Nullable.toOption) {
      | [
          grade,
          package,
          amount,
          amountUnit,
          numMin,
          numMax,
          perAmountUnit,
          sizeMin,
          sizeMax,
          sizeUnit,
        ] =>
        makeAutoGeneratedName(
          ~grade,
          ~package,
          ~amount,
          ~amountUnit,
          ~numMin,
          ~numMax,
          ~perAmountUnit,
          ~sizeMin,
          ~sizeMax,
          ~sizeUnit,
          ~showEach={showEach->Option.getWithDefault(false)},
          (),
        )
      | _ => ""
      }
    | None => ""
    }

    <div
      className=%twc(
        "w-1/3 max-w-[320px] h-9 px-3 py-2 border border-gray-300 bg-gray-100 rounded-lg "
      )>
      <span className=%twc("whitespace-nowrap text-gray-500")>
        {(
          generatedName === "" ? `자동생성 단품명(자동으로 생성)` : generatedName
        )->React.string}
      </span>
    </div>
  }
}

module OptionCode = {
  @react.component
  let make = () => {
    <div
      className=%twc(
        "w-1/3 max-w-[162px] h-9  px-3 py-2 border border-gray-300 bg-gray-100 rounded-lg"
      )>
      <span className=%twc("whitespace-nowrap text-gray-500")>
        {`단품코드(자동생성)`->React.string}
      </span>
    </div>
  }
}

module GradeInput = {
  @react.component
  let make = (~inputName) => {
    let {register} = Hooks.Context.use(. ~config=Hooks.Form.config(~mode=#onChange, ()), ())
    let {ref, name, onChange, onBlur} = register(. inputName, None)

    <div className=%twc("w-1/3 max-w-[320px]")>
      <label htmlFor=name className=%twc("block font-bold")>
        {`등급(용도)`->React.string}
      </label>
      <input
        id=name
        ref
        name
        onChange
        onBlur
        className=%twc("mt-2 w-full h-9 px-3 py-2 border border-gray-300 rounded-lg")
        placeholder={`등급 또는 용도 입력(선택사항)`}
        maxLength=20
      />
    </div>
  }
}

module PackageInput = {
  @react.component
  let make = (~inputName) => {
    let {register} = Hooks.Context.use(. ~config=Hooks.Form.config(~mode=#onChange, ()), ())
    let {ref, name, onChange, onBlur} = register(. inputName, None)

    <div className=%twc("w-1/3 max-w-[320px]")>
      <label htmlFor=name className=%twc("block font-bold")> {`포장재질`->React.string} </label>
      <input
        id=name
        ref
        name
        onChange
        onBlur
        className=%twc("mt-2 w-full h-9 px-3 py-2 border border-gray-300 rounded-lg")
        placeholder={`포장재질(선택사항)`}
        maxLength=20
      />
    </div>
  }
}

module AmountInput = {
  @react.component
  let make = (~showEachInputName, ~amountInputName, ~unitInputName) => {
    let {register, control, formState: {errors}} = Hooks.Context.use(.
      ~config=Hooks.Form.config(~mode=#onChange, ()),
      (),
    )

    let {ref, name, onChange, onBlur} = register(.
      amountInputName,
      Some(Hooks.Register.config(~required=true, ~valueAsNumber=true, ~min=0, ())),
    )

    <>
      <div className=%twc("py-6 flex flex-col gap-2")>
        <label htmlFor=name>
          <span className=%twc("font-bold")> {`중량`->React.string} </span>
          <span className=%twc("text-red-500")> {`*`->React.string} </span>
        </label>
        <div className=%twc("flex items-center gap-2")>
          <input
            ref
            id=name
            name
            type_="number"
            step=0.01
            onChange
            onBlur
            className=%twc("px-3 py-2 border border-border-default-L1 rounded-lg h-9")
            placeholder={`중량 입력`}
          />
          <Controller
            name=unitInputName
            control
            defaultValue={Select_Unit.AmountStatus.KG->Select_Unit.Amount.status_encode}
            render={({field: {ref, value, onChange}}) =>
              <Select_Unit.Amount
                forwardRef=ref
                status={value
                ->Select_Unit.Amount.status_decode
                ->Result.getWithDefault(Select_Unit.AmountStatus.KG)}
                onChange={status => {
                  status->Select_Unit.Amount.status_encode->Controller.OnChangeArg.value->onChange
                }}
              />}
          />
          <div className=%twc("flex gap-2 items-center grow")>
            <Controller
              name=showEachInputName
              control
              defaultValue={false->Js.Json.boolean}
              render={({field: {name, onChange, value}}) => <>
                <Checkbox
                  checked={value->Js.Json.decodeBoolean->Option.getWithDefault(false)}
                  id=name
                  onChange={e => e->Controller.OnChangeArg.event->onChange}
                />
                <label htmlFor=name> {`입수 정보 입력`->React.string} </label>
              </>}
            />
          </div>
        </div>
        <ErrorMessage
          errors
          name
          render={_ =>
            <span className=%twc("flex")>
              <IconError width="20" height="20" />
              <span className=%twc("text-sm text-notice ml-1")>
                {`중량을 입력해주세요.(음수입력 불가)`->React.string}
              </span>
            </span>}
        />
      </div>
    </>
  }
}

module PriceInput = {
  @react.component
  let make = (~inputName) => {
    let {register, formState: {errors}} = Hooks.Context.use(.
      ~config=Hooks.Form.config(~mode=#onChange, ()),
      (),
    )

    let {ref, name, onChange, onBlur} = register(.
      inputName,
      Some(Hooks.Register.config(~required=true, ~valueAsNumber=true, ~min=0, ())),
    )

    <div className=%twc("flex flex-col w-[158px] min-w-[158px]")>
      <label className=%twc("block")>
        <span className=%twc("font-bold")> {`바이어판매가`->React.string} </span>
        <span className=%twc("text-red-500")> {`*`->React.string} </span>
      </label>
      <input
        id=name
        ref
        type_="number"
        name
        onChange
        onBlur
        className=%twc("mt-2 w-full h-9 px-3 py-2 border border-gray-300 rounded-lg")
        placeholder={`가격입력`}
      />
      <ErrorMessage
        errors
        name
        render={_ =>
          <span className=%twc("flex")>
            <IconError width="20" height="20" />
            <span className=%twc("text-sm text-notice ml-1")>
              {`바이어판매가를 입력해주세요.`->React.string}
            </span>
          </span>}
      />
    </div>
  }
}
module OptionStatusSelect = {
  @react.component
  let make = (~inputName) => {
    let {control, formState: {errors}} = Hooks.Context.use(.
      ~config=Hooks.Form.config(~mode=#onChange, ()),
      (),
    )

    <div className=%twc("flex flex-col w-[158px] min-w-[158px]")>
      <label className=%twc("block")>
        <span className=%twc("font-bold")> {`운영상태`->React.string} </span>
        <span className=%twc("text-red-500")> {`*`->React.string} </span>
      </label>
      <div className=%twc("mt-2 w-full h-9")>
        <Controller
          name=inputName
          control
          rules={Rules.make(~required=true, ())}
          render={({field: {ref, name, value, onChange}}) =>
            <div>
              <Select_Product_Operation_Status.Base
                forwardRef=ref
                status={value
                ->Select_Product_Operation_Status.Base.status_decode
                ->Result.mapWithDefault(None, v => Some(v))}
                onChange={status => {
                  status
                  ->Select_Product_Operation_Status.Base.status_encode
                  ->Controller.OnChangeArg.value
                  ->onChange
                }}
              />
              <ErrorMessage
                errors
                name
                render={_ =>
                  <span className=%twc("flex")>
                    <IconError width="20" height="20" />
                    <span className=%twc("text-sm text-notice ml-1")>
                      {`운영상태를 입력해주세요.`->React.string}
                    </span>
                  </span>}
              />
            </div>}
        />
      </div>
    </div>
  }
}

module IsFreeShipping = {
  @react.component
  let make = (~inputName) => {
    let {control, formState: {errors}} = Hooks.Context.use(.
      ~config=Hooks.Form.config(~mode=#onChange, ()),
      (),
    )

    let toStatus = statusFromSelect => {
      statusFromSelect
      ->Select_Product_Shipping_Type.status_decode
      ->Result.mapWithDefault(None, v => Some(v))
    }

    <div className=%twc("flex flex-col w-[158px] min-w-[158px]")>
      <label className=%twc("block")>
        <span className=%twc("font-bold")> {`배송비 타입`->React.string} </span>
        <span className=%twc("text-red-500")> {`*`->React.string} </span>
      </label>
      <span className=%twc("mt-2 w-full h-9")>
        <Controller
          name=inputName
          control
          rules={Rules.make(~required=true, ())}
          render={({field: {ref, name, value, onChange}}) => {
            <div>
              <Select_Product_Shipping_Type
                forwardRef=ref
                status={value->toStatus}
                onChange={selected => {
                  selected
                  ->Select_Product_Shipping_Type.status_encode
                  ->Controller.OnChangeArg.value
                  ->onChange
                }}
              />
              <ErrorMessage
                errors
                name
                render={_ => {
                  <span className=%twc("flex")>
                    <IconError width="20" height="20" />
                    <span className=%twc("text-sm text-notice ml-1")>
                      {`배송비 타입을 입력해주세요.`->React.string}
                    </span>
                  </span>
                }}
              />
            </div>
          }}
        />
      </span>
    </div>
  }
}

module RawCostInput = {
  @react.component
  let make = (~inputName) => {
    let {register, formState: {errors}} = Hooks.Context.use(.
      ~config=Hooks.Form.config(~mode=#onChange, ()),
      (),
    )

    let {ref, name, onChange, onBlur} = register(.
      inputName,
      Some(Hooks.Register.config(~required=true, ~valueAsNumber=true, ~min=0, ())),
    )

    <div className=%twc("flex flex-col w-[158px] min-w-[158px]")>
      <label className=%twc("block") htmlFor=name>
        <span className=%twc("font-bold")> {`생산자 원물원가`->React.string} </span>
        <span className=%twc("text-red-500")> {`*`->React.string} </span>
      </label>
      <input
        ref
        id=name
        type_="number"
        name
        onChange
        onBlur
        className=%twc(
          "mt-2 w-full h-9 px-3 py-2 border border-gray-300 rounded-lg focus:outline-none"
        )
        placeholder={`가격입력`}
      />
      <ErrorMessage
        errors
        name
        render={_ =>
          <span className=%twc("flex")>
            <IconError width="20" height="20" />
            <span className=%twc("text-sm text-notice ml-1")>
              {`생산자원물원가를 입력해주세요.`->React.string}
            </span>
          </span>}
      />
    </div>
  }
}

module WorkingCostInput = {
  @react.component
  let make = (~inputName) => {
    let {register, formState: {errors}} = Hooks.Context.use(.
      ~config=Hooks.Form.config(~mode=#onChange, ()),
      (),
    )

    let {ref, name, onChange, onBlur} = register(.
      inputName,
      Some(Hooks.Register.config(~required=true, ~valueAsNumber=true, ~min=0, ())),
    )

    <div className=%twc("flex flex-col w-[158px] min-w-[158px]")>
      <label className=%twc("block") htmlFor=name>
        <span className=%twc("font-bold")> {`생산자 포장작업비`->React.string} </span>
        <span className=%twc("text-red-500")> {`*`->React.string} </span>
      </label>
      <input
        ref
        id=name
        type_="number"
        name
        onChange
        onBlur
        className=%twc(
          "mt-2 w-full h-9 px-3 py-2 border border-gray-300 rounded-lg focus:outline-none"
        )
        placeholder={`가격입력`}
      />
      <ErrorMessage
        errors
        name
        render={_ =>
          <span className=%twc("flex")>
            <IconError width="20" height="20" />
            <span className=%twc("text-sm text-notice ml-1")>
              {`생산자 포장작업비를 입력해주세요.`->React.string}
            </span>
          </span>}
      />
    </div>
  }
}

module DeliveryCostInput = {
  module Disabled = {
    @react.component
    let make = () => {
      <div className=%twc("flex flex-col w-[158px] min-w-[158px] gap-2")>
        <span className=%twc("font-bold block")> {`생산자 택배비`->React.string} </span>
        <div className=%twc("h-9 w-full px-3 py-2 border border-gray-300 bg-gray-100 rounded-lg")>
          <span className=%twc("text-disabled-L2")> {`택배 불가능`->React.string} </span>
        </div>
      </div>
    }
  }

  @react.component
  let make = (~inputName) => {
    let {register, formState: {errors}} = Hooks.Context.use(.
      ~config=Hooks.Form.config(~mode=#onChange, ()),
      (),
    )

    let {ref, name, onChange, onBlur} = register(.
      inputName,
      Some(Hooks.Register.config(~required=true, ~valueAsNumber=true, ~min=0, ())),
    )

    <div className=%twc("flex flex-col w-[158px] min-w-[158px]")>
      <label className=%twc("block") htmlFor=name>
        <span className=%twc("font-bold")> {`생산자 택배비`->React.string} </span>
        <span className=%twc("text-red-500")> {`*`->React.string} </span>
      </label>
      <input
        ref
        id=name
        type_="number"
        name
        onChange
        onBlur
        className=%twc(
          "mt-2 w-full h-9 px-3 py-2 border border-gray-300 rounded-lg focus:outline-none"
        )
        placeholder={`가격입력`}
      />
      <ErrorMessage
        errors
        name
        render={_ =>
          <span className=%twc("flex")>
            <IconError width="20" height="20" />
            <span className=%twc("text-sm text-notice ml-1")>
              {`생산자 택배비를 입력해주세요.`->React.string}
            </span>
          </span>}
      />
    </div>
  }
}

module TotalRawCost = {
  @react.component
  let make = (~inputNames: Form.inputNames) => {
    let watchCost = Hooks.WatchValues.use(
      Hooks.WatchValues.Texts,
      ~config=Hooks.WatchValues.config(
        ~name=[inputNames.rawCost, inputNames.workingCost, inputNames.deliveryCost],
        (),
      ),
      (),
    )

    let toFiniteFloat = optionStr =>
      optionStr->Option.flatMap(Float.fromString)->Option.keep(Js.Float.isFinite)

    let totalRawCost = switch watchCost {
    | Some([rawCost, workingCost, deliveryCost]) => {
        let rawCost' = rawCost->toFiniteFloat->Option.getWithDefault(0.)
        let workingCost' = workingCost->toFiniteFloat->Option.getWithDefault(0.)
        let deliveryCost' = deliveryCost->toFiniteFloat->Option.getWithDefault(0.)
        rawCost' +. workingCost' +. deliveryCost'
      }

    | _ => 0.
    }

    <div className=%twc("flex flex-col w-[158px] min-w-[158px]")>
      <label className=%twc("whitespace-nowrap block")>
        <span className=%twc("font-bold")> {`생산자 총 공급원가`->React.string} </span>
        <span className=%twc("text-gray-600")> {` *자동계산`->React.string} </span>
      </label>
      <div className=%twc("mt-2 h-9 w-full px-3 py-2 border border-gray-300 rounded-lg")>
        {totalRawCost->Float.toString->React.string}
      </div>
    </div>
  }
}

module CostTypeSelect = {
  @react.component
  let make = (~inputName) => {
    let {control, formState: {errors}} = Hooks.Context.use(.
      ~config=Hooks.Form.config(~mode=#onChange, ()),
      (),
    )

    <div className=%twc("flex flex-col w-[158px] min-w-[158px]")>
      <label className=%twc("block")>
        <span className=%twc("font-bold")> {`생산자 공급가 타입`->React.string} </span>
        <span className=%twc("text-red-500")> {`*`->React.string} </span>
      </label>
      <div className=%twc("mt-2 w-full h-9")>
        <Controller
          name=inputName
          control
          rules={Rules.make(~required=true, ())}
          render={({field: {ref, name, value, onChange}}) =>
            <div>
              <Select_Producer_Contract_Type
                forwardRef=ref
                status={value
                ->Select_Producer_Contract_Type.status_decode
                ->Result.mapWithDefault(None, v => v->Some)}
                onChange={status => {
                  status
                  ->Select_Producer_Contract_Type.status_encode
                  ->Controller.OnChangeArg.value
                  ->onChange
                }}
              />
              <ErrorMessage
                errors
                name
                render={_ =>
                  <span className=%twc("flex")>
                    <IconError width="20" height="20" />
                    <span className=%twc("text-sm text-notice ml-1")>
                      {`공급가 타입을 입력해주세요.`->React.string}
                    </span>
                  </span>}
              />
            </div>}
        />
      </div>
    </div>
  }
}

module ShippingUnitQuantityInput = {
  @react.component
  let make = (~inputName) => {
    let {register, formState: {errors}} = Hooks.Context.use(.
      ~config=Hooks.Form.config(~mode=#onChange, ()),
      (),
    )

    let {ref, name, onChange, onBlur} = register(.
      inputName,
      Some(Hooks.Register.config(~required=true, ~valueAsNumber=true, ~min=1, ())),
    )

    <div className=%twc("flex flex-col w-[158px] min-w-[158px]")>
      <label className=%twc("block") htmlFor=name>
        <span className=%twc("font-bold")> {`배송 합포장 단위`->React.string} </span>
        <span className=%twc("text-red-500")> {`*`->React.string} </span>
      </label>
      <input
        ref
        id=name
        type_="number"
        name
        onChange
        onBlur
        className=%twc(
          "mt-2 w-full h-9 px-3 py-2 border border-gray-300 rounded-lg focus:outline-none"
        )
        placeholder={`배송 합포장 단위 입력`}
        defaultValue="1"
      />
      <ErrorMessage
        errors
        name
        render={e =>
          <span className=%twc("flex")>
            <IconError width="20" height="20" />
            <span className=%twc("text-sm text-notice ml-1")>
              {`합포장 단위를 입력해주세요. (1 미만 입력 불가)`->React.string}
            </span>
          </span>}
      />
    </div>
  }
}

module AdhocStockIsLimitedCheckbox = {
  @react.component
  let make = (~inputName) => {
    let {register} = Hooks.Context.use(. ~config=Hooks.Form.config(~mode=#onChange, ()), ())

    let {name, onChange, onBlur, ref} = register(. inputName, None)

    <div className=%twc("flex flex-col gap-2 h-[125px] mr-10")>
      <div className=%twc("block")>
        <span className=%twc("font-bold")> {`공급 수량 설정`->React.string} </span>
      </div>
      <div className=%twc("flex gap-2 items-center")>
        <Checkbox.Uncontrolled defaultChecked={false} id=name name onChange onBlur inputRef=ref />
        <label htmlFor=name className=%twc("cursor-pointer")>
          {`공급 수량 설정하기`->React.string}
        </label>
      </div>
    </div>
  }
}

module AdhocStockNumLimit = {
  @react.component
  let make = (~inputName, ~adhocStockIsLimitedCheckboxName) => {
    let {register, formState: {errors}, setValue} = Hooks.Context.use(.
      ~config=Hooks.Form.config(~mode=#onChange, ()),
      (),
    )

    let quotableCheckboxValue = Hooks.WatchValues.use(
      Hooks.WatchValues.Checkbox,
      ~config=Hooks.WatchValues.config(~name=adhocStockIsLimitedCheckboxName, ()),
      (),
    )

    let isDisabled = switch quotableCheckboxValue {
    | Some(true) => false
    | _ => true
    }

    let {ref, name, onChange, onBlur} = register(.
      inputName,
      Some(Hooks.Register.config(~required=!isDisabled, ~valueAsNumber=!isDisabled, ())),
    )

    // react-hook-form의 handleSubmit 단계에서 데이터가 undefined가 되므로 decode가 불가능해진다.
    // 단품을 생성하는 경우, 어드민 유저가 판매 가능 수량 관리기능을 비활성화했다면 기본 값을 null로 변경시킨다.
    switch isDisabled {
    | true => setValue(. inputName, Js.Json.null)
    | false => ()
    }

    <div className=%twc("flex flex-col w-[158px] min-w-[158px]")>
      <label className=%twc("block")>
        <span className={isDisabled ? %twc("font-bold text-gray-400") : %twc("font-bold")}>
          {`공급 수량`->React.string}
        </span>
        <span className={isDisabled ? %twc("text-gray-400") : %twc("text-red-500")}>
          {`*`->React.string}
        </span>
      </label>
      <input
        id=name
        ref
        type_="number"
        name
        onChange
        onBlur
        disabled={isDisabled}
        readOnly={isDisabled}
        className=%twc("mt-2 w-full h-9 px-3 py-2 border border-gray-300 rounded-lg")
        placeholder={`공급 수량 입력`}
        defaultValue={"0"}
      />
      <ErrorMessage
        errors
        name
        render={_ =>
          <span className=%twc("flex")>
            <IconError width="20" height="20" />
            <span className=%twc("text-sm text-notice ml-1")>
              {`올바른 공급수량을 입력해주세요.`->React.string}
            </span>
          </span>}
      />
    </div>
  }
}

module AdhocStockNumSold = {
  @react.component
  let make = (~adhocStockIsLimitedCheckboxName) => {
    let quotableCheckboxValue = Hooks.WatchValues.use(
      Hooks.WatchValues.Checkbox,
      ~config=Hooks.WatchValues.config(~name=adhocStockIsLimitedCheckboxName, ()),
      (),
    )

    let isDisabled = switch quotableCheckboxValue {
    | Some(true) => false
    | _ => true
    }

    <div className=%twc("flex flex-col w-[158px] min-w-[158px]")>
      <label className=%twc("whitespace-nowrap block")>
        <span className={isDisabled ? %twc("font-bold text-gray-400") : %twc("font-bold")}>
          {`판매된 수량`->React.string}
        </span>
        <span className={isDisabled ? %twc("text-gray-400") : %twc("text-gray-600")}>
          {` *자동계산`->React.string}
        </span>
      </label>
      <div className=%twc("mt-2 h-9 w-full px-3 py-2 border border-gray-300 rounded-lg")>
        {"-"->React.string}
      </div>
    </div>
  }
}

module AdhocStockNumRemaining = {
  @react.component
  let make = (~adhocStockNumLimitName, ~adhocStockIsLimitedCheckboxName) => {
    let quotableCheckboxValue = Hooks.WatchValues.use(
      Hooks.WatchValues.Checkbox,
      ~config=Hooks.WatchValues.config(~name=adhocStockIsLimitedCheckboxName, ()),
      (),
    )

    let isDisabled = switch quotableCheckboxValue {
    | Some(true) => false
    | _ => true
    }

    let adhocStockNumLimitValue = Hooks.WatchValues.use(
      Hooks.WatchValues.Text,
      ~config=Hooks.WatchValues.config(~name=adhocStockNumLimitName, ()),
      (),
    )

    let remaining = adhocStockNumLimitValue->Option.flatMap(Int.fromString)
    let isShowWarningMessage = remaining->Option.mapWithDefault(false, x => 0 > x)

    <div className=%twc("flex flex-col w-[158px] min-w-[158px]")>
      <label className=%twc("whitespace-nowrap block")>
        <span className={isDisabled ? %twc("font-bold text-gray-400") : %twc("font-bold")}>
          {`판매 가능 수량`->React.string}
        </span>
        <span className={isDisabled ? %twc("text-gray-400") : %twc("text-gray-600")}>
          {` *자동계산`->React.string}
        </span>
      </label>
      <div className=%twc("mt-2 h-9 w-full px-3 py-2 border border-gray-300 rounded-lg")>
        {remaining->Option.mapWithDefault("-", x => x->Int.toString)->React.string}
      </div>
      // Error Message를 보여주더라도 submit이 가능해야하여,
      // Hook form의 ErrorMessage를 사용하지 않고 별도로 처리합니다.
      {switch isShowWarningMessage {
      | true =>
        <span className=%twc("flex")>
          <IconError width="20" height="20" />
          <span className=%twc("text-sm text-notice ml-1")>
            {"주문 취소가 필요합니다"->React.string}
          </span>
        </span>
      | false => React.null
      }}
    </div>
  }
}

module AdhocStockIsNumRemainingVisibleCheckbox = {
  @react.component
  let make = (~inputName, ~adhocStockIsLimitedCheckboxName) => {
    let {register, setValue} = Hooks.Context.use(.
      ~config=Hooks.Form.config(~mode=#onChange, ()),
      (),
    )

    let adhocStockIsLimitedCheckboxValue = Hooks.WatchValues.use(
      Hooks.WatchValues.Checkbox,
      ~config=Hooks.WatchValues.config(~name=adhocStockIsLimitedCheckboxName, ()),
      (),
    )

    let isDisabled = switch adhocStockIsLimitedCheckboxValue {
    | Some(true) => false
    | _ => true
    }

    let {name, onChange, onBlur, ref} = register(. inputName, None)

    // AdhocStockIsLimitedCheckbox가 false인 경우,
    // AdhocStockIsNumRemainingVisible을 false로 설정합니다.
    React.useEffect1(() => {
      switch isDisabled {
      | true => setValue(. inputName, false->Js.Json.boolean)
      | false => ()
      }
      None
    }, [isDisabled])

    <div className=%twc("flex flex-col gap-2 h-16")>
      <div className=%twc("block")>
        <span className={isDisabled ? %twc("font-bold text-gray-400") : %twc("font-bold")}>
          {`판매 가능 수량 노출 설정`->React.string}
        </span>
      </div>
      <div className=%twc("flex gap-2 items-center")>
        <Checkbox.Uncontrolled
          defaultChecked={false}
          id=name
          name
          onChange
          onBlur
          inputRef=ref
          disabled={isDisabled}
          readOnly={isDisabled}
        />
        <label htmlFor=name className={isDisabled ? %twc("text-gray-400") : %twc("cursor-pointer")}>
          {`판매 가능 수량 노출하기`->React.string}
        </label>
      </div>
    </div>
  }
}

module CutOffTimeInput = {
  @react.component
  let make = (~inputName) => {
    let {register, formState: {errors}} = Hooks.Context.use(.
      ~config=Hooks.Form.config(~mode=#onChange, ()),
      (),
    )
    let {ref, name, onChange, onBlur} = register(.
      inputName,
      Some(Hooks.Register.config(~maxLength=100, ())),
    )

    <div className=%twc("flex flex-col gap-2 min-w-1/2 max-w-2xl")>
      <label htmlFor=name>
        <span className=%twc("font-bold")> {`출고기준시간`->React.string} </span>
      </label>
      <textarea
        ref
        id=name
        name
        onChange
        onBlur
        className=%twc(
          "px-3 py-2 border border-border-default-L1 rounded-lg focus:outline-none h-9"
        )
        placeholder={`출고기준시간 입력(최대 100자)`}
        defaultValue={`10시 이전 발주 완료건에 한해 당일 출고(단, 산지 상황에 따라 출고 일정은 변경 될 수 있습니다.)`}
      />
      <ErrorMessage
        errors
        name
        render={_ =>
          <span className=%twc("flex")>
            <IconError width="20" height="20" />
            <span className=%twc("text-sm text-notice ml-1")>
              {`최대 100자까지 입력가능합니다.`->React.string}
            </span>
          </span>}
      />
    </div>
  }
}

module MemoInput = {
  @react.component
  let make = (~inputName) => {
    let {register, formState: {errors}} = Hooks.Context.use(.
      ~config=Hooks.Form.config(~mode=#onChange, ()),
      (),
    )
    let {ref, name, onChange, onBlur} = register(.
      inputName,
      Some(Hooks.Register.config(~maxLength=100, ())),
    )

    <div className=%twc("flex flex-col gap-2 min-w-1/2 max-w-2xl")>
      <label htmlFor=name>
        <span className=%twc("font-bold")> {`메모`->React.string} </span>
      </label>
      <textarea
        ref
        id=name
        name
        onChange
        onBlur
        className=%twc(
          "px-3 py-2 border border-border-default-L1 rounded-lg focus:outline-none h-9"
        )
        placeholder={`메모사항 입력(최대 100자)`}
      />
      <ErrorMessage
        errors
        name
        render={_ =>
          <span className=%twc("flex")>
            <IconError width="20" height="20" />
            <span className=%twc("text-sm text-notice ml-1")>
              {`최대 100자까지 입력가능합니다.`->React.string}
            </span>
          </span>}
      />
    </div>
  }
}

@react.component
let make = (
  ~prefix,
  ~index,
  ~remove,
  ~prepend: Hooks.FieldArray.prepend,
  ~isOnlyOneRemained,
  ~productDisplayName,
  ~applyAll,
  ~setApplyAll,
  ~isCourierAvailable,
) => {
  //prefix 형식 : options.[index]
  let {getValues, control} = Hooks.Context.use(. ~config=Hooks.Form.config(~mode=#onChange, ()), ())

  let values = {
    getValues(. [prefix])->Js.Json.decodeArray->Option.getWithDefault([])->Garter.Array.first
  }
  let (isShowRemove, setShowRemove) = React.Uncurried.useState(_ => Dialog.Hide)

  let inputNames = Form.makeNames(prefix)

  let onClickDelete = ReactEvents.interceptingHandler(_ => setShowRemove(._ => Dialog.Show))

  let onClickCopy = ReactEvents.interceptingHandler(_ => {
    setApplyAll(._ => false)
    switch values {
    | None => ()
    | Some(v) => {
        let focusOptions = Hooks.FieldArray.focusOptions(~shouldFocus=true, ())
        prepend(. v, ~focusOptions, ())
      }
    }
  })

  let onClickApplyAll = ReactEvents.interceptingHandler(_ => setApplyAll(.prev => !prev))

  let showEach = Hooks.WatchValues.use(
    Hooks.WatchValues.Checkbox,
    ~config=Hooks.WatchValues.config(~control, ~name=inputNames.showEach, ()),
    (),
  )

  <div className=%twc("bg-gray-50 border border-gray-200 px-3 py-7 rounded text-sm")>
    <RadixUI.Collapsible.Root defaultOpen={true}>
      // 기본정보
      <section className=%twc("flex flex-col gap-6")>
        <div className=%twc("flex flex-col gap-2")>
          <div className=%twc("flex justify-between")>
            <div className=%twc("flex items-center justify-start")>
              <span className=%twc("block font-bold")> {`단품 기본정보`->React.string} </span>
              <button
                onClick=onClickCopy
                className=%twc("ml-2 px-2 py-1 bg-green-500 text-white focus:outline-none rounded")>
                {`복사하기`->React.string}
              </button>
              <button
                className=%twc("ml-2 px-2 py-1 bg-gray-100 rounded focus:outline-none")
                disabled=isOnlyOneRemained
                onClick=onClickDelete>
                {`삭제하기`->React.string}
              </button>
            </div>
            <RadixUI.Collapsible.Trigger className=%twc("collabsible-trigger")>
              <div className=%twc("flex items-center cursor-pointer relative gap-1")>
                <span className=%twc("underline")> {`단품정보 접기`->React.string} </span>
                <IconArrow
                  height="16" width="16" fill="#000000" className=%twc("transform -rotate-90")
                />
              </div>
            </RadixUI.Collapsible.Trigger>
          </div>
          // 단품명, 자동생성단품명
          <div className=%twc("flex gap-2")>
            <NameInput inputName=inputNames.name />
            <AutoGeneratedName inputNames />
            <OptionCode />
          </div>
        </div>
      </section>
      <RadixUI.Collapsible.Content className=%twc("collabsible-content")>
        <div className=%twc("divide-y")>
          // 등급, 포장재질
          <div className=%twc("flex gap-2 py-6")>
            <GradeInput inputName=inputNames.grade />
            <PackageInput inputName=inputNames.package />
          </div>
          // 중량
          <AmountInput
            showEachInputName=inputNames.showEach
            amountInputName=inputNames.amount
            unitInputName=inputNames.amountUnit
          />
          {switch // 입수 정보
          showEach {
          | Some(true) =>
            <Product_Option_Each_Admin
              prefix amountInputName=inputNames.amount amountUnitInputName=inputNames.amountUnit
            />
          | Some(false) | None => React.null
          }}
          <div className=%twc("flex flex-col gap-6 py-6 w-full")>
            // 바이어판매가, 공급원가, 운영상태, 배송비 타입
            <div className=%twc("flex gap-4 items-center justify-start")>
              <PriceInput inputName=inputNames.buyerPrice />
              <TotalRawCost inputNames />
              <OptionStatusSelect inputName=inputNames.operationStatus />
            </div>
            // 원물원가, 포장작업비, 배송비, 공급가타입
            <div className=%twc("flex gap-4 items-center justify-start")>
              <RawCostInput inputName=inputNames.rawCost />
              <WorkingCostInput inputName=inputNames.workingCost />
              {switch isCourierAvailable {
              | true => <DeliveryCostInput inputName=inputNames.deliveryCost />
              | false => <DeliveryCostInput.Disabled />
              }}
            </div>
            // 배송비 타입, 생산자 공급가 타입, 배송 합포장 단위
            <div className=%twc("flex gap-4 items-center justify-start")>
              <IsFreeShipping inputName=inputNames.isFreeShipping />
              <CostTypeSelect inputName=inputNames.costType />
              <ShippingUnitQuantityInput inputName=inputNames.shippingUnitQuantity />
            </div>
          </div>
          // 공급 수량 설정, 공급 수량, 판매된 수량, 판매 가능 수량, 판매 가능 수량 노출 설정
          <div className=%twc("flex flex-col gap-6 py-6 w-full")>
            <div className=%twc("flex gap-4 items-center justify-start")>
              <AdhocStockIsLimitedCheckbox inputName=inputNames.adhocStockIsLimited />
              <AdhocStockNumLimit
                inputName=inputNames.adhocStockNumLimit
                adhocStockIsLimitedCheckboxName=inputNames.adhocStockIsLimited
              />
              <AdhocStockNumSold adhocStockIsLimitedCheckboxName=inputNames.adhocStockIsLimited />
              <AdhocStockNumRemaining
                adhocStockIsLimitedCheckboxName=inputNames.adhocStockIsLimited
                adhocStockNumLimitName=inputNames.adhocStockNumLimit
              />
              <AdhocStockIsNumRemainingVisibleCheckbox
                inputName=inputNames.adhocStockIsNumRemainingVisible
                adhocStockIsLimitedCheckboxName=inputNames.adhocStockIsLimited
              />
            </div>
          </div>
          <div className=%twc("flex flex-col gap-6 py-6 w-full")>
            <CutOffTimeInput inputName=inputNames.cutOffTime />
            <MemoInput inputName=inputNames.memo />
            {switch index {
            | 0 =>
              <div className=%twc("flex gap-2 items-center")>
                <button onClick=onClickApplyAll>
                  <img src={applyAll ? checkboxCheckedIcon : checkboxUncheckedIcon} />
                </button>
                <span>
                  {`[${productDisplayName}] 전체 단품에 출고기준시간과 메모 동일하게 적용하기`->React.string}
                </span>
              </div>
            | _ => React.null
            }}
          </div>
        </div>
      </RadixUI.Collapsible.Content>
    </RadixUI.Collapsible.Root>
    <Dialog
      boxStyle=%twc("text-center rounded-2xl")
      isShow={isShowRemove}
      textOnCancel={`닫기`}
      textOnConfirm={`삭제`}
      kindOfConfirm=Dialog.Negative
      onConfirm={_ => {
        remove(. index)
        setShowRemove(._ => Dialog.Hide)
      }}
      onCancel={_ => {
        setShowRemove(._ => Dialog.Hide)
      }}>
      <p className=%twc("text-gray-500 text-center whitespace-pre-wrap")>
        {`등록중인 단품정보를`->React.string}
        <br />
        {`삭제하시겠어요?`->React.string}
      </p>
    </Dialog>
  </div>
}
