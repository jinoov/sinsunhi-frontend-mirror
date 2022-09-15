@react.component
let make = (~children=?) => {
  <div className=%twc("fixed w-full bottom-0 left-0")>
    <div className=%twc("w-full max-w-[768px] p-3 mx-auto border-t border-t-gray-100 bg-white")>
      <div className=%twc("w-full h-14 flex")>
        <ReactUtil.SpreadProps props={"data-gtm": `click_chatbot`}>
          <button className=%twc("w-16") onClick={_ => ChannelTalk.showMessenger()}>
            <div className=%twc("flex justify-center")>
              <IconChat width="30" height="30" fill="#727272" />
            </div>
            <div className=%twc("text-xs text-gray-600 font-bold word-keep-all")>
              {`상담하기`->React.string}
            </div>
          </button>
        </ReactUtil.SpreadProps>
        {children->Option.getWithDefault(React.null)}
      </div>
    </div>
  </div>
}
