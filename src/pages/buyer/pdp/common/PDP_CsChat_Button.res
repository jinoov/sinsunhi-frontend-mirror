@module("../../../../../public/assets/cs-chat.svg")
external csChat: string = "default"

@react.component
let make = () => {
  <button
    onClick={_ => ChannelTalk.showMessenger()}
    className=%twc(
      "w-14 h-14 xl:w-16 xl:h-16 bg-gray-100 rounded-xl flex justify-center items-center cursor-pointer"
    )>
    <img src=csChat className=%twc("w-8 h-8") alt="cta-cs-btn-mobile" />
  </button>
}
