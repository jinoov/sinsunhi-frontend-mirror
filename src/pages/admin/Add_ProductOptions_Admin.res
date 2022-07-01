open ReactHookForm

module Query = %relay(`
  query AddProductOptionsAdminQuery($id: ID!) {
    node(id: $id) {
      ... on Product {
        ...ProductSummaryAdminFragment
        ...AddProductOptionsAdminFragment
      }
    }
  }

`)

module Fragment = %relay(`
  fragment AddProductOptionsAdminFragment on Product {
    displayName
    productOptions {
      totalCount
    }
    isCourierAvailable
  }
`)

module Mutation = %relay(`
  mutation AddProductOptionsAdminMutation($input: UpsertProductOptionsInput!) {
    upsertProductOptions(input: $input) {
      ... on Error {
        message
        code
      }
      ... on UpsertProductOptionsResult {
        # 생성 페이지는 api 성공 시 리스트 페이지로 이동하기때문에, prepend 불필요
        createdProductOptions {
          id
        }
        # updatedProductOptions필드도 있지만 생성화면이므로, 업데이트된 요소는 없음
      }
    }
  }
`)

module Form = {
  let name = "options"

  @spice
  type options = {options: array<Add_ProductOption_Admin.Form.submit>}
}

let contractTypeEncode = str => {
  switch str {
  | _ if str == `온라인택배` => #ONLINE
  | _ if str == `전량판매` => #BULKSALE
  | _ => #ONLINE
  }
}

let statusEncode = str => {
  switch str {
  | _ if str == `SLAE` => #SALE
  | _ if str == `SOLDOUT` => #SOLDOUT
  | _ if str == `HIDDEN_SALE` => #HIDDEN_SALE
  | _ if str == `NOSALE` => #NOSALE
  | _ if str == `RETIRE` => #RETIRE
  | _ => #SALE
  }
}

let weightUnitEncode = weightUnit => {
  open Select_Product_Option_Unit.WeightStatus

  switch weightUnit {
  | G => #G
  | KG => #KG
  | T => #T
  }
}
let sizeUnitEncode = sizeUnit => {
  open Select_Product_Option_Unit.SizeStatus

  switch sizeUnit {
  | MM => #MM
  | CM => #CM
  | M => #M
  }
}

let noneToDefaultCutOffTime = cutOffTime =>
  cutOffTime->Option.mapWithDefault(
    Some(`10시 이전 발주 완료건에 한해 당일 출고(단, 산지 상황에 따라 출고 일정은 변경 될 수 있습니다.)`),
    str => Some(str),
  )

let nonEmptyString = str => str !== ""

let makeCreateOption: (
  string,
  Add_ProductOption_Admin.Form.submit,
) => AddProductOptionsAdminMutation_graphql.Types.createProductOptionInput = (
  productNodeId,
  option,
) => {
  productOptionCost: {
    contractType: option.cost.costType->contractTypeEncode,
    deliveryCost: option.cost.deliveryCost->Option.getWithDefault(0),
    rawCost: option.cost.rawCost,
    workingCost: option.cost.workingCost,
  },
  grade: option.grade->Option.keep(nonEmptyString),
  cutOffTime: option.cutOffTime->Option.keep(nonEmptyString)->noneToDefaultCutOffTime,
  memo: option.memo->Option.keep(nonEmptyString),
  optionName: {
    switch option.name->Option.flatMap(str => str == "" ? None : Some(str)) {
    | Some(name') => name'
    | None => {
        let (numMin, numMax, perWeightUnit, sizeMin, sizeMax, sizeUnit) =
          option.each
          ->Option.map(({numMin, numMax, weightUnit, sizeMin, sizeMax, sizeUnit}) => (
            numMin->Some,
            numMax->Some,
            weightUnit->Some,
            sizeMin->Some,
            sizeMax->Some,
            sizeUnit->Some,
          ))
          ->Option.getWithDefault((None, None, None, None, None, None))
        Add_ProductOption_Admin.makeAutoGeneratedName(
          ~grade=option.grade,
          ~package=option.package,
          ~weight=option.weight->Float.toString->Some,
          ~weightUnit=option.weightUnit->Select_Product_Option_Unit.Weight.toString->Some,
          ~numMin={numMin->Option.map(Float.toString)},
          ~numMax={numMax->Option.map(Float.toString)},
          ~perWeightUnit={
            perWeightUnit->Option.map(Select_Product_Option_Unit.Weight.toString)
          },
          ~sizeMin={sizeMin->Option.map(Float.toString)},
          ~sizeMax={sizeMax->Option.map(Float.toString)},
          ~sizeUnit={
            sizeUnit->Option.map(Select_Product_Option_Unit.Size.toString)
          },
          ~showEach={option.showEach},
          (),
        )
      }
    }
  },
  packageType: option.package->Option.keep(nonEmptyString),
  price: option.cost.buyerPrice,
  productId: productNodeId,
  weight: option.weight,
  weightUnit: option.weightUnit->weightUnitEncode,
  status: option.operationStatus->statusEncode,
  //--- 입수정보
  countPerPackageMax: option.each
  ->Option.keep(_ => option.showEach)
  ->Option.map(each => each.numMax->Int.fromFloat),
  countPerPackageMin: option.each
  ->Option.keep(_ => option.showEach)
  ->Option.map(each => each.numMin->Int.fromFloat),
  perSizeMax: option.each->Option.keep(_ => option.showEach)->Option.map(each => each.sizeMin),
  perSizeMin: option.each->Option.keep(_ => option.showEach)->Option.map(each => each.sizeMax),
  perSizeUnit: option.each
  ->Option.keep(_ => option.showEach)
  ->Option.map(each => each.sizeUnit->sizeUnitEncode),
  perWeightMax: option.each
  ->Option.keep(_ => option.showEach)
  ->Option.map(each =>
    Product_Option_Each_Admin.getPerWeight(
      option.weight,
      option.weightUnit,
      each.numMin,
      Some(each.weightUnit),
    )
  )
  ->Option.flatMap(Float.fromString),
  perWeightMin: option.each
  ->Option.keep(_ => option.showEach)
  ->Option.map(each =>
    Product_Option_Each_Admin.getPerWeight(
      option.weight,
      option.weightUnit,
      each.numMax,
      Some(each.weightUnit),
    )
  )
  ->Option.flatMap(Float.fromString),
  perWeightUnit: option.each
  ->Option.keep(_ => option.showEach)
  ->Option.map(each => each.weightUnit->weightUnitEncode),
}

module Presenter = {
  @react.component
  let make = (~query, ~productId: string) => {
    let {
      displayName: productDisplayName,
      productOptions: {totalCount},
      isCourierAvailable,
    } = Fragment.use(query)
    let router = Next.Router.useRouter()

    let (mutate, _) = Mutation.use()
    let {addToast} = ReactToastNotifications.useToasts()
    let (showReset, setShowReset) = React.Uncurried.useState(_ => Dialog.Hide)
    let (showGoToList, setShowGoToList) = React.Uncurried.useState(_ => Dialog.Hide)

    let methods = Hooks.Form.use(.
      ~config=Hooks.Form.config(
        ~mode=#onChange,
        ~defaultValues=[(Form.name, [Add_ProductOption_Admin.Form.defaultValue]->Js.Json.array)]
        ->Js.Dict.fromArray
        ->Js.Json.object_,
        (),
      ),
      (),
    )
    let {handleSubmit, reset} = methods

    let onSubmit = (nodeId, data: Js.Json.t, _) => {
      switch data->Form.options_decode {
      | Ok(decode) =>
        {
          mutate(
            ~variables={
              input: {
                createProductOptions: Some(decode.options->Array.map(makeCreateOption(nodeId))),
                updateProductOptions: None,
              },
            },
            ~onCompleted=(_, _) => {
              addToast(.
                <div className=%twc("flex items-center")>
                  <IconCheck height="24" width="24" fill="#12B564" className=%twc("mr-2") />
                  {j`상품 등록이 완료되었습니다.`->React.string}
                </div>,
                {appearance: "success"},
              )
              //상품 목록 페이지로 이동
              router->Next.Router.push("/admin/products")
            },
            ~onError={
              err =>
                addToast(.
                  <div className=%twc("flex items-center")>
                    <IconError height="24" width="24" className=%twc("mr-2") />
                    {err.message->React.string}
                  </div>,
                  {appearance: "error"},
                )
            },
            (),
          )
        }->ignore
      | Error(err) => {
          Js.log(err)
          addToast(.
            <div className=%twc("flex items-center")>
              <IconError height="24" width="24" className=%twc("mr-2") />
              {err.message->React.string}
            </div>,
            {appearance: "error"},
          )->ignore
        }
      }
    }

    React.useEffect1(_ => {
      // 단품이 이미 있는 경우 단품 수정페이지로 이동시킵니다.
      if totalCount > 0 {
        router->Next.Router.replace(`/admin/products/${productId}/options`)
      }
      None
    }, [totalCount])

    <ReactHookForm.Provider methods>
      <form onSubmit={handleSubmit(. onSubmit(productId))}>
        <div className=%twc("max-w-gnb-panel overflow-auto bg-div-shape-L1 min-h-screen")>
          <header className=%twc("flex flex-col items-baseline px-5 pt-10 gap-1")>
            <h1 className=%twc("text-text-L1 font-bold text-xl")>
              {`단품 등록`->React.string}
            </h1>
          </header>
          <div>
            <section className=%twc("p-7 mt-4 mx-4 mb-7 bg-white rounded shadow-gl")>
              <Product_Summary_Admin query />
            </section>
          </div>
          <div>
            // 단품 정보
            <section className=%twc("p-7 mt-4 mx-4 mb-7 bg-white rounded shadow-gl")>
              <Add_ProductOptions_List_Admin
                productDisplayName formName={Form.name} isCourierAvailable
              />
            </section>
          </div>
        </div>
        <div
          className=%twc(
            "relative h-16 max-w-gnb-panel bg-white flex items-center gap-2 justify-between pr-5"
          )>
          <button
            className=%twc("px-3 py-2 bg-div-shape-L1 rounded-lg focus:outline-none")
            onClick={ReactEvents.interceptingHandler(_ => setShowGoToList(._ => Dialog.Show))}>
            {`목록으로`->React.string}
          </button>
          <div className=%twc("flex gap-2")>
            <button
              onClick={ReactEvents.interceptingHandler(_ => setShowReset(._ => Dialog.Show))}
              className=%twc("px-3 py-2 bg-div-shape-L1 rounded-lg focus:outline-none")>
              {`초기화`->React.string}
            </button>
            <button
              type_="submit"
              className=%twc(
                "px-3 py-2 bg-green-gl text-white rounded-lg hover:bg-green-gl-dark focus:outline-none"
              )>
              {`단품 등록`->React.string}
            </button>
          </div>
        </div>
      </form>
      <Dialog
        boxStyle=%twc("text-center rounded-2xl")
        isShow={showReset}
        textOnCancel=`취소`
        textOnConfirm=`초기화`
        kindOfConfirm=Dialog.Negative
        onConfirm={_ => {
          reset(.
            Some(
              [(Form.name, [Add_ProductOption_Admin.Form.defaultValue]->Js.Json.array)]
              ->Js.Dict.fromArray
              ->Js.Json.object_,
            ),
          )
          setShowReset(._ => Dialog.Hide)
        }}
        onCancel={_ => setShowReset(._ => Dialog.Hide)}>
        <p>
          {`단품등록 페이지를`->React.string}
          <br />
          {`초기화 하시겠습니까?`->React.string}
        </p>
      </Dialog>
      <Dialog
        boxStyle=%twc("text-center rounded-2xl")
        isShow={showGoToList}
        textOnCancel=`취소`
        textOnConfirm=`상품목록으로`
        kindOfConfirm=Dialog.Negative
        onConfirm={_ => {
          setShowGoToList(._ => Dialog.Hide)
          router->Next.Router.push("/admin/products")
        }}
        onCancel={_ => setShowGoToList(._ => Dialog.Hide)}>
        <p>
          {`기존에 등록하신 단품 정보를 초기화하고`->React.string}
          <br />
          {`상품 목록으로 이동하시겠습니까?`->React.string}
        </p>
      </Dialog>
    </ReactHookForm.Provider>
  }
}

module Container = {
  // node 를 못찾은 경우는 해당 컴포넌트에서 처리합니다.
  // Presenter 는 node가 존재할 때 렌더됩니다.
  @react.component
  let make = (~productId: string) => {
    let queryData = Query.use(
      ~variables={id: productId},
      ~fetchPolicy=RescriptRelay.StoreAndNetwork,
      (),
    )

    switch queryData.node {
    | Some(node') => <Presenter query={node'.fragmentRefs} productId />
    | None => <div> {`상품이 존재하지 않습니다`->React.string} </div>
    }
  }
}

@react.component
let make = () => {
  let router = Next.Router.useRouter()
  let id = router.query->Js.Dict.get("pid")

  <RescriptReactErrorBoundary fallback={_ => <div> {j`에러 발생`->React.string} </div>}>
    <Authorization.Admin title=j`관리자 단품 관리`>
      <React.Suspense fallback={<div> {j`로딩 중..`->React.string} </div>}>
        {switch id {
        | Some(productId') => <Container productId={productId'} />
        | None => <div> {`상품이 존재하지 않습니다`->React.string} </div>
        }}
      </React.Suspense>
    </Authorization.Admin>
  </RescriptReactErrorBoundary>
}