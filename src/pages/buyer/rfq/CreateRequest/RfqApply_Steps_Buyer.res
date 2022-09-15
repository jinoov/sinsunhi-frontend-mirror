module Query = %relay(`
  query RfqApplyStepsBuyer_BrandList_Query(
    $meatSpeciesIds: [ID!]!
    $madeIns: [CountryCode!]
    $isDomestic: Boolean
  ) {
    meatBrands(
      first: 9999
      madeIns: $madeIns
      isDomestic: $isDomestic
      meatSpeciesIds: $meatSpeciesIds
      orderBy: NAME
    ) {
      edges {
        node {
          id
          name
        }
      }
    }
  }
`)

module type Steps = {
  type t

  let first: t
  let last: t
  let length: int

  let getNext: t => option<t>
  let getPrev: t => option<t>

  let tToJs: t => int
  let fromString: string => Result.t<t, string>
  let toString: t => string
}

module ApplySteps = {
  @deriving(jsConverter)
  type t =
    | Package
    | Grade
    | Amount
    | Usage
    | Storage
    | Price
    | Brand
    | Etc

  let first = Package
  let last = Etc
  let length = 8

  let getNext = step =>
    switch step {
    | Package => Some(Grade)
    | Grade => Some(Amount)
    | Amount => Some(Usage)
    | Usage => Some(Storage)
    | Storage => Some(Price)
    | Price => Some(Brand)
    | Brand => Some(Etc)
    | Etc => None
    }

  let getPrev = step =>
    switch step {
    | Package => None
    | Grade => Some(Package)
    | Amount => Some(Grade)
    | Usage => Some(Amount)
    | Storage => Some(Usage)
    | Price => Some(Storage)
    | Brand => Some(Price)
    | Etc => Some(Brand)
    }

  let fromString = str =>
    switch str {
    | "packageMethod" => Result.Ok(Package)
    | "grade" => Result.Ok(Grade)
    | "orderAmount" => Result.Ok(Amount)
    | "usage" => Result.Ok(Usage)
    | "storageMethod" => Result.Ok(Storage)
    | "supplyPrice" => Result.Ok(Price)
    | "brand" => Result.Ok(Brand)
    | "etc" => Result.Ok(Etc)
    | _ => Result.Error("parse error")
    }

  let toString = step =>
    switch step {
    | Package => "packageMethod"
    | Grade => "grade"
    | Amount => "orderAmount"
    | Usage => "usage"
    | Storage => "storageMethod"
    | Price => "supplyPrice"
    | Brand => "brand"
    | Etc => "etc"
    }
}

module RfqStep = (Steps: Steps) => {
  type toList = unit => unit
  type toNext = unit => unit
  type toNextDouble = unit => unit
  type toPrev = unit => unit
  type toFirst = unit => unit
  type push = Steps.t => unit
  type replace = Steps.t => unit

  type router = {
    toList: toList,
    toNext: toNext,
    toNextDouble: toNextDouble,
    toPrev: toPrev,
    toFirst: toFirst,
    push: push,
    replace: replace,
  }

  type output = {
    first: Steps.t,
    current: Steps.t,
    currentIndex: int,
    next: option<Steps.t>,
    nextIndex: int,
    length: int,
    isModify: bool,
    isFirst: bool,
    isLast: bool,
    router: router,
  }

  let use = () => {
    let router = Next.Router.useRouter()
    let {makeWithDict, toString} = module(Webapi.Url.URLSearchParams)

    let getStepQueryString = step => {
      router.query->Js.Dict.set("step", step->Steps.toString)
      router.query->makeWithDict->toString
    }

    let currentStep = switch router.query->Js.Dict.get("step")->Option.map(Steps.fromString) {
    | Some(Result.Ok(step)) => step
    | Some(Result.Error(_)) => Steps.first
    | None => Steps.first
    }

    let isModify = switch router.query->Js.Dict.get("isModify") {
    | Some("true") => true
    | _ => false
    }

    let toList = () => {
      let requestId = router.query->Js.Dict.get("requestId")
      let nextpath = `/buyer/rfq/request/draft/list`
      let nextQueryString =
        switch requestId {
        | Some(requestId') =>
          Js.Dict.fromArray([("requestId", requestId'->Js.Global.encodeURIComponent)])
        | None => Js.Dict.empty()
        }
        ->Webapi.Url.URLSearchParams.makeWithDict
        ->Webapi.Url.URLSearchParams.toString

      router->Next.Router.push(`${nextpath}?${nextQueryString}`)
    }

    let getNextStep = currentStep => {
      switch currentStep->Steps.getNext {
      | Some(nextStep) => nextStep
      | None => currentStep
      }
    }

    let toNext = () => {
      let nextStep = currentStep->getNextStep
      let newQueryString = nextStep->getStepQueryString
      router->Next.Router.push(`${router.pathname}?${newQueryString}`)
    }

    let toNextDouble = () => {
      let nextStep = currentStep->getNextStep->getNextStep
      let newQueryString = nextStep->getStepQueryString
      router->Next.Router.push(`${router.pathname}?${newQueryString}`)
    }

    let toPrev = () =>
      switch currentStep->Steps.getPrev {
      | Some(prevStep) => {
          let newQueryString = prevStep->getStepQueryString
          router->Next.Router.push(`${router.pathname}?${newQueryString}`)
        }

      | None => router->Next.Router.back
      }

    let toFirst = () =>
      router->Next.Router.replace(`${router.pathname}?${Steps.first->getStepQueryString}`)

    let push = step => router->Next.Router.push(`${router.pathname}?${step->getStepQueryString}`)

    let replace = step =>
      router->Next.Router.replace(`${router.pathname}?${step->getStepQueryString}`)

    {
      first: Steps.first,
      current: currentStep,
      currentIndex: currentStep->Steps.tToJs,
      next: currentStep->Steps.getNext,
      nextIndex: currentStep->Steps.tToJs + 1,
      length: Steps.length,
      isModify,
      isFirst: currentStep == Steps.first,
      isLast: currentStep == Steps.last,
      router: {
        toList,
        toNext,
        toNextDouble,
        toPrev,
        toFirst,
        push,
        replace,
      },
    }
  }
}

module RfqApplyStep = RfqStep(ApplySteps)

let convertNumberInputValue = value =>
  value->Js.String2.replaceByRe(%re("/[^0-9]/g"), "")->Js.String2.replaceByRe(%re("/^[0]/g"), "")

let numberToComma = n =>
  n
  ->Float.fromString
  ->Option.mapWithDefault("", x => Intl.Currency.make(~value=x, ~locale={"ko-KR"->Some}, ()))

type buttonType = Full | Normal
module FloatingButton = {
  @react.component
  let make = (~handleClickButton, ~buttonText, ~disabled=false, ~buttonType: buttonType) => {
    <>
      <div className=%twc("fixed bottom-0 max-w-3xl w-full gradient-cta-t tab-highlight-color")>
        <div
          className={switch buttonType {
          | Full => %twc("")
          | Normal => %twc("px-4 py-5")
          }}>
          <button
            disabled
            onClick={handleClickButton}
            className={cx([
              switch buttonType {
              | Full => %twc("")
              | Normal => %twc("rounded-xl")
              },
              %twc("w-full h-14 bg-primary text-white text-lg font-bold"),
              %twc("disabled:bg-disabled-L2 disabled:text-inverted disabled:text-opacity-50"),
            ])}>
            {buttonText->React.string}
          </button>
        </div>
      </div>
      <div className=%twc("h-24") />
    </>
  }
}

type action =
  | PackageMethod(option<string>)
  | Grade(option<string>)
  | WeightKg(string)
  | Usages(array<string>)
  | StorageMethod(string)
  | PrevTradePricePerKg(string)
  | PrevTradeSellerName(string)
  | Brands(array<string>)
  | ETC(string)

module PackageMethod = {
  let checkValidPackageMethod = packageMethod => packageMethod->Option.isSome

  @react.component
  let make = (
    ~packageMethod,
    ~dispatch,
    ~isMutating,
    ~updateItem: (~initializeBrands: bool=?, unit) => unit,
    ~isSkipGrade,
    ~itemId,
    ~requestId,
  ) => {
    let {isModify, router: {toNext, toNextDouble}} = RfqApplyStep.use()

    let trackData = () =>
      {
        "event": "click_rfq_livestock_packagemethod",
        "package_method": packageMethod,
        "request_id": requestId,
        "request_item_id": itemId,
      }
      ->DataGtm.mergeUserIdUnsafe
      ->DataGtm.push

    let handleClickFloatingButton = () => {
      trackData()

      switch (isModify, isSkipGrade) {
      | (true, _) => updateItem()
      // isSkipGrade = true => 축종이 닭이거나, 축종이 돼지이며 수입산인 경우에는 등급체계가 존재하지 않으므로
      // 유저가 불필요한 스텝을 밟지 않도록 `Grade` 스텝에서 입력받을 데이터를 initialState에서 "등급없음"으로 설정해놓고, 해당 스텝을 스킵한다.
      | (false, true) => toNextDouble()
      | (false, false) => toNext()
      }
    }

    let isValidItem = packageMethod->checkValidPackageMethod

    <>
      <section className=%twc("pt-7")>
        <DS_Title.Normal1.Root>
          <DS_Title.Normal1.TextGroup
            title1={`원하시는 포장상태를`} title2={`선택해주세요`}
          />
        </DS_Title.Normal1.Root>
        <DS_ListItem.Normal1.Root className=%twc("space-y-8 text-lg mt-9 tab-highlight-color")>
          <DS_ListItem.Normal1.Item
            onClick={_ =>
              dispatch(PackageMethod(packageMethod->Option.isNone ? Some("RAW") : None))}>
            <DS_ListItem.Normal1.TextGroup title1={`원료육(박스육)`} />
            <DS_ListItem.Normal1.RightGroup>
              {packageMethod->Option.mapWithDefault(
                <DS_Icon.Common.UncheckedLarge1 width="22" height="22" />,
                _ => <DS_Icon.Common.CheckedLarge1 width="22" height="22" fill={"#12B564"} />,
              )}
            </DS_ListItem.Normal1.RightGroup>
          </DS_ListItem.Normal1.Item>
        </DS_ListItem.Normal1.Root>
        <div className=%twc("absolute w-full bottom-[108px] px-5 flex justify-between")>
          <div className=%twc("leading-6 tracking-tight")>
            <h5> {`세절/분쇄가 필요한 경우,`->React.string} </h5>
            <h5> {`담당자에게 문의 부탁드립니다.`->React.string} </h5>
          </div>
          <DataGtm dataGtm={`Contact_RFQ_Livestock_PackageMethod`}>
            <button
              onClick={_ =>
                switch Global.window {
                | Some(window') =>
                  Global.Window.openLink(
                    window',
                    ~url=`${Env.customerServiceUrl}${Env.customerServicePaths["rfqMeatProcess"]}`,
                    ~windowFeatures="",
                    (),
                  )
                | None => ()
                }}
              className=%twc(
                "text-[15px] leading-6 tracking-tight font-bold rounded-lg px-3.5 py-3 border border-border-default-L1 bg-surface"
              )>
              {`문의하기`->React.string}
            </button>
          </DataGtm>
        </div>
      </section>
      <FloatingButton
        buttonText={isModify ? `저장` : `다음`}
        buttonType=Normal
        disabled={!isValidItem || isMutating}
        handleClickButton={_ => handleClickFloatingButton()}
      />
    </>
  }
}

module Grade = {
  let checkValidGrade = grade => grade->Option.isSome
  module List = {
    @react.component
    let make = (
      ~edges: array<RfqApplyBuyer_Query_graphql.Types.response_node_species_meatGrades_edges>,
      ~madeIn,
      ~handleOnChangeGrade,
      ~grade,
    ) => <>
      {edges
      ->Array.keep(x => x.node.madeIn === madeIn)
      ->Array.map(x => {
        let isSelected = grade->Option.mapWithDefault(false, grade' => grade' === x.node.id)

        <DS_ListItem.Normal1.Item
          key={x.node.id} onClick={_ => handleOnChangeGrade(Grade(Some(x.node.id)))}>
          <DS_ListItem.Normal1.TextGroup title1={x.node.grade} />
          <DS_ListItem.Normal1.RightGroup>
            {isSelected
              ? <DS_Icon.Common.RadioOnLarge1 height="24" width="24" fill={"#12B564"} />
              : <DS_Icon.Common.RadioOffLarge1 height="24" width="24" fill={"#B2B2B2"} />}
          </DS_ListItem.Normal1.RightGroup>
        </DS_ListItem.Normal1.Item>
      })
      ->React.array}
    </>
  }

  @react.component
  let make = (
    ~grade,
    ~node: RfqApplyBuyer_Query_graphql.Types.response_node,
    ~dispatch,
    ~isMutating,
    ~updateItem: (~initializeBrands: bool=?, unit) => unit,
    ~itemId,
    ~requestId,
  ) => {
    let {isModify, router: {toNext}} = RfqApplyStep.use()

    let trackData = () =>
      {
        "event": "click_rfq_livestock_meatgrade",
        "request_id": requestId,
        "request_item_id": itemId,
        "meat_grade_id": grade,
      }
      ->DataGtm.mergeUserIdUnsafe
      ->DataGtm.push

    let {part, species} = node
    let isBeef = species->Option.mapWithDefault(false, x => x.name === `소고기`)
    let isDomestic = part->Option.mapWithDefault(false, x => x.isDomestic)
    let edges = species->Option.mapWithDefault([], x => x.meatGrades.edges)

    let isValidItem = grade->checkValidGrade

    let (madeIn, setMadeIn) = React.Uncurried.useState(_ =>
      isDomestic ? #KR : isBeef ? #US : #OTHER
    )

    let handleClickFloatingButton = () => {
      trackData()

      switch isModify {
      | true => updateItem(~initializeBrands=true, ())
      | false => toNext()
      }
    }
    <>
      <section className=%twc("pt-7")>
        <DS_Title.Normal1.Root>
          <DS_Title.Normal1.TextGroup
            title1={`찾으시는 상품의`} title2={`등급을 선택해주세요`}
          />
        </DS_Title.Normal1.Root>
        <div className=%twc("sticky top-[60px] px-5 mt-8")>
          <DS_Tab.LeftTab.Root className=%twc("space-x-0")>
            {isDomestic
              ? <DS_Tab.LeftTab.Item>
                  <DS_Button.Chip.TextSmall1
                    className=%twc("text-sm")
                    label={`국내산`}
                    onClick={_ => setMadeIn(._ => #KR)}
                    selected={madeIn === #KR}
                  />
                </DS_Tab.LeftTab.Item>
              : {
                  switch isBeef {
                  | true =>
                    <>
                      <DS_Tab.LeftTab.Item>
                        <DS_Button.Chip.TextSmall1
                          className=%twc("text-sm")
                          label={`미국산`}
                          onClick={_ => setMadeIn(._ => #US)}
                          selected={madeIn === #US}
                        />
                      </DS_Tab.LeftTab.Item>
                      <DS_Tab.LeftTab.Item>
                        <DS_Button.Chip.TextSmall1
                          className=%twc("text-sm")
                          label={`호주산`}
                          onClick={_ => setMadeIn(._ => #AU)}
                          selected={madeIn === #AU}
                        />
                      </DS_Tab.LeftTab.Item>
                      <DS_Tab.LeftTab.Item>
                        <DS_Button.Chip.TextSmall1
                          className=%twc("text-sm")
                          label={`캐나다산`}
                          onClick={_ => setMadeIn(._ => #CA)}
                          selected={madeIn === #CA}
                        />
                      </DS_Tab.LeftTab.Item>
                      <DS_Tab.LeftTab.Item>
                        <DS_Button.Chip.TextSmall1
                          className=%twc("text-sm")
                          label={`뉴질랜드산`}
                          onClick={_ => setMadeIn(._ => #NZ)}
                          selected={madeIn === #NZ}
                        />
                      </DS_Tab.LeftTab.Item>
                    </>
                  | false =>
                    <DS_Tab.LeftTab.Item>
                      <DS_Button.Chip.TextSmall1
                        className=%twc("text-sm")
                        label={`수입산`}
                        onClick={_ => setMadeIn(._ => #OTHER)}
                        selected={madeIn === #OTHER}
                      />
                    </DS_Tab.LeftTab.Item>
                  }
                }}
          </DS_Tab.LeftTab.Root>
        </div>
        <DS_ListItem.Normal1.Root className=%twc("space-y-8 mt-11 tab-highlight-color")>
          <List edges madeIn grade handleOnChangeGrade={dispatch} />
        </DS_ListItem.Normal1.Root>
      </section>
      <FloatingButton
        buttonText={isModify ? `저장` : `다음`}
        buttonType=Normal
        disabled={!isValidItem || isMutating}
        handleClickButton={_ => handleClickFloatingButton()}
      />
    </>
  }
}

module OrderAmount = {
  let minimumAmount = 50

  let checkValidOrderAmount = weightKg =>
    weightKg
    ->Option.flatMap(x => x->Int.fromString)
    ->Option.mapWithDefault(false, x => x >= minimumAmount)

  @react.component
  let make = (
    ~weightKg,
    ~dispatch,
    ~isMutating,
    ~updateItem: (~initializeBrands: bool=?, unit) => unit,
    ~itemId,
    ~requestId,
  ) => {
    let {isModify, router: {toNext}} = RfqApplyStep.use()

    let isValidItem = weightKg->checkValidOrderAmount

    let trackData = () =>
      {
        "event": "click_rfq_livestock_weightkg",
        "request_id": requestId,
        "request_item_id": itemId,
        "meat_weight_kg": weightKg,
      }
      ->DataGtm.mergeUserIdUnsafe
      ->DataGtm.push

    let handleClickFloatingButton = () => {
      trackData()

      switch isModify {
      | true => updateItem()
      | false => toNext()
      }
    }

    <>
      <section className=%twc("pt-7")>
        <DS_Title.Normal1.Root>
          <DS_Title.Normal1.TextGroup title1={`주문량을`} title2={`작성해주세요`} />
        </DS_Title.Normal1.Root>
        <DS_InputField.Line1.Root className=%twc("mt-4")>
          <DS_InputField.Line1.Input
            type_="text"
            placeholder={`납품 1회당 배송량`}
            inputMode={"decimal"}
            value={weightKg->Option.mapWithDefault(``, x =>
              x->Js.String2.split(".")->Garter_Array.firstExn->numberToComma
            )}
            autoFocus=true
            onChange={e => {
              let value = (e->ReactEvent.Synthetic.target)["value"]
              dispatch(WeightKg(value->convertNumberInputValue))
            }}
            unit={`kg`}
            isClear=true
            fnClear={_ => dispatch(WeightKg(""))}
            underLabelType=#ton
            underLabel={`최소 주문량 ${minimumAmount->Int.toString}kg`}
            errorMessage={weightKg->Option.mapWithDefault(None, x =>
              x
              ->Js.String2.split(".")
              ->Garter_Array.first
              ->Option.flatMap(Int.fromString)
              ->Option.mapWithDefault(None, x =>
                x < minimumAmount
                  ? Some(`최소 주문량은 ${minimumAmount->Int.toString}kg 입니다.`)
                  : None
              )
            )}
            maxLength={6}
          />
        </DS_InputField.Line1.Root>
      </section>
      <FloatingButton
        buttonText={isModify ? `저장` : `다음`}
        buttonType=Normal
        disabled={!isValidItem || isMutating}
        handleClickButton={_ => handleClickFloatingButton()}
      />
    </>
  }
}

module Usages = {
  type check = {
    id: string,
    name: string,
  }

  let checkValidUsage = usages => usages->Array.length > 0

  @react.component
  let make = (
    ~usages,
    ~edges: array<RfqApplyBuyer_Query_graphql.Types.response_node_species_meatUsages_edges>,
    ~dispatch,
    ~isMutating,
    ~updateItem: (~initializeBrands: bool=?, unit) => unit,
    ~itemId,
    ~requestId,
  ) => {
    let {isModify, router: {toNext}} = RfqApplyStep.use()
    let isValidItem = usages->checkValidUsage

    let trackData = () =>
      {
        "event": "click_rfq_livestock_meatusage",
        "request_id": requestId,
        "request_item_id": itemId,
        "meat_usage_ids": usages,
        "meatusage_skip": false,
      }
      ->DataGtm.mergeUserIdUnsafe
      ->DataGtm.push

    let handleClickFloatingButton = () => {
      trackData()

      switch isModify {
      | true => updateItem()
      | false => toNext()
      }
    }

    <>
      <section className=%twc("pt-7")>
        <DS_Title.Normal1.Root>
          <DS_Title.Normal1.TextGroup title1={`사용용도를 알려주세요`} />
        </DS_Title.Normal1.Root>
        <div className=%twc("flex justify-end items-center px-5 mt-1.5")>
          <span className=%twc("text-[13px] text-enabled-L2")>
            {`중복 선택 가능`->React.string}
          </span>
        </div>
        <DS_ListItem.Normal1.Root className=%twc("mt-7 space-y-8 tab-highlight-color")>
          {edges
          ->Array.map(({node: {id, name}}) => {
            let isUnChecked = usages->Array.keep(x => x === id)->Garter.Array.isEmpty
            <DS_ListItem.Normal1.Item
              key={id}
              onClick={_ => {
                dispatch(
                  Usages(
                    isUnChecked ? usages->Array.concat([id]) : usages->Array.keep(x => x != id),
                  ),
                )
              }}>
              <DS_ListItem.Normal1.TextGroup title1={name} titleStyle=%twc("text-lg") />
              <DS_ListItem.Normal1.RightGroup>
                {isUnChecked
                  ? <DS_Icon.Common.UncheckedLarge1 width="22" height="22" />
                  : <DS_Icon.Common.CheckedLarge1 width="22" height="22" fill={"#12B564"} />}
              </DS_ListItem.Normal1.RightGroup>
            </DS_ListItem.Normal1.Item>
          })
          ->React.array}
        </DS_ListItem.Normal1.Root>
      </section>
      <FloatingButton
        buttonText={isModify ? `저장` : `다음`}
        buttonType=Normal
        disabled={!isValidItem || isMutating}
        handleClickButton={_ => handleClickFloatingButton()}
      />
    </>
  }
}

module StorageMethod = {
  let checkValidStorageMethod = storageMethod => storageMethod->Option.isSome

  module List = {
    @react.component
    let make = (~arr, ~handleOnChangeStorageMethod, ~storageMethod) => {
      arr
      ->Array.map(x => {
        let (name, value) = x
        let isSelected =
          storageMethod->Option.mapWithDefault(false, storageMethod' => storageMethod' === value)

        <DS_ListItem.Normal1.Item
          key={value} onClick={_ => handleOnChangeStorageMethod(StorageMethod(value))}>
          <DS_ListItem.Normal1.TextGroup title1={name} />
          <DS_ListItem.Normal1.RightGroup>
            {isSelected
              ? <DS_Icon.Common.RadioOnLarge1 height="24" width="24" fill={"#12B564"} />
              : <DS_Icon.Common.RadioOffLarge1 height="24" width="24" fill={"#B2B2B2"} />}
          </DS_ListItem.Normal1.RightGroup>
        </DS_ListItem.Normal1.Item>
      })
      ->React.array
    }
  }

  @react.component
  let make = (
    ~storageMethod,
    ~dispatch,
    ~isMutating,
    ~updateItem: (~initializeBrands: bool=?, unit) => unit,
    ~itemId,
    ~requestId,
  ) => {
    let {isModify, router: {toNext}} = RfqApplyStep.use()
    let isValidItem = storageMethod->checkValidStorageMethod

    let trackData = () =>
      {
        "event": "click_rfq_livestock_storagestatus",
        "request_id": requestId,
        "request_item_id": itemId,
        "storage_method": storageMethod,
      }
      ->DataGtm.mergeUserIdUnsafe
      ->DataGtm.push

    let handleClickFloatingButton = () => {
      trackData()

      switch isModify {
      | true => updateItem()
      | false => toNext()
      }
    }

    <>
      <section className=%twc("pt-7")>
        <DS_Title.Normal1.Root>
          <DS_Title.Normal1.TextGroup
            title1={`원하시는 보관상태를`} title2={`선택해주세요`}
          />
        </DS_Title.Normal1.Root>
        <DS_ListItem.Normal1.Root className=%twc("space-y-8 text-lg mt-11 tab-highlight-color")>
          <List
            arr={[(`냉동`, `FROZEN`), (`냉장`, `CHILLED`), (`동결`, `FREEZE_DRIED`)]}
            handleOnChangeStorageMethod={dispatch}
            storageMethod
          />
        </DS_ListItem.Normal1.Root>
      </section>
      <FloatingButton
        buttonText={isModify ? `저장` : `다음`}
        buttonType=Normal
        disabled={!isValidItem || isMutating}
        handleClickButton={_ => handleClickFloatingButton()}
      />
    </>
  }
}

module SupplyPrice = {
  let minimumTradePricePerKg = 100

  let checkValidSupplyPrice = prevTradePricePerKg =>
    prevTradePricePerKg
    ->Option.flatMap(x => x->Int.fromString)
    ->Option.mapWithDefault(false, x => x >= minimumTradePricePerKg)

  @react.component
  let make = (
    ~prevTradeSellerName,
    ~prevTradePricePerKg,
    ~dispatch,
    ~isMutating,
    ~updateItem: (~initializeBrands: bool=?, unit) => unit,
    ~itemId,
    ~requestId,
  ) => {
    let {isModify, router: {toNext}} = RfqApplyStep.use()

    let isValidItem = prevTradePricePerKg->checkValidSupplyPrice

    let trackData = () =>
      {
        "event": "click_rfq_livestock_prevtradepriceperkg",
        "request_id": requestId,
        "request_item_id": itemId,
        "prev_trade_price_per_kg": prevTradePricePerKg,
        "prev_trade_seller_name": prevTradeSellerName,
      }
      ->DataGtm.mergeUserIdUnsafe
      ->DataGtm.push

    let handleClickFloatingButton = () => {
      trackData()

      switch isModify {
      | true => updateItem()
      | false => toNext()
      }
    }

    <>
      <section className=%twc("pt-7")>
        <DS_Title.Normal1.Root>
          <DS_Title.Normal1.TextGroup
            title1={`기존 거래 단가를`} title2={`알려주세요`}
          />
        </DS_Title.Normal1.Root>
        <DS_InputField.Line1.Root className=%twc("mt-10")>
          <DS_InputField.Line1.Input
            type_="text"
            placeholder={`기존 거래 단가`}
            inputMode={"decimal"}
            value={prevTradePricePerKg->Option.getWithDefault(``)->numberToComma}
            onChange={e => {
              let value = (e->ReactEvent.Synthetic.target)["value"]
              dispatch(PrevTradePricePerKg(value->convertNumberInputValue))
            }}
            unit={`원/kg`}
            isClear=true
            fnClear={_ => dispatch(PrevTradePricePerKg(""))}
            underLabelType=#won
            errorMessage={prevTradePricePerKg->Option.mapWithDefault(None, x =>
              x
              ->Js.String2.split(".")
              ->Garter_Array.first
              ->Option.flatMap(Int.fromString)
              ->Option.mapWithDefault(None, x =>
                x < minimumTradePricePerKg
                  ? Some(
                      `최소 거래 단가는 ${minimumTradePricePerKg
                        ->Int.toString
                        ->numberToComma}원/kg 입니다.`,
                    )
                  : None
              )
            )}
            maxLength={7}
          />
        </DS_InputField.Line1.Root>
        <DS_InputField.Line1.Root className=%twc("mt-5")>
          <DS_InputField.Line1.Input
            type_="text"
            placeholder={`기존 거래처명`}
            value={prevTradeSellerName->Option.getWithDefault(``)}
            onChange={e => {
              let value = (e->ReactEvent.Synthetic.target)["value"]
              dispatch(PrevTradeSellerName(value))
            }}
            isClear=true
            fnClear={_ => dispatch(PrevTradeSellerName(""))}
            maxLength={30}
          />
        </DS_InputField.Line1.Root>
      </section>
      <FloatingButton
        buttonText={isModify ? `저장` : `다음`}
        buttonType=Normal
        disabled={!isValidItem || isMutating}
        handleClickButton={_ => handleClickFloatingButton()}
      />
    </>
  }
}

module Brand = {
  @react.component
  let make = (
    ~meatBrandIds,
    ~dispatch,
    ~isMutating,
    ~updateItem: (~initializeBrands: bool=?, unit) => unit,
    ~itemId,
    ~requestId,
    ~isNotExistGrades,
    ~grade: option<string>,
    ~node: RfqApplyBuyer_Query_graphql.Types.response_node,
  ) => {
    let {isModify, router: {toNext}} = RfqApplyStep.use()

    let madeIn = switch grade {
    | Some(grade') =>
      node.species
      ->Option.map(x => x.meatGrades.edges)
      ->Option.flatMap(x => x->Array.getBy(x => x.node.id === grade'))
      ->Option.flatMap(x => x.node.madeIn->RfqApplyBuyer_Query_graphql.Utils.countryCode_decode)
    | None => None
    }->Option.getWithDefault(#OTHER)

    let isDomestic = node.part->Option.map(x => x.isDomestic)
    let speciesId = node.species->Option.mapWithDefault("", x => x.id)
    let madeIns = isNotExistGrades ? None : Some([madeIn])

    let (selectedBrandIds, setSelectedBrandIds) = React.Uncurried.useState(_ => meatBrandIds)
    let (isSelectedAnyBrand, setIsSelectedAnyBrand) = React.Uncurried.useState(_ =>
      isModify ? meatBrandIds->Garter_Array.isEmpty : false
    )

    let {meatBrands} = Query.use(
      ~variables={
        meatSpeciesIds: [speciesId],
        madeIns,
        isDomestic,
      },
      (),
    )

    let trackData = () =>
      {
        "event": "click_rfq_livestock_preferredbrand",
        "request_id": requestId,
        "request_item_id": itemId,
        "selected_brand_ids": meatBrandIds,
      }
      ->DataGtm.mergeUserIdUnsafe
      ->DataGtm.push

    let handleClickFloatingButton = () => {
      trackData()

      switch isModify {
      | true => updateItem()
      | false => toNext()
      }
    }

    let isValidItem = switch (isSelectedAnyBrand, selectedBrandIds->Garter_Array.isEmpty) {
    | (true, true)
    | (false, false) => true
    | (true, false)
    | (false, true) => false
    }

    <>
      <section className=%twc("pt-7")>
        <DS_Title.Normal1.Root>
          <DS_Title.Normal1.TextGroup title1={`브랜드를`} title2={`선택해주세요`} />
        </DS_Title.Normal1.Root>
        <div className=%twc("flex justify-end items-center px-5 mt-1.5")>
          <span className=%twc("text-[13px] text-enabled-L2")>
            {`중복 선택 가능`->React.string}
          </span>
        </div>
        <form>
          <ul className=%twc("mt-5")>
            <li>
              <label>
                <div className=%twc("flex justify-between items-center px-5 h-14 cursor-pointer")>
                  <div>
                    <input
                      type_="checkbox"
                      className="appearance-none"
                      checked={isSelectedAnyBrand}
                      onChange={_ => {
                        setIsSelectedAnyBrand(.prev => !prev)
                        setSelectedBrandIds(._ => [])
                        dispatch(Brands([]))
                      }}
                    />
                    {`브랜드 무관`->React.string}
                  </div>
                  <div>
                    {isSelectedAnyBrand
                      ? <DS_Icon.Common.CheckedLarge1 width="22" height="22" fill={"#12B564"} />
                      : <DS_Icon.Common.UncheckedLarge1 width="22" height="22" />}
                  </div>
                </div>
              </label>
            </li>
            {meatBrands.edges
            ->Array.map(brand => {
              let {id, name: brandName} = brand.node
              let isChecked = selectedBrandIds->Array.some(x => x === id)
              <li key={id}>
                <label>
                  <div className=%twc("flex justify-between items-center px-5 h-14 cursor-pointer")>
                    <div>
                      <input
                        type_="checkbox"
                        className="appearance-none"
                        checked={isChecked}
                        onChange={_ => {
                          // 브랜드무관 === [] (Empty Array)
                          // 유저가 브랜드무관을 클릭한 경우에, 나머지 리스트를 모두 초기화하고 브랜드무관만 선택되도록 한다.
                          // 브랜드무관이 선택되어있는 상태에서, 다른 브랜드를 클릭한 경우 브랜드무관을 제거하고 클릭한 브랜드를 추가한다.
                          let nextValue = switch isChecked {
                          | true => selectedBrandIds->Array.keep(x => x != id)
                          | false => selectedBrandIds->Array.concat([id])
                          }

                          dispatch(Brands(nextValue))
                          setSelectedBrandIds(._ => nextValue)
                          setIsSelectedAnyBrand(._ => false)
                        }}
                      />
                      {brandName->React.string}
                    </div>
                    <div>
                      {isChecked
                        ? <DS_Icon.Common.CheckedLarge1 width="22" height="22" fill={"#12B564"} />
                        : <DS_Icon.Common.UncheckedLarge1 width="22" height="22" />}
                    </div>
                  </div>
                </label>
              </li>
            })
            ->React.array}
          </ul>
        </form>
      </section>
      <FloatingButton
        buttonText={isModify ? `저장` : `다음`}
        buttonType=Normal
        disabled={!isValidItem || isMutating}
        handleClickButton={_ => handleClickFloatingButton()}
      />
    </>
  }
}

module Etc = {
  let checkValidEtc = etc => etc->Option.mapWithDefault(false, x => x->Js.String2.length > 0)

  @react.component
  let make = (
    ~etc,
    ~dispatch,
    ~isMutating,
    ~updateItem: (~initializeBrands: bool=?, unit) => unit,
    ~itemId,
    ~requestId,
  ) => {
    let {isModify} = RfqApplyStep.use()
    let isValidItem = etc->checkValidEtc

    let trackData = () =>
      {
        "event": "click_rfq_livestock_otherrequirements",
        "request_id": requestId,
        "request_item_id": itemId,
        "other_requirements": etc,
        "otherrequirements_skip": false,
      }
      ->DataGtm.mergeUserIdUnsafe
      ->DataGtm.push

    let handleClickFloatingButton = () => {
      trackData()
      updateItem()
    }

    <>
      <section className=%twc("pt-7")>
        <DS_Title.Normal1.Root>
          <DS_Title.Normal1.TextGroup
            title1={`기타 요청사항을`} title2={`남겨주세요`}
          />
        </DS_Title.Normal1.Root>
        <div className=%twc("px-5")>
          <DS_Input.InputText1
            type_="text"
            className=%twc("mt-7")
            placeholder={`예: 무항생제 찾습니다`}
            autoFocus=true
            value={etc->Option.getWithDefault(``)}
            onChange={e => {
              let value = (e->ReactEvent.Synthetic.target)["value"]
              dispatch(ETC(value))
            }}
            maxLength=300
          />
        </div>
      </section>
      <FloatingButton
        buttonText={isModify ? `저장` : `다음`}
        buttonType=Normal
        disabled={!isValidItem || isMutating}
        handleClickButton={_ => handleClickFloatingButton()}
      />
    </>
  }
}
