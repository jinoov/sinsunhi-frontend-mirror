@module("/public/assets/search-bnb-disabled.svg")
external searchIcon: string = "default"

@module("/public/assets/close-input-gray.svg")
external closeInput: string = "default"

@react.component
let make = (~defaultQuery="", ~onChange) => {
  let router = Next.Router.useRouter()
  let (query, setQuery) = React.Uncurried.useState(_ => defaultQuery)

  let handleChange = e => {
    let value = (e->ReactEvent.Synthetic.target)["value"]

    setQuery(._ => value)
    onChange(value)
  }

  let reset = _ => {
    setQuery(._ => "")
    onChange("")

    let newQuery = router.query
    newQuery->Js.Dict.set("search", "")

    router->Next.Router.replaceShallow({pathname: router.pathname, query: newQuery})
  }

  let handleOnSubmit = (
    _ => {
      let newQuery = router.query
      newQuery->Js.Dict.set("search", query)

      router->Next.Router.replaceShallow({pathname: router.pathname, query: newQuery})
    }
  )->ReactEvents.interceptingHandler

  <form onSubmit={handleOnSubmit}>
    <div className=%twc("bg-[#F0F2F5] p-[14px] rounded-[10px]")>
      <div className=%twc("relative")>
        <img
          src={searchIcon}
          className=%twc("flex absolute inset-y-0 left-0 items-center pointer-events-none")
          alt=""
        />
        <input
          value={query}
          onChange={handleChange}
          type_="text"
          id="input-matching-product"
          placeholder="검색어를 입력하세요"
          className=%twc("w-full bg-[#F0F2F5] pl-7 pr-6 focus:outline-none")
        />
        {switch query == "" {
        | true => React.null
        | false =>
          <button type_="button" className=%twc("absolute right-0 top-0") onClick={reset}>
            <img src={closeInput} className=%twc("w-6 h-6") alt="검색어 초기화" />
          </button>
        }}
      </div>
    </div>
  </form>
}
