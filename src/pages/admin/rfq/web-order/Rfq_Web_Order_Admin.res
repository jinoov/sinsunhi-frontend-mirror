module Fragment = %relay(`
  fragment RfqWebOrderAdminFragment on RfqWosOrderProduct {
    id
    buyer {
      buyerName: name
    }
    rfq {
      number
    }
    category {
      fullyQualifiedName {
        name
      }
    }
    rfqProduct {
      number
    }
    remainingBalance
    rfqWosOrderProductNo
    price
    paidAmountAcc
    deliveryFee
    ...RfqWebOrderDetailDialogFragment
  }
`)

@react.component
let make = (~query) => {
  let {
    rfq,
    buyer,
    category: {fullyQualifiedName},
    price,
    remainingBalance,
    paidAmountAcc,
    rfqProduct: {number},
    rfqWosOrderProductNo,
    fragmentRefs,
  } = Fragment.use(query)

  <li className=%twc("grid grid-cols-8-admin-rfq-web-order text-gray-700")>
    <div className=%twc("px-4 py-2")>
      <Rfq_Web_Order_Detail_Dialog query={fragmentRefs} num={rfq.number->Int.toString} />
    </div>
    <div className=%twc("px-4 py-2")> {number->Int.toString->React.string} </div>
    <div className=%twc("px-4 py-2")> {rfqWosOrderProductNo->Int.toString->React.string} </div>
    <div className=%twc("px-4 py-2")>
      {fullyQualifiedName->Garter.Array.joinWith(" > ", f => f.name)->React.string}
    </div>
    <div className=%twc("px-4 py-2")>
      {`${price
        ->Float.fromString
        ->Option.getWithDefault(0.)
        ->Locale.Float.show(~digits=3)} 원`->React.string}
    </div>
    <div className=%twc("px-4 py-2")>
      {`${paidAmountAcc
        ->Option.flatMap(Float.fromString)
        ->Option.getWithDefault(0.)
        ->Locale.Float.show(~digits=3)} 원`->React.string}
    </div>
    <div className=%twc("px-4 py-2")>
      {`${remainingBalance
        ->Option.flatMap(Float.fromString)
        ->Option.getWithDefault(0.)
        ->Locale.Float.show(~digits=3)} 원`->React.string}
    </div>
    <div className=%twc("px-4 py-2")>
      <span> {buyer->Option.mapWithDefault("", b => b.buyerName)->React.string} </span>
    </div>
  </li>
}
