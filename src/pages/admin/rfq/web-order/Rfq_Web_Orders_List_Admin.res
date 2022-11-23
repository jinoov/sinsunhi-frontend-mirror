module Fragment = %relay(`
  fragment RfqWebOrdersListAdminFragment on Query
  @argumentDefinitions(
    first: { type: "Int", defaultValue: 25 }
    offset: { type: "Int" }
    buyerId: { type: "Int" }
    rfqId: { type: "Int" }
  ) {
    rfqWosOrderProducts(
      first: $first
      offset: $offset
      buyerId: $buyerId
      rfqId: $rfqId
    ) {
      edges {
        node {
          id
          ...RfqWebOrderAdminFragment
        }
      }
      count
    }
  }
`)

module Skeleton = {
  @react.component
  let make = () => {
    open Skeleton
    <div>
      <Box className=%twc("w-full min-h-[48px]") />
      <div className=%twc("flex items-center justify-center w-full h-96")>
        {"로딩 중.."->React.string}
      </div>
    </div>
  }
}

module TableHeader = {
  module Column = {
    @react.component
    let make = (~label) =>
      <div className=%twc("h-full px-4 flex items-center whitespace-nowrap")>
        {label->React.string}
      </div>
  }
  @react.component
  let make = () => {
    <div className=%twc("grid grid-cols-8-admin-rfq-web-order bg-gray-100 text-gray-500 h-12")>
      <Column label="견적번호" />
      <Column label="견적상품번호" />
      <Column label="주문상품번호" />
      <Column label="품목/품종" />
      <Column label="총 견적금액" />
      <Column label="결제완료금액" />
      <Column label="잔액" />
      <Column label="바이어명" />
    </div>
  }
}

@react.component
let make = (~query) => {
  let router = Next.Router.useRouter()
  let {rfqWosOrderProducts} = query->Fragment.use

  let limit =
    router.query->Js.Dict.get("limit")->Option.flatMap(Int.fromString)->Option.getWithDefault(25)

  <>
    <div className=%twc("w-full overflow-x-scroll")>
      <div className=%twc("min-w-max max-w-full text-sm divide-y divide-gray-100")>
        <TableHeader />
        <ol
          className=%twc(
            "divide-y divide-gray-100 lg:list-height-admin-buyer lg:overflow-y-scroll"
          )>
          {rfqWosOrderProducts.edges
          ->Array.map(({node: {id, fragmentRefs}}) =>
            <Rfq_Web_Order_Admin key=id query=fragmentRefs />
          )
          ->React.array}
        </ol>
      </div>
    </div>
    <div className=%twc("flex justify-center pt-5")>
      React.null
      <Pagination
        pageDisplySize=Constants.pageDisplySize itemPerPage={limit} total=rfqWosOrderProducts.count
      />
    </div>
  </>
}
