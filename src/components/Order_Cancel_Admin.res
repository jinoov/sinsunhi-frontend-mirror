module Query = %relay(`
  query OrderCancelAdmin_Query($orderNo: String!, $orderProductNo: String) {
    wosOrder(
      orderNo: $orderNo
      orderProductNo: $orderProductNo
      wosOrderEventLogTypes: [PRODUCT_CANCELED]
    ) {
      createUserId
      eventLogs {
        createdAt
        eventType
        detailJson
      }
    }
  }
`)

@spice
type auth = {
  id: int,
  email: option<string>,
  name: option<string>,
}

@spice
type reasonType =
  | @spice.as("DELIVERY_NOT_POSSIBLE") DELIVERY_NOT_POSSIBLE
  | @spice.as("DELIVERY_ACCIDENT") DELIVERY_ACCIDENT
  | @spice.as("DELIVERY_DELAY") DELIVERY_DELAY
  | @spice.as("CHANGED_MIND") CHANGED_MIND
  | @spice.as("PRODUCT_SOLDOUT") PRODUCT_SOLDOUT
  | @spice.as("DUPLICATED_ORDER") DUPLICATED_ORDER
  | @spice.as("ETC") ETC

let toString = r =>
  switch r {
  | DELIVERY_NOT_POSSIBLE => "배송불가"
  | DELIVERY_ACCIDENT => "배송사고"
  | DELIVERY_DELAY => "배송지연"
  | CHANGED_MIND => "단순변심"
  | PRODUCT_SOLDOUT => "상품품절"
  | DUPLICATED_ORDER => "중복주문"
  | ETC => "기타"
  }

@spice
type reason = {
  email: string,
  @spice.key("reason_type") reasonType: option<reasonType>,
  @spice.key("reason_desc") reasonDesc: option<string>,
}

@spice
type detail = {
  auth: option<auth>,
  reason: option<reason>,
}

@spice
type detailJson = {detail: detail}

type wosOder = {
  eventType: RelaySchemaAssets_graphql.enum_WosOrderEventLogType,
  createdAt: string,
  detailJson: detailJson,
}

@react.component
let make = (~orderNo, ~orderProductNo) => {
  let {wosOrder} = Query.use(
    ~variables={
      orderNo,
      orderProductNo,
    },
    (),
  )

  let decoded =
    wosOrder
    ->Option.flatMap(wosOrder' =>
      // 취소 eventLogs는 [ 1-log ] | [] 라는 가정이 있습니다.
      // 추후 부분취소 같은 여러번의 취소를 로그로 갖게되는 경우 기획에 맞게 수정되어야 합니다.
      wosOrder'.eventLogs->Array.keepMap(Garter_Fn.identity)->Array.get(0)
    )
    ->Option.flatMap(log => {
      let json = switch log.detailJson {
      | Some(detailJson) =>
        try {
          detailJson->Js.Json.parseExn
        } catch {
        | _ => failwith("Expected an object")
        }
      | None => Js.Json.null
      }
      switch json->detailJson_decode {
      | Ok(decode) =>
        Some({
          eventType: log.eventType,
          detailJson: decode,
          createdAt: log.createdAt,
        })
      | Error(_) => None
      }
    })

  switch decoded {
  | Some(cancelOrder) =>
    let {detailJson: {detail: {auth, reason}}, createdAt} = cancelOrder

    <>
      <h3 className=%twc("mt-10 font-bold")> {j`주문취소 정보`->React.string} </h3>
      <section className=%twc("divide-y text-sm text-text-L2 mt-2 border-t border-b")>
        <div className=%twc("grid grid-cols-2-detail")>
          <div className=%twc("p-3 bg-div-shape-L2")> {"처리자"->React.string} </div>
          <div className=%twc("p-3")>
            {auth->Option.flatMap(auth' => auth'.email)->Option.getWithDefault(`-`)->React.string}
          </div>
        </div>
        <div className=%twc("grid grid-cols-2-detail")>
          <div className=%twc("p-3 bg-div-shape-L2")> {"취소일시"->React.string} </div>
          <div className=%twc("p-3")>
            {createdAt->Js.Date.fromString->DateFns.format("yyyy/MM/dd HH:mm")->React.string}
          </div>
        </div>
        <div className=%twc("grid grid-cols-2-detail")>
          <div className=%twc("p-3 bg-div-shape-L2")> {"취소사유"->React.string} </div>
          <div className=%twc("p-3")>
            {reason
            ->Option.flatMap(r => r.reasonType)
            ->Option.mapWithDefault("-", toString)
            ->React.string}
          </div>
        </div>
        <div className=%twc("grid grid-cols-2-detail w-full")>
          <div className=%twc("p-3 bg-div-shape-L2")> {"취소상세사유"->React.string} </div>
          <div className=%twc("p-3 whitespace-pre-wrap break-all")>
            {reason->Option.flatMap(r => r.reasonDesc)->Option.getWithDefault(`-`)->React.string}
          </div>
        </div>
      </section>
    </>
  | None => React.null
  }
}
