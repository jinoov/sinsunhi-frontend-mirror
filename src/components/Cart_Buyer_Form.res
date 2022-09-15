let name = "cart"

@spice
type productStatus = [
  | @spice.as("sale") #SALE
  | @spice.as("soldout") #SOLDOUT
  | @spice.as("hidden_sale") #HIDDEN_SALE
  | @spice.as("nosale") #NOSALE
  | @spice.as("retire") #RETIRE
]

@spice
type productOption = {
  checked: bool,
  @spice.key("cart-id") cartId: int,
  @spice.key("product-option-id") productOptionId: int,
  @spice.key("product-option-name") productOptionName: option<string>,
  @spice.key("option-status") optionStatus: productStatus,
  @spice.key("updated-at") updatedAt: option<string>,
  price: int,
  quantity: int,
}

@spice
type productOptions = array<productOption>

@spice
type cartItem = {
  checked: bool,
  @spice.key("checked-number") checkedNumber: int,
  @spice.key("product-id") productId: int,
  @spice.key("image-url") imageUrl: option<string>,
  @spice.key("product-name") productName: option<string>,
  @spice.key("total-price") totalPrice: option<int>,
  @spice.key("updated-at") updatedAt: option<string>,
  @spice.key("product-status") productStatus: productStatus,
  @spice.key("product-options") productOptions: productOptions,
}

@spice
type orderType = [
  | @spice.as("courier-available") #CourierAvailable
  | @spice.as("un-courier-available") #UnCourierAvailable
]

@spice
type cart = {
  checked: bool,
  @spice.key("cart-items") cartItems: option<array<cartItem>>,
}

@spice
type cartContainer = {
  @spice.key("order-type") orderType: orderType,
  @spice.key("courier-available-item") courierAvailableItem: cart,
  @spice.key("un-courier-available-item") unCourierAvailableItem: cart,
}

@spice
type submit = {cart: cartContainer}

type inputNames = {
  name: string,
  orderType: string,
  courierAvailableItem: string,
  unCourierAvailableItem: string,
  cartId: string,
  cartItems: string,
  productId: string,
  checked: string,
  productOptionId: string,
  productOptionName: string,
  price: string,
  quantity: string,
  productName: string,
  totalPrice: string,
  productOptions: string,
  productStatus: string,
  optionStatus: string,
  checkedNumber: string,
  imageUrl: string,
  updatedAt: string,
}

let names = prefix => {
  name: prefix,
  orderType: `${prefix}.order-type`,
  courierAvailableItem: `${prefix}.courier-available-item`,
  unCourierAvailableItem: `${prefix}.un-courier-available-item`,
  cartItems: `${prefix}.cart-items`,
  cartId: `${prefix}.cart-id`,
  productId: `${prefix}.product-id`,
  checked: `${prefix}.checked`,
  productOptionId: `${prefix}.product-option-id`,
  productOptionName: `${prefix}.product-option-name`,
  price: `${prefix}.price`,
  quantity: `${prefix}.quantity`,
  productName: `${prefix}.product-name`,
  totalPrice: `${prefix}.total-price`,
  productOptions: `${prefix}.product-options`,
  productStatus: `${prefix}.product-status`,
  imageUrl: `${prefix}.image-url`,
  optionStatus: `${prefix}.option-status`,
  checkedNumber: `${prefix}.checked-number`,
  updatedAt: `${prefix}.updated-at`,
}

let soldable = (s: productStatus) =>
  switch s {
  | #SALE
  | #HIDDEN_SALE => true
  | _ => false
  }

let toVariant: CartBuyerItemFragment_graphql.Types.enum_ProductStatus => productStatus = s =>
  switch s {
  | #SALE => #SALE
  | #SOLDOUT => #SOLDOUT
  | #HIDDEN_SALE => #HIDDEN_SALE
  | #NOSALE => #NOSALE
  | #RETIRE => #RETIRE
  | _ => #SALE
  }

let strDateToFloat = s => {
  s->Option.mapWithDefault(0., s' => s'->Js.Date.fromString->Js.Date.getTime)
}

let groupBy = (arrayOfCartItem: array<CartBuyerItemFragment_graphql.Types.fragment_cartItems>) =>
  arrayOfCartItem
  ->Garter_Array.groupBy(a => a.productId, ~id=module(Garter.Id.IntComparable))
  ->Map.valuesToArray

let dateCompare = (str1, str2) => {
  str2->strDateToFloat -. str1->strDateToFloat > 0. ? 1 : -1
}

let compare = (
  item1: CartBuyerItemFragment_graphql.Types.fragment_cartItems,
  item2: CartBuyerItemFragment_graphql.Types.fragment_cartItems,
) => {
  switch (item1.optionStatus, item2.optionStatus) {
  | (#SOLDOUT, #SOLDOUT) => dateCompare(item1.updatedAt, item2.updatedAt)
  | (#SOLDOUT, _) => 1
  | (_, #SOLDOUT) => -1
  | _ => dateCompare(item1.updatedAt, item2.updatedAt)
  }
}

let orderByCartItem = (arr: array<cartItem>) => {
  arr
  ->List.fromArray
  ->List.sort((item1, item2) => dateCompare(item1.updatedAt, item2.updatedAt))
  ->List.toArray
}

let orderByRawData = (arr: array<CartBuyerItemFragment_graphql.Types.fragment_cartItems>) =>
  arr->List.fromArray->List.sort(compare)->List.toArray

let map: array<CartBuyerItemFragment_graphql.Types.fragment_cartItems> => option<
  cartItem,
> = arr => {
  let ordered = arr->orderByRawData
  ordered
  ->Garter.Array.first
  ->Option.map(item => {
    {
      checked: true,
      checkedNumber: ordered->Array.length,
      productId: item.productId,
      productName: item.productName,
      totalPrice: Some(0),
      productStatus: item.productStatus->toVariant,
      imageUrl: item.image->Option.map(image' => image'.thumb100x100),
      updatedAt: item.updatedAt,
      productOptions: ordered->Array.map(item' => {
        checked: true,
        cartId: item'.cartId,
        productOptionId: item'.optionId,
        productOptionName: item'.optionName,
        optionStatus: item'.optionStatus->toVariant,
        price: item'.price,
        quantity: item'.quantity,
        updatedAt: item'.updatedAt,
      }),
    }
  })
}

// ---- START GTM ----
let makeGtmData = (data: array<cartItem>, cartIds: array<int>, eventType: string) => {
  {
    "event": eventType,
    "ecommerce": {
      "value": data
      ->Array.map(item => item.productOptions->Array.map(({price, quantity}) => price * quantity))
      ->Array.concatMany
      ->Garter.Math.sum_int
      ->Int.toString,
      "currency": "KRW",
      "items": data
      ->Array.map(item => {
        ...item,
        productOptions: item.productOptions->Array.keep(option =>
          cartIds->Array.some(a => a == option.cartId)
        ),
      })
      ->Array.map(item => {
        item.productOptions->Array.map(option => {
          {
            "item_id": item.productId->Int.toString,
            "item_name": item.productName->Option.getWithDefault(""),
            "price": option.price->Int.toString,
            "quantity": option.quantity,
            "item_variant": option.productOptionName,
            "index": None,
          }
        })
      })
      ->Array.concatMany
      ->Array.mapWithIndex((idx, obj) => Js.Obj.assign(obj, {"index": Some(idx)})),
    },
  }
}

let cartGtmPush = (data, cartIds, eventType) => {
  DataGtm.push({"ecommerce": Js.Null.empty}) // ecommerce 초기화하지 않으면 이전에 날렸던 ecommerce값이 그대로 날아가게 됩니다. (덮어쓰기 안됨)
  data->makeGtmData(cartIds, eventType)->DataGtm.mergeUserIdUnsafe->DataGtm.push
}
// ---- END GTM ----
