/*
  1. 컴포넌트 위치
  PDP > 일반 상품 > 상품명, 가격
  
  2. 역할
  일반 상품의 타이틀 정보를 보여줍니다.
*/

module PC = {
  @react.component
  let make = (~displayName, ~price, ~isSoldout) => {
    let user = CustomHooks.User.Buyer.use2()
    let priceToDisplay = p => p->Int.toFloat->Locale.Float.show(~digits=0)
    let priceLabel = price->Option.map(priceToDisplay)

    let oldUI =
      <section>
        <h1 className=%twc("text-[32px] leading-[44px] text-gray-800")>
          {displayName->React.string}
        </h1>
        <div className=%twc("h-10")>
          {switch user {
          | Unknown => <div className=%twc("mt-4") />

          | NotLoggedIn =>
            <h1 className=%twc("mt-4 text-[28px] text-green-500 font-bold")>
              {`공급가 회원공개`->React.string}
            </h1>

          | LoggedIn(_) => {
              let textColor = isSoldout ? %twc("text-gray-600") : %twc("text-gray-800")
              <h1 className={%twc("mt-4 text-[32px] leading-[38px] font-bold ") ++ textColor}>
                {switch priceLabel {
                | None => React.null
                | Some(priceLabel') =>
                  <>
                    {priceLabel'->React.string}
                    <span className=%twc("text-[28px]")> {`원`->React.string} </span>
                  </>
                }}
              </h1>
            }
          }}
        </div>
        <span className=%twc("mt-4 text-red-500 text-[15px]")>
          {`시세에 따라 가격이 변동될 수 있습니다`->React.string}
        </span>
      </section>

    <FeatureFlagWrapper featureFlag=#HOME_UI_UX fallback={oldUI}>
      <section>
        <h1 className=%twc("text-[32px] leading-[44px] text-gray-800")>
          {displayName->React.string}
        </h1>
        <div className=%twc("h-10")>
          {
            let textColor = isSoldout ? %twc("text-gray-600") : %twc("text-gray-800")
            <h1 className={%twc("mt-4 text-[32px] leading-[38px] font-bold ") ++ textColor}>
              {switch priceLabel {
              | None => React.null
              | Some(priceLabel') =>
                <>
                  {priceLabel'->React.string}
                  <span className=%twc("text-[28px]")> {`원`->React.string} </span>
                </>
              }}
            </h1>
          }
        </div>
        <span className=%twc("mt-4 text-red-500 text-[15px]")>
          {`시세에 따라 가격이 변동될 수 있습니다`->React.string}
        </span>
      </section>
    </FeatureFlagWrapper>
  }
}

module MO = {
  @react.component
  let make = (~displayName, ~price, ~isSoldout) => {
    let user = CustomHooks.User.Buyer.use2()
    let priceToDisplay = p => p->Int.toFloat->Locale.Float.show(~digits=0)
    let priceLabel = price->Option.map(priceToDisplay)

    let oldUI =
      <section>
        <h1 className=%twc("text-lg text-gray-800 break-all")> {displayName->React.string} </h1>
        <div className=%twc("h-[33px]")>
          {switch user {
          | Unknown => React.null

          | NotLoggedIn =>
            <h1 className=%twc("text-xl text-green-500 font-bold")>
              {`공급가 회원공개`->React.string}
            </h1>

          | LoggedIn(_) => {
              let textColor = isSoldout ? %twc("text-gray-600") : %twc("text-gray-800")
              <h1 className={%twc("text-[22px] font-bold ") ++ textColor}>
                {switch priceLabel {
                | None => React.null
                | Some(priceLabel') =>
                  <>
                    {priceLabel'->React.string}
                    <span className=%twc("text-lg")> {`원`->React.string} </span>
                  </>
                }}
              </h1>
            }
          }}
        </div>
        <span className=%twc("mt-4 text-red-500 text-[13px]")>
          {`시세에 따라 가격이 변동될 수 있습니다`->React.string}
        </span>
      </section>

    <FeatureFlagWrapper featureFlag=#HOME_UI_UX fallback=oldUI>
      <section>
        <h1 className=%twc("text-lg text-gray-800 break-all")> {displayName->React.string} </h1>
        <div className=%twc("h-[33px]")>
          {
            let textColor = isSoldout ? %twc("text-gray-600") : %twc("text-gray-800")
            <h1 className={%twc("text-[22px] font-bold ") ++ textColor}>
              {switch priceLabel {
              | None => React.null
              | Some(priceLabel') =>
                <>
                  {priceLabel'->React.string}
                  <span className=%twc("text-lg")> {`원`->React.string} </span>
                </>
              }}
            </h1>
          }
        </div>
        <span className=%twc("mt-4 text-red-500 text-[13px]")>
          {`시세에 따라 가격이 변동될 수 있습니다`->React.string}
        </span>
      </section>
    </FeatureFlagWrapper>
  }
}
