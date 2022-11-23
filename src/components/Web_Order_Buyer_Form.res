let name = "web-order"

@spice
type deliveryType = [
  | @spice.as("parcel") #PARCEL
  | @spice.as("freight") #FREIGHT
  | @spice.as("self") #SELF
]

@spice
type paymentMethod = [
  | @spice.as("card") #CREDIT_CARD
  | @spice.as("virtual") #VIRTUAL_ACCOUNT
  | @spice.as("transfer") #TRANSFER
]

@spice
type fixedData = {
  deliveryCost: int,
  isTaxFree: bool,
  price: int,
  productId: int,
  productName: string,
  imageUrl: string,
  isCourierAvailable: bool,
  productOptionName: string,
  quantity: int,
  stockSku: string,
  isFreeShipping: bool,
  updatedAt: option<string>,
}

@spice
type productInfo = {
  imageUrl: string,
  isCourierAvailable: bool,
  productName: string,
  totalPrice: int,
  isTaxFree: bool,
  updatedAt: option<string>,
  productOptions: array<fixedData>,
}

@spice
type productInfos = array<productInfo>

@spice
type formData = {
  @spice.key("delivery-desired-date") deliveryDesiredDate: option<string>,
  @spice.key("delivery-message") deliveryMessage: option<string>,
  @spice.key("delivery-type") deliveryType: deliveryType,
  @spice.key("order-user-id") orderUserId: int,
  @spice.key("orderer-name") ordererName: string,
  @spice.key("orderer-phone") ordererPhone: string,
  @spice.key("receiver-address") receiverAddress: option<string>,
  @spice.key("receiver-name") receiverName: option<string>,
  @spice.key("receiver-phone") receiverPhone: option<string>,
  @spice.key("receiver-zipcode") receiverZipCode: option<string>,
  @spice.key("receiver-detail-address") receiverDetailAddress: option<string>,
  @spice.key("payment-method") paymentMethod: paymentMethod,
  @spice.key("product-infos") productInfos: productInfos,
}

@spice
type webOrder = {
  @spice.key("order-user-id") orderUserId: int,
  @spice.key("payment-purpose") paymentPurpose: string,
  @spice.key("total-delivery-cost") totalDeliveryCost: int,
  @spice.key("total-order-price") totalOrderPrice: int,
  @spice.key("payment-method") paymentMethod: paymentMethod,
}

@spice
type submit = {@spice.key("web-order") webOrder: formData}

type inputNames = {
  name: string,
  productInfos: string,
  orderUserId: string,
  paymentPurpose: string,
  paymentMethod: string,
  deliveryDesiredDate: string,
  deliveryMessage: string,
  deliveryType: string,
  ordererName: string,
  ordererPhone: string,
  receiverAddress: string,
  receiverName: string,
  receiverPhone: string,
  receiverZipCode: string,
  receiverDetailAddress: string,
}
let names = prefix => {
  name: prefix,
  productInfos: `${prefix}.product-infos`,
  orderUserId: `${prefix}.order-user-id`,
  paymentPurpose: `${prefix}.payment-purpose`,
  paymentMethod: `${prefix}.payment-method`,
  deliveryDesiredDate: `${prefix}.delivery-desired-date`,
  deliveryMessage: `${prefix}.delivery-message`,
  deliveryType: `${prefix}.delivery-type`,
  ordererName: `${prefix}.orderer-name`,
  ordererPhone: `${prefix}.orderer-phone`,
  receiverAddress: `${prefix}.receiver-address`,
  receiverName: `${name}.receiver-name`,
  receiverPhone: `${prefix}.receiver-phone`,
  receiverZipCode: `${prefix}.receiver-zipcode`,
  receiverDetailAddress: `${prefix}.receiver-detail-address`,
}

let strDateToFloat = s => {
  s->Option.mapWithDefault(0., s' => s'->Js.Date.fromString->Js.Date.getTime)
}

let dateCompare = (str1, str2) => {
  str2->strDateToFloat -. str1->strDateToFloat > 0. ? 1 : -1
}

let fixedDataSort = (data: array<fixedData>) => {
  data
  ->List.fromArray
  ->List.sort((item1, item2) => dateCompare(item1.updatedAt, item2.updatedAt))
  ->List.toArray
}

let productInfoSort = (data: array<productInfo>) => {
  data
  ->List.fromArray
  ->List.sort((item1, item2) => dateCompare(item1.updatedAt, item2.updatedAt))
  ->List.toArray
}

let concat = (data: array<fixedData>) => {
  let sorted = data->fixedDataSort
  sorted
  ->Array.get(0)
  ->Option.map(first' => {
    imageUrl: first'.imageUrl,
    isCourierAvailable: first'.isCourierAvailable,
    productName: first'.productName,
    totalPrice: data->Array.map(d => d.price * d.quantity)->Garter_Math.sum_int,
    isTaxFree: first'.isTaxFree,
    productOptions: sorted,
    updatedAt: first'.updatedAt,
  })
}

let toFixedData = (
  {
    product,
    productOption: {stockSku, optionName, price, productOptionCost, isFreeShipping},
    quantity,
    updatedAt,
  }: WebOrderBuyer_TempWosOrder_Query_graphql.Types.response_tempWosOrder_data_productOptions,
) => {
  product->Option.map(({number, displayName, isCourierAvailable, image, isVat}) => {
    deliveryCost: productOptionCost.deliveryCost,
    isTaxFree: !(isVat->Option.getWithDefault(false)),
    price: price->Option.getWithDefault(0),
    productId: number,
    productName: displayName,
    imageUrl: image.thumb100x100,
    isCourierAvailable: isCourierAvailable->Option.getWithDefault(false),
    productOptionName: optionName,
    quantity,
    stockSku,
    isFreeShipping,
    updatedAt,
  })
}

// ---- START GTM ----
let gtmDataPush = (data: array<productInfo>) => {
  DataGtm.push({"ecommerce": Js.Null.empty}) // ecommerce 초기화하지 않으면 이전에 날렸던 ecommerce값이 그대로 날아가게 됩니다. (덮어쓰기 안됨)
  {
    "event": "add_shipping_info",
    "ecommerce": {
      "value": data->Array.map(info => info.totalPrice)->Garter.Math.sum_int->Int.toString,
      "currency": "KRW",
      "items": data
      ->Array.map(info =>
        info.productOptions->Array.map(option => {
          {
            "item_id": option.productId->Int.toString,
            "item_name": option.productName,
            "price": option.price->Int.toString,
            "quantity": option.quantity,
            "item_variant": option.productOptionName,
          }
        })
      )
      ->Array.concatMany
      ->Array.mapWithIndex((i, obj) => Js.Obj.assign(obj, {"index": i})),
    },
  }
  ->DataGtm.mergeUserIdUnsafe
  ->DataGtm.push
}

// ---- END GTM ----
