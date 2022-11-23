module Query = %relay(`
  query GnbBannerListBuyerQuery {
    gnbBanners {
      id
      title
      landingUrl
      isNewTabPc
      isNewTabMobile
    }
    ...GnbBannerListBuyer_CategoryQuery
  }
`)

module OldItem = {
  @react.component
  let make = (~id, ~title, ~landingUrl, ~isNewTabPc) => {
    let target = isNewTabPc ? "_blank" : "_self"

    <Next.Link key={`gnb-banner-${id}`} href=landingUrl>
      <a target className=%twc("ml-4 cursor-pointer")> {title->React.string} </a>
    </Next.Link>
  }
}

module Item = {
  @react.component
  let make = (~title, ~landingUrl, ~selected, ~newTab=false) => {
    let (loaded, setLoaded) = React.Uncurried.useState(_ => false)
    let target = newTab ? "_blank" : "_self"

    React.useEffect0(_ => {
      setLoaded(._ => true)
      None
    })

    let className = cx([
      %twc(
        "flex justify-center items-center p-[14px] mr-1 cursor-pointer hover:bg-[#1F20240A] active:bg-[#1F202414]  h-14 rounded-2xl"
      ),
      selected ? %twc("font-bold hover:bg-[#1F20240A]") : "",
      loaded ? %twc("ease-in-out duration-200") : "",
    ])

    <Next.Link href=landingUrl passHref=true>
      <a target className> {title->React.string} </a>
    </Next.Link>
  }
}

module GnbCategoryButton = {
  module MainCategoryPopup = {
    module Fragment = %relay(`
      fragment GnbBannerListBuyer_CategoryQuery on Query
      @argumentDefinitions(onlyDisplayable: { type: "Boolean", defaultValue: true }) {
        mainDisplayCategories(onlyDisplayable: $onlyDisplayable) {
          id
          name
        }
      }
    `)

    module Item = {
      @react.component
      let make = (~name, ~id) => {
        let {useRouter, pushObj} = module(Next.Router)
        let router = useRouter()
        let (loaded, setLoaded) = React.Uncurried.useState(_ => false)

        let onClick = _ => {
          let currentSection = switch router.query->Js.Dict.get("tab") {
          | Some("quick") => #DELIVERY
          | Some("matching") => #MATCHING
          | _ => #ALL
          }

          router->pushObj({
            pathname: `/categories/${id}`,
            query: [
              ("sort", "POPULARITY_DESC"),
              ("section", currentSection->Product_FilterOption.Section.toUrlParameter),
            ]->Js.Dict.fromArray,
          })
        }

        React.useEffect0(_ => {
          setLoaded(._ => true)
          None
        })

        let className = cx([
          %twc(
            "flex h-[58px] px-4 items-center text-[17px] py-3 hover:bg-[#1F20240A] first-of-type:rounded-t-2xl last-of-type:rounded-b-2xl  active:bg-[#e7e7e9] w-full"
          ),
          loaded ? %twc("ease-in-out duration-200") : "",
        ])

        <button type_="button" onClick className> {name->React.string} </button>
      }
    }

    @react.component
    let make = (~query, ~className) => {
      let {mainDisplayCategories} = query->Fragment.use

      let isCsr = CustomHooks.useCsr()

      let style = cx([
        %twc(
          "w-[328px] rounded-2xl z-[1] light-level-1 absolute mt-4 bg-white border-[1px] border-[#F0F2F5] min-h-[240px] overflow-hidden hover:block hidden"
        ),
        className,
      ])

      switch isCsr {
      | true =>
        <div className=style>
          {mainDisplayCategories->Array.map(({id, name}) => <Item id name key=id />)->React.array}
        </div>
      | false => React.null
      }
    }
  }

  module Placeholder = {
    @react.component
    let make = () => {
      <div>
        <div
          className=%twc(
            "inline-flex relative items-center py-3 px-[14px] peer h-14 hover:bg-[#1F20240A] active:bg-[#e7e7e9] duration-200 ease-in-out rounded-2xl cursor-pointer hover:font-bold peer-hover:text-[#1F2024] peer-hover:font-bold"
          )>
          <IconHamburger width={"20px"} height="20px" className=%twc("mr-2") />
          <span> {`카테고리`->React.string} </span>
        </div>
      </div>
    }
  }

  @react.component
  let make = (~query) => {
    let (loaded, setLoaded) = React.Uncurried.useState(_ => false)
    React.useEffect0(_ => {
      setLoaded(._ => true)
      None
    })

    let className = cx([
      %twc(
        "inline-flex relative items-center py-3 px-[14px] peer h-14 hover:bg-[#1F20240A] active:bg-[#e7e7e9]  rounded-2xl cursor-pointer hover:font-bold peer-hover:text-[#1F2024] peer-hover:font-bold"
      ),
      loaded ? %twc("ease-in-out duration-200") : "",
    ])

    <div>
      <div className>
        <IconHamburger width={"20px"} height="20px" className=%twc("mr-2") />
        <span> {`카테고리`->React.string} </span>
      </div>
      <div className=%twc("w-[110px] absolute h-4 peer") />
      <MainCategoryPopup query className=%twc("peer-hover:block hidden peer") />
    </div>
  }
}

module Placeholder = {
  @react.component
  let make = () => {
    let router = Next.Router.useRouter()
    let currentPage = switch (router.pathname, router.query->Js.Dict.get("tab")) {
    | ("/", Some("matching")) => Some(#matching)
    | ("/", Some("quick")) => Some(#quick)
    | _ => None
    }

    <div className=%twc("flex items-center text-lg text-gray-800 bg-white pl-[46px] py-2 w-full")>
      <GnbCategoryButton.Placeholder />
      <div className=%twc("w-[1px] h-[18px] mx-[10px] bg-[#D9D9D9]") />
      <Item title="즉시구매" landingUrl={`/?tab=quick`} selected=false />
      <Item
        title="견적요청" landingUrl={`/?tab=matching`} selected={currentPage == Some(#matching)}
      />
      <Item
        title="서비스 소개"
        landingUrl={`https://farm-hub.imweb.me/691`}
        selected=false
        newTab=true
      />
    </div>
  }
}

@react.component
let make = () => {
  let router = Next.Router.useRouter()
  let {gnbBanners, fragmentRefs} = Query.use(~variables=(), ())

  let oldUI =
    <div className=%twc("flex items-center py-3 text-lg text-gray-800 font-bold")>
      {gnbBanners
      ->Array.map(({id, title, landingUrl, isNewTabPc}) =>
        <OldItem id title key=id landingUrl isNewTabPc />
      )
      ->React.array}
    </div>

  let currentPage = switch (router.pathname, router.query->Js.Dict.get("tab")) {
  | ("/", Some("matching")) => Some(#matching)
  | ("/", Some("quick")) => Some(#quick)
  | _ => None
  }

  <FeatureFlagWrapper featureFlag=#HOME_UI_UX fallback={oldUI}>
    <div className=%twc("flex items-center text-lg text-gray-800 bg-white pl-[46px] py-2 w-full")>
      <GnbCategoryButton query=fragmentRefs />
      <div className=%twc("w-[1px] h-[18px] mx-[10px] bg-[#D9D9D9]") />
      <Item
        title="즉시구매" landingUrl={`/?tab=quick`} selected={currentPage == Some(#quick)}
      />
      <Item
        title="견적요청" landingUrl={`/?tab=matching`} selected={currentPage == Some(#matching)}
      />
      <Item
        title="서비스 소개"
        landingUrl={`https://farm-hub.imweb.me/691`}
        selected=false
        newTab=true
      />
    </div>
  </FeatureFlagWrapper>
}
