@module("/public/assets/search-bnb-enabled.svg")
external searchBnbEnabled: string = "default"

@react.component
let make = () => {
  let {useRouter, replaceShallow} = module(Next.Router)
  let router = useRouter()
  let searchQuery = router.query->Js.Dict.get("search")

  let (isShowModal, setIsShowModal) = React.Uncurried.useState(_ => Dialog.Hide)

  let handleOnClick = _ => setIsShowModal(._ => Dialog.Show)

  let handleOnClose = _ => {
    let newQuery =
      router.query->Js.Dict.entries->Array.keep(((key, _)) => key != "search")->Js.Dict.fromArray

    // 검색 쿼리를 제거합니다.
    router->replaceShallow({pathname: "/", query: newQuery})
    setIsShowModal(._ => Dialog.Hide)
  }

  <section className=%twc("relative w-[1280px] mx-auto")>
    <PC_Matching_Banner_Slide_Buyer />
    <div className=%twc("absolute z-[1] top-0 w-full h-full py-12 px-[52px] flex flex-col")>
      <h1 className=%twc("mt-3 text-white text-[32px] font-bold leading-[44px]")>
        {"원하는 상품, 수량 입력하고 산지 직거래 견적 받으세요"->React.string}
      </h1>
      <p className=%twc("mt-2 text-white text-[19px]")>
        {"믿고 거래할 수 있는 산지에서 소싱하세요"->React.string}
      </p>
      <button
        type_="button"
        className=%twc(
          "bg-white text-center rounded-xl mt-auto relative interactable w-[400px] h-14 hover:bg-[#f4f4f4] active:bg-[#e9e9e9] ease-in-out duration-200"
        )
        onClick={handleOnClick}>
        <div className=%twc("flex items-center justify-center")>
          <img className=%twc("w-6 h-6 mr-1") src=searchBnbEnabled alt="" />
          <span className=%twc("font-bold text-[19px]")>
            {"견적 상품 찾기"->React.string}
          </span>
        </div>
      </button>
    </div>
    <PC_Matching_SearchProduct
      isShow={isShowModal} onClose={handleOnClose} defaultQuery=?{searchQuery}
    />
  </section>
}
