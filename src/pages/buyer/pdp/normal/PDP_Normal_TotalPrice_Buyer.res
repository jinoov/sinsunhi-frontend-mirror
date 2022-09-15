/*
  1. 컴포넌트 위치
  바이어 센터 전시 매장 > PDP Page > 주문 최종 가격
  
  2. 역할
  일반 상품 최종 가격정보. 선택한 단품/수량에 따른 배송비, 최종 가격 정보를 보여줍니다.
*/

module Fragment = %relay(`
  fragment PDPNormalTotalPriceBuyerFragment on Product
  @argumentDefinitions(
    first: { type: "Int", defaultValue: 20 }
    after: { type: "ID", defaultValue: null }
  ) {
    status
  
    ... on NormalProduct {
      productOptions(first: $first, after: $after) {
        edges {
          node {
            id
            stockSku
            price
            productOptionCost {
              deliveryCost
              isFreeShipping
            }
          }
        }
      }
    }
  
    ... on QuotableProduct {
      productOptions(first: $first, after: $after) {
        edges {
          node {
            id
            stockSku
            price
            productOptionCost {
              deliveryCost
              isFreeShipping
            }
          }
        }
      }
    }
  }
`)

type priceObj = {
  price: int,
  deliveryCost: int,
  isFreeShipping: bool,
  quantity: int,
}

type optionsStatus =
  | Loading // SSR
  | Unauthorized // 미인증
  | Soldout // 품절상품
  | NoOption // 단품 미선택
  | Available(array<priceObj>) // 가격 출력

let makeOptionPrice = (~price, ~deliveryCost, ~isFreeShipping) => {
  // isFreeShipping(배송비 가리기 옵션)이 true일 때
  // 단품 가격 == 바이어 판매가
  // isFreeShipping(배송비 가리기 옵션)이 false일 때
  // 단품 가격 == 바이어 판매가 - 배송비
  switch isFreeShipping {
  | true => price
  | false => price - deliveryCost
  }
}

let makeOptionDeliveryCost = (~deliveryCost, ~isFreeShipping) => {
  // isFreeShipping(배송비 가리기 옵션)이 true일 때
  // 배송비 == 0
  // isFreeShipping(배송비 가리기 옵션)이 false일 때
  // 배송비 == 입력된 배송비
  switch isFreeShipping {
  | true => 0
  | false => deliveryCost
  }
}

let sumPriceObjs = priceObjs => {
  let multiply = (a, b) => a * b
  let init = (0, 0)

  priceObjs->Array.reduce(init, (
    (optionPriceSum, deliveryPriceSum),
    {price, deliveryCost, isFreeShipping, quantity},
  ) => {
    let optionPrice = makeOptionPrice(~price, ~deliveryCost, ~isFreeShipping)->multiply(quantity)
    let deliveryPrice = makeOptionDeliveryCost(~deliveryCost, ~isFreeShipping)->multiply(quantity)
    (optionPriceSum + optionPrice, deliveryPriceSum + deliveryPrice)
  })
}

module PC = {
  @react.component
  let make = (~query, ~selectedOptions, ~withDeliveryCost=true) => {
    let user = CustomHooks.User.Buyer.use2()
    let {status, productOptions} = query->Fragment.use

    let makePriceObjs = options => {
      let makePriceObj = ((optionId, quantity)) => {
        productOptions->Option.flatMap(({edges}) => {
          edges
          ->Array.getBy(({node}) => node.id == optionId)
          ->Option.flatMap(({node: {price, productOptionCost: {deliveryCost, isFreeShipping}}}) => {
            // 단품의 가격은 필수정보이지만, 미인증 상태일 경우 가격을 가리기 위해 nullable하게 만들어졌다.
            // 단품을 고르고 가격을 계산하는 과정은, 인증 이후에 진행되는 과정이므로
            // 가격이 null인 케이스를 사전에 제거하여 이후 계산에 용이하도록 한다.
            price->Option.map(price' => {
              price: price',
              deliveryCost: deliveryCost,
              isFreeShipping: isFreeShipping,
              quantity: quantity,
            })
          })
        })
      }

      options->Map.String.toArray->Array.keepMap(makePriceObj)
    }

    let priceLabelStatus = switch (user, status, selectedOptions->makePriceObjs) {
    | (Unknown, _, _) => Loading
    | (_, #SOLDOUT, _) => Soldout
    | (NotLoggedIn, _, _) => Unauthorized
    | (LoggedIn(_), _, []) => NoOption
    | (LoggedIn(_), _, nonEmptyPriceObjs) => Available(nonEmptyPriceObjs)
    }

    <div className=%twc("py-7 px-6")>
      <div className=%twc("flex justify-between")>
        <span className=%twc("text-lg font-bold text-gray-800")>
          {`총 결제 금액`->React.string}
        </span>
        {switch priceLabelStatus {
        | Loading | Soldout | Unauthorized | NoOption => React.null
        // 가격 표시
        | Available(priceObjs) =>
          let (totalOptionPrice, totalDeliveryCost) = priceObjs->sumPriceObjs
          let totalPrice = totalOptionPrice + totalDeliveryCost

          <span className=%twc("ml-2 text-green-500 font-bold text-2xl")>
            {`${totalPrice->Int.toFloat->Locale.Float.show(~digits=0)}원`->React.string}
          </span>
        }}
      </div>
      {switch priceLabelStatus {
      // SSR
      | Loading => <span className=%twc("text-gray-500 text-sm")> {``->React.string} </span>

      // 품절상품
      | Soldout =>
        <span className=%twc("text-gray-500 text-sm")>
          {`품절된 상품으로 총 결제 금액을 보실 수 없습니다`->React.string}
        </span>

      // 미인증
      | Unauthorized =>
        <span className=%twc("text-green-500 text-sm")>
          {`로그인을 하시면 총 결제 금액을 보실 수 있습니다`->React.string}
        </span>

      // 단품 미선택
      | NoOption =>
        <span className=%twc("text-green-500 text-sm")>
          {`단품을 선택하시면 총 결제 금액을 보실 수 있습니다`->React.string}
        </span>

      // 가격 표시
      | Available(priceObjs) =>
        let (_, totalDeliveryCost) = priceObjs->sumPriceObjs

        let deliveryCostLabel = {
          switch withDeliveryCost {
          // 배송비 포함
          | true =>
            switch totalDeliveryCost {
            | 0 => `배송비 무료`
            | nonZeroInt =>
              `배송비 ${nonZeroInt->Int.toFloat->Locale.Float.show(~digits=0)}원 포함`
            }

          // 배송비 비포함
          | false => `택배 배송비 포함 금액(배송방식에 따라 변동됨)`
          }
        }

        <span className=%twc("text-gray-600")> {deliveryCostLabel->React.string} </span>
      }}
    </div>
  }
}

module MO = {
  @react.component
  let make = (~query, ~selectedOptions, ~withDeliveryCost=true) => {
    let user = CustomHooks.User.Buyer.use2()
    let {status, productOptions} = query->Fragment.use

    let makePriceObjs = options => {
      let makePriceObj = ((optionId, quantity)) => {
        productOptions->Option.flatMap(({edges}) => {
          edges
          ->Array.getBy(({node}) => node.id == optionId)
          ->Option.flatMap(({node: {price, productOptionCost: {deliveryCost, isFreeShipping}}}) => {
            // 단품의 가격은 필수정보이지만, 미인증 상태일 경우 가격을 가리기 위해 nullable하게 만들어졌다.
            // 단품을 고르고 가격을 계산하는 과정은, 인증 이후에 진행되는 과정이므로
            // 가격이 null인 케이스를 사전에 제거하여 이후 계산에 용이하도록 한다.
            price->Option.map(price' => {
              price: price',
              deliveryCost: deliveryCost,
              isFreeShipping: isFreeShipping,
              quantity: quantity,
            })
          })
        })
      }

      options->Map.String.toArray->Array.keepMap(makePriceObj)
    }

    let priceLabelStatus = switch (user, status, selectedOptions->makePriceObjs) {
    | (Unknown, _, _) => Loading
    | (_, #SOLDOUT, _) => Soldout
    | (NotLoggedIn, _, _) => Unauthorized
    | (LoggedIn(_), _, []) => NoOption
    | (LoggedIn(_), _, nonEmptyPriceObjs) => Available(nonEmptyPriceObjs)
    }

    let titleStyle = %twc("text-base font-bold text-text-L1")
    let captionBaseStyle = %twc("text-[13px] ")
    <div>
      <div className=%twc("flex justify-between")>
        <h1 className=titleStyle> {`총 결제 금액`->React.string} </h1>
        {switch priceLabelStatus {
        | Loading | Soldout | Unauthorized | NoOption => React.null

        | Available(priceObjs) =>
          let (totalOptionPrice, totalDeliveryCost) = priceObjs->sumPriceObjs
          let totalPrice = totalOptionPrice + totalDeliveryCost
          <span className=%twc("text-green-500 font-bold text-[22px]")>
            {`${totalPrice->Int.toFloat->Locale.Float.show(~digits=0)}원`->React.string}
          </span>
        }}
      </div>
      {switch priceLabelStatus {
      | Loading =>
        let captionStyle = captionBaseStyle ++ %twc("text-gray-500")
        <span className=captionStyle> {``->React.string} </span>

      | Soldout =>
        let captionStyle = captionBaseStyle ++ %twc("text-gray-500")
        <span className=captionStyle>
          {`품절된 상품으로 총 결제 금액을 보실 수 없습니다`->React.string}
        </span>

      | Unauthorized =>
        let captionStyle = captionBaseStyle ++ %twc("text-green-500")
        <span className=captionStyle>
          {`로그인을 하시면 총 결제 금액을 보실 수 있습니다`->React.string}
        </span>

      | NoOption =>
        let captionStyle = captionBaseStyle ++ %twc("text-green-500")
        <span className=captionStyle>
          {`단품을 선택하시면 총 결제 금액을 보실 수 있습니다`->React.string}
        </span>

      | Available(priceObjs) =>
        let (_, totalDeliveryCost) = priceObjs->sumPriceObjs

        let deliveryCostLabel = {
          switch withDeliveryCost {
          // 배송비 보여줌
          | true =>
            switch totalDeliveryCost {
            | 0 => `배송비 무료`
            | nonZeroInt =>
              `배송비 ${nonZeroInt->Int.toFloat->Locale.Float.show(~digits=0)}원 포함`
            }

          // 배송비 가림
          | false => `택배 배송비 포함 금액(배송방식에 따라 변동됨)`
          }
        }

        let captionStyle = captionBaseStyle ++ %twc("text-gray-600")
        <span className=captionStyle> {deliveryCostLabel->React.string} </span>
      }}
    </div>
  }
}
