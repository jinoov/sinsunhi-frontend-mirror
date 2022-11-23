@module("../../../../../public/assets/recents.svg")
external recentsIcon: string = "default"

@module("../../../../../public/assets/close.svg")
external closeIcon: string = "default"

module RecentSearchDropdown = {
  module Empty = {
    @react.component
    let make = () => {
      <div className=%twc("w-full mb-[26px] ml-4 flex items-center text-[#8B8D94]")>
        {`최근 검색어가 없습니다.`->React.string}
      </div>
    }
  }

  module Item = {
    @react.component
    let make = (~keyword, ~onDelete) => {
      <Next.Link href={`/search?keyword=${keyword}`} passHref=true>
        <a
          className=%twc(
            "w-full flex h-[58px] items-center px-4 cursor-pointer hover:bg-[#1F20240A] active:bg-[#e7e7e9] ease-in-out duration-200 last-of-type:rounded-b-2xl"
          )>
          <img className=%twc("w-6 h-6") src=recentsIcon />
          <span className=%twc("flex-1 truncate ml-[10px] text-left")>
            {keyword->React.string}
          </span>
          <button>
            <img className=%twc("w-6 h-6 fill-slate-600") src=closeIcon onClick=onDelete />
          </button>
        </a>
      </Next.Link>
    }
  }

  @react.component
  let make = (~show) => {
    let (
      recentSearchKeyword: option<Js.Dict.t<string>>,
      setRecentSearchKeyword,
    ) = LocalStorageHooks.RecentSearchKeyword.useLocalStorage()

    let onDeleteItem = targetKeyword =>
      ReactEvents.interceptingHandler(_ => {
        let removeKeyword = (dictionary: Js.Dict.t<string>, targetKeyword: string) => {
          dictionary
          ->Js.Dict.entries
          ->Array.keep(((keyword, _)) => keyword != targetKeyword)
          ->Js.Dict.fromArray
        }

        recentSearchKeyword
        ->Option.map(recentSearchKeyword' => recentSearchKeyword'->removeKeyword(targetKeyword))
        ->Option.getWithDefault(Js.Dict.empty())
        ->setRecentSearchKeyword
      })

    let style = cx([
      %twc(
        "w-[400px] rounded-2xl z-[1] light-level-1 absolute mt-[6px] bg-white border-[1px] border-[#F0F2F5] hidden hover:!block overflow-hidden"
      ),
      show ? "!block" : %twc("hidden"),
    ])

    <div className=style>
      <div className=%twc("h-[58px] flex justify-between items-center px-4")>
        <span className=%twc("font-bold text-[17px]")> {`최근 검색어`->React.string} </span>
        <button
          className=%twc("text-[15px] text-[#8B8D94]")
          onClick={_ => {
            setRecentSearchKeyword(Js.Dict.empty())
          }}>
          {`모두 지우기`->React.string}
        </button>
      </div>
      {switch recentSearchKeyword
      ->Option.map(recentSearchKeyword' =>
        recentSearchKeyword'
        ->Js.Dict.entries
        ->SortArray.stableSortBy(((_, dateTime1), (_, dateTime2)) =>
          DateFns.compareDesc(dateTime1->Js.Date.fromString, dateTime2->Js.Date.fromString)
        )
      )
      ->Option.getWithDefault([]) {
      | [] => <Empty />
      | recentSearchKeyword'' =>
        recentSearchKeyword''
        ->Array.map(((keyword, _)) => {
          <Item keyword onDelete={onDeleteItem(keyword)} key=keyword />
        })
        ->React.array
      }}
    </div>
  }
}

module NewHomeSection = {
  type t = Quick | Matching
  let toProductFilterOption = t => {
    switch t {
    | Quick => #DELIVERY
    | Matching => #MATCHING
    }
  }

  let make = string =>
    switch string {
    | "quick" => Some(Quick)
    | "matching" => Some(Matching)
    | _ => None
    }
}

module Placeholder = {
  @react.component
  let make = () => {
    <div>
      <form
        className=%twc(
          "w-[400px] flex h-12 justify-center relative bg-[#F0F2F5] rounded-[10px] overflow-hidden items-center p-3"
        )>
        <IconSearch width="24" height="24" fill="#A6A8AD" />
        <input
          autoComplete="off"
          className={%twc(
            "flex-1 h-full ml-1 remove-spin-button focus:outline-none  focus:ring-opacity-100 text-base bg-[#F0F2F5] text-gray-800 caret-[#0BB25F]"
          )}
          type_="text"
          name="shop-search"
          placeholder={`찾고있는 작물을 검색해보세요`}
        />
      </form>
    </div>
  }
}

@react.component
let make = () => {
  let {useRouter, pushObj} = module(Next.Router)
  let router = useRouter()

  let (
    recentSearchList,
    setRecentSearchList,
  ) = LocalStorageHooks.RecentSearchKeyword.useLocalStorage()
  let (keyword, setKeyword) = React.Uncurried.useState(_ => "")
  let (isEditing, setEditing) = React.Uncurried.useState(_ => false)

  let inputStyle = %twc(
    "flex-1 h-full ml-1 remove-spin-button focus:outline-none  focus:ring-opacity-100 text-base bg-[#F0F2F5] text-gray-800 caret-[#0BB25F]"
  )

  let onChange = e => setKeyword(._ => (e->ReactEvent.Synthetic.target)["value"])
  let onFocus = _ => {
    setEditing(._ => true)
  }

  let onBlur = _ => {
    setEditing(._ => false)
  }

  let addToRecentSearchList = keyword => {
    switch keyword->Js.String2.trim {
    | "" => ()
    | keyword' => {
        let newSearchHistory = recentSearchList->Option.getWithDefault(Js.Dict.empty())
        newSearchHistory->Js.Dict.set(keyword', Js.Date.now()->Js.Date.fromFloat->Js.Date.toString)

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
    //검색 결과 페이지로 이동
    let targetSection =
      router.query
      ->Js.Dict.get("tab")
      ->Option.flatMap(NewHomeSection.make)
      ->Option.map(NewHomeSection.toProductFilterOption)
      ->Option.getWithDefault(#ALL)

    if keyword == "" {
      ignore()
    } else {
      open Product_FilterOption
      router->pushObj({
        pathname: "/search",
        query: Js.Dict.fromArray([
          ("keyword", keyword->Js.Global.encodeURIComponent),
          ("section", targetSection->Section.toUrlParameter),
          (
            "sort",
            Product_FilterOption.Sort.searchDefaultValue->Product_FilterOption.Sort.toString,
          ),
        ]),
      })
    }
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

  <div>
    <form
      onSubmit={submit}
      className=%twc(
        "w-[400px] flex h-12 justify-center relative bg-[#F0F2F5] rounded-[10px] overflow-hidden items-center p-3"
      )>
      <IconSearch width="24" height="24" fill="#A6A8AD" />
      <input
        autoComplete="off"
        className=inputStyle
        type_="text"
        name="shop-search"
        placeholder={`찾고있는 작물을 검색해보세요`}
        value={keyword}
        onChange
        onFocus
        onBlur
      />
    </form>
    <RecentSearchDropdown show={isEditing} />
  </div>
}
