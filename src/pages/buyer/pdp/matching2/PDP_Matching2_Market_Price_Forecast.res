@react.component
let make = () => {
  // Should not show the real numbers to guest users.
  // Blur the page with some random numbers for them.
  // Here you need `repMarketPriceDiff` and the user session.
  // And for now, you have no forcast data.
  let sessionStatus = CustomHooks.User.Buyer.use2()
  let (authenticated, blurryClass) = switch sessionStatus {
  | LoggedIn(_) => (true, "")
  | Unknown | NotLoggedIn => (false, "blur-sm opacity-50")
  }

  <div className="mb-5 relative">
    // Login guide layer hide for the logged in users.
    {authenticated
      ? React.null
      : <div
          className="absolute left-0 top-0 w-full h-full flex flex-col content-center justify-center flex-wrap text-sm z-10">
          <div className="mb-4 text-center">
            {`회원 로그인 후\n예상 시세를 확인해보세요`->ReactNl2br.nl2br}
          </div>
          <button
            type_="button"
            role="button"
            className="border border-green-500 bg-white rounded-lg py-2 px-4 text-green-500 font-semibold">
            {`로그인하고 시세 확인하기`->React.string}
          </button>
        </div>}
    // Contents. Blurry for the guest.
    <div className={blurryClass}>
      <div className="font-semibold text-lg mb-5"> {`예상 시세`->React.string} </div>
      <div
        className="grid grid-cols-2 py-2 px-3 text-[0.8125rem] bg-gray-50 rounded-lg font-light tracking-tighter">
        <div className=""> {`1주 후 평균가`->React.string} </div>
        <div className=""> {`최종 평균가보다`->React.string} </div>
      </div>
      <div className="grid grid-cols-2 p-3 text-sm items-center">
        <div className="font-semibold"> {`${100000->Locale.Int.show}원`->React.string} </div>
        <div className="text-red-600">
          <div> {`+${500->Locale.Int.show}원`->React.string} </div>
          <div> {`(0.0%)`->React.string} </div>
        </div>
      </div>
      <div
        className="grid grid-cols-2 py-2 px-3 text-[0.8125rem] bg-gray-50 rounded-lg font-light tracking-tighter">
        <div className=""> {`2주 후 평균가`->React.string} </div>
        <div className=""> {`최종 평균가보다`->React.string} </div>
      </div>
      <div className="grid grid-cols-2 p-3 text-sm items-center border-b">
        <div className="font-semibold"> {`${100000->Locale.Int.show}원`->React.string} </div>
        <div className="text-blue-500">
          <div> {`-${500->Locale.Int.show}원`->React.string} </div>
          <div> {`(-0.0%)`->React.string} </div>
        </div>
      </div>
    </div>
  </div>
}
