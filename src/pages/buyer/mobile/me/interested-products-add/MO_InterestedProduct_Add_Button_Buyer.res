module Query = %relay(`
  query MOInterestedProductAddButtonBuyerQuery {
    viewer {
      __id
    }
  }
`)
module Mutation = %relay(`
  mutation MOInterestedProductAddButtonBuyer_Mutation(
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
let make = (~checkedSet) => {
  let {viewer} = Query.use(~variables=(), ())
  let router = Next.Router.useRouter()
  let (mutation, _) = Mutation.use()
  let {addToast} = ReactToastNotifications.useToasts()

  let handleOnClick = _ => {
    mutation(
      ~variables={
        input: Mutation.make_likeProductsInput(~productIds=checkedSet->Set.String.toArray),
        connections: [
          RescriptRelay.ConnectionHandler.getConnectionID(
            viewer->Option.mapWithDefault(RescriptRelay.storeRootId, v => v.__id),
            MOInterestedProductListBuyerFragment_graphql.Utils.connectionKey,
            MO_InterestedProduct_List_Buyer.Fragment.makeRefetchVariables(
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
          router->Next.Router.replace("/?tab=matching")
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

  switch checkedSet->Set.String.isEmpty {
  | true => React.null
  | false =>
    <div className=%twc("p-4 fixed bottom-0 w-full max-w-3xl mx-auto bg-white")>
      <button
        type_="button"
        onClick={handleOnClick}
        className=%twc("w-full text-center text-white bg-green-500 py-[14px] rounded-xl")>
        <span className=%twc("font-bold text-[17px]")>
          {`${checkedSet->Set.String.size->Int.toString}개 추가하기`->React.string}
        </span>
      </button>
    </div>
  }
}
