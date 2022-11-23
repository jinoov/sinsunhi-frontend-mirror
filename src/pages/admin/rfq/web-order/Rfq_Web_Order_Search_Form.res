open HookForm
type fields = {
  @as("selected-buyer") selectedBuyer: ReactSelect.selectOption,
  @as("rfq-number") rfqNumber: string,
}
let initial = {
  selectedBuyer: ReactSelect.NotSelected,
  rfqNumber: "",
}
module Form = Make({
  type t = fields
})

module SelectedBuyer = {
  module Field = Form.MakeInput({
    type t = ReactSelect.selectOption
    let name = "selected-buyer"
    let config = Rules.empty()
  })
  module Input = {
    @react.component
    let make = (~form) => {
      let (value, onChange) = form->(Field.watch, Field.setValue)

      let handleLoadOptions = inputValue =>
        FetchHelper.fetchWithRetry(
          ~fetcher=FetchHelper.getWithToken,
          ~url=`${Env.restApiUrl}/user?name=${inputValue}&role=buyer`,
          ~body="",
          ~count=3,
        ) |> Js.Promise.then_(result =>
          switch result->CustomHooks.QueryUser.Buyer.users_decode {
          | Ok(users') if users'.data->Garter.Array.length > 0 =>
            let users'' = users'.data->Garter.Array.map(user => ReactSelect.Selected({
              value: user.id->Int.toString,
              label: `${user.name}(${user.phone
                ->Helper.PhoneNumber.parse
                ->Option.flatMap(Helper.PhoneNumber.format)
                ->Option.getWithDefault(user.phone)})`,
            }))
            Js.Promise.resolve(Some(users''))
          | _ => Js.Promise.reject(Js.Exn.raiseError(`유저 검색 에러`))
          }
        , _)

      <div className=%twc("flex gap-2.5 items-center w-1/2")>
        <span className=%twc("min-w-fit")> {"바이어명"->React.string} </span>
        <div className=%twc("flex w-full min-w-[300px]")>
          <div className=%twc("flex-auto relative")>
            <ReactSelect
              value
              loadOptions=handleLoadOptions
              cacheOptions=true
              defaultOptions=false
              onChange
              placeholder={"바이어 검색"}
              noOptionsMessage={_ => "검색 결과가 없습니다."}
              isClearable=true
            />
          </div>
        </div>
      </div>
    }
  }
}

module RfqNumber = {
  module Field = Form.MakeInput({
    type t = string
    let name = "rfq-number"
    let config = Rules.empty()
  })

  module Input = {
    @react.component
    let make = (~form) => {
      let {name, onChange, onBlur, ref} = form->Field.register()
      let error = form->Field.error
      <div className=%twc("flex gap-2.5 items-center")>
        <span className=%twc("min-w-fit")> {"견적번호"->React.string} </span>
        <div className=%twc("flex w-32 xl:w-full")>
          <Input
            size=Input.Medium
            name
            type_="text"
            placeholder="견적번호 입력"
            onChange
            onBlur
            inputRef=ref
            error={error->Option.map(({message}) => message)}
          />
        </div>
      </div>
    }
  }
}
