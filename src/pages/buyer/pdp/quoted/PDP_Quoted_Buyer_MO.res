module Fragment = %relay(`
  fragment PDPQuotedBuyerMOFragment on QuotedProduct {
    # Commons
    image {
      thumb1920x1920
      thumb1000x1000
    }
    salesDocument
    displayName
    description
    notice
    noticeStartAt
    noticeEndAt
  
    # Fragments
    ...PDPQuotedDetailsBuyerFragment
    ...PDPQuotedRfqBtnBuyer_fragment
  }
`)

@react.component
let make = (~query) => {
  let router = Next.Router.useRouter()
  let {
    image,
    salesDocument,
    displayName,
    notice,
    noticeStartAt,
    noticeEndAt,
    description,
    fragmentRefs,
  } =
    query->Fragment.use

  let (showModal, setShowModal) = React.Uncurried.useState(_ => PDP_Quoted_Modals_Buyer.Hide)

  <>
    <div className=%twc("w-full min-h-screen")>
      <div className=%twc("w-full bg-white")>
        <div className=%twc("w-full max-w-3xl mx-auto bg-white min-h-screen")>
          <Header_Buyer.Mobile.BackAndCart key=router.asPath title={`상품 상세`} />
          <section className=%twc("flex flex-col gap-5")>
            <PDP_Image_Buyer.MO src=image.thumb1000x1000 alt=displayName />
          </section>
          <section className=%twc("px-5 divide-y")>
            <div className=%twc("w-full divide-y")>
              <section className=%twc("pt-5 pb-8")>
                <PDP_Quoted_Title_Buyer.MO displayName />
              </section>
              <section className=%twc("py-8")>
                <PDP_Quoted_Details_Buyer.MO query=fragmentRefs />
              </section>
              <section className=%twc("py-8 flex flex-col gap-5")>
                <PDP_Quoted_RequestGuide_Buyer.MO />
                <PDP_Quoted_RfqBtn_Buyer.MO setShowModal query=fragmentRefs />
              </section>
            </div>
            {salesDocument->Option.mapWithDefault(React.null, salesDocument' =>
              <PDP_SalesDocument_Buyer.MO salesDocument=salesDocument' />
            )}
            <div className=%twc("flex flex-col gap-5 py-8")>
              <h1 className=%twc("text-text-L1 text-base font-bold")>
                {`상세설명`->React.string}
              </h1>
              <PDP_Notice_Buyer.MO notice noticeStartAt noticeEndAt />
              <div className=%twc("w-full overflow-x-scroll")>
                <Editor.Viewer value=description />
              </div>
            </div>
          </section>
          <Footer_Buyer.MO />
        </div>
      </div>
    </div>
    <PDP_Quoted_Modals_Buyer.MO show=showModal setShow=setShowModal />
  </>
}
