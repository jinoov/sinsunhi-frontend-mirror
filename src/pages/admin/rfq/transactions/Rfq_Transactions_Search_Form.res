@spice
type status = [
  | @spice.as("입금전") #PENDING
  | @spice.as("입금완료") #DEPOSIT_COMPLETE
  | @spice.as("스케쥴 취소") #CANCEL
  | @spice.as("전체") #NOT_SELECTED
]
let statuses: array<status> = [#NOT_SELECTED, #PENDING, #DEPOSIT_COMPLETE, #CANCEL]
let statusToString = m => m->status_encode->Js.Json.decodeString->Option.getWithDefault("")

@spice
type isFactoring = [
  | // 추후 Y, N 값이 아니라 다른 값들도 추가된다고 해서 bool type이 아닌 폴리모픽 배리언트로 설정했습니다.
  @spice.as("Y") #Y
  | @spice.as("N") #N
  | @spice.as("전체") #NOT_SELECTED
]

let isFactorings = [#NOT_SELECTED, #Y, #N]
let isFactoringToString = m =>
  m->isFactoring_encode->Js.Json.decodeString->Option.getWithDefault("")

type fromTo = {
  from: Js.Date.t,
  to_: Js.Date.t,
}

open HookForm
type fields = {
  @as("buyer-name") buyerName: ReactSelect.selectOption,
  status: status,
  @as("is-factoring") isFactoring: isFactoring,
  @as("search-from-date") searchFromDate: Js.Date.t,
  @as("search-to-date") searchToDate: Js.Date.t,
}
let initial = {
  buyerName: ReactSelect.NotSelected,
  status: #NOT_SELECTED,
  isFactoring: #NOT_SELECTED,
  searchFromDate: Js.Date.make()->DateFns.setDate(1),
  searchToDate: Js.Date.make()->DateFns.lastDayOfMonth,
}
module Form = Make({
  type t = fields
})
module BuyerName = {
  module Field = Form.MakeInput({
    type t = ReactSelect.selectOption
    let name = "buyer-name"
    let config = HookForm.Rules.empty()
  })

  module Input = {
    @react.component
    let make = (~form) => {
      let (value, setValue) = form->(Field.watch, Field.setValue)

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
              onChange=setValue
              placeholder={`바이어 검색`}
              noOptionsMessage={_ => `검색 결과가 없습니다.`}
              isClearable=true
            />
          </div>
        </div>
      </div>
    }
  }
}

module Status = {
  module Field = Form.MakeInput({
    type t = status
    let name = "status"
    let config = HookForm.Rules.empty()
  })

  module Input = {
    @react.component
    let make = (~form) => {
      let currentValue = form->Field.watch

      <div className=%twc("flex gap-2.5 items-center")>
        <span className=%twc("min-w-fit")> {"상태"->React.string} </span>
        <div className=%twc("flex w-32 xl:w-full")>
          <div>
            <label id="select" className=%twc("block text-sm font-medium text-gray-700") />
            <div className=%twc("relative")>
              <button
                type_="button"
                className={cx([
                  %twc(
                    "relative bg-white border rounded-lg py-1.5 px-3 border-border-default-L1 focus:outline-none focus:ring-1-gl remove-spin-button focus:border-gray-gl"
                  ),
                  %twc("w-44"),
                ])}>
                <span className=%twc("flex items-center text-text-L1")>
                  <span className=%twc("block truncate")>
                    {currentValue->statusToString->React.string}
                  </span>
                </span>
                <span className=%twc("absolute top-0.5 right-1")>
                  <IconArrowSelect height="28" width="28" fill="#121212" />
                </span>
              </button>
              {form->Field.renderController(({field: {onChange, onBlur, ref, name}}) =>
                <select
                  className=%twc("absolute left-0 w-full py-3 opacity-0")
                  name
                  ref
                  onBlur={_ => onBlur()}
                  onChange={e => {
                    let value = (e->ReactEvent.Synthetic.currentTarget)["value"]->Js.Json.string
                    switch value->status_decode {
                    | Ok(decode) => decode->onChange
                    | _ => ()
                    }
                  }}>
                  {statuses
                  ->Array.map(status => {
                    let stringStatus = status->statusToString
                    <option key=stringStatus value=stringStatus>
                      {stringStatus->React.string}
                    </option>
                  })
                  ->React.array}
                </select>
              , ())}
            </div>
          </div>
        </div>
      </div>
    }
  }
}

module Period = {
  module FromField = Form.MakeInput({
    type t = Js.Date.t
    let name = "search-from-date"
    let config = Rules.empty()
  })
  module ToField = Form.MakeInput({
    type t = Js.Date.t
    let name = "search-to-date"
    let config = Rules.empty()
  })
  module Input = {
    type t = From | To
    @react.component
    let make = (~form) => {
      let (from, setFrom) =
        form->(FromField.watch, FromField.setValueWithOption(~shouldValidate=true))
      let (to_, setTo) = form->(ToField.watch, ToField.setValueWithOption(~shouldValidate=true))

      let handleOnChangeDate = (t, e) => {
        let newDate = (e->DuetDatePicker.DuetOnChangeEvent.detail).valueAsDate
        switch (t, newDate) {
        | (From, Some(newDate')) => setFrom(newDate', ())
        | (To, Some(newDate')) => setTo(newDate', ())
        | _ => ()
        }
      }

      let handleOnChangePeriod = d => {
        setTo(Js.Date.make(), ())
        setFrom(d, ())
      }

      <div className=%twc("flex flex-col xl:flex-row gap-4 xl:gap-0")>
        <div className=%twc("flex mr-8")>
          <PeriodSelector from to_={Js.Date.make()} onSelect=handleOnChangePeriod />
        </div>
        <DatePicker
          id="from"
          date={from}
          onChange={handleOnChangeDate(From)}
          maxDate={to_->DateFns.format("yyyy-MM-dd")}
          firstDayOfWeek=0
        />
        <span className=%twc("hidden xl:flex items-center mr-1")> {j`~`->React.string} </span>
        <DatePicker
          id="to"
          date={to_}
          onChange={handleOnChangeDate(To)}
          minDate={from->DateFns.format("yyyy-MM-dd")}
          firstDayOfWeek=0
        />
      </div>
    }
  }
}

module IsFactoring = {
  module Field = Form.MakeInput({
    type t = isFactoring
    let name = "is-factoring"
    let config = HookForm.Rules.empty()
  })
  module Input = {
    @react.component
    let make = (~form) => {
      let currentValue = form->Field.watch

      <div className=%twc("flex gap-2.5 items-center")>
        <span className=%twc("min-w-fit")> {"팩토링 여부"->React.string} </span>
        <div className=%twc("flex w-32 xl:w-full")>
          <div>
            <label id="select" className=%twc("block text-sm font-medium text-gray-700") />
            <div className=%twc("relative")>
              <button
                type_="button"
                className={cx([
                  %twc(
                    "relative bg-white border rounded-lg py-1.5 px-3 border-border-default-L1 focus:outline-none focus:ring-1-gl remove-spin-button focus:border-gray-gl"
                  ),
                  %twc("w-16"),
                ])}>
                <span className=%twc("flex items-center text-text-L1")>
                  <span className=%twc("block truncate")>
                    {currentValue->isFactoringToString->React.string}
                  </span>
                </span>
                <span className=%twc("absolute top-0.5 right-1")>
                  <IconArrowSelect height="28" width="28" fill="#121212" />
                </span>
              </button>
              {form->Field.renderController(({field: {onChange, onBlur, ref, name}}) =>
                <select
                  className=%twc("absolute left-0 w-full py-3 opacity-0")
                  name
                  ref
                  onBlur={_ => onBlur()}
                  onChange={e => {
                    let value = (e->ReactEvent.Synthetic.currentTarget)["value"]->Js.Json.string
                    switch value->isFactoring_decode {
                    | Ok(decode) => decode->onChange
                    | _ => ()
                    }
                  }}>
                  {isFactorings
                  ->Array.map(isFactoring => {
                    let stringStatus = isFactoring->isFactoringToString
                    <option key=stringStatus value=stringStatus>
                      {stringStatus->React.string}
                    </option>
                  })
                  ->React.array}
                </select>
              , ())}
            </div>
          </div>
        </div>
      </div>
    }
  }
}
