module Card = {
  @react.component
  let make = (~content, ~onClick, ~children=React.null) => {
    <div
      className=%twc(
        "px-4 py-3 flex items-center justify-between border border-gray-200 rounded-[4px] h-full"
      )>
      <div className=%twc("text-sm mr-2")> {content->React.string} </div>
      <button className=%twc("px-3 py-2 text-sm bg-gray-50 rounded-lg text-gray-800") onClick>
        {`입력하기`->React.string}
      </button>
      {children}
    </div>
  }
}

module SalesBin = {
  @react.component
  let make = (~onClick) => {
    <Card content={`💰 연간 거래 규모는 어느정도 되시나요?`} onClick />
  }
}

module Sectors = {
  @react.component
  let make = (~onClick) => {
    <Card content={`🚛 주 납품 유형은 무엇인가요?`} onClick />
  }
}

module InterestCategories = {
  @react.component
  let make = (~onClick) => {
    <Card content={`🍅 관심 상품을 알려주세요.`} onClick />
  }
}

module BusinessNumber = {
  @react.component
  let make = (~onClick) => {
    <Card content={`📄 사업자 등록번호를 확인해주세요.`} onClick />
  }
}

module Manager = {
  @react.component
  let make = (~onClick) => {
    <Card content={`💻 담당자명을 알려주세요.`} onClick />
  }
}
