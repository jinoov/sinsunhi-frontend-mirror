@react.component
let make = () => {
  <>
    <div className=%twc("px-5 py-9")>
      <Skeleton.Box className=%twc("h-18") />
    </div>
    <div className=%twc("space-y-8")>
      <div className=%twc("px-5 space-y-1")>
        <Skeleton.Box className=%twc("h-7 w-1/5") />
        <Skeleton.Box className=%twc("h-5 w-1/3") />
        <Skeleton.Box className=%twc("h-5 w-1/2") />
      </div>
      <div className=%twc("px-5 space-y-1")>
        <Skeleton.Box className=%twc("h-7 w-1/5") />
        <Skeleton.Box className=%twc("h-5 w-1/3") />
        <Skeleton.Box className=%twc("h-5 w-1/2") />
      </div>
    </div>
    <div className=%twc("fixed bottom-0 max-w-3xl w-full px-4 py-5")>
      <Skeleton.Box className=%twc("w-full rounded-xl h-[52px]") />
    </div>
    <div className=%twc("h-24") />
  </>
}
