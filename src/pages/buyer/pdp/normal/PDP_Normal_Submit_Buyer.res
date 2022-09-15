/*
  1. 컴포넌트 위치
  PDP > 일반 상품 > 주문 버튼
  
  2. 역할
  {인증}/{단품 선택 여부} 등을 고려한 일반상품의 주문 버튼을 보여줍니다.
*/

module Fragment = %relay(`
  fragment PDPNormalSubmitBuyerFragment on Product {
    __typename
    status
  
    ...PDPNormalSubmitBuyer_fragment
    ...PDPNormalRfqBtnBuyer_fragment
  }
`)

module ButtonFragment = %relay(`
    fragment PDPNormalSubmitBuyer_fragment on Product
    @argumentDefinitions(
      first: { type: "Int", defaultValue: 20 }
      after: { type: "ID", defaultValue: null }
    ) {
      productId: number
      displayName
      category {
        fullyQualifiedName {
          name
        }
      }
      ... on NormalProduct {
        producer {
          producerCode
        }
    
        productOptions(first: $first, after: $after) {
          edges {
            node {
              id
              stockSku
              price
            }
          }
        }
      }
      ... on QuotableProduct {
        producer {
          producerCode
        }
    
        productOptions(first: $first, after: $after) {
          edges {
            node {
              id
              stockSku
              price
            }
          }
        }
      }
    }
  `)

// 구매 가능 상태
type orderStatus =
  | Loading // SSR
  | Soldout // 상품 품절
  | Unauthorized // 미인증
  | NoOption // 선택한 단품이 없음
  | Available(Map.String.t<int>) // 구매 가능 상태 (k: string(optionId) / v: int(quantity))

module ClickPurchaseGtm = {
  type option = {
    stockSku: string,
    price: option<int>,
    quantity: int,
  }

  let make = (product: PDPNormalSubmitBuyer_fragment_graphql.Types.fragment, ~selectedOptions) => {
    let {productId, displayName, producer, category, productOptions} = product
    let categoryNames = category.fullyQualifiedName->Array.map(({name}) => name)
    let producerCode = producer->Option.map(({producerCode}) => producerCode)

    let options = {
      selectedOptions
      ->Map.String.toArray
      ->Array.keepMap(((optionId, quantity)) => {
        productOptions->Option.flatMap(({edges}) => {
          switch edges->Array.getBy(({node: {id}}) => id == optionId) {
          | None => None
          | Some({node: {stockSku, price}}) => {stockSku, price, quantity}->Some
          }
        })
      })
    }

    let filterEmptyArr = arr => {
      switch arr {
      | [] => None
      | nonEmpty => nonEmpty->Some
      }
    }

    let makeItems = nonEmptyOptions => {
      nonEmptyOptions->Array.map(({stockSku, price, quantity}) =>
        {
          "currency": "KRW", // 화폐 KRW 고정
          "item_id": productId->Int.toString, // 상품 코드
          "item_name": displayName, // 상품명
          "item_brand": producerCode->Js.Nullable.fromOption, // maker - 생산자코드
          "item_variant": stockSku, // 단품 코드
          "price": price->Js.Nullable.fromOption, // 상품 가격 (바이어 판매가) - nullable
          "quantity": quantity, // 수량
          "item_category": categoryNames->Array.get(0)->Js.Nullable.fromOption, // 표준 카테고리 Depth 1
          "item_category2": categoryNames->Array.get(1)->Js.Nullable.fromOption, // 표준 카테고리 Depth 2
          "item_category3": categoryNames->Array.get(2)->Js.Nullable.fromOption, // 표준 카테고리 Depth 3
          "item_category4": categoryNames->Array.get(3)->Js.Nullable.fromOption, // 표준 카테고리 Depth 4
          "item_category5": categoryNames->Array.get(4)->Js.Nullable.fromOption, // 표준 카테고리 Depth 5
        }
      )
    }

    options
    ->filterEmptyArr
    ->Option.map(nonEmptyOptions => {
      {
        "event": "click_purchase", // 이벤트 타입: 상품 구매 클릭 시
        "ecommerce": {
          "items": nonEmptyOptions->makeItems,
        },
      }
    })
  }
}

module PC = {
  module ActionBtn = {
    @react.component
    let make = (~query, ~className, ~selectedOptions, ~setShowModal, ~children) => {
      let availableButton = ToggleOrderAndPayment.use()
      let product = query->ButtonFragment.use

      let onClick = _ => {
        switch availableButton {
        | true =>
          product
          ->ClickPurchaseGtm.make(~selectedOptions)
          ->Option.map(event' => {
            {"ecommerce": Js.Nullable.null}->DataGtm.push
            event'->DataGtm.mergeUserIdUnsafe->DataGtm.push
          })
          ->ignore
          setShowModal(._ => PDP_Normal_Modals_Buyer.Show(Confirm))

        | false =>
          Global.jsAlert(`서비스 점검으로 인해 주문,결제 기능을 이용할 수 없습니다.`)
        }
      }

      <button className onClick> children </button>
    }
  }

  module OrderBtn = {
    @react.component
    let make = (~status, ~selectedOptions, ~setShowModal, ~query) => {
      let user = CustomHooks.User.Buyer.use2()

      let btnStyle = %twc(
        "w-full h-16 rounded-xl flex items-center justify-center bg-primary hover:bg-primary-variant text-lg font-bold text-white"
      )

      let disabledStyle = %twc(
        "w-full h-16 rounded-xl flex items-center justify-center bg-gray-300 text-white font-bold text-xl"
      )

      let orderStatus = {
        switch (status, user) {
        | (#SOLDOUT, _) => Soldout
        | (_, Unknown) => Loading
        | (_, NotLoggedIn) => Unauthorized
        | (_, LoggedIn(_)) =>
          switch selectedOptions->Map.String.toArray {
          | [] => NoOption
          | _ => Available(selectedOptions)
          }
        }
      }

      switch orderStatus {
      // SSR
      | Loading => <button disabled=true className=disabledStyle> {``->React.string} </button>

      // 품절
      | Soldout => <button disabled=true className=disabledStyle> {`품절`->React.string} </button>

      // 미인증
      | Unauthorized =>
        <button
          className=btnStyle
          onClick={_ => {
            setShowModal(._ => PDP_Normal_Modals_Buyer.Show(
              Unauthorized(`로그인 후에\n구매하실 수 있습니다.`),
            ))
          }}>
          {`구매하기`->React.string}
        </button>

      // 단품 미선택
      | NoOption =>
        <button
          className=btnStyle
          onClick={_ => setShowModal(._ => PDP_Normal_Modals_Buyer.Show(NoOption))}>
          {`구매하기`->React.string}
        </button>

      // 구매 가능
      | Available(options) =>
        <ActionBtn className=btnStyle query selectedOptions=options setShowModal>
          {`구매하기`->React.string}
        </ActionBtn>
      }
    }
  }

  @react.component
  let make = (~query, ~selectedOptions, ~setShowModal) => {
    let {status, __typename, fragmentRefs} = query->Fragment.use

    <section className=%twc("w-full")>
      <OrderBtn query=fragmentRefs status selectedOptions setShowModal />
      {switch __typename->Product_Parser.Type.decode {
      | Some(Quotable) => <PDP_Normal_RfqBtn_Buyer.PC query=fragmentRefs setShowModal />
      | _ => React.null
      }}
    </section>
  }
}

module MO = {
  module OrderBtn = {
    module ActionBtn = {
      @react.component
      let make = (~query, ~className, ~selectedOptions, ~setShowModal, ~children) => {
        let availableButton = ToggleOrderAndPayment.use()
        let product = query->ButtonFragment.use

        let onClick = _ => {
          switch availableButton {
          | true => {
              product
              ->ClickPurchaseGtm.make(~selectedOptions)
              ->Option.map(event' => {
                {"ecommerce": Js.Nullable.null}->DataGtm.push
                event'->DataGtm.mergeUserIdUnsafe->DataGtm.push
              })
              ->ignore
              setShowModal(._ => PDP_Normal_Modals_Buyer.Show(Confirm))
            }

          | false =>
            Global.jsAlert(`서비스 점검으로 인해 주문,결제 기능을 이용할 수 없습니다.`)
          }
        }

        <button className onClick> children </button>
      }
    }

    @react.component
    let make = (~status, ~selectedOptions, ~setShowModal, ~query) => {
      let user = CustomHooks.User.Buyer.use2()

      let btnStyle = %twc(
        "flex flex-1 rounded-xl items-center justify-center bg-primary font-bold text-white"
      )

      let disabledStyle = %twc(
        "flex flex-1 rounded-xl items-center justify-center bg-gray-300 text-white font-bold"
      )

      let orderStatus = {
        switch (status, user) {
        | (#SOLDOUT, _) => Soldout
        | (_, Unknown) => Loading
        | (_, NotLoggedIn) => Unauthorized
        | (_, LoggedIn(_)) =>
          switch selectedOptions->Map.String.toArray {
          | [] => NoOption
          | _ => Available(selectedOptions)
          }
        }
      }

      switch orderStatus {
      // SSR
      | Loading => <button disabled=true className=disabledStyle> {``->React.string} </button>

      // 품절
      | Soldout => <button disabled=true className=disabledStyle> {`품절`->React.string} </button>

      // 미인증
      | Unauthorized =>
        <button
          className=btnStyle
          onClick={_ => {
            setShowModal(._ => PDP_Normal_Modals_Buyer.Show(
              Unauthorized(`로그인 후에\n구매하실 수 있습니다.`),
            ))
          }}>
          {`구매하기`->React.string}
        </button>

      // 단품 미선택
      | NoOption =>
        <button
          className=btnStyle
          onClick={_ => setShowModal(._ => PDP_Normal_Modals_Buyer.Show(NoOption))}>
          {`구매하기`->React.string}
        </button>

      // 구매 가능
      | Available(options) =>
        <ActionBtn className=btnStyle query selectedOptions=options setShowModal>
          {`구매하기`->React.string}
        </ActionBtn>
      }
    }
  }

  @react.component
  let make = (~query, ~selectedOptions, ~setShowModal) => {
    let {__typename, status, fragmentRefs} = query->Fragment.use

    <PDP_CTA_Container_Buyer>
      {switch __typename->Product_Parser.Type.decode {
      | Some(Quotable) =>
        <>
          <PDP_Normal_RfqBtn_Buyer.MO query=fragmentRefs setShowModal />
          <div className=%twc("w-2") />
        </>
      | _ => React.null
      }}
      <OrderBtn status selectedOptions setShowModal query=fragmentRefs />
    </PDP_CTA_Container_Buyer>
  }
}
