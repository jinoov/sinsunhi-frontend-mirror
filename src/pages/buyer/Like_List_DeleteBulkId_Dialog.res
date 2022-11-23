module Mutation = {
  module Unlike_Bulk_ProductItems = %relay(`
    mutation LikeListDeleteBulkIdDialog_Unlike_Bulk_ProductItems_Mutation(
      $input: UnlikeProductsInput!
      $connections: [ID!]!
    ) {
      unlikeProducts(input: $input) {
        ... on UnlikeProductsResult {
          # remainingCount
          unlikedProductIds @deleteEdge(connections: $connections)
          viewer {
            likedProductCount
          }
        }
        ... on Error {
          code
          message
        }
      }
    }
  `)
  module UnlikeAll_Bulk_ProductItems = %relay(`
    mutation LikeListDeleteBulkIdDialog_UnlikeAll_Bulk_ProductItems_Mutation(
      $input: UnlikeProductsAllInput!
      $connections: [ID!]!
    ) {
      unlikeProductsAll(input: $input) {
        ... on UnlikeProductsAllResult {
          # remainingCount
          unlikedProductIds @deleteEdge(connections: $connections)
          viewer {
            likedProductCount
          }
        }
        ... on Error {
          code
          message
        }
      }
    }
  `)
}

@module("../../../public/assets/check-fill-circle.svg")
external checkFillCircleIcon: string = "default"

@module("../../../public/assets/error-fill-circle.svg")
external errorFillCircleIcon: string = "default"

@react.component
let make = (
  ~ids,
  ~setIds,
  ~connection,
  ~show,
  ~setShow,
  ~selectedIdCount,
  ~isAllSelected,
  ~setIsAllSelected,
) => {
  let {addToast} = ReactToastNotifications.useToasts()
  let (deleteBulkId, _) = Mutation.Unlike_Bulk_ProductItems.use()
  let (deleteAllBulkId, _) = Mutation.UnlikeAll_Bulk_ProductItems.use()

  let onComplete = () => {
    setShow(._ => Dialog.Hide)
    addToast(.
      <div className=%twc("flex items-center")>
        <Image loading=Image.Loading.Lazy src=checkFillCircleIcon className=%twc("h-6 w-6 mr-2") />
        {`찜한 상품에서 삭제했어요 .`->React.string}
      </div>,
      {appearance: "success"},
    )
    setIds(._ => Set.String.empty)
    setIsAllSelected(._ => false)
  }

  let onError = errorMsg => {
    addToast(.
      <div className=%twc("flex items-center")>
        <Image loading=Image.Loading.Lazy src=errorFillCircleIcon className=%twc("h-6 w-6 mr-2") />
        {errorMsg->Option.getWithDefault("")->React.string}
      </div>,
      {appearance: "error"},
    )
  }

  let deleteBulkId = () =>
    deleteBulkId(
      ~variables=Mutation.Unlike_Bulk_ProductItems.makeVariables(
        ~input={
          productIds: ids,
        },
        ~connections=[connection],
      ),
      ~onCompleted=({unlikeProducts}, _) => {
        switch unlikeProducts {
        | #UnlikeProductsResult(_) => onComplete()

        | #Error(error) => onError(error.message)
        | #UnselectedUnionMember(_) => ()
        }
      },
      (),
    )->ignore

  let deleteAllBulkId = () =>
    deleteAllBulkId(
      ~variables=Mutation.UnlikeAll_Bulk_ProductItems.makeVariables(
        ~input={
          excludedProductIds: ids,
          types: None,
        },
        ~connections=[connection],
      ),
      ~onCompleted=({unlikeProductsAll}, _) => {
        switch unlikeProductsAll {
        | #UnlikeProductsAllResult(_) => onComplete()
        | #Error(error) => onError(error.message)
        | #UnselectedUnionMember(_) => ()
        }
      },
      (),
    )->ignore

  <Dialog
    isShow={show}
    textOnConfirm={`확인`}
    textOnCancel={`취소`}
    boxStyle=%twc("rounded-2xl text-center !w-[320px]")
    kindOfConfirm=Dialog.Positive
    onConfirm={_ => {
      switch isAllSelected {
      | false => deleteBulkId()
      | true => deleteAllBulkId()
      }
    }}
    onCancel={_ => setShow(._ => Dialog.Hide)}>
    <p>
      {`선택하신 ${selectedIdCount->Int.toString}개 상품을 삭제하시겠어요?`->React.string}
    </p>
  </Dialog>
}
