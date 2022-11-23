/*
  1. 컴포넌트 위치
  PDP > 메인 이미지
  
  2. 역할
  상품 이미지를 표현합니다
*/

module PC = {
  @react.component
  let make = (~src, ~alt) => {
    <div className=%twc("relative w-[664px] pt-[100%] rounded-2xl overflow-hidden")>
      <Image
        src
        placeholder=Image.Placeholder.Lg
        className=%twc("absolute left-0 top-0 w-full h-full object-cover")
        alt
      />
      <div className=%twc("w-full h-full absolute top-0 left-0 bg-black/[.03] rounded-2xl") />
    </div>
  }
}

module MO = {
  @react.component
  let make = (~src, ~alt) => {
    <div className=%twc("w-full pt-[100%] relative overflow-hidden")>
      <Image
        src
        placeholder=Image.Placeholder.Lg
        className=%twc("absolute top-0 left-0 w-full h-full object-cover")
        alt
      />
      <div className=%twc("w-full h-full absolute top-0 left-0 bg-black/[.03]") />
    </div>
  }
}
