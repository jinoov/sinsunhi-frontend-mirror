@react.component
let make = (~onComplete, ~closeDrawer, ~isShow) => {
  <DS_BottomDrawer.Root full=true isShow onClose={_ => closeDrawer()}>
    <DS_BottomDrawer.Header />
    <DS_BottomDrawer.Body>
      <RescriptReactErrorBoundary
        fallback={_ =>
          <div className=%twc("flex items-center justify-center")>
            <contents className=%twc("flex flex-col items-center justify-center")>
              <IconNotFound width="160" height="160" />
              <h1 className=%twc("mt-7 text-2xl text-gray-800 font-bold")>
                {`처리중 오류가 발생하였습니다.`->React.string}
              </h1>
              <span className=%twc("mt-4 text-gray-800")>
                {`페이지를 불러오는 중에 문제가 발생하였습니다.`->React.string}
              </span>
              <span className=%twc("text-gray-800")>
                {`잠시 후 재시도해 주세요.`->React.string}
              </span>
            </contents>
          </div>}>
        <SearchAddressEmbed onComplete isShow />
      </RescriptReactErrorBoundary>
    </DS_BottomDrawer.Body>
  </DS_BottomDrawer.Root>
}
