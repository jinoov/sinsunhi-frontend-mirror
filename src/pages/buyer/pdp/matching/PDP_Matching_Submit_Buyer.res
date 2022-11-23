/*
  1. 컴포넌트 위치
  PDP > 매칭 상품 > 구매 신청하기 버튼
  
  2. 역할
  {인증}/{유저 롤} 등을 고려한 구매 신청하기 버튼을 제공합니다.
*/

module Fragment = %relay(`
  fragment PDPMatchingSubmitBuyer_fragment on MatchingProduct {
    productId: number
    displayName
    category {
      fullyQualifiedName {
        name
      }
    }
    ...PDPLikeButton_Fragment
  }
`)

module RequestQuotationGtm = {
  let make = (
    ~displayName,
    ~productId,
    ~category: PDPMatchingSubmitBuyer_fragment_graphql.Types.fragment_category,
  ) => {
    let categoryNames = category.fullyQualifiedName->Array.map(({name}) => name)
    {
      "event": "request_quotation", // 이벤트 타입: 견적 버튼 클릭 시
      "click_rfq_btn": {
        "item_type": `견적`, // 상품 유형
        "item_id": productId->Int.toString, // 상품 코드
        "item_name": displayName, // 상품명
        "item_category": categoryNames->Array.get(0)->Js.Nullable.fromOption, // 표준 카테고리 Depth 1
        "item_category2": categoryNames->Array.get(1)->Js.Nullable.fromOption, // 표준 카테고리 Depth 2
        "item_category3": categoryNames->Array.get(2)->Js.Nullable.fromOption, // 표준 카테고리 Depth 3
        "item_category4": categoryNames->Array.get(3)->Js.Nullable.fromOption, // 표준 카테고리 Depth 4
        "item_category5": categoryNames->Array.get(4)->Js.Nullable.fromOption, // 표준 카테고리 Depth 5
      },
    }
  }
}

module MO = {
  @react.component
  let make = (~setShowModal, ~selectedGroup, ~query) => {
    let buttonText = `최저가 견적받기`

    let {useRouter, pushObj} = module(Next.Router)
    let router = useRouter()
    let user = CustomHooks.User.Buyer.use2()

    let {productId, displayName, category, fragmentRefs} = query->Fragment.use

    let btnStyle = %twc("h-14 flex-1 rounded-xl bg-primary text-white text-lg font-bold")
    let disabledStyle = %twc("h-14 flex-1 rounded-xl bg-disabled-L2 text-white text-lg font-bold")

    <PDP_CTA_Container_Buyer query=fragmentRefs>
      {switch user {
      | Unknown =>
        <button disabled=true className=disabledStyle> {buttonText->React.string} </button>

      // 미인증
      | NotLoggedIn =>
        <button
          className=btnStyle
          onClick={_ => {
            setShowModal(._ => PDP_Matching_Modals_Buyer.Show(
              Unauthorized(`로그인 후에\n견적을 받으실 수 있습니다.`),
            ))
          }}>
          {buttonText->React.string}
        </button>

      | LoggedIn({role}) =>
        switch role {
        // 어드민 | 셀러
        | Admin | ExternalStaff | Seller =>
          <button disabled=true className=disabledStyle> {buttonText->React.string} </button>

        // 바이어
        | Buyer =>
          let onClick = _ => {
            RequestQuotationGtm.make(~productId, ~displayName, ~category)
            ->DataGtm.mergeUserIdUnsafe
            ->DataGtm.push

            router->pushObj({
              pathname: `/buyer/tradematch/buy/products/${productId->Int.toString}/apply`,
              query: Js.Dict.fromArray([("grade", selectedGroup)]),
            })
          }
          <button className=btnStyle onClick> {buttonText->React.string} </button>
        }
      }}
    </PDP_CTA_Container_Buyer>
  }
}
