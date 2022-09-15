module PC = {
  module Skeleton = {
    @react.component
    let make = () => {
      <div
        className=%twc("w-[1280px] mx-auto h-[108px] rounded-[10px] animate-pulse bg-gray-150")
      />
    }
  }
  @react.component
  let make = () => {
    <div
      className=%twc(
        "w-[1280px] mx-auto h-[98px] rounded-[10px] flex items-center bg-blue-50 pl-9"
      )>
      <img className=%twc("h-full object-contain") src="https://public.sinsunhi.com/images/20220712/sinsun_matching_description.png" />
      <div
        className=%twc(
          "flex-1 flex flex-col h-full text-lg items-stretch pl-9 py-[26px] text-gray-800 "
        )>
        <div className=%twc("font-bold mb-1 leading-[22px]")> {`신선매칭이란?`->React.string} </div>
        <div className=%twc("leading-5")>
          {`필요한 품종에 대해 견적요청하시면,\n 최저가 상품을 연결해드립니다.`->React.string}
        </div>
      </div>
    </div>
  }
}

module MO = {
  module Skeleton = {
    @react.component
    let make = () => {
      <div className=%twc("w-full flex h-[98px] animate-pulse bg-gray-150") />
    }
  }
  @react.component
  let make = () => {
    <div className=%twc("w-full flex h-[98px] bg-blue-50")>
      <div className=%twc("flex-1 flex flex-col h-full p-4 text-sm text-gray-800")>
        <div className=%twc("font-bold mb-1")> {`신선매칭이란?`->React.string} </div>
        <div className=%twc("whitespace-pre")>
          {`필요한 품종에 대해 견적요청하시면,\n최저가 상품을 연결해드립니다.`->React.string}
        </div>
      </div>
      <img className=%twc("w-[108px] h-full mr-[18px] object-contain") src="https://public.sinsunhi.com/images/20220712/sinsun_matching_description.png" />
    </div>
  }
}
