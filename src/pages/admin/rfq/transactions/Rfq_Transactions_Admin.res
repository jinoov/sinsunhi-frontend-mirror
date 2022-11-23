module Query = %relay(`
  query RfqTransactionsAdminQuery(
    $buyerId: Int
    $first: Int!
    $offset: Int!
    $status: RfqWosDepositScheduleStatus
    $fromDate: DateTime!
    $toDate: DateTime!
    $factoring: Boolean
  ) {
    ...RfqTransactionsListAdminFragment
      @arguments(
        first: $first
        offset: $offset
        buyerId: $buyerId
        status: $status
        fromDate: $fromDate
        toDate: $toDate
        factoring: $factoring
      )
    rfqWosOrderDepositSchedules(
      buyerId: $buyerId
      status: $status
      offset: $offset
      first: $first
      fromDate: $fromDate
      toDate: $toDate
      factoring: $factoring
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
          <div className=%twc("flex gap-2")>
            <Box className=%twc("w-32") />
            <Box className=%twc("w-32") />
          </div>
        </div>
        <Rfq_Web_Orders_List_Admin.Skeleton />
      </section>
    }
  }
  let useSearchInput = (): RfqTransactionsAdminQuery_graphql.Types.variables => {
    let {query} = Next.Router.useRouter()

    let toStatus = s =>
      switch s {
      | "PENDING" => Some(#PENDING)
      | "DEPOSIT_COMPLETE" => Some(#DEPOSIT_COMPLETE)
      | "CANCEL" => Some(#CANCEL)
      | _ => None
      }
    let toFactoring = s =>
      switch s->Rfq_Transactions_Search_Form.isFactoring_decode {
      | Ok(decode) =>
        switch decode {
        | #Y => Some(true)
        | #N => Some(false)
        | #NOT_SELECTED => None
        }
      | Error(_) => None
      }

    {
      buyerId: query->Js.Dict.get("buyer-id")->Option.flatMap(Int.fromString),
      factoring: query
      ->Js.Dict.get("is-factoring")
      ->Option.flatMap(s => s->Js.Json.string->toFactoring),
      first: query->Js.Dict.get("limit")->Option.flatMap(Int.fromString)->Option.getWithDefault(25),
      status: query->Js.Dict.get("status")->Option.flatMap(toStatus),
      offset: query
      ->Js.Dict.get("offset")
      ->Option.flatMap(Int.fromString)
      ->Option.getWithDefault(0),
      fromDate: query
      ->Js.Dict.get("from")
      ->Option.mapWithDefault(
        Js.Date.make()->DateFns.setDate(1)->DateFns.startOfDay->Js.Date.toISOString,
        t => t->Js.Date.fromString->DateFns.startOfDay->Js.Date.toISOString,
      ),
      toDate: query
      ->Js.Dict.get("to")
      ->Option.mapWithDefault(
        Js.Date.make()->DateFns.lastDayOfMonth->DateFns.startOfDay->Js.Date.toISOString,
        t => t->Js.Date.fromString->DateFns.startOfDay->Js.Date.toISOString,
      ),
    }
  }

  @react.component
  let make = () => {
    let searchInput = useSearchInput()

    let {rfqWosOrderDepositSchedules, fragmentRefs} = Query.use(
      ~variables=searchInput,
      ~fetchPolicy=RescriptRelay.NetworkOnly,
      (),
    )

    <section
      className=%twc("flex flex-col gap-4 w-full p-7 bg-background rounded-sm min-w-[600px] ")>
      <div className=%twc("flex items-center justify-between")>
        <div>
          <span className=%twc("text-lg font-bold")> {"내역"->React.string} </span>
          <span className=%twc("text-primary ml-1")>
            {`${rfqWosOrderDepositSchedules.count->Int.toString}건`->React.string}
          </span>
        </div>
        <div className=%twc("flex gap-2 items-center")>
          <Select_CountPerPage className=%twc("interactable") />
          <Rfq_Transactions_Add_Schedule>
            <button
              type_="button" className=%twc("py-[5px] px-3 border border-primary rounded-lg ")>
              <span className=%twc("text-primary text-sm")>
                {"+ 결제스케쥴 추가"->React.string}
              </span>
            </button>
          </Rfq_Transactions_Add_Schedule>
        </div>
      </div>
      <Rfq_Transactions_List_Admin query=fragmentRefs />
    </section>
  }
}

type target = From | To
open Rfq_Transactions_Search_Form
module Summary = {
  @react.component
  let make = () => {
    let router = Next.Router.useRouter()
    let {pathname} = router

    let form = Form.use(~config={defaultValues: initial, mode: #onChange})

    let handleOnSubmit = (
      {buyerName, isFactoring, status, searchFromDate, searchToDate}: fields,
      _,
    ) => {
      router.query->Js.Dict.set(
        "buyer-id",
        switch buyerName {
        | Selected({value}) => value
        | NotSelected => ""
        },
      )
      router.query->Js.Dict.set("status", (status :> string))
      router.query->Js.Dict.set("is-factoring", (isFactoring :> string))
      router.query->Js.Dict.set("offset", "0")
      router.query->Js.Dict.set("from", searchFromDate->DateFns.format("yyyy-MM-dd"))
      router.query->Js.Dict.set("to", searchToDate->DateFns.format("yyyy-MM-dd"))

      let {makeWithDict, toString} = module(Webapi.Url.URLSearchParams)
      router->Next.Router.push(`${pathname}?${router.query->makeWithDict->toString}`)
    }

    <section className=%twc("p-7 bg-background rounded-sm min-w-[600px]")>
      <form onSubmit={form->Form.handleSubmit(handleOnSubmit)}>
        <div className=%twc("flex flex-col gap-5 bg-div-shape-L2 px-7 py-6 rounded-lg text-sm")>
          <div className=%twc("flex items-center gap-4 xl:gap-0")>
            <span className=%twc("min-w-fit font-bold xl:mr-16")> {"검색"->React.string} </span>
            <div className=%twc("flex flex-col xl:flex-row w-full gap-4 xl:gap-12")>
              <BuyerName.Input form />
              <Status.Input form />
            </div>
          </div>
          <div className=%twc("flex items-center gap-4 xl:gap-16")>
            <span className=%twc("min-w-fit font-bold")> {"기간"->React.string} </span>
            <Period.Input form />
            <IsFactoring.Input form />
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
          {"매칭 결제관리"->React.string}
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
  <RescriptReactErrorBoundary fallback={_ => <div> {j`에러 발생`->React.string} </div>}>
    <Authorization.Admin title={"관리자 매칭 결제관리"}>
      <Container />
    </Authorization.Admin>
  </RescriptReactErrorBoundary>
}
