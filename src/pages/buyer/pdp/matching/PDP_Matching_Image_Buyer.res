/*
  1. 컴포넌트 위치
  PDP > 매칭상품 > 이미지
  
  2. 역할
  매칭상품의 이미지를 표현합니다
*/

@react.component
let make = (~src, ~alt) => {
  <div className=%twc("w-full")>
    <div className=%twc("relative overflow-hidden")>
      <Image
        src
        placeholder=Image.Placeholder.Lg
        className=%twc("w-full max-h-[300px] object-contain")
        alt
      />
      <div className=%twc("w-full h-full absolute top-0 left-0 bg-black/[.03]") />
    </div>
  </div>
}
