module Mutation = {
  module Unmark_Bulk_ProductItems = %relay(`
    mutation RecentViewListDeleteBulkIdDialog_Unmark_Bulk_ProductItems_Mutation(
      $input: UnmarkProductsAsViewedInput!
      $connections: [ID!]!
    ) {
      unmarkProductsAsViewed(input: $input) {
        ... on UnmarkProductsAsViewedResult {
          unmarkedProductIds @deleteEdge(connections: $connections)
          viewer {
            viewedProductCount
          }
        }
        ... on Error {
          code
          message
        }
      }
    }
  `)
  module UnmarkAll_Bulk_ProductItems = %relay(`
    mutation RecentViewListDeleteBulkIdDialog_UnmarkAll_Bulk_ProductItems_Mutation(
      $input: UnmarkAllProductsAsViewedInput!
      $connections: [ID!]!
    ) {
      unmarkAllProductsAsViewed(input: $input) {
        ... on UnmarkAllProductsAsViewedResult {
          unmarkedProductIds @deleteEdge(connections: $connections)
          viewer {
            viewedProductCount
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
  let (deleteBulkId, _) = Mutation.Unmark_Bulk_ProductItems.use()
  let (deleteAllBulkId, _) = Mutation.UnmarkAll_Bulk_ProductItems.use()

  let onComplete = () => {
    setShow(._ => Dialog.Hide)
    addToast(.
      <div className=%twc("flex items-center")>
        <Image loading=Image.Loading.Lazy src=checkFillCircleIcon className=%twc("h-6 w-6 mr-2") />
        {`최근 본 상품에서 삭제했어요 .`->React.string}
      </div>,
      {appearance: "success"},
    )
    setIds(._ => Set.String.empty)
    setIsAllSelected(._ => false)
  }

  let onError = errorMsg => {
    setShow(._ => Dialog.Hide)
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
      ~variables=Mutation.Unmark_Bulk_ProductItems.makeVariables(
        ~input={
          productIds: ids,
        },
        ~connections=[connection],
      ),
      ~onCompleted=({unmarkProductsAsViewed}, _) => {
        switch unmarkProductsAsViewed {
        | #UnmarkProductsAsViewedResult(_) => onComplete()
        | #Error(error) => onError(error.message)
        | #UnselectedUnionMember(_) => ()
        }
      },
      (),
    )->ignore

  let deleteAllBulkId = () =>
    deleteAllBulkId(
      ~variables=Mutation.UnmarkAll_Bulk_ProductItems.makeVariables(
        ~input={
          excludedProductIds: ids,
        },
        ~connections=[connection],
      ),
      ~onCompleted=({unmarkAllProductsAsViewed}, _) => {
        switch unmarkAllProductsAsViewed {
        | #UnmarkAllProductsAsViewedResult(_) => onComplete()
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
