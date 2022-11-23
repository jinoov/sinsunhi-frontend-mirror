/*
  1. 컴포넌트 위치
  PDP > 일반 상품 > 단품 옵션 셀렉터
  
  2. 역할
  일반 상품이 가진 단품을 선택할 수 있습니다.
*/

module Fragments = {
  module List = %relay(`
   fragment PDPNormalSelectOptionBuyerFragment on Product
   @argumentDefinitions(
     first: { type: "Int", defaultValue: 20 }
     after: { type: "ID", defaultValue: null }
   ) {
     status
   
     ... on NormalProduct {
       productOptions(first: $first, after: $after) {
         edges {
           node {
             id
             stockSku
             optionName
             product {
               id
               productId: number
             }
             price
             isFreeShipping
             productOptionCost {
               deliveryCost
             }
             ...PDPNormalSelectOptionBuyerItemFragment
           }
         }
       }
     }
   
     ... on QuotableProduct {
       productOptions(first: $first, after: $after) {
         edges {
           node {
             id
             stockSku
             optionName
             product {
               id
               productId: number
             }
             price
             isFreeShipping
             productOptionCost {
               deliveryCost
             }
             ...PDPNormalSelectOptionBuyerItemFragment
           }
         }
       }
     }
   }
  `)

  module Item = %relay(`
  fragment PDPNormalSelectOptionBuyerItemFragment on ProductOption {
    id
    optionName
    stockSku
    price
    status
    isFreeShipping
    productOptionCost {
      deliveryCost
    }
    adhocStockIsLimited
    adhocStockIsNumRemainingVisible
    adhocStockNumRemaining
  }  
  `)
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

type selectableStatus =
  | Loading // SSR
  | Unauthorized // 미인증
  | Soldout // 품절
  | Available // 단품 선택 가능

module PC = {
  module Item = {
    @react.component
    let make = (~query, ~setSelectedOptions) => {
      let {
        id,
        optionName,
        price,
        status,
        isFreeShipping,
        productOptionCost: {deliveryCost},
        adhocStockIsLimited,
        adhocStockIsNumRemainingVisible,
        adhocStockNumRemaining,
      } =
        query->Fragments.Item.use

      let isShowRemaining = AdhocStock_Parser_Buyer_Admin.getIsShowRemaining(
        ~adhocStockIsLimited,
        ~adhocStockIsNumRemainingVisible,
      )

      let optionPrice = PDP_Parser_Buyer.ProductOption.makeOptionPrice(
        ~price,
        ~deliveryCost,
        ~isFreeShipping,
      )

      let optionPriceLabel = {
        optionPrice->Option.mapWithDefault("", optionPrice' =>
          `${optionPrice'->Float.fromInt->Locale.Float.show(~digits=0)}원`
        )
      }

      open RadixUI
      switch status {
      | #SOLDOUT =>
        <div className=%twc("w-full rounded-lg py-3 px-2 text-gray-400")>
          <span>
            {optionName->React.string}
            {`/`->React.string}
          </span>
          <span>
            <span className=%twc("ml-1 font-bold")> {optionPriceLabel->React.string} </span>
            <span> {` - 품절`->React.string} </span>
          </span>
        </div>

      | _ =>
        // 구매 가능
        <DropDown.Item className=%twc("focus:outline-none")>
          <div
            onClick={_ =>
              setSelectedOptions(.prev => {
                switch prev->Map.String.has(id) {
                | true => prev
                | false => prev->Map.String.set(id, 1)
                }
              })}
            className=%twc("rounded-lg py-3 px-2 hover:bg-gray-100")>
            <Formula.Text.Body size=#md>
              {optionName->React.string}
              {`/`->React.string}
            </Formula.Text.Body>
            <Formula.Text.Body weight=#bold size=#md className=%twc("ml-1")>
              {optionPriceLabel->React.string}
            </Formula.Text.Body>
            {switch (isShowRemaining, adhocStockNumRemaining) {
            | (true, Some(remaining)) =>
              <>
                <Formula.Text.Body> {` - `->React.string} </Formula.Text.Body>
                <Formula.Text.Body size=#md color=#"gray-70">
                  {`${remaining
                    ->Int.toFloat
                    ->Locale.Float.show(~digits=0)}개 남음`->React.string}
                </Formula.Text.Body>
              </>
            | _ => React.null
            }}
          </div>
        </DropDown.Item>
      }
    }
  }

  @react.component
  let make = (~query, ~setSelectedOptions, ~setShowModal) => {
    let user = CustomHooks.User.Buyer.use2()

    let {productOptions, status} = query->Fragments.List.use

    let selectableStatus = switch (user, status) {
    | (Unknown, _) => Loading
    | (_, #SOLDOUT) => Soldout
    | (NotLoggedIn, _) => Unauthorized
    | (LoggedIn(_), _) => Available
    }

    <div className=%twc("w-full")>
      <h1 className=%twc("text-base font-bold text-text-L1")> {`단품 선택`->React.string} </h1>
      <div className=%twc("w-full mt-4")>
        {switch selectableStatus {
        // SSR
        | Loading =>
          <div
            className=%twc("w-full h-13 p-3 flex items-center justify-between border rounded-xl")>
            <span className=%twc("text-gray-600")> {`선택해주세요`->React.string} </span>
            <IconArrowSelect height="20" width="20" fill="#121212" />
          </div>

        // 품절
        | Soldout =>
          <div
            className=%twc(
              "h-13 p-3 flex items-center justify-between border border-gray-300 rounded-xl bg-gray-100"
            )>
            <span className=%twc("text-gray-400")> {`선택해주세요`->React.string} </span>
            <IconArrowSelect height="20" width="20" fill="#B2B2B2" />
          </div>

        // 미인증
        | Unauthorized =>
          <div
            onClick={_ => {
              setShowModal(._ => PDP_Normal_Modals_Buyer.Show(
                Unauthorized(`로그인 후에\n단품을 선택하실 수 있습니다.`),
              ))
            }}
            className=%twc("w-full h-13 p-3 flex items-center justify-between border rounded-xl")>
            <span className=%twc("text-gray-600")> {`선택해주세요`->React.string} </span>
            <IconArrowSelect height="20" width="20" fill="#121212" />
          </div>

        // 구매가능
        | Available =>
          open RadixUI
          <div className=%twc("w-full")>
            <DropDown.Root>
              <DropDown.Trigger className=%twc("w-full focus:outline-none")>
                <div
                  className=%twc(
                    "w-full h-13 p-3 flex items-center justify-between border rounded-xl"
                  )>
                  <span className=%twc("text-gray-600")>
                    {`선택해주세요`->React.string}
                  </span>
                  <IconArrowSelect height="20" width="20" fill="#121212" />
                </div>
              </DropDown.Trigger>
              <DropDown.Content
                align=#start
                sideOffset=4
                className=%twc(
                  "dropdown-content w-[446px] bg-white border rounded-lg shadow-md p-1"
                )>
                <Scroll>
                  {productOptions->Option.mapWithDefault(React.null, ({edges}) => {
                    edges
                    ->Array.map(({node: {stockSku, fragmentRefs}}) => {
                      <Item key={`sku-${stockSku}`} query=fragmentRefs setSelectedOptions />
                    })
                    ->React.array
                  })}
                </Scroll>
              </DropDown.Content>
            </DropDown.Root>
          </div>
        }}
      </div>
    </div>
  }
}

module MO = {
  module Item = {
    @react.component
    let make = (~query, ~checked, ~onChange) => {
      let {
        id,
        optionName,
        price,
        status,
        isFreeShipping,
        productOptionCost: {deliveryCost},
        adhocStockIsLimited,
        adhocStockIsNumRemainingVisible,
        adhocStockNumRemaining,
      } =
        query->Fragments.Item.use

      let isShowRemaining = AdhocStock_Parser_Buyer_Admin.getIsShowRemaining(
        ~adhocStockIsLimited,
        ~adhocStockIsNumRemainingVisible,
      )

      let optionPrice = PDP_Parser_Buyer.ProductOption.makeOptionPrice(
        ~price,
        ~deliveryCost,
        ~isFreeShipping,
      )

      let optionPriceLabel = {
        optionPrice->Option.mapWithDefault("", optionPrice' =>
          `${optionPrice'->Float.fromInt->Locale.Float.show(~digits=0)}원`
        )
      }

      switch status {
      // 품절 단품
      | #SOLDOUT =>
        <div className=%twc("py-4 flex justify-between items-center")>
          <label htmlFor=id className=%twc("w-full flex items-start mr-3")>
            <span className=%twc("text-gray-400")>
              {optionName->React.string}
              <span className=%twc("ml-2 whitespace-nowrap")>
                {optionPriceLabel->React.string}
              </span>
              {` - 품절`->React.string}
            </span>
          </label>
          <Checkbox id checked onChange disabled=true />
        </div>

      // 구매 가능
      | _ =>
        <div className=%twc("py-4 flex justify-between items-center")>
          <label htmlFor=id className=%twc("w-full mr-3")>
            <Formula.Text.Body size=#md>
              {optionName->React.string}
              {`/`->React.string}
            </Formula.Text.Body>
            <Formula.Text.Body weight=#bold size=#md className=%twc("ml-1")>
              {optionPriceLabel->React.string}
            </Formula.Text.Body>
            {switch (isShowRemaining, adhocStockNumRemaining) {
            | (true, Some(remaining)) =>
              <>
                <Formula.Text.Body> {` - `->React.string} </Formula.Text.Body>
                <Formula.Text.Body size=#md color=#"gray-70">
                  {`${remaining
                    ->Int.toFloat
                    ->Locale.Float.show(~digits=0)}개 남음`->React.string}
                </Formula.Text.Body>
              </>
            | _ => React.null
            }}
          </label>
          <Checkbox id checked onChange />
        </div>
      }
    }
  }

  module OptionList = {
    @react.component
    let make = (
      ~productOptions: PDPNormalSelectOptionBuyerFragment_graphql.Types.fragment_productOptions,
      ~selectedOptions,
      ~setSelectedOptions,
      ~onClose,
    ) => {
      <>
        <section className=%twc("px-4")>
          <Scroll>
            {productOptions.edges
            ->Array.map(({node: {id, fragmentRefs}}) => {
              <Item
                key=id
                query=fragmentRefs
                checked={selectedOptions->Map.String.has(id)}
                onChange={_ => {
                  switch selectedOptions->Map.String.has(id) {
                  | true => setSelectedOptions(.prev => prev->Map.String.remove(id))
                  | false => setSelectedOptions(.prev => prev->Map.String.set(id, 1))
                  }
                }}
              />
            })
            ->React.array}
          </Scroll>
        </section>
        <section className=%twc("w-full px-4 py-5")>
          <button
            onClick={_ => onClose()}
            className=%twc("w-full h-14 rounded-xl bg-primary text-white font-bold text-base")>
            {`확인`->React.string}
          </button>
        </section>
      </>
    }
  }

  module BottomSheet = {
    @react.component
    let make = (~isShow, ~onClose, ~query, ~selectedOptions, ~setSelectedOptions) => {
      let {productOptions} = query->Fragments.List.use

      <DS_BottomDrawer.Root isShow onClose>
        <section className=%twc("w-full h-16 px-3 flex items-center")>
          <div className=%twc("w-10") />
          <div
            className=%twc(
              "flex flex-1 items-center justify-center text-base text-black font-bold"
            )>
            {`옵션 선택`->React.string}
          </div>
          <button
            onClick={_ => onClose()} className=%twc("w-10 h-10 flex items-center justify-center")>
            <IconClose width="24" height="24" fill="#000" />
          </button>
        </section>
        <DS_BottomDrawer.Body>
          {switch productOptions {
          | None => React.null
          | Some(productOptions') =>
            <OptionList onClose productOptions=productOptions' selectedOptions setSelectedOptions />
          }}
        </DS_BottomDrawer.Body>
      </DS_BottomDrawer.Root>
    }
  }

  @react.component
  let make = (~query, ~selectedOptions, ~setSelectedOptions, ~setShowModal) => {
    let user = CustomHooks.User.Buyer.use2()

    let {status} = query->Fragments.List.use
    let (showBottomSheet, setShowBottomSheet) = React.Uncurried.useState(_ => false)

    let selectableStatus = switch (user, status) {
    | (Unknown, _) => Loading
    | (_, #SOLDOUT) => Soldout
    | (NotLoggedIn, _) => Unauthorized
    | (LoggedIn(_), _) => Available
    }

    switch selectableStatus {
    // SSR
    | Loading =>
      <div className=%twc("w-full h-13 p-3 flex items-center justify-between border rounded-xl")>
        <span className=%twc("text-gray-600")>
          {`단품을 선택해 주세요`->React.string}
        </span>
        <IconArrowSelect height="20" width="20" fill="#121212" />
      </div>

    // 품절
    | Soldout =>
      <div
        className=%twc(
          "h-13 p-3 flex items-center justify-between border border-gray-300 rounded-xl bg-gray-100"
        )>
        <span className=%twc("text-gray-400")>
          {`단품을 선택해 주세요`->React.string}
        </span>
        <IconArrowSelect height="20" width="20" fill="#B2B2B2" />
      </div>

    // 미인증
    | Unauthorized =>
      <div
        onClick={_ => {
          setShowModal(._ => PDP_Normal_Modals_Buyer.Show(
            Unauthorized(`로그인 후에\n단품을 선택하실 수 있습니다.`),
          ))
        }}
        className=%twc("w-full h-13 p-3 flex items-center justify-between border rounded-xl")>
        <span className=%twc("text-gray-600")>
          {`단품을 선택해 주세요`->React.string}
        </span>
        <IconArrowSelect height="20" width="20" fill="#121212" />
      </div>

    // 단품 선택 가능
    | Available =>
      <>
        <div
          onClick={_ => setShowBottomSheet(._ => true)}
          className=%twc("w-full h-13 p-3 flex items-center justify-between border rounded-xl")>
          <span className=%twc("text-gray-600")>
            {`단품을 선택해 주세요`->React.string}
          </span>
          <IconArrowSelect height="20" width="20" fill="#121212" />
        </div>
        <BottomSheet
          isShow=showBottomSheet
          onClose={_ => setShowBottomSheet(._ => false)}
          query
          selectedOptions
          setSelectedOptions
        />
      </>
    }
  }
}
