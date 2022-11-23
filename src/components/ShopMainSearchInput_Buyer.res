@react.component
let make = () => {
  let router = Next.Router.useRouter()
  let onClick = _ => {
    router->Next.Router.push("/search")
  }

  <div className=%twc("w-full flex-1")>
    <div className=%twc("relative w-full h-10")>
      <input
        className=%twc(
          "w-full h-10 border border-green-500 rounded-full px-4 remove-spin-button focus:outline-none focus:border-green-500 focus:ring-opacity-100 text-[15px] caret-transparent"
        )
        type_="text"
        name="shop-search"
        placeholder={`찾고있는 작물을 검색해보세요`}
        onClick
        autoComplete="off"
      />
      <button className=%twc("absolute right-3 top-1/2 translate-y-[-50%] w-6 h-6")>
        <IconSearch width="24" height="24" fill="#12B564" />
      </button>
    </div>
  </div>
}
