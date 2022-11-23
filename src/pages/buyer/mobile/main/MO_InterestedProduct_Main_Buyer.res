@module("/public/assets/add-circle.svg")
external addCircle: string = "default"

module Query = %relay(`
  query MOInterestedProductMainBuyerQuery($cursor: String, $count: Int!) {
    viewer {
      ...MOInterestedProductListBuyerFragment
        @arguments(count: $count, cursor: $cursor)
      likedProducts(
        first: $count
        after: $cursor
        orderBy: [{field: RFQ_DISPLAY_ORDER, direction: ASC_NULLS_FIRST}, {field: LIKED_AT, direction: DESC}]
        types:[MATCHING]
      ) {
        totalCount
      }
    }
  }
`)

@react.component
let make = () => {
  let {viewer} = Query.use(
    ~variables={
      cursor: None,
      count: 20,
    },
    ~fetchPolicy=StoreAndNetwork,
    (),
  )
  <div>
    {switch viewer {
    | None =>
      <>
        <div className=%twc("py-3 px-4")>
          <h2 className=%twc("text-[19px] font-bold text-[#1F2024]")>
            {"관심 상품"->React.string}
          </h2>
        </div>
        <MO_Fallback_Buyer />
      </>
    | Some(viewer') =>
      <>
        {switch viewer'.likedProducts.totalCount {
        | 0 =>
          <div className=%twc("py-3 px-4 text-[19px] font-bold text-[#1F2024]")>
            <h2> {`관심 상품`->React.string} </h2>
            <div className=%twc("text-[13px] text-[#8B8D94] mt-3 font-normal")>
              {"추가한 상품의 정보를 알려드릴게요."->React.string}
            </div>
          </div>
        | n =>
          <div
            className=%twc(
              "py-3 px-4 text-[19px] font-bold flex items-center justify-between text-[#1F2024]"
            )>
            <h2> {`관심 상품(${n->Int.toString})`->React.string} </h2>
            <Next.Link href="/buyer/me/interested">
              <a className=%twc("font-normal text-primary interactable text-[15px]")>
                {"편집하기"->React.string}
              </a>
            </Next.Link>
          </div>
        }}
        <MO_InterestedProduct_List_Buyer.Partial
          query={viewer'.fragmentRefs} limit={5} empty={React.null}
        />
        <div className=%twc("py-4 px-4")>
          <Next.Link href="/buyer/me/interested/add">
            <a className=%twc("flex items-center w-full interactable")>
              <img src=addCircle className=%twc("w-11 h-11") alt="" />
              <span className=%twc("text-[#8B8D94] ml-[14px]")>
                {"추가하기"->React.string}
              </span>
            </a>
          </Next.Link>
        </div>
        {switch viewer'.likedProducts.totalCount {
        | i if i > 5 =>
          <div className=%twc("px-4")>
            <Next.Link href="/buyer/me/interested">
              <button
                type_="button"
                className=%twc(
                  "mt-4 rounded-lg py-2 text-center border border-[#DCDFE3] w-full interactable "
                )>
                {"더보기"->React.string}
              </button>
            </Next.Link>
          </div>
        | _ => React.null
        }}
      </>
    }}
  </div>
}
