/*
  1. 컴포넌트 위치
  PDP > 일반 상품 > 배송 안내
  
  2. 역할
  일반 상품의 배송 안내 문구를 보여줍니다.
*/

module Fragment = %relay(`
  fragment PDPNormalDeliveryGuideBuyer_fragment on Product {
    ... on NormalProduct {
      isCourierAvailable
    }
  
    ... on QuotableProduct {
      isCourierAvailable
    }
  }
`)

module PC = {
  @react.component
  let make = (~query) => {
    let isCourierAvailable = switch query->Fragment.use {
    | #NormalProduct({isCourierAvailable}) => isCourierAvailable->Some
    | #QuotableProduct({isCourierAvailable}) => isCourierAvailable->Some
    | _ => None
    }

    <div className=%twc("w-full")>
      <h1 className=%twc("text-base font-bold text-text-L1")> {`배송 안내`->React.string} </h1>
      <div className=%twc("mt-4 w-full bg-gray-50 p-4 rounded-xl")>
        {switch isCourierAvailable {
        // 택배 가능
        | Some(true) => <>
            <div className=%twc("flex")>
              <span className=%twc("text-text-L2")> {`・`->React.string} </span>
              <div className=%twc("flex flex-col text-gray-800")>
                <span>
                  <span className=%twc("text-green-500")>
                    {`원물, 대량구매는 1:1 채팅`->React.string}
                  </span>
                  {`을 이용해주세요`->React.string}
                </span>
              </div>
            </div>
            <div className=%twc("flex mt-2")>
              <span className=%twc("text-gray-500")> {`・`->React.string} </span>
              <div className=%twc("flex flex-col text-gray-800")>
                <span>
                  {`일부 상품은 `->React.string}
                  <span className=%twc("font-bold")>
                    {`배송비가 별도로 부과`->React.string}
                  </span>
                  {`됩니다.`->React.string}
                </span>
              </div>
            </div>
          </>

        // 택배 불가
        | Some(false) | None =>
          <div className=%twc("flex")>
            <span className=%twc("text-text-L2")> {`・`->React.string} </span>
            <div className=%twc("flex flex-col text-gray-800")>
              <span>
                <span className=%twc("font-bold")> {`화물 배송`->React.string} </span>
                {` 또는 `->React.string}
                <span className=%twc("font-bold")> {`직접 수령 상품`->React.string} </span>
                {`입니다`->React.string}
              </span>
            </div>
          </div>
        }}
      </div>
    </div>
  }
}

module MO = {
  @react.component
  let make = (~query) => {
    let isCourierAvailable = switch query->Fragment.use {
    | #NormalProduct({isCourierAvailable}) => isCourierAvailable->Some
    | #QuotableProduct({isCourierAvailable}) => isCourierAvailable->Some
    | _ => None
    }

    <div className=%twc("w-full")>
      <h1 className=%twc("text-base font-bold text-text-L1")> {`배송 안내`->React.string} </h1>
      <div className=%twc("mt-4 w-full bg-surface p-4 rounded-xl flex flex-col gap-2")>
        {switch isCourierAvailable {
        // 택배 가능
        | Some(true) => <>
            <div className=%twc("flex")>
              <span className=%twc("text-text-L2")> {`・`->React.string} </span>
              <div className=%twc("flex flex-col text-text-L1")>
                <span>
                  <span className=%twc("text-primary")>
                    {`원물, 대량구매는 1:1 채팅`->React.string}
                  </span>
                  {`을 이용해주세요`->React.string}
                </span>
              </div>
            </div>
            <div className=%twc("flex")>
              <span className=%twc("text-text-L2")> {`・`->React.string} </span>
              <div className=%twc("flex flex-col text-text-L1")>
                <span>
                  {`일부 상품은 `->React.string}
                  <span className=%twc("font-bold")>
                    {`배송비가 별도로 부과`->React.string}
                  </span>
                  {`됩니다.`->React.string}
                </span>
              </div>
            </div>
          </>

        // 택배 불가
        | Some(false) | None =>
          <div className=%twc("flex")>
            <span className=%twc("text-text-L2")> {`・`->React.string} </span>
            <div className=%twc("flex flex-col text-text-L1")>
              <span>
                <span className=%twc("font-bold")> {`화물 배송`->React.string} </span>
                {` 또는 `->React.string}
                <span className=%twc("font-bold")> {`직접 수령 상품`->React.string} </span>
                {`입니다`->React.string}
              </span>
            </div>
          </div>
        }}
      </div>
    </div>
  }
}
