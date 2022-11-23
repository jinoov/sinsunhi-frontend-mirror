// 매칭 상품 PDP의 PC 화면에 대응하기 위한 컴포넌트입니다.
// 추후 매칭상품 PDP PC 화면이 나오게 될 경우, 이 컴포넌트를 삭제해야 합니다.

@module("../../../../../public/assets/cs-chat.svg")
external csChat: string = "default"

@react.component
let make = () => {
  <button
    onClick={_ => ChannelTalk.showMessenger()}
    className=%twc(
      "w-14 h-14 bg-gray-100 rounded-xl flex justify-center items-center cursor-pointer"
    )>
    <img src=csChat className=%twc("w-8 h-8") alt="cta-cs-btn-mobile" />
  </button>
}
