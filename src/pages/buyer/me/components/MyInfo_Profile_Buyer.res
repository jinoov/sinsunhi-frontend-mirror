module Fragment = %relay(`
    fragment MyInfoProfileBuyer_Fragment on User {
      manager
      name
      uid
      shopUrl
      interestedItemCategories {
        name
      }
      selfReportedBusinessSectors {
        label
        value
      }
      selfReportedSalesBin {
        label
        value
      }
    }
`)
@module("../../../../../public/assets/write.svg")
external writeIcon: string = "default"
module PC = {
  type modal = SectorAndSale | Categories | ShopUrl

  @react.component
  let make = (~query) => {
    let (openModal, setOpenModal) = React.Uncurried.useState(_ => None)

    let {
      interestedItemCategories: categories,
      selfReportedBusinessSectors: sectors,
      selfReportedSalesBin: saleBin,
      shopUrl,
    } = Fragment.use(query)

    let displayCategories =
      categories->Option.getWithDefault([])->Array.map(({name}) => name)->Js.Array2.joinWith(",")

    let displaySectors =
      sectors->Option.getWithDefault([])->Array.map(({label}) => label)->Js.Array2.joinWith(",")

    let oldUI =
      <>
        <MyInfo_Layout_Buyer query>
          <div className=%twc("p-7 bg-white ml-4 w-full")>
            <div className=%twc("font-bold text-2xl")> {`프로필정보`->React.string} </div>
            <div className=%twc("py-7 flex flex-col")>
              <div className=%twc("mb-2")>
                <div className=%twc("flex py-5")>
                  <div className=%twc("min-w-[168px] w-1/6 font-bold")>
                    {`관심품목`->React.string}
                  </div>
                  <div className=%twc("flex items-center")>
                    {displayCategories->React.string}
                    <button
                      onClick={_ => setOpenModal(._ => Some(Categories))}
                      className=%twc("shrink-0")>
                      <img
                        src="/assets/write.svg" className=%twc("ml-2") width="16px" height="16px"
                      />
                    </button>
                  </div>
                </div>
                <div className=%twc("flex py-5")>
                  <div className=%twc("min-w-[168px] w-1/6 font-bold")>
                    {`업종 정보`->React.string}
                  </div>
                  <div className=%twc("flex items-center")>
                    {displaySectors->React.string}
                    <button
                      onClick={_ => setOpenModal(._ => Some(SectorAndSale))}
                      className=%twc("shrink-0")>
                      <img
                        src="/assets/write.svg" className=%twc("ml-2") width="16px" height="16px"
                      />
                    </button>
                  </div>
                </div>
                <div className=%twc("flex py-5")>
                  <div className=%twc("min-w-[168px] w-1/6 font-bold")>
                    {`연매출 정보`->React.string}
                  </div>
                  <div className=%twc("flex items-center")>
                    {saleBin->Option.mapWithDefault("", ({label}) => label)->React.string}
                    <button
                      onClick={_ => setOpenModal(._ => Some(SectorAndSale))}
                      className=%twc("shrink-0")>
                      <img
                        src="/assets/write.svg" className=%twc("ml-2") width="16px" height="16px"
                      />
                    </button>
                  </div>
                </div>
                <div className=%twc("flex py-5")>
                  <div className=%twc("min-w-[168px] w-1/6 font-bold")>
                    {`쇼핑몰 URL`->React.string}
                  </div>
                  <div className=%twc("flex items-center")>
                    {shopUrl->Option.getWithDefault("")->React.string}
                    <button
                      onClick={_ => setOpenModal(._ => Some(ShopUrl))} className=%twc("shrink-0")>
                      <img
                        src="/assets/write.svg" className=%twc("ml-2") width="16px" height="16px"
                      />
                    </button>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </MyInfo_Layout_Buyer>
        <Update_SectorAndSale_Buyer
          isOpen={openModal == Some(SectorAndSale)} onClose={_ => setOpenModal(._ => None)}
        />
        <Update_InterestedCategories_Buyer
          isOpen={openModal == Some(Categories)} onClose={_ => setOpenModal(._ => None)}
        />
        <Update_ShopURL_Buyer
          isOpen={openModal == Some(ShopUrl)}
          onClose={_ => setOpenModal(._ => None)}
          key=?{shopUrl}
          defaultValue=?{shopUrl}
        />
      </>

    <FeatureFlagWrapper featureFlag=#HOME_UI_UX fallback=oldUI>
      {<>
        <MyInfo_Layout_Buyer query>
          <div
            className=%twc(
              "py-10 px-[50px] bg-white w-full rounded-sm shadow-[0px_10px_40px_10px_rgba(0,0,0,0.03)]"
            )>
            <div className=%twc("font-bold text-[26px]")> {`프로필정보`->React.string} </div>
            <div className=%twc("py-7 flex flex-col")>
              <div className=%twc("mb-2")>
                <div className=%twc("flex py-5")>
                  <div className=%twc("min-w-[168px] w-1/6 font-bold")>
                    {`관심품목`->React.string}
                  </div>
                  <div className=%twc("flex items-center")>
                    {displayCategories->React.string}
                    <button
                      onClick={_ => setOpenModal(._ => Some(Categories))}
                      className=%twc("shrink-0")>
                      <img
                        src="/assets/write.svg" className=%twc("ml-2") width="16px" height="16px"
                      />
                    </button>
                  </div>
                </div>
                <div className=%twc("flex py-5")>
                  <div className=%twc("min-w-[168px] w-1/6 font-bold")>
                    {`업종 정보`->React.string}
                  </div>
                  <div className=%twc("flex items-center")>
                    {displaySectors->React.string}
                    <button
                      onClick={_ => setOpenModal(._ => Some(SectorAndSale))}
                      className=%twc("shrink-0")>
                      <img
                        src="/assets/write.svg" className=%twc("ml-2") width="16px" height="16px"
                      />
                    </button>
                  </div>
                </div>
                <div className=%twc("flex py-5")>
                  <div className=%twc("min-w-[168px] w-1/6 font-bold")>
                    {`연매출 정보`->React.string}
                  </div>
                  <div className=%twc("flex items-center")>
                    {saleBin->Option.mapWithDefault("", ({label}) => label)->React.string}
                    <button
                      onClick={_ => setOpenModal(._ => Some(SectorAndSale))}
                      className=%twc("shrink-0")>
                      <img
                        src="/assets/write.svg" className=%twc("ml-2") width="16px" height="16px"
                      />
                    </button>
                  </div>
                </div>
                <div className=%twc("flex py-5")>
                  <div className=%twc("min-w-[168px] w-1/6 font-bold")>
                    {`쇼핑몰 URL`->React.string}
                  </div>
                  <div className=%twc("flex items-center")>
                    {shopUrl->Option.getWithDefault("")->React.string}
                    <button
                      onClick={_ => setOpenModal(._ => Some(ShopUrl))} className=%twc("shrink-0")>
                      <img
                        src="/assets/write.svg" className=%twc("ml-2") width="16px" height="16px"
                      />
                    </button>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </MyInfo_Layout_Buyer>
        <Update_SectorAndSale_Buyer
          isOpen={openModal == Some(SectorAndSale)} onClose={_ => setOpenModal(._ => None)}
        />
        <Update_InterestedCategories_Buyer
          isOpen={openModal == Some(Categories)} onClose={_ => setOpenModal(._ => None)}
        />
        <Update_ShopURL_Buyer
          isOpen={openModal == Some(ShopUrl)}
          onClose={_ => setOpenModal(._ => None)}
          key=?{shopUrl}
          defaultValue=?{shopUrl}
        />
      </>}
    </FeatureFlagWrapper>
  }
}

module Mobile = {
  type modal = SectorAndSale | Categories | Company | Manager | ShopUrl

  let toFragment = modal =>
    switch modal {
    | Company => "#company"
    | Manager => "#manager"
    | SectorAndSale => "#sector"
    | Categories => "#categories"
    | ShopUrl => "#shopurl"
    }

  @react.component
  let make = (~query) => {
    let router = Next.Router.useRouter()
    let (openModal, setOpenModal) = React.Uncurried.useState(_ => None)

    let {
      interestedItemCategories: categories,
      selfReportedBusinessSectors: sectors,
      selfReportedSalesBin: saleBin,
      manager,
      name: company,
      uid: email,
      shopUrl,
    } = Fragment.use(query)

    let displayCategories =
      categories->Option.getWithDefault([])->Array.map(({name}) => name)->Js.Array2.joinWith(", ")

    let displaySectors =
      sectors->Option.getWithDefault([])->Array.map(({label}) => label)->Js.Array2.joinWith(", ")

    // only for mobile
    // related PR: #860 모달, 드로워에 대한 뒤로가기 처리 방법을 찾는 시도.
    // 모달이 열릴 때, fragment 를 추가하고 뒤로가기 하여 모달이 닫히게 한다.
    let open_ = (~modal: modal) => {
      if !(router.asPath->Js.String2.includes(toFragment(modal))) {
        router->Next.Router.push(`${router.asPath}${toFragment(modal)}`)
      }
      setOpenModal(._ => Some(modal))
    }

    // url에 fragment가 없으면 모달창 닫는다.
    // 모달 닫는 것을 직접 하지 않고 url이 변화할 때마다 side effect로 처리한다.
    React.useEffect1(() => {
      if !(router.asPath->Js.String2.includes("#")) && openModal->Option.isSome {
        setOpenModal(._ => None)
      }

      None
    }, [router.asPath])

    <>
      <div className=%twc("block w-full bg-white absolute top-0 pt-14 min-h-screen")>
        <div className=%twc("w-full max-w-3xl mx-auto bg-white h-full")>
          <section>
            <div className=%twc("py-10 flex flex-col items-center")>
              <MyInfo_ProfilePicture_Buyer
                size={MyInfo_ProfilePicture_Buyer.XLarge} content=company
              />
              <button className=%twc("mt-3 flex items-center") onClick={_ => open_(~modal=Manager)}>
                <span className=%twc("font-bold text-gray-800 text-lg")>
                  {manager->Option.getWithDefault("")->React.string}
                </span>
                <img src="/assets/write.svg" className=%twc("ml-1") width="16px" height="16px" />
              </button>
              <button className=%twc("mt-1 flex items-center") onClick={_ => open_(~modal=Company)}>
                <span className=%twc("text-gray-800")> {company->React.string} </span>
                <img src="/assets/write.svg" className=%twc("ml-1") width="16px" height="16px" />
              </button>
              <div className=%twc("")>
                <span className=%twc("text-gray-600 text-sm")> {email->React.string} </span>
              </div>
            </div>
            <div className=%twc("h-3 bg-gray-100") />
            <ul>
              <li>
                <button
                  className=%twc("w-full py-[18px] px-4 flex items-center justify-between")
                  onClick={_ => open_(~modal=Categories)}>
                  <div className=%twc("flex items-center w-[calc(100%-16px)]")>
                    <div className=%twc("shrink-0")>
                      <span className=%twc("font-bold")> {`관심품목`->React.string} </span>
                    </div>
                    <div className=%twc("text-gray-600 text-sm shrink ml-2 truncate")>
                      {displayCategories->React.string}
                    </div>
                  </div>
                  <IconArrow height="16" width="16" fill="#B2B2B2" />
                </button>
              </li>
              <li>
                <button
                  className=%twc("w-full py-[18px] px-4 flex items-center justify-between")
                  onClick={_ => open_(~modal=SectorAndSale)}>
                  <div className=%twc("flex items-center w-[calc(100%-16px)]")>
                    <div className=%twc("shrink-0")>
                      <span className=%twc("font-bold")> {`업종 정보`->React.string} </span>
                    </div>
                    <div className=%twc("text-gray-600 text-sm shrink mx-2 truncate")>
                      {displaySectors->React.string}
                    </div>
                  </div>
                  <IconArrow height="16" width="16" fill="#B2B2B2" />
                </button>
              </li>
              <li>
                <button
                  className=%twc("w-full py-[18px] px-4 flex items-center justify-between")
                  onClick={_ => open_(~modal=SectorAndSale)}>
                  <div className=%twc("flex items-center")>
                    <div className=%twc("shrink-0")>
                      <span className=%twc("font-bold")> {`연매출 정보`->React.string} </span>
                    </div>
                    <div className=%twc("text-gray-600 text-sm shrink mx-2 truncate")>
                      {saleBin->Option.mapWithDefault("", ({label}) => label)->React.string}
                    </div>
                  </div>
                  <IconArrow height="16" width="16" fill="#B2B2B2" />
                </button>
              </li>
              <li>
                <button
                  className=%twc("w-full py-[18px] px-4 flex items-center justify-between")
                  onClick={_ => open_(~modal=ShopUrl)}>
                  <div className=%twc("flex items-center")>
                    <div className=%twc("shrink-0")>
                      <span className=%twc("font-bold")> {`쇼핑몰URL`->React.string} </span>
                    </div>
                    <div className=%twc("text-gray-600 text-sm shrink mx-2 truncate")>
                      {shopUrl->Option.getWithDefault("")->React.string}
                    </div>
                  </div>
                  <IconArrow height="16" width="16" fill="#B2B2B2" />
                </button>
              </li>
            </ul>
          </section>
        </div>
      </div>
      <Update_SectorAndSale_Buyer
        isOpen={openModal == Some(SectorAndSale)} onClose={_ => router->Next.Router.back}
      />
      <Update_InterestedCategories_Buyer
        isOpen={openModal == Some(Categories)} onClose={_ => router->Next.Router.back}
      />
      <Update_CompanyName_Buyer
        isOpen={openModal == Some(Company)}
        onClose={_ => router->Next.Router.back}
        key={company}
        defaultValue={company}
      />
      <Update_Manager_Buyer
        isOpen={openModal == Some(Manager)}
        onClose={_ => router->Next.Router.back}
        key=?{manager}
        defaultValue=?{manager}
      />
      <Update_ShopURL_Buyer
        isOpen={openModal == Some(ShopUrl)}
        onClose={_ => router->Next.Router.back}
        key=?{shopUrl}
        defaultValue=?{shopUrl}
      />
    </>
  }
}
