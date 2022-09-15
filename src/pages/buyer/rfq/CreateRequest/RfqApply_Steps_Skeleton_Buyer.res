@react.component
let make = () => {
  <>
    <section className=%twc("pt-7")>
      <div className=%twc("px-5")> <Skeleton.Box className=%twc("h-18") /> </div>
      <ul className=%twc("py-11")>
        <li className=%twc("h-14 px-5 space-y-1")>
          <Skeleton.Box className=%twc("h-6 w-1/4") />
        </li>
        <li className=%twc("h-14 px-5 space-y-1")>
          <Skeleton.Box className=%twc("h-6 w-1/3") />
        </li>
        <li className=%twc("h-14 px-5 space-y-1")>
          <Skeleton.Box className=%twc("h-6 w-1/4") />
        </li>
        <li className=%twc("h-14 px-5 space-y-1")>
          <Skeleton.Box className=%twc("h-6 w-1/3") />
        </li>
      </ul>
      <div className=%twc("fixed bottom-0 max-w-3xl w-full px-4 py-5")>
        <Skeleton.Box className=%twc("w-full rounded-xl h-[52px]") />
      </div>
    </section>
  </>
}
