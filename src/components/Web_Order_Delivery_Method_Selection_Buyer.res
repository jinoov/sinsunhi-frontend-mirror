open ReactHookForm
open Web_Order_Util_Component
module Form = Web_Order_Buyer_Form

module Fragment = %relay(`
        fragment WebOrderDeliveryMethodSelectionBuyerFragment on Query
        @argumentDefinitions(productNodeId: { type: "ID!" }) {
          productNode: node(id: $productNodeId) {
            ... on NormalProduct {
              isCourierAvailable
            }
        
            ... on QuotableProduct {
              isCourierAvailable
            }
          }
        }
  `)

module PlaceHoder = {
  module PC = {
    @react.component
    let make = () => {
      <section className=%twc("flex flex-col p-7 gap-5 bg-white rounded-sm")>
        <span className=%twc("flex items-center gap-1 text-xl text-enabled-L1 font-bold")>
          {`배송 방식 선택`->React.string}
          <Tooltip.PC>
            {`선택하신 배송 방식에 따라 배송비 부과 정책이 달라집니다.`->React.string}
          </Tooltip.PC>
        </span>
        <div className=%twc("flex gap-2")>
          <RadioButton.PlaceHolder.PC /> <RadioButton.PlaceHolder.PC /> <RadioButton.PlaceHolder.PC />
        </div>
      </section>
    }
  }
  module MO = {
    @react.component
    let make = () => {
      <section className=%twc("flex flex-col p-7 gap-5 bg-white rounded-sm")>
        <span className=%twc("flex items-center gap-1 text-lg text-enabled-L1 font-bold")>
          {`배송 방식 선택`->React.string}
          <Tooltip.Mobile>
            {`선택하신 배송 방식에 따라 배송비 부과 정책이 달라집니다.`->React.string}
          </Tooltip.Mobile>
        </span>
        <div className=%twc("flex gap-2")>
          <RadioButton.PlaceHolder.MO /> <RadioButton.PlaceHolder.MO /> <RadioButton.PlaceHolder.MO />
        </div>
      </section>
    }
  }
}

@react.component
let make = (~isSameCourierAvailable, ~isCourierAvailable, ~prefix, ~deviceType) => {
  let formNames = Form.names(prefix)
  let {register, formState: {errors}} = Hooks.Context.use(.
    ~config=Hooks.Form.config(~mode=#onChange, ()),
    (),
  )

  let {ref, name, onChange, onBlur} = register(.
    formNames.deliveryType,
    Some(Hooks.Register.config(~required=true, ())),
  )

  let watchValue = Hooks.WatchValues.use(
    Hooks.WatchValues.Text,
    ~config=Hooks.WatchValues.config(~name=formNames.deliveryType, ()),
    (),
  )
  <>
    <div className=%twc("flex gap-2")>
      {{
        switch isSameCourierAvailable {
        | Some(true) =>
          switch isCourierAvailable {
          | Some(true) => [
              ("parcel", `택배배송`),
              ("freight", `화물배송`),
              ("self", `직접수령`),
            ]
          | Some(false) => [("freight", `화물배송`), ("self", `직접수령`)]
          | None => []
          }
        | _ => []
        }
      }
      ->Array.map(((value, n)) =>
        <label
          key=n
          className=%twc(
            "focus:outline-none focus-within:bg-primary-light focus-within:outline-none focus-within:rounded-xl"
          )>
          <input className=%twc("sr-only") type_="radio" id=name ref name onChange onBlur value />
          <RadioButton watchValue name=n value deviceType />
        </label>
      )
      ->React.array}
    </div>
    <ErrorMessage
      name
      errors
      render={_ =>
        <span className=%twc("flex")>
          <IconError width="20" height="20" />
          <span className=%twc("text-sm text-notice ml-1")>
            {`배송 방식을 선택해주세요`->React.string}
          </span>
        </span>}
    />
  </>
}
