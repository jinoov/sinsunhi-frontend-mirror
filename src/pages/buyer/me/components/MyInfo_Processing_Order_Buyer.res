module Fragment = %relay(`
  fragment MyInfoProcessingOrderBuyer_Fragment on User
  @argumentDefinitions(from: { type: "String!" }, to: { type: "String!" }) {
    orderProductCountByStatus(from: $from, to: $to) {
      count
      status
    }
  }
`)

type status = {
  create: int,
  ready: int,
  delivering: int,
  complete: int,
}

let initStatus = {
  create: 0,
  ready: 0,
  delivering: 0,
  complete: 0,
}

let useStatus = (query: RescriptRelay.fragmentRefs<[> #MyInfoProcessingOrderBuyer_Fragment]>) => {
  let {orderProductCountByStatus: orderStatus} = Fragment.use(query)

  let status = orderStatus->Array.reduce(initStatus, (acc, i) => {
    switch i {
    | {count, status: #CREATE} => {...acc, create: acc.create + count}
    | {count, status: #NEGOTIATING} => {...acc, create: acc.create + count}
    | {count, status: #PACKING} => {...acc, ready: acc.ready + count}
    | {count, status: #DEPARTURE} => {...acc, ready: acc.ready + count}
    | {count, status: #DELIVERING} => {...acc, delivering: acc.delivering + count}
    | {count, status: #COMPLETE} => {...acc, complete: acc.complete + count}
    | {count: _, status: #REFUND}
    | {count: _, status: #CANCEL}
    | _ => acc
    }
  })

  status
}

module PC = {
  @react.component
  let make = (~query) => {
    let status = useStatus(query)

    <div className=%twc("flex flex-col p-6")>
      <div className=%twc("flex items-center justify-between")>
        <div>
          <span className=%twc("font-bold text-2xl")> {`주문내역`->React.string} </span>
          <span className=%twc("ml-1 text-sm text-text-L3")>
            {`(최근 1개월)`->React.string}
          </span>
        </div>
        <Next.Link href="/buyer/orders">
          <a>
            <span className=%twc("text-sm mr-1")> {`더보기`->React.string} </span>
            <IconArrow height="13" width="13" fill="#262626" className=%twc("inline") />
          </a>
        </Next.Link>
      </div>
      <div className=%twc("pt-8 flex divide-x")>
        <div
          className=%twc(
            "px-5 first:pl-4 last:pr-4 text-center flex-1 word-keep-all flex flex-col justify-around"
          )>
          <div className=%twc("text-gray-600 text-sm")> {`신규 주문`->React.string} </div>
          <div className=%twc("font-bold text-lg")>
            {status.create->Int.toString->React.string}
          </div>
        </div>
        <div
          className=%twc(
            "px-5 first:pl-4 last:pr-4 text-center flex-1 word-keep-all flex flex-col justify-around"
          )>
          <div className=%twc("text-gray-600 text-sm")> {`상품 준비중`->React.string} </div>
          <div className=%twc("font-bold text-lg")>
            {status.ready->Int.toString->React.string}
          </div>
        </div>
        <div
          className=%twc(
            "px-5 first:pl-4 last:pr-4 text-center flex-1 word-keep-all flex flex-col justify-around"
          )>
          <div className=%twc("text-gray-600 text-sm")> {`배송중`->React.string} </div>
          <div className=%twc("font-bold text-lg")>
            {status.delivering->Int.toString->React.string}
          </div>
        </div>
        <div
          className=%twc(
            "px-5 first:pl-4 last:pr-4 text-center flex-1 word-keep-all flex flex-col justify-around"
          )>
          <div className=%twc("text-gray-600 text-sm")> {`배송 완료`->React.string} </div>
          <div className=%twc("font-bold text-lg")>
            {status.complete->Int.toString->React.string}
          </div>
        </div>
      </div>
    </div>
  }
}
module Mobile = {
  @react.component
  let make = (~query) => {
    let status = useStatus(query)

    <div>
      <div className=%twc("mb-4 flex items-center justify-between")>
        <div>
          <span className=%twc("font-bold text-lg")> {`진행중인 주문`->React.string} </span>
          <span className=%twc("ml-1 text-sm text-text-L3")>
            {`(최근 1개월)`->React.string}
          </span>
        </div>
        <Next.Link href="/buyer/orders">
          <a>
            <span className=%twc("text-sm mr-1")> {`더보기`->React.string} </span>
            <IconArrow height="10" width="10" fill="#262626" className=%twc("inline") />
          </a>
        </Next.Link>
      </div>
      <div className=%twc("mb-4 flex")>
        <div className=%twc(" text-center flex-1 word-keep-all flex flex-col justify-around")>
          <div className=%twc("text-gray-600 text-sm")> {`신규 주문`->React.string} </div>
          <div className=%twc("font-bold text-lg")>
            {status.create->Int.toString->React.string}
          </div>
        </div>
        <div className=%twc("border-l border-gray-100 py-[10px] my-1") />
        <div className=%twc(" text-center flex-1 word-keep-all flex flex-col justify-around")>
          <div className=%twc("text-gray-600 text-sm")> {`상품 준비중`->React.string} </div>
          <div className=%twc("font-bold text-lg")>
            {status.ready->Int.toString->React.string}
          </div>
        </div>
        <div className=%twc("border-l border-gray-100 py-[10px] my-1") />
        <div className=%twc(" text-center flex-1 word-keep-all flex flex-col justify-around")>
          <div className=%twc("text-gray-600 text-sm")> {`배송중`->React.string} </div>
          <div className=%twc("font-bold text-lg")>
            {status.delivering->Int.toString->React.string}
          </div>
        </div>
        <div className=%twc("border-l border-gray-100 py-[10px] my-1") />
        <div className=%twc(" text-center flex-1 word-keep-all flex flex-col justify-around")>
          <div className=%twc("text-gray-600 text-sm")> {`배송 완료`->React.string} </div>
          <div className=%twc("font-bold text-lg")>
            {status.complete->Int.toString->React.string}
          </div>
        </div>
      </div>
    </div>
  }
}
