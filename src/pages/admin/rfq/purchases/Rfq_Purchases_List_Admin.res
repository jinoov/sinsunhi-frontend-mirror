module Style = {
  let grid = %twc("grid grid-cols-[120px_80px_170px_170px_170px_120px_150px_120px_150px]")
  let column = %twc("h-full px-4 flex items-center")
}

module Parser = {
  module AmountUnit = {
    let toLabel = v => {
      switch v {
      | #G => "g"
      | #KG => "kg"
      | #T => "t"
      | #ML => "ml"
      | #L => "l"
      | #EA => "ea"
      | _ => ""
      }
    }
  }

  module Department = {
    type t =
      | Agriculture // 농산
      | Meat // 축산
      | Seafood // 수산

    let fromCategoryName = name => {
      if name == `농산물` {
        Agriculture->Some
      } else if name == `축산물` {
        Meat->Some
      } else if name == `수산물/건수산` {
        Seafood->Some
      } else {
        None
      }
    }

    let toLabel = department => {
      switch department {
      | Agriculture => `농산`
      | Meat => `축산`
      | Seafood => `수산`
      }
    }
  }
}

module Head = {
  @react.component
  let make = () => {
    <div className={cx([Style.grid, %twc("bg-gray-100 text-gray-500 h-12")])}>
      <div className=Style.column> {`견적번호`->React.string} </div>
      <div className=Style.column> {`사업부`->React.string} </div>
      <div className=Style.column> {`품목/품종`->React.string} </div>
      <div className=Style.column> {`구매자`->React.string} </div>
      <div className=Style.column> {`판매자`->React.string} </div>
      <div className=Style.column> {`구매 요청량`->React.string} </div>
      <div className=Style.column> {`금액`->React.string} </div>
      <div className=Style.column> {`진행상태`->React.string} </div>
      <div className=Style.column> {`신청날짜`->React.string} </div>
    </div>
  }
}

module StatusTag = {
  @react.component
  let make = (~status) => {
    let base = %twc("px-2 h-6 flex items-center justify-center rounded-lg text-[15px]")
    switch status {
    | #WAIT =>
      <div className={cx([base, %twc("bg-[#F7F8FA] text-[#65666B]")])}>
        {`컨택 대기`->React.string}
      </div>
    | #SOURCING =>
      <div className={cx([base, %twc("bg-[#EDFAF2] text-[#009454]")])}>
        {`소싱 진행`->React.string}
      </div>
    | #SOURCED =>
      <div className={cx([base, %twc("bg-[#EDFAF2] text-[#009454]")])}>
        {`소싱 성공`->React.string}
      </div>
    | #SOURCING_FAIL =>
      <div className={cx([base, %twc("bg-[#FAE8E9] text-[#CF1124]")])}>
        {`소싱 실패`->React.string}
      </div>
    | #MATCHING =>
      <div className={cx([base, %twc("bg-[#EDFAF2] text-[#009454]")])}>
        {`매칭 진행`->React.string}
      </div>
    | #COMPLETE =>
      <div className={cx([base, %twc("bg-[#EDFAF2] text-[#009454]")])}>
        {`매칭 성공`->React.string}
      </div>
    | #FAIL =>
      <div className={cx([base, %twc("bg-[#FAE8E9] text-[#CF1124]")])}>
        {`매칭 실패`->React.string}
      </div>
    | _ => React.null
    }
  }
}

module ListItem = {
  module Fragment = %relay(`
    fragment RfqPurchasesListAdminListItemFragment on RfqProduct {
      rfq {
        number
        buyer {
          name
        }
      }
      category {
        fullyQualifiedName {
          name
        }
      }
      seller {
        name
      }
      amount
      amountUnit
      price
      status
      createdAt
    }
  `)

  @react.component
  let make = (~query) => {
    let {rfq, category, amount, amountUnit, price, status, createdAt, seller} = query->Fragment.use

    let rfqId = rfq.number->Int.toString
    let rfqIdLabel = (`000000` ++ rfqId)->Js.String2.sliceToEnd(~from=-6)

    let department = {
      category.fullyQualifiedName
      ->Array.get(0)
      ->Option.flatMap(({name}) => name->Parser.Department.fromCategoryName)
    }

    let itemKind = {
      // 품목/품종 레이블은
      // 축산은 카테고리 2/5뎁스
      // 그 외 카테고리 4/5뎁스로 구성된다.
      switch department {
      | Some(Meat) => [
          category.fullyQualifiedName->Array.get(1)->Option.mapWithDefault("", ({name}) => name),
          category.fullyQualifiedName->Array.get(4)->Option.mapWithDefault("", ({name}) => name),
        ]

      | _ => [
          category.fullyQualifiedName->Array.get(3)->Option.mapWithDefault("", ({name}) => name),
          category.fullyQualifiedName->Array.get(4)->Option.mapWithDefault("", ({name}) => name),
        ]
      }->Js.Array2.joinWith("/")
    }

    let buyerName = rfq.buyer->Option.map(({name}) => name)
    let sellerName = seller->Option.map(({name}) => name)

    <li className={cx([Style.grid, %twc("h-12")])}>
      <span className=Style.column>
        <Next.Link href={`/admin/matching/purchases/${rfqId}`}>
          <a className={%twc("text-[#3B6DE3] underline")}> {rfqIdLabel->React.string} </a>
        </Next.Link>
      </span>
      <span className=Style.column>
        {department->Option.mapWithDefault("-", Parser.Department.toLabel)->React.string}
      </span>
      <span className={cx([Style.column, %twc("whitespace-pre-wrap break-all")])}>
        {itemKind->React.string}
      </span>
      <span className={cx([Style.column, %twc("whitespace-pre-wrap break-all")])}>
        {buyerName->Option.getWithDefault("-")->React.string}
      </span>
      <span className={cx([Style.column, %twc("whitespace-pre-wrap break-all")])}>
        {sellerName->Option.getWithDefault("-")->React.string}
      </span>
      <span className=Style.column>
        {`${amount->Float.toString}${amountUnit->Parser.AmountUnit.toLabel}`->React.string}
      </span>
      <span className=Style.column>
        {`${price->Locale.Float.show(~digits=0)}원`->React.string}
      </span>
      <span className=Style.column>
        <StatusTag status />
      </span>
      <span className=Style.column>
        {createdAt->Js.Date.fromString->DateFns.format("yyyy/MM/dd HH:mm")->React.string}
      </span>
    </li>
  }
}

module Empty = {
  @react.component
  let make = () => {
    <div
      className=%twc(
        "min-w-max min-h-[280px] flex items-center justify-center text-[#8B8D94] text-sm"
      )>
      {`조건에 맞는 구매 신청 내역이 없습니다.`->React.string}
    </div>
  }
}

module Fragment = %relay(`
  fragment RfqPurchasesListAdminFragment on Query
  @argumentDefinitions(
    limit: { type: "Int", defaultValue: 25 }
    offset: { type: "Int" }
    mdName: { type: "String" }
    productName: { type: "String" }
    from: { type: "DateTime" }
    to: { type: "DateTime" }
    status: { type: "RfqProductStatus" }
    categoryId: { type: "ID" }
    sort: { type: "RfqProductSort" }
  ) {
    rfqProducts(
      first: $limit
      offset: $offset
      mdName: $mdName
      productName: $productName
      from: $from
      to: $to
      status: $status
      categoryId: $categoryId
      sort: $sort
    ) {
      edges {
        node {
          id
          ...RfqPurchasesListAdminListItemFragment
        }
      }
      totalCount
    }
  }
`)

@react.component
let make = (~query) => {
  let router = Next.Router.useRouter()
  let limit = {
    router.query->Js.Dict.get("limit")->Option.flatMap(Int.fromString)->Option.getWithDefault(25)
  }

  let {rfqProducts} = query->Fragment.use

  switch rfqProducts.edges {
  | [] => <Empty />
  | nonEmptyEdges =>
    <div className=%twc("w-full")>
      <div className=%twc("w-full overflow-x-scroll")>
        <div className=%twc("min-w-max text-sm divide-y divide-gray-100 pb-3")>
          <Head />
          <ol className=%twc("divide-y divide-gray-100")>
            {nonEmptyEdges
            ->Array.map(({node: {id, fragmentRefs}}) => {
              <ListItem key=id query=fragmentRefs />
            })
            ->React.array}
          </ol>
        </div>
      </div>
      <div className=%twc("flex justify-center pt-5")>
        <Pagination
          pageDisplySize=Constants.pageDisplySize itemPerPage=limit total=rfqProducts.totalCount
        />
      </div>
    </div>
  }
}
