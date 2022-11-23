/*
 *
 * 1. 위치: 바이어센터 메인 상단 검색창
 *
 * 2. 역할: 상품명을 입력받아서 검색결과 페이지로 이동한다
 *
 */

@react.component
let make = () => {
  let {useRouter, pushObj} = module(Next.Router)
  let router = useRouter()

  let (keyword, setKeyword) = React.Uncurried.useState(_ => "")
  let (isEditing, setEditing) = React.Uncurried.useState(_ => false)

  let inputStyle = {
    let default = %twc(
      "w-full h-full border-2 border-green-500 rounded-full px-4 remove-spin-button focus:outline-none focus:border-green-500 focus:ring-opacity-100 text-base"
    )
    isEditing ? cx([default, %twc("text-green-500")]) : default
  }

  let onChangeKeyword = e => setKeyword(._ => (e->ReactEvent.Synthetic.target)["value"])

  let submit = ReactEvents.interceptingHandler(_ => {
    open Product_FilterOption
    router->pushObj({
      pathname: "/search",
      query: Js.Dict.fromArray([
        ("keyword", keyword->Js.Global.encodeURIComponent),
        ("section", #ALL->Section.toUrlParameter),
        ("sort", Product_FilterOption.Sort.searchDefaultValue->Product_FilterOption.Sort.toString),
      ]),
    })
  })

  React.useEffect2(_ => {
    if router.pathname == "/search" {
      router.query
      ->Js.Dict.get("keyword")
      ->Option.map(Js.Global.decodeURIComponent)
      ->Option.map(keyword' => setKeyword(. _ => keyword'))
      ->ignore
    } else {
      setKeyword(._ => "")
    }

    None
  }, (router.pathname, router.query))

  <form onSubmit={submit}>
    <div className={%twc("flex min-w-[658px] h-13 justify-center relative")}>
      <input
        className=inputStyle
        type_="text"
        name="shop-search"
        placeholder={`찾고있는 작물을 검색해보세요`}
        value={keyword}
        onChange={onChangeKeyword}
        onFocus={_ => setEditing(._ => true)}
        onBlur={_ => setEditing(._ => false)}
      />
      <button
        type_="submit"
        className=%twc(
          "absolute right-0 h-[52px] bg-green-500 rounded-full focus:outline-none flex items-center justify-center px-6"
        )>
        <IconSearch width="24" height="24" fill="#fff" />
        <span className=%twc("text-white font-bold")> {`검색`->React.string} </span>
      </button>
    </div>
  </form>
}

@module("../../public/assets/notice-red.svg")
external noticeRedIcon: string = "default"

@send external focus: Dom.element => unit = "focus"

@module("/public/assets/search-bnb-disabled.svg")
external searchIcon: string = "default"

@module("/public/assets/close-input-gray.svg")
external closeInput: string = "default"

module MO = {
  @react.component
  let make = () => {
    let inputRef = React.useRef(Js.Nullable.null)
    let {addToast} = ReactToastNotifications.useToasts()
    let {useRouter, replaceObj, pushObj} = module(Next.Router)
    let router = useRouter()
    let (
      recentSearchList,
      setRecentSearchList,
    ) = LocalStorageHooks.RecentSearchKeyword.useLocalStorage()

    let (keyword, setKeyword) = React.Uncurried.useState(_ => "")
    let (isEditing, setEditing) = React.Uncurried.useState(_ => false)

    let inputStyle = {
      let default = %twc(
        "w-full h-10 border border-green-500 rounded-full px-4 remove-spin-button focus:outline-none focus:border-green-500 focus:ring-opacity-100 text-[15px]"
      )
      isEditing ? cx([default, %twc("text-green-500")]) : default
    }

    let onChangeKeyword = e => setKeyword(._ => (e->ReactEvent.Synthetic.target)["value"])

    let addToRecentSearchList = keyword => {
      switch keyword->Js.String2.trim {
      | "" => ()
      | keyword' => {
          let newSearchHistory = recentSearchList->Option.getWithDefault(Js.Dict.empty())
          newSearchHistory->Js.Dict.set(
            keyword',
            Js.Date.now()->Js.Date.fromFloat->Js.Date.toString,
          )

          let recentSearchHistoryLimit = 15
          //최근 검색어가 15개보다 많은 경우 가장 오래된 검색어 삭제
          switch newSearchHistory {
          | searchHistory if searchHistory->Js.Dict.keys->Array.length > recentSearchHistoryLimit =>
            searchHistory
            ->Js.Dict.entries
            ->List.fromArray
            ->List.sort(((_, a), (_, b)) =>
              DateFns.compareDesc(a->Js.Date.fromString, b->Js.Date.fromString)
            )
            ->List.take(recentSearchHistoryLimit)
            ->Option.map(Js.Dict.fromList)
            ->Option.getWithDefault(Js.Dict.empty())

          | searchHistory => searchHistory
          }->setRecentSearchList
        }
      }
    }

    let submit = ReactEvents.interceptingHandler(_ => {
      //최근 검색어에 추가
      addToRecentSearchList(keyword)

      //검색어가 없는 경우 에러 표시
      if keyword == "" {
        addToast(.
          <div className=%twc("flex items-center")>
            <Image loading=Image.Loading.Lazy src=noticeRedIcon className=%twc("h-6 w-6 mr-2") />
            {"검색어를 입력해주세요"->React.string}
          </div>,
          {appearance: "error"},
        )
      } else {
        //검색 결과 페이지로 이동
        let searchInitialWithKeywordQuery: Next.Router.pathObj = {
          pathname: "/search",
          query: Js.Dict.fromArray([
            ("keyword", keyword->Js.Global.encodeURIComponent),
            ("section", #ALL->Product_FilterOption.Section.toUrlParameter),
            (
              "sort",
              Product_FilterOption.Sort.searchDefaultValue->Product_FilterOption.Sort.toString,
            ),
          ]),
        }
        let route = (routeFn, option) => router->routeFn(option)->ignore
        switch router.pathname {
        //홈에서 검색했을 때는 뒤로가기로 돌아올 수 있도록 pushObj를 사용합니다.
        | "/" => pushObj
        | _ => replaceObj
        }->route(searchInitialWithKeywordQuery)
      }
    })

    let onClickClear = _ => {
      setKeyword(._ => "")

      router->Next.Router.replaceObj({
        pathname: router.pathname,
        query: Js.Dict.empty(),
      })
    }

    React.useEffect2(_ => {
      if router.pathname == "/search" {
        router.query
        ->Js.Dict.get("keyword")
        ->Option.map(Js.Global.decodeURIComponent)
        ->Option.map(keyword' => setKeyword(. _ => keyword'))
        ->ignore
      } else {
        setKeyword(._ => "")
      }

      None
    }, (router.pathname, router.query))

    React.useEffect3(_ => {
      switch (router.pathname, router.query->Js.Dict.get("keyword")) {
      | ("/search", None) =>
        inputRef.current
        ->Js.Nullable.toOption
        ->Option.map(input => {
          input->focus
        })
        ->ignore
      | _ => ()
      }

      None
    }, (inputRef.current, router.pathname, router.query))

    let oldUI =
      <form onSubmit={submit} className=%twc("w-full flex-1")>
        <div className=%twc("relative w-full")>
          <input
            ref={ReactDOM.Ref.domRef(inputRef)}
            className={inputStyle}
            type_="text"
            name="shop-search"
            placeholder={`찾고있는 작물을 검색해보세요`}
            value={keyword}
            onChange={onChangeKeyword}
            onFocus={_ => setEditing(._ => true)}
            onBlur={_ => setEditing(._ => false)}
          />
          {switch keyword {
          | "" => React.null
          | _ =>
            <img
              onClick={ReactEvents.interceptingHandler(onClickClear)}
              src="/icons/reset-input-gray-circle@3x.png"
              className=%twc("absolute w-6 h-6 right-10 top-1/2 translate-y-[-50%]")
              alt={`검색어 지우기`}
            />
          }}
          <button
            type_="submit"
            className=%twc("absolute right-3 top-1/2 translate-y-[-50%]")
            ariaLabel="검색">
            <IconSearch width="24" height="24" fill="#12B564" />
          </button>
        </div>
      </form>

    <FeatureFlagWrapper featureFlag=#HOME_UI_UX fallback={oldUI}>
      <form onSubmit={submit} className=%twc("w-full flex-1")>
        <div className=%twc("bg-[#F0F2F5] p-3 rounded-[10px]")>
          <div className=%twc("relative")>
            <img
              src={searchIcon}
              className=%twc("flex absolute inset-y-0 left-0 items-center pointer-events-none")
              alt=""
            />
            <input
              ref={ReactDOM.Ref.domRef(inputRef)}
              className=%twc(
                "w-full bg-[#F0F2F5] pl-7 pr-6 focus:outline-none focus:ring-opacity-100 caret-[#0BB25F] text-gray-800"
              )
              type_="text"
              name="shop-search"
              placeholder={`찾고있는 작물을 검색해보세요`}
              value={keyword}
              onChange={onChangeKeyword}
              onFocus={_ => setEditing(._ => true)}
              onBlur={_ => setEditing(._ => false)}
            />
            {switch keyword {
            | "" => React.null
            | _ =>
              <button
                type_="button"
                className=%twc("absolute right-0 top-0")
                onClick={ReactEvents.interceptingHandler(onClickClear)}>
                <img src={closeInput} className=%twc("w-6 h-6") alt="검색어 초기화" />
              </button>
            }}
          </div>
        </div>
      </form>
    </FeatureFlagWrapper>
  }
}
