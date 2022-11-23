module Query = %relay(`
  query RfqTransactionQueryRefInputQuery($rfqWosOrderProductNo: Int!) {
    rfqWosOrderProduct(rfqWosOrderProductNo: $rfqWosOrderProductNo) {
      ... on RfqWosOrderProduct {
        id
        buyer {
          id
          name
        }
        rfqProduct {
          amount
          unitPrice
        }
        price
        paidAmountAcc
        deliveryFee
        remainingBalance
      }
    }
  }
`)

module Form = Rfq_Transactions_Admin_Form.Form
module Inputs = Rfq_Transactions_Admin_Form.Inputs

@react.component
let make = (
  ~form,
  ~remove,
  ~update: (int, Rfq_Transactions_Admin_Form.orderProduct) => unit,
  ~index,
  ~queryRef,
) => {
  let {rfqWosOrderProduct} = Query.usePreloaded(~queryRef, ())
  let buyer = form->Inputs.Buyer.watch
  let orderProducts = form->Inputs.OrderProducts.watch

  let delete = () =>
    switch index {
    | 0 => {
        remove(index)
        form->Inputs.Buyer.setValue(#NoSearch)
        form->Inputs.OrderProducts.setValue(orderProducts->Array.sliceToEnd(1))
      }

    | _ => remove(index)
    }

  let orderProductProperty = "order-product-number"
  let expectedPaymentAmountProperty = "expected-payment-amount"

  let orderProductNumber =
    form->Inputs.OrderProducts.registerWithIndex(index, ~property=orderProductProperty, ())
  let expectedPaymentAmount =
    form->Inputs.OrderProducts.registerWithIndex(index, ~property=expectedPaymentAmountProperty, ())

  let getError = keyName =>
    (form->Inputs.OrderProducts.getFieldArrayState).error
    ->Option.getWithDefault([])
    ->Array.get(index)
    ->Option.flatMap(optDict => optDict->Option.flatMap(d => d->Js.Dict.get(keyName)))

  let expectedPaymentAmountError =
    getError(expectedPaymentAmountProperty)->Option.map(_ =>
      "금액을 입력해주세요.(숫자만)"
    )

  let reset = () =>
    update(
      index,
      {
        orderProductNumber: "",
        id: "",
        expectedPaymentAmount: "",
      },
    )

  let wosOrderProduct = rfqWosOrderProduct->Option.flatMap(r =>
    switch r {
    | #RfqWosOrderProduct(p) => Some(p)
    | _ => None
    }
  )

  React.useEffect0(_ => {
    switch wosOrderProduct->Option.flatMap(p => p.buyer) {
    | Some(buyer') =>
      switch (buyer, index) {
      | (#Searched({userId}), _) =>
        switch userId == buyer'.id {
        | true => ()
        | false => reset()
        }
      | (#NoSearch, 0) =>
        form->Inputs.Buyer.setValue(#Searched({userId: buyer'.id, userName: buyer'.name}))
      | _ => reset()
      }
    | None => reset()
    }
    None
  })

  let toString = (v, fn) => v->Option.mapWithDefault("-", fn)

  let originPrice =
    wosOrderProduct
    ->Option.map(r => r.rfqProduct.amount *. r.rfqProduct.unitPrice->Int.toFloat)
    ->toString(Locale.Float.show(~digits=3))

  let confirmPrice =
    wosOrderProduct
    ->Option.flatMap(p => p.price->Float.fromString)
    ->toString(Locale.Float.show(~digits=3))

  let paidAmountAcc =
    wosOrderProduct
    ->Option.flatMap(p => p.paidAmountAcc)
    ->Option.flatMap(Float.fromString)
    ->toString(Locale.Float.show(~digits=3))

  let deliveryFee = wosOrderProduct->Option.flatMap(p => p.deliveryFee)->toString(Locale.Int.show)

  let remainingBalance =
    wosOrderProduct
    ->Option.flatMap(p => p.remainingBalance)
    ->Option.flatMap(Float.fromString)
    ->toString(Locale.Float.show(~digits=3))

  <div className=%twc("grid grid-cods-8-admin-rfq-factoring px-2 h-12 items-center")>
    <Input
      type_="text"
      name=orderProductNumber.name
      className=%twc("w-32")
      size=Input.Small
      placeholder={"주문상품번호 입력"}
      inputRef=orderProductNumber.ref
      onBlur=orderProductNumber.onBlur
      onChange=orderProductNumber.onChange
      disabled=true
      error=None
    />
    <span> {originPrice->React.string} </span>
    <span> {confirmPrice->React.string} </span>
    <span> {paidAmountAcc->React.string} </span>
    <span> {deliveryFee->React.string} </span>
    <div className=%twc("relative")>
      <Input
        type_="text"
        name=expectedPaymentAmount.name
        className={cx([
          %twc("w-32"),
          switch expectedPaymentAmountError {
          | Some(_) => %twc("ring-2 ring-opacity-100 ring-notice")
          | _ => ""
          },
        ])}
        size=Input.Small
        placeholder={"금액입력"}
        inputRef=expectedPaymentAmount.ref
        onBlur=expectedPaymentAmount.onBlur
        onChange=expectedPaymentAmount.onChange
        error=None
      />
      {expectedPaymentAmountError->Option.mapWithDefault(React.null, errMsg =>
        <ErrorText className=%twc("absolute min-w-max") errMsg />
      )}
    </div>
    <span> {remainingBalance->React.string} </span>
    <button type_="button" onClick={_ => delete()}>
      <Formula.Icon.TrashLineRegular />
    </button>
  </div>
}
