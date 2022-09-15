module Query = {
  module TradematchDeliveryPolicy = %relay(`
       query TradematchBuyAquaApplyStepsBuyer_TradematchDeliveryPolicy_Query {
         tradematchDeliveryPolicy {
           acceptableDeliveryDate
         }
       }
  `)

  module TradematchTerms = RfqShipping_Buyer.Query.RfqTerms
}

module Mutation = {
  module CreateTradematchDemand = %relay(`
    mutation TradematchBuyAquaApplyStepsBuyer_CreateTradematchDemand_Mutation(
      $connections: [ID!]!
      $input: TradematchDemandCreateInput!
    ) {
      createTradematchDemand(input: $input) {
        ... on Error {
          message
          code
        }
        ... on TradematchDemandMutationPayload {
          result
            @prependNode(
              connections: $connections
              edgeTypeName: "tradematchDemandEdge"
            ) {
            id
            productId
            productOrigin
            numberOfPackagesPerTrade
            wantedPricePerPackage
            tradeCycle
            packageQuantityUnit
            productStorageMethod
            productProcess
            productRequirements
            productSize
            quantityPerPackage
            requestedAt
            status
            canceledAt
            deliveryAddress
            deliveryAddress1
            deliveryAddress2
            deliveryDate
            deliveryRegion
            deliveryZipCode
            draftedAt
          }
        }
      }
    }`)

  module PartialUpdateTradematchDemand = %relay(`
    mutation TradematchBuyAquaApplyStepsBuyer_PartialUpdateTradematchDemand_Mutation(
      $id: ID!
      $input: TradematchDemandPartialUpdateInput!
    ) {
      partialUpdateTradematchDemand(id: $id, input: $input) {
        ... on Error {
          message
          code
        }
        ... on TradematchDemandMutationPayload {
          result {
            id
            productId
            productOrigin
            numberOfPackagesPerTrade
            wantedPricePerPackage
            tradeCycle
            productStorageMethod
            packageQuantityUnit
            productProcess
            productRequirements
            productSize
            quantityPerPackage
            requestedAt
            status
            canceledAt
            deliveryAddress
            deliveryAddress1
            deliveryAddress2
            deliveryDate
            deliveryRegion
            deliveryZipCode
            draftedAt
          }
        }
      }
    }
  `)

  module UpdateTermAgreement = RfqShipping_Buyer.Mutation.UpdateTermAgreement
}

module Title = {
  @react.component
  let make = (~text, ~subText=?, ~label=?) => {
    <div className=%twc("px-5 py-9")>
      {label->Option.mapWithDefault(React.null, x => x)}
      <h2 className=%twc("text-2xl font-bold whitespace-pre-line")> {text->React.string} </h2>
      {switch subText {
      | Some(subText') =>
        <h3 className=%twc("text-gray-600 whitespace-pre-line text-sm mt-3")>
          {subText'->React.string}
        </h3>
      | None => React.null
      }}
    </div>
  }
}

module FloatingButton = {
  @react.component
  let make = (~handleClickButton, ~disabled=false) => {
    let {isLast} = CustomHooks.FarmTradematchStep.use()
    let buttonText = isLast ? `견적 신청 완료` : `다음`
    <>
      <div className=%twc("fixed bottom-0 max-w-3xl w-full gradient-cta-t tab-highlight-color")>
        <div className=%twc("w-full max-w-[768px] px-4 py-5 mx-auto")>
          <button
            disabled
            onClick={handleClickButton}
            className={cx([
              %twc("h-14 w-full rounded-xl bg-primary text-white text-lg font-bold"),
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

module CalendarListitem = {
  @react.component
  let make = (~leftText, ~currentDate, ~handleChangeDate, ~minDate, ~maxDate) => {
    let checkWeekend = (e: Js.Date.t) => {
      e->Js.Date.getDay === 0. || e->Js.Date.getDay === 6.
    }

    <li
      className=%twc(
        "flex items-center min-h-[56px] mx-5 cursor-pointer border-b-2 border-b-border-disabled"
      )>
      <div className=%twc("flex flex-col justify-between truncate")>
        <span className=%twc("block text-base truncate")> {leftText->React.string} </span>
      </div>
      <div className=%twc("ml-auto pl-2")>
        <DatePicker
          id="date"
          date=?{currentDate}
          onFocus={_ => {
            open Webapi
            Dom.document
            ->Dom.Document.getElementById("date")
            ->Option.flatMap(inputEl' => inputEl'->Dom.Element.asHtmlElement)
            ->Option.forEach(inputEl' => inputEl'->Dom.HtmlElement.blur)
          }}
          onChange={e => {
            let newDate = (e->DuetDatePicker.DuetOnChangeEvent.detail).valueAsDate
            handleChangeDate(._ => newDate)
          }}
          isDateDisabled={e => {
            checkWeekend(e)
          }}
          minDate={minDate->DateFns.format("yyyy-MM-dd")}
          maxDate={maxDate->DateFns.format("yyyy-MM-dd")}
          firstDayOfWeek=0
        />
      </div>
    </li>
  }
}

module Origin = {
  open RadixUI
  type origin = Domestic | Imported(string)

  let fromString = str =>
    switch str {
    | str if str == "" => None
    | str if str == `국산` => Some(Domestic)
    | str => Some(Imported(str->Js.String2.replace(`수입산-`, "")))
    }

  let toString = origin =>
    switch origin {
    | Domestic => `국산`
    | Imported(str) => `수입산-${str}`
    }

  @react.component
  let make = (~connectionId, ~productId, ~defaultOrigin=?, ~demandId=?) => {
    let {router: {toNext}} = CustomHooks.AquaTradematchStep.use()
    let {addToast} = ReactToastNotifications.useToasts()

    let (createMutate, isCreateMutating) = Mutation.CreateTradematchDemand.use()
    let (updateMutate, isUpdateMutating) = Mutation.PartialUpdateTradematchDemand.use()

    let (origin, setOrigin) = React.Uncurried.useState(_ =>
      defaultOrigin->Option.flatMap(fromString)
    )

    let toastError = str =>
      addToast(. str->DS_Toast.getToastComponent(#error), {appearance: "error"})

    let pushEvent = (~demandId, ~origin) =>
      {
        "event": "click_intention_seafood_origin",
        "tradematch_demand_id": demandId,
        "origin": origin,
      }
      ->DataGtm.mergeUserIdUnsafe
      ->DataGtm.push

    let handleClickButton = _ => {
      switch demandId {
      | Some(demandId') =>
        updateMutate(
          ~variables={
            id: demandId',
            input: Mutation.PartialUpdateTradematchDemand.make_tradematchDemandPartialUpdateInput(
              ~productOrigin=?{origin->Option.map(toString)},
              (),
            ),
          },
          ~onCompleted=({partialUpdateTradematchDemand}, _) => {
            switch partialUpdateTradematchDemand {
            | #TradematchDemandMutationPayload({result}) => {
                result
                ->Option.map(demand => pushEvent(~demandId=demand.id, ~origin=demand.productOrigin))
                ->ignore
                toNext()
              }

            | _ =>
              toastError(`요청 중 오류가 발생했습니다. 잠시 후 다시 시도해주세요.`)
            }
          },
          ~onError=_ =>
            toastError(`요청 중 오류가 발생했습니다. 잠시 후 다시 시도해주세요.`),
          (),
        )->ignore
      | None =>
        createMutate(
          ~variables={
            connections: [connectionId],
            input: Mutation.CreateTradematchDemand.make_tradematchDemandCreateInput(
              ~productId,
              ~productOrigin=?{origin->Option.map(toString)},
              ~productType=#AQUATIC,
              (),
            ),
          },
          ~onCompleted=({createTradematchDemand}, _) => {
            switch createTradematchDemand {
            | #TradematchDemandMutationPayload({result}) => {
                result
                ->Option.map(demand => pushEvent(~demandId=demand.id, ~origin=demand.productOrigin))
                ->ignore
                toNext()
              }

            | _ =>
              toastError(`요청 중 오류가 발생했습니다. 잠시 후 다시 시도해주세요.`)
            }
          },
          ~onError=_ =>
            toastError(`요청 중 오류가 발생했습니다. 잠시 후 다시 시도해주세요.`),
          (),
        )->ignore
      }
    }

    <div>
      <Title text={`원하시는 원산지를\n선택해주세요.`} />
      <form>
        <RadioGroup.Root
          name="tradematch-origin"
          className=%twc("flex flex-col")
          value={switch origin {
          | None => ""
          | Some(Domestic) => "domestic"
          | Some(Imported(_)) => "imported"
          }}
          onValueChange={v => {
            let origin = switch v {
            | "domestic" => Some(Domestic)
            | "imported" => Some(Imported(""))
            | _ => None
            }

            setOrigin(._ => origin)
          }}>
          <div className=%twc("flex items-center justify-between px-5")>
            <label htmlFor="domestic"> {`국산`->React.string} </label>
            <RadioGroup.Item
              id="domestic"
              value="domestic"
              className={cx([
                %twc(
                  "relative flex items-center justify-center ml-[25px] min-w-[22px] min-h-[22px] max-w-[22px] max-h-[22px] border-[1.5px] rounded-full border-enabled-L4 "
                ),
                %twc(
                  "after:content-[''] after:w-[7px] after:h-[7px] after:bg-enabled-L4 after:bg-opacity-30 after:rounded-full after:absolute "
                ),
              ])}>
              <RadixUI.RadioGroup.Indicator
                className={cx([
                  %twc("relative flex items-center justify-center h-full w-full "),
                  %twc(
                    "after:block after:content-[''] after:rounded-full after:border-green-500 after:border-[7px] after:bg-transparent after:min-w-[22px] after:h-[22px]"
                  ),
                ])}
              />
            </RadioGroup.Item>
          </div>
          <div className=%twc("flex items-center justify-between px-5 mt-10")>
            <label htmlFor="imported"> {`수입산`->React.string} </label>
            <RadioGroup.Item
              id="imported"
              value="imported"
              className={cx([
                %twc(
                  "relative flex items-center justify-center ml-[25px] min-w-[22px] min-h-[22px] max-w-[22px] max-h-[22px] border-[1.5px] rounded-full border-enabled-L4 "
                ),
                %twc(
                  "after:content-[''] after:w-[7px] after:h-[7px] after:bg-enabled-L4 after:bg-opacity-30 after:rounded-full after:absolute "
                ),
              ])}>
              <RadixUI.RadioGroup.Indicator
                className={cx([
                  %twc("relative flex items-center justify-center h-full w-full "),
                  %twc(
                    "after:block after:content-[''] after:rounded-full after:border-green-500 after:border-[7px] after:bg-transparent after:min-w-[22px] after:h-[22px]"
                  ),
                ])}
              />
            </RadioGroup.Item>
          </div>
        </RadioGroup.Root>
        {switch origin {
        | Some(Imported(country)) =>
          <>
            <div className=%twc("px-5 text-gray-500 mt-5 text-sm")>
              {`희망국가`->React.string}
            </div>
            <DS_InputField.Line1.Root className=%twc("mt-4")>
              <DS_InputField.Line1.Input
                type_="text"
                placeholder={`희망 국가를 입력해 주세요`}
                inputMode="text"
                value={country}
                autoFocus=true
                onChange={e => {
                  let value = (e->ReactEvent.Synthetic.target)["value"]
                  setOrigin(._ => Some(Imported(value)))
                }}
                isClear=true
                fnClear={_ => setOrigin(._ => Some(Imported("")))}
                maxLength={50}
              />
            </DS_InputField.Line1.Root>
          </>
        | Some(Domestic) => React.null
        | None => React.null
        }}
        <FloatingButton
          handleClickButton={handleClickButton}
          disabled={isCreateMutating ||
          isUpdateMutating ||
          switch origin {
          | Some(Imported(str)) if str == "" => true
          | None => true
          | _ => false
          }}
        />
      </form>
    </div>
  }
}

module Weight = {
  let convertNumberInputValue = value =>
    value->Js.String2.replaceByRe(%re("/[^0-9]/g"), "")->Js.String2.replaceByRe(%re("/^[0]/g"), "")

  @react.component
  let make = (~demandId, ~defaultWeight=?) => {
    let {router: {toNext}} = CustomHooks.AquaTradematchStep.use()
    let {addToast} = ReactToastNotifications.useToasts()
    let (weight, setWeight) = React.Uncurried.useState(_ =>
      defaultWeight->Option.getWithDefault("")
    )
    let (inputError, setInputError) = React.Uncurried.useState(_ => None)

    let (updateMutate, isUpdateMutating) = Mutation.PartialUpdateTradematchDemand.use()

    let toastError = str =>
      addToast(. str->DS_Toast.getToastComponent(#error), {appearance: "error"})

    let pushEvent = (~demandId, ~weight) =>
      {
        "event": "click_intention_seafood_quantity",
        "tradematch_demand_id": demandId,
        "quantity_per_trade": weight,
      }
      ->DataGtm.mergeUserIdUnsafe
      ->DataGtm.push

    let handleClickButton = ReactEvents.interceptingHandler(_ => {
      pushEvent(~demandId, ~weight)

      switch weight->Int.fromString {
      | Some(weight') =>
        updateMutate(
          ~variables={
            id: demandId,
            input: Mutation.PartialUpdateTradematchDemand.make_tradematchDemandPartialUpdateInput(
              ~quantityPerPackage=1.,
              ~packageQuantityUnit=#KG,
              ~numberOfPackagesPerTrade=weight',
              (),
            ),
          },
          ~onCompleted=({partialUpdateTradematchDemand}, _) => {
            switch partialUpdateTradematchDemand {
            | #TradematchDemandMutationPayload(_) => toNext()

            | _ =>
              toastError(`요청 중 오류가 발생했습니다. 잠시 후 다시 시도해주세요.`)
            }
          },
          ~onError={
            _ =>
              toastError(`요청 중 오류가 발생했습니다. 잠시 후 다시 시도해주세요.`)
          },
          (),
        )->ignore
      | None => setInputError(._ => Some(`숫자를 입력해 주세요.`))
      }

      ()
    })

    <div>
      <Title text={`총 구매 중량을\n입력해주세요.`} />
      <DS_InputField.Line1.Root className=%twc("mt-4")>
        <DS_InputField.Line1.Input
          type_="text"
          placeholder={`총 구매 중량`}
          inputMode={"decimal"}
          value={weight
          ->Float.fromString
          ->Option.map(Locale.Float.show(~digits=0))
          ->Option.getWithDefault("")}
          autoFocus=true
          onChange={e => {
            let value = (e->ReactEvent.Synthetic.target)["value"]
            setWeight(._ => value->convertNumberInputValue)
            setInputError(._ => None)
          }}
          unit="Kg"
          isClear=true
          fnClear={_ => setWeight(._ => "")}
          errorMessage=inputError
          maxLength={11}
        />
      </DS_InputField.Line1.Root>
      <FloatingButton handleClickButton disabled={weight == "" || isUpdateMutating} />
    </div>
  }
}

module Price = {
  let convertNumberInputValue = value =>
    value->Js.String2.replaceByRe(%re("/[^0-9]/g"), "")->Js.String2.replaceByRe(%re("/^[0]/g"), "")

  @react.component
  let make = (~demandId, ~currentWeight, ~defaultPrice=?) => {
    let {router: {toNext}} = CustomHooks.AquaTradematchStep.use()
    let {addToast} = ReactToastNotifications.useToasts()

    let (price, setPrice) = React.Uncurried.useState(_ => defaultPrice->Option.getWithDefault(""))
    let (inputError, setInputError) = React.Uncurried.useState(_ => None)

    let (updateMutate, isUpdateMutating) = Mutation.PartialUpdateTradematchDemand.use()

    let totalPrice =
      price->Float.fromString->Option.mapWithDefault(0., f => f *. currentWeight->Float.fromInt)

    let toastError = str =>
      addToast(. str->DS_Toast.getToastComponent(#error), {appearance: "error"})

    let pushEvent = (~demandId, ~price) =>
      {
        "event": "click_intention_seafood_beforeprice",
        "tradematch_demand_id": demandId,
        "beforeprice_per_trade": price,
      }
      ->DataGtm.mergeUserIdUnsafe
      ->DataGtm.push

    let handleClickButton = _ => {
      pushEvent(~demandId, ~price)

      switch price->Int.fromString {
      | Some(price') =>
        updateMutate(
          ~variables={
            id: demandId,
            input: Mutation.PartialUpdateTradematchDemand.make_tradematchDemandPartialUpdateInput(
              ~wantedPricePerPackage=price',
              (),
            ),
          },
          ~onCompleted=({partialUpdateTradematchDemand}, _) => {
            switch partialUpdateTradematchDemand {
            | #TradematchDemandMutationPayload(_) => toNext()
            | _ =>
              toastError(`요청 중 오류가 발생했습니다. 잠시 후 다시 시도해주세요.`)
            }
          },
          ~onError={
            _ =>
              toastError(`요청 중 오류가 발생했습니다. 잠시 후 다시 시도해주세요.`)
          },
          (),
        )->ignore
      | None => setInputError(._ => Some(`숫자를 입력해 주세요.`))
      }
    }

    <div>
      <Title text={`기존에 kg당\n얼마에 구매하셨어요?`} />
      <DS_InputField.Line1.Root className=%twc("mt-4")>
        <DS_InputField.Line1.Input
          type_="text"
          placeholder={`기존 구매 단가`}
          inputMode={"decimal"}
          value={price
          ->Float.fromString
          ->Option.map(Locale.Float.show(~digits=0))
          ->Option.getWithDefault("")}
          autoFocus=true
          onChange={e => {
            let value = (e->ReactEvent.Synthetic.target)["value"]
            setPrice(._ => value->convertNumberInputValue)
            setInputError(._ => None)
          }}
          unit={`원/Kg`}
          isClear=true
          errorMessage={inputError}
          fnClear={_ => setPrice(._ => "")}
          maxLength={11}
        />
      </DS_InputField.Line1.Root>
      <div className=%twc("mt-9 mx-5")>
        <div
          className=%twc(
            "relative flex justify-between items-center border-border-default-L2 px-4 h-[72px] border-[1px] border-solid rounded-lg mb-3"
          )>
          <div className=%twc("w-[26%] mr-[30px]")>
            <span className=%twc("break-all font-bold")>
              {`총 ${currentWeight->Int.toFloat->Locale.Float.show(~digits=0)}kg`->React.string}
            </span>
          </div>
          <div className=%twc("w-[46%] flex justify-end")>
            <span className=%twc("break-all font-bold")>
              {`${totalPrice->Locale.Float.show(~digits=0)}원`->React.string}
            </span>
          </div>
        </div>
      </div>
      <FloatingButton
        handleClickButton={handleClickButton} disabled={price == "" || isUpdateMutating}
      />
    </div>
  }
}

module StorageMethod = {
  open RadixUI
  @spice
  type status =
    | @spice.as(`상온`) ROOM
    | @spice.as(`냉장`) COLD
    | @spice.as(`냉동`) FROZEN

  let toString = (opt: status) =>
    opt->status_encode->Js.Json.decodeString->Option.getWithDefault("")

  let fromString = str =>
    switch str {
    | str if str == `상온` => Some(ROOM)
    | str if str == `냉장` => Some(COLD)
    | str if str == `냉동` => Some(FROZEN)
    | _ => None
    }

  @react.component
  let make = (~demandId, ~defaultStorageMethod=?) => {
    let {router: {toNext}} = CustomHooks.AquaTradematchStep.use()
    let {addToast} = ReactToastNotifications.useToasts()

    let (updateMutate, isUpdateMutating) = Mutation.PartialUpdateTradematchDemand.use()

    let (status, setStatus) = React.Uncurried.useState(_ => defaultStorageMethod)

    let toastError = str =>
      addToast(. str->DS_Toast.getToastComponent(#error), {appearance: "error"})

    let pushEvent = (~demandId, ~storageMehtod) =>
      {
        "event": "click_intention_seafood_storage",
        "tradematch_demand_id": demandId,
        "storage_method": storageMehtod,
      }
      ->DataGtm.mergeUserIdUnsafe
      ->DataGtm.push

    let handleClickButton = _ => {
      pushEvent(~demandId, ~storageMehtod={status->Option.mapWithDefault("", toString)})

      switch status {
      | Some(status') =>
        updateMutate(
          ~variables={
            id: demandId,
            input: Mutation.PartialUpdateTradematchDemand.make_tradematchDemandPartialUpdateInput(
              ~productStorageMethod=status'->toString,
              (),
            ),
          },
          ~onCompleted=({partialUpdateTradematchDemand}, _) => {
            switch partialUpdateTradematchDemand {
            | #TradematchDemandMutationPayload(_) => toNext()
            | _ =>
              toastError(`요청 중 오류가 발생했습니다. 잠시 후 다시 시도해주세요.`)
            }
          },
          ~onError={
            _ =>
              toastError(`요청 중 오류가 발생했습니다. 잠시 후 다시 시도해주세요.`)
          },
          (),
        )->ignore
      | None => ()
      }
    }

    <div>
      <Title text={`원하시는 보관상태를\n선택해주세요`} />
      <form>
        <RadioGroup.Root
          name="tradematch-temperature"
          value={switch status {
          | Some(status') => status'->toString
          | None => ""
          }}
          onValueChange={v => {
            let status = switch v->Js.Json.string->status_decode {
            | Ok(status') => Some(status')
            | Error(_) => None
            }
            setStatus(._ => status)
          }}>
          {[ROOM, COLD, FROZEN]
          ->Array.map(opt =>
            <li key={opt->toString} className=%twc("flex w-full items-center h-[60px]")>
              <label
                className=%twc(
                  "flex items-center justify-between w-full h-full px-5 cursor-pointer"
                )>
                <div className=%twc("text-text-L1")> {opt->toString->React.string} </div>
                <RadixUI.RadioGroup.Item
                  id={opt->toString}
                  value={opt->toString}
                  className={cx([
                    %twc(
                      "relative flex items-center justify-center ml-[25px] min-w-[22px] min-h-[22px] max-w-[22px] max-h-[22px] border-[1.5px] rounded-full border-enabled-L4 "
                    ),
                    %twc(
                      "after:content-[''] after:w-[7px] after:h-[7px] after:bg-enabled-L4 after:bg-opacity-30 after:rounded-full after:absolute "
                    ),
                  ])}>
                  <RadixUI.RadioGroup.Indicator
                    className={cx([
                      %twc("relative flex items-center justify-center h-full w-full "),
                      %twc(
                        "after:block after:content-[''] after:rounded-full after:border-green-500 after:border-[7px] after:bg-transparent after:min-w-[22px] after:h-[22px]"
                      ),
                    ])}
                  />
                </RadixUI.RadioGroup.Item>
              </label>
            </li>
          )
          ->React.array}
        </RadioGroup.Root>
        <FloatingButton
          handleClickButton={handleClickButton} disabled={status->Option.isNone || isUpdateMutating}
        />
      </form>
    </div>
  }
}

module Cycle = {
  open RadixUI
  @spice
  type cycle =
    | @spice.as(`매일`) EVERYDAY
    | @spice.as(`주 3~5회`) WEEK35
    | @spice.as(`주 1~2회`) WEEK12
    | @spice.as(`월 1~2회`) MONTH12
    | @spice.as(`일회성 주문`) ONCE

  let toString = (opt: cycle) => opt->cycle_encode->Js.Json.decodeString->Option.getWithDefault("")

  let fromString = str =>
    switch str {
    | str if str == `매일` => Some(EVERYDAY)
    | str if str == `주 3~5회` => Some(WEEK35)
    | str if str == `주 1~2회` => Some(WEEK12)
    | str if str == `월 1~2회` => Some(MONTH12)
    | str if str == `일회성 주문` => Some(ONCE)
    | _ => None
    }

  @react.component
  let make = (~demandId, ~defaultCycle=?) => {
    let {router: {toNext}} = CustomHooks.AquaTradematchStep.use()
    let {addToast} = ReactToastNotifications.useToasts()

    let (updateMutate, isUpdateMutating) = Mutation.PartialUpdateTradematchDemand.use()

    let (cycle, setCycle) = React.Uncurried.useState(_ => defaultCycle)

    let toastError = str =>
      addToast(. str->DS_Toast.getToastComponent(#error), {appearance: "error"})

    let pushEvent = (~demandId, ~cycle) =>
      {
        "event": "click_intention_seafood_cycle",
        "tradematch_demand_id": demandId,
        "trade_cycle": cycle,
      }
      ->DataGtm.mergeUserIdUnsafe
      ->DataGtm.push

    let handleClickButton = _ => {
      pushEvent(~demandId, ~cycle={cycle->Option.mapWithDefault("", toString)})

      switch cycle {
      | Some(cycle') =>
        updateMutate(
          ~variables={
            id: demandId,
            input: Mutation.PartialUpdateTradematchDemand.make_tradematchDemandPartialUpdateInput(
              ~tradeCycle=cycle'->toString,
              (),
            ),
          },
          ~onCompleted=({partialUpdateTradematchDemand}, _) => {
            switch partialUpdateTradematchDemand {
            | #TradematchDemandMutationPayload(_) => toNext()
            | _ =>
              toastError(`요청 중 오류가 발생했습니다. 잠시 후 다시 시도해주세요.`)
            }
          },
          ~onError={
            _ =>
              toastError(`요청 중 오류가 발생했습니다. 잠시 후 다시 시도해주세요.`)
          },
          (),
        )->ignore
      | None => ()
      }
    }

    <div>
      <Title text={`원하시는 납품주기를\n선택해주세요`} />
      <form>
        <RadioGroup.Root
          name="tradematch-cycle"
          value={switch cycle {
          | Some(cycle') => cycle'->toString
          | None => ""
          }}
          onValueChange={v => {
            let cycle = switch v->Js.Json.string->cycle_decode {
            | Ok(cycle') => Some(cycle')
            | Error(_) => None
            }
            setCycle(._ => cycle)
          }}>
          {[EVERYDAY, WEEK35, WEEK12, MONTH12, ONCE]
          ->Array.map(opt =>
            <li key={opt->toString} className=%twc("flex w-full items-center h-[60px]")>
              <label
                className=%twc(
                  "flex items-center justify-between w-full h-full px-5 cursor-pointer"
                )>
                <div className=%twc("text-text-L1")> {opt->toString->React.string} </div>
                <RadixUI.RadioGroup.Item
                  id={opt->toString}
                  value={opt->toString}
                  className={cx([
                    %twc(
                      "relative flex items-center justify-center ml-[25px] min-w-[22px] min-h-[22px] max-w-[22px] max-h-[22px] border-[1.5px] rounded-full border-enabled-L4 "
                    ),
                    %twc(
                      "after:content-[''] after:w-[7px] after:h-[7px] after:bg-enabled-L4 after:bg-opacity-30 after:rounded-full after:absolute "
                    ),
                  ])}>
                  <RadixUI.RadioGroup.Indicator
                    className={cx([
                      %twc("relative flex items-center justify-center h-full w-full "),
                      %twc(
                        "after:block after:content-[''] after:rounded-full after:border-green-500 after:border-[7px] after:bg-transparent after:min-w-[22px] after:h-[22px]"
                      ),
                    ])}
                  />
                </RadixUI.RadioGroup.Item>
              </label>
            </li>
          )
          ->React.array}
        </RadioGroup.Root>
        <FloatingButton
          handleClickButton={handleClickButton} disabled={cycle->Option.isNone || isUpdateMutating}
        />
      </form>
    </div>
  }
}

module Requirement = {
  @react.component
  let make = (~demandId, ~defaultSize=?, ~defaultProcess=?, ~defaultRequirements=?) => {
    let {router: {toNext}} = CustomHooks.AquaTradematchStep.use()
    let {addToast} = ReactToastNotifications.useToasts()

    let (size, setSize) = React.Uncurried.useState(_ => defaultSize->Option.getWithDefault(""))
    let (process, setProcess) = React.Uncurried.useState(_ =>
      defaultProcess->Option.getWithDefault("")
    )
    let (requirements, setRequirements) = React.Uncurried.useState(_ =>
      defaultRequirements->Option.getWithDefault("")
    )
    let (updateMutate, isUpdateMutating) = Mutation.PartialUpdateTradematchDemand.use()

    let toastError = str =>
      addToast(. str->DS_Toast.getToastComponent(#error), {appearance: "error"})

    let pushEvent = (~demandId, ~size, ~process, ~requirements) =>
      {
        "event": "click_intention_seafood_requirements",
        "tradematch_demand_id": demandId,
        "product_size": size,
        "product_process": process,
        "product_requirements": requirements,
      }
      ->DataGtm.mergeUserIdUnsafe
      ->DataGtm.push

    let handleClickButton = _ => {
      pushEvent(~demandId, ~size, ~process, ~requirements)

      updateMutate(
        ~variables={
          id: demandId,
          input: Mutation.PartialUpdateTradematchDemand.make_tradematchDemandPartialUpdateInput(
            ~productSize=size,
            ~productProcess=process,
            ~productRequirements=requirements,
            (),
          ),
        },
        ~onCompleted=({partialUpdateTradematchDemand}, _) => {
          switch partialUpdateTradematchDemand {
          | #TradematchDemandMutationPayload(_) => toNext()
          | _ =>
            toastError(`요청 중 오류가 발생했습니다. 잠시 후 다시 시도해주세요.`)
          }
        },
        ~onError={
          _ =>
            toastError(`요청 중 오류가 발생했습니다. 잠시 후 다시 시도해주세요.`)
        },
        (),
      )->ignore
    }

    <div>
      <Title text={`기타 요청사항을\n남겨주세요`} />
      <div>
        <DS_InputField.Line1.Root className=%twc("mt-4")>
          <div className=%twc("mb-2 text-sm")> {`사이즈`->React.string} </div>
          <DS_InputField.Line1.Input
            type_="text"
            autoFocus={true}
            placeholder={`고등어 20kg 30미 내외`}
            value={size}
            onChange={e => {
              let value = (e->ReactEvent.Synthetic.target)["value"]
              setSize(._ => value)
            }}
            maxLength={1000}
          />
        </DS_InputField.Line1.Root>
        <DS_InputField.Line1.Root className=%twc("mt-4")>
          <div className=%twc("mb-2 text-sm")> {`상품 가공`->React.string} </div>
          <DS_InputField.Line1.Input
            type_="text"
            placeholder={`절단, 건조 등`}
            value={process}
            onChange={e => {
              let value = (e->ReactEvent.Synthetic.target)["value"]
              setProcess(._ => value)
            }}
            maxLength={1000}
          />
        </DS_InputField.Line1.Root>
        <DS_InputField.Line1.Root className=%twc("mt-4")>
          <div className=%twc("mb-2 text-sm")> {`기타`->React.string} </div>
          <DS_InputField.Line1.Input
            type_="text"
            placeholder={`선별수준 등`}
            value={requirements}
            onChange={e => {
              let value = (e->ReactEvent.Synthetic.target)["value"]
              setRequirements(._ => value)
            }}
            maxLength={1000}
          />
        </DS_InputField.Line1.Root>
      </div>
      <FloatingButton handleClickButton={handleClickButton} disabled={isUpdateMutating} />
    </div>
  }
}

@send external focus: Dom.element => unit = "focus"
module Shipping = {
  @react.component
  let make = (~demandId) => {
    let {tradematchDeliveryPolicy} = Query.TradematchDeliveryPolicy.use(~variables=(), ())
    let {terms} = Query.TradematchTerms.use(~variables=(), ())
    let (updateMutate, isUpdateMutating) = Mutation.PartialUpdateTradematchDemand.use()
    let (updateTermAgreement, _) = Mutation.UpdateTermAgreement.use()

    let {router: {toNext}} = CustomHooks.AquaTradematchStep.use()
    let {addToast} = ReactToastNotifications.useToasts()

    let isTermAgree =
      terms.edges->Array.map(x => x.node.agreement)->Array.keep(x => x === `rfq`)->Array.length > 0

    let (isAgreedPrivacyPolicy, setIsAgreedPrivacyPolicy) = React.Uncurried.useState(_ =>
      isTermAgree
    )
    let (selectedDeliveryDate, setSelectedDeliveryDate) = React.Uncurried.useState(_ => None)

    let toastError = str =>
      addToast(. str->DS_Toast.getToastComponent(#error), {appearance: "error"})

    let pushEvent = (~demandId) =>
      {
        "event": "click_intention_seafood_address",
        "tradematch_demand_id": demandId,
      }
      ->DataGtm.mergeUserIdUnsafe
      ->DataGtm.push

    let minDateString = switch tradematchDeliveryPolicy {
    | Some(tradematchDeliveryPolicy') => tradematchDeliveryPolicy'.acceptableDeliveryDate
    | None => Js.Date.make()->DateFns.addDays(7)->DateFns.format("yyyy-MM-dd")
    }

    let minDate = minDateString->Js.Date.fromString
    let maxDate = minDate->DateFns.addDays(30)

    let deliveryAddressDetailInput = React.useRef(Js.Nullable.null)
    let (isAddressDrawerShow, setIsAddressDrawerShow) = React.Uncurried.useState(_ => false)

    let (deliveryRegion, setDeliveryRegion) = React.Uncurried.useState(_ => ``)
    let (deliveryAddress, setDeliveryAddress) = React.Uncurried.useState(_ => ``)
    let (deliveryAddressDetail, setDeliveryAddressDetail) = React.Uncurried.useState(_ => ``)
    let (deliveryAddressZipcode, setDeliveryAddressZipcode) = React.Uncurried.useState(_ => ``)

    let toggleDrawer = _ => setIsAddressDrawerShow(.prev => !prev)
    let onCompleteAddressDrawer = (data: DaumPostCode.oncompleteResponse) => {
      let {zonecode, sido, sigungu, bname, addressType, address, autoRoadAddress} = data

      // 정책 - 고객의 주소는 도로명주소 || 지번주소로 입력받는다.
      // daum post code의 autoRoadAddress가 empty string인 케이스에 한해 지번주소로 입력한다
      let deliveryAddress = switch addressType {
      | #R => address
      | #J =>
        switch autoRoadAddress->Js.String2.length > 0 {
        | true => autoRoadAddress
        | false => address
        }
      }

      let deliveryRegion =
        `${sido} ${sigungu} ${bname}`
        ->Js.String2.replaceByRe(%re("/[ ]{2,}/"), " ")
        ->Js.String2.trim

      setDeliveryRegion(._ => deliveryRegion)
      setDeliveryAddress(._ => deliveryAddress)
      setDeliveryAddressZipcode(._ => zonecode)
      toggleDrawer()
    }

    let updateDemand = _ => {
      let deliveryDate =
        selectedDeliveryDate->Option.mapWithDefault(None, date => Some(date->Js.Date.toISOString))

      updateMutate(
        ~variables={
          id: demandId,
          input: Mutation.PartialUpdateTradematchDemand.make_tradematchDemandPartialUpdateInput(
            ~deliveryAddress1=deliveryAddress,
            ~deliveryAddress2=deliveryAddressDetail->Js.String2.trim,
            ~deliveryDate=?{deliveryDate},
            ~deliveryRegion,
            ~deliveryZipCode=deliveryAddressZipcode,
            ~status=#REQUESTED,
            (),
          ),
        },
        ~onCompleted=({partialUpdateTradematchDemand}, _) => {
          switch partialUpdateTradematchDemand {
          | #TradematchDemandMutationPayload(_) => toNext()
          | #Error(_)
          | #UnselectedUnionMember(_) =>
            toastError(`요청 중 오류가 발생했습니다. 잠시 후 다시 시도해주세요.`)
          }
          ()
        },
        ~onError={
          err =>
            toastError(`요청 중 오류가 발생했습니다. 잠시 후 다시 시도해주세요.`)
        },
        (),
      )->ignore
    }

    let handleClickButton = _ => {
      pushEvent(~demandId)

      switch isTermAgree {
      | true => updateDemand()
      | false =>
        updateTermAgreement(
          ~variables={agreement: "rfq"},
          ~onCompleted=({createTerm}, _) => {
            switch createTerm {
            | #TermMutationPayload(_) => updateDemand()
            | #Error(_)
            | #UnselectedUnionMember(_) =>
              toastError(`요청 중 오류가 발생했습니다. 잠시 후 다시 시도해주세요.`)
            }
          },
          ~onError=_ =>
            toastError(`요청 중 오류가 발생했습니다. 잠시 후 다시 시도해주세요.`),
          (),
        )->ignore
      }
    }

    let isValidItems = {
      switch (
        selectedDeliveryDate,
        deliveryRegion !== ``,
        deliveryAddress !== ``,
        deliveryAddressZipcode !== ``,
        isAgreedPrivacyPolicy,
      ) {
      | (Some(_), true, true, true, true) => true
      | _ => false
      }
    }

    React.useEffect1(() => {
      setDeliveryAddressDetail(._ => ``)
      deliveryAddressDetailInput.current
      ->Js.Nullable.toOption
      ->Belt.Option.forEach(input => input->focus)

      None
    }, [deliveryAddress])

    <>
      <div>
        <Title text={`마지막으로\n배송정보를 알려주세요`} />
        <CalendarListitem
          leftText={`배송 희망일`}
          currentDate={selectedDeliveryDate}
          handleChangeDate={setSelectedDeliveryDate}
          minDate={minDate}
          maxDate={maxDate}
        />
        <div className=%twc("mx-5 mb-[30px]")>
          <div className=%twc("my-4")> {`배송지`->React.string} </div>
          <div className=%twc("flex mb-[13px]")>
            <input
              disabled=true
              value=deliveryAddressZipcode
              className={cx([
                %twc(
                  "w-full px-[14px] py-[13px] rounded-[10px] border-border-default-L1 border-[1px]"
                ),
                %twc("disabled:bg-disabled-L3"),
              ])}
              placeholder={`우편번호`}
            />
            <button
              className=%twc(
                "ml-2 min-w-[92px] bg-blue-gray-700 px-[14px] py-[13px] rounded-[10px] text-inverted font-bold"
              )
              onClick={toggleDrawer}>
              {`주소 검색`->React.string}
            </button>
          </div>
          <div className=%twc("mb-[13px]")>
            <input
              disabled=true
              className={cx([
                %twc(
                  "w-full px-[14px] py-[13px] rounded-[10px] border-border-default-L1 border-[1px]"
                ),
                %twc("disabled:bg-disabled-L3"),
              ])}
              value=deliveryAddress
              placeholder={`주소`}
            />
          </div>
          <div>
            <input
              ref={ReactDOM.Ref.domRef(deliveryAddressDetailInput)}
              onChange={e => {
                let value = (e->ReactEvent.Synthetic.target)["value"]
                setDeliveryAddressDetail(._ => value)
              }}
              value=deliveryAddressDetail
              disabled={deliveryAddress->Js.String2.length === 0}
              className={cx([
                %twc(
                  "w-full px-[14px] py-[13px] rounded-[10px] border-border-default-L1 border-[1px]"
                ),
                %twc("disabled:bg-disabled-L3 disabled:text-inverted disabled:text-opacity-50"),
              ])}
              placeholder={`상세주소를 입력해주세요.`}
            />
          </div>
        </div>
        {isTermAgree
          ? React.null
          : <>
              <div className=%twc("h-3 bg-border-default-L2") />
              <div className=%twc("my-7 mx-5")>
                <button onClick={_ => setIsAgreedPrivacyPolicy(.prev => !prev)}>
                  <div>
                    <div className=%twc("flex items-center space-x-2 mb-3")>
                      {isAgreedPrivacyPolicy
                        ? <DS_Icon.Common.CheckedLarge1 height="24" width="24" fill={`#12B564`} />
                        : <DS_Icon.Common.UncheckedLarge1 height="24" width="24" />}
                      <span className=%twc("font-bold leading-7 tracking-tight text-enabled-L1")>
                        {`개인정보 제공에 동의해주세요`->React.string}
                      </span>
                    </div>
                    <div className=%twc("pl-8 text-left")>
                      <p className=%twc("text-[13px] text-enabled-L2 leading-5 tracking-tight")>
                        <div>
                          {`(주)그린랩스는 다음과 같은 목적으로 개인정보를 수집합니다.`->React.string}
                        </div>
                        <div> {`1. 개인정보 수집 항목 : 주소`->React.string} </div>
                        <div>
                          {`2. 개인정보 수집 목적 : 견적 매칭 서비스 및 구매상품 배송`->React.string}
                        </div>
                        <div>
                          {`3. 개인정보의 보유 및 이용 기간 : `->React.string}
                          <span className=%twc("font-bold")>
                            {`회원탈퇴 시 즉시 파기`->React.string}
                          </span>
                          {` 이용자는 개인정보 수집 및 이용 동의를 거부할 권리가 있습니다. 다만, 이에 동의하지 않을 경우 신선매칭 서비스 이용이 어려울 수 있습니다.`->React.string}
                        </div>
                      </p>
                    </div>
                  </div>
                </button>
              </div>
            </>}
      </div>
      <FloatingButton
        handleClickButton={handleClickButton} disabled={!isValidItems || isUpdateMutating}
      />
      <Tradematch_SearchAddressDrawer_Buyer
        isShow={isAddressDrawerShow} closeDrawer={toggleDrawer} onComplete={onCompleteAddressDrawer}
      />
    </>
  }
}
