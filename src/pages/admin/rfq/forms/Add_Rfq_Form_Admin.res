module Style = {
  let input = %twc(
    "w-full h-[34px] px-3 rounded-lg border border-border-default-L1 focus:outline-none focus:ring-1-gl focus:border-border-active focus:ring-opacity-100 remove-spin-button text-sm text-text-L1"
  )
}

type requestType = [
  | #Purchase
  | #Sale
]

type t = {
  @as("request-type") requestType: requestType,
  @as("requested-from") requestedFrom: string,
  @as("buyer-id") buyerId: string,
  address: string,
}

module FormHandler = HookForm.Make({
  type t = t
})

module RequestType = {
  module Field = FormHandler.MakeInput({
    type t = requestType
    let name = "request-type"
    let config = HookForm.Rules.makeWithErrorMessage({
      required: {value: true, message: `신청 구분을 선택해주세요.`},
    })
  })

  let toString = v => {
    switch v {
    | #Purchase => "purchase"
    | #Sale => "sale"
    }
  }

  let toValue = s => {
    switch s {
    | "purchase" => #Purchase->Some
    | "sale" => #Sale->Some
    | _ => None
    }
  }

  let toLabel = v => {
    switch v {
    | #Purchase => "구매 신청"
    | #Sale => "판매 신청"
    }
  }

  module Select = {
    // 현 시점 판매신청 없음. disabled select로 구매신청 고정
    @react.component
    let make = (~form, ~disabled=false) => {
      form->Field.renderController(({field: {value}}) => {
        let selected = value->toLabel
        <label className=%twc("block relative")>
          <div
            className=%twc(
              "w-full flex items-center h-9 border rounded-lg px-3 py-2 border-border-default-L1 bg-disabled-L3 text-disabled-L1"
            )>
            <span> {selected->React.string} </span>
            <span className=%twc("absolute top-1.5 right-2")>
              <IconArrowSelect height="24" width="24" fill="#b2b2b2" />
            </span>
          </div>
          <select className=%twc("block w-full h-full absolute top-0 opacity-0") disabled>
            {[#Purchase, #Sale]
            ->Array.map(v => {
              let asString = v->toString
              let label = v->toLabel
              <option key=asString value=asString> {label->React.string} </option>
            })
            ->React.array}
          </select>
        </label>
      }, ())
    }
  }
}

module RequestedFrom = {
  module Field = FormHandler.MakeInput({
    type t = string
    let name = "requested-from"
    let config = HookForm.Rules.makeWithErrorMessage({
      required: {value: true, message: `유입경로를 선택해주세요.`},
    })
  })

  type value = [
    | #RFQ
    | #FARMMORNING
    | #PAPERFORM
    | #TELEPHONE
    | #KAKAOTALK
    | #SALES
    | #FINANCE
  ]

  let toString = v => {
    switch v {
    | #RFQ => "rfq"
    | #FARMMORNING => "farmmorning"
    | #PAPERFORM => "paperform"
    | #TELEPHONE => "telephone"
    | #KAKAOTALK => "kakaotalk"
    | #SALES => "sales"
    | #FINANCE => "finance"
    }
  }

  let toValue = s => {
    switch s {
    | "rfq" => #RFQ->Some
    | "farmmorning" => #FARMMORNING->Some
    | "paperform" => #PAPERFORM->Some
    | "telephone" => #TELEPHONE->Some
    | "kakaotalk" => #KAKAOTALK->Some
    | "sales" => #SALES->Some
    | "finance" => #FINANCE->Some
    | _ => None
    }
  }

  let toLabel = v => {
    switch v {
    | #RFQ => `농축수산 rfq를 통한 유입`
    | #FARMMORNING => `팜모닝 판로 개척`
    | #PAPERFORM => `페이퍼 폼`
    | #TELEPHONE => `전화 문의`
    | #KAKAOTALK => `카톡 문의`
    | #SALES => `영업 활동`
    | #FINANCE => `파이낸스`
    }
  }

  module Select = {
    @react.component
    let make = (~form) => {
      form->Field.renderController(({field: {name, value, onChange}}) => {
        let selected = {
          switch value->toValue {
          | Some(v) => v->toLabel
          | None => `유입경로를 선택해주세요.`
          }
        }
        let handleChange = e => {
          (e->ReactEvent.Synthetic.target)["value"]->onChange
        }
        let error = form->Field.error->Option.map(({message}) => message)

        <div className=%twc("relative")>
          <label htmlFor=name className=%twc("block relative")>
            <div
              className=%twc(
                "w-full flex items-center h-9 border border-border-default-L1 rounded-lg px-3 py-2 bg-white"
              )>
              <span className={value == "" ? %twc("text-disabled-L1") : %twc("text-text-L1")}>
                {selected->React.string}
              </span>
              <span className=%twc("absolute top-1.5 right-2")>
                <IconArrowSelect height="24" width="24" fill="#121212" />
              </span>
            </div>
            <select
              name
              className=%twc("block w-full h-full absolute top-0 opacity-0")
              value
              onChange={handleChange}>
              <option value="" disabled=true hidden={value == "" ? false : true}>
                {`미선택`->React.string}
              </option>
              {[#PAPERFORM, #TELEPHONE, #KAKAOTALK, #SALES, #FINANCE]
              ->Array.map(v => {
                let asString = v->toString
                let label = v->toLabel
                <option key=asString value=asString> {label->React.string} </option>
              })
              ->React.array}
            </select>
          </label>
          {error->Option.mapWithDefault(React.null, errMsg =>
            <ErrorText className=%twc("absolute") errMsg />
          )}
        </div>
      }, ())
    }
  }
}

module BuyerId = {
  module Field = FormHandler.MakeInput({
    type t = string
    let name = "buyer-id"
    let config = HookForm.Rules.makeWithErrorMessage({
      required: {value: true, message: `바이어를 검색해주세요..`},
    })
  })

  module Search = {
    @react.component
    let make = (~form) => {
      form->Field.renderController(({field: {onChange}}) => {
        let handleChange = userId => {
          switch userId {
          | None => onChange("")
          | Some(id) => onChange(id)
          }
        }

        let error = form->Field.error->Option.map(({message}) => message)

        <div className=%twc("relative")>
          <SearchBuyer_Admin onSelect=handleChange />
          {error->Option.mapWithDefault(React.null, errMsg =>
            <ErrorText className=%twc("absolute") errMsg />
          )}
        </div>
      }, ())
    }
  }
}

module Address = {
  module Field = FormHandler.MakeInput({
    type t = string
    let name = "address"
    let config = HookForm.Rules.empty()
  })

  module Input = {
    @react.component
    let make = (~form) => {
      let {ref, name, onChange, onBlur} = form->Field.register()
      let error = form->Field.error->Option.map(({message}) => message)

      <div className=%twc("relative")>
        <input
          className=Style.input
          type_="text"
          ref
          name
          placeholder={`배송지를 입력해주세요.`}
          onChange
          onBlur
        />
        {error->Option.mapWithDefault(React.null, errMsg =>
          <ErrorText className=%twc("absolute") errMsg />
        )}
      </div>
    }
  }
}
