module Mutation = %relay(`
  mutation CartQuantitySelectorMutation($cartId: Int!, $quantity: Int!) {
    updateCartItemQuantity(input: { cartId: $cartId, quantity: $quantity }) {
      ... on UpdateCartItemQuantitySuccess {
        cartId
      }
      ... on Error {
        message
      }
    }
  }
`)
module Form = Cart_Buyer_Form
open ReactHookForm

@module("../../public/assets/minus.svg")
external minusIcon: string = "default"

@module("../../public/assets/plus.svg")
external plusIcon: string = "default"

@react.component
let make = (~prefix, ~quantity, ~cartId, ~max=Spinbox.maxQuantity) => {
  let {addToast} = ReactToastNotifications.useToasts()
  let {control, setError, formState: {errors}, setValue} = Hooks.Context.use(.
    ~config=Hooks.Form.config(~mode=#onChange, ()),
    (),
  )

  let toastWhenOverMaxQuantity = _ =>
    addToast(.
      <div className=%twc("flex items-center")>
        <div className=%twc("mr-[6px]")>
          <Formula.Icon.CheckCircleFill color=#"primary-contents" />
        </div>
        <span> {`구매 가능 수량은 ${max->Int.toString}개 입니다`->React.string} </span>
      </div>,
      {appearance: "success"},
    )

  let (mutate, _) = Mutation.use()
  let formNames = Form.names(prefix)

  let handleError = (~message=?, ()) => {
    addToast(.
      <div className=%twc("flex items-center w-full whitespace-pre-wrap")>
        <IconError height="24" width="24" className=%twc("mr-2") />
        {`상품 수량 수정에 실패하였습니다. ${message->Option.getWithDefault(
            "",
          )}`->React.string}
      </div>,
      {appearance: "error"},
    )
  }

  React.useEffect0(() => {
    // 현재 Snapshot에 담긴 수량이 어드민이 설정한 판매 가능 수량보다 높은 경우,
    // Snapshot의 quantity를 max값으로 변경 후, 에러메시지를 보여줍니다.
    switch quantity > max {
    | true =>
      mutate(
        ~variables={
          cartId,
          quantity: max,
        },
        ~onCompleted={
          ({updateCartItemQuantity}, _) =>
            switch updateCartItemQuantity {
            | #UpdateCartItemQuantitySuccess(_) => {
                setValue(. formNames.quantity, max->Int.toFloat->Js.Json.number)
                setError(.
                  formNames.quantity,
                  {type_: "custom", message: "상품 수량이 변경되었습니다."},
                )
              }

            | #Error(err) => handleError(~message=err.message->Option.getWithDefault(""), ())
            | _ => handleError()
            }
        },
        ~onError=err => handleError(~message=err.message, ()),
        (),
      )->ignore

    | false => ()
    }

    None
  })

  let plus = (x, y) => x + y
  let minus = (x, y) => x - y

  let handleChange = (changeFn, fn, v) =>
    ReactEvents.interceptingHandler(_ => {
      v
      ->Js.Json.decodeNumber
      ->Option.map(Float.toInt)
      ->Option.forEach(v' => {
        let nextQuantity = fn(v', 1)

        if nextQuantity > max {
          toastWhenOverMaxQuantity()
        } else {
          switch nextQuantity > 0 {
          | true =>
            mutate(
              ~variables={
                cartId,
                quantity: nextQuantity,
              },
              ~onCompleted={
                ({updateCartItemQuantity}, _) =>
                  switch updateCartItemQuantity {
                  | #UpdateCartItemQuantitySuccess(_) =>
                    changeFn(
                      Controller.OnChangeArg.value(nextQuantity->Int.toFloat->Js.Json.number),
                    )
                  | #Error(err) => handleError(~message=err.message->Option.getWithDefault(""), ())
                  | _ => handleError()
                  }
              },
              ~onError=err => handleError(~message=err.message, ()),
              (),
            )->ignore
          | false => ()
          }
        }
      })
    })

  <Controller
    control
    name={formNames.quantity}
    defaultValue={quantity->Int.toFloat->Js.Json.number}
    render={({field: {onChange, value}}) => {
      <div>
        <div
          className=%twc(
            "w-[120px] h-[38px] flex justify-between items-center bg-white rounded-lg border border-gray-250"
          )>
          <button
            disabled={value === 1->Int.toFloat->Js.Json.number}
            className=%twc("w-[38px] h-full flex justify-center items-center")
            onClick={handleChange(onChange, minus, value)}>
            <Formula.Icon.MinusLineRegular color=#"gray-90" size=#sm />
          </button>
          {value->Js.Json.stringify->React.string}
          <button
            className=%twc("w-[38px] h-full flex justify-center items-center")
            onClick={handleChange(onChange, plus, value)}>
            <Formula.Icon.PlusLineRegular color=#"gray-90" size=#sm />
          </button>
        </div>
        <ErrorMessage
          name=formNames.quantity
          errors
          render={({message}) =>
            <span className=%twc("flex mt-2")>
              <IconError width="20" height="20" />
              <span className=%twc("text-sm text-notice ml-1")> {message->React.string} </span>
            </span>}
        />
      </div>
    }}
  />
}
