type unitWeightPrice = int // price per 1kg * representative weight

@react.component
let make = (~price: unitWeightPrice) => {
  <div className="mb-8">
    <div className="flex items-baseline justify-between mb-8">
      <div className="font-semibold text-lg"> {`도매가격 비교`->React.string} </div>
      <div className="text-sm text-gray-400"> {`오늘 기준 평균가`->React.string} </div>
    </div>
    <div className="flex justify-evenly items-end">
      <div>
        <div
          className="mb-2 px-2 py-1.5 rounded-3xl text-sm font-light text-gray-700 bg-gray-100 text-center">
          {`도매시장`->React.string}
        </div>
        <div className="rounded-lg h-36 bg-gray-300">
          <div
            className="py-1.5 text-center text-sm font-light rounded-t-lg text-white bg-gray-400">
            {`수수료`->React.string}
          </div>
        </div>
        <div className="mt-2 font-semibold">
          {`${(price->Int.toFloat *. 1.2)
            ->Js.Math.floor_float
            ->Locale.Float.show(~digits=0)} 원`->React.string}
        </div>
      </div>
      <div>
        <div
          className="mb-2 px-2 py-1.5 rounded-3xl text-sm font-light text-gray-700 bg-gray-100 text-center">
          {`신선하이`->React.string}
        </div>
        <div className="rounded-lg h-28 bg-primary" />
        <div className="mt-2 font-semibold"> {`${price->Locale.Int.show} 원`->React.string} </div>
      </div>
    </div>
  </div>
}
