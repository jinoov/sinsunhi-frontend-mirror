/*
  1. 컴포넌트 위치
  바이어 센터 전시 매장 > PDP Page > 주문 수량
  
  2. 역할
  선택한 단품의 주문 수량을 입력할 수 있으며, 그에 따른 가격 정보를 보여줍니다.
*/

module Query = %relay(`
  query PDPNormalSelectedOptionItemBuyerQuery($id: ID!) {
    node(id: $id) {
      ... on ProductOption {
        id
        optionName
        product {
          id
          productId: number
        }
        stockSku
        price
        isFreeShipping
        productOptionCost {
          deliveryCost
        }
        adhocStockIsLimited
        adhocStockIsNumRemainingVisible
        adhocStockNumRemaining
      }
    }
  }
`)

module PC = {
  @react.component
  let make = (~id, ~quantity, ~onChange, ~onRemove, ~withCaption=?) => {
    let {node} = Query.use(~variables={id: id}, ())

    switch node {
    | None => React.null

    | Some({
        product: {productId},
        stockSku,
        optionName,
        price,
        isFreeShipping,
        productOptionCost,
        adhocStockIsLimited,
        adhocStockIsNumRemainingVisible,
        adhocStockNumRemaining,
      }) =>
      let {addToast} = ReactToastNotifications.useToasts()

      let toastWhenOverMaxQuantity = _ =>
        switch adhocStockNumRemaining {
        | Some(max) =>
          addToast(.
            <div className=%twc("flex items-center")>
              <div className=%twc("mr-[6px]")>
                <Formula.Icon.CheckCircleFill color=#"primary-contents" />
              </div>
              <span>
                {`구매 가능 수량은 ${max
                  ->Int.toFloat
                  ->Locale.Float.show(~digits=0)}개 입니다`->React.string}
              </span>
            </div>,
            {appearance: "success"},
          )
        | None => ()
        }

      let isShowRemaining = AdhocStock_Parser_Buyer_Admin.getIsShowRemaining(
        ~adhocStockIsLimited,
        ~adhocStockIsNumRemainingVisible,
      )

      let totalOptionPrice = {
        PDP_Parser_Buyer.ProductOption.makeOptionPrice(
          ~price,
          ~deliveryCost=productOptionCost.deliveryCost,
          ~isFreeShipping,
        )->Option.map(optionPrice' => optionPrice' * quantity)
      }

      <div className=%twc("pt-6 flex items-start justify-between")>
        <div>
          <Spinbox
            value=quantity
            onChange={value => onChange(id, value)}
            max=?adhocStockNumRemaining
            onOverMaxQuantity={toastWhenOverMaxQuantity}
          />
          {switch (isShowRemaining, adhocStockNumRemaining) {
          | (true, Some(remaining)) =>
            <Formula.Text.Body size=#sm color=#"gray-70" className=%twc("mt-2")>
              {`${remaining->Int.toFloat->Locale.Float.show(~digits=0)}개 남음`->React.string}
            </Formula.Text.Body>
          | _ => React.null
          }}
        </div>
        <div className=%twc("flex flex-col items-end")>
          <span className=%twc("mt-1 text-gray-800 text-right text-[15px]")>
            <span> {optionName->React.string} </span>
          </span>
          {withCaption
          ->Option.keep(bool' => bool' == true)
          ->Option.mapWithDefault(React.null, _ => {
            <span className=%twc("text-gray-600 text-[14px]")>
              {`상품번호 : ${productId->Int.toString} 단품번호 : ${stockSku}`->React.string}
            </span>
          })}
          <div className=%twc("mt-1 flex items-center")>
            <span className=%twc("text-gray-800 font-bold text-base text-right")>
              {totalOptionPrice
              ->Option.mapWithDefault("", totalOptionPrice' => {
                `${totalOptionPrice'->Int.toFloat->Locale.Float.show(~digits=0)}원`
              })
              ->React.string}
            </span>
            <button onClick={_ => onRemove(id)} className=%twc("ml-1")>
              <img
                src="/icons/reset-input-gray-circle@3x.png" className=%twc("w-5 h-5 object-contain")
              />
            </button>
          </div>
        </div>
      </div>
    }
  }
}

module MO = {
  @react.component
  let make = (~id, ~quantity, ~onChange, ~onRemove, ~withCaption=?) => {
    let {node} = Query.use(~variables={id: id}, ())

    switch node {
    | None => React.null

    | Some({
        product: {productId},
        stockSku,
        optionName,
        price,
        isFreeShipping,
        productOptionCost,
        adhocStockIsLimited,
        adhocStockIsNumRemainingVisible,
        adhocStockNumRemaining,
      }) =>
      let {addToast} = ReactToastNotifications.useToasts()

      let toastWhenOverMaxQuantity = _ =>
        switch adhocStockNumRemaining {
        | Some(max) =>
          addToast(.
            <div className=%twc("flex items-center")>
              <div className=%twc("mr-[6px]")>
                <Formula.Icon.CheckCircleFill color=#"primary-contents" />
              </div>
              <span>
                {`구매 가능 수량은 ${max->Int.toString}개 입니다`->React.string}
              </span>
            </div>,
            {appearance: "success"},
          )
        | None => ()
        }

      let isShowRemaining = AdhocStock_Parser_Buyer_Admin.getIsShowRemaining(
        ~adhocStockIsLimited,
        ~adhocStockIsNumRemainingVisible,
      )

      let totalOptionPrice = {
        PDP_Parser_Buyer.ProductOption.makeOptionPrice(
          ~price,
          ~deliveryCost=productOptionCost.deliveryCost,
          ~isFreeShipping,
        )->Option.map(optionPrice' => optionPrice' * quantity)
      }

      <section className=%twc("pt-5 flex items-start justify-between")>
        <div>
          <Spinbox
            value=quantity
            onChange={value => onChange(id, value)}
            max=?adhocStockNumRemaining
            onOverMaxQuantity={toastWhenOverMaxQuantity}
          />
          {switch (isShowRemaining, adhocStockNumRemaining) {
          | (true, Some(remaining)) =>
            <Formula.Text.Body size=#sm color=#"gray-70" className=%twc("mt-2")>
              {`${remaining->Int.toFloat->Locale.Float.show(~digits=0)}개 남음`->React.string}
            </Formula.Text.Body>
          | _ => React.null
          }}
        </div>
        <div className=%twc("flex flex-col items-end")>
          <span className=%twc("mt-1 text-gray-800 text-right text-[15px]")>
            <span> {optionName->React.string} </span>
          </span>
          {withCaption
          ->Option.keep(bool' => bool' == true)
          ->Option.mapWithDefault(React.null, _ => {
            <span className=%twc("text-gray-600 text-[14px]")>
              {`상품번호 : ${productId->Int.toString} 단품번호 : ${stockSku}`->React.string}
            </span>
          })}
          <div className=%twc("mt-1 flex items-center")>
            <span className=%twc("text-gray-800 font-bold text-base text-right")>
              {totalOptionPrice
              ->Option.mapWithDefault("", totalOptionPrice' => {
                `${totalOptionPrice'->Int.toFloat->Locale.Float.show(~digits=0)}원`
              })
              ->React.string}
            </span>
            <button onClick={_ => onRemove(id)} className=%twc("ml-1")>
              <img
                src="/icons/reset-input-gray-circle@3x.png" className=%twc("w-5 h-5 object-contain")
              />
            </button>
          </div>
        </div>
      </section>
    }
  }
}
