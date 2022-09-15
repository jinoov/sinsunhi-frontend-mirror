module Fragment = %relay(`
  fragment PDPNormalRfqBtnBuyer_fragment on QuotableProduct {
    productId: number
    displayName
    salesType
    category {
      fullyQualifiedName {
        name
      }
    }
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
    ~category: PDPNormalRfqBtnBuyer_fragment_graphql.Types.fragment_category,
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

// 견적 가능 상태
type rfqStatus =
  | Loading // SSR
  | Unauthorized // 미인증
  | NoPermission // 바이어 계정이 아닌 사용자
  | Available(QuotationType.t) // 견적 가능 상태

module PC = {
  @react.component
  let make = (~query, ~setShowModal) => {
    let {useRouter, push} = module(Next.Router)
    let router = useRouter()
    let user = CustomHooks.User.Buyer.use2()
    let {productId, salesType, category, displayName} = query->Fragment.use

    let btnStyle = %twc(
      "mt-4 w-full h-16 rounded-xl bg-primary-light hover:bg-primary-light-variant text-primary text-lg font-bold hover:text-primary-variant"
    )

    let disabledStyle = %twc(
      "mt-4 w-full h-16 rounded-xl bg-disabled-L2 text-lg font-bold text-white"
    )

    let rfqStatus = {
      switch user {
      | Unknown => Loading
      | NotLoggedIn => Unauthorized
      | LoggedIn({role}) =>
        switch role {
        | Admin | Seller => NoPermission
        | Buyer =>
          Available(
            salesType->QuotationType.decode->Option.getWithDefault(QuotationType.RFQ_LIVESTOCK),
          )
        }
      }
    }

    switch rfqStatus {
    | Loading =>
      <button disabled=true className=disabledStyle>
        {`최저가 견적문의`->React.string}
      </button>

    | Unauthorized =>
      <button
        className=btnStyle
        onClick={_ => {
          setShowModal(._ => PDP_Normal_Modals_Buyer.Show(
            Unauthorized(`로그인 후에\n견적을 받으실 수 있습니다.`),
          ))
        }}>
        {`최저가 견적문의`->React.string}
      </button>

    | NoPermission =>
      <button disabled=true className=disabledStyle>
        {`최저가 견적문의`->React.string}
      </button>

    | Available(TRADEMATCH_AQUATIC) =>
      let onClick = _ => {
        RequestQuotationGtm.make(~productId, ~displayName, ~category)
        ->DataGtm.mergeUserIdUnsafe
        ->DataGtm.push
        router->push(`/buyer/tradematch/buy/products/${productId->Int.toString}/apply`)
      }
      <button className=btnStyle onClick> {`최저가 견적문의`->React.string} </button>

    | Available(RFQ_LIVESTOCK) =>
      let onClick = _ => {
        RequestQuotationGtm.make(~productId, ~displayName, ~category)
        ->DataGtm.mergeUserIdUnsafe
        ->DataGtm.push
        router->push(`/buyer/tradematch/buy/products/${productId->Int.toString}/apply`)
      }
      <div onClick>
        <RfqCreateRequestButton className=btnStyle buttonText={`최저가 견적문의`} />
      </div>
    }
  }
}

module MO = {
  @react.component
  let make = (~query, ~setShowModal) => {
    let {useRouter, push} = module(Next.Router)
    let router = useRouter()
    let user = CustomHooks.User.Buyer.use2()
    let {productId, salesType, displayName, category} = query->Fragment.use

    let btnStyle = %twc(
      "flex flex-1 items-center justify-center rounded-xl bg-white border border-primary text-primary text-lg font-bold"
    )
    let disabledStyle = %twc(
      "flex flex-1 items-center justify-center rounded-xl bg-disabled-L2 text-lg font-bold text-white"
    )

    let rfqStatus = {
      switch user {
      | Unknown => Loading
      | NotLoggedIn => Unauthorized

      | LoggedIn({role}) =>
        switch role {
        | Admin | Seller => NoPermission
        | Buyer =>
          Available(
            salesType->QuotationType.decode->Option.getWithDefault(QuotationType.RFQ_LIVESTOCK),
          )
        }
      }
    }

    switch rfqStatus {
    | Loading =>
      <button disabled=true className=disabledStyle>
        {`최저가 견적문의`->React.string}
      </button>

    | Unauthorized =>
      <>
        <button
          className=btnStyle
          onClick={_ => {
            setShowModal(._ => PDP_Normal_Modals_Buyer.Show(
              Unauthorized(`로그인 후에\n견적을 받으실 수 있습니다.`),
            ))
          }}>
          {`최저가 견적문의`->React.string}
        </button>
      </>

    | NoPermission =>
      <button disabled=true className=disabledStyle>
        {`최저가 견적문의`->React.string}
      </button>

    | Available(TRADEMATCH_AQUATIC) =>
      <>
        <button
          className=btnStyle
          onClick={_ => {
            RequestQuotationGtm.make(~productId, ~displayName, ~category)
            ->DataGtm.mergeUserIdUnsafe
            ->DataGtm.push
            router->push(`/buyer/tradematch/buy/products/${productId->Int.toString}/apply`)
          }}>
          {`최저가 견적문의`->React.string}
        </button>
      </>

    | Available(RFQ_LIVESTOCK) =>
      <RfqCreateRequestButton className=btnStyle buttonText={`최저가 견적문의`} />
    }
  }
}
