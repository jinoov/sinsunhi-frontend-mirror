module Query = %relay(`
  query RfqPurchasesAdminQuery(
    $limit: Int!
    $offset: Int
    $mdName: String
    $productName: String
    $from: DateTime
    $to: DateTime
    $status: RfqProductStatus
    $categoryId: ID
    $sort: RfqProductSort
  ) {
    ...RfqPurchasesListAdminFragment
      @arguments(
        limit: $limit
        offset: $offset
        mdName: $mdName
        productName: $productName
        from: $from
        to: $to
        status: $status
        categoryId: $categoryId
        sort: $sort
      )
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
      totalCount
    }
  }
`)

module Content = {
  module Head = {
    @react.component
    let make = (~totalCount) => {
      <div className=%twc("flex items-center justify-between")>
        <h3 className=%twc("font-bold")>
          {`내역`->React.string}
          <span className=%twc("ml-1 text-green-gl font-normal")>
            {`${totalCount->Int.toString}건`->React.string}
          </span>
        </h3>
        <div className=%twc("flex items-center")>
          <Rfq_Select_OrderBy_Admin className=%twc("mr-2") />
          <Select_CountPerPage className=%twc("mr-2") />
          <Add_Rfq_Button_Admin />
        </div>
      </div>
    }
  }

  let isNonEmptyStr = str => str != ""
  let today = Js.Date.make()
  let weekAgo = today->DateFns.subDays(7)

  @react.component
  let make = () => {
    let router = Next.Router.useRouter()
    let limit =
      router.query
      ->Js.Dict.get("limit")
      ->Option.flatMap(limit' => limit'->Int.fromString)
      ->Option.getWithDefault(25)

    let offset =
      router.query
      ->Js.Dict.get("offset")
      ->Option.flatMap(offset' => offset'->Int.fromString)
      ->Option.getWithDefault(0)

    let mdName =
      router.query
      ->Js.Dict.get("manager-name")
      ->Option.map(Js.Global.decodeURIComponent)
      ->Option.keep(isNonEmptyStr)

    let productName =
      router.query
      ->Js.Dict.get("product-name")
      ->Option.map(Js.Global.decodeURIComponent)
      ->Option.keep(isNonEmptyStr)

    let fromDate =
      router.query
      ->Js.Dict.get("from")
      ->Option.map(Js.Global.decodeURIComponent)
      ->Option.mapWithDefault(weekAgo, Js.Date.fromString)
      ->DateFns.startOfDay
      ->Js.Date.toISOString

    let toDate =
      router.query
      ->Js.Dict.get("to")
      ->Option.map(Js.Global.decodeURIComponent)
      ->Option.mapWithDefault(today, Js.Date.fromString)
      ->DateFns.endOfDay
      ->Js.Date.toISOString

    let status =
      router.query
      ->Js.Dict.get("status")
      ->Option.flatMap(Rfq_Purchases_Filter_Admin.Form.Status.toValue)
      ->Option.flatMap(s =>
        switch s {
        | #WAIT => #WAIT->Some
        | #SOURCING => #SOURCING->Some
        | #SOURCED => #SOURCED->Some
        | #SOURCING_FAIL => #SOURCING_FAIL->Some
        | #COMPLETE => #COMPLETE->Some
        | #MATCHING => #MATCHING->Some
        | #FAIL => #FAIL->Some
        | _ => None
        }
      )

    let categoryId = router.query->Js.Dict.get("category-id")

    let sort = router.query->Js.Dict.get("sort")->Option.flatMap(Rfq_Select_OrderBy_Admin.toValue)

    let {fragmentRefs, rfqProducts: {totalCount}} = Query.use(
      ~variables=Query.makeVariables(
        ~limit,
        ~offset,
        ~mdName?,
        ~productName?,
        ~from={fromDate},
        ~to={toDate},
        ~status?,
        ~categoryId?,
        ~sort?,
        (),
      ),
      (),
    )

    <div className=%twc("p-7 w-full bg-white rounded-sm text-text-L1")>
      <Head totalCount />
      <section className=%twc("mt-5")>
        <Rfq_Purchases_List_Admin query=fragmentRefs />
      </section>
    </div>
  }
}

module Page = {
  @react.component
  let make = () => {
    <main className=%twc("p-5 min-w-[1080px] min-h-full bg-gray-100")>
      <h1 className=%twc("mt-5 text-xl text-text-L1 font-bold")>
        {`구매 신청 조회`->React.string}
      </h1>
      <section className=%twc("mt-4")>
        <div className=%twc("p-7 w-full bg-white rounded-sm text-text-L1")>
          <React.Suspense fallback={<Rfq_Purchases_Tabs_Admin.Skeleton />}>
            <Rfq_Purchases_Tabs_Admin />
          </React.Suspense>
          <Rfq_Purchases_Filter_Admin />
        </div>
      </section>
      <section className=%twc("mt-4")>
        <Content />
      </section>
    </main>
  }
}

@react.component
let make = () => {
  <Authorization.Admin title={`관리자 구매 신청 조회`}>
    <RescriptReactErrorBoundary fallback={_ => `에러`->React.string}>
      <React.Suspense fallback={React.null}>
        <Page />
      </React.Suspense>
    </RescriptReactErrorBoundary>
  </Authorization.Admin>
}
