module Fragment = %relay(`
  fragment PDPNormalContentsGuideBuyer_fragment on Product {
    displayName
    origin
  
    ... on NormalProduct {
      notationInformationType
    }
    ... on QuotableProduct {
      notationInformationType
    }
  }
`)

module Divider = {
  @react.component
  let make = () => <div className=%twc("w-full h-[1px] bg-gray-100") />
}

module PC = {
  module Info = {
    @react.component
    let make = (~k, ~v=?) => {
      <div className=%twc("flex items-center")>
        <div className=%twc("p-[18px] h-full flex items-center bg-gray-50")>
          <span className=%twc("w-[140px] text-gray-900 text-[14px]")> {k->ReactNl2br.nl2br} </span>
        </div>
        <div className=%twc("p-[18px] h-full flex items-center")>
          <span className=%twc("w-[408px] text-gray-700 text-[14px]")>
            {v->Option.mapWithDefault(React.null, ReactNl2br.nl2br)}
          </span>
        </div>
      </div>
    }
  }

  module WholeFood = {
    @react.component
    let make = (~displayName, ~origin) => {
      <div className=%twc("w-full flex flex-wrap border-gray-100 border-y")>
        <Info k=`품목 또는 명칭` v=displayName />
        <Info k=`포장단위별 내용물 용량, 중량, 수량, 크기` v=`컨텐츠 참조` />
        <Divider />
        <Info k=`생산자(수입자)` v=`컨텐츠 참조` />
        <Info k=`원산지` v=?origin />
        <Divider />
        <Info k=`제조연월일` v=`컨텐츠 참조` />
        <Info k=`관련법상 표시사항` v=`컨텐츠 참조` />
        <Divider />
        <Info k=`수입식품 문구 여부` v=`컨텐츠 참조` />
        <Info k=`상품구성 ` v=displayName />
        <Divider />
        <Info k=`보관방법` v=`컨텐츠 참조` />
        <Info k=`소비자안전을 위한 주의 사항` v=`컨텐츠 참조` />
        <Divider />
        <Info k=`소비자상담관련 전화번호` v=`1670-5245` />
      </div>
    }
  }

  module ProcessedFood = {
    @react.component
    let make = (~displayName) => {
      <div className=%twc("w-full flex flex-wrap border-gray-100 border-y")>
        <Info k=`제품명` v=displayName />
        <Info k=`식품의 유형` v=`컨텐츠 참조` />
        <Divider />
        <Info k=`생산자 및 소재지` v=`컨텐츠 참조` />
        <Info k=`제조연월일` v=`컨텐츠 참조, 제품에 별도표기` />
        <Divider />
        <Info k=`포장단위별 내용물의 용량(중량), 수량` v=`컨텐츠 참조` />
        <Info k=`원재료명 및 함량` v=`컨텐츠 참조` />
        <Divider />
        <Info k=`영양성분` v=`컨텐츠 참조` />
        <Info k=`유전자변형식품에 해당하는 경우의 표시 ` v=`컨텐츠 참조` />
        <Divider />
        <Info k=`소비자안전을 위한 주의 사항` v=`컨텐츠 참조` />
        <Info k=`수입식품 문구` v=`컨텐츠 참조` />
        <Divider />
        <Info k=`소비자상담관련 전화번호` v=`1670-5245` />
      </div>
    }
  }

  @react.component
  let make = (~query) => {
    let {displayName, origin, notationInformationType} = query->Fragment.use
    switch notationInformationType {
    | Some(#WHOLE_FOOD) => <WholeFood displayName origin />
    | Some(#PROCESSED_FOOD) => <ProcessedFood displayName />
    | _ => React.null
    }
  }
}

module MO = {
  module Info = {
    @react.component
    let make = (~k=?, ~v=?) => {
      <div className=%twc("flex items-center")>
        <div className=%twc("w-[140px] p-[10px] h-full flex items-center bg-gray-50")>
          <span className=%twc("text-gray-900 text-[14px]")>
            {k->Option.mapWithDefault(React.null, ReactNl2br.nl2br)}
          </span>
        </div>
        <div className=%twc("p-[10px] h-full flex items-center")>
          <span className=%twc("text-gray-700 text-[14px]")>
            {v->Option.mapWithDefault(React.null, ReactNl2br.nl2br)}
          </span>
        </div>
      </div>
    }
  }

  module WholeFood = {
    @react.component
    let make = (~displayName, ~origin) => {
      <div className=%twc("w-full border-gray-100 border-y")>
        <Info k=`품목 또는 명칭` v=displayName />
        <Divider />
        <Info k=`포장단위별 내용물 용량, 중량, 수량, 크기` v=`컨텐츠 참조` />
        <Divider />
        <Info k=`생산자(수입자)` v=`컨텐츠 참조` />
        <Divider />
        <Info k=`원산지` v=?origin />
        <Divider />
        <Info k=`제조연월일` v=`컨텐츠 참조` />
        <Divider />
        <Info k=`관련법상 표시사항` v=`컨텐츠 참조` />
        <Divider />
        <Info k=`수입식품 문구 여부` v=`컨텐츠 참조` />
        <Divider />
        <Info k=`상품구성 ` v=displayName />
        <Divider />
        <Info k=`보관방법` v=`컨텐츠 참조` />
        <Divider />
        <Info k=`소비자안전을 위한 주의 사항` v=`컨텐츠 참조` />
        <Divider />
        <Info k=`소비자상담관련 전화번호` v=`1670-5245` />
      </div>
    }
  }

  module ProcessedFood = {
    @react.component
    let make = (~displayName) => {
      <div className=%twc("w-full border-gray-100 border-y")>
        <Info k=`제품명` v=displayName />
        <Divider />
        <Info k=`식품의 유형` v=`컨텐츠 참조` />
        <Divider />
        <Info k=`생산자 및 소재지` v=`컨텐츠 참조` />
        <Divider />
        <Info k=`제조연월일` v=`컨텐츠 참조, 제품에 별도표기` />
        <Divider />
        <Info k=`포장단위별 내용물의 용량(중량), 수량` v=`컨텐츠 참조` />
        <Divider />
        <Info k=`원재료명 및 함량` v=`컨텐츠 참조` />
        <Divider />
        <Info k=`영양성분` v=`컨텐츠 참조` />
        <Divider />
        <Info k=`유전자변형식품에 해당하는 경우의 표시 ` v=`컨텐츠 참조` />
        <Divider />
        <Info k=`소비자안전을 위한 주의 사항` v=`컨텐츠 참조` />
        <Divider />
        <Info k=`수입식품 문구` v=`컨텐츠 참조` />
        <Divider />
        <Info k=`소비자상담관련 전화번호` v=`1670-5245` />
      </div>
    }
  }

  @react.component
  let make = (~query) => {
    let {displayName, origin, notationInformationType} = query->Fragment.use
    switch notationInformationType {
    | Some(#WHOLE_FOOD) => <WholeFood displayName origin />
    | Some(#PROCESSED_FOOD) => <ProcessedFood displayName />
    | _ => React.null
    }
  }
}
