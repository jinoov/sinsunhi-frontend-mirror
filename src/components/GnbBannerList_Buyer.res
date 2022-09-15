module Query = %relay(`
  query GnbBannerListBuyerQuery {
    gnbBanners {
      id
      title
      landingUrl
      isNewTabPc
      isNewTabMobile
    }
  }
`)

@react.component
let make = (~gnbBanners: array<GnbBannerListBuyerQuery_graphql.Types.response_gnbBanners>) => {
  <div className=%twc("flex items-center py-3 text-lg text-gray-800 font-bold")>
    {gnbBanners
    ->Array.map(({id, title, landingUrl, isNewTabPc}) => {
      let target = isNewTabPc ? "_blank" : "_self"
      <Next.Link key={`gnb-banner-${id}`} href=landingUrl>
        <a target className=%twc("ml-4 cursor-pointer")> {title->React.string} </a>
      </Next.Link>
    })
    ->React.array}
  </div>
}
