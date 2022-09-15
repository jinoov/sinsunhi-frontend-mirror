module Query = %relay(`
    query WebOrderItemBuyer_Query($productNos: [Int!]) {
      products(productNos: $productNos, sort: UPDATED_ASC) {
        edges {
          node {
            ... on NormalProduct {
              image {
                thumb100x100
              }
              displayName
              isCourierAvailable
              number
              isVat
              productOptions {
                edges {
                  node {
                    grade
                    optionName
                    stockSku
                    price
                    isFreeShipping
                    productOptionCost {
                      deliveryCost
                    }
                  }
                }
              }
            }
            ... on QuotableProduct {
              image {
                thumb100x100
              }
              displayName
              isCourierAvailable
              number
              isVat
              productOptions {
                edges {
                  node {
                    grade
                    optionName
                    stockSku
                    price
                    isFreeShipping
                    productOptionCost {
                      deliveryCost
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
`)

// HIDDEN_SALE이 Query.products로 조회되지 않기 때문에 임시로 단건조회를 여러번하는 코드를 추가하였습니다.
// 22.08.25 작성되었습니다.
// 이 부분 개선이 이루어지면 해당 코드 수정하겠습니다.
module TempQuery = %relay(`
  query WebOrderItemBuyer_Temp_Query($number: Int!) {
    product(number: $number) {
      ... on NormalProduct {
        image {
          thumb100x100
        }
        displayName
        isCourierAvailable
        number
        isVat
        productOptions {
          edges {
            node {
              grade
              optionName
              stockSku
              price
              isFreeShipping
              productOptionCost {
                deliveryCost
              }
            }
          }
        }
      }
      ... on QuotableProduct {
        image {
          thumb100x100
        }
        displayName
        isCourierAvailable
        number
        isVat
        productOptions {
          edges {
            node {
              grade
              optionName
              stockSku
              price
              isFreeShipping
              productOptionCost {
                deliveryCost
              }
            }
          }
        }
      }
    }
  }
`)

open ReactHookForm
open Web_Order_Util_Component
module Form = Web_Order_Buyer_Form

module PlaceHolder = {
  module PC = {
    @react.component
    let make = (~deviceType) => {
      let router = Next.Router.useRouter()

      <>
        <Header_Buyer.PC_Old key=router.asPath />
        <main className=%twc("flex flex-col gap-5 px-[16%] py-20 bg-surface")>
          <h1 className=%twc("flex ml-5 mb-3 text-3xl font-bold text-enabled-L1")>
            {`주문·결제`->React.string}
          </h1>
          <div className=%twc("flex flex-col xl:flex-row gap-5")>
            <article className=%twc("w-3/5 flex flex-col gap-5 min-w-[550px]")>
              <div className=%twc("flex flex-col gap-7 p-7 bg-white")>
                <Web_Order_Product_Info_Buyer.PlaceHolder.PC />
                <div className=%twc("h-px bg-border-default-L2") />
                <Web_Order_Orderer_Info_Buyer.PlaceHolder deviceType />
              </div>
              <Web_Order_Delivery_Method_Selection_Buyer.PlaceHoder.PC />
            </article>
            <aside className=%twc("w-2/5")> <Web_Order_Payment_Info_Buyer.PlaceHolder.PC /> </aside>
          </div>
        </main>
        <Footer_Buyer.PC />
      </>
    }
  }
  module MO = {
    @react.component
    let make = (~deviceType) => {
      let router = Next.Router.useRouter()

      <>
        <Header_Buyer.Mobile key=router.asPath />
        <main className=%twc("flex flex-col gap-3 bg-surface")>
          <div className=%twc("flex flex-col gap-4")>
            <article className=%twc("w-full flex flex-col gap-5")>
              <div className=%twc("flex flex-col gap-7 p-7 bg-white")>
                <Web_Order_Product_Info_Buyer.PlaceHolder.MO />
                <div className=%twc("h-px bg-border-default-L2") />
                <Web_Order_Orderer_Info_Buyer.PlaceHolder deviceType />
              </div>
              <Web_Order_Delivery_Method_Selection_Buyer.PlaceHoder.MO />
            </article>
            <aside className=%twc("w-full")>
              <Web_Order_Payment_Info_Buyer.PlaceHolder.MO />
            </aside>
          </div>
        </main>
        <Footer_Buyer.MO />
      </>
    }
  }
  @react.component
  let make = (~deviceType) => {
    switch deviceType {
    | DeviceDetect.Unknown => React.null
    | DeviceDetect.PC => <PC deviceType />
    | DeviceDetect.Mobile => <MO deviceType />
    }
  }
}

module PC = {
  @react.component
  let make = (
    ~productInfos,
    ~firstIsCourierAvailable,
    ~isSameCourierAvailable,
    ~formNames: Form.inputNames,
    ~watchValue,
    ~deviceType,
  ) => {
    <main className=%twc("flex flex-col gap-5 px-[16%] py-20 bg-surface")>
      <h1 className=%twc("flex ml-5 mb-3 text-3xl font-bold text-enabled-L1")>
        {`주문·결제`->React.string}
      </h1>
      <div className=%twc("flex flex-row gap-5")>
        <article className=%twc("w-2/3 flex flex-col gap-5 min-w-[550px]")>
          <div className=%twc("flex flex-col gap-7 p-7 bg-white")>
            <Web_Order_Product_Info_Buyer.PC productInfos />
            <Web_Order_Orderer_Info_Buyer deviceType />
          </div>
          <section className=%twc("flex flex-col gap-5 p-7 bg-white rounded-sm")>
            <span className=%twc("flex items-center gap-1 text-xl text-enabled-L1 font-bold")>
              {`배송 방식 선택`->React.string}
              <Tooltip.PC className=%twc("flex")>
                {`선택하신 배송 방식에 따라 배송비 부과 정책이 달라집니다.`->React.string}
              </Tooltip.PC>
            </span>
            <Web_Order_Delivery_Method_Selection_Buyer
              isCourierAvailable=firstIsCourierAvailable
              isSameCourierAvailable
              prefix=formNames.name
              deviceType
            />
            <Web_Order_Delivery_Form prefix=formNames.name watchValue deviceType />
          </section>
        </article>
        <aside className=%twc("w-1/3 min-h-full relative bottom-0")>
          <Web_Order_Payment_Info_Buyer prefix=formNames.name productInfos deviceType />
        </aside>
      </div>
    </main>
  }
}

module MO = {
  @react.component
  let make = (
    ~productInfos,
    ~firstIsCourierAvailable,
    ~isSameCourierAvailable,
    ~formNames: Form.inputNames,
    ~watchValue,
    ~deviceType,
  ) => {
    <main className=%twc("flex flex-col gap-5 bg-surface")>
      <div className=%twc("flex flex-col gap-4")>
        <article className=%twc("w-full flex flex-col gap-5")>
          <div className=%twc("flex flex-col gap-2 p-5 pb-7 bg-white")>
            <Web_Order_Product_Info_Buyer.MO productInfos />
            <div className=%twc("h-px bg-div-border-L2") />
            <Web_Order_Orderer_Info_Buyer deviceType />
          </div>
          <section className=%twc("flex flex-col gap-5 p-5 pb-7 bg-white rounded-sm")>
            <span className=%twc("flex items-center gap-1 text-lg text-enabled-L1 font-bold")>
              {`배송 방식 선택`->React.string}
              <Tooltip.Mobile className=%twc("flex")>
                {`선택하신 배송 방식에 따라 배송비 부과 정책이 달라집니다.`->React.string}
              </Tooltip.Mobile>
            </span>
            <Web_Order_Delivery_Method_Selection_Buyer
              isCourierAvailable=firstIsCourierAvailable
              isSameCourierAvailable
              prefix=formNames.name
              deviceType
            />
            <Web_Order_Delivery_Form prefix=formNames.name watchValue deviceType />
          </section>
        </article>
        <aside className=%twc("w-full relative bottom-0")>
          <Web_Order_Payment_Info_Buyer prefix=formNames.name productInfos deviceType />
        </aside>
      </div>
    </main>
  }
}

@react.component
let make = (~productNos, ~skuNos, ~skuMap, ~deviceType) => {
  let {setValue} = Hooks.Context.use(. ~config=Hooks.Form.config(~mode=#onChange, ()), ())
  let router = Next.Router.useRouter()
  let formNames = Form.names(Form.name)

  // HIDDEN_SALE이 Query.products로 조회되지 않기 때문에 임시로 단건조회를 여러번하는 코드를 추가하였습니다.
  // 22.08.25 작성되었습니다.
  // 이 부분 개선이 이루어지면 해당 코드 수정하겠습니다.
  // let {products} = Query.use(
  //   ~variables={
  //     productNos: Some(productNos),
  //   },
  //   ~fetchPolicy=RescriptRelay.StoreAndNetwork,
  //   (),
  // )

  let temp =
    productNos
    ->Set.Int.fromArray
    ->Set.Int.toArray
    ->Array.map(a =>
      TempQuery.use(
        ~variables={
          number: a,
        },
        ~fetchPolicy=RescriptRelay.StoreAndNetwork,
        (),
      )
    )

  let productInfos =
    temp
    ->Array.map(({product}) =>
      switch product {
      | Some(#NormalProduct(product)) =>
        product.productOptions.edges
        ->Array.keep(option => skuNos->Set.String.has(option.node.stockSku))
        ->Array.keepMap(option =>
          skuMap
          ->Map.String.get(option.node.stockSku)
          ->Option.map(Form.normalProductToFixedDataTemp(product, option))
        )
      | Some(#QuotableProduct(product)) =>
        product.productOptions.edges
        ->Array.keep(option => skuNos->Set.String.has(option.node.stockSku))
        ->Array.keepMap(option =>
          skuMap
          ->Map.String.get(option.node.stockSku)
          ->Option.map(Form.quotableProductToFixedDataTemp(product, option))
        )
      | _ => []
      }
    )
    ->Array.keepMap(Form.concat)
    ->Form.productInfoSort

  // HIDDEN_SALE이 Query.products로 조회되지 않기 때문에 임시로 단건조회를 여러번하는 코드를 추가하였습니다.
  // 22.08.25 작성되었습니다.
  // 이 부분 개선이 이루어지면 해당 코드 수정하겠습니다.
  // let productInfos =
  //   products.edges
  //   ->Array.map(({node}) =>
  //     switch node {
  //     | #NormalProduct(product) =>
  //       product.productOptions.edges
  //       ->Array.keep(option => skuNos->Set.String.has(option.node.stockSku))
  //       ->Array.keepMap(option =>
  //         skuMap
  //         ->Map.String.get(option.node.stockSku)
  //         ->Option.map(Form.normalProductToFixedData(product, option))
  //       )
  //     | #QuotableProduct(product) =>
  //       product.productOptions.edges
  //       ->Array.keep(option => skuNos->Set.String.has(option.node.stockSku))
  //       ->Array.keepMap(option =>
  //         skuMap
  //         ->Map.String.get(option.node.stockSku)
  //         ->Option.map(Form.quotableProductToFixedData(product, option))
  //       )
  //     | _ => []
  //     }
  //   )
  //   ->Array.keepMap(Form.concat)
  //   ->Form.productInfoSort

  let firstIsCourierAvailable =
    productInfos->Array.get(0)->Option.map(first => first.isCourierAvailable)
  let isSameCourierAvailable =
    firstIsCourierAvailable->Option.map(first' =>
      productInfos->Array.map(t => t.isCourierAvailable)->Array.every(c => c == first')
    )

  let defaultDeliveryType = switch firstIsCourierAvailable {
  | Some(first) =>
    switch isSameCourierAvailable {
    | Some(same) => first && same ? "parcel" : "freight"
    | None => "freight"
    }
  | None => "freight"
  }

  let watchValue = Hooks.WatchValues.use(
    Hooks.WatchValues.Text,
    ~config=Hooks.WatchValues.config(~name=formNames.deliveryType, ()),
    (),
  )

  React.useEffect0(_ => {
    productInfos->Form.gtmDataPush
    setValue(. formNames.productInfos, productInfos->Form.productInfos_encode)
    setValue(. formNames.deliveryType, defaultDeliveryType->Js.Json.string)
    None
  })

  {
    switch deviceType {
    | DeviceDetect.Unknown => React.null
    | DeviceDetect.PC => <>
        <Header_Buyer.PC_Old key=router.asPath />
        <PC
          productInfos
          firstIsCourierAvailable
          isSameCourierAvailable
          formNames
          watchValue
          deviceType
        />
        <Footer_Buyer.PC />
      </>
    | DeviceDetect.Mobile => <>
        <Header_Buyer.Mobile key=router.asPath />
        <MO
          productInfos
          firstIsCourierAvailable
          isSameCourierAvailable
          formNames
          watchValue
          deviceType
        />
        <Footer_Buyer.MO />
      </>
    }
  }
}
