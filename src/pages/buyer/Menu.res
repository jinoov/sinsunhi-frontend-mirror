module Sub = {
  @react.component
  let make = (
    ~parentId,
    ~displayCategories: array<
      ShopCategorySelectBuyerQuery_graphql.Types.response_rootDisplayCategories_children,
    >,
  ) => {
    <>
      <Next.Link href={`/categories/${parentId}?section=matching,delivery`}>
        <button
          className=%twc(
            "text-left px-5 py-3 bg-white flex justify-between items-center active:bg-bg-pressed-L2"
          )>
          <span className=%twc("font-bold")> {`전체보기`->React.string} </span>
          <IconArrow width="16" height="16" />
        </button>
      </Next.Link>
      {displayCategories
      ->Array.map(({id, name}) => {
        <Next.Link href={`/categories/${id}?section=matching,delivery`} key=id>
          <button
            className=%twc(
              "text-left px-5 py-3 bg-white flex justify-between items-center active:bg-bg-pressed-L2"
            )>
            {name->React.string}
            <IconArrow width="16" height="16" />
          </button>
        </Next.Link>
      })
      ->React.array}
    </>
  }
}

module GNBBannerList = {
  @react.component
  let make = (~gnbBanners: array<GnbBannerListBuyerQuery_graphql.Types.response_gnbBanners>) => {
    gnbBanners
    ->Array.map(({title, id, landingUrl, isNewTabMobile}) =>
      <Next.Link href={landingUrl} key=id>
        <a
          className=%twc("py-4 px-5 flex justify-between active:bg-bg-pressed-L2")
          target={isNewTabMobile ? "_blank" : ""}
          rel="noopener noreferer">
          <div> {title->React.string} </div>
          <IconArrow width="24" height="24" stroke="#B2B2B2" />
        </a>
      </Next.Link>
    )
    ->React.array
  }
}

module Container = {
  @react.component
  let make = (
    ~deviceType,
    ~gnbBanners: array<GnbBannerListBuyerQuery_graphql.Types.response_gnbBanners>,
    ~displayCategories: array<
      ShopCategorySelectBuyerQuery_graphql.Types.response_rootDisplayCategories,
    >,
  ) => {
    let router = Next.Router.useRouter()
    let defaultParentId = switch Next.Router.useRouter().query->Js.Dict.get("cid") {
    | cid if cid->Option.isSome => cid
    | _ => displayCategories->Array.get(0)->Option.map(({id}) => id)
    }

    let (parentId, setParentId) = React.Uncurried.useState(_ => defaultParentId)

    let clickedStyle = id => {
      switch parentId {
      | Some(parentId') => parentId' == id ? %twc("bg-white text-primary font-bold") : %twc("")
      | None => %twc("")
      }
    }

    let makeOnClick = (id, e) => {
      ReactEvents.interceptingHandler(_ => setParentId(._ => Some(id)), e)

      router->Next.Router.replaceObj({
        pathname: router.pathname,
        query: Js.Dict.fromArray([("cid", id)]),
      })
    }

    <>
      <div className={cx([%twc("w-full h-full  top-0 left-0 bg-gray-50 overflow-y-auto")])}>
        <div className=%twc("w-full max-w-3xl mx-auto bg-white min-h-full")>
          <div className=%twc("relative overflow-auto")>
            <Header_Buyer.Mobile />
            <div className=%twc("flex flex-col")>
              <div className=%twc("grid grid-cols-10 border-y min-h-[432px] text-[15px]")>
                <div className=%twc("col-span-4 flex flex-col bg-surface")>
                  <Next.Link href="/products">
                    <a
                      className={cx([
                        %twc(
                          "text-left px-5 py-3 border-b last:border-none active:bg-bg-pressed-L2"
                        ),
                        clickedStyle("buyer-products"),
                      ])}>
                      {`전체 상품`->React.string}
                    </a>
                  </Next.Link>
                  {displayCategories
                  ->Array.map(({id, name}) =>
                    <button
                      key=id
                      className={cx([
                        %twc(
                          "text-left px-5 py-3 border-b last:border-none active:bg-bg-pressed-L2"
                        ),
                        clickedStyle(id),
                      ])}
                      onClick={makeOnClick(id)}>
                      {name->React.string}
                    </button>
                  )
                  ->React.array}
                </div>
                <div className=%twc("col-span-6 flex flex-col border-none")>
                  {parentId->Option.mapWithDefault(React.null, parentId' => {
                    <Sub
                      parentId=parentId'
                      displayCategories={displayCategories
                      ->Array.keep(displayCategory => displayCategory.id == parentId')
                      ->Garter.Array.first
                      ->Option.mapWithDefault([], displayCategory => displayCategory.children)}
                    />
                  })}
                </div>
              </div>
              <FeatureFlagWrapper featureFlag=#HOME_UI_UX fallback={<GNBBannerList gnbBanners />}>
                <Next.Link href="https://farm-hub.imweb.me/691">
                  <a className=%twc("py-4 px-5 flex justify-between active:bg-bg-pressed-L2") target="_blank">
                    <div> {"서비스 소개"->React.string} </div>
                    <IconArrow width="24" height="24" />
                  </a>
                </Next.Link>
              </FeatureFlagWrapper>
            </div>
          </div>
        </div>
      </div>
      <Bottom_Navbar deviceType />
    </>
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

let default = (~props) => {
  let {deviceType, gnbBanners, displayCategories} = props
  <Container deviceType gnbBanners displayCategories />
}

let getServerSideProps = (ctx: Next.GetServerSideProps.context<props, params, previewData>) => {
  let deviceType = DeviceDetect.detectDeviceFromCtx2(ctx.req)
  GnbBannerList_Buyer.Query.fetchPromised(~environment=RelayEnv.envSinsunMarket, ~variables=(), ())
  |> Js.Promise.then_((gnbBannersRes: GnbBannerListBuyerQuery_graphql.Types.response) => {
    ShopCategorySelect_Buyer.Query.fetchPromised(
      ~environment=RelayEnv.envSinsunMarket,
      ~variables={onlyDisplayable: Some(true), types: Some([#NORMAL])},
      (),
    ) |> Js.Promise.then_((
      displayCategoriesRes: ShopCategorySelectBuyerQuery_graphql.Types.response,
    ) => {
      Js.Promise.resolve({
        "props": {
          "deviceType": deviceType,
          "gnbBanners": gnbBannersRes.gnbBanners,
          "displayCategories": displayCategoriesRes.rootDisplayCategories,
        },
      })
    })
  })
  |> Js.Promise.catch(err => {
    Js.log2("에러 Category_getServerSideProps", err)
    Js.Promise.resolve({
      "props": {
        "deviceType": deviceType,
        "gnbBanners": [],
        "displayCategories": [],
      },
    })
  })
}
