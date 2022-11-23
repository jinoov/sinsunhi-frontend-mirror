module Query = %relay(`
  query CartBuyerQuery {
    ...CartBuyerItemFragment
  }
`)

module Mutation = %relay(`
  mutation CartBuyerMutation($cartItems: [Int!]!) {
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

open ReactHookForm
module Form = Cart_Buyer_Form
module Util = Cart_Buyer_Util

module Container = {
  @react.component
  let make = (~deviceType) => {
    let {addToast} = ReactToastNotifications.useToasts()
    let {useRouter, push} = module(Next.Router)
    let router = useRouter()

    let methods = Hooks.Form.use(.
      ~config=Hooks.Form.config(~mode=#all, ~shouldUnregister=true, ()),
      (),
    )
    let {handleSubmit} = methods
    let (showNotChecked, setShowNotChecked) = React.Uncurried.useState(_ => false)

    let (mutate, _) = Mutation.use()
    let query = Query.use(~variables=(), ~fetchPolicy=RescriptRelay.NetworkOnly, ())

    let handleError = (~message=?, ()) =>
      addToast(.
        <div className=%twc("flex items-center")>
          <IconError height="24" width="24" className=%twc("mr-2") />
          {j`주문에 실패하였습니다. ${message->Option.getWithDefault("")}`->React.string}
        </div>,
        {appearance: "error"},
      )

    let extractCartIds = (e: Form.cart) => {
      e.cartItems
      ->Option.getWithDefault([])
      ->Array.keep(cartItem => cartItem.productStatus->Form.soldable)
      ->Array.map(cartItem =>
        cartItem.productOptions
        ->Array.keep(option => option.checked && option.optionStatus->Form.soldable)
        ->Array.map(option => option.cartId)
      )
      ->Array.concatMany
    }

    let onSubmit = (data: Js.Json.t, _) => {
      switch data->Form.submit_decode {
      | Ok({cart}) => {
          let (cartIds, cartItems) = switch cart.orderType {
          | #CourierAvailable => (
              cart.courierAvailableItem->extractCartIds,
              cart.courierAvailableItem.cartItems->Option.getWithDefault([]),
            )
          | #UnCourierAvailable => (
              cart.unCourierAvailableItem->extractCartIds,
              cart.unCourierAvailableItem.cartItems->Option.getWithDefault([]),
            )
          }
          mutate(
            ~variables={
              cartItems: cartIds,
            },
            ~onCompleted={
              ({createTempWosOrder}, _) => {
                switch createTempWosOrder {
                | Some(createTempWosOrder') =>
                  switch createTempWosOrder' {
                  | #TempWosOrder({tempOrderId}) =>
                    // GTM
                    cartItems->Form.cartGtmPush(cartIds, "begin_checkout")
                    router->push(`/buyer/web-order/${tempOrderId->Int.toString}`)
                  | #Error({message}) =>
                    handleError(~message=message->Option.getWithDefault(""), ())
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

      | Error(err) => Js.log(err)
      }
    }

    <>
      {switch deviceType {
      | DeviceDetect.Unknown => React.null
      | DeviceDetect.PC => {
          let oldUI =
            <>
              <Header_Buyer.PC_Old key=router.asPath />
              <ReactHookForm.Provider methods>
                <form onSubmit={handleSubmit(. onSubmit)}>
                  <Cart_Buyer_Item query=query.fragmentRefs deviceType />
                </form>
              </ReactHookForm.Provider>
              <Footer_Buyer.PC />
            </>

          <FeatureFlagWrapper featureFlag=#HOME_UI_UX fallback=oldUI>
            {<div className=%twc("w-full min-h-screen bg-[#F0F2F5] flex flex-col")>
              <Header_Buyer.PC_Old key=router.asPath />
              <section className=%twc("w-[1920px] mx-auto bg-[#FAFBFC] flex-1")>
                <ReactHookForm.Provider methods>
                  <form onSubmit={handleSubmit(. onSubmit)}>
                    <Cart_Buyer_Item query=query.fragmentRefs deviceType />
                  </form>
                </ReactHookForm.Provider>
              </section>
              <Footer_Buyer.PC />
            </div>}
          </FeatureFlagWrapper>
        }

      | DeviceDetect.Mobile =>
        <>
          <Header_Buyer.Mobile />
          <ReactHookForm.Provider methods>
            <form onSubmit={handleSubmit(. onSubmit)}>
              <Cart_Buyer_Item query=query.fragmentRefs deviceType />
            </form>
          </ReactHookForm.Provider>
        </>
      }}
      <Util.SubmitDialog _open=showNotChecked setOpen=setShowNotChecked />
    </>
  }
}

type props = {deviceType: DeviceDetect.deviceType}
type params
type previewData

let default = (~props) => {
  let {deviceType} = props

  <Authorization.Buyer
    title={j`장바구니`} fallback={<Cart_Buyer_Item.PlaceHolder deviceType />}>
    <React.Suspense fallback={<Cart_Buyer_Item.PlaceHolder deviceType />}>
      <Container deviceType />
    </React.Suspense>
  </Authorization.Buyer>
}

let getServerSideProps = (ctx: Next.GetServerSideProps.context<props, params, previewData>) => {
  let deviceType = DeviceDetect.detectDeviceFromCtx2(ctx.req)
  Js.Promise.resolve({
    "props": {"deviceType": deviceType},
  })
}
