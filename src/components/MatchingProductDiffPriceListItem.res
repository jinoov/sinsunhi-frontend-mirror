type diffTerm = [#day | #week]
module DiffNumber = {
  @react.component
  let make = (~diffPrice: option<int>, ~diffRate: option<float>, ~diffTerm=#day) => {
    let baseStyle = %twc("text-sm ")

    let rise = %twc("text-[#E84A07]")
    let fall = %twc("text-blue-500")
    let keep = %twc("text-gray-500")

    let textStyle = switch diffPrice {
    | Some(amount') if amount' > 0 => cx([rise, baseStyle])
    | Some(amount') if amount' < 0 => cx([fall, baseStyle])
    | _ => cx([baseStyle, keep])
    }

    let difflabel = {
      switch diffPrice {
      | None => "-"
      | Some(diffPrice') => `${diffPrice'->Locale.Int.show(~showPlusSign=true)}원`
      }
    }
    <>
      <div className=%twc("inline-flex text-gray-500")>
        <span className={cx([%twc("mr-1"), baseStyle])}>
          {switch diffTerm {
          | #week => `전주대비`->React.string
          | #day => `전일대비`->React.string
          }}
        </span>
        <span className=textStyle> {difflabel->React.string} </span>
      </div>
      {switch diffRate {
      | None => <div> {"‎ "->React.string} </div>
      | Some(diffRate') =>
        <div>
          <span className=textStyle>
            {`(${(diffRate' *. 100.)
                ->Locale.Float.show(~showPlusSign=true, ~digits=2)}%)`->React.string}
          </span>
        </div>
      }}
    </>
  }
}

module Placeholder = {
  @react.component
  let make = () => {
    <li className=%twc("flex flex-row px-4 text-gray-800  py-4")>
      <div className=%twc("w-12 h-12 bg-gray-100 rounded-full mr-3 animate-pulse") />
      <div className=%twc("inline-flex flex-col flex-1")>
        <Skeleton.Box className=%twc("w-full h-[18px]") />
        <Skeleton.Box className=%twc("w-1/4 h-4") />
      </div>
    </li>
  }
}

@react.component
let make = (~image, ~name, ~representativeWeight, ~price, ~diffPrice, ~diffRate, ~diffTerm=?) => {
  <li className=%twc("flex flex-row p-2.5 text-gray-700 font-medium")>
    <div className=%twc("flex")>
      <img
        src=image
        className=%twc("w-12 h-12 mr-3 rounded-full border-[1px] border-[#F0F2F5]")
        alt={`${name} 상품 이미지`}
      />
    </div>
    <div className=%twc("inline-flex flex-col flex-1 justify-start")>
      {`${name}`->React.string}
      <span className=%twc("text-[15px] text-gray-500")>
        {`${representativeWeight->Locale.Float.toLocaleStringF(
            ~locale="ko-KR",
            (),
          )}kg`->React.string}
      </span>
    </div>
    <div className=%twc("w-10") />
    <div className=%twc("inline-flex flex-col items-end justify-start")>
      <span className=%twc("text-lg")>
        {`${price->Locale.Int.toLocaleString(~locale="ko-KR", ())}원`->React.string}
      </span>
      <DiffNumber diffPrice diffTerm=?{diffTerm} diffRate />
    </div>
  </li>
}
