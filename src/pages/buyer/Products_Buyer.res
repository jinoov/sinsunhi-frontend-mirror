external unsafeAsFile: Webapi.Blob.t => Webapi.File.t = "%identity"

module List = {
  @react.component
  let make = (~status: CustomHooks.Products.result) => {
    switch status {
    | Error(error) => <ErrorPanel error />
    | Loading => <div> {j`로딩 중..`->React.string} </div>
    | Loaded(products) =>
      <>
        <div className=%twc("w-full overflow-x-scroll")>
          <div className=%twc("text-sm lg:min-w-max")>
            <div
              className=%twc(
                "hidden lg:grid lg:grid-cols-8-buyer-product bg-gray-100 text-gray-500 h-12"
              )>
              <div className=%twc("h-full px-4 flex items-center whitespace-nowrap")>
                {`판매상태`->React.string}
              </div>
              <div className=%twc("h-full px-4 flex items-center text-center whitespace-nowrap")>
                {`상품번호·단품번호`->React.string}
              </div>
              <div className=%twc("h-full px-4 flex items-center text-center whitespace-nowrap")>
                {`상품명·단품명`->React.string}
              </div>
              <div className=%twc("h-full px-4 flex items-center whitespace-nowrap")>
                {`현재 판매가`->React.string}
              </div>
              <div className=%twc("h-full px-4 flex items-center whitespace-nowrap")>
                {`구매 가능 수량`->React.string}
              </div>
              <div className=%twc("h-full px-4 flex items-center whitespace-nowrap")>
                {`출고기준시간`->React.string}
              </div>
              <div className=%twc("h-full px-4 flex items-center whitespace-nowrap text-center")>
                {`메모`->React.string}
              </div>
            </div>
            {switch products->CustomHooks.Products.products_decode {
            | Ok(products') =>
              <ol
                className=%twc(
                  "divide-y divide-gray-300 lg:divide-gray-100 lg:list-height-buyer lg:overflow-y-scroll"
                )>
                {products'.data->Garter.Array.length > 0
                  ? products'.data
                    ->Garter.Array.map(product => <Product_Buyer key=product.productSku product />)
                    ->React.array
                  : <EmptyProducts />}
              </ol>
            | Error(_error) => <EmptyProducts />
            }}
          </div>
        </div>
        {switch status {
        | Loaded(products) =>
          switch products->CustomHooks.Products.products_decode {
          | Ok(products') =>
            <div className=%twc("flex justify-center py-5")>
              <Pagination
                pageDisplySize=Constants.pageDisplySize
                itemPerPage=products'.limit
                total=products'.count
              />
            </div>
          | Error(_) => React.null
          }
        | _ => React.null
        }}
      </>
    }
  }
}

@spice
type data = {
  @spice.key("total-count") totalCount: int,
  @spice.key("update-count") updateCount: int,
}
@spice
type response = {
  data: data,
  message: string,
}

module Products = {
  @react.component
  let make = () => {
    let router = Next.Router.useRouter()

    let status = CustomHooks.Products.use(
      router.query->Webapi.Url.URLSearchParams.makeWithDict->Webapi.Url.URLSearchParams.toString,
    )

    let count = switch status {
    | Loaded(products) =>
      switch products->CustomHooks.Products.products_decode {
      | Ok(products') => products'.count->Int.toString
      | Error(_) => `-`
      }
    | _ => `-`
    }

    let oldUI =
      <div className=%twc("sm:px-10 md:px-20")>
        <Search_Product_Buyer />
        <div className=%twc("lg:px-7 mt-4 shadow-gl")>
          <div className=%twc("md:flex md:justify-between pb-4 text-base")>
            <div
              className=%twc(
                "pt-10 px-5 flex flex-col lg:flex-row sm:flex-auto sm:justify-between"
              )>
              <h3 className=%twc("font-bold")>
                {j`내역`->React.string}
                <span className=%twc("ml-1 text-green-gl font-normal")>
                  {j`${count}건`->React.string}
                </span>
              </h3>
              <div className=%twc("flex flex-col lg:flex-row mt-4 lg:mt-0")>
                <div className=%twc("flex items-center")>
                  <Select_CountPerPage className=%twc("mr-2") />
                </div>
                <div className=%twc("flex mt-2 lg:mt-0")>
                  <Excel_Download_Request_Button
                    userType=Buyer requestUrl="/product/request-excel"
                  />
                </div>
              </div>
            </div>
          </div>
          <List status />
        </div>
      </div>

    <FeatureFlagWrapper featureFlag=#HOME_UI_UX fallback=oldUI>
      <div className=%twc("flex pc-content bg-[#FAFBFC]")>
        <PC_MyInfo_Sidebar />
        <div
          className=%twc(
            "lg:mx-16 lg:max-w-[1280px] lg:min-w-[872px] shadow-gl bg-white lg:mt-10 mb-14 rounded-sm h-fit "
          )>
          <Search_Product_Buyer />
          <div className=%twc("hidden lg:block px-[50px] my-5")>
            <Formula.Divider variant=#small />
          </div>
          <div className=%twc("lg:px-[50px] mt-4")>
            <div className=%twc("md:flex md:justify-between pb-4 text-base")>
              <div
                className=%twc(
                  "pt-10 px-5 lg:pt-0 lg:px-0 flex flex-col lg:flex-row sm:flex-auto sm:justify-between"
                )>
                <h3 className=%twc("font-bold")>
                  {j`내역`->React.string}
                  <span className=%twc("ml-1 text-green-gl font-normal")>
                    {j`${count
                      ->Int.fromString
                      ->Option.map(count' => count'->Locale.Int.toLocaleString(~locale="ko-KR", ()))
                      ->Option.getWithDefault("")}건`->React.string}
                  </span>
                </h3>
                <div className=%twc("flex flex-col lg:flex-row mt-4 lg:mt-0")>
                  <div className=%twc("flex lg:mt-0 mr-2")>
                    <Excel_Download_Request_Button
                      userType=Buyer requestUrl="/product/request-excel"
                    />
                  </div>
                  <div className=%twc("flex items-center mt-2 lg:mt-0")>
                    <Select_CountPerPage />
                  </div>
                </div>
              </div>
            </div>
            <List status />
          </div>
        </div>
      </div>
    </FeatureFlagWrapper>
  }
}

@react.component
let make = () =>
  <Authorization.Buyer title={j`상품`}>
    <Products />
  </Authorization.Buyer>
