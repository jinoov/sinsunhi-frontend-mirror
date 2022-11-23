/*
 * 1. 컴포넌트 위치
 *    PLP
 *
 * 2. 역할
 *    전시카테고리(category-id)가 파라메터가 전달되거나, `/categories/[cid]`인 경우 특정 전시 카테고리 내 상품리스트,
      전시카테고리(category-id)가 파라메터가 전달되지 않고, `/categories/[cid]`로 접근하지 않은 경우 전체 상품
 *
 */

type props = {deviceType: DeviceDetect.deviceType}
type params
type previewData

let default = (~props) => {
  let {deviceType} = props
  let router = Next.Router.useRouter()
  let displayCategoryId = switch router.query->Js.Dict.get("cid") {
  | Some(_) as cid => cid
  | None => router.query->Js.Dict.get("category-id")
  }

  let isCsr = CustomHooks.useCsr()

  <>
    <Next.Head>
      <title> {`신선하이`->React.string} </title>
    </Next.Head>
    // {switch displayCategoryId {
    // // 전체 상품
    // | None => <PLP_All_Buyer deviceType />

    // // 특정 전시카테고리 내 상품
    // | Some(displayCategoryId') =>
    //   <PLP_DisplayCategory_Buyer deviceType displayCategoryId=displayCategoryId' />
    // }}
    // TEMP: 가격노출조건 개선 전까지, SSR disable, CSR Only
    {switch displayCategoryId {
    // 전체 상품
    | None =>
      <>
        <Next.Head>
          <title> {`신선하이 | 전체상품`->React.string} </title>
          <meta
            name="description"
            content={`농산물 소싱은 신선하이에서! | 신선하이에 있는 모든 상품을 만나보세요.`}
          />
        </Next.Head>
        <OpenGraph_Header
          title="신선하이 | 전체상품"
          description="신선하이에 있는 모든 상품을 만나보세요"
        />
        {switch isCsr {
        | false => <PLP_All_Buyer.Placeholder deviceType />
        | true => <PLP_All_Buyer deviceType />
        }}
      </>

    // 특정 전시카테고리 내 상품
    | Some(displayCategoryId') =>
      switch isCsr {
      | false => <PLP_DisplayCategory_Buyer.Placeholder deviceType />
      | true => <PLP_DisplayCategory_Buyer deviceType displayCategoryId=displayCategoryId' />
      }
    }}
    <Bottom_Navbar deviceType />
  </>
}

let getServerSideProps = (ctx: Next.GetServerSideProps.context<props, params, previewData>) => {
  open ServerSideHelper
  let environment = SinsunMarket(Env.graphqlApiUrl)->RelayEnv.environment
  let gnbAndCategoryQuery = environment->gnbAndCategory
  let features = environment->featureFlags

  let deviceType = DeviceDetect.detectDeviceFromCtx2(ctx.req)

  Promise.allSettled2((gnbAndCategoryQuery, features))->makeResultWithQuery(
    ~environment,
    ~extraProps={"deviceType": deviceType},
  )

  // TEMP: 가격노출조건 개선 전까지, SSR disable, CSR Only
  // {"props": environment->RelayEnv.createDehydrateProps()}->Js.Promise.resolve
  // let displayCategoryId = ctx.query->Js.Dict.get("category-id")

  // let resolveEnv = _ => {
  //   {"props": environment->RelayEnv.createDehydrateProps()}->Js.Promise.resolve
  // }

  // switch displayCategoryId {
  // // 전체상품 리스트 쿼리
  // | None =>
  //   let sort = {
  //     ctx.query
  //     ->Js.Dict.get("sort")
  //     ->Option.flatMap(ShopProductsSortSelect_Buyer.decodeSort)
  //     ->Option.getWithDefault(#UPDATED_DESC)
  //   }
  //   PLP_All_Buyer.Query.fetchPromised(
  //     ~environment,
  //     ~variables=PLP_All_Buyer.Query.makeVariables(~sort, ~count=20, ~onlyBuyable=true, ()),
  //     (),
  //   )
  //   |> Js.Promise.then_(resolveEnv)
  //   |> Js.Promise.catch(resolveEnv)

  // // 특정 카테고리 소속 상품 리스트 쿼리
  // | Some(displayCategoryId') =>
  //   let sectionType = ctx.query->Js.Dict.get("section-type")->PLP_FilterOption.Section.make

  //   let sort =
  //     ctx.query
  //     ->Js.Dict.get("sort")
  //     ->Option.map(sort => PLP_FilterOption.Sort.decodeSort(sectionType, sort))

  //   let productType =
  //     ctx.query
  //     ->Js.Dict.get("section-type")
  //     ->PLP_FilterOption.Section.make
  //     ->PLP_FilterOption.Section.toQueryParam

  //   PLP_DisplayCategory_Buyer.Query.fetchPromised(
  //     ~environment,
  //     ~variables=PLP_DisplayCategory_Buyer.Query.makeVariables(
  //       ~displayCategoryId=displayCategoryId',
  //       ~sort?,
  //       ~count=20,
  //       ~onlyBuyable=true,
  //       ~productType,
  //       (),
  //     ),
  //     (),
  //   )
  //   |> Js.Promise.then_(resolveEnv)
  //   |> Js.Promise.catch(resolveEnv)
  // }
}
