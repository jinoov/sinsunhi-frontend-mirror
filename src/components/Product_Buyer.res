let formatDate = d => d->Js.Date.fromString->Locale.DateTime.formatFromUTC("yyyy/MM/dd HH:mm")

module Item = {
  module AdhocText = {
    @react.component
    let make = (
      ~salesStatus: CustomHooks.Products.salesStatus,
      ~adhocStockIsLimited,
      ~adhocStockNumRemaining,
    ) => {
      // 단품 조회 페이지에서는 판매 가능 수량 노출유무가 false더라도,
      // 바이어에게 구매 가능 수량이 얼마나 남아있는지 UX적으로 안내할 방법이 없는 문제로 인해 수량을 노출시킵니다.
      let adhocRemaningText = switch (
        salesStatus === CustomHooks.Products.SOLDOUT,
        adhocStockIsLimited,
        adhocStockNumRemaining,
      ) {
      | (true, _, _) => "품절"
      | (false, true, Some(remaining)) =>
        `${remaining->Int.toFloat->Locale.Float.show(~digits=0)}개 남음`

      | (false, true, None)
      | (false, false, Some(_))
      | (false, false, None) => "수량 제한 없음"
      }

      <> {adhocRemaningText->React.string} </>
    }
  }
  module Table = {
    @react.component
    let make = (~product: CustomHooks.Products.product) => {
      <>
        <li className=%twc("hidden lg:grid lg:grid-cols-8-buyer-product text-gray-700")>
          <div className=%twc("h-full flex flex-col px-4 py-2")>
            <Product_Badge status=product.salesStatus />
          </div>
          <div className=%twc("h-full flex flex-col px-4 py-2")>
            <span className=%twc("block")> {product.productId->Int.toString->React.string} </span>
            <span className=%twc("block text-gray-500")> {product.productSku->React.string} </span>
          </div>
          <div className=%twc("h-full flex flex-col px-4 py-2")>
            <span className=%twc("block")> {product.productName->React.string} </span>
            <span className=%twc("block text-gray-500")>
              {product.productOptionName->Option.getWithDefault("")->React.string}
            </span>
          </div>
          <div className=%twc("h-full flex flex-col px-4 py-2")>
            <span className=%twc("whitespace-nowrap")>
              {`${product.price->Locale.Float.show(~digits=0)}원`->React.string}
            </span>
          </div>
          <div className=%twc("h-full flex flex-col px-4 py-2")>
            <span className=%twc("whitespace-nowrap")>
              <AdhocText
                salesStatus={product.salesStatus}
                adhocStockIsLimited={product.adhocStockIsLimited}
                adhocStockNumRemaining={product.adhocStockNumRemaining}
              />
            </span>
          </div>
          <div className=%twc("h-full flex flex-col px-4 py-2")>
            <span className=%twc("block")>
              {product.cutOffTime->Option.getWithDefault("")->React.string}
            </span>
          </div>
          <div className=%twc("h-full flex flex-col px-4 py-2")>
            <span className=%twc("block")>
              {product.memo->Option.getWithDefault("")->React.string}
            </span>
          </div>
        </li>
      </>
    }
  }

  module Card = {
    @react.component
    let make = (~product: CustomHooks.Products.product) => {
      <>
        <li className=%twc("py-7 px-5 lg:mb-4 lg:hidden text-black-gl")>
          <section className=%twc("flex justify-between items-start")>
            <div className=%twc("flex")>
              <span className=%twc("w-20 text-gray-gl")> {`상품`->React.string} </span>
              <div className=%twc("ml-2")>
                <span className=%twc("block")>
                  {product.productId->Int.toString->React.string}
                </span>
                <span className=%twc("block mt-1")> {product.productName->React.string} </span>
              </div>
            </div>
            <Product_Badge status=product.salesStatus />
          </section>
          <section className=%twc("py-3")>
            <div className=%twc("flex")>
              <span className=%twc("w-20 text-gray-gl")> {`품목`->React.string} </span>
              <div className=%twc("ml-2")>
                <span className=%twc("block")> {product.productSku->React.string} </span>
                <span className=%twc("block mt-1")>
                  {product.productOptionName
                  ->Option.getWithDefault(`품목명 없음`)
                  ->React.string}
                </span>
              </div>
            </div>
            <div className=%twc("flex mt-3")>
              <span className=%twc("w-20 text-gray-gl")> {`현재 판매가`->React.string} </span>
              <span className=%twc("ml-2")>
                {`${product.price->Locale.Float.show(~digits=0)}원`->React.string}
              </span>
            </div>
            <div className=%twc("flex mt-3")>
              <span className=%twc("w-20 text-gray-gl")>
                {`구매 가능 수량`->React.string}
              </span>
              <span className=%twc("ml-2")>
                <AdhocText
                  salesStatus={product.salesStatus}
                  adhocStockIsLimited={product.adhocStockIsLimited}
                  adhocStockNumRemaining={product.adhocStockNumRemaining}
                />
              </span>
            </div>
            <RadixUI.Separator.Root className=%twc("separator my-5") />
            <div className=%twc("flex mt-3")>
              <span className=%twc("w-20 text-gray-gl")>
                {`출고기준시간`->React.string}
              </span>
              <span className=%twc("ml-2")>
                {product.cutOffTime->Option.getWithDefault("")->React.string}
              </span>
            </div>
            <div className=%twc("flex mt-3")>
              <span className=%twc("w-20 text-gray-gl")> {`메모`->React.string} </span>
              <span className=%twc("ml-2")>
                {product.memo->Option.getWithDefault("")->React.string}
              </span>
            </div>
          </section>
        </li>
      </>
    }
  }
}

@react.component
let make = (~product: CustomHooks.Products.product) => {
  <>
    // PC 뷰
    <Item.Table product />
    // 모바일뷰
    <Item.Card product />
  </>
}
