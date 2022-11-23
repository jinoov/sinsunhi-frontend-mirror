@react.component
let make = (
  ~submitRef: ReactDOM.domRef,
  ~quotePrice: int,
  ~quoteWeight: int,
  ~representativeWeight: float,
) => {
  // Number of boxes
  let boxes = (quoteWeight->Int.toFloat /. representativeWeight)->Js.Math.ceil_float
  // price * boxes
  let calculatedPrice = quotePrice->Int.toFloat *. boxes

  <div ref={submitRef} className="fixed bottom-0 left-0 w-full border-t bg-white">
    <div className="flex items-center justify-between max-w-3xl m-auto p-4">
      <div>
        <div className="text-gray-400 text-sm"> {`예상 견적가`->React.string} </div>
        <div className="font-semibold text-xl">
          {(calculatedPrice->Locale.Float.show(~digits=0) ++ "원")->React.string}
        </div>
      </div>
      <button className="font-semibold text-white bg-primary rounded-xl px-9 py-4">
        {`견적 요청하기`->React.string}
      </button>
    </div>
  </div>
}
