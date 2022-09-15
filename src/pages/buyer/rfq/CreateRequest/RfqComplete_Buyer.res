module Complete = {
  @react.component
  let make = () => {
    let router = Next.Router.useRouter()

    <div className=%twc("relative container max-w-3xl mx-auto min-h-screen sm:shadow-gl pt-11")>
      <DS_TopNavigation.Detail.Root>
        <DS_TopNavigation.Detail.Left>
          <a className=%twc("cursor-pointer") onClick={_ => router->Next.Router.push("/buyer/rfq")}>
            <DS_Icon.Common.ArrowLeftXLarge1 height="32" width="32" className=%twc("relative") />
          </a>
        </DS_TopNavigation.Detail.Left>
      </DS_TopNavigation.Detail.Root>
      <div className=%twc("px-5")>
        <div className=%twc("pt-7 text-[26px] font-bold")>
          <DS_Badge.Medium text={`요청서를 보냈어요!`} colorType=#secondary />
          <h2 className=%twc("leading-[38px] mt-2 whitespace-pre-line")>
            {`(영업일) 2시간내로 \n견적요청 결과를 보내드립니다.`->React.string}
          </h2>
          <h3 className=%twc("mt-2 text-base text-text-L3 font-normal whitespace-pre-line")>
            {`카카오톡에서 확인하실 수 있어요`->React.string}
          </h3>
          <h3 className=%twc("text-base text-text-L3 font-normal whitespace-pre-line")>
            {`※ 단, 16시 이후 견적요청 건은 다음 날 오전에 결과를 보내드려요`->React.string}
          </h3>
        </div>
      </div>
      <DS_ButtonContainer.Floating1
        label={`카카오톡으로 확인하기`}
        buttonType=#white
        onClick={_ =>
          switch Global.window {
          | Some(window') =>
            Global.Window.openLink(window', ~url=Env.kakaotalkChannel, ~windowFeatures="", ())
          | None => ()
          }}
      />
    </div>
  }
}

@react.component
let make = () =>
  <Authorization.Buyer title={j`바이어 견적 요청`}>
    <Complete />
  </Authorization.Buyer>
