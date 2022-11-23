module Query = %relay(`
  query PCInterestedProductAddButtonBuyerQuery {
    viewer {
      __id
    }
  }
`)
module Mutation = %relay(`
  mutation PCInterestedProductAddButtonBuyer_Mutation(
    $input: LikeProductsInput!
    $connections: [ID!]!
  ) {
    likeProducts(input: $input) {
      ... on LikeProductsResult {
        likedProducts
          @prependNode(
            connections: $connections
            edgeTypeName: "LikeProductEdge"
          ) {
          id
          displayName
          image {
            thumb400x400
          }
        }
      }
    }
  }
`)

@react.component
let make = (~checkedSet, ~onClose) => {
  let {viewer} = Query.use(~variables=(), ())
  let (mutation, _) = Mutation.use()
  let {addToast} = ReactToastNotifications.useToasts()

  let handleOnClick = e => {
    mutation(
      ~variables={
        input: Mutation.make_likeProductsInput(~productIds=checkedSet->Set.String.toArray),
        connections: [
          RescriptRelay.ConnectionHandler.getConnectionID(
            viewer->Option.mapWithDefault(RescriptRelay.storeRootId, v => v.__id),
            PCInterestedProductListBuyerFragment_graphql.Utils.connectionKey,
            PC_InterestedProduct_List_Buyer.Fragment.makeRefetchVariables(
              ~orderBy=Some([
                {field: #RFQ_DISPLAY_ORDER, direction: #ASC_NULLS_FIRST},
                {field: #LIKED_AT, direction: #DESC},
              ]),
              ~types=Some([#MATCHING]),
              (),
            ),
          ),
        ],
      },
      ~onCompleted={
        (_, _) => {
          onClose(e)
          addToast(.
            <div className=%twc("flex items-center")>
              <IconCheck height="24" width="24" fill="#12B564" className=%twc("mr-2") />
              {"편집한 내용으로 저장되었어요"->React.string}
            </div>,
            {appearance: "success"},
          )
        }
      },
      ~onError={_ => Js.log("error")},
      (),
    )->ignore
    ()
  }
  <div className=%twc("pt-4 bottom-0 w-full max-w-3xl mx-auto bg-white flex")>
    <button
      type_="button"
      onClick={onClose}
      className=%twc(
        "w-full text-center bg-[#F0F2F5] interactable py-[14px] rounded-xl flex-1 mr-3 last-of-type:mr-0"
      )>
      <span className=%twc("font-bold text-[17px]")> {`닫기`->React.string} </span>
    </button>
    {switch checkedSet->Set.String.isEmpty {
    | true => React.null
    | false =>
      <button
        type_="button"
        onClick={handleOnClick}
        className=%twc("text-center text-white bg-green-500 py-[14px] rounded-xl flex-[3]")>
        <span className=%twc("font-bold text-[17px]")>
          {`${checkedSet->Set.String.size->Int.toString}개 추가하기`->React.string}
        </span>
      </button>
    }}
  </div>
}
