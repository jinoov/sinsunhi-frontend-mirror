module Style = {
  let input = %twc(
    "w-full h-[34px] px-3 rounded-lg border border-border-default-L1 focus:outline-none focus:ring-1-gl focus:border-border-active focus:ring-opacity-100 remove-spin-button text-sm text-text-L1"
  )

  let error = %twc("absolute top-1/2 -translate-y-1/2 -left-6")

  let selected = %twc(
    "flex items-center h-[34px] border border-border-default-L1 rounded-lg px-3 py-2 bg-white"
  )
}

type value<'a> =
  | Valid('a) // value
  | Invalid({value: 'a, message: string}) // err msg

module Pattern = {
  type t = {
    re: Js.Re.t,
    message: string,
  }

  let notEmpty = %re("/^(?!\s*$).+/")
  let int = %re("/^([0-9]{0,})$/")
  let float = %re("/([0-9]*[.])?[0-9]+/")

  let getMatched = (str, regex) => {
    Js.Re.exec_(regex, str)->Option.flatMap(result => {
      result->Js.Re.captures->Array.keepMap(Js.Nullable.toOption)->List.fromArray->List.head
    })
  }

  let validate = (value, patterns) => {
    let results = patterns->Array.map(({re, message}) => {
      switch getMatched(value, re) {
      | Some(value') => value'
      | None => message
      }
    })

    results
    ->Array.getBy(result => result != value)
    ->Option.mapWithDefault(Valid(value), message => Invalid({value, message}))
  }
}

let toString = s => {
  switch s {
  | Valid(value) => value
  | Invalid({value}) => value
  }
}

let update = (v, setFn, changeFn) => {
  setFn(._ => v)
  v->changeFn
}

module Amount = {
  let makeDefault = amount => amount->Float.toString->Valid

  let patterns: array<Pattern.t> = [
    // {re: Pattern.notEmpty, message: "중량 입력."},
    {re: Pattern.float, message: "숫자만 입력 가능."},
  ]

  @react.component
  let make = (~defaultValue=Valid(""), ~onChange) => {
    let (value, setValue) = React.Uncurried.useState(_ => defaultValue)
    let (error, setError) = React.Uncurried.useState((_): option<string> => None)

    let handleChange = e => {
      switch (e->ReactEvent.Synthetic.currentTarget)["value"]->Pattern.validate(patterns) {
      | Valid(v) => {
          setError(._ => None)
          v->Valid->update(setValue, onChange)
        }

      | Invalid(e) => {
          setError(._ => Some(e.message))
          e->Invalid->update(setValue, onChange)
        }
      }
    }

    <div className=%twc("relative w-full")>
      <input
        type_="text"
        className={Style.input}
        value={value->toString}
        onChange=handleChange
        placeholder="0"
      />
      {error->Option.mapWithDefault(React.null, _ => <ErrorText className=Style.error errMsg="" />)}
    </div>
  }
}

module UnitPrice = {
  let makeDefault = unitPrice => unitPrice->Int.toString->Valid

  let patterns: array<Pattern.t> = [
    // {re: Pattern.notEmpty, message: "단위당 희망가 입력."},
    {re: Pattern.int, message: "숫자만 입력 가능."},
  ]

  @react.component
  let make = (~defaultValue=Valid(""), ~onChange) => {
    let (value, setValue) = React.Uncurried.useState(_ => defaultValue)
    let (error, setError) = React.Uncurried.useState((_): option<string> => None)

    let update = v => {
      setValue(._ => v)
      v->onChange
    }

    let handleChange = e => {
      switch (e->ReactEvent.Synthetic.currentTarget)["value"]->Pattern.validate(patterns) {
      | Valid(v) => {
          setError(._ => None)
          v->Valid->update
        }

      | Invalid(e) => {
          setError(._ => Some(e.message))
          e->Invalid->update
        }
      }
    }

    <div className=%twc("relative w-full")>
      <input
        type_="text"
        className={Style.input}
        value={value->toString}
        onChange=handleChange
        placeholder="0"
      />
      {error->Option.mapWithDefault(React.null, _ => <ErrorText className=Style.error errMsg="" />)}
    </div>
  }
}

module SellerPrice = {
  let makeDefault = sellerPrice => sellerPrice->Option.mapWithDefault("", Int.toString)->Valid

  let patterns: array<Pattern.t> = [
    // {re: Pattern.notEmpty, message: "샐러 공급가 입력."},
    {re: Pattern.int, message: "숫자만 입력 가능."},
  ]

  @react.component
  let make = (~defaultValue=Valid(""), ~onChange) => {
    let (value, setValue) = React.Uncurried.useState(_ => defaultValue)
    let (error, setError) = React.Uncurried.useState((_): option<string> => None)

    let update = v => {
      setValue(._ => v)
      v->onChange
    }

    let handleChange = e => {
      switch (e->ReactEvent.Synthetic.currentTarget)["value"]->Pattern.validate(patterns) {
      | Valid(v) => {
          setError(._ => None)
          v->Valid->update
        }

      | Invalid(e) => {
          setError(._ => Some(e.message))
          e->Invalid->update
        }
      }
    }

    <div className=%twc("relative w-full")>
      <input
        type_="text"
        className={Style.input}
        value={value->toString}
        onChange=handleChange
        placeholder="0"
      />
      {error->Option.mapWithDefault(React.null, _ => <ErrorText className=Style.error errMsg="" />)}
    </div>
  }
}

module DeliveryFee = {
  let makeDefault = deliveryFee => deliveryFee->Option.mapWithDefault("", Int.toString)->Valid

  let patterns: array<Pattern.t> = [
    // {re: Pattern.notEmpty, message: "배송비 입력."},
    {re: Pattern.int, message: "숫자만 입력 가능."},
  ]

  @react.component
  let make = (~defaultValue=Valid(""), ~onChange) => {
    let (value, setValue) = React.Uncurried.useState(_ => defaultValue)
    let (error, setError) = React.Uncurried.useState((_): option<string> => None)

    let update = v => {
      setValue(._ => v)
      v->onChange
    }

    let handleChange = e => {
      switch (e->ReactEvent.Synthetic.currentTarget)["value"]->Pattern.validate(patterns) {
      | Valid(v) => {
          setError(._ => None)
          v->Valid->update
        }

      | Invalid(e) => {
          setError(._ => Some(e.message))
          e->Invalid->update
        }
      }
    }

    <div className=%twc("relative w-full")>
      <input
        type_="text"
        className={Style.input}
        value={value->toString}
        onChange=handleChange
        placeholder="0"
      />
      {error->Option.mapWithDefault(React.null, _ => <ErrorText className=Style.error errMsg="" />)}
    </div>
  }
}

module DeliveryMethod = {
  let toString = v => {
    switch v {
    | #FREIGHT => "freight"
    | #COURIER => "courier"
    | #SELLER_DELIVERY => "seller-delivery"
    | #BUYER_TAKE => "buyer-take"
    | _ => ""
    }
  }

  let toValue = s => {
    switch s {
    | "freight" => #FREIGHT->Some
    | "courier" => #COURIER->Some
    | "seller-delivery" => #SELLER_DELIVERY->Some
    | "buyer-take" => #BUYER_TAKE->Some
    | _ => None
    }
  }

  let toLabel = v => {
    switch v {
    | #FREIGHT => "화물배송"
    | #COURIER => "택배배송"
    | #SELLER_DELIVERY => "자체물류"
    | #BUYER_TAKE => "바이어 직접 수령"
    | _ => "배송 방법 선택"
    }
  }

  let makeDefault = deliveryMethod => deliveryMethod->Option.mapWithDefault("", toString)->Valid

  @react.component
  let make = (~defaultValue=Valid(""), ~onChange) => {
    let (value, setValue) = React.Uncurried.useState(_ => defaultValue)

    let selected = {
      switch value {
      | Valid(v) => v
      | Invalid({value}) => value
      }
    }

    let update = v => {
      setValue(._ => v)
      v->onChange
    }

    let handleChange = e => {
      (e->ReactEvent.Synthetic.target)["value"]->Valid->update
    }

    <label className=%twc("block relative w-full")>
      <div className=Style.selected>
        <span className={selected == "" ? %twc("text-disabled-L1") : %twc("text-text-L1")}>
          {selected->toValue->Option.mapWithDefault("배송 방법 선택", toLabel)->React.string}
        </span>
        <span className=%twc("absolute top-1.5 right-2")>
          <IconArrowSelect height="24" width="24" fill="#121212" />
        </span>
      </div>
      <select
        value=selected
        className=%twc("block w-full h-full absolute top-0 opacity-0")
        onChange=handleChange>
        <option value="" disabled=true hidden={selected == "" ? false : true}>
          {`배송 방법 선택`->React.string}
        </option>
        {[#FREIGHT, #COURIER, #SELLER_DELIVERY, #BUYER_TAKE]
        ->Array.map(v => {
          let asString = v->toString
          let label = v->toLabel
          <option key=asString value=asString> {label->React.string} </option>
        })
        ->React.array}
      </select>
    </label>
  }
}

module Status = {
  let toString = v => {
    switch v {
    | #WAIT => "wait"
    | #SOURCING => "sourcing"
    | #SOURCED => "sourced"
    | #SOURCING_FAIL => "sourcing-fail"
    | #MATCHING => "matching"
    | #COMPLETE => "complete"
    | #FAIL => "fail"
    | _ => ""
    }
  }

  let toValue = s => {
    switch s {
    | "wait" => #WAIT->Some
    | "sourcing" => #SOURCING->Some
    | "sourced" => #SOURCED->Some
    | "sourcing-fail" => #SOURCING_FAIL->Some
    | "matching" => #MATCHING->Some
    | "complete" => #COMPLETE->Some
    | "fail" => #FAIL->Some
    | _ => None
    }
  }

  let toLabel = v => {
    switch v {
    | #WAIT => "컨택 대기"
    | #SOURCING => "소싱 진행"
    | #SOURCED => "소싱 성공"
    | #SOURCING_FAIL => "소싱 실패"
    | #MATCHING => "매칭 진행"
    | #COMPLETE => "매칭 성공"
    | #FAIL => "매칭 실패"
    | _ => "진행 상태 선택"
    }
  }

  let makeDefault = status => status->toString->Valid

  @react.component
  let make = (~defaultValue=Valid(""), ~onChange) => {
    let (value, setValue) = React.Uncurried.useState(_ => defaultValue)

    let selected = {
      switch value {
      | Valid(v) => v
      | Invalid({value}) => value
      }
    }

    let update = v => {
      setValue(._ => v)
      v->onChange
    }

    let handleChange = e => {
      (e->ReactEvent.Synthetic.target)["value"]->Valid->update
    }

    <label className=%twc("block relative w-full")>
      <div className=Style.selected>
        <span className={selected == "" ? %twc("text-disabled-L1") : %twc("text-text-L1")}>
          {selected->toValue->Option.mapWithDefault("진행 상태 선택", toLabel)->React.string}
        </span>
        <span className=%twc("absolute top-1.5 right-2")>
          <IconArrowSelect height="24" width="24" fill="#121212" />
        </span>
      </div>
      <select
        value=selected
        className=%twc("block w-full h-full absolute top-0 opacity-0")
        onChange=handleChange>
        <option value="" disabled=true hidden={selected == "" ? false : true}>
          {`진행 상태 선택`->React.string}
        </option>
        {[#WAIT, #SOURCING, #SOURCED, #SOURCING_FAIL, #MATCHING, #COMPLETE, #FAIL]
        ->Array.map(v => {
          let asString = v->toString
          let label = v->toLabel
          <option key=asString value=asString> {label->React.string} </option>
        })
        ->React.array}
      </select>
    </label>
  }
}

module StatusInfo = {
  let toString = v => {
    switch v {
    | #SOURCING_MEAT_TOUCH => "sourcing-meat-touch" // [소싱 진행] 미트 터치를 통해 소싱이 진행되는 경우
    | #SOURCING_MEAT_CART => "sourcing-meat-cart" // [소싱 진행] 미트 카트 를 통해 소싱이 진행되는 경우
    | #SOURCING_FAIL_BUYER_ORDER => "sourcing-fail-buyer-order" // [소싱 실패] 바이어 소량 주문: 바이어 소량주문으로 인한 실패상태
    | #SOURCING_FAIL_BUYER_UNAVAILABLE => "sourcing-fail-buyer-unavailable" // [소싱 실패] 바이어 연락 두절: 바이어가 매칭 도중 연락이 더 이상 되지 않는 상태
    | #SOURCING_FAIL_BUYER_WITHDRAW => "sourcing-fail-buyer-withdraw" // [소싱 실패] 바이어 거래의사 없음: 컨택시 바이어 구매 의사가 없는 상태
    | #SOURCING_FAIL_ADMIN_DECLINED_PRICE => "sourcing-fail-admin-declined-price" // [소싱 실패] 바이어 희망가 거절: 바이어가 제시한 희망가가 너무 터무니 없어 실패하는 경우
    | #SOURCING_FAIL_DELIVERY => "sourcing-fail-delivery" // [소싱 실패] 배송 이슈: 배송비 또는 배송방식의 문제로 인해 실패될 경우
    | #SOURCING_FAIL_NO_SELLERS => "sourcing-fail-no-sellers" // [소싱 실패] 셀러 소싱 실패: 셀러 소싱이 실패할 경우
    | #SOURCING_FAIL_SELLER_DECLINED_PRICE => "sourcing-fail-seller-declined-price" // [소싱 실패] 셀러 단가 거절: 셀러가 바이어가 제시한 희망가에 맞출 수 없는 경우
    | #SOURCING_FAIL_SELLER_DECLINED_AMOUNT => "sourcing-fail-seller-declined-amount" // [소싱 실패] 셀러 중량 거절: 셀러가 바이어의 구매 희망 중량/용량/수량을 거절 할 경우
    | #SOURCING_FAIL_SELLER_RETIRE => "sourcing-fail-seller-retire" // [소싱 실패] 상품 판매 종료: 셀러가 더 이상 상품을 판매하지 않을 경우
    | #SOURCING_FAIL_ETC => "sourcing-fail-etc" // [소싱 실패] 기타 종료
    | #SOURCING_FAIL_REGION => "sourcing-fail-region" // [소싱 실패] 지방권: 현재 정책상 거래 가능 지역이 아닌 경우
    | #FAIL_DELIVERY => "fail-delivery" // [매칭 실패] 배송비 문제: 소싱 성공 이후, 배송비 또는 배송방식의 문제로 인해 실패될 경우
    | #FAIL_BUYER_DECLINED => "fail-buyer-declined" // [매칭 실패] 바이어 견적 거절: 바이어가 셀러의 견적서를 거절하여 매칭이 실패한 케이스
    | #FAIL_BUYER_UNAVAILABLE => "fail-buyer-unavailable" // [매칭 실패] 바이어 연락 끊김: 소싱 성공 이후, 바이어 연락 끊긴 상태
    | #FAIL_EXPIRED => "fail-expired" // [매칭 실패] 매칭 지연 이슈: 매칭 리드타임이 오래되어 취소된 경우
    | _ => ""
    }
  }

  let toValue = s => {
    switch s {
    | "sourcing-meat-touch" => #SOURCING_MEAT_TOUCH->Some
    | "sourcing-meat-cart" => #SOURCING_MEAT_CART->Some
    | "sourcing-fail-buyer-order" => #SOURCING_FAIL_BUYER_ORDER->Some
    | "sourcing-fail-buyer-unavailable" => #SOURCING_FAIL_BUYER_UNAVAILABLE->Some
    | "sourcing-fail-buyer-withdraw" => #SOURCING_FAIL_BUYER_WITHDRAW->Some
    | "sourcing-fail-admin-declined-price" => #SOURCING_FAIL_ADMIN_DECLINED_PRICE->Some
    | "sourcing-fail-delivery" => #SOURCING_FAIL_DELIVERY->Some
    | "sourcing-fail-no-sellers" => #SOURCING_FAIL_NO_SELLERS->Some
    | "sourcing-fail-seller-declined-price" => #SOURCING_FAIL_SELLER_DECLINED_PRICE->Some
    | "sourcing-fail-seller-declined-amount" => #SOURCING_FAIL_SELLER_DECLINED_AMOUNT->Some
    | "sourcing-fail-seller-retire" => #SOURCING_FAIL_SELLER_RETIRE->Some
    | "sourcing-fail-etc" => #SOURCING_FAIL_ETC->Some
    | "sourcing-fail-region" => #SOURCING_FAIL_REGION->Some
    | "fail-delivery" => #FAIL_DELIVERY->Some
    | "fail-buyer-declined" => #FAIL_BUYER_DECLINED->Some
    | "fail-buyer-unavailable" => #FAIL_BUYER_UNAVAILABLE->Some
    | "fail-expired" => #FAIL_EXPIRED->Some
    | _ => None
    }
  }

  let toLabel = v => {
    switch v {
    | #SOURCING_MEAT_TOUCH => "[소싱 진행] 미트 터치를 통해 소싱 진행"
    | #SOURCING_MEAT_CART => "[소싱 진행] 미트 카트를 통해 소싱 진행"
    | #SOURCING_FAIL_BUYER_ORDER => "[소싱 실패] 바이어 소량 주문"
    | #SOURCING_FAIL_BUYER_UNAVAILABLE => "[소싱 실패] 바이어 연락 두절"
    | #SOURCING_FAIL_BUYER_WITHDRAW => "[소싱 실패] 바이어 거래의사 없음"
    | #SOURCING_FAIL_ADMIN_DECLINED_PRICE => "[소싱 실패] 바이어 희망가 거절"
    | #SOURCING_FAIL_DELIVERY => "[소싱 실패] 배송 이슈"
    | #SOURCING_FAIL_NO_SELLERS => "[소싱 실패] 셀러 소싱 실패"
    | #SOURCING_FAIL_SELLER_DECLINED_PRICE => "[소싱 실패] 셀러 단가 거절"
    | #SOURCING_FAIL_SELLER_DECLINED_AMOUNT => "[소싱 실패] 셀러 중량 거절"
    | #SOURCING_FAIL_SELLER_RETIRE => "[소싱 실패] 상품 판매 종료"
    | #SOURCING_FAIL_ETC => "[소싱 실패] 기타 종료"
    | #SOURCING_FAIL_REGION => "[소싱 실패] 거래 불가 지역"
    | #FAIL_DELIVERY => "[매칭 실패] 배송비 문제"
    | #FAIL_BUYER_DECLINED => "[매칭 실패] 바이어 견적 거절"
    | #FAIL_BUYER_UNAVAILABLE => "[매칭 실패] 바이어 연락 끊김"
    | #FAIL_EXPIRED => "[매칭 실패] 매칭 지연"
    | _ => "사유 선택"
    }
  }

  let makeDefault = statusInfo => statusInfo->Option.mapWithDefault("", toString)->Valid

  @react.component
  let make = (~defaultValue=Valid(""), ~onChange) => {
    let (value, setValue) = React.Uncurried.useState(_ => defaultValue)

    let selected = {
      switch value {
      | Valid(v) => v
      | Invalid({value}) => value
      }
    }

    let update = v => {
      setValue(._ => v)
      v->onChange
    }

    let handleChange = e => {
      (e->ReactEvent.Synthetic.target)["value"]->Valid->update
    }

    <label className=%twc("block relative w-full")>
      <div className=Style.selected>
        <span className={selected == "" ? %twc("text-disabled-L1") : %twc("text-text-L1")}>
          {selected->toValue->Option.mapWithDefault("사유 선택", toLabel)->React.string}
        </span>
        <span className=%twc("absolute top-1.5 right-2")>
          <IconArrowSelect height="24" width="24" fill="#121212" />
        </span>
      </div>
      <select
        value=selected
        className=%twc("block w-full h-full absolute top-0 opacity-0")
        onChange=handleChange>
        <option value="" disabled=true hidden={selected == "" ? false : true}>
          {`사유 선택`->React.string}
        </option>
        {[
          #SOURCING_MEAT_TOUCH,
          #SOURCING_MEAT_CART,
          #SOURCING_FAIL_BUYER_ORDER,
          #SOURCING_FAIL_BUYER_UNAVAILABLE,
          #SOURCING_FAIL_BUYER_WITHDRAW,
          #SOURCING_FAIL_ADMIN_DECLINED_PRICE,
          #SOURCING_FAIL_DELIVERY,
          #SOURCING_FAIL_NO_SELLERS,
          #SOURCING_FAIL_SELLER_DECLINED_PRICE,
          #SOURCING_FAIL_SELLER_DECLINED_AMOUNT,
          #SOURCING_FAIL_SELLER_RETIRE,
          #SOURCING_FAIL_ETC,
          #SOURCING_FAIL_REGION,
          #FAIL_DELIVERY,
          #FAIL_BUYER_DECLINED,
          #FAIL_BUYER_UNAVAILABLE,
          #FAIL_EXPIRED,
        ]
        ->Array.map(v => {
          let asString = v->toString
          let label = v->toLabel
          <option key=asString value=asString> {label->React.string} </option>
        })
        ->React.array}
      </select>
    </label>
  }
}

module PromotedProductId = {
  let makeDefault = promotedProductId =>
    promotedProductId->Option.mapWithDefault("", Int.toString)->Valid

  let patterns: array<Pattern.t> = [
    // {re: Pattern.notEmpty, message: "신선배송 상품번호 입력."},
    {re: Pattern.int, message: "숫자만 입력 가능."},
  ]

  @react.component
  let make = (~defaultValue=Valid(""), ~onChange) => {
    let (value, setValue) = React.Uncurried.useState(_ => defaultValue)
    let (error, setError) = React.Uncurried.useState((_): option<string> => None)

    let update = v => {
      setValue(._ => v)
      v->onChange
    }

    let handleChange = e => {
      switch (e->ReactEvent.Synthetic.currentTarget)["value"]->Pattern.validate(patterns) {
      | Valid(v) => {
          setError(._ => None)
          v->Valid->update
        }

      | Invalid(e) => {
          setError(._ => Some(e.message))
          e->Invalid->update
        }
      }
    }

    <div className=%twc("relative w-full")>
      <input
        type_="text"
        className={Style.input}
        value={value->toString}
        onChange=handleChange
        placeholder="상품번호 입력"
      />
      {error->Option.mapWithDefault(React.null, _ => <ErrorText className=Style.error errMsg="" />)}
    </div>
  }
}

module Seller = {
  let makeDefault = id => id->Valid

  module Select = {
    @react.component
    let make = (~defaultId=?, ~defaultName=?, ~onChange) => {
      let init = {
        switch (defaultId, defaultName) {
        | (Some(id), Some(label)) => SearchSeller_Admin.Item.Selected({id, label})
        | _ => SearchSeller_Admin.Item.NotSelected
        }
      }
      let (value, setValue) = React.Uncurried.useState(_ => init)

      let handleChange = v => {
        setValue(._ => v)
        switch v {
        | SearchSeller_Admin.Item.Selected({id}) => Valid(id)->onChange
        | SearchSeller_Admin.Item.NotSelected => Valid("")->onChange
        }
      }

      <SearchSeller_Admin value onChange=handleChange placeholder={`생산자 검색`} />
    }
  }
}
