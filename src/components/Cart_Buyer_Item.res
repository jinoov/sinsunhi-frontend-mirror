open ReactHookForm
open Skeleton

module Form = Cart_Buyer_Form
module Util = Cart_Buyer_Util
module Hidden = Util.Hidden

module Fragment = %relay(`
  fragment CartBuyerItemFragment on Query {
    cartItems {
      number
      productSnapshot {
        displayName
      }
      product {
        number
        status
        image {
          thumb100x100
        }
        ... on NormalProduct {
          isCourierAvailable
        }
        ... on QuotableProduct {
          isCourierAvailable
        }
      }
      productOptionSnapshot {
        optionName
        price
      }
      productOption {
        status
        number
        adhocStockIsLimited
        adhocStockIsNumRemainingVisible
        adhocStockNumRemaining
      }
      quantity
      updatedAt
    }
  }
`)

module NoItem = {
  @react.component
  let make = (~className="") => {
    <div
      className={cx([
        %twc("flex flex-col items-center justify-center gap-1 xl:gap-7 h-[500px] xl:h-[700px]"),
        className,
      ])}>
      <span className=%twc("text-text-L1 text-lg xl:text-3xl font-bold xl:font-normal")>
        {`장바구니에 담긴 상품이 없습니다.`->React.string}
      </span>
      <span className=%twc("whitespace-pre-wrap text-center text-text-L2 text-[17px]")>
        {`원하는 상품을 장바구니에 담아보세요.

*현재는 1개의 배송지로 가는 상품만 지원합니다.
2개이상 배송지를 구매하고 싶은 경우에는 
주문서 업로드를 이용해주세요.`->React.string}
      </span>
      <Next.Link href="/buyer">
        <a
          className=%twc(
            "mt-12 xl:mt-0 px-4 xl:px-20 py-4 flex justify-center items-center border border-green-500 text-green-500 font-bold rounded-xl"
          )>
          {`상품 둘러보기`->React.string}
        </a>
      </Next.Link>
    </div>
  }
}

module Notice = {
  module PC = {
    @react.component
    let make = () => {
      <div className=%twc("w-full px-0 bg-white pt-0 mb-7 mt-0")>
        <div
          className=%twc(
            "w-full flex flex-col px-3 py-2.5 text-orange-500 text-sm rounded-[10px] bg-red-50"
          )>
          <span>
            {`- 산지 사정에 따라, 상품 상태(ex. 품절) 및 가격이 변동될 수 있습니다. 주문 전 반드시 확인해주세요.`->React.string}
          </span>
          <span>
            {`- 장바구니를 통한 주문은 오직 한 곳의 배송지로만 상품을 보낼 수 있습니다.`->React.string}
          </span>
        </div>
      </div>
    }
  }

  module MO = {
    @react.component
    let make = () => {
      <div className=%twc("w-full px-4 bg-white pt-7 mb-0 mt-12")>
        <div
          className=%twc(
            "w-full flex flex-col px-3 py-2.5 text-orange-500 text-sm rounded-[10px] bg-red-50"
          )>
          <span>
            {`- 산지 사정에 따라, 상품 상태(ex. 품절) 및 가격이 변동될 수 있습니다. 주문 전 반드시 확인해주세요.`->React.string}
          </span>
          <span>
            {`- 장바구니를 통한 주문은 오직 한 곳의 배송지로만 상품을 보낼 수 있습니다.`->React.string}
          </span>
        </div>
      </div>
    }
  }
}

module SelectAll = {
  module PlaceHolder = {
    module PC = {
      @react.component
      let make = () =>
        <div className=%twc("w-full")>
          <div className=%twc("flex w-full justify-around bg-white py-3 mb-5")>
            <Box className=%twc("w-1/3") />
            <Box className=%twc("w-1/3") />
          </div>
          <div
            className=%twc(
              "pb-5 mb-5 mt-0 px-0 w-full relative top-0 bg-white flex justify-between border border-x-0 border-t-0 border-div-border-L2"
            )>
            <div className=%twc("flex gap-2 items-center")>
              <Box className=%twc("w-6") />
              <Box className=%twc("w-18") />
            </div>
            <Box className=%twc("w-12") />
          </div>
        </div>
    }

    module MO = {
      @react.component
      let make = () =>
        <div className=%twc("w-full pb-5 mb-5 px-4 mt-16 fixed top-0 bg-white")>
          <div className=%twc("flex w-full justify-around bg-white py-3 mb-5")>
            <Box className=%twc("w-1/3") />
            <Box className=%twc("w-1/3") />
          </div>
        </div>
    }
  }

  module PC = {
    @react.component
    let make = (~prefix, ~refetchCart, ~availableNum, ~unavailableNum, ~className="") => {
      let formNames = Form.names(prefix)

      let watchCart = Hooks.WatchValues.use(
        Hooks.WatchValues.Object,
        ~config=Hooks.WatchValues.config(~name=formNames.name, ()),
        (),
      )

      let {register} = Hooks.Context.use(. ~config=Hooks.Form.config(~mode=#onChange, ()), ())

      let {ref, name, onChange, onBlur} = register(.
        Form.names(Form.name).orderType,
        Some(Hooks.Register.config(~required=true, ())),
      )
      let watchOrderType = Hooks.WatchValues.use(
        Hooks.WatchValues.Text,
        ~config=Hooks.WatchValues.config(~name=Form.names(Form.name).orderType, ()),
        (),
      )

      let (selectedItems, totalItems, targetNames) = switch watchCart->Option.map(
        Form.cart_decode,
      ) {
      | Some(Ok(decode)) =>
        let filtered =
          decode.cartItems
          ->Option.getWithDefault([])
          ->Array.map(cartItem =>
            switch cartItem.productStatus->Form.soldable {
            | true =>
              cartItem.productOptions->Array.map(option =>
                switch option.optionStatus->Form.soldable {
                | true => Some(option)
                | false => None
                }
              )
            | false => []
            }
          )
          ->Array.mapWithIndex((i, c) => {
            let firstDepth = Form.names(`${formNames.cartItems}.${i->Int.toString}`)
            c->Array.mapWithIndex((j, option) =>
              option->Option.map(
                option' => {
                  let secondDepth = Form.names(`${firstDepth.productOptions}.${j->Int.toString}`)
                  (secondDepth.checked, option')
                },
              )
            )
          })
          ->Array.concatMany
          ->Array.keepMap(Garter_Fn.identity)

        let (names, options) = filtered->Garter.Array.unzip

        (options->Array.keep(option => option.checked), filtered, names)
      | Some(Error(_))
      | None => ([], [], [])
      }

      <div
        className={cx([
          %twc(
            "pb-5 mb-5 mt-0 pt-0 w-full relative top-0 bg-white border border-x-0 border-t-0 border-div-border-L2"
          ),
          className,
        ])}>
        <div className=%twc("flex w-full justify-start bg-white")>
          {[
            ("courier-available", `택배배송 가능 상품 ${availableNum->Int.toString}`),
            ("un-courier-available", `택배배송 불가 상품 ${unavailableNum->Int.toString}`),
          ]
          ->Array.map(((value, n)) =>
            <label key=n className=%twc("w-1/2")>
              <input
                className=%twc("sr-only") type_="radio" id=name ref name onChange onBlur value
              />
              <Util.RadioButton.PC watchValue=watchOrderType name=n value />
            </label>
          )
          ->React.array}
        </div>
        <div className=%twc("flex justify-between items-center px-0 mt-10")>
          <div className=%twc("flex gap-2 items-center")>
            <Util.Checkbox name=formNames.checked watchNames=targetNames targetNames status=#SALE />
            <span className=%twc("text-gray-800")>
              {`전체 선택 (${selectedItems->Array.length->Int.toString}/${totalItems
                ->Array.length
                ->Int.toString})`->React.string}
            </span>
          </div>
          <Cart_Delete_Button refetchCart productOptions=selectedItems isIcon=false>
            <span className=%twc("text-gray-600 text-sm")> {`선택 삭제`->React.string} </span>
          </Cart_Delete_Button>
        </div>
      </div>
    }
  }

  module MO = {
    @react.component
    let make = (~prefix, ~refetchCart, ~availableNum, ~unavailableNum, ~className="") => {
      let formNames = Form.names(prefix)

      let watchCart = Hooks.WatchValues.use(
        Hooks.WatchValues.Object,
        ~config=Hooks.WatchValues.config(~name=formNames.name, ()),
        (),
      )

      let {register} = Hooks.Context.use(. ~config=Hooks.Form.config(~mode=#onChange, ()), ())

      let {ref, name, onChange, onBlur} = register(.
        Form.names(Form.name).orderType,
        Some(Hooks.Register.config(~required=true, ())),
      )
      let watchOrderType = Hooks.WatchValues.use(
        Hooks.WatchValues.Text,
        ~config=Hooks.WatchValues.config(~name=Form.names(Form.name).orderType, ()),
        (),
      )

      let (selectedItems, totalItems, targetNames) = switch watchCart->Option.map(
        Form.cart_decode,
      ) {
      | Some(Ok(decode)) =>
        let filtered =
          decode.cartItems
          ->Option.getWithDefault([])
          ->Array.map(cartItem =>
            switch cartItem.productStatus->Form.soldable {
            | true =>
              cartItem.productOptions->Array.map(option =>
                switch option.optionStatus->Form.soldable {
                | true => Some(option)
                | false => None
                }
              )
            | false => []
            }
          )
          ->Array.mapWithIndex((i, c) => {
            let firstDepth = Form.names(`${formNames.cartItems}.${i->Int.toString}`)
            c->Array.mapWithIndex((j, option) =>
              option->Option.map(
                option' => {
                  let secondDepth = Form.names(`${firstDepth.productOptions}.${j->Int.toString}`)
                  (secondDepth.checked, option')
                },
              )
            )
          })
          ->Array.concatMany
          ->Array.keepMap(Garter_Fn.identity)

        let (names, options) = filtered->Garter.Array.unzip

        (options->Array.keep(option => option.checked), filtered, names)
      | _ => ([], [], [])
      }

      <div
        className={cx([
          %twc(
            "pb-3 mb-5 pt-2 w-full fixed top-12 mt-1 bg-white border border-x-0 border-t-0 border-div-border-L2"
          ),
          className,
        ])}>
        <div className=%twc("flex w-full justify-center bg-white")>
          {[
            ("courier-available", `택배배송 가능 상품 ${availableNum->Int.toString}`),
            ("un-courier-available", `택배배송 불가 상품 ${unavailableNum->Int.toString}`),
          ]
          ->Array.map(((value, n)) =>
            <label key=n className=%twc("w-1/2")>
              <input
                className=%twc("sr-only") type_="radio" id=name ref name onChange onBlur value
              />
              <Util.RadioButton.MO watchValue=watchOrderType name=n value />
            </label>
          )
          ->React.array}
        </div>
        <div className=%twc("flex justify-between items-center px-4 mt-4")>
          <div className=%twc("flex gap-2 items-center")>
            <Util.Checkbox name=formNames.checked watchNames=targetNames targetNames status=#SALE />
            <span className=%twc("text-gray-800")>
              {`전체 선택 (${selectedItems->Array.length->Int.toString}/${totalItems
                ->Array.length
                ->Int.toString})`->React.string}
            </span>
          </div>
          <Cart_Delete_Button refetchCart productOptions=selectedItems isIcon=false>
            <span className=%twc("text-gray-600 text-sm ")> {`선택 삭제`->React.string} </span>
          </Cart_Delete_Button>
        </div>
      </div>
    }
  }
}

module PlaceHolder = {
  module PC = {
    @react.component
    let make = (~deviceType) => {
      let router = Next.Router.useRouter()

      let oldUI =
        <>
          <Header_Buyer.PC_Old key=router.asPath />
          <main className=%twc("flex flex-col gap-5 px-[14%] py-20 bg-surface pb-20")>
            <h1 className=%twc("flex ml-5 mb-3 text-3xl font-bold text-enabled-L1")>
              {`장바구니`->React.string}
            </h1>
            <div className=%twc("flex flex-row gap-4 xl:gap-5")>
              <div className=%twc("w-2/3 flex flex-col gap-5")>
                <div className=%twc("flex flex-col pt-7 px-7 bg-white")>
                  <div className=%twc("flex flex-col items-center")>
                    <SelectAll.PlaceHolder.PC />
                    <Box className=%twc("w-full px-0 min-h-[4rem] mt-0") />
                  </div>
                  <div className=%twc("flex flex-col gap-4 mt-7 mb-10 bg-white")>
                    <Cart_Card_List_Buyer.PlaceHolder deviceType />
                  </div>
                </div>
              </div>
              <div className=%twc("w-1/3 xl:min-h-full relative bottom-0")>
                <Cart_Payment_Info_Buyer.PlaceHolder.PC />
              </div>
            </div>
          </main>
          <Footer_Buyer.PC />
        </>

      <FeatureFlagWrapper featureFlag=#HOME_UI_UX fallback=oldUI>
        {<>
          <Header_Buyer.PC_Old key=router.asPath />
          <main className=%twc("flex flex-col gap-5 px-[14%] py-20 bg-[#FAFBFC] pb-20")>
            <h1 className=%twc("flex ml-5 mb-3 text-3xl font-bold text-enabled-L1")>
              {`장바구니`->React.string}
            </h1>
            <div className=%twc("flex flex-row gap-4 xl:gap-5")>
              <div className=%twc("w-2/3 flex flex-col gap-5")>
                <div className=%twc("flex flex-col pt-7 px-7 bg-white")>
                  <div className=%twc("flex flex-col items-center")>
                    <SelectAll.PlaceHolder.PC />
                    <Box className=%twc("w-full px-0 min-h-[4rem] mt-0") />
                  </div>
                  <div className=%twc("flex flex-col gap-4 mt-7 mb-10 bg-white")>
                    <Cart_Card_List_Buyer.PlaceHolder deviceType />
                  </div>
                </div>
              </div>
              <div className=%twc("w-1/3 xl:min-h-full relative bottom-0")>
                <Cart_Payment_Info_Buyer.PlaceHolder.PC />
              </div>
            </div>
          </main>
          <Footer_Buyer.PC />
        </>}
      </FeatureFlagWrapper>
    }
  }
  module MO = {
    @react.component
    let make = (~deviceType) => {
      let router = Next.Router.useRouter()

      <>
        <Header_Buyer.Mobile key=router.asPath />
        <main className=%twc("flex flex-col gap-5 bg-surface pb-[11rem]")>
          <div className=%twc("flex flex-col gap-4 xl:gap-5")>
            <div className=%twc("w-full flex flex-col gap-5")>
              <div className=%twc("flex flex-col pt-7 px-0 bg-white")>
                <div className=%twc("flex flex-col items-center")>
                  <SelectAll.PlaceHolder.MO />
                  <Box className=%twc("w-[92%] min-h-[4rem] mt-10") />
                </div>
                <div className=%twc("flex flex-col gap-4 bg-surface")>
                  <Cart_Card_List_Buyer.PlaceHolder deviceType />
                </div>
              </div>
            </div>
            <div className=%twc("w-full fixed bottom-0")>
              <Cart_Payment_Info_Buyer.PlaceHolder.MO />
            </div>
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

module RenderByOrderType = {
  module PC = {
    @react.component
    let make = (
      ~data,
      ~refetchCart,
      ~formNames: Form.inputNames,
      ~orderType: Form.orderType,
      ~availableNum,
      ~unavailableNum,
      ~deviceType,
    ) => {
      let watchOrderType = Hooks.WatchValues.use(
        Hooks.WatchValues.Text,
        ~config=Hooks.WatchValues.config(~name=Form.names(Form.name).orderType, ()),
        (),
      )

      let isSelected =
        watchOrderType->Option.mapWithDefault(false, watch =>
          Js.Json.string(watch) == orderType->Form.orderType_encode
        )

      <>
        <Util.HiddenInputs data prefix=formNames.name />
        <div className={isSelected ? %twc("flex flex-row gap-5") : %twc("hidden")}>
          <div className=%twc("w-2/3 flex flex-col gap-5 pt-0 min-w-[550px]")>
            <div className=%twc("flex flex-col pt-0 px-7 bg-white")>
              <SelectAll.PC refetchCart prefix=formNames.name availableNum unavailableNum />
              <div className=%twc("flex flex-col gap-4 mb-10 bg-white")>
                {switch data {
                | [] => <NoItem className=%twc("bg-white") />
                | data' =>
                  <div className=%twc("flex flex-col")>
                    <Notice.PC />
                    <div className=%twc("flex flex-col gap-7")>
                      {data'
                      ->Array.mapWithIndex((index, cartItem) =>
                        <Cart_Card_List_Buyer
                          refetchCart
                          key={`${formNames.cartItems}.${index->Int.toString}`}
                          cartItem
                          prefix={`${formNames.cartItems}.${index->Int.toString}`}
                          isLast={index + 1 == data->Array.length}
                          deviceType
                        />
                      )
                      ->React.array}
                    </div>
                  </div>
                }}
              </div>
            </div>
          </div>
          <div className=%twc("w-1/3 min-h-full relative bottom-0")>
            <Cart_Payment_Info_Buyer.PC prefix=formNames.name />
          </div>
        </div>
      </>
    }
  }

  module MO = {
    @react.component
    let make = (
      ~data,
      ~refetchCart,
      ~formNames: Form.inputNames,
      ~orderType: Form.orderType,
      ~availableNum,
      ~unavailableNum,
      ~deviceType,
    ) => {
      let watchOrderType = Hooks.WatchValues.use(
        Hooks.WatchValues.Text,
        ~config=Hooks.WatchValues.config(~name=Form.names(Form.name).orderType, ()),
        (),
      )

      let isSelected =
        watchOrderType->Option.mapWithDefault(false, watch =>
          Js.Json.string(watch) == orderType->Form.orderType_encode
        )

      <>
        <Util.HiddenInputs data prefix=formNames.name />
        <div className={isSelected ? %twc("flex flex-col gap-4") : %twc("hidden")}>
          <div className=%twc("w-full flex flex-col gap-5 pt-14")>
            <div className=%twc("flex flex-col pt-0 px-0 bg-white")>
              <SelectAll.MO refetchCart prefix=formNames.name availableNum unavailableNum />
              <div className=%twc("flex flex-col gap-2 bg-surface")>
                {switch data {
                | [] => <NoItem className=%twc("bg-white") />
                | data' =>
                  <div className=%twc("flex flex-col")>
                    <Notice.MO />
                    <div className=%twc("flex flex-col gap-3")>
                      {data'
                      ->Array.mapWithIndex((index, cartItem) =>
                        <Cart_Card_List_Buyer
                          refetchCart
                          key={`${formNames.cartItems}.${index->Int.toString}`}
                          cartItem
                          prefix={`${formNames.cartItems}.${index->Int.toString}`}
                          isLast={index + 1 == data->Array.length}
                          deviceType
                        />
                      )
                      ->React.array}
                    </div>
                  </div>
                }}
              </div>
            </div>
          </div>
          <div className=%twc("w-full fixed bottom-0")>
            <Cart_Payment_Info_Buyer.MO prefix=formNames.name />
          </div>
        </div>
      </>
    }
  }

  @react.component
  let make = (
    ~data,
    ~refetchCart,
    ~formNames: Form.inputNames,
    ~orderType: Form.orderType,
    ~availableNum,
    ~unavailableNum,
    ~deviceType,
  ) => {
    switch deviceType {
    | DeviceDetect.Unknown => React.null
    | DeviceDetect.PC =>
      <PC data refetchCart formNames orderType availableNum unavailableNum deviceType />

    | DeviceDetect.Mobile =>
      <MO data refetchCart formNames orderType availableNum unavailableNum deviceType />
    }
  }
}

type renderParams = {
  orderType: Form.orderType,
  data: array<Form.cartItem>,
  formNames: Form.inputNames,
}

module PC = {
  @react.component
  let make = (~renderParams, ~refetchCart, ~availableNum, ~unavailableNum, ~deviceType) => {
    let oldUI =
      <main
        className=%twc("w-full min-w-[1280px] flex flex-col gap-5 px-[14%] py-20 bg-surface pb-20")>
        <h1 className=%twc("flex ml-5 mb-3 text-3xl font-bold text-enabled-L1")>
          {`장바구니`->React.string}
        </h1>
        {renderParams
        ->Array.map(({orderType, data, formNames}) =>
          <RenderByOrderType
            key=formNames.name
            orderType
            data
            formNames
            refetchCart
            availableNum
            unavailableNum
            deviceType
          />
        )
        ->React.array}
      </main>

    <FeatureFlagWrapper featureFlag=#HOME_UI_UX fallback=oldUI>
      <main
        className=%twc("w-full min-w-[1280px] flex flex-col gap-5 px-[14%] py-20 bg-[#FAFBFC] pb-20")>
        <h1 className=%twc("flex ml-5 mb-3 text-3xl font-bold text-enabled-L1")>
          {`장바구니`->React.string}
        </h1>
        {renderParams
        ->Array.map(({orderType, data, formNames}) =>
          <RenderByOrderType
            key=formNames.name
            orderType
            data
            formNames
            refetchCart
            availableNum
            unavailableNum
            deviceType
          />
        )
        ->React.array}
      </main>
    </FeatureFlagWrapper>
  }
}

module MO = {
  @react.component
  let make = (~renderParams, ~refetchCart, ~availableNum, ~unavailableNum, ~deviceType) => {
    <main className=%twc("w-full flex flex-col gap-3 bg-surface pb-44")>
      {renderParams
      ->Array.map(({orderType, data, formNames}) =>
        <RenderByOrderType
          key=formNames.name
          orderType
          data
          formNames
          refetchCart
          availableNum
          unavailableNum
          deviceType
        />
      )
      ->React.array}
    </main>
  }
}

module Container = {
  @react.component
  let make = (~renderParams, ~refetchCart, ~availableNum, ~unavailableNum, ~deviceType) => {
    switch deviceType {
    | DeviceDetect.Unknown => React.null
    | DeviceDetect.PC => <PC renderParams refetchCart availableNum unavailableNum deviceType />
    | DeviceDetect.Mobile => <MO renderParams refetchCart availableNum unavailableNum deviceType />
    }
  }
}

@react.component
let make = (~query, ~deviceType) => {
  let router = Next.Router.useRouter()
  let {setValue} = Hooks.Context.use(. ~config=Hooks.Form.config(~mode=#onChange, ()), ())
  let formNames = Form.names(Form.name)

  let queryData = Fragment.use(query)

  let refetchCart = () => router->Next.Router.reload(router.pathname)->ignore

  let data = queryData.cartItems->Form.groupBy->Array.keepMap(Form.map)

  let (courierAvailableData, unCourierAvailableData) =
    data->Array.partition(cartItem => cartItem.isCourierAvailable->Option.getWithDefault(false))

  let itemLength = (d: array<Form.cartItem>) =>
    d
    ->Array.keep(item => item.productStatus->Form.soldable)
    ->Array.map(item =>
      item.productOptions->Array.keep(option => option.optionStatus->Form.soldable)
    )
    ->Array.concatMany
    ->Array.length

  let availableNum = courierAvailableData->itemLength
  let unavailableNum = unCourierAvailableData->itemLength

  let renderParams = [
    {
      orderType: #CourierAvailable,
      data: courierAvailableData->Form.orderByCartItem,
      formNames: Form.names(formNames.courierAvailableItem),
    },
    {
      orderType: #UnCourierAvailable,
      data: unCourierAvailableData->Form.orderByCartItem,
      formNames: Form.names(formNames.unCourierAvailableItem),
    },
  ]

  let defaultOrderType = switch courierAvailableData->Array.length {
  | 0 => #UnCourierAvailable
  | _ => #CourierAvailable
  }

  let cartIds =
    data
    ->Array.map(cartItem => cartItem.productOptions->Array.map(option => option.cartId))
    ->Array.concatMany

  React.useEffect0(_ => {
    setValue(. formNames.orderType, defaultOrderType->Form.orderType_encode)
    // GTM
    Form.cartGtmPush(data, cartIds, "view_cart")
    None
  })

  <>
    {switch data {
    | [] => <NoItem />
    | _ => <Container renderParams refetchCart availableNum unavailableNum deviceType />
    }}
  </>
}
