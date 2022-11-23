module Fragment = %relay(`
  fragment RfqTransactionsListAdminFragment on Query
  @argumentDefinitions(
    first: { type: "Int", defaultValue: 25 }
    offset: { type: "Int" }
    buyerId: { type: "Int" }
    status: { type: "RfqWosDepositScheduleStatus" }
    fromDate: { type: "DateTime" }
    toDate: { type: "DateTime" }
    factoring: { type: "Boolean" }
  ) {
    rfqWosOrderDepositSchedules(
      first: $first
      offset: $offset
      status: $status
      buyerId: $buyerId
      fromDate: $fromDate
      toDate: $toDate
      factoring: $factoring
    ) {
      edges {
        node {
          id
          ...RfqTransactionAdminFragment
        }
      }
      count
    }
  }
`)

module Column = {
  @react.component
  let make = (~label) =>
    <div className=%twc("h-full px-4 flex items-center whitespace-nowrap")>
      {label->React.string}
    </div>
}

@react.component
let make = (~query) => {
  let router = Next.Router.useRouter()
  let {rfqWosOrderDepositSchedules} = query->Fragment.use

  let limit =
    router.query->Js.Dict.get("limit")->Option.flatMap(Int.fromString)->Option.getWithDefault(25)

  <>
    <div className=%twc("w-full overflow-x-scroll")>
      <div className=%twc("min-w-max max-w-full text-sm divide-y divide-gray-100")>
        <div
          className=%twc("grid grid-cols-6-admin-rfq-transaction bg-gray-100 text-gray-500 h-12")>
          <Column label="바이어명" />
          <Column label="결제예정일" />
          <Column label="결제예정금액" />
          <Column label="결제스케쥴 관리" />
          <Column label="상태" />
        </div>
        <ol
          className=%twc(
            "divide-y divide-gray-100 lg:list-height-admin-buyer lg:overflow-y-scroll"
          )>
          {rfqWosOrderDepositSchedules.edges
          ->Array.map(({node: {id, fragmentRefs}}) =>
            <Rfq_Transaction_Admin key=id query=fragmentRefs />
          )
          ->React.array}
        </ol>
      </div>
    </div>
    <div className=%twc("flex justify-center pt-5")>
      React.null
      <Pagination
        pageDisplySize=Constants.pageDisplySize
        itemPerPage={limit}
        total=rfqWosOrderDepositSchedules.count
      />
    </div>
  </>
}
