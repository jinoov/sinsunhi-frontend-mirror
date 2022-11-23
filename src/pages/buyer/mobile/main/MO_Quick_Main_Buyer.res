module Category_List = {
  @react.component
  let make = () => {
    <RescriptReactErrorBoundary fallback={_ => <ShopMain_CategoryList_Buyer.MO.Placeholder />}>
      <React.Suspense fallback={<ShopMain_CategoryList_Buyer.MO.Placeholder />}>
        <section className=%twc("mt-[30px] px-2")>
          <ShopMain_CategoryList_Buyer.MO />
        </section>
      </React.Suspense>
    </RescriptReactErrorBoundary>
  }
}

module Showcase_List = {
  @react.component
  let make = () => {
    <RescriptReactErrorBoundary
      fallback={_ => <ShopMainSpecialShowcaseList_Buyer.MO.Placeholder />}>
      <React.Suspense fallback={<ShopMainSpecialShowcaseList_Buyer.MO.Placeholder />}>
        <ShopMainSpecialShowcaseList_Buyer.MO />
      </React.Suspense>
      <React.Suspense fallback={<MO_ALLProductShowcaseList_Main_Buyer.Placeholder />}>
        <MO_ALLProductShowcaseList_Main_Buyer />
      </React.Suspense>
      <React.Suspense fallback={<MO_CategoryShowcaseList_Main_Buyer.Placeholder />}>
        <MO_CategoryShowcaseList_Main_Buyer />
      </React.Suspense>
    </RescriptReactErrorBoundary>
  }
}

@react.component
let make = (~query) =>
  <div>
    <MO_Quick_Banner_Buyer query />
    <Category_List />
    <ClientSideRender fallback={<ShopMainSpecialShowcaseList_Buyer.MO.Placeholder />}>
      <Showcase_List />
    </ClientSideRender>
  </div>
