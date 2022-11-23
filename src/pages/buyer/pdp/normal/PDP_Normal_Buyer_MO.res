module Fragment = %relay(`
  fragment PDPNormalBuyerMOFragment on Product {
    # Commons
    image {
      thumb1920x1920
      thumb1000x1000
    }
    salesDocument
    description
    displayName
    status
    notice
    noticeStartAt
    noticeEndAt
  
    # Origin
    ... on NormalProduct {
      price
    }
  
    ... on QuotableProduct {
      price
    }
  
    # Fragments
    ...PDPNormalDetailsBuyerFragment
    ...PDPNormalSelectOptionBuyerFragment
    ...PDPNormalTotalPriceBuyerFragment
    ...PDPNormalSubmitBuyerFragment
    ...PDPNormalContentsGuideBuyer_fragment
    ...PDPNormalDeliveryGuideBuyer_fragment
    ...PDPNormalOrderSpecificationBuyer_fragment
  }
`)

@react.component
let make = (~query) => {
  let router = Next.Router.useRouter()
  let {
    image,
    salesDocument,
    description,
    displayName,
    price,
    status,
    notice,
    noticeStartAt,
    noticeEndAt,
    fragmentRefs,
  } =
    query->Fragment.use

  let (selectedOptions, setSelectedOptions) = React.Uncurried.useState(_ =>
    Map.String.fromArray([])
  )

  let (showModal, setShowModal) = React.Uncurried.useState(_ => PDP_Normal_Modals_Buyer.Hide)

  <>
    <div className=%twc("w-full min-h-screen")>
      <div className=%twc("w-full bg-white")>
        <div className=%twc("w-full max-w-3xl mx-auto bg-white min-h-screen")>
          <Header_Buyer.Mobile.BackAndCart key=router.asPath title={`상품 상세`} />
          <PDP_Image_Buyer.MO src=image.thumb1000x1000 alt=displayName />
          <section>
            <div className=%twc("px-5")>
              <section className=%twc("py-6")>
                <PDP_Normal_Title_Buyer.MO displayName price isSoldout={status == #SOLDOUT} />
                <div className=%twc("pt-4")>
                  <PDP_Normal_SelectOption_Buyer.MO
                    query=fragmentRefs selectedOptions setSelectedOptions setShowModal
                  />
                </div>
                {switch selectedOptions->Map.String.toArray {
                | [] => React.null
                | nonEmptyOptions =>
                  <>
                    <div className=%twc("mt-6 w-full h-[1px] bg-gray-100") />
                    <section className=%twc("py-1")>
                      {nonEmptyOptions
                      ->Array.map(((id, quantity)) => {
                        <React.Suspense key=id fallback={React.null}>
                          <PDP_Normal_SelectedOptionItem_Buyer.MO
                            id
                            quantity
                            onChange={(optionId, quantity) => {
                              setSelectedOptions(.prev => prev->Map.String.set(optionId, quantity))
                            }}
                            onRemove={optionId => {
                              setSelectedOptions(.prev => prev->Map.String.remove(optionId))
                            }}
                          />
                        </React.Suspense>
                      })
                      ->React.array}
                    </section>
                  </>
                }}
                <div className=%twc("mt-6 w-full h-[1px] bg-gray-100") />
                <section className=%twc("pt-6")>
                  <PDP_Normal_TotalPrice_Buyer.MO query=fragmentRefs selectedOptions />
                </section>
              </section>
            </div>
            <div className=%twc("w-full h-3 bg-gray-100") />
            <div className=%twc("w-full px-5 divide-y")>
              <section className=%twc("py-8")>
                <PDP_Normal_Details_Buyer.MO query=fragmentRefs />
                <div className=%twc("mt-4 w-full flex items-center justify-center")>
                  <button
                    className=%twc(
                      "px-4 py-2 flex items-center text-gray-800 bg-gray-100 rounded-full"
                    )
                    onClick={_ => {
                      setShowModal(._ => PDP_Normal_Modals_Buyer.Show(ContentGuide))
                    }}>
                    {`필수 표기정보`->React.string}
                    <img src="/assets/arrow-right.svg" className=%twc("w-3 h-3 ml-1") />
                  </button>
                </div>
              </section>
              <section className=%twc("py-8")>
                <PDP_Normal_DeliveryGuide_Buyer.MO query=fragmentRefs />
              </section>
            </div>
            {salesDocument->Option.mapWithDefault(React.null, salesDocument' =>
              <section className=%twc("px-5")>
                <PDP_SalesDocument_Buyer.MO salesDocument=salesDocument' />
              </section>
            )}
            <section className=%twc("px-5 flex flex-col gap-5 py-8")>
              <h1 className=%twc("text-text-L1 text-base font-bold")>
                {`상세설명`->React.string}
              </h1>
              <PDP_Notice_Buyer.MO notice noticeStartAt noticeEndAt />
              <div className=%twc("w-full overflow-x-scroll")>
                <Editor.Viewer value=description />
              </div>
            </section>
          </section>
          <section className=%twc("px-5 py-8")>
            <div className=%twc("w-full aspect-[144/1001]")>
              <img
                src="https://public.sinsunhi.com/images/pdp_description/normal-guide.webp"
                className=%twc("w-full h-full object-cover")
                alt="pdp-delivery-guide-mo"
              />
            </div>
          </section>
          <Footer_Buyer.MO />
        </div>
      </div>
    </div>
    <PDP_Normal_Submit_Buyer.MO query=fragmentRefs selectedOptions setShowModal />
    <PDP_Normal_Modals_Buyer.MO
      show=showModal setShow=setShowModal selectedOptions setSelectedOptions query=fragmentRefs
    />
  </>
}
