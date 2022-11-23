module Layout = {
  @react.component
  let make = (~children=?) => {
    let oldUI =
      <div className=%twc("sm:px-20 py-4")>
        {children->Option.getWithDefault(React.null)}
        <footer
          className=%twc("w-full flex flex-row items-center justify-center py-7 text-text-L3 ")>
          {j`ⓒ Copyright Greenlabs All Reserved. (주)그린랩스`->React.string}
        </footer>
      </div>

    <FeatureFlagWrapper featureFlag=#HOME_UI_UX fallback=oldUI>
      {children->Option.getWithDefault(React.null)}
    </FeatureFlagWrapper>
  }
}

@react.component
let make = () => {
  let deviceDetect = DeviceDetect.detectDevice()
  let oldUI =
    <Authorization.Buyer title={j`다운로드 센터`}>
      <DownloadCenter_Render>
        <Layout />
      </DownloadCenter_Render>
    </Authorization.Buyer>

  let newUI =
    <Authorization.Buyer title={j`다운로드 센터`}>
      <div className=%twc("flex bg-[#FAFBFC] pc-content")>
        <PC_MyInfo_Sidebar />
        <div className=%twc("min-w-[872px] max-w-[1280px] w-full mx-16 mt-10")>
          <DownloadCenter_Render>
            <Layout />
          </DownloadCenter_Render>
        </div>
      </div>
    </Authorization.Buyer>

  <FeatureFlagWrapper featureFlag=#HOME_UI_UX fallback=oldUI>
    {switch deviceDetect {
    | PC => newUI
    | Unknown
    | Mobile => oldUI
    }}
  </FeatureFlagWrapper>
}
