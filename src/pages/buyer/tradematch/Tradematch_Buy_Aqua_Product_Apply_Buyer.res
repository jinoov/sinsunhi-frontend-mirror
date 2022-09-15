module Query = {
  module Product = %relay(`
    query TradematchBuyAquaProductApplyBuyer_Query($productNumber: Int!) {
      product(number: $productNumber) {
        ... on Product {
          id
          name
          category {
            name
          }
        }
      }
    }
  `)

  module TradematchDemands = %relay(`
    query TradematchBuyAquaProductApplyBuyer_TradematchDemands_Query(
      $productIds: [ID!]
      $statuses: [TradematchDemandStatus!]
      $orderBy: TradematchDemandOrderBy
      $orderDirection: OrderDirection
      $productTypes: [TradematchProductType!]
      $first: Int
    ) {
      ...TradematchBuyAquaProductApplyBuyer_TradematchDemands_Fragment
        @arguments(
          productIds: $productIds
          statuses: $statuses
          orderBy: $orderBy
          orderDirection: $orderDirection
          first: $first
          productTypes: $productTypes
        )
    }
  `)
}

module Fragment = {
  module TradematchDemands = %relay(`
    fragment TradematchBuyAquaProductApplyBuyer_TradematchDemands_Fragment on Query
    @refetchable(queryName: "TradematchBuyAquaProductApplyBuyerRefetchQuery")
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
      ) @connection(key: "TradematchBuyAquaProductApplyBuyer__tradematchDemands") {
        __id
        edges {
          node {
            id
            productOrigin
            numberOfPackagesPerTrade
            wantedPricePerPackage
            productStorageMethod
            tradeCycle
            productProcess
            productRequirements
            productSize
          }
        }
      }
    }
  `)
}

module Mutation = {
  module DeleteTradematchDemand = %relay(`
    mutation TradematchBuyAquaProductApplyBuyer_DeleteTradematchDemand_Mutation(
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

module ProgressBar = {
  @react.component
  let make = () => {
    let {currentIndex, length} = CustomHooks.AquaTradematchStep.use()
    let percentage = (currentIndex + 1)->Int.toFloat /. (length + 1)->Int.toFloat *. 100.
    let style = ReactDOM.Style.make(~width=`${percentage->Float.toString}%`, ())

    <div className=%twc("max-w-3xl fixed h-1 w-full bg-surface z-[10]")>
      <div style className=%twc("absolute left-0 top-0 bg-primary z-30 h-full transition-all") />
    </div>
  }
}

module StatusChecker = {
  let getNextStep = (
    ~demand: TradematchBuyAquaProductApplyBuyer_TradematchDemands_Fragment_graphql.Types.fragment_tradematchDemands_edges_node,
  ): CustomHooks.AquaProductSteps.t => {
    let {
      productOrigin: origin,
      numberOfPackagesPerTrade: weight,
      wantedPricePerPackage: price,
      productStorageMethod: method,
      tradeCycle: cycle,
      productProcess: process,
      productSize: size,
      productRequirements: req,
    } = demand

    let stringToOption: string => option<string> = str =>
      Js.String2.length(str) > 0 ? Some(str) : None

    switch (
      origin->stringToOption,
      weight,
      price,
      method->stringToOption,
      cycle->stringToOption,
      [process, size, req]->Array.every(s => Js.String2.length(s) > 0),
    ) {
    | (Some(_), Some(_), Some(_), Some(_), Some(_), true) => Shipping
    | (Some(_), Some(_), Some(_), Some(_), Some(_), false) => Requirement
    | (Some(_), Some(_), Some(_), Some(_), None, _) => Cycle
    | (Some(_), Some(_), Some(_), None, _, _) => StorageMethod
    | (Some(_), Some(_), None, _, _, _) => Price
    | (Some(_), None, _, _, _, _) => Weight
    | (None, _, _, _, _, _) => Origin
    }
  }

  @react.component
  let make = (
    ~currentDemand: option<
      TradematchBuyAquaProductApplyBuyer_TradematchDemands_Fragment_graphql.Types.fragment_tradematchDemands_edges_node,
    >,
    ~connectionId,
    ~children,
  ) => {
    let {isFirst, router: {toFirst, replace}} = CustomHooks.AquaTradematchStep.use()
    let {addToast} = ReactToastNotifications.useToasts()

    let nextStep = currentDemand->Option.map(demand => getNextStep(~demand))
    let (showContinueDraft, setContinueDraft) = React.Uncurried.useState(_ =>
      nextStep->Option.isSome
    )

    let (deleteMutate, _) = Mutation.DeleteTradematchDemand.use()

    let handleClickRejectButton = () => {
      switch currentDemand {
      | Some(demand) =>
        deleteMutate(
          ~variables={id: demand.id, connections: [connectionId]},
          ~onCompleted=({deleteTradematchDemand}, _) => {
            switch deleteTradematchDemand {
            | #DeleteSuccess(_) => {
                setContinueDraft(._ => false)
                toFirst()
              }

            | _ =>
              addToast(.
                `요청 중 오류가 발생했습니다. 잠시 후 다시 시도해주세요.`->DS_Toast.getToastComponent(
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

      | None => ()
      }
    }
    let handleClickAcceptButton = () => {
      setContinueDraft(._ => false)
      switch nextStep {
      | Some(step) => replace(step)
      | None => toFirst()
      }
    }

    React.useLayoutEffect0(() => {
      switch (isFirst, nextStep) {
      | (false, None) => toFirst()
      | _ => ()
      }
      None
    })

    <>
      {switch showContinueDraft {
      | true => <> <Tradematch_Header_Buyer /> <Tradematch_Skeleton_Buyer /> </>
      | false => children
      }}
      <DS_Dialog.Popup.Root _open=showContinueDraft>
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
  let make = (~pid: string) => {
    let {current, router: {replace, toFirst}} = CustomHooks.AquaTradematchStep.use()
    let draftStatusTradematchDemands = Query.TradematchDemands.use(
      ~variables={
        productIds: Some([pid]),
        statuses: Some([#DRAFT]),
        orderBy: Some(#DRAFTED_AT),
        orderDirection: Some(#DESC),
        first: Some(100),
        productTypes: Some([#AQUATIC]),
      },
      ~fetchPolicy=NetworkOnly,
      (),
    )

    let {data: {tradematchDemands}} = Fragment.TradematchDemands.usePagination(
      draftStatusTradematchDemands.fragmentRefs,
    )

    let currentDemand =
      tradematchDemands->Fragment.TradematchDemands.getConnectionNodes->Garter.Array.first

    let connectionId = tradematchDemands.__id

    <StatusChecker currentDemand connectionId>
      <ProgressBar />
      {switch (current, currentDemand->Option.map(({id}) => id)) {
      | (Origin, demandId) =>
        <Tradematch_Buy_Aqua_Apply_Steps_Buyer.Origin
          defaultOrigin=?{currentDemand->Option.map(({productOrigin}) => productOrigin)}
          connectionId
          demandId=?{demandId}
          productId={pid}
        />
      | (Weight, Some(demandId)) =>
        <Tradematch_Buy_Aqua_Apply_Steps_Buyer.Weight
          demandId
          defaultWeight=?{currentDemand
          ->Option.flatMap(({numberOfPackagesPerTrade}) => numberOfPackagesPerTrade)
          ->Option.map(Int.toString)}
        />
      | (Price, Some(demandId)) =>
        switch currentDemand->Option.flatMap(({numberOfPackagesPerTrade}) =>
          numberOfPackagesPerTrade
        ) {
        | Some(weight') =>
          <Tradematch_Buy_Aqua_Apply_Steps_Buyer.Price
            demandId
            currentWeight=weight'
            defaultPrice=?{currentDemand
            ->Option.flatMap(({wantedPricePerPackage}) => wantedPricePerPackage)
            ->Option.map(Int.toString)}
          />
        | None =>
          //Weight 값이 없으면 Weight 페이지로 이동
          replace(Weight)
          React.null
        }

      | (StorageMethod, Some(demandId)) =>
        <Tradematch_Buy_Aqua_Apply_Steps_Buyer.StorageMethod
          demandId
          defaultStorageMethod=?{currentDemand->Option.flatMap(({productStorageMethod}) =>
            productStorageMethod->Tradematch_Buy_Aqua_Apply_Steps_Buyer.StorageMethod.fromString
          )}
        />
      | (Cycle, Some(demandId)) =>
        <Tradematch_Buy_Aqua_Apply_Steps_Buyer.Cycle
          demandId
          defaultCycle=?{currentDemand->Option.flatMap(({tradeCycle}) =>
            tradeCycle->Tradematch_Buy_Aqua_Apply_Steps_Buyer.Cycle.fromString
          )}
        />
      | (Requirement, Some(demandId)) => {
          let (size, process, requirements) =
            currentDemand->Option.mapWithDefault((None, None, None), ({
              productSize,
              productProcess,
              productRequirements,
            }) => (Some(productSize), Some(productProcess), Some(productRequirements)))

          <Tradematch_Buy_Aqua_Apply_Steps_Buyer.Requirement
            demandId
            defaultSize=?{size}
            defaultProcess=?{process}
            defaultRequirements=?{requirements}
          />
        }

      | (Shipping, Some(demandId)) => <Tradematch_Buy_Aqua_Apply_Steps_Buyer.Shipping demandId />
      | (_, None) => {
          toFirst()
          React.null
        }
      }}
    </StatusChecker>
  }
}

/*
 * Product가 조회되는 경우에 대해서만 거래매칭 콘텐츠를 노출.
 */

@react.component
let make = (~pNumber: int) => {
  let {product} = Query.Product.use(~variables={productNumber: pNumber}, ())

  {
    switch product->Option.map(({category, id}) => (category, id)) {
    | Some((category', pid)) => <>
        <Tradematch_Header_Buyer title={`${category'.name} 견적신청`} /> <Content pid />
      </>
    | _ => <>
        <Tradematch_Header_Buyer title="" />
        <Tradematch_Skeleton_Buyer />
        <Tradematch_NotFound_Buyer />
      </>
    }
  }
}
