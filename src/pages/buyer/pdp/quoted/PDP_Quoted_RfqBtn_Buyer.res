/*
  1. 컴포넌트 위치
  PDP > 견적 상품 > 최저가 견적받기 버튼
  
  2. 역할
  {인증}/{유저 롤} 등을 고려한 최저가 견적받기 버튼을 제공합니다.
*/

module Fragment = %relay(`
  fragment PDPQuotedRfqBtnBuyer_fragment on QuotedProduct {
    productId: number
    salesType
    displayName
    category {
      fullyQualifiedName {
        name
      }
    }
    ...PDPLikeButton_Fragment
  }
`)

module QuotationType = {
  type t =
    | RFQ_LIVESTOCK // 축산
    | TRADEMATCH_AQUATIC // 수산

  let decode = v => {
    switch v {
    | #RFQ_LIVESTOCK => RFQ_LIVESTOCK->Some
    | #TRADEMATCH_AQUATIC => TRADEMATCH_AQUATIC->Some
    | _ => None
    }
  }

  let encode = v => {
    switch v {
    | RFQ_LIVESTOCK => #RFQ_LIVESTOCK
    | TRADEMATCH_AQUATIC => #TRADEMATCH_AQUATIC
    }
  }
}

module RequestQuotationGtm = {
  let make = (
    ~displayName,
    ~productId,
    ~category: PDPQuotedRfqBtnBuyer_fragment_graphql.Types.fragment_category,
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

type rfqStatus =
  | Loading // SSR
  | Unauthorized // 미인증
  | NoPermission // 바이어 롤이 아닌 사용자
  | Available(QuotationType.t) // 견적요청 가능

module PC = {
  @react.component
  let make = (~setShowModal, ~query) => {
    let {useRouter, push} = module(Next.Router)
    let router = useRouter()

    let user = CustomHooks.User.Buyer.use2()
    let {productId, salesType, displayName, category} = query->Fragment.use

    let rfqStatus = {
      switch user {
      | Unknown => Loading
      | NotLoggedIn => Unauthorized
      | LoggedIn({role}) =>
        switch role {
        | Admin | ExternalStaff | Seller => NoPermission
        | Buyer => Available(salesType->QuotationType.decode->Option.getWithDefault(RFQ_LIVESTOCK))
        }
      }
    }

    let btnStyle = %twc(
      "w-full h-16 rounded-xl bg-primary hover:bg-primary-variant text-white text-lg font-bold flex-1"
    )
    let disabledStyle = %twc(
      "w-full h-16 rounded-xl flex items-center justify-center bg-gray-300 text-white font-bold text-xl flex-1"
    )

    switch rfqStatus {
    // SSR
    | Loading =>
      <button disabled=true className=disabledStyle>
        {`최저가 견적받기`->React.string}
      </button>

    // 미인증
    | Unauthorized =>
      <button
        className=btnStyle
        onClick={_ => setShowModal(._ => PDP_Quoted_Modals_Buyer.Show(Unauthorized))}>
        {`최저가 견적받기`->React.string}
      </button>

    // 바이어 롤이 아닌 사용자
    | NoPermission =>
      <button disabled=true className=disabledStyle>
        {`최저가 견적받기`->React.string}
      </button>

    // 견적요청 가능 (수산)
    | Available(TRADEMATCH_AQUATIC) =>
      <button
        className=btnStyle
        onClick={_ => {
          RequestQuotationGtm.make(~productId, ~displayName, ~category)
          ->DataGtm.mergeUserIdUnsafe
          ->DataGtm.push
          router->push(`/buyer/tradematch/buy/products/${productId->Int.toString}/apply`)
        }}>
        {`최저가 견적받기`->React.string}
      </button>

    // 견적요청 가능 (축산)
    | Available(RFQ_LIVESTOCK) =>
      <div
        onClick={_ =>
          RequestQuotationGtm.make(~productId, ~displayName, ~category)
          ->DataGtm.mergeUserIdUnsafe
          ->DataGtm.push} className=%twc("flex-1")>
        <RfqCreateRequestButton className=btnStyle buttonText={`최저가 견적받기`} />
      </div>
    }
  }
}

module MO = {
  @react.component
  let make = (~setShowModal, ~query) => {
    let {useRouter, push} = module(Next.Router)
    let router = useRouter()

    let user = CustomHooks.User.Buyer.use2()
    let {productId, salesType, displayName, category, fragmentRefs} = query->Fragment.use

    let rfqStatus = {
      switch user {
      | Unknown => Loading
      | NotLoggedIn => Unauthorized
      | LoggedIn({role}) =>
        switch role {
        | Admin | ExternalStaff | Seller => NoPermission
        | Buyer => Available(salesType->QuotationType.decode->Option.getWithDefault(RFQ_LIVESTOCK))
        }
      }
    }

    let btnStyle = %twc("h-14 flex-1 rounded-xl bg-primary text-white text-lg font-bold")
    let disabledStyle = %twc("h-14 flex-1 rounded-xl bg-disabled-L2 text-white text-lg font-bold")

    switch rfqStatus {
    // SSR
    | Loading =>
      <button disabled=true className=disabledStyle>
        {`최저가 견적받기`->React.string}
      </button>

    // 미인증
    | Unauthorized =>
      <>
        <button
          className=btnStyle
          onClick={_ => setShowModal(._ => PDP_Quoted_Modals_Buyer.Show(Unauthorized))}>
          {`최저가 견적받기`->React.string}
        </button>
        <PDP_CTA_Container_Buyer query=fragmentRefs>
          <button
            className=btnStyle
            onClick={_ => setShowModal(._ => PDP_Quoted_Modals_Buyer.Show(Unauthorized))}>
            {`최저가 견적받기`->React.string}
          </button>
        </PDP_CTA_Container_Buyer>
      </>

    // 바이어 롤이 아닌 사용자
    | NoPermission =>
      <>
        <button disabled=true className=disabledStyle>
          {`최저가 견적받기`->React.string}
        </button>
        <PDP_CTA_Container_Buyer query=fragmentRefs>
          <button disabled=true className=disabledStyle>
            {`최저가 견적받기`->React.string}
          </button>
        </PDP_CTA_Container_Buyer>
      </>

    // 견적요청 가능 (수산)
    | Available(TRADEMATCH_AQUATIC) =>
      let onClick = _ => {
        RequestQuotationGtm.make(~productId, ~displayName, ~category)
        ->DataGtm.mergeUserIdUnsafe
        ->DataGtm.push
        router->push(`/buyer/tradematch/buy/products/${productId->Int.toString}/apply`)
      }
      <>
        <button className=btnStyle onClick> {`최저가 견적받기`->React.string} </button>
        <PDP_CTA_Container_Buyer query=fragmentRefs>
          <button className=btnStyle onClick> {`최저가 견적받기`->React.string} </button>
        </PDP_CTA_Container_Buyer>
      </>

    // 견적요청 가능 (축산)
    | Available(RFQ_LIVESTOCK) =>
      let onClick = _ => {
        RequestQuotationGtm.make(~productId, ~displayName, ~category)
        ->DataGtm.mergeUserIdUnsafe
        ->DataGtm.push
      }
      <>
        <div onClick>
          <RfqCreateRequestButton className=btnStyle buttonText={`최저가 견적받기`} />
        </div>
        <PDP_CTA_Container_Buyer query=fragmentRefs>
          <div className=%twc("w-full flex flex-1") onClick>
            <RfqCreateRequestButton className=btnStyle buttonText={`최저가 견적받기`} />
          </div>
        </PDP_CTA_Container_Buyer>
      </>
    }
  }
}
