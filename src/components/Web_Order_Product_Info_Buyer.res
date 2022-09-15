module PlaceHolder = {
  module PC = {
    @react.component
    let make = () => {
      open Skeleton
      <section className=%twc("flex flex-col gap-5 bg-white rounded-sm")>
        <span className=%twc("text-xl text-enabled-L1 font-bold")>
          {`상품 정보`->React.string}
        </span>
        <div className=%twc("flex justify-between gap-3 h-20")>
          <Box className=%twc("w-20 h-20 rounded-lg") />
          <div className=%twc("flex-auto")>
            <Box className=%twc("w-32 mb-1") />
            <Box className=%twc("w-32 mb-1") />
            <Box className=%twc("w-24") />
          </div>
          <Box className=%twc("w-24 flex min-w-fit") />
        </div>
      </section>
    }
  }
  module MO = {
    @react.component
    let make = () => {
      open Skeleton
      <section className=%twc("flex flex-col gap-5 bg-white rounded-sm")>
        <span className=%twc("text-lg text-enabled-L1 font-bold")>
          {`상품 정보`->React.string}
        </span>
        <div className=%twc("flex justify-between gap-3 h-18")>
          <Box className=%twc("w-18 h-18 rounded-lg") />
          <div className=%twc("flex-auto")>
            <Box className=%twc("w-32 mb-1") />
            <Box className=%twc("w-32 mb-1") />
            <Box className=%twc("w-24") />
          </div>
        </div>
      </section>
    }
  }
}

module Form = Web_Order_Buyer_Form

module List = {
  @react.component
  let make = (~productOptions: array<Form.fixedData>) => {
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
    let make = (~data: Form.productInfo, ~isLast=false) => {
      let {imageUrl, productName, totalPrice, productOptions} = data

      <div className=%twc("w-full flex gap-3 pt-7")>
        <img
          src=imageUrl
          alt="product-image"
          className=%twc("min-w-[80px] min-h-[80px] w-20 h-20 rounded-lg")
        />
        <div
          className={cx([
            %twc(
              "flex flex-col gap-2 w-full pb-7 border border-x-0 border-t-0 border-div-border-L2"
            ),
            isLast ? %twc("border-b-0") : "",
          ])}>
          <div className=%twc("flex flex-row w-full justify-between xl:items-center")>
            <span className=%twc("text-gray-800 font-bold")> {productName->React.string} </span>
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
    let make = (~data: Form.productInfo, ~isLast=false) => {
      let {imageUrl, productName, totalPrice, productOptions} = data
      <div>
        <div className=%twc("w-full flex gap-3 pt-5")>
          <img
            src=imageUrl
            alt="product-image"
            className=%twc("w-18 h-18 min-w-[72px] min-h-[72px] rounded-lg")
          />
          <div className={%twc("flex flex-col gap-2 w-full pb-7")}>
            <div className=%twc("flex flex-col justify-between")>
              <span className=%twc("text-gray-800 font-normal")> {productName->React.string} </span>
              <span className=%twc("text-gray-800 font-bold text-lg")>
                {`${totalPrice->Locale.Int.show}원`->React.string}
              </span>
            </div>
          </div>
        </div>
        <div
          className={isLast ? "" : %twc("pb-5 border border-x-0 border-t-0 border-div-border-L2")}>
          <List productOptions />
        </div>
      </div>
    }
  }
}

module PC = {
  @react.component
  let make = (~productInfos) => {
    <>
      <span className=%twc("text-xl text-enabled-L1 font-bold")>
        {`상품 정보`->React.string}
      </span>
      <div>
        {productInfos
        ->Array.mapWithIndex((idx, data) =>
          <ProductCard.PC
            data isLast={idx == productInfos->Array.length - 1} key={data.productName}
          />
        )
        ->React.array}
      </div>
    </>
  }
}

module MO = {
  @react.component
  let make = (~productInfos) => {
    <>
      <span className=%twc("text-lg text-enabled-L1 font-bold")>
        {`상품 정보`->React.string}
      </span>
      <div className=%twc("pb-8")>
        {productInfos
        ->Array.mapWithIndex((idx, data) =>
          <ProductCard.MO
            data isLast={idx == productInfos->Array.length - 1} key={data.productName}
          />
        )
        ->React.array}
      </div>
    </>
  }
}
