module Query = {
  module RfqRequestItemMeat = %relay(`
    query RfqItemDetailSeller_RfqRequestItemMeatNode_Query($itemId: ID!) {
      node(id: $itemId) {
        ... on RfqRequestItemMeat {
          id
          species {
            id
            code
            name
            shortName
            meatGrades(first: 9999, orderBy: RANKING) {
              edges {
                node {
                  id
                  grade
                  isDomestic
                  madeIn
                  meatSpecies {
                    code
                  }
                }
              }
            }
          }
          part {
            name
            isDomestic
          }
          grade {
            id
            grade
            madeIn
          }
          weightKg
          usages {
            edges {
              node {
                id
                name
              }
            }
          }
          storageMethod
          packageMethod
          preferredBrand
          otherRequirements
          createdAt
          updatedAt
          requestItemStatus: status
          request {
            id
            requestStatus: status
            desiredDeliveryDate
            deliveryMethod
            deliveryAddress
            remainSecondsUntilQuotationExpired
            closedAt
          }
          quotations {
            edges {
              node {
                id
                quotationStatus: status
                createdAt
                price
                pricePerKg
                grade {
                  grade
                  id
                }
              }
            }
          }
          brands {
            edges {
              node {
                id
                name
              }
            }
          }
        }
      }
    }
`)

  module QuotationPrice = %relay(`
    query RfqItemDetailSeller_QuotationPrice_Query($itemId: ID!) {
      rfqRecommendedPriceForMeat(rfqRequestItemId: $itemId) {
        recommendedPricePerKg: pricePerKg
      }
      rfqMinQuotedPriceForMeat(rfqRequestItemId: $itemId) {
        minQuotedPricePerKg: pricePerKg
      }
    }
  `)
}

module Mutation = {
  module CreateRfqQuotationMeat = %relay(`
    mutation RfqItemDetailSeller_CreateRfqQuotationMeat_Mutation(
      $input: RfqQuotationMeatInput!
    ) {
      createRfqQuotationMeat(input: $input) {
        __typename
        ... on Error {
          code
          message
        }
        ... on RfqQuotationMeatMutationPayload {
          result {
            id
            requestItem {
              quotations {
                edges {
                  node {
                    id
                    quotationStatus: status
                    createdAt
                    price
                    pricePerKg
                    grade {
                      grade
                      id
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  `)

  module UpdateRfqQuotationMeat = %relay(`
    mutation RfqItemDetailSeller_UpdateRfqQuotationMeat_Mutation(
      $id: ID!
      $input: RfqQuotationMeatInput!
    ) {
      updateRfqQuotationMeat(id: $id, input: $input) {
        __typename
        ... on Error {
          code
          message
        }
        ... on RfqQuotationMeatMutationPayload {
          result {
            id
            requestItem {
              quotations {
                edges {
                  node {
                    id
                    quotationStatus: status
                    createdAt
                    price
                    pricePerKg
                    grade {
                      grade
                      id
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  `)
}

module MeatItemTypes = RfqItemDetailSeller_RfqRequestItemMeatNode_Query_graphql.Types

let convertNumberInputValue = value =>
  value->Js.String2.replaceByRe(%re("/[^0-9]/g"), "")->Js.String2.replaceByRe(%re("/^[0]/g"), "")

let displayDeleveryMethod = (v: MeatItemTypes.enum_RfqDeliveryMethod) =>
  switch v {
  | #ANY => `상관없음`
  | #DIRECT_DELIVERY => `신선하이 직접배송`
  | #OTHER => `기타`
  | #WAREHOUSE_PICKUP => `창고수령`
  | #WAREHOUSE_TRANSFER => `창고배송`
  | _ => `기타`
  }

let displayStorageMethod = (v: MeatItemTypes.enum_RfqMeatStorageMethod) =>
  switch v {
  | #ANY => `모두`
  | #CHILLED => `냉장`
  | #FREEZE_DRIED => `동결`
  | #FROZEN => `냉동`
  | #OTHER => `그 외`
  | _ => ``
  }

let displayPackageMethod = (v: MeatItemTypes.enum_RfqMeatPackageMethod) =>
  switch v {
  | #ANY => `모두`
  | #CUT => `세절`
  | #OTHER => `그 외`
  | #RAW => `원료육(박스육)`
  | #SPLIT => `소분`
  | _ => ``
  }

let displayMadeInMethod = (v: MeatItemTypes.enum_CountryCode) =>
  switch v {
  | #KR => `국내산`
  | #US => `미국산`
  | #AU => `호주산`
  | #NZ => `뉴질랜드산`
  | #CA => `캐나다산`
  | #OTHER => `기타`
  | _ => ``
  }

let numberToComma = n =>
  n
  ->Float.fromString
  ->Option.mapWithDefault("", x => Intl.Currency.make(~value=x, ~locale={"ko-KR"->Some}, ()))

let stringToNumber = s => s->Js.String2.split(".")->Garter_Array.firstExn->numberToComma

type time = Day(int) | Hour(int) | Minute(int) | Second(int)
module TimerTitle = {
  @react.component
  let make = (~remainSecondsUntilQuotationExpired: int) => {
    let (time, setTime) = React.Uncurried.useState(_ => remainSecondsUntilQuotationExpired - 7200)

    React.useEffect0(_ => {
      let id = Js.Global.setInterval(_ => {
        setTime(. time => Js.Math.max_int(0, time - 1))
      }, 1000)

      Some(_ => id->Js.Global.clearInterval)
    })

    let getRemainTimes = (s: int) => {
      let oneMinuteSeconds = 60
      let oneHourSeconds = oneMinuteSeconds * 60
      let oneDaySeconds = oneHourSeconds * 24

      let remainDays = s / oneDaySeconds
      let remainHourSeconds = mod(s, oneDaySeconds)

      let remainHours = remainHourSeconds / oneHourSeconds
      let remainMinuteSeconds = mod(remainHourSeconds, oneHourSeconds)

      let remainMinutes = remainMinuteSeconds / oneMinuteSeconds
      let remainSeconds = mod(remainMinuteSeconds, oneMinuteSeconds)

      (Day(remainDays), Hour(remainHours), Minute(remainMinutes), Second(remainSeconds))
    }

    let getTimeText = (time: time) => {
      let generateText = (num, postfix) =>
        Some(num)
        ->Option.keep(x => x > 0)
        ->Option.mapWithDefault(``, x => `${x->Int.toString}${postfix}`)

      switch time {
      | Day(d) => d->generateText(`일 `)
      | Hour(h) => h->generateText(`시간 `)
      | Minute(m) => m->generateText(`분 `)
      | Second(s) => s->generateText(`초`)
      }
    }

    let (d, h, m, s) = time->getRemainTimes
    let dayText = d->getTimeText
    let hourText = h->getTimeText
    let minuteText = m->getTimeText
    let secondText = s->getTimeText

    let timeText =
      time > 0
        ? `${dayText}${hourText}${minuteText}${secondText} 후 요청 마감`
        : `요청 마감`

    timeText->React.string
  }
}

module Detail = {
  module Item = {
    @react.component
    let make = (~title, ~value) => {
      <DS_ListItem.Normal1.Item>
        <DS_TitleList.Left.TitleSubtitle1
          title1={title} titleStyle=%twc("font-normal text-text-L2")
        />
        <DS_ListItem.Normal1.RightGroup>
          <DS_TitleList.Common.TextIcon1.Root>
            <DS_TitleList.Common.TextIcon1.Text className=%twc("text-right word-keep-all")>
              {value->React.string}
            </DS_TitleList.Common.TextIcon1.Text>
          </DS_TitleList.Common.TextIcon1.Root>
        </DS_ListItem.Normal1.RightGroup>
      </DS_ListItem.Normal1.Item>
    }
  }

  module Title = {
    @react.component
    let make = (~itemMeat: MeatItemTypes.response_node) => {
      let submittedQuotation = itemMeat.quotations.edges->Array.map(x => x.node)->Garter_Array.first
      let hasSubmittedQuotation = submittedQuotation->Option.isSome

      let pageTitle = {
        switch hasSubmittedQuotation {
        | true =>
          <DS_TitleList.Left.Title3Subtitle1
            titleStyle=%twc("text-xl font-bold")
            title1={itemMeat.species->Option.mapWithDefault("", x => x.shortName)}
            title2={itemMeat.part->Option.mapWithDefault("", x => x.name)}
            title3={itemMeat.part->Option.mapWithDefault("", x =>
              x.isDomestic ? `국내` : `수입`
            )}
            subTitle={switch itemMeat.requestItemStatus {
            | #WAITING_FOR_QUOTATION => `아직 견적서를 수정할 수 있어요`
            | _ => ``
            }}
          />
        | false =>
          <>
            <DS_TitleList.Left.TitleSubtitle1 title1={`견적요청서가 도착했어요`} />
            {switch itemMeat.requestItemStatus {
            | #WAITING_FOR_QUOTATION => React.null
            | _ => React.null
            }}
          </>
        }
      }

      let pageSubTitle = switch itemMeat.requestItemStatus {
      | #WAITING_FOR_QUOTATION =>
        <div
          className=%twc(
            "my-3 inline-flex items-center text-sm font-bold leading-5 tracking-tight px-2 py-1.5 rounded text-emphasis bg-emphasis bg-opacity-10"
          )>
          <DS_Icon.Common.PeriodSmall1 width="14" height="14" className=%twc("mr-1") />
          <TimerTitle
            remainSecondsUntilQuotationExpired={itemMeat.request.remainSecondsUntilQuotationExpired}
          />
        </div>
      | _ => React.null
      }

      <div className=%twc("px-5 pt-8")>
        <div className=%twc("mt-3")>
          {pageTitle}
          {pageSubTitle}
        </div>
      </div>
    }
  }

  module MyQuotation = {
    @react.component
    let make = (~itemMeat: MeatItemTypes.response_node) => {
      let hasSubmittedQuotation =
        itemMeat.quotations.edges->Array.map(x => x.node)->Garter_Array.first->Option.isSome

      switch hasSubmittedQuotation {
      | false => React.null
      | true => {
          let isGradeIgnore =
            itemMeat.grade->Option.mapWithDefault(false, x => x.grade === `등급무관`)

          let gradeText =
            itemMeat.quotations.edges
            ->Garter_Array.first
            ->Option.flatMap(x => Some(x.node.grade.grade))

          let quotationPrice =
            itemMeat.quotations.edges
            ->Garter_Array.first
            ->Option.flatMap(x => Some(
              x.node.pricePerKg->Js.String2.split(".")->Garter_Array.firstExn,
            ))

          <>
            <div className=%twc("px-5 mt-10")>
              <h3 className=%twc("font-bold leading-6 tracking-tight")>
                {`제안하신 내용`->React.string}
              </h3>
            </div>
            <div className=%twc("flex flex-col items-center space-y-3 mx-5 mt-5")>
              <div className=%twc("w-full bg-white rounded-lg py-5")>
                <div className=%twc("flex flex-col px-5 gap-3.5")>
                  <Item
                    title={`단가`}
                    value={`${quotationPrice->Option.getWithDefault("")->numberToComma}원/kg`}
                  />
                  {isGradeIgnore
                    ? <Item title={`등급`} value={gradeText->Option.mapWithDefault(``, x => x)} />
                    : React.null}
                </div>
              </div>
            </div>
            <div className=%twc("h-3 bg-border-default-L2 mt-6") />
          </>
        }
      }
    }
  }

  module Request = {
    @react.component
    let make = (~itemMeat: MeatItemTypes.response_node) => {
      let isSkipGrade = switch (
        itemMeat.species->Option.map(x => x.code),
        itemMeat.part->Option.map(x => x.isDomestic),
      ) {
      | (Some(speciesCode'), Some(isDomestic')) =>
        switch (speciesCode', isDomestic') {
        | ("CHICKEN", _) => true
        | ("PORK", false) => true
        | _ => false
        }
      | _ => false
      }

      <div className=%twc("flex flex-col items-center space-y-3 mx-5 mt-5 pb-28")>
        <div className=%twc("w-full bg-white rounded-lg py-5 mx-6")>
          <div className=%twc("px-5 mb-6")>
            <DS_TitleList.Left.Title3Subtitle1
              title1={itemMeat.species->Option.mapWithDefault("", x => x.shortName)}
              title2={itemMeat.part->Option.mapWithDefault("", x => x.name)}
              title3={itemMeat.part->Option.mapWithDefault(``, x =>
                x.isDomestic ? `국내` : `수입`
              )}
            />
          </div>
          <div className=%twc("flex flex-col")>
            <DS_ListItem.Normal1.Root className=%twc("space-y-3.5")>
              {itemMeat.packageMethod->Option.mapWithDefault(React.null, x =>
                <Item title={`포장상태`} value={x->displayPackageMethod} />
              )}
              {isSkipGrade
                ? React.null
                : itemMeat.grade->Option.mapWithDefault(React.null, x =>
                    <Item title={`등급`} value={x.grade} />
                  )}
              {itemMeat.weightKg->Option.mapWithDefault(React.null, x =>
                <Item
                  title={`주문량`}
                  value={`${x->Js.String2.split(".")->Garter_Array.firstExn->numberToComma} kg`}
                />
              )}
              {switch itemMeat.usages.edges->Garter.Array.isEmpty {
              | false =>
                <Item
                  title={`사용용도`}
                  value={itemMeat.usages.edges->Array.map(edge => {
                    edge.node.name
                  }) |> Js.Array.joinWith(", ")}
                />
              | true => React.null
              }}
              {itemMeat.storageMethod->Option.mapWithDefault(React.null, x => {
                <Item title={`보관상태`} value={x->displayStorageMethod} />
              })}
              {
                // Brand 선택 개선 전의 레거시 코드
                // preferredBrand 필드는 더 이상 유저가 입력하지 않음.
                // 그러나 개선 이전의 주문건에 대해 보여주기 위해 필요함.
                itemMeat.preferredBrand === ""
                  ? React.null
                  : <Item title={`선호브랜드`} value={itemMeat.preferredBrand} />
              }
              {switch // Brand 선택 개선 이후 - 새롭게 추가된 필드의 데이터를 보여줌.
              itemMeat.brands.edges->Garter.Array.isEmpty {
              | true => <Item title={`브랜드`} value={`브랜드 무관`} />
              | false =>
                <Item
                  title={`브랜드`}
                  value={itemMeat.brands.edges->Array.map(edge => {
                    edge.node.name
                  }) |> Js.Array.joinWith(", ")}
                />
              }}
              <li className=%twc("h-0.5 bg-border-disabled") />
              <Item
                title={`납품 희망일자`}
                value={itemMeat.request.desiredDeliveryDate
                ->Js.Date.fromString
                ->DateFns.format("yy.MM.dd")}
              />
              <Item
                title={`수령방식`}
                value={itemMeat.request.deliveryMethod->displayDeleveryMethod}
              />
              <Item title={`배송지역`} value={itemMeat.request.deliveryAddress} />
              {itemMeat.otherRequirements->Js.String2.trim === ""
                ? React.null
                : <>
                    <li className=%twc("h-0.5 bg-border-disabled") />
                    <li className=%twc("flex flex-col justify-start items-start space-y-2")>
                      <span className=%twc("text-text-L2")> {`요청사항`->React.string} </span>
                      <div className=%twc("w-full")>
                        {itemMeat.otherRequirements->React.string}
                      </div>
                    </li>
                  </>}
            </DS_ListItem.Normal1.Root>
          </div>
        </div>
      </div>
    }
  }

  module Button = {
    @react.component
    let make = (~itemMeat: MeatItemTypes.response_node) => {
      let router = Next.Router.useRouter()

      let submittedQuotation = itemMeat.quotations.edges->Array.map(x => x.node)->Garter_Array.first
      let hasSubmittedQuotation = submittedQuotation->Option.isSome

      let isGradeIgnore =
        itemMeat.grade->Option.mapWithDefault(false, x => x.grade === `등급무관`)
      let isDomestic = itemMeat.part->Option.mapWithDefault(true, x => x.isDomestic)
      let madeIn = itemMeat.grade->Option.mapWithDefault(#OTHER, x => x.madeIn)
      let madeInText = madeIn->displayMadeInMethod
      let grades =
        itemMeat.species
        ->Option.mapWithDefault([], x => x.meatGrades.edges)
        ->Array.keep(x => x.node.madeIn === madeIn)
        ->Array.keep(x => x.node.grade !== `등급무관`)
        ->Array.map(x => x.node)

      let (isDrawerShow, setDrawerShow) = React.Uncurried.useState(_ => false)
      let (selectedGrade, setSelectedGrade) = React.Uncurried.useState(_ =>
        isGradeIgnore ? None : itemMeat.grade->Option.mapWithDefault(None, x => Some(x.id))
      )

      let navigatePriceFormPage = () => {
        switch selectedGrade {
        | Some(selectedGrade') => {
            router.query->Js.Dict.set("selected_grade_id", selectedGrade')
            let {makeWithDict, toString} = module(Webapi.Url.URLSearchParams)
            let newQueryString =
              [("selected_grade_id", selectedGrade')]->Js.Dict.fromArray->makeWithDict->toString
            router->Next.Router.push(`${router.asPath}?${newQueryString}`)
          }

        | None => ()
        }

        ()
      }

      let handleClickQuotationButton = () => {
        switch isGradeIgnore {
        | true => setDrawerShow(._ => true)
        | false => navigatePriceFormPage()
        }
      }

      let trackData = () => {
        switch hasSubmittedQuotation {
        | true => ()
        | false =>
          {
            "event": "click_rfq_livestock_quotation",
            "request_id": itemMeat.request.id,
            "quotation_id": itemMeat.id,
          }
          ->DataGtm.mergeUserIdUnsafe
          ->DataGtm.push
        }
      }

      <>
        <div onClick={_ => trackData()}>
          <DS_ButtonContainer.Floating1
            disabled={switch itemMeat.requestItemStatus {
            | #WAITING_FOR_QUOTATION => false
            | _ => true
            }}
            label={`견적서 ${hasSubmittedQuotation ? `수정` : `작성`}하기`}
            onClick={_ => handleClickQuotationButton()}
          />
        </div>
        <DS_BottomDrawer.Root isShow=isDrawerShow onClose={_ => setDrawerShow(._ => !isDrawerShow)}>
          <DS_BottomDrawer.Header />
          <DS_BottomDrawer.Body>
            <div className=%twc("text-text-L3 leading-6 tracking-tight px-5 mb-3")>
              {`구매자가 ${madeInText}/등급무관을 선택했어요`->React.string}
            </div>
            <DS_Title.Normal1.Root>
              <DS_Title.Normal1.TextGroup
                title1={`${itemMeat.part->Option.mapWithDefault("", x => x.name)}/${isDomestic
                    ? `국내산`
                    : `수입산`}의`}
                title2={`판매하시는 등급을 선택해주세요`}
              />
            </DS_Title.Normal1.Root>
            <DS_ListItem.Normal1.Root
              className=%twc("space-y-8 mt-10 tab-highlight-color pb-[96px] overflow-y-auto")>
              {grades
              ->Array.map(x => {
                let isSelected =
                  selectedGrade->Option.mapWithDefault(false, grade' => grade' === x.id)

                <DS_ListItem.Normal1.Item
                  key={x.id} onClick={_ => setSelectedGrade(._ => Some(x.id))}>
                  <DS_ListItem.Normal1.TextGroup title1={x.grade} />
                  <DS_ListItem.Normal1.RightGroup>
                    {isSelected
                      ? <DS_Icon.Common.RadioOnLarge1 height="24" width="24" fill={"#12B564"} />
                      : <DS_Icon.Common.RadioOffLarge1 height="24" width="24" fill={"#B2B2B2"} />}
                  </DS_ListItem.Normal1.RightGroup>
                </DS_ListItem.Normal1.Item>
              })
              ->React.array}
            </DS_ListItem.Normal1.Root>
            <DS_ButtonContainer.Floating1
              disabled={selectedGrade->Option.isNone}
              label={`다음`}
              onClick={_ => navigatePriceFormPage()}
            />
          </DS_BottomDrawer.Body>
        </DS_BottomDrawer.Root>
      </>
    }
  }

  @react.component
  let make = (~itemMeat: MeatItemTypes.response_node) => {
    React.useEffect0(() => {
      {
        "event": "view_rfq_livestock_quotation_detail",
        "request_id": itemMeat.request.id,
        "quotation_id": itemMeat.id,
      }
      ->DataGtm.mergeUserIdUnsafe
      ->DataGtm.push

      None
    })

    <section
      className=%twc("relative container max-w-3xl mx-auto min-h-screen sm:shadow-gl bg-gray-50")>
      <Title itemMeat={itemMeat} />
      <MyQuotation itemMeat={itemMeat} />
      <Request itemMeat={itemMeat} />
      <Button itemMeat={itemMeat} />
    </section>
  }
}

type mutationType = Create | Update
module Apply = {
  module PriceTextsSkeleton = {
    @react.component
    let make = () => {
      <div>
        <div className=%twc("animate-pulse rounded-lg bg-gray-100 h-5 w-[280px]") />
        <div className=%twc("h-2") />
        <div className=%twc("animate-pulse rounded-lg bg-gray-100 h-5 w-[300px]") />
      </div>
    }
  }

  module PriceTexts = {
    @react.component
    let make = (~itemId, ~minimumPriceUnit) => {
      let {rfqRecommendedPriceForMeat, rfqMinQuotedPriceForMeat} = Query.QuotationPrice.use(
        ~variables={itemId: itemId},
        // 짧은 시간 내에 다른 셀러들이 견적서를 제출할 수 있으므로, 최신화된 가격정보를 가져와야함.
        ~fetchPolicy=RescriptRelay.NetworkOnly,
        (),
      )

      let displayPricePerKg =
        rfqRecommendedPriceForMeat.recommendedPricePerKg
        ->Int.fromString
        ->Option.map(x => x - mod(x, minimumPriceUnit))
        ->Option.map(x => x->Int.toString)
        ->Option.map(x => x->stringToNumber)

      let minQuotedPrice =
        rfqMinQuotedPriceForMeat.minQuotedPricePerKg->Option.mapWithDefault(
          displayPricePerKg,
          x => Some(x->stringToNumber),
        )

      <div className=%twc("text-text-L3 text-base")>
        {switch displayPricePerKg {
        | Some(pricePerKg) =>
          <>
            <span> {`구매자의 기존 단가는 `->React.string} </span>
            <span className=%twc("text-primary")> {`${pricePerKg}원`->React.string} </span>
            <span> {`입니다.`->React.string} </span>
            <br />
          </>
        | None => React.null
        }}
        {switch minQuotedPrice {
        | Some(minQuotedPrice') =>
          <>
            <span> {`현재까지 최저 입찰 단가는 `->React.string} </span>
            <span className=%twc("text-primary")> {`${minQuotedPrice'}원`->React.string} </span> // Todo
            <span> {`입니다.`->React.string} </span>
          </>
        | None => React.null
        }}
      </div>
    }
  }

  @react.component
  let make = (
    ~itemMeat: MeatItemTypes.response_node,
    ~sellerSelectedGradeNode: MeatItemTypes.response_node_species_meatGrades_edges_node,
  ) => {
    let router = Next.Router.useRouter()

    let {addToast} = ReactToastNotifications.useToasts()
    let (mutateCreate, _) = Mutation.CreateRfqQuotationMeat.use()
    let (mutateUpdate, _) = Mutation.UpdateRfqQuotationMeat.use()
    let (price, setPrice) = React.Uncurried.useState(_ => None)

    let submittedQuotation = itemMeat.quotations.edges->Array.map(x => x.node)->Garter_Array.first
    let hasSubmittedQuotation = submittedQuotation->Option.isSome

    let handleChangeInput = e => {
      let value = (e->ReactEvent.Synthetic.target)["value"]->convertNumberInputValue
      setPrice(._ => value->Js.String2.trim === "" ? None : Some(value))
    }

    let addToastWhenAfterMutate = (mutationType: mutationType, hasError: bool) => {
      let submitTypeText = switch mutationType {
      | Create => `제출`
      | Update => `수정`
      }

      switch hasError {
      | true =>
        addToast(.
          `견적서 ${submitTypeText}에 실패했습니다.`->DS_Toast.getToastComponent(#error),
          {appearance: "error"},
        )
      | false =>
        addToast(.
          `견적서를 ${submitTypeText}했습니다.`->DS_Toast.getToastComponent(#succ),
          {appearance: "succ"},
        )
      }
    }

    let trackDataInMutation = (mutationType: mutationType) => {
      switch mutationType {
      | Create =>
        {
          "event": "click_yes_rfq_livestock_enteraprice_check_popup",
          "request_id": itemMeat.request.id,
          "quotation_id": itemMeat.id,
        }
        ->DataGtm.mergeUserIdUnsafe
        ->DataGtm.push
      | Update => ()
      }
    }

    let handleSubmit = _ => {
      switch submittedQuotation {
      | Some(submittedQuotation') => {
          let input: Mutation.UpdateRfqQuotationMeat.Types.rfqQuotationMeatInput = {
            meatGradeId: sellerSelectedGradeNode.id,
            pricePerKg: price->Option.getWithDefault(""),
            rfqRequestItemId: itemMeat.id,
            deliveryFee: None,
            brand: "", // Next step Todo - user can enter a brand name.
          }

          mutateUpdate(
            ~variables={
              id: submittedQuotation'.id,
              input,
            },
            ~onCompleted={
              ({updateRfqQuotationMeat}, _) => {
                switch updateRfqQuotationMeat {
                | #RfqQuotationMeatMutationPayload(payload) =>
                  switch payload.result {
                  | Some(_) =>
                    trackDataInMutation(Update)
                    addToastWhenAfterMutate(Update, false)
                    router->Next.Router.replace(`/seller/rfq/request/${itemMeat.id}`)
                  | None => addToastWhenAfterMutate(Update, true)
                  }
                | #UnselectedUnionMember(_) => addToastWhenAfterMutate(Update, true)
                | _ => addToastWhenAfterMutate(Update, true)
                }
              }
            },
            (),
          )->ignore
        }

      | None => {
          let input: Mutation.CreateRfqQuotationMeat.Types.rfqQuotationMeatInput = {
            meatGradeId: sellerSelectedGradeNode.id,
            pricePerKg: price->Option.getWithDefault(""),
            rfqRequestItemId: itemMeat.id,
            deliveryFee: None,
            brand: "", // Next step Todo - user can enter a brand name.
          }

          mutateCreate(
            ~variables={
              input: input,
            },
            ~onCompleted={
              ({createRfqQuotationMeat}, _) => {
                switch createRfqQuotationMeat {
                | #RfqQuotationMeatMutationPayload(payload) =>
                  switch payload.result {
                  | Some(_) =>
                    trackDataInMutation(Create)
                    addToastWhenAfterMutate(Create, false)
                    router->Next.Router.replace(`/seller/rfq/request/${itemMeat.id}`)
                  | None => addToastWhenAfterMutate(Create, true)
                  }
                | #UnselectedUnionMember(_) => addToastWhenAfterMutate(Create, true)
                | _ => addToastWhenAfterMutate(Create, true)
                }
              }
            },
            (),
          )->ignore
        }
      }
    }

    let trackDataWhenNextButton = () => {
      switch hasSubmittedQuotation {
      | true => ()
      | false =>
        {
          "event": "click_rfq_livestock_enteraprice",
          "request_id": itemMeat.request.id,
          "quotation_id": itemMeat.id,
          "seller_price_per_kg": price,
        }
        ->DataGtm.mergeUserIdUnsafe
        ->DataGtm.push
      }
    }

    let speciesName = itemMeat.species->Option.map(x => x.name)
    let speciesCode = itemMeat.species->Option.map(x => x.code)

    let minimumPriceUnit = switch speciesCode {
    | Some("BEEF") => 100
    | Some("PORK") => 50
    | Some("CHICKEN") => 10
    | _ => 0
    }

    let errorMessage = switch speciesName {
    | Some(name) =>
      Some(
        `${name}의 경우 견적가는 ${minimumPriceUnit->Int.toString}원 단위로 입력해주셔야 해요.`,
      )
    | _ => None
    }

    let isValidPrice = switch price->Option.flatMap(Int.fromString) {
    | Some(price') => mod(price', minimumPriceUnit) === 0 ? true : false
    | None => false
    }

    <>
      <section
        className=%twc("relative container max-w-3xl mx-auto min-h-screen sm:shadow-gl pt-14")>
        <DS_TopNavigation.Detail.Root>
          <DS_TopNavigation.Detail.Left>
            <a className=%twc("cursor-pointer") onClick={_ => History.back()}>
              <DS_Icon.Common.ArrowLeftXLarge1 height="32" width="32" className=%twc("relative") />
            </a>
          </DS_TopNavigation.Detail.Left>
          <DS_TopNavigation.Detail.Center>
            {`견적서 ${hasSubmittedQuotation ? `수정` : `작성`}`->React.string}
          </DS_TopNavigation.Detail.Center>
        </DS_TopNavigation.Detail.Root>
        <DS_Title.Normal1.Root className=%twc("mt-10")>
          <DS_Title.Normal1.TextGroup
            title1={`${itemMeat.part->Option.mapWithDefault("", x =>
                x.name
              )}/${itemMeat.part->Option.mapWithDefault("", x =>
                x.isDomestic ? `국산` : `수입`
              )}의`}
            title2={`제공 가능한 단가를 알려주세요`}
          />
        </DS_Title.Normal1.Root>
        <div className=%twc("px-5 mt-3")>
          <React.Suspense fallback={<PriceTextsSkeleton />}>
            <PriceTexts itemId={itemMeat.id} minimumPriceUnit />
          </React.Suspense>
        </div>
        <DS_InputField.Line1.Root className=%twc("mt-10")>
          <DS_InputField.Line1.Input
            type_="text"
            inputMode={"decimal"}
            placeholder={`단가`}
            unit={`원/kg`}
            autoFocus=true
            errorMessage={isValidPrice ? None : errorMessage}
            value={price->Option.getWithDefault(``)->numberToComma}
            onChange={handleChangeInput}
            isClear=true
            fnClear={_ => setPrice(._ => None)}
            underLabelType=#won
            maxLength={10}
          />
        </DS_InputField.Line1.Root>
      </section>
      <DS_Dialog.Popup.Root>
        <DS_Dialog.Popup.Trigger asChild=false>
          <div onClick={_ => trackDataWhenNextButton()}>
            <DS_ButtonContainer.Full1 disabled={!isValidPrice} label={`다음`} />
          </div>
        </DS_Dialog.Popup.Trigger>
        <DS_Dialog.Popup.Portal>
          <DS_Dialog.Popup.Overlay />
          <DS_Dialog.Popup.Content>
            <DS_Dialog.Popup.Title>
              {`아래 내용으로 견적서를 ${hasSubmittedQuotation
                  ? `수정합니다.`
                  : `보냅니다.`}`->React.string}
            </DS_Dialog.Popup.Title>
            <DS_Dialog.Popup.Description>
              {
                let part =
                  itemMeat.part->Option.mapWithDefault("", x =>
                    `${x.name}/${x.isDomestic ? `국산` : `수입`}`
                  )

                let price' = price->Option.getWithDefault("")
                <div className=%twc("text-base leading-6 tracking-tight text-enabled-L2")>
                  <div> {`${part} - ${price'->numberToComma} 원/kg`->React.string} </div>
                  <div> {`등급 - ${sellerSelectedGradeNode.grade}`->React.string} </div>
                </div>
              }
            </DS_Dialog.Popup.Description>
            <DS_Dialog.Popup.Buttons>
              <DS_Dialog.Popup.Close asChild=true>
                <DS_Button.Normal.Large1 buttonType=#white label={`아니오`} />
              </DS_Dialog.Popup.Close>
              <DS_Dialog.Popup.Close asChild=true>
                <DS_Button.Normal.Large1 label={`네`} onClick={handleSubmit} />
              </DS_Dialog.Popup.Close>
            </DS_Dialog.Popup.Buttons>
          </DS_Dialog.Popup.Content>
        </DS_Dialog.Popup.Portal>
      </DS_Dialog.Popup.Root>
    </>
  }
}

module DetailPageRouter = {
  @react.component
  let make = (~itemId) => {
    let {node} = Query.RfqRequestItemMeat.use(~variables={itemId: itemId}, ())
    let router = Next.Router.useRouter()
    let selectedGradeId = router.query->Js.Dict.get("selected_grade_id")

    {
      switch node {
      | Some(itemMeat) =>
        switch selectedGradeId {
        | Some(selectedGradeId') => {
            let itemStatus = itemMeat.requestItemStatus
            let madeIn = itemMeat.grade->Option.mapWithDefault(#OTHER, x => x.madeIn)
            let sellerSelectedGradeNode =
              itemMeat.species
              ->Option.mapWithDefault([], x => x.meatGrades.edges)
              ->Array.keep(x => x.node.madeIn === madeIn)
              ->Array.keep(x => x.node.grade !== `등급무관`)
              ->Array.getBy(x => x.node.id === selectedGradeId')

            switch (sellerSelectedGradeNode, itemStatus) {
            | (Some(sellerSelectedGradeNode'), #WAITING_FOR_QUOTATION) =>
              <Apply itemMeat={itemMeat} sellerSelectedGradeNode={sellerSelectedGradeNode'.node} />
            | _ => <DS_None.Default message={`잘못된 접근입니다.`} />
            }
          }

        | None => <Detail itemMeat={itemMeat} />
        }
      | None => <DS_None.Default message={`견적서 정보가 없습니다.`} />
      }
    }
  }
}

@react.component
let make = (~itemId: option<string>) => {
  <Authorization.Seller fallback={React.null} title={`견적 확인`}>
    <React.Suspense>
      {switch itemId {
      | Some(itemId') => <DetailPageRouter itemId={itemId'} />
      | None =>
        <DS_None.Default
          message={`견적서 정보를 불러올 수 없습니다. 관리자에게 문의해주세요.`}
        />
      }}
    </React.Suspense>
  </Authorization.Seller>
}
