module RecentKeywordChip = {
  @react.component
  let make = (~keyword) => {
    let href = `/search?keyword=${keyword->Js.Global.encodeURIComponent}`

    <Next.Link href passHref=true>
      <a className=%twc("rounded-full px-[14px] py-[7.5px] border-[1px] text-[15px] mb-4 h-[38px]")>
        {`${keyword}`->React.string}
      </a>
    </Next.Link>
  }
}

module Empty = {
  @react.component
  let make = () => {
    <>
      <div className=%twc("font-bold text-gray-800 mx-5 mb-2 mt-4 flex-1")>
        {`최근 검색어`->React.string}
      </div>
      <span className=%twc("text-gray-500 mx-5")>
        {`최근 검색어가 없습니다.`->React.string}
      </span>
    </>
  }
}

@react.component
let make = () => {
  let (
    recentSearchList,
    setRecentSearchList,
  ) = LocalStorageHooks.RecentSearchKeyword.useLocalStorage()

  let onClickClear = _ => {
    setRecentSearchList(Js.Dict.empty())
  }

  {
    switch recentSearchList
    ->Option.getWithDefault(Js.Dict.empty())
    ->Js.Dict.entries
    ->SortArray.stableSortBy(((_, dateTime1), (_, dateTime2)) =>
      DateFns.compareDesc(dateTime1->Js.Date.fromString, dateTime2->Js.Date.fromString)
    ) {
    | [] => <Empty />
    | searchHistoryItems =>
      <>
        <div className=%twc("flex flex-row justify-between my-4 px-5")>
          <span className=%twc("font-bold text-gray-800")>
            {`최근 검색어`->React.string}
          </span>
          <button className=%twc("text-gray-500 text-[13px]") onClick=onClickClear>
            {`모두 지우기`->React.string}
          </button>
        </div>
        <div className=%twc("flex flex-wrap px-5 gap-2")>
          {searchHistoryItems
          ->Array.map(((keyword, _)) => <RecentKeywordChip keyword key=keyword />)
          ->React.array}
        </div>
      </>
    }
  }
}
