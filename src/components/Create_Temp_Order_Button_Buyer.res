module Mutation = %relay(`
  mutation CreateTempOrderButtonBuyerMutation($cartItems: [Int!]!) {
    createTempWosOrder(input: { cartItems: $cartItems }) {
      ... on TempWosOrder {
        tempOrderId
      }
      ... on Error {
        message
      }
      ... on CartError {
        message
      }
    }
  }
`)

module Util = Cart_Buyer_Util

@react.component
let make = (
  ~className=%twc("w-20 h-10 border border-primary text-primary rounded-[10px]"),
  ~buttonText=`바로구매`,
  ~cartItems,
  ~cartIds,
) => {
  let {addToast} = ReactToastNotifications.useToasts()
  let {useRouter, push} = module(Next.Router)
  let router = useRouter()
  let (mutate, _) = Mutation.use()
  let (showNoSelect, setShowNoSelect) = React.Uncurried.useState(_ => false)

  let handleError = (~message=?, ()) =>
    addToast(.
      <div className=%twc("flex items-center")>
        <IconError height="24" width="24" className=%twc("mr-2") />
        {j`주문에 실패하였습니다. ${message->Option.getWithDefault("")}`->React.string}
      </div>,
      {appearance: "error"},
    )

  let onSuccess = () => {
    switch cartIds {
    | [] => setShowNoSelect(._ => true)
    | ids =>
      mutate(
        ~variables={
          cartItems: ids,
        },
        ~onCompleted={
          ({createTempWosOrder}, _) => {
            switch createTempWosOrder {
            | Some(createTempWosOrder') =>
              switch createTempWosOrder' {
              | #TempWosOrder({tempOrderId}) => {
                  // GTM
                  cartItems->Cart_Buyer_Form.cartGtmPush(ids, "begin_checkout")
                  router->push(`/buyer/web-order/${tempOrderId->Int.toString}`)
                }

              | #Error({message}) => handleError(~message=message->Option.getWithDefault(""), ())
              | #CartError({message}) =>
                handleError(~message=message->Option.getWithDefault(""), ())
              | _ => handleError()
              }
            | None => Js.log("fail to mutation")
            }
          }
        },
        ~onError={
          err => handleError(~message=err.message, ())
        },
        (),
      )->ignore
    }
  }

  <>
    <Util.SubmitDialog _open=showNoSelect setOpen=setShowNoSelect />
    <button onClick={ReactEvents.interceptingHandler(_ => onSuccess())} className>
      {buttonText->React.string}
    </button>
  </>
}
