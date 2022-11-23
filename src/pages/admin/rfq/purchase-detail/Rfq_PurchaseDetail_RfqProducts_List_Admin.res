module Form = Edit_RfqProduct_Form_Admin

module Style = {
  let grid = %twc(
    "grid grid-cols-[130px_100px_220px_150px_150px_150px_150px_150px_170px_230px_150px_310px_140px_90px]"
  )

  let gridCulumn = %twc("h-full px-4 flex items-center whitespace-nowrap")
}

module Head = {
  @react.component
  let make = () => {
    <div className={cx([Style.grid, %twc("bg-gray-100 text-gray-500 h-12")])}>
      <div className=Style.gridCulumn> {`견적 상품 번호`->React.string} </div>
      <div className=Style.gridCulumn> {`사업부`->React.string} </div>
      <div className=Style.gridCulumn> {`품목/품종`->React.string} </div>
      <div className=Style.gridCulumn> {`중량/수량/용량`->React.string} </div>
      <div className=Style.gridCulumn> {`단위당 희망가`->React.string} </div>
      <div className=Style.gridCulumn> {`생산자 공급가`->React.string} </div>
      <div className=Style.gridCulumn> {`총 견적 희망가`->React.string} </div>
      <div className=Style.gridCulumn> {`배송비`->React.string} </div>
      <div className=Style.gridCulumn> {`배송 방법`->React.string} </div>
      <div className=Style.gridCulumn> {`생산자`->React.string} </div>
      <div className=Style.gridCulumn> {`진행상태`->React.string} </div>
      <div className=Style.gridCulumn> {`사유`->React.string} </div>
      <div className=Style.gridCulumn> {`즉시구매 상품번호`->React.string} </div>
      <div className=Style.gridCulumn> {``->React.string} </div>
    </div>
  }
}

module ListItem = {
  module Fragment = %relay(`
    fragment RfqPurchaseDetailRfqProductsListAdminListItemFragment on RfqProduct {
      id
      number
      category {
        fullyQualifiedName {
          name
        }
      }
      amount
      amountUnit
      unitPrice
      sellerPrice
      price
      deliveryFee
      deliveryMethod
      seller {
        id
        name
      }
      status
      statusInfo
      promotedProduct {
        promotedProductId: number
      }
      isDeletable
    
      ...EditRfqProductModalAdminFragment
    }
  `)

  module Department = {
    type t =
      | Agriculture // 농산
      | Meat // 축산
      | Seafood // 수산

    let fromCategoryName = name => {
      if name == `농산물` {
        Agriculture->Some
      } else if name == `축산물` {
        Meat->Some
      } else if name == `수산물/건수산` {
        Seafood->Some
      } else {
        None
      }
    }

    let toLabel = department => {
      switch department {
      | Agriculture => `농산`
      | Meat => `축산`
      | Seafood => `수산`
      }
    }
  }

  module AmountUnit = {
    let toLabel = v => {
      switch v {
      | #G => "g"
      | #KG => "kg"
      | #T => "t"
      | #ML => "ml"
      | #L => "l"
      | #EA => "ea"
      | _ => ""
      }
    }
  }

  module Updater = {
    open Form

    type rfqProduct = {
      amount: option<float>,
      unitPrice: option<int>,
      sellerPrice: option<int>,
      deliveryFee: option<int>,
      deliveryMethod: option<string>,
      status: option<string>,
      statusInfo: option<string>,
      promotedProductId: option<int>,
      sellerId: option<string>,
    }

    type status =
      | Available(rfqProduct)
      | NotAvailable

    let filterEmpty = s => s == "" ? None : Some(s)

    let validationReducer = (prev, (k, v)) => {
      switch k {
      | "amount" =>
        Available({
          ...prev,
          amount: v->filterEmpty->Option.flatMap(Float.fromString),
        })

      | "unitPrice" =>
        Available({
          ...prev,
          unitPrice: v->filterEmpty->Option.flatMap(Int.fromString),
        })

      | "sellerPrice" =>
        Available({
          ...prev,
          sellerPrice: v->filterEmpty->Option.flatMap(Int.fromString),
        })

      | "deliveryFee" =>
        Available({
          ...prev,
          deliveryFee: v->filterEmpty->Option.flatMap(Int.fromString),
        })

      | "deliveryMethod" =>
        Available({
          ...prev,
          deliveryMethod: v->filterEmpty,
        })

      | "status" =>
        Available({
          ...prev,
          status: v->filterEmpty,
        })

      | "status-info" =>
        Available({
          ...prev,
          statusInfo: v->filterEmpty,
        })

      | "promoted-product-id" =>
        Available({
          ...prev,
          promotedProductId: v->filterEmpty->Option.flatMap(Int.fromString),
        })

      | "seller-id" =>
        Available({
          ...prev,
          sellerId: v->filterEmpty,
        })

      | _ => NotAvailable
      }
    }

    let validate = mapValue => {
      let init = Available({
        amount: None,
        unitPrice: None,
        sellerPrice: None,
        deliveryFee: None,
        deliveryMethod: None,
        status: None,
        statusInfo: None,
        promotedProductId: None,
        sellerId: None,
      })

      mapValue
      ->Map.String.toArray
      ->Array.reduce(init, (prev, curr) => {
        let (k, currV) = curr
        switch (prev, currV) {
        | (NotAvailable, _) | (_, Invalid(_)) => NotAvailable
        | (Available(prev'), Valid(v)) => prev'->validationReducer((k, v))
        }
      })
    }
  }

  @react.component
  let make = (~query, ~onChange, ~connectionId, ~softRefresh) => {
    let {
      id,
      number,
      category,
      amount,
      amountUnit,
      unitPrice,
      price,
      sellerPrice,
      deliveryMethod,
      deliveryFee,
      status,
      seller,
      statusInfo,
      promotedProduct,
      isDeletable,
      fragmentRefs,
    } =
      query->Fragment.use

    let department = {
      category.fullyQualifiedName
      ->Array.get(0)
      ->Option.flatMap(({name}) => name->Department.fromCategoryName)
    }

    let itemKind = {
      switch department {
      | Some(Meat) => [
          category.fullyQualifiedName->Array.get(1)->Option.mapWithDefault("", ({name}) => name),
          category.fullyQualifiedName->Array.get(4)->Option.mapWithDefault("", ({name}) => name),
        ]

      | _ => [
          category.fullyQualifiedName->Array.get(3)->Option.mapWithDefault("", ({name}) => name),
          category.fullyQualifiedName->Array.get(4)->Option.mapWithDefault("", ({name}) => name),
        ]
      }->Js.Array2.joinWith("/")
    }

    let default =
      [
        ("amount", amount->Form.Amount.makeDefault),
        ("unitPrice", unitPrice->Form.UnitPrice.makeDefault),
        ("sellerPrice", sellerPrice->Form.SellerPrice.makeDefault),
        ("deliveryFee", deliveryFee->Form.DeliveryFee.makeDefault),
        ("deliveryMethod", deliveryMethod->Form.DeliveryMethod.makeDefault),
        ("status", status->Form.Status.makeDefault),
        (
          "seller-id",
          seller->Option.mapWithDefault(Form.Valid(""), ({id}) => id->Form.Seller.makeDefault),
        ),
        ("status-info", statusInfo->Form.StatusInfo.makeDefault),
        (
          "promoted-product-id",
          promotedProduct
          ->Option.map(({promotedProductId}) => promotedProductId)
          ->Form.PromotedProductId.makeDefault,
        ),
      ]->Map.String.fromArray

    let (value, setValue) = React.Uncurried.useState(_ => default)
    let (showModal, setShowModal) = React.Uncurried.useState(_ =>
      Edit_RfqProduct_Modal_Admin.Modal.Hide
    )

    React.useEffect2(() => {
      let defaultValues = default->Map.String.valuesToArray
      let currentValues = value->Map.String.valuesToArray

      if defaultValues == currentValues {
        None->onChange
      } else {
        value->Updater.validate->Some->onChange
      }

      None
    }, (default, value))

    <>
      <div className={cx([Style.grid, %twc("h-[60px]")])}>
        <div className=Style.gridCulumn>
          <span
            className=%twc("text-[#3B6DE3] underline cursor-pointer")
            onClick={_ => setShowModal(._ => Show)}>
            {
              let rfqId = number->Int.toString
              let rfqIdLabel = (`000000` ++ rfqId)->Js.String2.sliceToEnd(~from=-6)
              `${rfqIdLabel}`->React.string
            }
          </span>
        </div>
        <div className=Style.gridCulumn>
          {department->Option.mapWithDefault("-", Department.toLabel)->React.string}
        </div>
        <div className={cx([Style.gridCulumn, %twc("break-all whitespace-pre-wrap")])}>
          {itemKind->React.string}
        </div>
        <div className=Style.gridCulumn>
          <Form.Amount
            defaultValue=?{default->Map.String.get("amount")}
            onChange={v => setValue(.prev => prev->Map.String.set("amount", v))}
          />
          <span className=%twc("ml-1")> {amountUnit->AmountUnit.toLabel->React.string} </span>
        </div>
        <div className=Style.gridCulumn>
          <Form.UnitPrice
            defaultValue=?{default->Map.String.get("unitPrice")}
            onChange={v => setValue(.prev => prev->Map.String.set("unitPrice", v))}
          />
          <span className=%twc("ml-1")> {"원"->React.string} </span>
        </div>
        <div className=Style.gridCulumn>
          <Form.SellerPrice
            defaultValue=?{default->Map.String.get("sellerPrice")}
            onChange={v => setValue(.prev => prev->Map.String.set("sellerPrice", v))}
          />
          <span className=%twc("ml-1")> {"원"->React.string} </span>
        </div>
        <div className=Style.gridCulumn>
          {`${price->Locale.Float.show(~digits=0)}원`->React.string}
        </div>
        <div className=Style.gridCulumn>
          <Form.DeliveryFee
            defaultValue=?{default->Map.String.get("deliveryFee")}
            onChange={v => setValue(.prev => prev->Map.String.set("deliveryFee", v))}
          />
          <span className=%twc("ml-1")> {"원"->React.string} </span>
        </div>
        <div className=Style.gridCulumn>
          <Form.DeliveryMethod
            defaultValue=?{default->Map.String.get("deliveryMethod")}
            onChange={v => setValue(.prev => prev->Map.String.set("deliveryMethod", v))}
          />
        </div>
        <div className=Style.gridCulumn>
          <Form.Seller.Select
            defaultId=?{seller->Option.map(({id}) => id)}
            defaultName=?{seller->Option.map(({name}) => name)}
            onChange={v => setValue(.prev => prev->Map.String.set("seller-id", v))}
          />
        </div>
        <div className=Style.gridCulumn>
          <Form.Status
            defaultValue=?{default->Map.String.get("status")}
            onChange={v => setValue(.prev => prev->Map.String.set("status", v))}
          />
        </div>
        <div className=Style.gridCulumn>
          <Form.StatusInfo
            defaultValue=?{default->Map.String.get("status-info")}
            onChange={v => setValue(.prev => prev->Map.String.set("status-info", v))}
          />
        </div>
        <div className=Style.gridCulumn>
          <Form.PromotedProductId
            defaultValue=?{default->Map.String.get("promoted-product-id")}
            onChange={v => setValue(.prev => prev->Map.String.set("promoted-product-id", v))}
          />
        </div>
        <div className=Style.gridCulumn>
          <Delete_RfqProduct_Button_Admin isDeletable targetId=id connectionId />
        </div>
      </div>
      <Edit_RfqProduct_Modal_Admin
        title={`'${itemKind}' '${amount->Float.toString}${amountUnit->AmountUnit.toLabel}'`}
        query=fragmentRefs
        rfqNodeId=id
        softRefresh
        showModal
        setShowModal
      />
    </>
  }
}

module Fragment = %relay(`
  fragment RfqPurchaseDetailRfqProductsListAdminFragment on Rfq
  @argumentDefinitions(first: { type: "Int", defaultValue: 99 }) {
    id
    rfqProducts(first: $first)
      @connection(
        key: "RfqPurchaseDetailRfqProductsListAdminFragment_rfqProducts"
      ) {
      connectionId: __id
      totalCount
      edges {
        node {
          id
          ...RfqPurchaseDetailRfqProductsListAdminListItemFragment
        }
      }
    }
  }
`)

@react.component
let make = (~query, ~onChangeList, ~resetKey, ~softRefresh) => {
  let {id, rfqProducts} = query->Fragment.use

  <section className=%twc("mt-4 w-full p-7 bg-white rounded-sm text-text-L1")>
    <div className=%twc("flex items-center justify-between")>
      <div className=%twc("flex items-center")>
        <h2 className=%twc("font-bold")> {`신청 품목/품종`->React.string} </h2>
        <span className=%twc("ml-1 text-base text-primary")>
          {`${rfqProducts.edges->Array.length->Int.toString}개`->React.string}
        </span>
      </div>
      <Add_RfqProduct_Button_Admin rfqNodeId=id connectionId=rfqProducts.connectionId />
    </div>
    <div className=%twc("mt-4 w-full overflow-x-scroll pb-[120px]")>
      <div className=%twc("min-w-max text-sm divide-y divide-gray-100")>
        <Head />
        <ol className=%twc("divide-y divide-gray-100")>
          {switch rfqProducts.edges {
          | [] => React.null
          | nonEmptyEdges =>
            nonEmptyEdges
            ->Array.map(({node: {id, fragmentRefs}}) => {
              <ListItem
                key={`${id}-${resetKey}`}
                softRefresh
                connectionId=rfqProducts.connectionId
                query=fragmentRefs
                onChange={v => onChangeList(id, v)}
              />
            })
            ->React.array
          }}
        </ol>
      </div>
    </div>
  </section>
}
