module Style = {
  let input = %twc(
    "w-full h-[34px] px-3 rounded-lg border border-border-default-L1 focus:outline-none focus:ring-1-gl focus:border-border-active focus:ring-opacity-100 remove-spin-button text-sm text-text-L1"
  )

  let select = %twc(
    "flex items-center h-[34px] border border-border-default-L1 rounded-lg px-3 py-2 bg-white"
  )
}

type t = {
  category: string, // 표준 카테고리
  amount: string, // 중량 / 수량 / 용량
  @as("amount-unit") amountUnit: string, // 용량 단위
  @as("unit-price") unitPrice: string, // 단위당 희망가
  @as("package-amount") packageAmount: string, // 포장물 수량
  @as("meat-brand-id") meatBrandId: string, // 축산 브랜드
  @as("meat-grade-id") meatGradeId: string, // 축산 등급
  memo: string, // 메모
  origin: string, // 원산지
  @as("previous-price") previousPrice: string, // 기존 납품가
  @as("processing-method") processingMethod: string, // 가공 방식
  @as("requested-delivered-at") requestedDeliveredAt: string, // 희망 배송일
  @as("storage-method") storageMethod: string, // 보관 방식
  @as("trade-cycle") tradeCycle: string, // 거래주기
  usage: string, // 사용 용도
  description: string, // 판매입찰 메모
  @as("is-cross-selling") isCrossSelling: bool,
}

module FormHandler = HookForm.Make({
  type t = t
})

// 중량
module Amount = {
  module Field = FormHandler.MakeInput({
    type t = string
    let name = "amount"
    let config = HookForm.Rules.makeWithErrorMessage({
      required: {value: true, message: `중량을 입력해주세요.`},
      pattern: {
        value: %re("/^[0-9]*\.?[0-9]*$/"),
        message: `숫자만 입력 가능`,
      },
    })
  })

  module Input = {
    @react.component
    let make = (~form) => {
      let {ref, name, onChange, onBlur} = form->Field.register()
      let error = form->Field.error->Option.map(({message}) => message)

      <div className=%twc("relative")>
        <input className=Style.input type_="text" ref name placeholder={`0`} onChange onBlur />
        {error->Option.mapWithDefault(React.null, errMsg =>
          <ErrorText className=%twc("absolute") errMsg />
        )}
      </div>
    }
  }
}

// 중량 단위
module AmountUnit = {
  module Field = FormHandler.MakeInput({
    type t = string
    let name = "amount-unit"
    let config = HookForm.Rules.makeWithErrorMessage({
      required: {value: true, message: `중량 단위를 입력해주세요.`},
    })
  })

  type t = [
    | #G
    | #KG
    | #T
    | #EA
    | #ML
    | #L
  ]

  let toString = v => {
    switch v {
    | #G => "g"
    | #KG => "kg"
    | #T => "t"
    | #EA => "ea"
    | #ML => "ml"
    | #L => "l"
    | _ => ""
    }
  }

  let toValue = s => {
    switch s {
    | "g" => #G->Some
    | "kg" => #KG->Some
    | "t" => #T->Some
    | "ea" => #EA->Some
    | "ml" => #ML->Some
    | "l" => #L->Some
    | _ => None
    }
  }

  module Select = {
    @react.component
    let make = (~className=%twc(""), ~form) => {
      form->Field.renderController(({field: {value, onChange}}) => {
        let handleChange = e => {
          (e->ReactEvent.Synthetic.target)["value"]->onChange
        }
        <label className={cx([%twc("w-[72px] block relative"), className])}>
          <div className=Style.select>
            <span> {value->React.string} </span>
            <span className=%twc("absolute top-1.5 right-2")>
              <IconArrowSelect height="24" width="24" fill="#121212" />
            </span>
          </div>
          <select
            className=%twc("block w-full h-full absolute top-0 opacity-0") onChange=handleChange>
            <option value="" disabled=true hidden={value == "" ? false : true}>
              {`미선택`->React.string}
            </option>
            {[#G, #KG, #T, #EA, #ML, #L]
            ->Array.map(v => {
              let asString = v->toString
              <option key=asString value=asString> {asString->React.string} </option>
            })
            ->React.array}
          </select>
        </label>
      }, ())
    }
  }
}

// 단위당 희망가
module UnitPrice = {
  module Field = FormHandler.MakeInput({
    type t = string
    let name = "unit-price"
    let config = HookForm.Rules.makeWithErrorMessage({
      required: {value: true, message: `단위당 희망가를 입력해주세요.`},
      pattern: {
        value: %re("/^([0-9]{1,})$/"),
        message: `숫자만 입력 가능`,
      },
    })
  })

  module Input = {
    @react.component
    let make = (~form) => {
      let {ref, name, onChange, onBlur} = form->Field.register()
      let error = form->Field.error->Option.map(({message}) => message)

      <div className=%twc("relative w-full")>
        <div className=%twc("flex items-center")>
          <input className=Style.input type_="text" ref name placeholder={`0`} onChange onBlur />
          <span className=%twc("ml-1")> {`원`->React.string} </span>
        </div>
        {error->Option.mapWithDefault(React.null, errMsg =>
          <ErrorText className=%twc("absolute") errMsg />
        )}
      </div>
    }
  }
}

// 포장물 수량
module PackageAmount = {
  module Field = FormHandler.MakeInput({
    type t = string
    let name = "package-amount"
    let config = HookForm.Rules.makeWithErrorMessage({
      pattern: {
        value: %re("/^([0-9]{1,})$/"),
        message: `숫자만 입력 가능합니다.`,
      },
    })
  })

  module Input = {
    @react.component
    let make = (~form) => {
      let {ref, name, onChange, onBlur} = form->Field.register()
      let error = form->Field.error->Option.map(({message}) => message)

      <div className=%twc("relative w-full")>
        <input className=Style.input type_="text" ref name placeholder={`0`} onChange onBlur />
        {error->Option.mapWithDefault(React.null, errMsg =>
          <ErrorText className=%twc("absolute") errMsg />
        )}
      </div>
    }
  }
}

// 가공 방식
module ProcessingMethod = {
  module Field = FormHandler.MakeInput({
    type t = string
    let name = "processing-method"
    let config = HookForm.Rules.empty()
  })

  module Input = {
    @react.component
    let make = (~form) => {
      let {ref, name, onChange, onBlur} = form->Field.register()
      let error = form->Field.error->Option.map(({message}) => message)

      <div className=%twc("relative w-full")>
        <input
          className=Style.input
          type_="text"
          ref
          name
          placeholder={`가공방식을 입력해주세요.`}
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

// 보관 방식
module StorageMethod = {
  module Field = FormHandler.MakeInput({
    type t = string
    let name = "storage-method"
    let config = HookForm.Rules.empty()
  })

  type t = [
    | #AMBIENT
    | #CHILLED
    | #FROZEN
    | #FREEZE_DRIED
  ]

  let toString = v => {
    switch v {
    | #AMBIENT => "ambient"
    | #CHILLED => "chilled"
    | #FROZEN => "frozen"
    | #FREEZE_DRIED => "freeze_dried"
    | _ => ""
    }
  }

  let toValue = s => {
    switch s {
    | "ambient" => #AMBIENT->Some
    | "chilled" => #CHILLED->Some
    | "frozen" => #FROZEN->Some
    | "freeze_dried" => #FREEZE_DRIED->Some
    | _ => None
    }
  }

  let toLabel = v => {
    switch v {
    | #AMBIENT => `상온`
    | #CHILLED => `냉장`
    | #FROZEN => `냉동`
    | #FREEZE_DRIED => `동결`
    }
  }

  module Select = {
    @react.component
    let make = (~form) => {
      form->Field.renderController(({field: {value, onChange}}) => {
        let selected = {
          switch value->toValue {
          | Some(v) => v->toLabel
          | None => `미선택`
          }
        }

        let handleChange = e => {
          (e->ReactEvent.Synthetic.target)["value"]->onChange
        }

        <label className=%twc("block relative w-full")>
          <div className=Style.select>
            <span className={value == "" ? %twc("text-disabled-L1") : %twc("text-text-L1")}>
              {selected->React.string}
            </span>
            <span className=%twc("absolute top-1.5 right-2")>
              <IconArrowSelect height="24" width="24" fill="#121212" />
            </span>
          </div>
          <select
            value
            className=%twc("block w-full h-full absolute top-0 opacity-0")
            onChange=handleChange>
            <option value="" disabled=true hidden={value == "" ? false : true}>
              {`미선택`->React.string}
            </option>
            {[#AMBIENT, #CHILLED, #FROZEN, #FREEZE_DRIED]
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

// 희망 배송일
module RequestedDeliveredAt = {
  module Field = FormHandler.MakeInput({
    type t = string
    let name = "requested-delivered-at"
    let config = HookForm.Rules.empty()
  })

  let today = Js.Date.make()
  let toString = d => d->DateFns.format("yyyy-MM-dd")
  let toDate = s => s->Js.Date.fromString

  module DateInput = {
    @react.component
    let make = (~form) => {
      form->Field.renderController(({field: {value, onChange}}) => {
        let _value = {
          switch value {
          | "" => None
          | nonEmptyString => nonEmptyString->toDate->Some
          }
        }

        let handleChange = e => {
          (e->DuetDatePicker.DuetOnChangeEvent.detail).value->onChange
        }

        <DatePicker
          id="from"
          date=?{_value}
          minDate={today->toString}
          firstDayOfWeek=0
          onChange=handleChange
          localization={
            ...DuetDatePicker.krLocalization,
            placeholder: "미선택",
          }
        />
      }, ())
    }
  }
}

// 원산지
module Origin = {
  module Field = FormHandler.MakeInput({
    type t = string
    let name = "origin"
    let config = HookForm.Rules.empty()
  })

  type t = [
    | #KR
    | #OTHER
    | #US
    | #AU
    | #CA
    | #NZ
  ]

  let toString = v => {
    switch v {
    | #KR => "kr"
    | #OTHER => "other"
    | #US => "us"
    | #AU => "au"
    | #CA => "ca"
    | #NZ => "nz"
    | _ => ""
    }
  }

  let toValue = s => {
    switch s {
    | "kr" => #KR->Some
    | "other" => #OTHER->Some
    | "us" => #US->Some
    | "au" => #AU->Some
    | "ca" => #CA->Some
    | "nz" => #NZ->Some
    | _ => None
    }
  }

  let toLabel = v => {
    switch v {
    | #KR => "국내산"
    | #OTHER => "수입산"
    | #US => "미국산"
    | #AU => "호주산"
    | #CA => "캐나다산"
    | #NZ => "뉴질랜드산"
    }
  }

  module Select = {
    @react.component
    let make = (~form) => {
      form->Field.renderController(({field: {value, onChange}}) => {
        let selected = {
          switch value->toValue {
          | Some(v) => v->toLabel
          | None => `미선택`
          }
        }

        let handleChange = e => {
          (e->ReactEvent.Synthetic.target)["value"]->onChange
        }
        <label className=%twc("block relative w-full")>
          <div className=Style.select>
            <span className={value == "" ? %twc("text-disabled-L1") : %twc("text-text-L1")}>
              {selected->React.string}
            </span>
            <span className=%twc("absolute top-1.5 right-2")>
              <IconArrowSelect height="24" width="24" fill="#121212" />
            </span>
          </div>
          <select
            value
            className=%twc("block w-full h-full absolute top-0 opacity-0")
            onChange=handleChange>
            <option value="" disabled=true hidden={value == "" ? false : true}>
              {`미선택`->React.string}
            </option>
            {[#KR, #OTHER, #US, #AU, #CA, #NZ]
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

// 축산 등급
module MeatGrade = {
  module Field = FormHandler.MakeInput({
    type t = string
    let name = "meat-grade-id"
    let config = HookForm.Rules.empty()
  })

  module Select = {
    @react.component
    let make = (~form) => {
      form->Field.renderController(({field: {value, onChange}}) => {
        <React.Suspense fallback={<Select_MeatGrade_Admin.Sekeleton className=%twc("w-full") />}>
          <Select_MeatGrade_Admin className=%twc("w-full") value onChange />
        </React.Suspense>
      }, ())
    }
  }
}

// 축산 브랜드
module MeatBrand = {
  module Field = FormHandler.MakeInput({
    type t = string
    let name = "meat-brand-id"
    let config = HookForm.Rules.empty()
  })

  module Select = {
    @react.component
    let make = (~form) => {
      form->Field.renderController(({field: {value, onChange}}) => {
        <React.Suspense fallback={<Select_MeatBrand_Admin.Sekeleton className=%twc("w-full") />}>
          <Select_MeatBrand_Admin value onChange className=%twc("w-full") />
        </React.Suspense>
      }, ())
    }
  }
}

// 사용 용도
module Usage = {
  module Field = FormHandler.MakeInput({
    type t = string
    let name = "usage"
    let config = HookForm.Rules.empty()
  })

  module Input = {
    @react.component
    let make = (~form) => {
      let {ref, name, onChange, onBlur} = form->Field.register()
      let error = form->Field.error->Option.map(({message}) => message)

      <div className=%twc("relative w-full")>
        <input
          className=Style.input
          type_="text"
          ref
          name
          placeholder={`사용 용도를 입력해주세요.`}
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

// 거래 주기
module TradeCycle = {
  module Field = FormHandler.MakeInput({
    type t = string
    let name = "trade-cycle"
    let config = HookForm.Rules.empty()
  })

  type t = [
    | #DAILY
    | #WEEKLY_3TO5
    | #WEEKLY_1TO2
    | #MONTHLY_1TO2
    | #ONCE
  ]

  let toString = v => {
    switch v {
    | #DAILY => "daily"
    | #WEEKLY_3TO5 => "weekly_3to5"
    | #WEEKLY_1TO2 => "weekly_1to2"
    | #MONTHLY_1TO2 => "monthly_1to2"
    | #ONCE => "once"
    | _ => ""
    }
  }

  let toValue = s => {
    switch s {
    | "daily" => #DAILY->Some
    | "weekly_3to5" => #WEEKLY_3TO5->Some
    | "weekly_1to2" => #WEEKLY_1TO2->Some
    | "monthly_1to2" => #MONTHLY_1TO2->Some
    | "once" => #ONCE->Some
    | _ => None
    }
  }

  let toLabel = v => {
    switch v {
    | #DAILY => "매일"
    | #WEEKLY_3TO5 => "주 3~5회"
    | #WEEKLY_1TO2 => "주 1~2회"
    | #MONTHLY_1TO2 => "월 1~2회"
    | #ONCE => "일회성 주문"
    }
  }

  module Select = {
    @react.component
    let make = (~form) => {
      form->Field.renderController(({field: {value, onChange}}) => {
        let selected = {
          switch value->toValue {
          | Some(v) => v->toLabel
          | None => `미선택`
          }
        }
        let handleChange = e => {
          (e->ReactEvent.Synthetic.target)["value"]->onChange
        }
        <label className=%twc("block relative w-full")>
          <div className=Style.select>
            <span className={value == "" ? %twc("text-disabled-L1") : %twc("text-text-L1")}>
              {selected->React.string}
            </span>
            <span className=%twc("absolute top-1.5 right-2")>
              <IconArrowSelect height="24" width="24" fill="#121212" />
            </span>
          </div>
          <select
            value
            className=%twc("block w-full h-full absolute top-0 opacity-0")
            onChange=handleChange>
            <option value="" disabled=true hidden={value == "" ? false : true}>
              {`미선택`->React.string}
            </option>
            {[#DAILY, #WEEKLY_3TO5, #WEEKLY_1TO2, #MONTHLY_1TO2, #ONCE]
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

// 기존 납품가
module PreviousPrice = {
  module Field = FormHandler.MakeInput({
    type t = string
    let name = "previous-price"
    let config = HookForm.Rules.makeWithErrorMessage({
      pattern: {
        value: %re("/^([0-9]{1,})$/"),
        message: `숫자만 입력 가능합니다.`,
      },
    })
  })

  module Input = {
    @react.component
    let make = (~form) => {
      let {ref, name, onChange, onBlur} = form->Field.register()
      let error = form->Field.error->Option.map(({message}) => message)

      <div className=%twc("relative w-full")>
        <div className=%twc("flex items-center")>
          <input className=Style.input type_="text" ref name placeholder={`0`} onChange onBlur />
          <span className=%twc("ml-1")> {`원`->React.string} </span>
        </div>
        {error->Option.mapWithDefault(React.null, errMsg =>
          <ErrorText className=%twc("absolute") errMsg />
        )}
      </div>
    }
  }
}

// 메모
module Memo = {
  module Field = FormHandler.MakeInput({
    type t = string
    let name = "memo"
    let config = HookForm.Rules.empty()
  })

  module Input = {
    @react.component
    let make = (~form) => {
      let {ref, name, onChange, onBlur} = form->Field.register()

      <textarea
        className=%twc(
          "p-3 w-full h-[100px] border border-border-default-L1 rounded-lg focus:outline-none focus:border-border-active resize-none"
        )
        ref
        name
        placeholder={`메모 입력(최대 1,000자)`}
        maxLength=1000
        onChange
        onBlur
      />
    }
  }
}

module Description = {
  module Field = FormHandler.MakeInput({
    type t = string
    let name = "description"
    let config = HookForm.Rules.empty()
  })

  module Input = {
    @react.component
    let make = (~form) => {
      let {ref, name, onChange, onBlur} = form->Field.register()

      <textarea
        className=%twc(
          "p-3 w-full h-[100px] border border-border-default-L1 rounded-lg focus:outline-none focus:border-border-active resize-none"
        )
        ref
        name
        placeholder={`팜모닝 판매입찰에 노출되는 메모 입력(최대 1,000자)`}
        maxLength=1000
        onChange
        onBlur
      />
    }
  }
}

module Category = {
  module Field = FormHandler.MakeInput({
    type t = string
    let name = "category"
    let config = HookForm.Rules.makeWithErrorMessage({
      required: {value: true, message: `카테고리를 선택해주세요.`},
    })
  })

  module CategorySelectHandler = {
    @react.component
    let make = (~value, ~onChange, ~disabled=?, ~defaultValue=?) => {
      let (value_, setValue_) = React.Uncurried.useState(_ =>
        switch defaultValue {
        | Some(defaultValue') => defaultValue'
        | None => Select_Category_Admin.Spec.Value.default
        }
      )

      let handleChange = nextValue => {
        setValue_(._ => nextValue)
        let (_, _, _, _, v5) = nextValue

        switch v5 {
        | ReactSelect.Selected(nextV5) if value != nextV5.value => nextV5.value->onChange
        | ReactSelect.NotSelected if value != "" => ""->onChange
        | _ => ()
        }
      }

      <Select_Category_Admin value=value_ onChange=handleChange ?disabled />
    }
  }

  module Select = {
    @react.component
    let make = (~form, ~disabled=?) => {
      form->Field.renderController(({field: {value, onChange}}) => {
        let error = form->Field.error->Option.map(({message}) => message)

        <div className=%twc("mt-2")>
          <React.Suspense fallback={React.null}>
            <CategorySelectHandler value onChange ?disabled />
            {error->Option.mapWithDefault(React.null, errMsg =>
              <ErrorText className=%twc("absolute") errMsg />
            )}
          </React.Suspense>
        </div>
      }, ())
    }
  }

  module ReadOnly = {
    @react.component
    let make = (~categoryId) => {
      let initCategory = Select_Category_Admin.RestoreFromApi.use(categoryId)

      <div className=%twc("mt-2")>
        <React.Suspense fallback={React.null}>
          <Select_Category_Admin value=initCategory onChange={_ => ()} disabled=true />
        </React.Suspense>
      </div>
    }
  }
}

// 크로스셀링
module IsCrossSelling = {
  module Field = FormHandler.MakeInput({
    type t = bool
    let name = "is-cross-selling"
    let config = HookForm.Rules.empty()
  })

  module Checkbox = {
    @react.component
    let make = (~form, ~disabled=false) => {
      form->Field.renderController(({field: {value, onChange}}) => {
        let onClick = _ => onChange(!value)
        <button type_="button" className=%twc("flex items-center") onClick disabled>
          <Rfq_CheckIcon_Admin value disabled />
          <span className=%twc("ml-2 text-[15px]")> {`크로스셀링`->React.string} </span>
        </button>
      }, ())
    }
  }
}
