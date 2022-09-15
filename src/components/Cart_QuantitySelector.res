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
let make = (~prefix, ~quantity, ~cartId) => {
  let {addToast} = ReactToastNotifications.useToasts()
  let {control} = Hooks.Context.use(. ~config=Hooks.Form.config(~mode=#onChange, ()), ())

  let handleError = (~message=?, ()) => {
    addToast(.
      <div className=%twc("flex items-center w-full whitespace-pre-wrap")>
        <IconError height="24" width="24" className=%twc("mr-2") />
        {j`상품 수량 수정에 실패하였습니다. ${message->Option.getWithDefault(
            "",
          )}`->React.string}
      </div>,
      {appearance: "error"},
    )
  }

  let (mutate, _) = Mutation.use()
  let formNames = Form.names(prefix)
  let handleChange = (changeFn, fn, v) =>
    ReactEvents.interceptingHandler(_ => {
      v
      ->Js.Json.decodeNumber
      ->Option.map(Float.toInt)
      ->Option.forEach(v' =>
        switch fn(v', 1) {
        | 0
        | 1000 => () // 0 < n < 1000
        | _ =>
          mutate(
            ~variables={
              cartId: cartId,
              quantity: fn(v', 1),
            },
            ~onCompleted={
              ({updateCartItemQuantity}, _) =>
                switch updateCartItemQuantity {
                | #UpdateCartItemQuantitySuccess(_) =>
                  changeFn(Controller.OnChangeArg.value(fn(v', 1)->Int.toFloat->Js.Json.number))
                | #Error(err) => handleError(~message=err.message->Option.getWithDefault(""), ())
                | _ => handleError()
                }
            },
            ~onError=err => handleError(~message=err.message, ()),
            (),
          )->ignore
        }
      )
    })

  let plus = (x, y) => x + y
  let minus = (x, y) => x - y

  <Controller
    control
    name={formNames.quantity}
    defaultValue={quantity->Int.toFloat->Js.Json.number}
    render={({field: {onChange, value}}) => {
      <div
        className=%twc(
          "w-24 flex justify-between py-[7px] px-[11px] gap-[11px] bg-white rounded-lg border border-gray-250"
        )>
        <button onClick={handleChange(onChange, minus, value)}>
          <img src=minusIcon alt="minus-icon" className=%twc("w-4 h-4 cursor-pointer") />
        </button>
        {value->Js.Json.stringify->React.string}
        <button onClick={handleChange(onChange, plus, value)}>
          <img src=plusIcon alt="plus-icon" className=%twc("w-4 h-4 cursor-pointer") />
        </button>
      </div>
    }}
  />
}
