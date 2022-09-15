module Skeleton = {
  @react.component
  let make = () => {
    <div className=%twc("mt-20 mb-8 mx-auto w-[1280px] ")>
      <div className=%twc("animate-pulse rounded-lg bg-gray-150 w-36 h-9") />
    </div>
  }
}
@react.component
let make = (~title) => {
  <div className=%twc("text-[32px] w-[1280px] mx-auto font-bold leading-[44px] mt-20 mb-8")>
    <h1> <span> {title->React.string} </span> </h1>
  </div>
}
