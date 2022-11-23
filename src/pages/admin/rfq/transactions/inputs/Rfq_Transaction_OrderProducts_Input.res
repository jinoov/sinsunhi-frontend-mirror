module Inputs = Rfq_Transactions_Admin_Form.Inputs

module InputWithoutData = {
  @react.component
  let make = (~form, ~remove, ~update, ~index) => {
    let (queryRef, loadQuery, _) = Rfq_Transaction_QueryRef_Input.Query.useLoader()

    let orderProductNumberProperty = "order-product-number"
    let searchedUserProperty = "searched-user"

    let orderProductNumber =
      form->Inputs.OrderProducts.registerWithIndex(index, ~property=orderProductNumberProperty, ())

    let getError = keyName =>
      (form->Inputs.OrderProducts.getFieldArrayState).error
      ->Option.getWithDefault([])
      ->Array.get(index)
      ->Option.flatMap(optDict => optDict->Option.flatMap(d => d->Js.Dict.get(keyName)))

    let orderProductNumberError =
      getError(orderProductNumberProperty)->Option.map(_ =>
        "주문상품 번호를 입력해주세요(숫자만)"
      )

    let searchedUserError = getError(searchedUserProperty)->Option.map(({message}) => message)

    let orderProducts = form->Inputs.OrderProducts.watch
    let productNumber =
      orderProducts
      ->Array.get(index)
      ->Option.flatMap(orderProduct => orderProduct.orderProductNumber->Int.fromString)
    let handleKeyDownEnter = (e: ReactEvent.Keyboard.t) => {
      if e->ReactEvent.Keyboard.keyCode === 13 {
        e->ReactEvent.Keyboard.preventDefault
        switch productNumber {
        | Some(productNumber') => {
            Js.log(productNumber')
            loadQuery(~variables={rfqWosOrderProductNo: productNumber'}, ())
          }

        | None => ()
        }
      }
    }

    let delete = () => remove(index)

    {
      switch queryRef {
      | Some(queryRef) =>
        <React.Suspense fallback={<div />}>
          //TODO: 서스팬스
          <Rfq_Transaction_QueryRef_Input form remove update index queryRef />
        </React.Suspense>
      | None =>
        <div className=%twc("grid grid-cods-8-admin-rfq-factoring px-2 h-12 items-center")>
          <div className=%twc("relative")>
            {form->Inputs.OrderProducts.renderWithIndexRegister(
              index,
              <input className=%twc("sr-only") />,
              ~property=searchedUserProperty,
              ~config=HookForm.Rules.makeWithErrorMessage({
                required: {value: true, message: "바이어 검색을 해주세요(숫자만)"},
                pattern: {
                  value: %re("/^((?!NoSearch).)*$/"),
                  message: "바이어 검색을 해주세요(숫자만)",
                },
              }),
              (),
            )}
            <Input
              type_="text"
              name=orderProductNumber.name
              className={cx([
                %twc("w-32"),
                switch (orderProductNumberError, searchedUserError) {
                | (None, None) => ""
                | _ => %twc("ring-2 ring-opacity-100 ring-notice")
                },
              ])}
              size=Input.Small
              placeholder={"주문상품번호 입력"}
              inputRef=orderProductNumber.ref
              onBlur=orderProductNumber.onBlur
              onChange=orderProductNumber.onChange
              onKeyDown={handleKeyDownEnter}
              error=None
            />
            {switch (orderProductNumberError, searchedUserError) {
            | (Some(message), _)
            | (None, Some(message)) =>
              <ErrorText className=%twc("absolute min-w-max") errMsg=message />
            | _ => React.null
            }}
          </div>
          <span> {"-"->React.string} </span>
          <span> {"-"->React.string} </span>
          <span> {"-"->React.string} </span>
          <span> {"-"->React.string} </span>
          <span> {"-"->React.string} </span>
          <span> {"-"->React.string} </span>
          <button type_="button" onClick={_ => delete()}>
            <Formula.Icon.TrashLineRegular />
          </button>
        </div>
      }
    }
  }
}

module InputWithData = {
  @react.component
  let make = (
    ~form,
    ~index,
    ~rfqWosOrderProduct: RfqTransactionOrderProductsInputFragment_graphql.Types.fragment_details_rfqWosOrderProduct,
    ~disabled=false,
  ) => {
    let orderProductProperty = "order-product-number"
    let expectedPaymentAmountProperty = "expected-payment-amount"
    let orderProductNumber =
      form->Inputs.OrderProducts.registerWithIndex(index, ~property=orderProductProperty, ())
    let expectedPaymentAmount =
      form->Inputs.OrderProducts.registerWithIndex(
        index,
        ~property=expectedPaymentAmountProperty,
        (),
      )

    let getError = keyName =>
      (form->Inputs.OrderProducts.getFieldArrayState).error
      ->Option.getWithDefault([])
      ->Array.get(index)
      ->Option.flatMap(optDict => optDict->Option.flatMap(d => d->Js.Dict.get(keyName)))

    let expectedPaymentAmountError =
      getError(expectedPaymentAmountProperty)->Option.map(_ =>
        "금액을 입력해주세요.(숫자만)"
      )

    let {price, deliveryFee, paidAmountAcc, remainingBalance, rfqProduct} = rfqWosOrderProduct

    let confirmPrice = price->Float.fromString->Option.getWithDefault(0.)

    let originPrice = rfqProduct.amount *. rfqProduct.unitPrice->Int.toFloat

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
        error=None
        disabled=true
      />
      <span> {originPrice->Locale.Float.show(~digits=3)->React.string} </span>
      <span> {confirmPrice->Locale.Float.show(~digits=3)->React.string} </span>
      <span>
        {paidAmountAcc
        ->Option.flatMap(Float.fromString)
        ->Option.getWithDefault(0.)
        ->Locale.Float.show(~digits=3)
        ->React.string}
      </span>
      <span> {deliveryFee->Option.getWithDefault(0)->Locale.Int.show->React.string} </span>
      <div className=%twc("relative")>
        <Input
          type_="text"
          name=expectedPaymentAmount.name
          className=%twc("w-32")
          size=Input.Small
          placeholder={"결제금액입력"}
          inputRef=expectedPaymentAmount.ref
          onBlur=expectedPaymentAmount.onBlur
          onChange=expectedPaymentAmount.onChange
          disabled
          error=None
        />
        {expectedPaymentAmountError->Option.mapWithDefault(React.null, errMsg =>
          <ErrorText className=%twc("absolute min-w-max") errMsg />
        )}
      </div>
      <span>
        {remainingBalance
        ->Option.flatMap(Float.fromString)
        ->Option.getWithDefault(0.)
        ->Locale.Float.show(~digits=3)
        ->React.string}
      </span>
    </div>
  }
}

module InputArray = {
  @react.component
  let make = (~form, ~fieldArray) => {
    let fields = fieldArray->Inputs.OrderProducts.fields
    let remove = fieldArray->Inputs.OrderProducts.remove
    let update = fieldArray->Inputs.OrderProducts.update

    <div className=%twc("h-96 overflow-y-scroll divide-y divide-gray-100")>
      {fields
      ->Array.mapWithIndex((index, field) =>
        <InputWithoutData form remove index update key={field->Inputs.OrderProducts.id} />
      )
      ->React.array}
    </div>
  }
}

module InputArrayWithQuery = {
  module Fragment = %relay(`
  fragment RfqTransactionOrderProductsInputFragment on RfqWosOrderDepositSchedule {
    details {
      rfqWosOrderProduct {
        rfqProduct {
          amount
          unitPrice
        }
        price
        remainingBalance
        paidAmountAcc
        deliveryFee
      }
    }
  }
`)
  @react.component
  let make = (~form, ~fieldArray, ~query, ~disabled) => {
    let {details} = Fragment.use(query)
    let fields = fieldArray->Inputs.OrderProducts.fields

    let zipped =
      details
      ->Array.keepMap(Garter_Fn.identity)
      ->Array.map(d => d.rfqWosOrderProduct)
      ->Array.zip(fields)

    <div className=%twc("h-96 overflow-y-scroll divide-y divide-gray-100")>
      {zipped
      ->Array.mapWithIndex((index, (rfqWosOrderProduct, field)) => {
        <InputWithData
          form index rfqWosOrderProduct disabled key={field->Inputs.OrderProducts.id}
        />
      })
      ->React.array}
    </div>
  }
}
