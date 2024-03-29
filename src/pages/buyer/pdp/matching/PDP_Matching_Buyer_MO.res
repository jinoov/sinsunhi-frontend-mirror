module Fragment = %relay(`
  fragment PDPMatchingBuyerMO_fragment on MatchingProduct {
    productId: number
    displayName
  
    image {
      thumb1920x1920
      thumb1000x1000
    }
    category {
      parent {
        name
      }
    }
  
    ...PDPMatchingSiblingCategoriesBuyer_fragment
    ...PDPMatchingTitleBuyer_fragment
    ...PDPMatchingSelectGradeBuyer_fragment
    ...PDPMatchingDemeterBuyer_fragment
    ...PDPMatchingEstimatorBuyer_fragment
    ...PDPMatchingDetailsBuyer_fragment
    ...PDPMatchingGradeGuideBuyer_fragment
    ...PDPMatchingSubmitBuyer_fragment
  }
`)

module Divider = {
  @react.component
  let make = () => {
    <div className=%twc("w-full h-3 bg-gray-100") />
  }
}

@react.component
let make = (~query) => {
  let router = Next.Router.useRouter()

  let {productId, image, fragmentRefs, displayName, category} = query->Fragment.use
  let parentCategoryName = category.parent->Option.mapWithDefault(`상품 상세`, ({name}) => name)

  let (showModal, setShowModal) = React.Uncurried.useState(_ => PDP_Matching_Modals_Buyer.Hide)
  let (selectedGroup, setSelectedGroup) = React.Uncurried.useState(_ => "high")

  <div className=%twc("w-full min-h-screen")>
    <Header_Buyer.Mobile.BackAndCart key=router.asPath title=parentCategoryName />
    <PDP_Matching_SiblingCategories_Buyer query=fragmentRefs />
    <div className=%twc("w-full bg-white")>
      <div className=%twc("w-full max-w-3xl mx-auto relative bg-white min-h-screen")>
        <PDP_Matching_Image_Buyer src=image.thumb1000x1000 alt=displayName />
        <section className=%twc("px-4")>
          <PDP_Matching_Title_Buyer.MO query=fragmentRefs selectedGroup />
        </section>
        <section className=%twc("px-4")>
          <PDP_Matching_SelectGrade_Buyer
            selectedGroup setSelectedGroup setShowModal query=fragmentRefs
          />
        </section>
        <section className=%twc("py-6")>
          <PDP_Matching_Demeter_Buyer query=fragmentRefs selectedGroup />
        </section>
        <Divider />
        <PDP_Matching_Estimator_Buyer
          key={productId->Int.toString} query=fragmentRefs selectedGroup
        />
        <section className=%twc("px-4")>
          <PDP_Matching_Details_Buyer query=fragmentRefs />
        </section>
        <Divider />
        <section className=%twc("px-4 pt-4 pb-16")>
          <PDP_Matching_ServiceGuide_Buyer.Trigger
            onClick={_ => setShowModal(._ => PDP_Matching_Modals_Buyer.Show(ServiceGuide))}
          />
          <PDP_Matching_GradeGuide_Buyer.Trigger
            className=%twc("mt-3")
            onClick={_ => setShowModal(._ => PDP_Matching_Modals_Buyer.Show(GradeGuide))}
          />
        </section>
      </div>
      <PDP_Matching_Submit_Buyer.MO setShowModal selectedGroup query=fragmentRefs />
      <PDP_Matching_Modals_Buyer.MO show=showModal setShow=setShowModal query=fragmentRefs />
    </div>
    <Footer_Buyer.MO />
  </div>
}
