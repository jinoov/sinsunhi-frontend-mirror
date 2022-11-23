module Fragment = %relay(`
  fragment PDPQuotedBuyerPCFragment on QuotedProduct {
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
    ...PDPLikeButton_Fragment
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
    <div className=%twc("w-full min-w-[1280px] min-h-screen")>
      <Header_Buyer.PC key=router.asPath />
      <div className=%twc("w-[1280px] mx-auto min-h-full")>
        <div className=%twc("w-full pt-16 px-5 divide-y")>
          <section className=%twc("w-full flex pb-12 gap-20")>
            <div>
              <PDP_Image_Buyer.PC src=image.thumb1920x1920 alt=displayName />
              {salesDocument->Option.mapWithDefault(React.null, salesDocument' =>
                <PDP_SalesDocument_Buyer.PC salesDocument=salesDocument' />
              )}
            </div>
            <div className=%twc("w-full")>
              <PDP_Quoted_Title_Buyer.PC displayName />
              <section className=%twc("mt-4 border border-gray-200 rounded-xl divide-y")>
                <div className=%twc("px-6 py-8 divide-y")>
                  <PDP_Quoted_Details_Buyer.PC query=fragmentRefs />
                  <div className=%twc("flex flex-col gap-6 pt-6")>
                    <PDP_Quoted_RequestGuide_Buyer.PC />
                  </div>
                </div>
              </section>
              <section className=%twc("w-full mt-4 flex gap-2")>
                <PDP_Like_Button query=fragmentRefs/>
                <PDP_CsChat_Button />
                <PDP_Quoted_RfqBtn_Buyer.PC setShowModal query=fragmentRefs />
              </section>
            </div>
          </section>
          <section className=%twc("pt-16")>
            <span className=%twc("text-2xl font-bold text-gray-800")>
              {`상세 설명`->React.string}
            </span>
            <PDP_Notice_Buyer.PC notice noticeStartAt noticeEndAt />
            <div className=%twc("py-16")>
              <Editor.Viewer value=description />
            </div>
          </section>
        </div>
      </div>
      <Footer_Buyer.PC />
    </div>
    <PDP_Quoted_Modals_Buyer.PC show=showModal setShow=setShowModal />
  </>
}
