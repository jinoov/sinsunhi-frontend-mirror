module Fragment = %relay(`
    fragment MyInfoProfileBuyer_Fragment on User {
      manager
      name
      uid
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
  @react.component
  let make = (~query) => {
    let {
      interestedItemCategories: categories,
      selfReportedBusinessSectors: sectors,
      selfReportedSalesBin: saleBin,
    } = Fragment.use(query)

    let displayCategories =
      categories->Option.getWithDefault([])->Array.map(({name}) => name)->Js.Array2.joinWith(",")

    let displaySectors =
      sectors->Option.getWithDefault([])->Array.map(({label}) => label)->Js.Array2.joinWith(",")

    let (isUpdateSectorAndSale, setUpdateSectorAndSale) = React.Uncurried.useState(_ => false)
    let (
      isUpdateInterestedCategories,
      setUpdateInterestedCategories,
    ) = React.Uncurried.useState(_ => false)

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
                    onClick={_ => setUpdateInterestedCategories(._ => true)}
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
                    onClick={_ => setUpdateSectorAndSale(._ => true)} className=%twc("shrink-0")>
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
                    onClick={_ => setUpdateSectorAndSale(._ => true)} className=%twc("shrink-0")>
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
        isOpen=isUpdateSectorAndSale onClose={_ => setUpdateSectorAndSale(._ => false)}
      />
      <Update_InterestedCategories_Buyer
        isOpen=isUpdateInterestedCategories
        onClose={_ => setUpdateInterestedCategories(._ => false)}
      />
    </>
  }
}

module Mobile = {
  @react.component
  let make = (~query) => {
    let {
      interestedItemCategories: categories,
      selfReportedBusinessSectors: sectors,
      selfReportedSalesBin: saleBin,
      manager,
      name: company,
      uid: email,
    } = Fragment.use(query)
    let (isUpdateCompanyOpen, setUpdateComponentOpen) = React.Uncurried.useState(_ => false)
    let (isUpdateManagerOpen, setUpdateManagerOpen) = React.Uncurried.useState(_ => false)

    let displayCategories =
      categories->Option.getWithDefault([])->Array.map(({name}) => name)->Js.Array2.joinWith(", ")

    let displaySectors =
      sectors->Option.getWithDefault([])->Array.map(({label}) => label)->Js.Array2.joinWith(", ")

    let (isUpdateSectorAndSale, setUpdateSectorAndSale) = React.Uncurried.useState(_ => false)
    let (
      isUpdateInterestedCategories,
      setUpdateInterestedCategories,
    ) = React.Uncurried.useState(_ => false)

    <>
      <div className=%twc("block w-full bg-white absolute top-0 pt-14 min-h-screen")>
        <div className=%twc("w-full max-w-3xl mx-auto bg-white h-full")>
          <section>
            <div className=%twc("py-10 flex flex-col items-center")>
              <MyInfo_ProfilePicture_Buyer
                size={MyInfo_ProfilePicture_Buyer.XLarge} content=company
              />
              <button
                className=%twc("mt-3 flex items-center")
                onClick={_ => setUpdateManagerOpen(._ => true)}>
                <span className=%twc("font-bold text-gray-800 text-lg")>
                  {manager->Option.getWithDefault("")->React.string}
                </span>
                <img src="/assets/write.svg" className=%twc("ml-1") width="16px" height="16px" />
              </button>
              <button
                className=%twc("mt-1 flex items-center")
                onClick={_ => setUpdateComponentOpen(._ => true)}>
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
                  onClick={_ => setUpdateInterestedCategories(._ => true)}>
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
                  onClick={_ => setUpdateSectorAndSale(._ => true)}>
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
                  onClick={_ => setUpdateSectorAndSale(._ => true)}>
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
            </ul>
          </section>
        </div>
      </div>
      <Update_SectorAndSale_Buyer
        isOpen=isUpdateSectorAndSale onClose={_ => setUpdateSectorAndSale(._ => false)}
      />
      <Update_InterestedCategories_Buyer
        isOpen=isUpdateInterestedCategories
        onClose={_ => setUpdateInterestedCategories(._ => false)}
      />
      <Update_CompanyName_Buyer
        isOpen={isUpdateCompanyOpen}
        onClose={_ => setUpdateComponentOpen(._ => false)}
        key={company}
        defaultValue={company}
      />
      <Update_Manager_Buyer
        isOpen={isUpdateManagerOpen}
        onClose={_ => setUpdateManagerOpen(._ => false)}
        key=?{manager}
        defaultValue=?{manager}
      />
    </>
  }
}