module Query = %relay(`
    query RfqApplyBuyer_Query($itemId: ID!) {
      node(id: $itemId) {
        ... on RfqRequestItemMeat {
          id
          species {
            id
            name
            code
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
            meatUsages(first: 9999) {
              edges {
                node {
                  id
                  name
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
            meatSpecies {
              id
            }
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
          prevTradeSellerName
          prevTradePricePerKg
          brands {
            edges {
              node {
                id
                name
              }
            }
          }
          otherRequirements
          createdAt
          updatedAt
        }
      }
    }
  `)

module Mutation = %relay(`
    mutation RfqApplyBuyer_Update_Mutation(
      $id: ID!
      $input: RfqRequestItemMeatUpdateInput!
    ) {
      updateRfqRequestItemsMeat(id: $id, input: $input) {
        ... on RfqRequestItemMeatMutationPayload {
          result {
            id
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
            prevTradeSellerName
            prevTradePricePerKg
            otherRequirements
          }
        }
        ... on Error {
          code
          message
        }
      }
    }
  `)

let toStringStorageMethod = (v: RfqApplyBuyer_Query_graphql.Types.enum_RfqMeatStorageMethod) =>
  switch v {
  | #ANY => `ANY`
  | #CHILLED => `CHILLED`
  | #FREEZE_DRIED => `FREEZE_DRIED`
  | #FROZEN => `FROZEN`
  | #OTHER => `OTHER`
  | _ => ``
  }

let toStringPackageMethod = (v: RfqApplyBuyer_Query_graphql.Types.enum_RfqMeatPackageMethod) =>
  switch v {
  | #ANY => `ANY`
  | #CUT => `CUT`
  | #OTHER => `OTHER`
  | #RAW => `RAW`
  | #SPLIT => `SPLIT`
  | _ => ``
  }

module Layout = {
  @react.component
  let make = (~children) => {
    <div className=%twc("bg-gray-100")>
      <div className=%twc("relative container bg-white max-w-3xl mx-auto min-h-screen")>
        children
      </div>
    </div>
  }
}

module Header = {
  @react.component
  let make = (
    ~title=?,
    ~handleClickLeftButton=History.back,
    ~updateItem: (~initializeBrands: bool=?, unit) => unit,
    ~requestId,
    ~itemId,
    ~dispatch: RfqApply_Steps_Buyer.action => unit,
  ) => {
    let {current, isModify, router: {toNext}} = RfqApply_Steps_Buyer.RfqApplyStep.use()

    let isAvailableSkip = switch (current, isModify) {
    | (Usage, false)
    | (Etc, false) => true
    | _ => false
    }

    let trackData = () => {
      switch current {
      | Usage =>
        {
          "event": "click_rfq_livestock_meatusage",
          "request_id": requestId,
          "request_item_id": itemId,
          "meat_usage_ids": [],
          "meatusage_skip": true,
        }
        ->DataGtm.mergeUserIdUnsafe
        ->DataGtm.push
      | Etc =>
        {
          "event": "click_rfq_livestock_otherrequirements",
          "request_id": requestId,
          "request_item_id": itemId,
          "other_requirements": "",
          "otherrequirements_skip": true,
        }
        ->DataGtm.mergeUserIdUnsafe
        ->DataGtm.push
      | Brand
      | Package
      | Grade
      | Amount
      | Storage
      | Price => ()
      }
    }

    let handleClickSkipButton = () => {
      trackData()

      switch (current, isAvailableSkip) {
      | (Usage, true) => {
          dispatch(Usages([]))
          toNext()
        }

      | (Etc, true) => {
          dispatch(ETC(""))
          updateItem()
        }

      | _ => ()
      }
    }

    <>
      <div className=%twc("w-full fixed top-0 left-0 z-10")>
        <header className=%twc("relative w-full max-w-3xl mx-auto h-14 bg-white")>
          <div className=%twc("flex justify-between px-5 py-4 left-1/2")>
            <button className=%twc("min-w-[60px]") onClick={_ => handleClickLeftButton()}>
              <img
                src="/assets/arrow-right.svg"
                className=%twc("w-6 h-6 rotate-180 pointer-events-none")
              />
            </button>
            <div className=%twc("text-center truncate")>
              <span className=%twc("font-bold text-base")>
                {title->Option.mapWithDefault(``, x => x)->React.string}
              </span>
            </div>
            <div className=%twc("min-w-[60px] flex justify-end")>
              {isAvailableSkip
                ? <button
                    onClick={_ => handleClickSkipButton()}
                    className=%twc("text-enabled-L1 w-auto word-keep-all")>
                    {`건너뛰기`->React.string}
                  </button>
                : React.null}
            </div>
          </div>
        </header>
      </div>
      <div className=%twc("w-full h-14") />
    </>
  }
}

module ProgressBar = {
  @react.component
  let make = (~totalCount, ~currentCount) => {
    let percentage = currentCount->Int.toFloat /. totalCount->Int.toFloat *. 100.
    let style = ReactDOM.Style.make(~width=`${percentage->Float.toString}%`, ())

    <div className=%twc("max-w-3xl fixed h-1 w-full bg-surface z-[10]")>
      <div style className=%twc("absolute left-0 top-0 bg-primary z-30 h-full transition-all") />
    </div>
  }
}

module Apply = {
  type item = {
    grade: option<string>,
    weightKg: option<string>,
    usages: array<string>,
    storageMethod: option<string>,
    packageMethod: option<string>,
    prevTradePricePerKg: option<string>,
    prevTradeSellerName: option<string>,
    meatBrandIds: array<string>,
    otherRequirements: option<string>,
  }

  let getItemInfo = (node: option<RfqApplyBuyer_Query_graphql.Types.response_node>) => {
    let itemInfo = switch node {
    | Some(node') => {
        grade: node'.grade->Option.mapWithDefault(None, grade' => Some(grade'.id)),
        weightKg: node'.weightKg->Option.mapWithDefault(None, weightKg' => Some(
          weightKg'->Js.String2.make,
        )),
        usages: node'.usages.edges->Array.map(edge => edge.node.id),
        storageMethod: node'.storageMethod->Option.mapWithDefault(None, storageMethod' => Some(
          storageMethod'->toStringStorageMethod,
        )),
        packageMethod: node'.packageMethod->Option.mapWithDefault(None, packageMethod' => Some(
          packageMethod'->toStringPackageMethod,
        )),
        prevTradePricePerKg: node'.prevTradePricePerKg->Option.mapWithDefault(
          None,
          prevTradePricePerKg' => Some(prevTradePricePerKg'->Js.String2.make),
        ),
        prevTradeSellerName: node'.prevTradeSellerName == ""
          ? None
          : Some(node'.prevTradeSellerName),
        meatBrandIds: node'.brands.edges->Array.map(edge => edge.node.id),
        otherRequirements: node'.otherRequirements == "" ? None : Some(node'.otherRequirements),
      }
    | None => {
        grade: None,
        weightKg: None,
        usages: [],
        storageMethod: None,
        packageMethod: None,
        prevTradePricePerKg: None,
        prevTradeSellerName: None,
        meatBrandIds: [],
        otherRequirements: None,
      }
    }

    let getEmptyGradeId = (speciesCode, isDomestic) => {
      node
      ->Option.flatMap(x => x.species)
      ->Option.map(x => x.meatGrades.edges)
      ->Option.mapWithDefault(None, x =>
        x
        ->Array.map(x => x.node)
        ->Array.keep(x => speciesCode === x.meatSpecies.code)
        ->Array.keep(x => x.isDomestic === isDomestic)
        ->Garter.Array.first
      )
      ->Option.map(x => x.id)
    }

    let (isNotExistGrades, isEmptyGradeId) = {
      // 닭고기 or 돼지고기(수입산) 은 등급이 없으므로 skip
      node->Option.mapWithDefault((false, None), node' => {
        switch (node'.species->Option.map(x => x.code), node'.part->Option.map(x => x.isDomestic)) {
        | (Some(speciesCode'), Some(isDomestic')) =>
          switch (speciesCode', isDomestic') {
          | ("CHICKEN", _) => (true, getEmptyGradeId(speciesCode', isDomestic'))
          | ("PORK", false) => (true, getEmptyGradeId(speciesCode', isDomestic'))
          | _ => (false, None)
          }
        | _ => (false, None)
        }
      })
    }

    (itemInfo, isNotExistGrades, isEmptyGradeId)
  }

  type state = {
    packageMethod: option<string>,
    grade: option<string>,
    weightKg: option<string>,
    usages: array<string>,
    storageMethod: option<string>,
    prevTradePricePerKg: option<string>,
    prevTradeSellerName: option<string>,
    meatBrandIds: array<string>,
    etc: option<string>,
  }

  let reducer = (state, action: RfqApply_Steps_Buyer.action) => {
    switch action {
    | PackageMethod(packageMethod) => {...state, packageMethod}
    | Grade(grade) => {...state, grade}
    | WeightKg(weight) => {...state, weightKg: Some(weight)}
    | Usages(usages) => {...state, usages}
    | StorageMethod(storage) => {...state, storageMethod: Some(storage)}
    | PrevTradePricePerKg(kg) => {...state, prevTradePricePerKg: Some(kg)}
    | PrevTradeSellerName(name) => {...state, prevTradeSellerName: Some(name)}
    | Brands(brands) => {...state, meatBrandIds: brands}
    | ETC(etc) => {...state, etc: Some(etc)}
    }
  }

  @react.component
  let make = (~itemId, ~requestId) => {
    let {current} = RfqApply_Steps_Buyer.RfqApplyStep.use()
    let {node} = Query.use(~variables={itemId: itemId}, ())
    let (itemInfo, isNotExistGrades, isEmptyGradeId) = getItemInfo(node)

    let initialState = {
      grade: isNotExistGrades ? isEmptyGradeId : itemInfo.grade,
      weightKg: itemInfo.weightKg,
      usages: itemInfo.usages,
      storageMethod: itemInfo.storageMethod,
      packageMethod: itemInfo.packageMethod,
      prevTradePricePerKg: itemInfo.prevTradePricePerKg,
      prevTradeSellerName: itemInfo.prevTradeSellerName,
      meatBrandIds: itemInfo.meatBrandIds,
      etc: itemInfo.otherRequirements,
    }

    let (state, dispatch) = React.useReducer(reducer, initialState)

    let {
      packageMethod,
      grade,
      weightKg,
      usages,
      storageMethod,
      prevTradeSellerName,
      prevTradePricePerKg,
      meatBrandIds,
      etc,
    } = state

    let router = Next.Router.useRouter()
    let {addToast} = ReactToastNotifications.useToasts()
    let (updateMutate, isMutating) = Mutation.use()

    let titleText =
      node->Option.mapWithDefault("", node' =>
        node'.part->Option.mapWithDefault("", part' =>
          `${part'.name} / ${part'.isDomestic ? `국내` : `수입`}`
        )
      )

    let updateItem = (~initializeBrands: bool=false, ()) => {
      let input: RfqApplyBuyer_Update_Mutation_graphql.Types.rfqRequestItemMeatUpdateInput = {
        meatGradeId: grade,
        meatPartId: None,
        meatSpeciesId: None,
        meatUsageIds: usages,
        storageMethod,
        packageMethod,
        meatBrandIds: initializeBrands ? [] : meatBrandIds,
        prevTradePricePerKg,
        prevTradeSellerName,
        weightKg,
        otherRequirements: etc,
        status: #REVIEW_REQUIRED,
      }

      let toastSuccessMessage = switch initializeBrands {
      | true =>
        `${titleText} 작성이 완료되었어요! \n등급 변경으로 인해 선택했던 브랜드가 초기화되었어요.`
      | false => `${titleText} 작성이 완료되었어요!`
      }

      updateMutate(
        ~variables={id: itemId, input},
        ~onCompleted={
          ({updateRfqRequestItemsMeat}, _) => {
            switch updateRfqRequestItemsMeat {
            | #RfqRequestItemMeatMutationPayload(_) => {
                addToast(.
                  <div className=%twc("flex items-center whitespace-pre-line")>
                    <DS_Toast.Normal.IconSuccess />
                    <div> {toastSuccessMessage->React.string} </div>
                  </div>,
                  {appearance: "success"},
                )

                router->Next.Router.push(`/buyer/rfq/request/draft/list?requestId=${requestId}`)
              }

            | #Error(_)
            | #UnselectedUnionMember(_) =>
              addToast(.
                `요청 중 요류가 발생했습니다. 잠시 후 다시 시도해주세요.`->DS_Toast.getToastComponent(
                  #error,
                ),
                {appearance: "error"},
              )
            }
          }
        },
        ~onError=_ => {
          addToast(.
            `저장중 문제가 발생하였습니다. 관리자에게 문의해주세요.`->DS_Toast.getToastComponent(
              #error,
            ),
            {appearance: "error"},
          )
        },
        (),
      )->ignore
    }

    <>
      <Header title={titleText} updateItem requestId itemId dispatch />
      <ProgressBar
        currentCount={switch current {
        | Package => 1
        | Grade => 2
        | Amount => 3
        | Usage => 4
        | Storage => 5
        | Price => 6
        | Brand => 7
        | Etc => 8
        }}
        totalCount=9
      />
      {node->Option.mapWithDefault(React.null, node' => {
        switch current {
        | Package =>
          <RfqApply_Steps_Buyer.PackageMethod
            packageMethod
            dispatch
            isMutating
            updateItem
            isSkipGrade=isNotExistGrades
            itemId
            requestId
          />
        | Grade =>
          <RfqApply_Steps_Buyer.Grade
            grade node=node' dispatch isMutating updateItem itemId requestId
          />
        | Amount =>
          <RfqApply_Steps_Buyer.OrderAmount
            weightKg dispatch isMutating updateItem itemId requestId
          />
        | Usage =>
          <RfqApply_Steps_Buyer.Usages
            usages
            edges={node'.species->Option.mapWithDefault([], x => x.meatUsages.edges)}
            dispatch
            isMutating
            updateItem
            itemId
            requestId
          />
        | Storage =>
          <RfqApply_Steps_Buyer.StorageMethod
            storageMethod dispatch isMutating updateItem itemId requestId
          />
        | Price =>
          <RfqApply_Steps_Buyer.SupplyPrice
            prevTradeSellerName prevTradePricePerKg dispatch isMutating updateItem itemId requestId
          />
        | Brand =>
          <React.Suspense fallback={<RfqApply_Steps_Skeleton_Buyer />}>
            <RfqApply_Steps_Buyer.Brand
              dispatch
              isMutating
              updateItem
              itemId
              requestId
              node=node'
              grade
              isNotExistGrades
              meatBrandIds
            />
          </React.Suspense>
        | Etc => <RfqApply_Steps_Buyer.Etc etc dispatch isMutating updateItem itemId requestId />
        }
      })}
    </>
  }
}

@react.component
let make = (~itemId: option<string>, ~requestId: option<string>) => {
  let router = Next.Router.useRouter()

  {
    switch (itemId, requestId) {
    | (Some(itemId'), Some(requestId')) =>
      <Authorization.Buyer fallback={React.null} title={`바이어 견적 요청`}>
        <React.Suspense>
          <RfqCommon.CheckBuyerRequestStatus requestId={requestId'}>
            <Layout>
              <Apply itemId={itemId'} requestId={requestId'} />
            </Layout>
          </RfqCommon.CheckBuyerRequestStatus>
        </React.Suspense>
      </Authorization.Buyer>
    | _ => {
        React.useEffect0(_ => {
          router->Next.Router.push("/buyer/rfq")
          None
        })
        React.null
      }
    }
  }
}
