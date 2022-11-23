module Query = %relay(`
  query OrderDetailDepositPendingTable_Query(
    $orderNo: String!
    $orderProductNo: String
  ) {
    wosOrder(orderNo: $orderNo, orderProductNo: $orderProductNo) {
      payment {
        virtualAccount {
          accountNo
          bank {
            name
          }
          expiredAt
        }
      }
    }
  }
`)

module Converter = Converter.Status(CustomHooks.Orders)

module PlaceHolder = {
  @react.component
  let make = () => {
    <>
      <div className=%twc("grid grid-cols-2-detail  sm:grid-cols-4-detail")>
        <div className=%twc("p-3 bg-div-shape-L2")> {"주문상태"->React.string} </div>
        <div className=%twc("p-3")> {"입금대기"->React.string} </div>
        <div className=%twc("p-3 bg-div-shape-L2")> {"입금기한"->React.string} </div>
        <div className=%twc("p-3")> {"-"->React.string} </div>
      </div>
      <div className=%twc("grid grid-cols-2-detail  sm:grid-cols-4-detail")>
        <div className=%twc("p-3 bg-div-shape-L2")> {"가상계좌은행"->React.string} </div>
        <div className=%twc("p-3")> {"-"->React.string} </div>
        <div className=%twc("p-3 bg-div-shape-L2")> {"계좌번호"->React.string} </div>
        <div className=%twc("flex gap-1 items-center px-3")>
          <div> {"-"->React.string} </div>
        </div>
      </div>
    </>
  }
}

@react.component
let make = (~order: CustomHooks.Orders.order) => {
  let {addToast} = ReactToastNotifications.useToasts()
  let {orderNo, orderProductNo} = order
  let {wosOrder} = Query.use(
    ~variables={
      orderNo,
      orderProductNo: Some(orderProductNo),
    },
    (),
  )

  let showToastCopySuccess = _ => {
    addToast(.
      <div className=%twc("flex items-center ")>
        <IconCheck height="24" width="24" fill="#12B564" className=%twc("mr-2") />
        {"계좌번호가 클립보드에 복사되었습니다."->React.string}
      </div>,
      {appearance: "success"},
    )
  }

  let showToastCopyError = _ => {
    addToast(.
      <div className=%twc("flex items-center w-full whitespace-pre-wrap")>
        <IconError height="24" width="24" className=%twc("mr-2") />
        {"클립보드 복사에 실패하였습니다."->React.string}
      </div>,
      {appearance: "error"},
    )
  }

  let (accountNo, bankName, expiredAt) =
    wosOrder
    ->Option.flatMap(w => w.payment->Option.flatMap(p => p.virtualAccount))
    ->Option.mapWithDefault(("-", "-", "-"), ({accountNo, bank: {name}, expiredAt}) => (
      accountNo,
      name,
      expiredAt->Js.Date.fromString->DateFns.format("yyyy/MM/dd HH:mm"),
    ))

  let copyText = str => {
    // FIXME: Dialog 내에서 Clipboard가 동작하지 않아서 사용한 방법입니다.
    let _ = try {
      str->Global.Window.writeText
      |> Js.Promise.then_(_ => {
        showToastCopySuccess()
        Js.Promise.resolve()
      })
      |> Js.Promise.catch(_ => {
        showToastCopySuccess()
        Js.Promise.resolve()
      })
    } catch {
    | _ => {
        showToastCopyError()
        Js.Promise.resolve()
      }
    }
  }

  <>
    <div className=%twc("grid grid-cols-2-detail  sm:grid-cols-4-detail")>
      <div className=%twc("p-3 bg-div-shape-L2")> {j`주문상태`->React.string} </div>
      <div className=%twc("p-3")> {order.status->Converter.displayStatus->React.string} </div>
      <div className=%twc("p-3 bg-div-shape-L2 border-t sm:border-t-0")>
        {j`입금기한`->React.string}
      </div>
      <div className=%twc("p-3 border-t sm:border-t-0")> {expiredAt->React.string} </div>
    </div>
    <div className=%twc("grid grid-cols-2-detail")>
      <div className=%twc("p-3 bg-div-shape-L2")> {"가상계좌은행"->React.string} </div>
      <div className=%twc("p-3 flex items-center gap-2")>
        <span> {bankName->React.string} </span>
      </div>
    </div>
    <div className=%twc("grid grid-cols-2-detail")>
      <div className=%twc("p-3 bg-div-shape-L2")> {"계좌번호"->React.string} </div>
      <div className=%twc("px-3 flex items-center gap-2")>
        <span> {accountNo->React.string} </span>
        <button
          type_="button"
          className="py-1 px-2 text-[#65666B] font-normal text-sm rounded-md bg-[#F7F8FA]"
          onClick={_ => copyText(accountNo->Js.String2.replaceByRe(%re("/\D/g"), ""))}>
          {"복사"->React.string}
        </button>
      </div>
    </div>
  </>
}
