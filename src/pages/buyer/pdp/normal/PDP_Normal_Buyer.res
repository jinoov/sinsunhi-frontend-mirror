/*
  1. 컴포넌트 위치
  PDP > 일반 상품
  
  2. 역할
  일반 상품의 상품 정보를 표현합니다.
*/

module Fragment = %relay(`
  fragment PDPNormalBuyerFragment on Product {
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

module PC = {
  @react.component
  let make = (~query, ~gnbBanners, ~displayCategories) => {
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
        <Header_Buyer.PC key=router.asPath gnbBanners displayCategories />
        <div className=%twc("w-[1280px] mx-auto min-h-full")>
          <div className=%twc("w-full pt-16 px-5 divide-y")>
            <section className=%twc("w-full flex pb-12 gap-20")>
              <div>
                <PDP_Image_Buyer.PC src=image.thumb1920x1920 />
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
                                setSelectedOptions(.prev =>
                                  prev->Map.String.set(optionId, quantity)
                                )
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
              <div className=%twc("w-full max-w-[600px] aspect-[209/1361]")>
                <img
                  src="https://public.sinsunhi.com/images/20220616/f15dcb82-7b3e-482d-a32a-ab56791617da/%E1%84%89%E1%85%A1%E1%86%BC%E1%84%89%E1%85%A6%20CS%E1%84%80%E1%85%A9%E1%86%BC%E1%84%90%E1%85%A9%E1%86%BC%E1%84%8B%E1%85%A7%E1%86%BC%E1%84%8B%E1%85%A7%E1%86%A8%20%E1%84%8E%E1%85%AC%E1%84%8E%E1%85%AC%E1%84%8C%E1%85%A9%E1%86%BC.jpg"
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
}

module MO = {
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
            <PDP_Header_Buyer key=router.asPath />
            <PDP_Image_Buyer.MO src=image.thumb1000x1000 />
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
                                setSelectedOptions(.prev =>
                                  prev->Map.String.set(optionId, quantity)
                                )
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
              <div className=%twc("w-full aspect-[209/1361]")>
                <img
                  src="https://public.sinsunhi.com/images/20220616/f15dcb82-7b3e-482d-a32a-ab56791617da/%E1%84%89%E1%85%A1%E1%86%BC%E1%84%89%E1%85%A6%20CS%E1%84%80%E1%85%A9%E1%86%BC%E1%84%90%E1%85%A9%E1%86%BC%E1%84%8B%E1%85%A7%E1%86%BC%E1%84%8B%E1%85%A7%E1%86%A8%20%E1%84%8E%E1%85%AC%E1%84%8E%E1%85%AC%E1%84%8C%E1%85%A9%E1%86%BC.jpg"
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
}

@react.component
let make = (~deviceType, ~query, ~gnbBanners, ~displayCategories) => {
  switch deviceType {
  | DeviceDetect.Unknown => React.null
  | DeviceDetect.PC => <PC query gnbBanners displayCategories />
  | DeviceDetect.Mobile => <MO query />
  }
}
