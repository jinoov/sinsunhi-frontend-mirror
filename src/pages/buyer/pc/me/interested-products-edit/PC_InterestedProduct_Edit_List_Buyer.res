module Fragment = %relay(`
    fragment PCInterestedProductEditListBuyerFragment on User
    @refetchable(queryName: "PCInterestedProductEditListRefetchQuery")
    @argumentDefinitions(
      cursor: { type: "String", defaultValue: null }
      count: { type: "Int!" }
      orderBy: {
        type: "[LikedProductsOrderBy!]"
        defaultValue: [
          { field: RFQ_DISPLAY_ORDER, direction: ASC_NULLS_FIRST }
          { field: LIKED_AT, direction: DESC }
        ]
      }
    ) {
      likedProducts(
        after: $cursor
        first: $count
        orderBy: $orderBy
        types: [MATCHING]
      ) @connection(key: "PCInterestedProductEditList_likedProducts") {
        __id
        edges {
          cursor
          node {
            id
            displayName
            image {
              thumb400x400
            }
          }
        }
        totalCount
      }
    }
`)

module Mutation = %relay(`
    mutation PCInterestedProductEditListBuyerMutation(
      $input: ReplaceRfqLikedProductsInput!
    ) {
      replaceRfqLikedProducts(input: $input) {
        ... on ReplaceRfqLikedProductsResult {
          viewer {
            __id
          }
        }
      }
    }
  `)

module Content = {
  @react.component
  let make = (
    ~likedProducts: PCInterestedProductEditListBuyerFragment_graphql.Types.fragment_likedProducts,
  ) => {
    let (updateInterestedProductsList, _) = Mutation.use()
    let {addToast} = ReactToastNotifications.useToasts()

    let {useRouter, replace, back} = module(Next.Router)
    let router = useRouter()

    let (interestedProducts, setInterestedProducts) = React.Uncurried.useState(_ =>
      likedProducts.edges->Array.map(({node}) => node)
    )

    let showEditDoneToast = _ => {
      addToast(.
        <div className=%twc("flex items-center")>
          <IconCheck height="24" width="24" fill="#12B564" className=%twc("mr-2") />
          {"편집한 내용으로 저장되었어요."->React.string}
        </div>,
        {appearance: "success"},
      )
    }

    let updateInterestedProducts = ids => {
      updateInterestedProductsList(
        ~variables={input: {productIds: ids}},
        ~onCompleted=(_, _) => {
          router->replace("/buyer/me/interested")
          showEditDoneToast()
        },
        ~onError=_ => {
          Js.log("error on PC_InterestedProduct_Edit_List_Buyer")
        },
        ~updater=(storeProxy, response) => {
          // 관심상품 리스트를 stale 처리합니다.
          switch response.replaceRfqLikedProducts {
          | #ReplaceRfqLikedProductsResult(result) => {
              // 뷰어 커넥션의 레코드 프록시 꺼내오기
              let user =
                storeProxy->RescriptRelay.RecordSourceSelectorProxy.get(~dataId=result.viewer.__id)

              //부모 커넥션을 이용하여 자식 커넥션 가져오기
              let connection = user->Option.flatMap(user' => {
                RescriptRelay.ConnectionHandler.getConnection(
                  ~record=user',
                  ~key=PCInterestedProductListBuyerFragment_graphql.Utils.connectionKey,
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

              //커넥션이 있는 경우 invalidate 처리
              switch connection {
              | Some(connection') => connection'->RescriptRelay.RecordProxy.invalidateRecord
              | None => ()
              }

              let editConnection =
                storeProxy->RescriptRelay.RecordSourceSelectorProxy.get(~dataId=likedProducts.__id)

              switch editConnection {
              | Some(editConnection') => editConnection'->RescriptRelay.RecordProxy.invalidateRecord
              | None => ()
              }
            }

          | #UnselectedUnionMember(_) => ()
          }
        },
        (),
      )->ignore
    }

    let deleteAll = _ => {
      showEditDoneToast()
      router->back
    }

    let apply = () => {
      updateInterestedProducts(interestedProducts->Array.map(({id}) => id))
    }

    switch interestedProducts {
    | [] =>
      <>
        <div className=%twc("flex justify-between items-center")>
          <div
            className=%twc("inline-flex text-[26px] font-bold items-center ml-3 pt-10 mb-[42px]")>
            <button type_="button" onClick={_ => router->back} className=%twc("cursor-pointer")>
              <IconArrow
                width="36px" height="36px" fill="#1F2024" className=%twc("rotate-180 mr-[10px]")
              />
            </button>
            <h2> {`관심 상품`->React.string} </h2>
          </div>
          <div className=%twc("inline-flex items-center max-h-fit gap-2")>
            <Formula.Button.Container
              color=#"tertiary-gray"
              size=#sm
              onClick={_ => apply()->ignore}
              text="완료"
              className=%twc("font-bold")
            />
          </div>
        </div>
        <div className=%twc("min-h-[720px] flex flex-col justify-center items-center")>
          <span className=%twc("text-gray-800 text-lg")>
            {"관심 상품이 없어요."->React.string}
          </span>
          <br />
          <p className=%twc("text-gray-500 mt-1 text-center")>
            {"시세 정보를 원하는 상품을 추가하면 관심상품에서"->React.string}
            <br />
            {"편하게 확인하고 관리할 수 있어요."->React.string}
          </p>
        </div>
      </>
    | interestedProducts' =>
      <>
        <div className=%twc("flex justify-between items-center")>
          <div
            className=%twc("inline-flex text-[26px] font-bold items-center ml-3 pt-10 mb-[42px] ")>
            <button type_="button" onClick={_ => router->back} className=%twc("cursor-pointer")>
              <IconArrow
                width="36px" height="36px" fill="#1F2024" className=%twc("rotate-180 mr-[10px]")
              />
            </button>
            <h2> {`관심 상품`->React.string} </h2>
          </div>
          <div className=%twc("inline-flex items-center max-h-fit gap-2 font-bold")>
            <button
              type_="button"
              className=%twc(
                "px-3 py-[6px] text-sm text-[#65666B] rounded-lg bg-[#F0F2F5] font-bold hover:bg-[#AEB0B5] active:bg-[#A7A9AF] ease-in-out duration-200 flex justify-center items-center"
              )
              onClick=deleteAll>
              <Formula__Icon.TrashLineRegular sizePx=16 classname=%twc("mr-[2px]") />
              {"전체 삭제"->React.string}
            </button>
            <button
              type_="button"
              className=%twc(
                "px-3 py-[6px] text-sm text-[#65666B] rounded-lg bg-[#F0F2F5] font-bold hover:bg-[#AEB0B5] active:bg-[#A7A9AF] ease-in-out duration-200 flex justify-center items-center"
              )
              onClick={_ => apply()->ignore}>
              {"완료"->React.string}
            </button>
          </div>
        </div>
        <PC_InterestedProduct_Edit_Droppable_List_Buyer
          interestedProducts=interestedProducts' setInterestedProducts
        />
        <div className=%twc("h-5 w-full") />
      </>
    }
  }
}

@react.component
let make = (~query) => {
  let {data: {likedProducts}, loadNext} = Fragment.usePagination(query)

  React.useEffect1(_ => {
    if likedProducts.edges->Array.length < likedProducts.totalCount {
      loadNext(~count=likedProducts.totalCount, ())->ignore
    }
    None
  }, [likedProducts])

  <Content likedProducts key={UniqueId.make(~prefix="interested-", ())} />
}
