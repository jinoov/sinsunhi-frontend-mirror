module Query = {
  module MatchingProduct = %relay(`
    query TradematchBuyFarmProductApplyBuyer_MatchingProduct_Query(
      $productNumber: Int!
    ) {
      product(number: $productNumber) {
        ... on MatchingProduct {
          id
          name
          representativeWeight
          qualityStandard {
            highQualityStandard: high {
              description
            }
            mediumQualityStandard: medium {
              description
            }
            lowQualityStandard: low {
              description
            }
          }
          recentMarketPrice {
            highRecentMarketPrice: high {
              lower
              mean
              higher
            }
            mediumRecentMarketPrice: medium {
              lower
              mean
              higher
            }
            lowRecentMarketPrice: low {
              lower
              mean
              higher
            }
          }
          category {
            name
            productCategoryCodeId
          }
        }
      }
    }
  `)

  module TradematchDemands = %relay(`
    query TradematchBuyFarmProductApplyBuyer_TradematchDemands_Query(
      $productIds: [ID!]
      $statuses: [TradematchDemandStatus!]
      $orderBy: TradematchDemandOrderBy
      $orderDirection: OrderDirection
      $productTypes: [TradematchProductType!]
      $first: Int
    ) {
      ...TradematchBuyFarmProductApplyBuyer_TradematchDemands_Fragment
        @arguments(
          productIds: $productIds
          statuses: $statuses
          orderBy: $orderBy
          orderDirection: $orderDirection
          productTypes: $productTypes
          first: $first
        )
    }
  `)
}

module Fragment = {
  module TradematchDemands = %relay(`
    fragment TradematchBuyFarmProductApplyBuyer_TradematchDemands_Fragment on Query
    @refetchable(queryName: "TradematchBuyFarmProductApplyBuyerRefetchQuery")
    @argumentDefinitions(
      after: { type: "ID" }
      productIds: { type: "[ID!]" }
      first: { type: "Int" }
      orderDirection: { type: "OrderDirection" }
      orderBy: { type: "TradematchDemandOrderBy" }
      statuses: { type: "[TradematchDemandStatus!]" }
      productTypes: { type: "[TradematchProductType!]" }
    ) {
      tradematchDemands(
        after: $after
        productIds: $productIds
        statuses: $statuses
        orderBy: $orderBy
        orderDirection: $orderDirection
        first: $first
        productTypes: $productTypes
      ) @connection(key: "TradematchBuyFarmProductApplyBuyer__tradematchDemands") {
        __id
        edges {
          node {
            canceledAt
            deliveryAddress
            deliveryAddress1
            deliveryAddress2
            deliveryDate
            deliveryRegion
            deliveryZipCode
            draftedAt
            id
            numberOfPackagesPerTrade
            packageQuantityUnit
            priceGroup
            pricePerTrade
            productCategoryCode
            productId
            productProcess
            productRequirements
            productSize
            quantityPerPackage
            quantityPerTrade
            requestedAt
            status
            tradeCycle
            wantedPricePerPackage
          }
        }
      }
    }
  `)
}

module Mutation = {
  module DeleteTradematchDemand = %relay(`
    mutation TradematchBuyFarmProductApplyBuyer_DeleteTradematchDemand_Mutation(
      $id: ID!
      $connections: [ID!]!
    ) {
      deleteTradematchDemand(id: $id) {
        ... on Error {
          message
        }
        ... on DeleteSuccess {
          deletedId @deleteEdge(connections: $connections)
        }
      }
    }
  `)
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
  let make = (~title=?, ~handleClickLeftButton=History.back) => {
    <>
      <div className=%twc("w-full fixed top-0 left-0 z-10")>
        <header className=%twc("w-full max-w-3xl mx-auto h-14 bg-white")>
          <div className=%twc("px-5 py-4 flex justify-between")>
            <button onClick={_ => handleClickLeftButton()}>
              <Formula.Icon.ArrowLeftLineRegular size=#xl />
            </button>
            <div>
              <span className=%twc("font-bold text-base")>
                {title->Option.mapWithDefault(``, x => x)->React.string}
              </span>
            </div>
            <div />
          </div>
        </header>
      </div>
      <div className=%twc("w-full h-14") />
    </>
  }
}

module ProgressBar = {
  @react.component
  let make = () => {
    let {currentIndex, length} = CustomHooks.FarmTradematchStep.use()
    let percentage = (currentIndex + 1)->Int.toFloat /. (length + 1)->Int.toFloat *. 100.
    let style = ReactDOM.Style.make(~width=`${percentage->Float.toString}%`, ())

    <div className=%twc("max-w-3xl fixed h-1 w-full bg-surface z-[10]")>
      <div style className=%twc("absolute left-0 top-0 bg-primary z-30 h-full transition-all") />
    </div>
  }
}

module Skeleton = {
  @react.component
  let make = () => {
    <>
      <div className=%twc("px-5 py-9")>
        <Skeleton.Box className=%twc("h-18") />
      </div>
      <div className=%twc("space-y-8")>
        <div className=%twc("px-5 space-y-1")>
          <Skeleton.Box className=%twc("h-7 w-1/5") />
          <Skeleton.Box className=%twc("h-5 w-1/3") />
          <Skeleton.Box className=%twc("h-5 w-1/2") />
        </div>
        <div className=%twc("px-5 space-y-1")>
          <Skeleton.Box className=%twc("h-7 w-1/5") />
          <Skeleton.Box className=%twc("h-5 w-1/3") />
          <Skeleton.Box className=%twc("h-5 w-1/2") />
        </div>
      </div>
      <div className=%twc("fixed bottom-0 max-w-3xl w-full px-4 py-5")>
        <Skeleton.Box className=%twc("w-full rounded-xl h-[52px]") />
      </div>
      <div className=%twc("h-24") />
    </>
  }
}

module NotFoundProductOrDemand = {
  @react.component
  let make = () => {
    <DS_Dialog.Popup.Root _open=true>
      <DS_Dialog.Popup.Portal>
        <DS_Dialog.Popup.Overlay />
        <DS_Dialog.Popup.Content>
          <DS_Dialog.Popup.Title>
            {`상품 정보를 찾을 수 없습니다.`->React.string}
          </DS_Dialog.Popup.Title>
          <DS_Dialog.Popup.Description>
            {`해당 상품을 찾을 수 없습니다.`->React.string}
          </DS_Dialog.Popup.Description>
          <DS_Dialog.Popup.Buttons>
            <DS_Dialog.Popup.Close asChild=true>
              <DS_Button.Normal.Large1 label={`돌아가기`} onClick={_ => History.back()} />
            </DS_Dialog.Popup.Close>
          </DS_Dialog.Popup.Buttons>
        </DS_Dialog.Popup.Content>
      </DS_Dialog.Popup.Portal>
    </DS_Dialog.Popup.Root>
  }
}

module StatusChecker = {
  @react.component
  let make = (
    ~currentDemand: option<
      TradematchBuyFarmProductApplyBuyer_TradematchDemands_Fragment_graphql.Types.fragment_tradematchDemands_edges_node,
    >,
    ~connectionId,
    ~children,
  ) => {
    let {isFirst, router: {toFirst, replace}} = CustomHooks.FarmTradematchStep.use()
    let {addToast} = ReactToastNotifications.useToasts()

    let (deleteMutate, _) = Mutation.DeleteTradematchDemand.use()

    switch (isFirst, currentDemand->Option.isSome) {
    | (false, false) => toFirst()
    | _ => ()
    }

    let hasDraftDemand = currentDemand->Option.isSome
    let (isOpenCheckDraftDemand, setIsOpenCheckDraftDemand) = React.Uncurried.useState(_ =>
      hasDraftDemand
    )

    let applyContinueDraftDemand = () => {
      switch currentDemand {
      | Some(demand) => {
          let step: CustomHooks.FarmProductSteps.t = switch (
            // grade
            demand.priceGroup->Option.isSome,
            demand.productCategoryCode->Js.String2.length > 0,
            // count
            demand.numberOfPackagesPerTrade->Option.isSome,
            demand.packageQuantityUnit->Option.isSome,
            demand.quantityPerPackage->Option.isSome,
            // price
            demand.wantedPricePerPackage->Option.isSome,
            // cycle
            demand.tradeCycle->Js.String2.length > 0,
            // requirement
            demand.productProcess->Js.String2.length > 0,
            demand.productSize->Js.String2.length > 0,
            demand.productRequirements->Js.String2.length > 0,
          ) {
          | (true, true, true, true, true, true, true, true, true, true) => Shipping
          | (true, true, true, true, true, true, true, _, _, _) => Requirement
          | (true, true, true, true, true, true, _, _, _, _) => Cycle
          | (true, true, true, true, true, _, _, _, _, _) => Price
          | (true, true, _, _, _, _, _, _, _, _) => Count
          | (_, _, _, _, _, _, _, _, _, _) => Grade
          }

          replace(step)
        }

      | None => toFirst()
      }
    }

    let handleClickAcceptButton = () => {
      setIsOpenCheckDraftDemand(._ => false)
      applyContinueDraftDemand()
    }

    let handleClickRejectButton = () => {
      switch currentDemand {
      | Some(demand) => {
          let variables = Mutation.DeleteTradematchDemand.makeVariables(
            ~id=demand.id,
            ~connections=[connectionId],
          )
          deleteMutate(
            ~variables,
            ~onCompleted=({deleteTradematchDemand}, _) => {
              switch deleteTradematchDemand {
              | #DeleteSuccess(_) => {
                  setIsOpenCheckDraftDemand(._ => false)
                  toFirst()
                }

              | #UnselectedUnionMember(_)
              | #Error(_) =>
                addToast(.
                  `요청 중 요류가 발생했습니다. 잠시 후 다시 시도해주세요.`->DS_Toast.getToastComponent(
                    #error,
                  ),
                  {appearance: "error"},
                )
              }
            },
            ~onError={
              err => {
                addToast(.
                  <div className=%twc("flex items-center")>
                    <IconError height="24" width="24" className=%twc("mr-2") />
                    {err.message->React.string}
                  </div>,
                  {appearance: "error"},
                )
              }
            },
            (),
          )->ignore
        }

      | None => ()
      }
    }

    <>
      {switch isOpenCheckDraftDemand {
      | true =>
        <>
          <Header />
          <Skeleton />
        </>
      | false => children
      }}
      <DS_Dialog.Popup.Root _open=isOpenCheckDraftDemand>
        <DS_Dialog.Popup.Portal>
          <DS_Dialog.Popup.Overlay />
          <DS_Dialog.Popup.Content>
            <DS_Dialog.Popup.Title>
              {`작성중인 견적서가 있습니다.`->React.string}
            </DS_Dialog.Popup.Title>
            <DS_Dialog.Popup.Description>
              {`이어서 작성하시겠어요?`->React.string}
            </DS_Dialog.Popup.Description>
            <DS_Dialog.Popup.Buttons>
              <DS_Dialog.Popup.Close asChild=true>
                <DS_Button.Normal.Large1
                  buttonType=#white
                  onClick={_ => handleClickRejectButton()}
                  label={`새로 작성하기`}
                />
              </DS_Dialog.Popup.Close>
              <DS_Dialog.Popup.Close asChild=true>
                <DS_Button.Normal.Large1
                  label={`이어서 작성하기`} onClick={_ => handleClickAcceptButton()}
                />
              </DS_Dialog.Popup.Close>
            </DS_Dialog.Popup.Buttons>
          </DS_Dialog.Popup.Content>
        </DS_Dialog.Popup.Portal>
      </DS_Dialog.Popup.Root>
    </>
  }
}

module Content = {
  @react.component
  let make = (
    ~matchingProduct: TradematchBuyFarmProductApplyBuyer_MatchingProduct_Query_graphql.Types.response_product_MatchingProduct,
  ) => {
    let {current} = CustomHooks.FarmTradematchStep.use()

    let draftStatusTradematchDemands = Query.TradematchDemands.use(
      ~variables={
        productIds: Some([matchingProduct.id]),
        statuses: Some([#DRAFT]),
        orderBy: Some(#DRAFTED_AT),
        orderDirection: Some(#DESC),
        first: Some(100),
        productTypes: Some([#AGRICULTURAL]),
      },
      ~fetchPolicy=NetworkOnly,
      (),
    )

    let {data} = draftStatusTradematchDemands.fragmentRefs->Fragment.TradematchDemands.usePagination
    let tradematchDemands = data.tradematchDemands->Fragment.TradematchDemands.getConnectionNodes
    let connectionId = data.tradematchDemands.__id
    let currentDemand = tradematchDemands->Garter_Array.first

    <StatusChecker currentDemand={currentDemand} connectionId={connectionId}>
      <Header title={`${matchingProduct.category.name} 견적 신청`} />
      <ProgressBar />
      {switch current {
      | Grade =>
        <Tradematch_Buy_Farm_Apply_Steps_Buyer.Grade
          pid={matchingProduct.id}
          product={matchingProduct}
          currentDemand={currentDemand}
          connectionId={connectionId}
        />
      | Count =>
        <Tradematch_Buy_Farm_Apply_Steps_Buyer.Count
          product={matchingProduct} currentDemand={currentDemand}
        />
      | Price =>
        <Tradematch_Buy_Farm_Apply_Steps_Buyer.Price
          product={matchingProduct} currentDemand={currentDemand}
        />
      | Cycle => <Tradematch_Buy_Farm_Apply_Steps_Buyer.Cycle currentDemand={currentDemand} />
      | Requirement =>
        <Tradematch_Buy_Farm_Apply_Steps_Buyer.Requirement currentDemand={currentDemand} />
      | Shipping =>
        <React.Suspense fallback={<Skeleton />}>
          <Tradematch_Buy_Farm_Apply_Steps_Buyer.Shipping currentDemand={currentDemand} />
        </React.Suspense>
      }}
    </StatusChecker>
  }
}

@react.component
let make = (~pNumber: int) => {
  let {product} = Query.MatchingProduct.use(~variables={productNumber: pNumber}, ())

  {
    switch product {
    | Some(#MatchingProduct(matchingProduct)) => <Content matchingProduct />
    | Some(#UnselectedUnionMember(_))
    | None =>
      <>
        <Header />
        <Skeleton />
        <NotFoundProductOrDemand />
      </>
    }
  }
}
