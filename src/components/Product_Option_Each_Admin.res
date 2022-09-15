open ReactHookForm

module Form = {
  @spice
  type each = {
    numMin: float,
    numMax: float,
    sizeMin: float,
    sizeMax: float,
    sizeUnit: Select_Product_Option_Unit.Size.status,
    amountUnit: Select_Product_Option_Unit.Amount.status,
  }

  type inputNames = {
    unitAmount: string,
    minSize: string,
    maxSize: string,
    unitSize: string,
    minNum: string,
    maxNum: string,
    values: string,
  }

  let getNamesWithPrefix = prefix => {
    unitAmount: `${prefix}.each.amountUnit`,
    minSize: `${prefix}.each.sizeMin`,
    maxSize: `${prefix}.each.sizeMax`,
    unitSize: `${prefix}.each.sizeUnit`,
    minNum: `${prefix}.each.numMin`,
    maxNum: `${prefix}.each.numMax`,
    values: `${prefix}.each`,
  }

  let names = {
    unitAmount: "amountUnit",
    minSize: "sizeMin",
    maxSize: "sizeMax",
    unitSize: "sizeUnit",
    minNum: "numMin",
    maxNum: "numMax",
    values: "",
  }
}

let divideNum = (baseUnit, currentUnit) => {
  open Select_Product_Option_Unit.AmountStatus
  switch (baseUnit, currentUnit) {
  | (G, G) => 1.
  | (G, KG) => 1000.
  | (G, T) => 1000000.
  | (KG, G) => 1. /. 1000.
  | (KG, KG) => 1.
  | (KG, T) => 1000.
  | (T, G) => 1. /. 1000000.
  | (T, KG) => 1. /. 1000.
  | (T, T) => 1.
  | (EA, EA) => 1.
  | (ML, ML) => 1.
  | (ML, L) => 1000.
  | (L, ML) => 1. /. 1000.
  | (L, L) => 1.
  | _ => 1.
  }
}

let getPerAmount = (amount, amountUnit, perNum, unitAmount) => {
  open Select_Product_Option_Unit
  let decodedUnit = unitAmount->Option.getWithDefault(AmountStatus.KG)
  let baseAmount = amount /. divideNum(amountUnit, decodedUnit)

  //FIXED 는 항상 소숫점 n 자리를 유지 -> 이를 최대 n 자리로 바꿈
  (baseAmount /. perNum)
  ->Js.Float.toFixedWithPrecision(~digits=2)
  ->Float.fromString
  ->Option.mapWithDefault("", Float.toString)
}

@react.component
let make = (~prefix, ~amountInputName, ~amountUnitInputName, ~readOnly=false) => {
  open Select_Product_Option_Unit

  let {register, control, formState: {errors}, setValue} = Hooks.Context.use(.
    ~config=Hooks.Form.config(~mode=#onChange, ()),
    (),
  )

  let amountAndUnit = Hooks.WatchValues.use(
    Hooks.WatchValues.NullableTexts,
    ~config=Hooks.WatchValues.config(~name=[amountInputName, amountUnitInputName], ()),
    (),
  )

  let (amount, amountUnit) =
    amountAndUnit
    ->Option.map(a => a->Array.map(Js.Nullable.toOption))
    ->Option.flatMap(v => v->Helper.Option.sequence)
    ->Option.flatMap(v =>
      switch v {
      | [amount, unit] => (amount, unit)->Some
      | _ => None
      }
    )
    ->Option.map(((w, u)) => (
      w->Float.fromString,
      u->Amount.fromString->Result.getWithDefault(AmountStatus.G),
    ))
    ->Option.getWithDefault((None, AmountStatus.G))

  let inputNames = Form.getNamesWithPrefix(prefix)

  let eachValues = Hooks.WatchValues.use(
    Hooks.WatchValues.Object,
    ~config=Hooks.WatchValues.config(~name=inputNames.values, ()),
    (),
  )

  let (watchMinNum, watchMaxNum, watchMinSize, watchAmountUnit) = switch eachValues->Option.map(
    Form.each_decode,
  ) {
  | Some(Ok({numMin, numMax, sizeMin, amountUnit})) => (
      Some(numMin),
      Some(numMax),
      Some(sizeMin),
      Some(amountUnit),
    )
  | _ => (None, None, None, None)
  }

  let eachMinNum = register(.
    inputNames.minNum,
    Some(Hooks.Register.config(~required=true, ~valueAsNumber=true, ~min=1, ())),
  )

  let eachMaxNum = register(.
    inputNames.maxNum,
    Some(
      Hooks.Register.config(
        ~required=true,
        ~valueAsNumber=true,
        ~min=watchMinNum->Option.map(Float.toInt)->Option.getWithDefault(1),
        (),
      ),
    ),
  )
  let eachMinSize = register(.
    inputNames.minSize,
    Some(Hooks.Register.config(~required=true, ~valueAsNumber=true, ~min=0, ())),
  )

  let eachMaxSize = register(.
    inputNames.maxSize,
    Some(
      Hooks.Register.config(
        ~required=true,
        ~valueAsNumber=true,
        ~min=watchMinSize->Option.map(Float.toInt)->Option.getWithDefault(0),
        (),
      ),
    ),
  )

  React.useEffect0(() => {
    //폼에서 디폴트 단위 값 설정
    setValue(. inputNames.unitSize, SizeStatus.MM->Size.status_encode)

    None
  })

  React.useEffect2(() => {
    // 측량 단위가 달라질 때, 같은 측량 타입 안에 속하는지 확인한다.
    switch watchAmountUnit {
    | None => ()
    | Some(watchAmountUnit') => {
        let availableOptions = amountUnit->AmountStatus.makeVariation
        switch availableOptions->Array.getBy(option => option == watchAmountUnit') {
        | Some(_) => ()
        | None =>
          setValue(.
            inputNames.unitAmount,
            amountUnit->AmountStatus.makeDefaultUnit->Amount.status_encode,
          )
        }
      }
    }

    None
  }, (amountUnit, watchAmountUnit))

  <div className=%twc("py-6 flex flex-col gap-2")>
    <div className=%twc("flex gap-2 items-center")>
      <label className=%twc("block")> {`입수 정보`->React.string} </label>
      <div
        className=%twc(
          "px-3 py-2 border border-border-default-L1 rounded-lg h-9 bg-disabled-L3 w-36 leading-4.5"
        )>
        {`${amount->Option.mapWithDefault("", Float.toString)}
          ${amountUnit->Amount.toString}`->React.string}
      </div>
      <div>
        <input
          readOnly
          type_="number"
          id=eachMinNum.name
          name=eachMinNum.name
          defaultValue={1.0->Float.toString}
          onChange={eachMinNum.onChange}
          ref=eachMinNum.ref
          onBlur=eachMinNum.onBlur
          className={cx([
            %twc("px-3 py-2 border border-border-default-L1 rounded-lg h-9 focus:outline-none"),
            readOnly ? %twc("bg-disabled-L3") : %twc("bg-white"),
          ])}
          placeholder=`입수 입력`
        />
        <ErrorMessage
          errors
          name={eachMinNum.name}
          render={_ =>
            <span className=%twc("flex")>
              <IconError width="20" height="20" />
              <span className=%twc("text-sm text-notice ml-1")>
                {`입수(최소)를 입력해주세요.`->React.string}
              </span>
            </span>}
        />
      </div>
      <span> {`~`->React.string} </span>
      <div>
        <input
          readOnly
          type_="number"
          defaultValue={1.0->Float.toString}
          id=eachMaxNum.name
          name=eachMaxNum.name
          onChange={eachMaxNum.onChange}
          ref=eachMaxNum.ref
          onBlur=eachMaxNum.onBlur
          className={cx([
            %twc("px-3 py-2 border border-border-default-L1 rounded-lg h-9 focus:outline-none"),
            readOnly ? %twc("bg-disabled-L3") : %twc("bg-white"),
          ])}
          placeholder=`입수 입력`
        />
        <ErrorMessage
          errors
          name={eachMaxNum.name}
          render={_ =>
            <span className=%twc("flex")>
              <IconError width="20" height="20" />
              <span className=%twc("text-sm text-notice ml-1")>
                {`입수(최대)를 입력해주세요.`->React.string}
              </span>
            </span>}
        />
      </div>
    </div>
    <div className=%twc("flex gap-4 flex-wrap")>
      <div className=%twc("flex gap-2 items-center pr-4 border-r border-div-border-L2")>
        <label className=%twc("block shrink-0")> {`개당 무게`->React.string} </label>
        <div
          className=%twc(
            "px-3 py-2 border border-border-default-L1 rounded-lg h-9 bg-disabled-L3 w-36 text-disabled-L1 leading-4.5 focus:outline-none"
          )>
          {switch (amount, amountUnit, watchMaxNum, watchAmountUnit) {
          | (Some(amount'), _, Some(watchMaxNum'), _) =>
            getPerAmount(amount', amountUnit, watchMaxNum', watchAmountUnit)
          | _ => `자동계산`
          }->React.string}
        </div>
        <span> {`~`->React.string} </span>
        <div
          className=%twc(
            "px-3 py-2 border border-border-default-L1 rounded-lg h-9 bg-disabled-L3 w-36 text-disabled-L1 leading-4.5 focus:outline-none"
          )>
          {switch (amount, amountUnit, watchMinNum, watchAmountUnit) {
          | (Some(amount'), _, Some(watchMinNum'), _) =>
            getPerAmount(amount', amountUnit, watchMinNum', watchAmountUnit)
          | _ => `자동계산`
          }->React.string}
        </div>
        <Controller
          name=inputNames.unitAmount
          defaultValue={amountUnit->Amount.status_encode}
          control
          render={({field: {onChange, value, ref}}) => {
            <Amount
              forwardRef=ref
              disabled=readOnly
              status={value
              ->Amount.status_decode
              ->Result.getWithDefault(amountUnit->AmountStatus.makeDefaultUnit)}
              availableOptions={amountUnit->AmountStatus.makeVariation}
              onChange={status =>
                status->Amount.status_encode->Controller.OnChangeArg.value->onChange}
            />
          }}
        />
      </div>
      <div className=%twc("flex gap-2 items-center")>
        <label className=%twc("block shrink-0")> {`개당 크기`->React.string} </label>
        <div>
          <input
            readOnly
            id=eachMinSize.name
            name=eachMinSize.name
            type_="number"
            onChange=eachMinSize.onChange
            onBlur=eachMinSize.onBlur
            ref=eachMinSize.ref
            className={cx([
              %twc(
                "px-3 py-2 border border-border-default-L1 rounded-lg h-9 focus:outline-none shrink"
              ),
              readOnly ? %twc("bg-disabled-L3") : %twc("bg-white"),
            ])}
            placeholder=`최소 크기`
            defaultValue={0.0->Float.toString}
          />
          <ErrorMessage
            errors
            name={eachMinSize.name}
            render={_ =>
              <span className=%twc("flex")>
                <IconError width="20" height="20" />
                <span className=%twc("text-sm text-notice ml-1")>
                  {`개당 최소 크기를 입력해주세요.`->React.string}
                </span>
              </span>}
          />
        </div>
        <span> {`~`->React.string} </span>
        <div>
          <input
            readOnly
            id=eachMaxSize.name
            name=eachMaxSize.name
            type_="number"
            onChange=eachMaxSize.onChange
            onBlur=eachMaxSize.onBlur
            ref=eachMaxSize.ref
            className={cx([
              %twc(
                "px-3 py-2 border border-border-default-L1 rounded-lg h-9 focus:outline-none shrink"
              ),
              readOnly ? %twc("bg-disabled-L3") : %twc("bg-white"),
            ])}
            placeholder=`최대 크기`
            defaultValue={0.0->Float.toString}
          />
          <ErrorMessage
            errors
            name={eachMaxSize.name}
            render={_ =>
              <span className=%twc("flex")>
                <IconError width="20" height="20" />
                <span className=%twc("text-sm text-notice ml-1")>
                  {`개당 최대 크기를 입력해주세요.`->React.string}
                </span>
              </span>}
          />
        </div>
        <Controller
          name={inputNames.unitSize}
          control
          render={({field: {onChange, value, ref}}) =>
            <Size
              disabled=readOnly
              status={value->Size.status_decode->Result.getWithDefault(SizeStatus.MM)}
              onChange={status => {
                onChange(Controller.OnChangeArg.value(status->Size.status_encode))
              }}
              forwardRef=ref
            />}
        />
      </div>
    </div>
  </div>
}
