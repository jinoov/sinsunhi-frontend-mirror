open RadixUI

module Fragment = %relay(`
  fragment PDPNormalOrderSpecificationBuyer_fragment on Product
  @argumentDefinitions(
    first: { type: "Int", defaultValue: 20 }
    after: { type: "ID", defaultValue: null }
  ) {
    id
    productId: number
    productName: name
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
            productOptionId: number
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
            productOptionId: number
            stockSku
            price
          }
        }
      }
    }
  }
`)

module OrderMethod = {
  type t =
    | Excel // 엑셀업로드
    | Wos // 웹주문서

  let stringify = v =>
    switch v {
    | Excel => "excel"
    | Wos => "wos"
    }

  let variantify = s =>
    switch s {
    | "excel" => Excel->Some
    | "wos" => Wos->Some
    | _ => None
    }

  let toBool = v =>
    switch v {
    | Excel => true
    | Wos => false
    }
}

module SelectedItems = {
  type item = {
    productId: int,
    displayName: string,
    optionId: int,
    stockSku: string,
    quantity: int,
    price: int,
    producerCode: option<string>,
    categories: array<string>,
  }

  let filterEmptyArr = arr => {
    switch arr {
    | [] => None
    | nonEmpty => nonEmpty->Some
    }
  }

  let make = (
    product: PDPNormalOrderSpecificationBuyer_fragment_graphql.Types.fragment,
    ~selectedOptions,
  ) => {
    let {productId, displayName, category: {fullyQualifiedName}, producer, productOptions} = product

    switch productOptions {
    | None => []
    | Some({edges}) =>
      let makeItem = ((nodeId, quantity)) =>
        edges
        ->Array.getBy(({node}) => nodeId == node.id)
        ->Option.flatMap(({node: {productOptionId, stockSku, price}}) =>
          // 단품의 금액정보는 필수 스키마
          // option 타입인 이유는 미인증 유저에게 가격을 노출하지 않기 위함이다
          // 해당 단계에 진입해서 가격정보가 None인 경우는 데이터 정합성을 만족하지 않다고 볼 수 있기 때문에
          // 가격이 None인 케이스를 사전에 필터링하여, 더 좁은 타입을 만들어내고, 이후 처리에 용이하도록 한다.
          switch price {
          | None => None
          | Some(price') =>
            {
              productId,
              displayName,
              optionId: productOptionId,
              stockSku,
              quantity,
              price: price',
              producerCode: producer->Option.flatMap(producer' => producer'.producerCode),
              categories: fullyQualifiedName->Array.map(c => c.name),
            }->Some
          }
        )
      selectedOptions->Map.String.toArray->Array.keepMap(makeItem)
    }
  }

  let makeOrderBranchGtm = (selectedItems, ~orderType) => {
    let makeItems = nonEmptyItems => {
      nonEmptyItems->Array.map(({
        productId,
        displayName,
        producerCode,
        stockSku,
        price,
        quantity,
        categories,
      }) =>
        {
          "currency": "KRW", // 화폐 KRW 고정
          "item_id": productId->Int.toString, // 상품 코드
          "item_name": displayName, // 상품명
          "item_brand": producerCode->Js.Nullable.fromOption, // maker - 생산자코드
          "item_variant": stockSku, // 단품 코드
          "price": price, // 상품 가격 (바이어 판매가) - nullable
          "quantity": quantity, // 수량
          "item_category": categories->Array.get(0)->Js.Nullable.fromOption, // 표준 카테고리 Depth 1
          "item_category2": categories->Array.get(1)->Js.Nullable.fromOption, // 표준 카테고리 Depth 2
          "item_category3": categories->Array.get(2)->Js.Nullable.fromOption, // 표준 카테고리 Depth 3
          "item_category4": categories->Array.get(3)->Js.Nullable.fromOption, // 표준 카테고리 Depth 4
          "item_category5": categories->Array.get(4)->Js.Nullable.fromOption, // 표준 카테고리 Depth 5
          "order_type": orderType->OrderMethod.toBool,
        }
      )
    }
    selectedItems
    ->filterEmptyArr
    ->Option.map(nonEmptyItems =>
      {
        "event": "click_purchase", // 이벤트 타입: 상품 구매 클릭 시
        "ecommerce": {"items": nonEmptyItems->makeItems},
      }
    )
  }

  let makeAddToCartGtm = selectedItems => {
    let makeTotalPrice = nonEmptyItems => {
      nonEmptyItems->Array.map(({price, quantity}) => quantity * price)->Garter.Math.sum_int
    }

    let makeItems = nonEmptyItems => {
      nonEmptyItems->Array.mapWithIndex((
        index,
        {productId, displayName, producerCode, stockSku, price, quantity, categories},
      ) =>
        {
          "item_id": productId->Int.toString,
          "item_name": displayName,
          "price": price,
          "quantity": quantity,
          "item_brand": producerCode->Js.Nullable.fromOption,
          "item_category": categories->Array.get(0)->Js.Nullable.fromOption, // 표준 카테고리 Depth 1
          "item_category2": categories->Array.get(1)->Js.Nullable.fromOption, // 표준 카테고리 Depth 2
          "item_category3": categories->Array.get(2)->Js.Nullable.fromOption, // 표준 카테고리 Depth 3
          "item_category4": categories->Array.get(3)->Js.Nullable.fromOption, // 표준 카테고리 Depth 4
          "item_category5": categories->Array.get(4)->Js.Nullable.fromOption, // 표준 카테고리 Depth 5
          "item_variant": stockSku,
          "index": index,
        }
      )
    }

    selectedItems
    ->filterEmptyArr
    ->Option.map(nonEmptyItems =>
      {
        "event": "add_to_cart", // 이벤트 타입: 장바구니 담기 클릭 시
        "currency": "KRW",
        "value": nonEmptyItems->makeTotalPrice, // 총 가격
        "ecommerce": {"items": nonEmptyItems->makeItems},
      }
    )
  }
}

module Placeholder = {
  @react.component
  let make = () => {
    <div className=%twc("w-full h-[497px]") />
  }
}

module Scroll = {
  @react.component
  let make = (~children) => {
    open RadixUI.ScrollArea
    <Root className=%twc("max-h-[400px] flex flex-col overflow-hidden")>
      <Viewport className=%twc("w-full h-full")> {children} </Viewport>
      <Scrollbar>
        <Thumb />
      </Scrollbar>
    </Root>
  }
}

module Tab = {
  @react.component
  let make = (~label, ~value, ~isSelected) => {
    let btnDefaultStyle = %twc("flex flex-1 items-center justify-center border ")
    let btnStyle = isSelected
      ? %twc("bg-green-50 text-green-500 border-green-500")
      : %twc("text-gray-800 border-gray-250")

    <Tabs.Trigger className={btnDefaultStyle ++ btnStyle} value>
      <span> {label->React.string} </span>
    </Tabs.Trigger>
  }
}

module CartBtn = {
  module CartMutation = %relay(`
  mutation PDPNormalOrderSpecificationBuyerCartMutation(
    $items: [RequestAddCartItem!]!
  ) {
    addCartItemList(input: $items) {
      result
    }
  }
`)

  module CartQuery = %relay(`
    query PDPNormalOrderSpecificationBuyerCartQuery {
      cartItemCount
    }
  `)

  let makeMutationItem: SelectedItems.item => PDPNormalOrderSpecificationBuyerCartMutation_graphql.Types.requestAddCartItem = ({
    optionId,
    quantity,
  }) => {
    optionId,
    quantity,
  }

  type toastType =
    | Success
    | Failure

  @react.component
  let make = (~selectedOptions, ~setSelectedOptions, ~query, ~closeFn) => {
    let {addToast} = ReactToastNotifications.useToasts()
    let product = query->Fragment.use
    let selectedItems = product->SelectedItems.make(~selectedOptions)
    let (addCartItems, isAddingCartItems) = CartMutation.use()
    let (_, refreshCount, _) = CartQuery.useLoader()

    let showToast = (message, toastType) => {
      addToast(.
        <div className=%twc("flex items-center")>
          {switch toastType {
          | Success => <IconCheck height="24" width="24" fill="#12B564" className=%twc("mr-2") />
          | Failure => <IconError height="24" width="24" className=%twc("mr-2") />
          }}
          {message->React.string}
        </div>,
        {
          appearance: "success",
        },
      )
    }

    let onClick = _ => {
      // add_to_cart gtm 발송
      selectedItems
      ->SelectedItems.makeAddToCartGtm
      ->Option.map(event => {
        {"ecommerce": Js.Nullable.null}->DataGtm.push
        event->DataGtm.mergeUserIdUnsafe->DataGtm.push
      })
      ->ignore

      switch (isAddingCartItems, selectedItems) {
      | (true, _) | (_, []) => ()
      | (false, nonEmptyItems) => {
          let variables = CartMutation.makeVariables(
            ~items=nonEmptyItems->Array.map(makeMutationItem),
          )
          addCartItems(
            ~variables,
            ~onCompleted={
              ({addCartItemList}, _) => {
                switch addCartItemList.result {
                | true => {
                    refreshCount(~variables=(), ~fetchPolicy=RescriptRelay.StoreAndNetwork, ())
                    closeFn()
                    setSelectedOptions(._ => Map.String.fromArray([]))
                    showToast(`장바구니에 상품이 담겼습니다.`, Success)
                  }

                | false => showToast(`요청에 실패하였습니다.`, Failure)
                }
              }
            },
            ~onError={err => err->Js.log},
            (),
          )->ignore
        }
      }
    }

    <button
      disabled=isAddingCartItems
      onClick
      className=%twc(
        "h-16 rounded-xl bg-white border border-primary text-primary text-base font-bold flex flex-1 items-center justify-center"
      )>
      {`장바구니 담기`->React.string}
    </button>
  }
}

module WosBtn = {
  module WosMutation = %relay(`
  mutation PDPNormalOrderSpecificationBuyerWosMutation(
    $productOptions: [TempWosOrderProductOptionsList!]!
  ) {
    createTempWosOrderProductOptions(input: { productOptions: $productOptions }) {
      ... on TempWosOrder {
        tempOrderId
      }
  
      ... on CartError {
        message
      }
  
      ... on Error {
        message
      }
    }
  }
`)

  let makeMutationItem: SelectedItems.item => PDPNormalOrderSpecificationBuyerWosMutation_graphql.Types.tempWosOrderProductOptionsList = ({
    optionId,
    quantity,
  }) => {
    productOptionId: optionId,
    quantity,
  }

  @react.component
  let make = (~selectedOptions, ~query) => {
    let {useRouter, push} = module(Next.Router)
    let router = useRouter()
    let {addToast} = ReactToastNotifications.useToasts()
    let product = query->Fragment.use
    let selectedItems = product->SelectedItems.make(~selectedOptions)
    let (createOrder, isCreatingOrder) = WosMutation.use()

    let showErrToast = (~message=?, ()) => {
      addToast(.
        <div className=%twc("flex items-center")>
          <IconError height="24" width="24" className=%twc("mr-2") />
          {message->Option.getWithDefault(`요청에 실패하였습니다.`)->React.string}
        </div>,
        {
          appearance: "success",
        },
      )
    }

    let onClick = _ => {
      // order_branch gtm 발송
      selectedItems
      ->SelectedItems.makeOrderBranchGtm(~orderType=OrderMethod.Wos)
      ->Option.map(event => {
        {"ecommerce": Js.Nullable.null}->DataGtm.push
        event->DataGtm.mergeUserIdUnsafe->DataGtm.push
      })
      ->ignore

      switch (isCreatingOrder, selectedItems) {
      | (true, _) | (_, []) => ()
      | (false, nonEmptyItems) => {
          let variables = WosMutation.makeVariables(
            ~productOptions=nonEmptyItems->Array.map(makeMutationItem),
          )
          createOrder(
            ~variables,
            ~onCompleted={
              ({createTempWosOrderProductOptions}, _) => {
                switch createTempWosOrderProductOptions {
                | Some(#TempWosOrder({tempOrderId})) =>
                  router->push(`/buyer/web-order/${tempOrderId->Int.toString}`)

                | Some(#CartError({message})) => showErrToast(~message?, ())
                | Some(#Error({message})) => showErrToast(~message?, ())
                | _ => showErrToast()
                }
              }
            },
            ~onError={err => err->Js.log},
            (),
          )->ignore
        }
      }
    }

    <button
      disabled=isCreatingOrder
      onClick
      className=%twc(
        "h-16 bg-primary text-white font-bold flex flex-1 items-center justify-center rounded-xl"
      )>
      {`바로 구매하기`->React.string}
    </button>
  }
}

module UploadBtn = {
  @react.component
  let make = (~selectedOptions, ~query) => {
    let {useRouter, push} = module(Next.Router)
    let router = useRouter()
    let product = query->Fragment.use
    let selectedItems = product->SelectedItems.make(~selectedOptions)

    <button
      onClick={_ => {
        selectedItems
        ->SelectedItems.makeOrderBranchGtm(~orderType=OrderMethod.Excel)
        ->Option.map(event => {
          {"ecommerce": Js.Nullable.null}->DataGtm.push
          event->DataGtm.mergeUserIdUnsafe->DataGtm.push
        })
        ->ignore

        router->push("/buyer/upload")
      }}
      className=%twc(
        "w-full h-16 bg-primary text-white font-bold flex items-center justify-center rounded-xl"
      )>
      {`주문서 업로드하기`->React.string}
    </button>
  }
}

@react.component
let make = (~query, ~selectedOptions, ~setSelectedOptions, ~closeFn) => {
  let (selectedMethod, setSelectedMethod) = React.Uncurried.useState(_ => OrderMethod.Excel)

  <Tabs.Root
    defaultValue={OrderMethod.stringify(Excel)}
    onValueChange={selected => {
      selected
      ->OrderMethod.variantify
      ->Option.map(method => setSelectedMethod(._ => method))
      ->ignore
    }}>
    <Tabs.List className=%twc("w-full h-12 flex px-4")>
      <Tab
        label={`2개 이상 배송지`}
        value={OrderMethod.stringify(Excel)}
        isSelected={selectedMethod == Excel}
      />
      <Tab
        label={`1개 배송지`}
        value={OrderMethod.stringify(Wos)}
        isSelected={selectedMethod == Wos}
      />
    </Tabs.List>
    // 엑셀업로드
    <Tabs.Content value={OrderMethod.stringify(Excel)}>
      <div className=%twc("divide-y px-4 pt-1")>
        {switch selectedOptions->Map.String.toArray {
        | [] => React.null
        | nonEmptyOptions =>
          <Scroll>
            <section className=%twc("pb-6")>
              {nonEmptyOptions
              ->Array.map(((id, quantity)) => {
                <React.Suspense key=id fallback={React.null}>
                  <PDP_Normal_SelectedOptionItem_Buyer.MO
                    id
                    quantity
                    onChange={(optionId, quantity) => {
                      setSelectedOptions(.prev => prev->Map.String.set(optionId, quantity))
                    }}
                    onRemove={optionId => {
                      setSelectedOptions(.prev => prev->Map.String.remove(optionId))
                    }}
                    withCaption=true
                  />
                </React.Suspense>
              })
              ->React.array}
            </section>
          </Scroll>
        }}
        <section className=%twc("py-3")>
          <PDP_Normal_TotalPrice_Buyer.MO query selectedOptions />
        </section>
      </div>
      <div className=%twc("w-full h-[1px] bg-gray-100") />
      <section className=%twc("w-full px-4 py-5")>
        <UploadBtn selectedOptions query />
      </section>
    </Tabs.Content>
    // 웹주문서
    <Tabs.Content value={OrderMethod.stringify(Wos)}>
      <div className=%twc("divide-y px-4")>
        {switch selectedOptions->Map.String.toArray {
        | [] => React.null
        | nonEmptyOptions =>
          <Scroll>
            <section className=%twc("pt-1 pb-6")>
              {nonEmptyOptions
              ->Array.map(((id, quantity)) => {
                <React.Suspense key=id fallback={React.null}>
                  <PDP_Normal_SelectedOptionItem_Buyer.MO
                    id
                    quantity
                    onChange={(optionId, quantity) => {
                      setSelectedOptions(.prev => prev->Map.String.set(optionId, quantity))
                    }}
                    onRemove={optionId => {
                      setSelectedOptions(.prev => prev->Map.String.remove(optionId))
                    }}
                  />
                </React.Suspense>
              })
              ->React.array}
            </section>
          </Scroll>
        }}
        <section className=%twc("py-3")>
          <PDP_Normal_TotalPrice_Buyer.MO query selectedOptions withDeliveryCost=false />
        </section>
      </div>
      <div className=%twc("w-full h-[1px] bg-gray-100") />
      <section className=%twc("w-full px-4 py-5 flex items-center")>
        <CartBtn selectedOptions setSelectedOptions query closeFn />
        <span className=%twc("w-2") /> // gap
        <WosBtn selectedOptions query />
      </section>
    </Tabs.Content>
  </Tabs.Root>
}
