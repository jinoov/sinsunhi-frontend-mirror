@module("/public/assets/search-bnb-enabled.svg")
external searchBnbEnabled: string = "default"

module Query = %relay(`
  query PCQuickMainBuyer_Query {
    ...PCQuickBannerSlideBuyerFragment
  }
`)

module Skeleton = {
  @react.component
  let make = () => {
    <div
      className=%twc(
        "flex flex-col relative w-[1280px] mx-auto mt-8 rounded-sm bg-white shadow-[0px_10px_40px_10px_rgba(0,0,0,0.03)]"
      )>
      <PC_Quick_Banner_Slide_Buyer.Skeleton />
      <ShopMainSpecialShowcaseList_Buyer.PC.Placeholder />
    </div>
  }
}

@react.component
let make = () => {
  let isCsr = CustomHooks.useCsr()
  let {fragmentRefs} = Query.use(~variables=(), ())

  <>
    <div
      className=%twc(
        "flex flex-col relative w-[1280px] mx-auto mt-8 rounded-sm bg-white shadow-[0px_10px_40px_10px_rgba(0,0,0,0.03)]"
      )>
      <PC_Quick_Banner_Slide_Buyer query=fragmentRefs />
      <ShopMain_CategoryList_Buyer.PC />
    </div>
    {switch isCsr {
    | true =>
      <RescriptReactErrorBoundary
        fallback={_ => <ShopMainSpecialShowcaseList_Buyer.PC.Placeholder />}>
        <React.Suspense fallback={<ShopMainSpecialShowcaseList_Buyer.PC.Placeholder />}>
          <ShopMainSpecialShowcaseList_Buyer.PC />
        </React.Suspense>
        <React.Suspense fallback={<PC_ALLProductShowcaseList_Main_Buyer.Placeholder />}>
          <PC_ALLProductShowcaseList_Main_Buyer />
        </React.Suspense>
        <React.Suspense fallback={<PC_CategoryShowcaseList_Main_Buyer.Placeholder />}>
          <PC_CategoryShowcaseList_Main_Buyer />
        </React.Suspense>
      </RescriptReactErrorBoundary>
    | false => <ShopMainSpecialShowcaseList_Buyer.PC.Placeholder />
    }}
  </>
}
