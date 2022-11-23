module Query = {
  module GetList = %relay(`
    query RecentViewList_GetList_Query($cursor: String, $count: Int!) {
      viewer {
        ...RecentViewList_Fragment @arguments(count: $count, cursor: $cursor)
      }
    }
`)
}

module Fragment = %relay(`
  fragment RecentViewList_Fragment on User
  @refetchable(queryName: "RecentViewGetListRefetchQuery")
  @argumentDefinitions(cursor: { type: "String" }, count: { type: "Int!" }) {
    viewedProductCount
    viewedProducts(first: $count, after: $cursor, orderBy: [{ viewedAt: DESC }])
      @connection(key: "RecentViewList_viewedProducts") {
      __id
      edges {
        viewedAt # 본 시각(UTC)
        cursor
        node {
          id
          number
          ...LikeRecentListItem_Fragment
        }
      }
    }
  }
`)

module NoItems = {
  @react.component
  let make = () => {
    let oldUI =
      //헤더와 BNB 영역의 높이를 뺸 위치
      <div
        className=%twc("flex flex-col gap-5 h-[calc(100vh-170px)] overflow-y-scroll flex-1 mt-2")>
        <div
          className=%twc(
            "text-center text-gray-500 flex flex-col justify-center items-center flex-1 whitespace-pre gap-1.5"
          )>
          <span className=%twc("text-lg text-gray-800")>
            {`최근 본 상품이 없어요.`->React.string}
          </span>
        </div>
      </div>

    <FeatureFlagWrapper featureFlag=#HOME_UI_UX fallback=oldUI>
      <div className=%twc("flex flex-col gap-5 overflow-y-scroll flex-1 mt-2")>
        <div
          className=%twc(
            "text-center text-gray-500 flex flex-col justify-center items-center flex-1 whitespace-pre gap-1.5"
          )>
          <span className=%twc("text-lg text-gray-800")>
            {`최근 본 상품이 없어요.`->React.string}
          </span>
        </div>
      </div>
    </FeatureFlagWrapper>
  }
}

module Header = {
  @react.component
  let make = (~itemAmount) => {
    let oldUI =
      <div className=%twc("flex font-bold pt-8 px-7 pb-3 items-center gap-[6px]")>
        <span className=%twc("text-2xl text-gray-900 ")> {`최근 본 상품`->React.string} </span>
        <span
          className=%twc(
            "leading-[12px] py-[2px] px-[6px] rounded-xl bg-gray-150 text-sm align-middle"
          )>
          {`${itemAmount->Int.toString}`->React.string}
        </span>
      </div>

    <FeatureFlagWrapper featureFlag=#HOME_UI_UX fallback=oldUI>
      <div
        className=%twc(
          "flex font-bold pt-8 lg:pt-10 px-7 pb-3 items-center gap-[6px] lg:px-[50px] bg-white"
        )>
        <span className=%twc("text-2xl text-gray-900 ")> {`최근 본 상품`->React.string} </span>
        <span
          className=%twc(
            "leading-[12px] py-[2px] px-[6px] rounded-xl bg-gray-150 text-sm align-middle"
          )>
          {`${itemAmount->Int.toString}`->React.string}
        </span>
      </div>
    </FeatureFlagWrapper>
  }
}

let groupByDate = (
  edges: array<RecentViewList_Fragment_graphql.Types.fragment_viewedProducts_edges>,
) => {
  let toDateStringWithWeekday = s =>
    switch s->Js.Date.fromString {
    | today if today->DateFns.isToday => today->DateFns.format("yyyy.MM.dd (오늘)")
    | viewedDate =>
      viewedDate->DateFns.formatOpt(
        "yyyy.MM.dd (EEE)",
        {
          locale: Some(DateFns.Locale.ko),
          weekStartsOn: None,
          firstWeekContainsDate: None,
          useAdditionalWeekYearTokens: None,
          useAdditionalDayOfYearTokens: None,
        },
      )
    }

  edges
  ->Array.map(edge => (edge.viewedAt->toDateStringWithWeekday, edge))
  ->Array.reduce(Map.String.empty, (acc, (date, edge)) => {
    switch acc->Map.String.get(date) {
    | Some(edges) => acc->Map.String.set(date, edges->Array.concat([edge]))
    | None => acc->Map.String.set(date, [edge])
    }
  })
  ->Map.String.toArray
  ->Array.reverse
}

module Edit = {
  module PC = {
    @react.component
    let make = (~query, ~toView=?) => {
      let {data: {viewedProducts, viewedProductCount}, hasNext, loadNext} =
        query->Fragment.usePagination
      let {__id} = viewedProducts
      let loadMoreRef = React.useRef(Js.Nullable.null)

      //전체 선택 토글이 활성화 되었는지 여부
      let (isAllSelected, setIsAllSelected) = React.Uncurried.useState(_ => false)
      //사용자가 전체 토글을 조작한 후에 개별적으로 조작한 항목들
      let (manipulatedIds, setManipulatedIds) = React.Uncurried.useState(_ => Set.String.empty)

      //실제로 선택된 것으로 활성화된 id 수
      let selectedIdCount = switch isAllSelected {
      | true => viewedProductCount - manipulatedIds->Set.String.size
      | false => manipulatedIds->Set.String.size
      }

      let (isShowConfirmDialog, setIsShowConfirmDialog) = React.Uncurried.useState(_ => Dialog.Hide)

      let onChangeItem = (id: string) => {
        setManipulatedIds(.prev =>
          switch prev->Belt.Set.String.has(id) {
          | true => prev->Belt.Set.String.remove(id)
          | false => prev->Belt.Set.String.add(id)
          }
        )
      }

      let isIntersecting = CustomHooks.IntersectionObserver.use(
        ~target=loadMoreRef,
        ~rootMargin="10px",
        ~thresholds=0.1,
        (),
      )

      // 페이지네이션을 수행하는 훅
      React.useEffect1(_ => {
        if hasNext && isIntersecting {
          loadNext(~count=20, ())->ignore
        }
        None
      }, [hasNext, isIntersecting])

      //사용자가 모든 항목을 조작했다면, 전체 선택 토글을 플립, 조작한 리스트 초기화
      React.useEffect2(_ => {
        if manipulatedIds->Set.String.size == viewedProductCount {
          setIsAllSelected(.prev => !prev)
          setManipulatedIds(._ => Set.String.empty)
        }

        None
      }, (manipulatedIds, viewedProductCount))

      let onSelectAllCheck = e => {
        setManipulatedIds(._ => Set.String.empty)
        setIsAllSelected(._ => (e->ReactEvent.Synthetic.target)["checked"])
      }

      let oldUI =
        <>
          <div className=%twc("flex flex-col flex-1 overflow-y-hidden gap-1")>
            <Header itemAmount={viewedProductCount} />
            {switch viewedProducts.edges {
            | [] => <NoItems />
            | edges =>
              <>
                <div
                  className=%twc(
                    "flex py-5 gap-[6px] justify-between items-center h-16 border-b-[1px] border-gray-100 mx-7"
                  )>
                  <div className=%twc("flex gap-[6px] items-center justify-start ")>
                    <Checkbox
                      id="recent-view-list-all-select"
                      checked=isAllSelected
                      onChange={onSelectAllCheck}
                    />
                    <span className=%twc("text-sm text-gray-500 leading-3")>
                      {`전체선택`->React.string}
                    </span>
                  </div>
                  {switch toView {
                  | Some(toView') =>
                    <div className=%twc("inline-flex gap-1")>
                      {
                        let baseStyle = %twc("text-sm rounded-lg px-3 py-1.5 transition-colors")
                        let stateStyle = switch selectedIdCount == 0 {
                        | true => %twc("text-gray-400  bg-gray-100 cursor-not-allowed")
                        | false =>
                          %twc("text-white bg-green-500  hover:bg-green-600 transition-colors")
                        }

                        <button
                          className={Cn.make([baseStyle, stateStyle])}
                          disabled={selectedIdCount == 0}
                          onClick={_ => setIsShowConfirmDialog(._ => Dialog.Show)}>
                          {(
                            selectedIdCount == 0
                              ? `삭제`
                              : `삭제(${selectedIdCount->Int.toString})`
                          )->React.string}
                        </button>
                      }
                      <button
                        className=%twc(
                          "text-gray-700 text-sm bg-gray-100 rounded-lg px-3 py-1.5 hover:bg-gray-200 transition-colors"
                        )
                        onClick={_ => toView'()}>
                        {`완료`->React.string}
                      </button>
                    </div>
                  | None => React.null
                  }}
                </div>
                <div className=%twc("flex flex-col flex-1 w-full gap-5 overflow-y-scroll mt-2 ")>
                  {edges
                  ->groupByDate
                  ->Array.map(((date, chunkEdges)) =>
                    <div
                      className=%twc("flex flex-col gap-2") key={`${date}-recent-view-edit-chunk`}>
                      <div className=%twc("text-[15px] text-gray-900 font-bold pl-[72px] my-4")>
                        {date->React.string}
                      </div>
                      {chunkEdges
                      ->Array.map(({cursor, node: {id, fragmentRefs}}) => {
                        <Like_Recent_List_Item.Edit
                          query=fragmentRefs
                          isChecked={manipulatedIds->Belt.Set.String.has(id) != isAllSelected}
                          onClick={_ => onChangeItem(id)}
                          key={`${cursor}-recent-view-edit`}
                        />
                      })
                      ->React.array}
                      <div className=%twc("h-[10px] w-full bg-slate-50") />
                    </div>
                  )
                  ->React.array}
                  <div ref={ReactDOM.Ref.domRef(loadMoreRef)} className=%twc("h-5 w-full") />
                </div>
              </>
            }}
          </div>
          <Recent_View_List_DeleteBulkId_Dialog
            ids={manipulatedIds->Set.String.toArray}
            setIds={setManipulatedIds}
            connection={__id}
            show={isShowConfirmDialog}
            setShow={setIsShowConfirmDialog}
            selectedIdCount
            isAllSelected
            setIsAllSelected
          />
        </>

      <FeatureFlagWrapper featureFlag=#HOME_UI_UX fallback=oldUI>
        {<>
          <div className=%twc("flex flex-col mb-5")>
            {switch viewedProducts.edges->groupByDate->List.fromArray {
            | list{} =>
              <div
                className=%twc(
                  "bg-white mb-5 shadow-[0px_10px_40px_10px_rgba(0,0,0,0.03)] h-[720px] rounded-sm flex flex-col"
                )>
                <Header itemAmount={viewedProductCount} />
                <NoItems />
              </div>
            | list{(date, chunkEdges), ...rest} =>
              <>
                <div className=%twc("bg-white shadow-[0px_10px_40px_10px_rgba(0,0,0,0.03)] mb-5")>
                  <Header itemAmount={viewedProductCount} />
                  <div
                    className=%twc(
                      "flex py-5 gap-[6px] justify-between items-center h-16 border-b-[1px] border-gray-100 mx-[50px]"
                    )>
                    <div className=%twc("flex gap-[6px] items-center justify-start ")>
                      <Checkbox
                        id="recent-view-list-all-select"
                        checked=isAllSelected
                        onChange={onSelectAllCheck}
                      />
                      <span className=%twc("text-sm text-gray-500 leading-3")>
                        {`전체선택`->React.string}
                      </span>
                    </div>
                    {switch toView {
                    | Some(toView') =>
                      <div className=%twc("inline-flex gap-1")>
                        {
                          let baseStyle = %twc("text-sm rounded-lg px-3 py-1.5 transition-colors")
                          let stateStyle = switch selectedIdCount == 0 {
                          | true => %twc("text-gray-400  bg-gray-100 cursor-not-allowed")
                          | false =>
                            %twc("text-white bg-green-500  hover:bg-green-600 transition-colors")
                          }

                          <button
                            className={Cn.make([baseStyle, stateStyle])}
                            disabled={selectedIdCount == 0}
                            onClick={_ => setIsShowConfirmDialog(._ => Dialog.Show)}>
                            {(
                              selectedIdCount == 0
                                ? `삭제`
                                : `삭제(${selectedIdCount->Int.toString})`
                            )->React.string}
                          </button>
                        }
                        <button
                          className=%twc(
                            "text-gray-700 text-sm bg-gray-100 rounded-lg px-3 py-1.5 hover:bg-gray-200 transition-colors"
                          )
                          onClick={_ => toView'()}>
                          {`완료`->React.string}
                        </button>
                      </div>
                    | None => React.null
                    }}
                  </div>
                  <div
                    className=%twc("flex flex-col gap-2 pb-5")
                    key={`${date}-recent-view-edit-chunk`}>
                    <div className=%twc("text-[15px] text-gray-900 font-bold pl-[50px] my-4")>
                      {date->React.string}
                    </div>
                    {chunkEdges
                    ->Array.map(({cursor, node: {id, fragmentRefs}}) => {
                      <Like_Recent_List_Item.Edit
                        query=fragmentRefs
                        isChecked={manipulatedIds->Belt.Set.String.has(id) != isAllSelected}
                        onClick={_ => onChangeItem(id)}
                        key={`${cursor}-recent-view-edit`}
                      />
                    })
                    ->React.array}
                  </div>
                </div>
                <div className=%twc("flex flex-col flex-1 w-full gap-5 ")>
                  {rest
                  ->List.map(((date, chunkEdges)) =>
                    <div
                      className=%twc(
                        "flex flex-col gap-2 bg-white shadow-[0px_10px_40px_10px_rgba(0,0,0,0.03)] pb-5"
                      )
                      key={`${date}-recent-view-edit-chunk`}>
                      <div className=%twc("text-[15px] text-gray-900 font-bold pl-[50px] my-4")>
                        {date->React.string}
                      </div>
                      {chunkEdges
                      ->Array.map(({cursor, node: {id, fragmentRefs}}) => {
                        <Like_Recent_List_Item.Edit
                          query=fragmentRefs
                          isChecked={manipulatedIds->Belt.Set.String.has(id) != isAllSelected}
                          onClick={_ => onChangeItem(id)}
                          key={`${cursor}-recent-view-edit`}
                        />
                      })
                      ->React.array}
                    </div>
                  )
                  ->List.toArray
                  ->React.array}
                  <div
                    ref={ReactDOM.Ref.domRef(loadMoreRef)}
                    className=%twc("h-5 w-full bg-transparent")
                  />
                </div>
              </>
            }}
          </div>
          <Recent_View_List_DeleteBulkId_Dialog
            ids={manipulatedIds->Set.String.toArray}
            setIds={setManipulatedIds}
            connection={__id}
            show={isShowConfirmDialog}
            setShow={setIsShowConfirmDialog}
            selectedIdCount
            isAllSelected
            setIsAllSelected
          />
        </>}
      </FeatureFlagWrapper>
    }
  }

  module MO = {
    module CTAContainer = {
      @react.component
      let make = (~selectedIdCount, ~onClick) => {
        let isButtonActive = selectedIdCount > 0
        let buttonStyle = {
          let base = %twc(
            "w-full h-14 rounded-xl flex flex-row justify-center items-center gap-1 font-bold"
          )
          let active = %twc("bg-green-gl text-white")
          let inActive = %twc("bg-gray-150 text-gray-300")

          Cn.make([base, isButtonActive ? active : inActive])
        }
        <>
          <div className=%twc("w-full h-[93px]") />
          <div
            className=%twc(
              "border-t-[1px] p-4 pb-5 fixed bottom-0 max-w-[768px] mx-auto border-t-gray-100 bg-white w-full"
            )>
            <button type_="button" className=buttonStyle onClick>
              <span className=%twc("text-lg")> {`삭제`->React.string} </span>
              {switch isButtonActive {
              | true =>
                <div
                  className=%twc(
                    "rounded-xl bg-green-50 text-green-gl px-[6px] py-[2px] text-xs leading-3"
                  )>
                  {`${selectedIdCount->Int.toString}`->React.string}
                </div>
              | false => React.null
              }}
            </button>
          </div>
        </>
      }
    }

    @react.component
    let make = (~query, ~toView=?) => {
      let scrollContainer = React.useRef(Js.Nullable.null)
      let {data: {viewedProducts, viewedProductCount}, hasNext, loadNext} =
        query->Fragment.usePagination
      let {__id} = viewedProducts
      let loadMoreRef = React.useRef(Js.Nullable.null)

      //전체 선택 토글이 활성화 되었는지 여부
      let (isAllSelected, setIsAllSelected) = React.Uncurried.useState(_ => false)
      //사용자가 전체 토글을 조작한 후에 개별적으로 조작한 항목들
      let (manipulatedIds, setManipulatedIds) = React.Uncurried.useState(_ => Set.String.empty)

      //실제로 선택된 것으로 활성화된 id 수
      let selectedIdCount = switch isAllSelected {
      | true => viewedProductCount - manipulatedIds->Set.String.size
      | false => manipulatedIds->Set.String.size
      }

      let (isShowConfirmDialog, setIsShowConfirmDialog) = React.Uncurried.useState(_ => Dialog.Hide)

      let onChangeItem = (id: string) => {
        setManipulatedIds(.prev =>
          switch prev->Belt.Set.String.has(id) {
          | true => prev->Belt.Set.String.remove(id)
          | false => prev->Belt.Set.String.add(id)
          }
        )
      }

      let isIntersecting = CustomHooks.IntersectionObserver.use(
        ~target=loadMoreRef,
        ~root=scrollContainer,
        ~rootMargin="10px",
        ~thresholds=0.1,
        (),
      )

      // 페이지네이션을 수행하는 훅
      React.useEffect1(_ => {
        if hasNext && isIntersecting {
          loadNext(~count=20, ())->ignore
        }
        None
      }, [hasNext, isIntersecting])

      //사용자가 모든 항목을 조작했다면, 전체 선택 토글을 플립, 조작한 리스트 초기화
      React.useEffect2(_ => {
        if manipulatedIds->Set.String.size == viewedProductCount {
          setIsAllSelected(.prev => !prev)
          setManipulatedIds(._ => Set.String.empty)
        }

        None
      }, (manipulatedIds, viewedProductCount))

      let onSelectAllCheck = e => {
        setManipulatedIds(._ => Set.String.empty)
        setIsAllSelected(._ => (e->ReactEvent.Synthetic.target)["checked"])
      }

      <>
        {switch viewedProducts.edges {
        | [] => <NoItems />
        | edges =>
          <div className=%twc("flex flex-col flex-1 overflow-hidden h-full")>
            <div
              className=%twc(
                "flex w-full px-5 py-4 gap-[6px] justify-between items-center h-14 text-[15px] fixed bg-white z-[1]"
              )>
              <div className=%twc("flex gap-[6px] items-center justify-start")>
                <Checkbox
                  id="recent-view-list-all-select" checked=isAllSelected onChange={onSelectAllCheck}
                />
                <span className=%twc("text-gray-500 leading-3")>
                  {`전체선택`->React.string}
                </span>
              </div>
              {switch toView {
              | Some(toView') =>
                <button className=%twc("text-green-gl") onClick={_ => toView'()}>
                  {`완료`->React.string}
                </button>
              | None => React.null
              }}
            </div>
            <div className=%twc("w-full h-14") />
            <div
              className=%twc("flex flex-col flex-1 w-full gap-1 overflow-y-scroll h-full")
              ref={ReactDOM.Ref.domRef(scrollContainer)}>
              {edges
              ->groupByDate
              ->Array.map(((date, chunkEdges)) =>
                <li
                  className=%twc(
                    "flex flex-col gap-2 border-b-[10px] last-of-type:border-b-0 border-gray-50 pb-3 pt-5"
                  )
                  key={`${date}-recent-view-view-chunk`}>
                  <div className=%twc("text-[15px] text-gray-900 font-bold ml-16")>
                    {date->React.string}
                  </div>
                  {chunkEdges
                  ->Array.map(({cursor, node: {id, fragmentRefs}}) => {
                    <Like_Recent_List_Item.Edit
                      query=fragmentRefs
                      isChecked={manipulatedIds->Belt.Set.String.has(id) != isAllSelected}
                      onClick={_ => onChangeItem(id)}
                      key={`${cursor}-recent-view-edit`}
                    />
                  })
                  ->React.array}
                </li>
              )
              ->React.array}
              <div ref={ReactDOM.Ref.domRef(loadMoreRef)} className=%twc("h-5 w-full") />
            </div>
          </div>
        }}
        <CTAContainer selectedIdCount onClick={_ => setIsShowConfirmDialog(._ => Dialog.Show)} />
        <Recent_View_List_DeleteBulkId_Dialog
          ids={manipulatedIds->Set.String.toArray}
          setIds={setManipulatedIds}
          connection={__id}
          show={isShowConfirmDialog}
          setShow={setIsShowConfirmDialog}
          selectedIdCount
          isAllSelected
          setIsAllSelected
        />
      </>
    }
  }
}

module View = {
  module PC = {
    @react.component
    let make = (~query, ~toEdit) => {
      let loadMoreRef = React.useRef(Js.Nullable.null)
      let {data: {viewedProducts, viewedProductCount}, hasNext, loadNext} =
        query->Fragment.usePagination

      let isIntersecting = CustomHooks.IntersectionObserver.use(
        ~target=loadMoreRef,
        ~rootMargin="50px",
        ~thresholds=0.1,
        (),
      )

      React.useEffect1(_ => {
        if hasNext && isIntersecting {
          loadNext(~count=20, ())->ignore
        }
        None
      }, [hasNext, isIntersecting])

      let oldUI =
        <div className=%twc("overflow-hidden h-full gap-1 flex flex-col overflow-y-hidden")>
          <Header itemAmount={viewedProductCount} />
          {switch viewedProducts.edges {
          | [] => <NoItems />
          | edges =>
            <>
              <div
                className=%twc(
                  "flex py-5 mx-7 gap-[6px] justify-end items-center h-16 border-b-[1px] border-gray-100"
                )>
                {switch viewedProductCount {
                | totalCount if totalCount < 50 =>
                  <div className=%twc("text-gray-500 text-sm flex-1")>
                    {`최대 50개`->React.string}
                  </div>
                | _ => React.null
                }}
                <button
                  className=%twc(
                    "text-gray-700 text-sm bg-gray-100 rounded-lg px-3 py-1.5 hover:bg-gray-200 transition-colors"
                  )
                  onClick={_ => toEdit()}>
                  {`편집`->React.string}
                </button>
              </div>
              <div className=%twc("flex flex-col gap-5 h-full overflow-y-scroll flex-1 mt-2")>
                {edges
                ->groupByDate
                ->Array.map(((date, chunkEdges)) =>
                  <div className=%twc("flex flex-col gap-2") key={`${date}-recent-view-view-chunk`}>
                    <div className=%twc("text-[15px] text-gray-900 font-bold px-7 my-4")>
                      {date->React.string}
                    </div>
                    {chunkEdges
                    ->Array.map(({cursor, node: {number, fragmentRefs}}) => {
                      <Like_Recent_List_Item.View
                        query=fragmentRefs key={`${cursor}-recent-view`} pid=number
                      />
                    })
                    ->React.array}
                    <div className=%twc("h-[10px] w-full bg-slate-50") />
                  </div>
                )
                ->React.array}
                <div ref={ReactDOM.Ref.domRef(loadMoreRef)} className=%twc("h-5 w-full ") />
              </div>
            </>
          }}
        </div>

      <FeatureFlagWrapper featureFlag=#HOME_UI_UX fallback=oldUI>
        <div className=%twc("h-full flex flex-col")>
          {switch viewedProducts.edges->groupByDate->List.fromArray {
          | list{} =>
            <div
              className=%twc(
                "bg-white mb-5 shadow-[0px_10px_40px_10px_rgba(0,0,0,0.03)] h-[720px] rounded-sm flex flex-col"
              )>
              <Header itemAmount={viewedProductCount} />
              <NoItems />
            </div>
          | list{(date, chunkEdges), ...rest} =>
            <>
              <div className=%twc("bg-white mb-5 shadow-[0px_10px_40px_10px_rgba(0,0,0,0.03)]")>
                <Header itemAmount={viewedProductCount} />
                <div
                  className=%twc(
                    "flex py-5 mx-[50px] gap-[6px] justify-end items-center h-16 border-b-[1px] border-gray-100 "
                  )>
                  {switch viewedProductCount {
                  | totalCount if totalCount < 50 =>
                    <div className=%twc("text-gray-500 text-sm flex-1")>
                      {`최대 50개`->React.string}
                    </div>
                  | _ => React.null
                  }}
                  <button
                    className=%twc(
                      "text-gray-700 text-sm bg-gray-100 rounded-lg px-3 py-1.5 hover:bg-gray-200 transition-colors"
                    )
                    onClick={_ => toEdit()}>
                    {`편집`->React.string}
                  </button>
                </div>
                <div
                  className=%twc("flex flex-col gap-2  pb-5")
                  key={`${date}-recent-view-view-chunk`}>
                  <div className=%twc("text-[15px] text-gray-900 font-bold px-[50px] my-5")>
                    {date->React.string}
                  </div>
                  {chunkEdges
                  ->Array.map(({cursor, node: {number, fragmentRefs}}) => {
                    <Like_Recent_List_Item.View
                      query=fragmentRefs key={`${cursor}-recent-view`} pid=number
                    />
                  })
                  ->React.array}
                </div>
              </div>
              <div className=%twc("flex flex-col gap-5 h-full  flex-1")>
                {rest
                ->List.map(((date, chunkEdges)) =>
                  <div
                    className=%twc(
                      "flex flex-col gap-2 bg-white shadow-[0px_10px_40px_10px_rgba(0,0,0,0.03)] pb-5"
                    )
                    key={`${date}-recent-view-view-chunk`}>
                    <div className=%twc("text-[15px] text-gray-900 font-bold px-[50px] my-5")>
                      {date->React.string}
                    </div>
                    {chunkEdges
                    ->Array.map(({cursor, node: {number, fragmentRefs}}) => {
                      <Like_Recent_List_Item.View
                        query=fragmentRefs key={`${cursor}-recent-view`} pid=number
                      />
                    })
                    ->React.array}
                  </div>
                )
                ->List.toArray
                ->React.array}
                <div ref={ReactDOM.Ref.domRef(loadMoreRef)} className=%twc("h-5 w-full ") />
              </div>
            </>
          }}
        </div>
      </FeatureFlagWrapper>
    }
  }

  module MO = {
    @react.component
    let make = (~query, ~toEdit) => {
      let loadMoreRef = React.useRef(Js.Nullable.null)
      let {data: {viewedProducts, viewedProductCount}, hasNext, loadNext} =
        query->Fragment.usePagination

      let isIntersecting = CustomHooks.IntersectionObserver.use(
        ~target=loadMoreRef,
        ~rootMargin="50px",
        ~thresholds=0.1,
        (),
      )

      React.useEffect1(_ => {
        if hasNext && isIntersecting {
          loadNext(~count=20, ())->ignore
        }
        None
      }, [hasNext, isIntersecting])

      {
        switch viewedProducts.edges {
        | [] => <NoItems />
        | edges =>
          <>
            <div
              className=%twc(
                "flex flex-row-reverse w-full px-5 py-4 gap-[6px] justify-between items-center h-14 text-[15px] fixed bg-white z-[1]"
              )>
              <button className=%twc("text-green-gl") onClick={_ => toEdit()}>
                {`편집`->React.string}
              </button>
              {switch viewedProductCount {
              | totalCount if totalCount < 50 =>
                <div className=%twc("text-gray-500 text-sm")> {`최대 50개`->React.string} </div>
              | _ => React.null
              }}
            </div>
            <div className=%twc("w-full h-14") />
            <ol className=%twc("flex flex-col gap-1 h-full overflow-y-scroll flex-1")>
              {edges
              ->groupByDate
              ->Array.map(((date, chunkEdges)) =>
                <li
                  className=%twc(
                    "flex flex-col gap-2 border-b-[10px] last-of-type:border-b-0 border-gray-50 pb-3 pt-5"
                  )
                  key={`${date}-recent-view-view-chunk`}>
                  <div className=%twc("text-[15px] text-gray-900 font-bold ml-5")>
                    {date->React.string}
                  </div>
                  {chunkEdges
                  ->Array.map(({cursor, node: {number, fragmentRefs}}) => {
                    <Like_Recent_List_Item.View
                      query=fragmentRefs key={`${cursor}-recent-view`} pid=number
                    />
                  })
                  ->React.array}
                </li>
              )
              ->React.array}
              <div ref={ReactDOM.Ref.domRef(loadMoreRef)} className=%twc("h-5 w-full ") />
            </ol>
          </>
        }
      }
    }
  }
}

type mode = [
  | #VIEW
  | #EDIT
]

module PC = {
  @react.component
  let make = () => {
    let router = Next.Router.useRouter()
    let (isCsr, setIsCsr) = React.Uncurried.useState(_ => false)
    let {viewer} = Query.GetList.use(
      ~variables=Query.GetList.makeVariables(~count=20, ()),
      ~fetchPolicy=StoreAndNetwork,
      (),
    )

    let (kind, setkind) = React.Uncurried.useState(_ => #VIEW)

    React.useEffect0(_ => {
      setIsCsr(._ => true)
      None
    })

    React.useEffect1(_ => {
      let newQuery = router.query
      newQuery->Js.Dict.set("mode", (kind: mode :> string))
      router->Next.Router.replaceObj({
        pathname: router.pathname,
        query: newQuery,
      })
      None
    }, [kind])

    let oldUI = switch isCsr {
    | true =>
      switch viewer {
      | Some(viewer') =>
        switch kind {
        | #EDIT => <Edit.PC query=viewer'.fragmentRefs toView={_ => setkind(._ => #VIEW)} />
        | #VIEW => <View.PC toEdit={_ => setkind(._ => #EDIT)} query=viewer'.fragmentRefs />
        }

      | None => React.null
      }

    | false => React.null
    }

    <FeatureFlagWrapper featureFlag=#HOME_UI_UX fallback=oldUI>
      <div className=%twc("mx-16 my-10 min-w-[872px] max-w-[1280px] w-full h-fit")>
        {switch isCsr {
        | true =>
          switch viewer {
          | Some(viewer') =>
            switch kind {
            | #EDIT => <Edit.PC query=viewer'.fragmentRefs toView={_ => setkind(._ => #VIEW)} />
            | #VIEW => <View.PC toEdit={_ => setkind(._ => #EDIT)} query=viewer'.fragmentRefs />
            }

          | None => React.null
          }

        | false => React.null
        }}
      </div>
    </FeatureFlagWrapper>
  }
}

module MO = {
  @react.component
  let make = () => {
    let router = Next.Router.useRouter()
    let (isCsr, setIsCsr) = React.Uncurried.useState(_ => false)
    let {viewer} = Query.GetList.use(
      ~variables=Query.GetList.makeVariables(~count=20, ()),
      ~fetchPolicy=StoreAndNetwork,
      (),
    )
    let (kind, setkind) = React.Uncurried.useState(_ => #VIEW)

    React.useEffect0(_ => {
      setIsCsr(._ => true)
      None
    })

    React.useEffect1(_ => {
      let newQuery = router.query
      newQuery->Js.Dict.set("mode", (kind: mode :> string))
      router->Next.Router.replaceObj({
        pathname: router.pathname,
        query: newQuery,
      })
      None
    }, [kind])

    switch isCsr {
    | true =>
      switch viewer {
      | Some(viewer') =>
        switch kind {
        | #EDIT => <Edit.MO query=viewer'.fragmentRefs toView={_ => setkind(._ => #VIEW)} />
        | #VIEW => <View.MO toEdit={_ => setkind(._ => #EDIT)} query=viewer'.fragmentRefs />
        }

      | None => React.null
      }
    | false => React.null
    }
  }
}
