let toValue = s => {
  switch s {
  | "price-asc" => #PRICE_ASC->Some // 낮은 가격 순
  | "price-desc" => #PRICE_DESC->Some // 높은 가격 순
  | "created-asc" => #CREATED_ASC->Some // 견적 신청 오래된 순
  | "created-desc" => #CREATED_DESC->Some // 견적 신청 최신 순
  | "amount-asc" => #AMOUNT_ASC->Some // 낮은 중량/수량/용량 순
  | "amount-desc" => #AMOUNT_DESC->Some // 높은 중량/수량/용량 순
  | _ => None
  }
}

let toString = v => {
  switch v {
  | #PRICE_ASC => "price-asc" // 낮은 가격 순
  | #PRICE_DESC => "price-desc" // 높은 가격 순
  | #CREATED_ASC => "created-asc" // 견적 신청 오래된 순
  | #CREATED_DESC => "created-desc" // 견적 신청 최신 순
  | #AMOUNT_ASC => "amount-asc" // 낮은 중량/수량/용량 순
  | #AMOUNT_DESC => "amount-desc" // 높은 중량/수량/용량 순
  | _ => ""
  }
}

let toLabel = v => {
  switch v {
  | #PRICE_ASC => "낮은 가격 순"
  | #PRICE_DESC => "높은 가격 순"
  | #CREATED_ASC => "오래된 순"
  | #CREATED_DESC => "최신 순"
  | #AMOUNT_ASC => "낮은 용청량 순"
  | #AMOUNT_DESC => "높은 용청량 순"
  | _ => ""
  }
}

let set = (dict, k, v) => {
  let new = dict
  new->Js.Dict.set(k, v)
  new
}

let key = "sort"

@react.component
let make = (~className=?) => {
  let {useRouter, push} = module(Next.Router)
  let router = useRouter()

  let current = {
    router.query->Js.Dict.get(key)->Option.flatMap(toValue)->Option.getWithDefault(#CREATED_DESC)
  }

  let onChange = e => {
    let {makeWithDict, toString} = module(Webapi.Url.URLSearchParams)
    let newQueryString =
      router.query->set(key, (e->ReactEvent.Synthetic.target)["value"])->makeWithDict->toString
    router->push(`${router.pathname}?${newQueryString}`)
  }

  <span ?className>
    <label className=%twc("block relative")>
      <span
        className=%twc(
          "w-40 flex items-center border border-border-default-L1 rounded-md h-9 px-3 text-enabled-L1"
        )>
        {current->toLabel->React.string}
      </span>
      <span className=%twc("absolute top-1.5 right-2")>
        <IconArrowSelect height="24" width="24" fill="#121212" />
      </span>
      <select
        value={current->toString}
        className=%twc("block w-full h-full absolute top-0 opacity-0")
        onChange>
        {[#CREATED_DESC, #CREATED_ASC, #PRICE_ASC, #PRICE_DESC, #AMOUNT_ASC, #AMOUNT_DESC]
        ->Array.map(v => {
          <option value={v->toString}> {v->toLabel->React.string} </option>
        })
        ->React.array}
      </select>
    </label>
  </span>
}
