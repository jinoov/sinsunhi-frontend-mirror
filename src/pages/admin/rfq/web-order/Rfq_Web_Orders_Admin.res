module Query = %relay(`
  query RfqWebOrdersAdminQuery(
    $first: Int!
    $offset: Int
    $buyerId: Int
    $rfqId: Int
  ) {
    ...RfqWebOrdersListAdminFragment
      @arguments(first: $first, offset: $offset, buyerId: $buyerId, rfqId: $rfqId)
    rfqWosOrderProducts(
      first: $first
      offset: $offset
      buyerId: $buyerId
      rfqId: $rfqId
    ) {
      count
    }
  }
`)

module List = {
  module Skeleton = {
    @react.component
    let make = () => {
      open Skeleton
      <section
        className=%twc("flex flex-col gap-4 w-full p-7 bg-background rounded-sm min-w-[500px] ")>
        <div className=%twc("flex items-center justify-between")>
          <Box className=%twc("w-16") />
          <Box className=%twc("w-32") />
        </div>
        <Rfq_Web_Orders_List_Admin.Skeleton />
      </section>
    }
  }
  let useSearchInput = (): RfqWebOrdersAdminQuery_graphql.Types.variables => {
    let {query} = Next.Router.useRouter()

    {
      first: query->Js.Dict.get("limit")->Option.flatMap(Int.fromString)->Option.getWithDefault(25),
      offset: query->Js.Dict.get("offset")->Option.flatMap(Int.fromString),
      buyerId: query->Js.Dict.get("buyer-id")->Option.flatMap(Int.fromString),
      rfqId: query->Js.Dict.get("rfq-number")->Option.flatMap(Int.fromString),
    }
  }
  @react.component
  let make = () => {
    let searchInput = useSearchInput()

    let {rfqWosOrderProducts, fragmentRefs} = Query.use(
      ~variables=searchInput,
      ~fetchPolicy=RescriptRelay.NetworkOnly,
      (),
    )

    <section
      className=%twc("flex flex-col gap-4 w-full p-7 bg-background rounded-sm min-w-[500px] ")>
      <div className=%twc("flex items-center justify-between")>
        <div>
          <span className=%twc("text-lg font-bold")> {"내역"->React.string} </span>
          <span className=%twc("text-primary ml-1")>
            {`${rfqWosOrderProducts.count->Int.toString}건`->React.string}
          </span>
        </div>
        <Select_CountPerPage className=%twc("interactable") />
      </div>
      <Rfq_Web_Orders_List_Admin query=fragmentRefs />
    </section>
  }
}

module Summary = {
  @react.component
  let make = () => {
    open Rfq_Web_Order_Search_Form
    let router = Next.Router.useRouter()
    let {query, pathname} = router

    let form = Form.use(~config={defaultValues: initial, mode: #onChange})

    let handleOnSubmit = ({selectedBuyer, rfqNumber}: fields, _) => {
      switch selectedBuyer {
      | Selected({value}) => query->Js.Dict.set("buyer-id", value)
      | NotSelected => query->Js.Dict.set("buyer-id", "")
      }
      query->Js.Dict.set("rfq-number", rfqNumber)
      query->Js.Dict.set("offset", "0")

      let {makeWithDict, toString} = module(Webapi.Url.URLSearchParams)
      router->Next.Router.push(`${pathname}?${query->makeWithDict->toString}`)
    }

    <section className=%twc("p-7 bg-background rounded-sm min-w-[500px]")>
      <form onSubmit={form->Form.handleSubmit(handleOnSubmit)}>
        <div className=%twc("bg-div-shape-L2 px-7 py-6 rounded-lg text-sm")>
          <div className=%twc("flex items-center gap-4 xl:gap-0")>
            <span className=%twc("min-w-fit font-bold xl:mr-16")> {"검색"->React.string} </span>
            <div className=%twc("flex flex-col xl:flex-row w-full gap-4 xl:gap-12")>
              <SelectedBuyer.Input form />
              <RfqNumber.Input form />
            </div>
          </div>
        </div>
        <div className=%twc("w-full mt-6 flex justify-center items-center gap-2.5")>
          <button
            type_="button"
            onClick={_ => form->Form.reset(initial)}
            className=%twc("bg-div-shape-L1 rounded-lg px-3 py-2 min-w-fit interactable")>
            {"초기화"->React.string}
          </button>
          <button
            className=%twc("bg-primary text-white rounded-lg px-4 py-2 min-w-fit interactable")>
            {"검색"->React.string}
          </button>
        </div>
      </form>
    </section>
  }
}

module Container = {
  @react.component
  let make = () => {
    <div
      className=%twc(
        "flex flex-col gap-4 max-w-gnb-panel overflow-auto overflow-x-scroll bg-div-shape-L1 min-h-screen pt-10 pb-16 pl-5 pr-20"
      )>
      <header className=%twc("flex items-baseline")>
        <h1 className=%twc("text-text-L1 text-xl font-bold min-w-max")>
          {"매칭 주문관리"->React.string}
        </h1>
      </header>
      <Summary />
      <React.Suspense fallback={<List.Skeleton />}>
        <List />
      </React.Suspense>
    </div>
  }
}

@react.component
let make = () => {
  <>
    <Next.Script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js" />
    <RescriptReactErrorBoundary fallback={_ => <div> {j`에러 발생`->React.string} </div>}>
      <Authorization.Admin title={"관리자 매칭 주문관리"}>
        <Container />
      </Authorization.Admin>
    </RescriptReactErrorBoundary>
  </>
}
