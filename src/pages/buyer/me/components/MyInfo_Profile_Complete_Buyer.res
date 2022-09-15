module Fragment = %relay(`
  fragment MyInfoProfileCompleteBuyer_Fragment on User {
    sectors: selfReportedBusinessSectors {
      id
    }
    sales: selfReportedSalesBin {
      id
    }
    verifications {
      valid: isValidBusinessRegistrationNumberByViewer
    }
    interestedItemCategories {
      name
    }
    manager
  }
`)

let useCards = (
  query,
  ~sectorsOnclick,
  ~salesOnClick,
  ~categoriesOnClick,
  ~bizOnClick,
  ~managerOnClick,
) => {
  let {sectors, sales, interestedItemCategories: categories, verifications, manager} = Fragment.use(
    query,
  )

  let items =
    [
      sectors->Option.getWithDefault([])->Garter.Array.isEmpty
        ? Some(<MyInfo_ProfileInfo_Promote_Card.Sectors onClick={sectorsOnclick} />)
        : None,
      sales->Option.isSome
        ? None
        : Some(<MyInfo_ProfileInfo_Promote_Card.SalesBin onClick={salesOnClick} />),
      categories->Option.getWithDefault([])->Garter.Array.isEmpty
        ? Some(<MyInfo_ProfileInfo_Promote_Card.InterestCategories onClick={categoriesOnClick} />)
        : None,
      switch verifications->Option.map(({valid}) => valid) {
      | None
      | Some(false) =>
        Some(<MyInfo_ProfileInfo_Promote_Card.BusinessNumber onClick={bizOnClick} />)
      | _ => None
      },
      manager->Option.getWithDefault("") == ""
        ? Some(<MyInfo_ProfileInfo_Promote_Card.Manager onClick={managerOnClick} />)
        : None,
    ]
    ->Array.keep(Option.isSome)
    ->Helper.Option.sequence
    ->Option.getWithDefault([])

  items
}

module PC = {
  @react.component
  let make = (~query) => {
    let (isSalesAndSectorOpen, setSalesAndSectorOpen) = React.Uncurried.useState(_ => false)
    let (isCategoriesOpen, setCategoriesOpen) = React.Uncurried.useState(_ => false)
    let (isBizOpen, setBizOpen) = React.Uncurried.useState(_ => false)
    let (isManagerOpen, setManagerOpen) = React.Uncurried.useState(_ => false)

    let items = useCards(
      query,
      ~sectorsOnclick={_ => setSalesAndSectorOpen(._ => true)},
      ~salesOnClick={_ => setSalesAndSectorOpen(._ => true)},
      ~categoriesOnClick={_ => setCategoriesOpen(._ => true)},
      ~bizOnClick={_ => setBizOpen(._ => true)},
      ~managerOnClick={_ => setManagerOpen(._ => true)},
    )

    let cmpNum = 5 - items->Array.length

    switch items->Garter.Array.isEmpty {
    | true => React.null
    | false =>
      <div className=%twc("w-full mt-4 bg-white h-full")>
        <div className=%twc("pt-8 p-7")>
          <div className=%twc("mb-5")>
            <span className=%twc("font-bold text-2xl")>
              {`프로필 완성하기`->React.string}
            </span>
            <span className=%twc("ml-1 text-sm text-primary")>
              {`${cmpNum->Int.toString}/5`->React.string}
            </span>
          </div>
          <div className=%twc("mb-4 grid grid-cols-2 gap-2")>
            {items
            ->Array.map(i => {
              <div key={UniqueId.make(~prefix="profile", ())}> {i} </div>
            })
            ->React.array}
          </div>
        </div>
        <Update_SectorAndSale_Buyer
          isOpen={isSalesAndSectorOpen} onClose={_ => setSalesAndSectorOpen(._ => false)}
        />
        <Update_InterestedCategories_Buyer
          isOpen={isCategoriesOpen} onClose={_ => setCategoriesOpen(._ => false)}
        />
        <Update_BusinessNumber_Buyer isOpen={isBizOpen} onClose={_ => setBizOpen(._ => false)} />
        <Update_Manager_Buyer isOpen={isManagerOpen} onClose={_ => setManagerOpen(._ => false)} />
      </div>
    }
  }
}

module Mobile = {
  @react.component
  let make = (~query) => {
    let (isSalesAndSectorOpen, setSalesAndSectorOpen) = React.Uncurried.useState(_ => false)
    let (isCategoriesOpen, setCategoriesOpen) = React.Uncurried.useState(_ => false)
    let (isBizOpen, setBizOpen) = React.Uncurried.useState(_ => false)
    let (isManagerOpen, setManagerOpen) = React.Uncurried.useState(_ => false)

    let items = useCards(
      query,
      ~sectorsOnclick={_ => setSalesAndSectorOpen(._ => true)},
      ~salesOnClick={_ => setSalesAndSectorOpen(._ => true)},
      ~categoriesOnClick={_ => setCategoriesOpen(._ => true)},
      ~bizOnClick={_ => setBizOpen(._ => true)},
      ~managerOnClick={_ => setManagerOpen(._ => true)},
    )

    let cmpNum = 5 - items->Array.length

    switch items->Garter.Array.isEmpty {
    | true => React.null
    | false =>
      <>
        <div>
          <div className=%twc("mb-4")>
            <span className=%twc("font-bold text-lg")>
              {`프로필 완성하기`->React.string}
            </span>
            <span className=%twc("ml-1 text-sm text-primary")>
              {`${cmpNum->Int.toString}/5`->React.string}
            </span>
          </div>
          <div>
            {switch items->Array.length {
            | 0 | 1 =>
              items
              ->Array.map(i => {
                <div className=%twc("w-full") key={UniqueId.make(~prefix="profile", ())}> {i} </div>
              })
              ->React.array
            | _ =>
              <SlickSlider infinite=false slidesToShow=1 variableWidth=true>
                {items
                ->Array.map(i => {
                  <div className=%twc("pl-[5px]") key={UniqueId.make(~prefix="profile", ())}>
                    {i}
                  </div>
                })
                ->React.array}
              </SlickSlider>
            }}
          </div>
        </div>
        <Update_SectorAndSale_Buyer
          isOpen={isSalesAndSectorOpen} onClose={_ => setSalesAndSectorOpen(._ => false)}
        />
        <Update_InterestedCategories_Buyer
          isOpen={isCategoriesOpen} onClose={_ => setCategoriesOpen(._ => false)}
        />
        <Update_BusinessNumber_Buyer isOpen={isBizOpen} onClose={_ => setBizOpen(._ => false)} />
        <Update_Manager_Buyer isOpen={isManagerOpen} onClose={_ => setManagerOpen(._ => false)} />
      </>
    }
  }
}
