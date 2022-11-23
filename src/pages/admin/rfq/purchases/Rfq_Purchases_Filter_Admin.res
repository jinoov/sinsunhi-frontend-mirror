module Form = {
  type fields = {
    @as("manager-name") managerName: string,
    @as("product-name") productName: string,
    @as("to") to_: string,
    from: string,
    status: string,
  }

  module FormHandler = HookForm.Make({
    type t = fields
  })

  // 담당자 이름
  module ManagerName = {
    module Field = FormHandler.MakeInput({
      type t = string
      let name = "manager-name"
      let config = HookForm.Rules.empty()
    })

    module Input = {
      @react.component
      let make = (~form) => {
        let {ref, name, onChange, onBlur} = form->Field.register()
        let error = form->Field.error->Option.map(({message}) => message)

        <div className=%twc("flex items-center text-sm ")>
          <span className=%twc("mr-2")> {`담당자명`->React.string} </span>
          <Input
            className=%twc("w-[180px]")
            inputRef=ref
            type_="text"
            name
            placeholder={`담당자 입력`}
            size=Input.Small
            onChange
            onBlur
            error
          />
        </div>
      }
    }
  }

  // 상품명
  module ProductName = {
    module Field = FormHandler.MakeInput({
      type t = string
      let name = "product-name"
      let config = HookForm.Rules.empty()
    })

    module Input = {
      @react.component
      let make = (~form) => {
        let {ref, name, onChange, onBlur} = form->Field.register()
        let error = form->Field.error->Option.map(({message}) => message)

        <div className=%twc("ml-12 flex items-center text-sm")>
          <span className=%twc("mr-2")> {`품목/품종`->React.string} </span>
          <Input
            className=%twc("w-[420px]")
            inputRef=ref
            type_="text"
            name
            size=Input.Small
            error
            placeholder={`폼목, 품종명 입력`}
            onChange
            onBlur
          />
        </div>
      }
    }
  }

  // 기간
  module Period = {
    module FromField = FormHandler.MakeInput({
      type t = string
      let name = "from"
      let config = HookForm.Rules.empty()
    })

    module ToField = FormHandler.MakeInput({
      type t = string
      let name = "to"
      let config = HookForm.Rules.empty()
    })

    let today = Js.Date.make()
    let toString = d => d->DateFns.format("yyyy-MM-dd")
    let toDate = s => s->Js.Date.fromString

    module Picker = {
      @react.component
      let make = (~form) => {
        form->FromField.renderController(({field: {value: fromValue, onChange: onChangeFrom}}) => {
          form->ToField.renderController(({field: {value: toValue, onChange: onChangeTo}}) => {
            let onSelectChange = from => {
              from->toString->onChangeFrom
              today->toString->onChangeTo
            }

            let makeOnChange = (fn, e) => {
              (e->DuetDatePicker.DuetOnChangeEvent.detail).value->fn
            }

            <>
              <div>
                <PeriodSelector
                  from={fromValue->toDate} to_={toValue->toDate} onSelect=onSelectChange
                />
              </div>
              <div className=%twc("ml-2 flex items-center")>
                <DatePicker
                  id="from"
                  date={fromValue->toDate}
                  onChange={makeOnChange(onChangeFrom)}
                  maxDate={toValue}
                  firstDayOfWeek=0
                />
                <span className=%twc("flex items-center mr-1")> {j`~`->React.string} </span>
                <DatePicker
                  id="to"
                  date={toValue->toDate}
                  onChange={makeOnChange(onChangeTo)}
                  maxDate={today->toString}
                  minDate={fromValue}
                  firstDayOfWeek=0
                />
              </div>
            </>
          }, ())
        }, ())
      }
    }
  }

  module Status = {
    module Field = FormHandler.MakeInput({
      type t = string
      let name = "status"
      let config = HookForm.Rules.empty()
    })

    let toString = v => {
      switch v {
      | #All => "all"
      | #WAIT => "wait"
      | #SOURCING => "sourcing"
      | #SOURCED => "sourced"
      | #SOURCING_FAIL => "sourcing-failed"
      | #MATCHING => "matching"
      | #COMPLETE => "complete"
      | #FAIL => "fail"
      | _ => ""
      }
    }

    let toLabel = v => {
      switch v {
      | #All => `전체`
      | #WAIT => `컨택 대기`
      | #SOURCING => `소싱 진행`
      | #SOURCED => `소싱 성공`
      | #SOURCING_FAIL => `소싱 실패`
      | #MATCHING => "매칭 진행"
      | #COMPLETE => `매칭 성공`
      | #FAIL => `매칭 실패`
      | _ => ""
      }
    }

    let toValue = s => {
      switch s {
      | "all" => #All->Some
      | "wait" => #WAIT->Some
      | "sourcing" => #SOURCING->Some
      | "sourced" => #SOURCED->Some
      | "sourcing-failed" => #SOURCING_FAIL->Some
      | "matching" => #MATCHING->Some
      | "complete" => #COMPLETE->Some
      | "fail" => #FAIL->Some
      | _ => None
      }
    }

    module Select = {
      @react.component
      let make = (~form) => {
        form->Field.renderController(({field: {value, onChange}}) => {
          let handleChange = e => {
            (e->ReactEvent.Synthetic.target)["value"]->onChange
          }
          <label className=%twc("block relative")>
            <div
              className=%twc(
                "flex items-center w-[180px] h-9 border border-border-default-L1 rounded-lg px-3 py-2 bg-white"
              )>
              <span> {value->toValue->Option.mapWithDefault("", toLabel)->React.string} </span>
              <span className=%twc("absolute top-1.5 right-2")>
                <IconArrowSelect height="24" width="24" fill="#121212" />
              </span>
            </div>
            <select
              className=%twc("block w-full h-full absolute top-0 opacity-0")
              value
              onChange=handleChange>
              {[#All, #WAIT, #SOURCING, #SOURCED, #SOURCING_FAIL, #MATCHING, #COMPLETE, #FAIL]
              ->Array.map(v => {
                let asString = v->toString
                <option key=asString value=asString> {v->toLabel->React.string} </option>
              })
              ->React.array}
            </select>
          </label>
        }, ())
      }
    }
  }
}

module Row = {
  @react.component
  let make = (~className=?, ~title, ~children) => {
    <div className={%twc("flex items-center ") ++ className->Option.getWithDefault("")}>
      <span className=%twc("min-w-[100px] font-bold text-sm")> {title->React.string} </span>
      children
    </div>
  }
}

let set = (dict, k, v) => {
  let new = dict
  new->Js.Dict.set(k, v)
  new
}

let initFilter: Form.fields = {
  managerName: "",
  productName: "",
  from: Js.Date.make()->DateFns.subDays(7)->Form.Period.toString,
  to_: Js.Date.make()->Form.Period.toString,
  status: "all",
}

@react.component
let make = () => {
  let {useRouter, push} = module(Next.Router)
  let router = useRouter()

  let form = Form.FormHandler.use(
    ~config={
      defaultValues: initFilter,
      mode: #onChange,
    },
  )

  let reset = _ => {
    form->Form.FormHandler.reset(initFilter)
  }

  let onSubmit = form->Form.FormHandler.handleSubmit((
    {managerName, productName, from, to_, status},
    _,
  ) => {
    let {makeWithDict, toString} = module(Webapi.Url.URLSearchParams)
    let newQueryString = {
      router.query
      ->set("manager-name", managerName->Js.Global.encodeURIComponent)
      ->set("product-name", productName->Js.Global.encodeURIComponent)
      ->set("from", from)
      ->set("to", to_)
      ->set("status", status)
      ->set("offset", "0") // 필터 조건이 바뀌면 offset 초기화
      ->makeWithDict
      ->toString
    }
    router->push(`${router.pathname}?${newQueryString}`)
  })

  React.useEffect2(() => {
    let managerName =
      router.query
      ->Js.Dict.get("manager-name")
      ->Option.mapWithDefault("", Js.Global.decodeURIComponent)

    let productName =
      router.query
      ->Js.Dict.get("product-name")
      ->Option.mapWithDefault("", Js.Global.decodeURIComponent)

    let from =
      router.query
      ->Js.Dict.get("from")
      ->Option.mapWithDefault(Js.Date.make()->DateFns.subDays(7)->Form.Period.toString, from' => {
        from'->Js.Date.fromString->Form.Period.toString
      })

    let to_ =
      router.query
      ->Js.Dict.get("to")
      ->Option.mapWithDefault(Js.Date.make()->Form.Period.toString, from' => {
        from'->Js.Date.fromString->Form.Period.toString
      })

    let status = router.query->Js.Dict.get("status")->Option.getWithDefault("all")

    form->Form.FormHandler.reset({
      managerName,
      productName,
      from,
      to_,
      status,
    })

    None
  }, (router.query, form))

  <form onSubmit>
    <div className=%twc("mt-5 w-full bg-gray-50 rounded-lg px-7 py-6")>
      <Row title={`검색`}>
        <Form.ManagerName.Input form />
        <Form.ProductName.Input form />
      </Row>
      <Row title={`기간`} className=%twc("mt-3")>
        <Form.Period.Picker form />
      </Row>
      <Row title={`진행상태`} className=%twc("mt-3")>
        <Form.Status.Select form />
      </Row>
    </div>
    <div className=%twc("mt-5 w-full flex items-center justify-center")>
      <button
        type_="button"
        onClick={reset}
        className=%twc("px-3 py-[6px] text-[15px] bg-gray-100 rounded-lg")>
        {`초기화`->React.string}
      </button>
      <button
        type_="submit"
        className=%twc(
          "ml-[10px] px-3 py-[6px] text-[15px] text-white rounded-lg bg-primary hover:bg-primary-variant"
        )>
        {`검색`->React.string}
      </button>
    </div>
  </form>
}
