// 단품
module ProductOption = {
  // 중량
  let makeAmountLabel = (amount, unit) => {
    let amountToStr = a => {
      a->Locale.Float.round1->Float.toString
    }

    let unitToStr = u => {
      switch u {
      | #G => "g"
      | #KG => "kg"
      | #T => "t"
      | #ML => "ml"
      | #L => "l"
      | #EA => "ea"
      | _ => ""
      }
    }

    `${amount->amountToStr}${unit->unitToStr}`
  }

  // 입수: (min은 라벨 표현에 이용되지 않음)
  let makeCountPerPkgLabel = max => {
    max->Option.mapWithDefault("", count => `최대 ${count->Int.toString}입`)
  }

  // 개당 크기: (min은 라벨 표현에 이용되지 않음)
  let makePerSizeLabel = (max, unit) => {
    let unitToStr = u => {
      switch u {
      | #CM => "cm"
      | #M => "m"
      | #MM => "mm"
      | _ => ""
      }
    }

    Helper.Option.map2(max->Option.map(Float.toString), unit->Option.map(unitToStr), (
      mLabel,
      uLabel,
    ) => `최대 ${mLabel}${uLabel}`)
  }

  let makeOptionPrice = (~price, ~deliveryCost, ~isFreeShipping) => {
    // isFreeShipping(배송비 무료 프로모션)이 true일 때
    // 단품 가격 == 바이어 판매가
    // isFreeShipping(배송비 무료 프로모션)이 false일 때
    // 단품 가격 == 바이어 판매가 - 배송비
    switch isFreeShipping {
    | true => price
    | false => price->Option.map(price' => price' - deliveryCost)
    }
  }

  let makeOptionDeliveryCost = (~deliveryCost, ~isFreeShipping) => {
    // isFreeShipping(배송비 무료 프로모션)이 true일 때
    // 배송비 == 0
    // isFreeShipping(배송비 무료 프로모션)이 false일 때
    // 배송비 == 입력된 배송비
    switch isFreeShipping {
    | true => 0
    | false => deliveryCost
    }
  }
}

// 상품
module Product = {
  // 일반상품
  module Normal = {
    // 일반상품 중량 variation: 단품의 중량정보를 취합하여 중복제거 후 join하여 표현
    let makeAmountLabel = amountOptions => {
      amountOptions
      ->Array.map(((amount, unit)) => ProductOption.makeAmountLabel(amount, unit))
      ->Set.String.fromArray
      ->Set.String.toArray
      ->Array.joinWith("/", x => x)
    }

    // 일반상품 등급 variation: 일반상품의 경우 단품의 등급정보를 취합하여 중복제거 후 join하여 표현
    // ToImprove:
    //   - 일반/견적상품의 등급체계를 일원화 하던가
    //   - 일반/견적상품의 타입을 분리하던가
    let makeGradeLabel = grades => {
      let label = grades->Set.String.fromArray->Set.String.toArray->Js.Array2.joinWith("/")
      switch label {
      | "" => None
      | label' => Some(label')
      }
    }

    // 상품 카테고리
    let makeCategoryLabel = (categoryItem, categoryKind) => {
      [categoryItem, categoryKind]->Array.keep(Option.isSome)->Js.Array2.joinWith("/")
    }

    // 상품 패키지 variation: 단품의 package정보를 취합하여 중복제거 후 join하여 표현
    let makePkgLabel = pkgs => {
      pkgs->Set.String.fromArray->Set.String.toArray->Array.joinWith("/", x => x)
    }

    // 상품 공지사항 적용기간
    let makeNoticeDateLabel = (startDate, endDate) => {
      let formatDate = dateString => dateString->Js.Date.fromString->DateFns.format("y.MM.dd")

      switch (startDate, endDate) {
      | (Some(start), Some(end)) => `적용기준일: ${start->formatDate}~${end->formatDate}`
      | (Some(start), None) => `적용기준일: ${start->formatDate}~`
      | (None, Some(end)) => `적용기준일: ~${end->formatDate}`
      | (None, None) => ""
      }
    }
  }
}
