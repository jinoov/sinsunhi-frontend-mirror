module Mutation = %relay(`
  mutation MOInterestedProductEditButtonBuyerMutation($input: ReplaceRfqLikedProductsInput!) {
    replaceRfqLikedProducts(input: $input) {
      ... on ReplaceRfqLikedProductsResult {
        viewer {
          __id
        }
      }
    }
  }
`)

module ErrorToast = {
  @module("/public/assets/error-fill-circle.svg")
  external errorFillCircleIcon: string = "default"
  @react.component
  let make = () => {
    <div className=%twc("flex items-center")>
      <Image loading=Image.Loading.Lazy src=errorFillCircleIcon className=%twc("h-6 w-6 mr-2") />
      {"일시적 오류입니다. 다시 시도해주세요."->React.string}
    </div>
  }
}

module SuccessToast = {
  @module("/public/assets/success-fill-circle.svg")
  external inputCheckIcon: string = "default"
  @react.component
  let make = () => {
    <div className=%twc("flex items-center")>
      <Image loading=Image.Loading.Lazy src=inputCheckIcon className=%twc("h-6 w-6 mr-2") />
      {"편집한 내용이 저장되었습니다."->React.string}
    </div>
  }
}

@react.component
let make = (
  ~interestedProducts: array<
    MOInterestedProductEditListBuyerFragment_graphql.Types.fragment_likedProducts_edges_node,
  >,
  ~show,
) => {
  let router = Next.Router.useRouter()
  let (mutate, _) = Mutation.use()
  let {addToast} = ReactToastNotifications.useToasts()

  let handleOnClick = _ => {
    mutate(
      ~variables={input: {productIds: interestedProducts->Array.map(({id}) => id)}},
      ~onCompleted=(_, _) => {
        addToast(. <SuccessToast />, {appearance: "success"})
        router->Next.Router.back
      },
      ~onError=_ => {
        addToast(. <ErrorToast />, {appearance: "error"})
        router->Next.Router.back
      },
      ~updater=(storeProxy, response) => {
        // 관심상품 리스트를 stale 처리합니다.
        switch response.replaceRfqLikedProducts {
        | #ReplaceRfqLikedProductsResult(result) => {
            let user =
              storeProxy->RescriptRelay.RecordSourceSelectorProxy.get(~dataId=result.viewer.__id)

            let connection = user->Option.flatMap(user' => {
              RescriptRelay.ConnectionHandler.getConnection(
                ~record=user',
                ~key=MOInterestedProductListBuyerFragment_graphql.Utils.connectionKey,
                ~filters=RescriptRelay.makeArguments({
                  "orderBy": Some([
                    {"field": #RFQ_DISPLAY_ORDER, "direction": #ASC_NULLS_FIRST},
                    {"field": #LIKED_AT, "direction": #DESC},
                  ]),
                  "types": Some([#MATCHING]),
                }),
                (),
              )
            })

            switch connection {
            | Some(connection') => connection'->RescriptRelay.RecordProxy.invalidateRecord
            | None => ()
            }
          }

        | #UnselectedUnionMember(_) => ()
        }
      },
      (),
    )->ignore
  }

  <div
    className={cx([
      %twc(
        "p-4 fixed w-full max-w-3xl mx-auto bg-white transition-[bottom] duration-150 ease-out "
      ),
      show ? %twc("bottom-0") : %twc("-bottom-full"),
    ])}>
    <button
      type_="button"
      onClick={handleOnClick}
      className=%twc("w-full text-center text-white bg-green-500 py-[14px] rounded-xl")>
      <span className=%twc("font-bold text-[17px]")> {`저장하기`->React.string} </span>
    </button>
  </div>
}
