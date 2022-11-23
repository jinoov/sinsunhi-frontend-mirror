module Content = {
  module SubPage = {
    type t = [
      | #like
      | #recent
    ]

    let fromUrlParameter = urlParameter => {
      switch urlParameter {
      | "like" => #like
      | "recent" => #recent
      | _ => #like
      }
    }
  }
  module PC = {
    @react.component
    let make = () => {
      let router = Next.Router.useRouter()
      let subPage = router.query->Js.Dict.get("selected")->Option.map(SubPage.fromUrlParameter)
      let isCsr = CustomHooks.useCsr()

      <div className=%twc("w-full max-w-[1920px] bg-[#FAFBFC] mx-auto")>
        <div className=%twc(" flex max-w-[1920px] mx-auto")>
          {switch isCsr {
          | true =>
            <>
              <PC_Saved_Products_Sidebar />
              {switch subPage {
              | Some(#like) => <Like_List.PC />
              | Some(#recent) => <Recent_View_List.PC />
              | None => React.null
              }}
            </>

          | false => React.null
          }}
        </div>
      </div>
    }
  }
  module MO = {
    module Query = %relay(`
        query SavedProducts_Query {
          viewer {
            likedProductCount
            viewedProductCount
          }
        }
      `)
    module Tab = {
      module Item = {
        @react.component
        let make = (~title, ~type_: SubPage.t, ~selected, ~count) => {
          <Next.Link href={`/saved-products?selected=${(type_ :> string)}`}>
            <div className=%twc("px-5 flex flex-col flex-1 justify-center items-center")>
              <div
                className={Cn.make([
                  %twc("inline-flex  flex-1 gap-1 items-center justify-center"),
                  selected ? %twc("text-gray-800") : %twc("text-gray-300"),
                ])}>
                <span className=%twc("font-bold text-base leading-6")> {title->React.string} </span>
                <span
                  className=%twc(
                    "text-xs font-bold leading-3 px-1.5 py-0.5 rounded-xl bg-slate-100 h-4"
                  )>
                  {`${count->Option.mapWithDefault("", Int.toString)}`->React.string}
                </span>
              </div>
              <div
                className={Cn.make([
                  %twc("mx-4 h-[2px] rounded-full w-full"),
                  selected ? %twc("bg-gray-800") : %twc("bg-transparent"),
                ])}
              />
            </div>
          </Next.Link>
        }
      }

      module Container = {
        @react.component
        let make = () => {
          let router = Next.Router.useRouter()
          let currentSubPage = router.query->Js.Dict.get("selected")

          let {viewer} = Query.use(~variables=(), ~fetchPolicy=NetworkOnly, ())

          <>
            <div
              className=%twc(
                "w-full flex fixed left-0 bg-white h-14 border-b-[1px] border-gray-150 z-10"
              )>
              <Item
                title="찜한 상품"
                type_=#like
                selected={currentSubPage == Some((#like: SubPage.t :> string))}
                count={viewer->Option.map(viewer' => viewer'.likedProductCount)}
              />
              <Item
                title="최근 본 상품"
                type_=#recent
                selected={currentSubPage == Some((#recent: SubPage.t :> string))}
                count={viewer->Option.map(viewer' => viewer'.viewedProductCount)}
              />
            </div>
            <div className=%twc("h-14 w-full bg-white") />
          </>
        }
      }

      @react.component
      let make = () => {
        let (isCsr, setIsCsr) = React.Uncurried.useState(_ => false)
        React.useEffect0(_ => {
          setIsCsr(._ => true)
          None
        })
        switch isCsr {
        | true => <Container />
        | false => React.null
        }
      }
    }

    @react.component
    let make = () => {
      let router = Next.Router.useRouter()
      let subPage = router.query->Js.Dict.get("selected")->Option.map(SubPage.fromUrlParameter)
      <div className=%twc("w-full h-full overflow-y-hidden")>
        <Tab />
        {switch subPage {
        | Some(#like) => <Like_List.MO />
        | Some(#recent) => <Recent_View_List.MO />
        | None => React.null
        }}
      </div>
    }
  }
}

type props = {
  deviceType: DeviceDetect.deviceType,
  gnbBanners: array<GnbBannerListBuyerQuery_graphql.Types.response_gnbBanners>,
  displayCategories: array<
    ShopCategorySelectBuyerQuery_graphql.Types.response_rootDisplayCategories,
  >,
}
type params
type previewData

let default = ({deviceType}) => {
  let router = Next.Router.useRouter()

  {
    switch deviceType {
    | DeviceDetect.PC =>
      <div className=%twc("w-full min-h-screen flex flex-col bg-[#F0F2F5]")>
        <Authorization.Buyer title={`신선하이`} ssrFallback={<PC_Saved_Products.Skeleton />}>
          <RescriptReactErrorBoundary
            fallback={_ =>
              <div> {`계정정보를 가져오는데 실패했습니다`->React.string} </div>}>
            <React.Suspense fallback={<PC_Saved_Products.Skeleton />}>
              {<>
                <React.Suspense fallback={<PC_Header.Buyer.Placeholder />}>
                  <PC_Header.Buyer />
                </React.Suspense>
                <Content.PC />
              </>}
            </React.Suspense>
          </RescriptReactErrorBoundary>
        </Authorization.Buyer>
        <Footer_Buyer.PC />
      </div>
    | DeviceDetect.Unknown
    | DeviceDetect.Mobile =>
      <>
        <Header_Buyer.Mobile key=router.asPath />
        <Authorization.Buyer
          title={`신선하이`} ssrFallback={<MyInfo_Skeleton_Buyer.Mobile.Main />}>
          <RescriptReactErrorBoundary
            fallback={_ =>
              <div> {`계정정보를 가져오는데 실패했습니다`->React.string} </div>}>
            <React.Suspense fallback={React.null}>
              <Content.MO />
            </React.Suspense>
          </RescriptReactErrorBoundary>
        </Authorization.Buyer>
        <Bottom_Navbar deviceType />
      </>
    }
  }
}

let getServerSideProps = (ctx: Next.GetServerSideProps.context<props, params, previewData>) => {
  let deviceType = DeviceDetect.detectDeviceFromCtx2(ctx.req)

  let gnb = () =>
    GnbBannerList_Buyer.Query.fetchPromised(
      ~environment=RelayEnv.envSinsunMarket,
      ~variables=(),
      (),
    )
  let displayCategories = () =>
    ShopCategorySelect_Buyer.Query.fetchPromised(
      ~environment=RelayEnv.envSinsunMarket,
      ~variables={onlyDisplayable: Some(true), types: Some([#NORMAL])},
      (),
    )

  Js.Promise.all2((gnb(), displayCategories()))
  |> Js.Promise.then_(((
    gnb: GnbBannerListBuyerQuery_graphql.Types.response,
    displayCategories: ShopCategorySelectBuyerQuery_graphql.Types.response,
  )) => {
    Js.Promise.resolve({
      "props": {
        "deviceType": deviceType,
        "gnbBanners": gnb.gnbBanners,
        "displayCategories": displayCategories.rootDisplayCategories,
      },
    })
  })
  |> Js.Promise.catch(err => {
    Js.log2(`에러 gnb preload`, err)
    Js.Promise.resolve({
      "props": {
        "deviceType": deviceType,
        "gnbBanners": [],
        "displayCategories": [],
      },
    })
  })
}
