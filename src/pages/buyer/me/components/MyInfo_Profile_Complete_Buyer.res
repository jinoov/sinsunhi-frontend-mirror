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
  type modal = SectorAndSale | Categories | BizNumber | Manager

  @react.component
  let make = (~query) => {
    let (openModal, setOpenModal) = React.Uncurried.useState(_ => None)

    let items = useCards(
      query,
      ~sectorsOnclick={_ => setOpenModal(._ => Some(SectorAndSale))},
      ~salesOnClick={_ => setOpenModal(._ => Some(SectorAndSale))},
      ~categoriesOnClick={_ => setOpenModal(._ => Some(Categories))},
      ~bizOnClick={_ => setOpenModal(._ => Some(BizNumber))},
      ~managerOnClick={_ => setOpenModal(._ => Some(Manager))},
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
          isOpen={openModal == Some(SectorAndSale)} onClose={_ => setOpenModal(._ => None)}
        />
        <Update_InterestedCategories_Buyer
          isOpen={openModal == Some(Categories)} onClose={_ => setOpenModal(._ => None)}
        />
        <Update_BusinessNumber_Buyer
          isOpen={openModal == Some(BizNumber)} onClose={_ => setOpenModal(._ => None)}
        />
        <Update_Manager_Buyer
          isOpen={openModal == Some(Manager)} onClose={_ => setOpenModal(._ => None)}
        />
      </div>
    }
  }
}

module Mobile = {
  type modal = SectorAndSale | Categories | BizNumber | Manager

  let toFragment = modal =>
    switch modal {
    | Manager => "#manager"
    | BizNumber => "#biz-number"
    | SectorAndSale => "#sector"
    | Categories => "#categories"
    }

  @react.component
  let make = (~query) => {
    let router = Next.Router.useRouter()
    let (openModal, setOpenModal) = React.Uncurried.useState(_ => None)

    // only for mobile
    // related PR: #860 모달, 드로워에 대한 뒤로가기 처리 방법을 찾는 시도.
    // 모달이 열릴 때, fragment 를 추가하고 뒤로가기 하여 모달이 닫히게 한다.
    let open_ = (~modal: modal) => {
      if !(router.asPath->Js.String2.includes(toFragment(modal))) {
        router->Next.Router.push(`${router.asPath}${toFragment(modal)}`)
      }
      setOpenModal(._ => Some(modal))
    }

    let items = useCards(
      query,
      ~sectorsOnclick={_ => open_(~modal=SectorAndSale)},
      ~salesOnClick={_ => open_(~modal=SectorAndSale)},
      ~categoriesOnClick={_ => open_(~modal=Categories)},
      ~bizOnClick={_ => open_(~modal=BizNumber)},
      ~managerOnClick={_ => open_(~modal=Manager)},
    )

    let cmpNum = 5 - items->Array.length

    // url에 fragment가 없으면 모달창 닫는다.
    // 모달 닫는 것을 직접 하지 않고 url이 변화할 때마다 side effect로 처리한다.
    React.useEffect1(() => {
      if !(router.asPath->Js.String2.includes("#")) && openModal->Option.isSome {
        setOpenModal(._ => None)
      }

      None
    }, [router.asPath])

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
          isOpen={openModal == Some(SectorAndSale)} onClose={_ => router->Next.Router.back}
        />
        <Update_InterestedCategories_Buyer
          isOpen={openModal == Some(Categories)} onClose={_ => router->Next.Router.back}
        />
        <Update_BusinessNumber_Buyer
          isOpen={openModal == Some(BizNumber)} onClose={_ => router->Next.Router.back}
        />
        <Update_Manager_Buyer
          isOpen={openModal == Some(Manager)} onClose={_ => router->Next.Router.back}
        />
      </>
    }
  }
}
