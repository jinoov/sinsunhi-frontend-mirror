module Fragment = %relay(`
  fragment PDPNormalBuyerPCFragment on Product {
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
              <section className=%twc("pb-4")>
                <PDP_Normal_Title_Buyer.PC displayName price isSoldout={status == #SOLDOUT} />
              </section>
              <section className=%twc("border border-gray-200 rounded-xl divide-y")>
                <div className=%twc("px-6 py-8 divide-y")>
                  <PDP_Normal_Details_Buyer.PC query=fragmentRefs />
                  <div className=%twc("flex flex-col gap-6 py-6")>
                    <PDP_Normal_DeliveryGuide_Buyer.PC query=fragmentRefs />
                    <PDP_Normal_SelectOption_Buyer.PC
                      query=fragmentRefs setSelectedOptions setShowModal
                    />
                  </div>
                  {switch selectedOptions->Map.String.toArray {
                  | [] => React.null
                  | nonEmptyOptions =>
                    <section className=%twc("pt-1")>
                      {nonEmptyOptions
                      ->Array.map(((id, quantity)) => {
                        <React.Suspense key=id fallback={React.null}>
                          <PDP_Normal_SelectedOptionItem_Buyer.PC
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
                  }}
                </div>
                <PDP_Normal_TotalPrice_Buyer.PC query=fragmentRefs selectedOptions />
              </section>
              <section className=%twc("w-full mt-4")>
                <PDP_Normal_Submit_Buyer.PC query=fragmentRefs selectedOptions setShowModal />
              </section>
            </div>
          </section>
          <section className=%twc("pt-16")>
            <div>
              <span className=%twc("text-2xl font-bold text-gray-800")>
                {`필수표기 정보`->React.string}
              </span>
              <div className=%twc("mt-7")>
                <PDP_Normal_ContentsGuide_Buyer.PC query=fragmentRefs />
              </div>
            </div>
            <div className=%twc("pt-16")>
              <span className=%twc("text-2xl font-bold text-gray-800")>
                {`상세 설명`->React.string}
              </span>
              <PDP_Notice_Buyer.PC notice noticeStartAt noticeEndAt />
              <div className=%twc("py-16")>
                <Editor.Viewer value={description} />
              </div>
            </div>
          </section>
          <section className=%twc("w-full py-16 flex justify-center")>
            <div className=%twc("w-full max-w-[600px] aspect-[144/1001]")>
              <img
                src="https://public.sinsunhi.com/images/pdp_description/normal-guide.webp"
                className=%twc("w-full h-full object-cover")
                alt="pdp-delivery-guide-mo"
              />
            </div>
          </section>
        </div>
      </div>
      <Footer_Buyer.PC />
    </div>
    <PDP_Normal_Modals_Buyer.PC
      query=fragmentRefs show=showModal setShow=setShowModal selectedOptions setSelectedOptions
    />
  </>
}
