module Inputs = Rfq_Transactions_Admin_Form.Inputs

@react.component
let make = (~form) => {
  let {name, onChange, onBlur, ref} = form->Inputs.Buyer.register()
  let buyer = form->Inputs.Buyer.watch
  let error = form->Inputs.Buyer.error->Option.map(({message}) => message)

  {
    switch buyer {
    | #Searched(user) => <span className=%twc("p-3")> {user.userName->React.string} </span>
    | _ =>
      <div>
        <label>
          <span className=%twc("p-3 text-[#8B8D94]")>
            {"자동 조회됩니다"->React.string}
          </span>
          <input type_="text" name onChange onBlur ref className=%twc("sr-only") />
        </label>
        {switch error {
        | Some(message) => <span className=%twc("text-notice")> {message->React.string} </span>
        | None => React.null
        }}
      </div>
    }
  }
}
