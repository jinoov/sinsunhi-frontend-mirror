module Fragment = %relay(`
    fragment WebOrderCompleteProductInfoBuyerFragment on Query
    @argumentDefinitions(orderNo: { type: "String!" }) {
      wosOrder(orderNo: $orderNo) {
        orderProducts {
          productId
          productName
          productOptionName
          quantity
          price
          image {
            thumb100x100
          }
        }
      }
    }    
`)

module Placeholder = {
  @react.component
  let make = () => {
    open Skeleton
    <section className=%twc("flex flex-col gap-5 bg-white rounded-sm")>
      <span className=%twc("text-lg xl:text-xl text-enabled-L1 font-bold")>
        {`상품 정보`->React.string}
      </span>
      <div className=%twc("flex justify-between gap-3 h-18 xl:h-20")>
        <Box className=%twc("w-18 h-18 xl:w-20 xl:h-20 rounded-lg") />
        <div className=%twc("flex-auto")>
          <Box className=%twc("w-20 h-5 mb-2") />
          <Box className=%twc("w-20 h-5 ") />
          <Box className=%twc("text-sm text-text-L2 h-6 w-16") />
        </div>
        <Box className=%twc("hidden xl:flex h-6 w-10") />
      </div>
    </section>
  }
}

@spice
type fixedData = {
  price: int,
  productId: int,
  productName: string,
  imageUrl: string,
  productOptionName: string,
  quantity: int,
}

@spice
type productInfo = {
  imageUrl: string,
  productName: string,
  totalPrice: int,
  productOptions: array<fixedData>,
}

let makeProductInfo: array<
  WebOrderCompleteProductInfoBuyerFragment_graphql.Types.fragment_wosOrder_orderProducts,
> => option<productInfo> = data => {
  let first = data->Array.get(0)
  first->Option.map(first' => {
    imageUrl: first'.image->Option.mapWithDefault("", image => image.thumb100x100),
    productName: first'.productName,
    totalPrice: data->Array.map(d => d.price * d.quantity)->Garter_Math.sum_int,
    productOptions: data->Array.map(({
      price,
      productId,
      productName,
      productOptionName,
      quantity,
      image,
    }) => {
      price: price,
      productId: productId,
      productName: productName,
      imageUrl: image->Option.mapWithDefault("", image => image.thumb100x100),
      productOptionName: productOptionName,
      quantity: quantity,
    }),
  })
}

module List = {
  @react.component
  let make = (~productOptions: array<fixedData>) => {
    <div className=%twc("flex flex-col gap-2")>
      {productOptions
      ->Array.map(({productOptionName, quantity, price}) => {
        <div
          key=productOptionName
          className=%twc("flex flex-col p-3 gap-1 w-full bg-gray-50 rounded-md")>
          <span className=%twc("text-sm text-gray-800")> {productOptionName->React.string} </span>
          <span className=%twc("text-sm text-gray-600")>
            {`수량 ${quantity->Locale.Int.show} | ${price->Locale.Int.show}원`->React.string}
          </span>
        </div>
      })
      ->React.array}
    </div>
  }
}

module ProductCard = {
  module PC = {
    @react.component
    let make = (~data: productInfo, ~isLast) => {
      let {imageUrl, productName, totalPrice, productOptions} = data

      <div className=%twc("w-full flex gap-3 pt-7")>
        <img src=imageUrl alt="product-image" className=%twc("w-20 h-20 rounded-lg") />
        <div
          className={cx([
            %twc("flex flex-col gap-2 w-full pb-7"),
            isLast ? "" : %twc("border border-x-0 border-t-0"),
          ])}>
          <div className=%twc("flex flex-row w-full justify-between items-center")>
            <span className=%twc("text-gray-800 font-normal xl:font-bold")>
              {productName->React.string}
            </span>
            <span className=%twc("text-gray-800 font-bold text-base")>
              {`${totalPrice->Locale.Int.show}원`->React.string}
            </span>
          </div>
          <List productOptions />
        </div>
      </div>
    }
  }
  module MO = {
    @react.component
    let make = (~data: productInfo, ~isLast) => {
      let {imageUrl, productName, totalPrice, productOptions} = data
      <div className={isLast ? "" : %twc("border border-x-0 border-t-0 pb-5")}>
        <div className=%twc("w-full flex gap-3 pt-5")>
          <img src=imageUrl alt="product-image" className=%twc("w-18 h-18 rounded-lg") />
          <div className={%twc("flex flex-col gap-2 w-full pb-7")}>
            <div className=%twc("flex flex-col w-full justify-between")>
              <span className=%twc("text-gray-800 font-normal")> {productName->React.string} </span>
              <span className=%twc("text-gray-800 font-bold text-lg")>
                {`${totalPrice->Locale.Int.show}원`->React.string}
              </span>
            </div>
          </div>
        </div>
        <List productOptions />
      </div>
    }
  }
  @react.component
  let make = (~data: productInfo, ~isLast, ~deviceType) => {
    switch deviceType {
    | DeviceDetect.Unknown => React.null
    | DeviceDetect.PC => <PC data isLast />
    | DeviceDetect.Mobile => <MO data isLast />
    }
  }
}

@react.component
let make = (~query, ~deviceType) => {
  let {wosOrder} = Fragment.use(query)

  let groupBy = (
    orderProducts: array<
      WebOrderCompleteProductInfoBuyerFragment_graphql.Types.fragment_wosOrder_orderProducts,
    >,
  ) =>
    orderProducts
    ->Garter_Array.groupBy(a => a.productId, ~id=module(Garter_Id.IntComparable))
    ->Map.valuesToArray

  let productInfos =
    wosOrder
    ->Option.mapWithDefault([], w => w.orderProducts->Array.keepMap(Garter_Fn.identity))
    ->groupBy
    ->Array.keepMap(makeProductInfo)

  switch productInfos {
  | [] => <Placeholder />
  | productInfos' =>
    <section className=%twc("flex flex-col bg-white rounded-sm")>
      <span className=%twc("text-lg xl:text-xl text-enabled-L1 font-bold")>
        {`상품 정보`->React.string}
      </span>
      {productInfos'
      ->Array.mapWithIndex((index, data) =>
        <ProductCard
          data key={data.productName} isLast={index == productInfos'->Array.length - 1} deviceType
        />
      )
      ->React.array}
    </section>
  }
}
