@module("../../public/assets/download.svg")
external downloadIcon: string = "default"

module Mutation = %relay(`
  mutation ExcelRequestButtonProductsAdmin_Mutation(
    $categoryId: ID
    $displayCategoryId: ID
    $isCourierAvailable: Boolean
    $name: String
    $onlyBuyable: Boolean
    $producerCodes: [String!]
    $producerName: String
    $productNos: [Int!]
    $statuses: [ProductStatus!]
    $type_: [ProductType!]
  ) {
    createProductExcel(
      categoryId: $categoryId
      displayCategoryId: $displayCategoryId
      isCourierAvailable: $isCourierAvailable
      name: $name
      onlyBuyable: $onlyBuyable
      producerCodes: $producerCodes
      producerName: $producerName
      productNos: $productNos
      statuses: $statuses
      type: $type_
    ) {
      ... on CreateProductExcelResult {
        result
      }
  
      ... on Error {
        code
        message
      }
    }
  }
`)

let isNonEmptyString = str => str != ""
let isNonEmptyArray = arr => arr != []

let parseDeliveryParam = q => {
  switch q {
  | "available" => true->Some
  | "unavailable" => false->Some
  | _ => None
  }
}

let parseProducerCodes = q => {
  q->Js.Global.decodeURIComponent->Js.String2.split(",")
}

let parseProducerNos = q => {
  q->Js.Global.decodeURIComponent->Js.String2.split(",")->Array.keepMap(no => no->Int.fromString)
}

let parseStatus = q => {
  switch q {
  | "All" => [#HIDDEN_SALE, #NOSALE, #RETIRE, #SALE, #SOLDOUT]->Some
  | "SALE" => [#SALE]->Some
  | "SOLDOUT" => [#SOLDOUT]->Some
  | "HIDDEN_SALE" => [#HIDDEN_SALE]->Some
  | "NOSALE" => [#NOSALE]->Some
  | "RETIRE" => [#RETIRE]->Some
  | _ => None
  }
}

let parseProductType = q => {
  switch q {
  | "All" => [#MATCHING, #NORMAL, #QUOTABLE, #QUOTED]->Some
  | "NORMAL" => [#NORMAL]->Some
  | "QUOTABLE" => [#QUOTABLE]->Some
  | "QUOTED" => [#QUOTED]->Some
  | "MATCHING" => [#MATCHING]->Some
  | _ => None
  }
}

module Toast = {
  type appearance =
    | Success
    | Failure

  let use = () => {
    let {addToast} = ReactToastNotifications.useToasts()

    (message, appearance) => {
      switch appearance {
      | Success =>
        addToast(.
          <div className=%twc("flex items-center")>
            <IconCheck height="24" width="24" fill="#12B564" className=%twc("mr-2") />
            {message->React.string}
          </div>,
          {appearance: "success"},
        )

      | Failure =>
        addToast(.
          <div className=%twc("flex items-center")>
            <IconError height="24" width="24" className=%twc("mr-2") />
            {message->React.string}
          </div>,
          {appearance: "error"},
        )
      }
    }
  }
}

module ModalConfirm = {
  @react.component
  let make = (~show, ~onConfirm, ~onCancel) => {
    <Dialog isShow=show onConfirm textOnCancel={`닫기`} onCancel>
      <span className=%twc("flex items-center justify-center w-full py-10")>
        <strong> {`엑셀 다운로드`->React.string} </strong>
        <span> {`를 요청하시겠어요?`->React.string} </span>
      </span>
    </Dialog>
  }
}

module ModalSuccess = {
  @react.component
  let make = (~show, ~onConfirm, ~onCancel) => {
    <Dialog isShow=show onConfirm textOnCancel={`닫기`} onCancel>
      <span className=%twc("flex flex-col items-center justify-center w-full py-5")>
        <span className=%twc("flex")>
          <strong> {`엑셀 다운로드 요청`->React.string} </strong>
          <span> {`이 완료되었어요.`->React.string} </span>
        </span>
        <span>
          <strong> {`다운로드 센터`->React.string} </strong>
          <span> {`로 이동하시겠어요?`->React.string} </span>
        </span>
        <span className=%twc("mt-10 whitespace-pre-wrap text-center")>
          {`*다운로드 파일 생성 진행은\n좌측 메뉴의 다운로드 센터에서 확인하실 수 있어요.`->React.string}
        </span>
      </span>
    </Dialog>
  }
}

@react.component
let make = () => {
  let {useRouter, push} = module(Next.Router)
  let router = useRouter()
  let showToast = Toast.use()

  let (requestProductExcel, isRequesting) = Mutation.use()
  let (showConfirm, setShowConfirm) = React.Uncurried.useState(_ => Dialog.Hide)
  let (showSuccess, setShowSuccess) = React.Uncurried.useState(_ => Dialog.Hide)

  let getNonEmptyParam = k => router.query->Js.Dict.get(k)->Option.keep(isNonEmptyString)

  let request = _ => {
    setShowConfirm(._ => Dialog.Hide)
    `다운로드 파일 생성을 요청합니다.`->showToast(Success)

    requestProductExcel(
      ~variables=Mutation.makeVariables(
        ~categoryId=?{"category-id"->getNonEmptyParam},
        ~displayCategoryId=?{"display-category-id"->getNonEmptyParam},
        ~isCourierAvailable=?{"delivery"->getNonEmptyParam->Option.flatMap(parseDeliveryParam)},
        ~name=?{"product-name"->getNonEmptyParam},
        ~onlyBuyable=false,
        ~producerName=?{"producer-name"->getNonEmptyParam},
        ~producerCodes=?{
          "producer-codes"
          ->getNonEmptyParam
          ->Option.map(parseProducerCodes)
          ->Option.keep(isNonEmptyArray)
        },
        ~productNos=?{
          "product-nos"
          ->getNonEmptyParam
          ->Option.map(parseProducerNos)
          ->Option.keep(isNonEmptyArray)
        },
        ~statuses=?{"status"->getNonEmptyParam->Option.flatMap(parseStatus)},
        ~type_=?{"type"->getNonEmptyParam->Option.flatMap(parseProductType)},
        (),
      ),
      ~onCompleted={
        ({createProductExcel}, _err) => {
          switch createProductExcel {
          | #CreateProductExcelResult({result}) =>
            switch result {
            | true => setShowSuccess(._ => Dialog.Show)
            | false => `요청에 실패하였습니다.`->showToast(Failure)
            }
          | #Error(_)
          | #UnselectedUnionMember(_) =>
            `요청에 실패하였습니다.`->showToast(Failure)
          }
        }
      },
      ~onError={_ => `요청에 실패하였습니다.`->showToast(Failure)},
      (),
    )->ignore
  }

  <>
    <button
      disabled=isRequesting
      className=%twc(
        "h-9 px-3 text-black-gl bg-gray-button-gl rounded-lg flex items-center min-w-max"
      )
      onClick={_ => setShowConfirm(._ => Dialog.Show)}>
      <img src=downloadIcon className=%twc("relative mr-1") />
      {`엑셀 다운로드 요청`->React.string}
    </button>
    <ModalConfirm
      show=showConfirm onCancel={_ => setShowConfirm(._ => Dialog.Hide)} onConfirm=request
    />
    <ModalSuccess
      show=showSuccess
      onCancel={_ => setShowSuccess(._ => Dialog.Hide)}
      onConfirm={_ => router->push("/admin/download-center")}
    />
  </>
}
