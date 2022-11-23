module Query = {
  module GetList = %relay(`
    query LikeList_GetList_Query($cursor: String, $count: Int!) {
      viewer {
        ...LikeList_Fragment @arguments(count: $count, cursor: $cursor)
      }
    }
`)
}

module Fragment = %relay(`
  fragment LikeList_Fragment on User
  @refetchable(queryName: "LikeListGetListRefetchQuery")
  @argumentDefinitions(cursor: { type: "String" }, count: { type: "Int!" }) {
    likedProductCount
    likedProducts(
      first: $count
      after: $cursor
      orderBy: [{ field: LIKED_AT, direction: DESC }]
    ) @connection(key: "LikeList_likedProducts") {
      __id
      edges {
        likedAt # 찜한 시각(UTC)
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
    //헤더와 BNB 영역의 높이를 뺸 위치
    <div className=%twc("flex flex-col gap-5 h-[calc(100vh-170px)] overflow-y-scroll flex-1 mt-2")>
      <div
        className=%twc(
          "text-center text-gray-500 flex flex-col justify-center items-center flex-1 whitespace-pre gap-1.5"
        )>
        <span className=%twc("text-lg text-gray-800")>
          {`찜한 상품이 없어요.`->React.string}
        </span>
        {`마음에 드는 상품을 찜해두면 저장된 상품에서\n편하게 확인하고 관리할 수 있어요.`->React.string}
      </div>
    </div>
  }
}

module Header = {
  @react.component
  let make = (~itemAmount) => {
    let oldUI =
      <div className=%twc("flex font-bold pt-8 px-7 pb-3 items-center gap-[6px]")>
        <span className=%twc("text-2xl text-gray-900 ")> {`찜한 상품`->React.string} </span>
        <span
          className=%twc(
            "leading-[12px] py-[2px] px-[6px] rounded-xl bg-gray-150 text-xs align-middle"
          )>
          {`${itemAmount->Int.toString}`->React.string}
        </span>
      </div>

    <FeatureFlagWrapper featureFlag=#HOME_UI_UX fallback=oldUI>
      <div
        className=%twc(
          "flex font-bold pt-8 px-7 pb-3 items-center gap-[6px] lg:pt-10 lg:px-[50px]"
        )>
        <span className=%twc("text-2xl text-gray-900 ")> {`찜한 상품`->React.string} </span>
        <span
          className=%twc(
            "leading-[12px] py-[2px] px-[6px] rounded-xl bg-gray-150 text-xs align-middle"
          )>
          {`${itemAmount->Int.toString}`->React.string}
        </span>
      </div>
    </FeatureFlagWrapper>
  }
}

module Edit = {
  module PC = {
    @react.component
    let make = (~query, ~toView=?) => {
      let {data: {likedProducts, likedProductCount}, hasNext, loadNext} =
        query->Fragment.usePagination
      let {__id} = likedProducts
      let loadMoreRef = React.useRef(Js.Nullable.null)

      //전체 선택 토글이 활성화 되었는지 여부
      let (isAllSelected, setIsAllSelected) = React.Uncurried.useState(_ => false)
      //사용자가 전체 토글을 조작한 후에 개별적으로 조작한 항목들
      let (manipulatedIds, setManipulatedIds) = React.Uncurried.useState(_ => Set.String.empty)

      //실제로 선택된 것으로 활성화된 id 수
      let selectedIdCount = switch isAllSelected {
      | true => likedProductCount - manipulatedIds->Set.String.size
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
        if manipulatedIds->Set.String.size == likedProductCount {
          setIsAllSelected(.prev => !prev)
          setManipulatedIds(._ => Set.String.empty)
        }

        None
      }, (manipulatedIds, likedProductCount))

      let onSelectAllCheck = e => {
        setManipulatedIds(._ => Set.String.empty)
        setIsAllSelected(._ => (e->ReactEvent.Synthetic.target)["checked"])
      }

      let oldUI =
        <>
          <div className=%twc("flex flex-col flex-1 overflow-y-hidden gap-1 h-full")>
            <Header itemAmount={likedProductCount} />
            {switch likedProducts.edges {
            | [] => <NoItems />
            | edges =>
              // <div className=%twc("flex flex-col flex-1 overflow-hidden h-full")>
              <>
                <div
                  className=%twc(
                    "flex pt-[18px] pb-[14px] gap-[6px] justify-between items-center h-16 border-b-[1px] border-gray-100 mx-7"
                  )>
                  <div className=%twc("flex gap-[6px] items-center justify-start")>
                    <Checkbox
                      id="likelist-all-select" checked=isAllSelected onChange={onSelectAllCheck}
                    />
                    <span className=%twc("text-sm text-gray-500 leading-3")>
                      {`전체선택`->React.string}
                    </span>
                  </div>
                  {switch toView {
                  | Some(toView') =>
                    <div className=%twc("inline-flex gap-2")>
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
                <div className=%twc("flex flex-col flex-1 w-full gap-1 overflow-y-scroll mt-2")>
                  {<>
                    {edges
                    ->Array.map(({cursor, node: {id, fragmentRefs}}) => {
                      <Like_Recent_List_Item.Edit
                        query={fragmentRefs}
                        isChecked={manipulatedIds->Belt.Set.String.has(id) != isAllSelected}
                        onClick={_ => onChangeItem(id)}
                        key={`${cursor}-like-edit`}
                      />
                    })
                    ->React.array}
                    <div ref={ReactDOM.Ref.domRef(loadMoreRef)} className=%twc("h-5 w-full") />
                  </>}
                </div>
                // </div>
              </>
            }}
          </div>
          <Like_List_DeleteBulkId_Dialog
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
          <div className=%twc("flex flex-col flex-1 overflow-y-hidden gap-1 min-h-[720px]")>
            <Header itemAmount={likedProductCount} />
            {switch likedProducts.edges {
            | [] => <NoItems />
            | edges =>
              // <div className=%twc("flex flex-col flex-1 overflow-hidden h-full")>
              <>
                <div
                  className=%twc(
                    "flex pt-[18px] pb-[14px] mx-[50px] gap-[6px] justify-between items-center h-16 border-b-[1px] border-gray-100"
                  )>
                  <div className=%twc("flex gap-[6px] items-center justify-start")>
                    <Checkbox
                      id="likelist-all-select" checked=isAllSelected onChange={onSelectAllCheck}
                    />
                    <span className=%twc("text-sm text-gray-500 leading-3")>
                      {`전체선택`->React.string}
                    </span>
                  </div>
                  {switch toView {
                  | Some(toView') =>
                    <div className=%twc("inline-flex gap-2")>
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
                <div className=%twc("flex flex-col flex-1 w-full gap-1 overflow-y-scroll mt-2")>
                  {<>
                    {edges
                    ->Array.map(({cursor, node: {id, fragmentRefs}}) => {
                      <Like_Recent_List_Item.Edit
                        query={fragmentRefs}
                        isChecked={manipulatedIds->Belt.Set.String.has(id) != isAllSelected}
                        onClick={_ => onChangeItem(id)}
                        key={`${cursor}-like-edit`}
                      />
                    })
                    ->React.array}
                    <div ref={ReactDOM.Ref.domRef(loadMoreRef)} className=%twc("h-5 w-full") />
                  </>}
                </div>
                // </div>
              </>
            }}
          </div>
          <Like_List_DeleteBulkId_Dialog
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
              "border-t-[1px] p-4 pb-5 fixed bottom-0 max-w-[768px] mx-auto border-t-gray-100 bg-white w-full "
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
      let {data: {likedProducts, likedProductCount}, hasNext, loadNext} =
        query->Fragment.usePagination
      let {__id} = likedProducts
      let loadMoreRef = React.useRef(Js.Nullable.null)

      //전체 선택 토글이 활성화 되었는지 여부
      let (isAllSelected, setIsAllSelected) = React.Uncurried.useState(_ => false)
      //사용자가 전체 토글을 조작한 후에 개별적으로 조작한 항목들
      let (manipulatedIds, setManipulatedIds) = React.Uncurried.useState(_ => Set.String.empty)

      //실제로 선택된 것으로 활성화된 id 수
      let selectedIdCount = switch isAllSelected {
      | true => likedProductCount - manipulatedIds->Set.String.size
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
        if manipulatedIds->Set.String.size == likedProductCount {
          setIsAllSelected(.prev => !prev)
          setManipulatedIds(._ => Set.String.empty)
        }

        None
      }, (manipulatedIds, likedProductCount))

      let onSelectAllCheck = e => {
        setManipulatedIds(._ => Set.String.empty)
        setIsAllSelected(._ => (e->ReactEvent.Synthetic.target)["checked"])
      }

      <>
        {switch likedProducts.edges {
        | [] => <NoItems />
        | edges =>
          <>
            <div
              className=%twc(
                "flex w-full px-5 py-4 gap-[6px] justify-between items-center h-14 text-[15px] fixed bg-white z-[1]"
              )>
              <div className=%twc("flex gap-[6px] items-center justify-start")>
                <Checkbox
                  id="likelist-all-select" checked=isAllSelected onChange={onSelectAllCheck}
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
              className=%twc("flex flex-col gap-1 h-full overflow-y-scroll flex-1")
              ref={ReactDOM.Ref.domRef(scrollContainer)}>
              {<>
                {edges
                ->Array.map(({cursor, node: {id, fragmentRefs}}) => {
                  <Like_Recent_List_Item.Edit
                    query=fragmentRefs
                    isChecked={manipulatedIds->Belt.Set.String.has(id) != isAllSelected}
                    onClick={_ => onChangeItem(id)}
                    key={`${cursor}-like-edit`}
                  />
                })
                ->React.array}
                <div ref={ReactDOM.Ref.domRef(loadMoreRef)} className=%twc("h-5 w-full") />
              </>}
            </div>
          </>
        }}
        <CTAContainer selectedIdCount onClick={_ => setIsShowConfirmDialog(._ => Dialog.Show)} />
        <Like_List_DeleteBulkId_Dialog
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
      let {data: {likedProducts, likedProductCount}, hasNext, loadNext} =
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
          <Header itemAmount={likedProductCount} />
          {switch likedProducts.edges {
          | [] => <NoItems />
          | edges =>
            <>
              <div
                className=%twc(
                  "flex pt-[18px] pb-[14px] mx-7 gap-[6px] justify-end items-center h-16 border-b-[1px] border-gray-100"
                )>
                <button
                  className=%twc(
                    "text-gray-700 text-sm bg-gray-100 rounded-lg px-3 py-1.5 hover:bg-gray-200 transition-colors"
                  )
                  onClick={_ => toEdit()}>
                  {`편집`->React.string}
                </button>
              </div>
              <div className=%twc("flex flex-col gap-1 h-full overflow-y-scroll flex-1 mt-2")>
                {edges
                ->Array.map(({cursor, node: {number, fragmentRefs}}) =>
                  <Like_Recent_List_Item.View
                    query=fragmentRefs key={`${cursor}-like`} pid=number
                  />
                )
                ->React.array}
                <div ref={ReactDOM.Ref.domRef(loadMoreRef)} className=%twc("h-5 w-full ") />
              </div>
            </>
          }}
        </div>

      <FeatureFlagWrapper featureFlag=#HOME_UI_UX fallback=oldUI>
        <div className=%twc("overflow-hidden gap-1 flex flex-col overflow-y-hidden min-h-[720px]")>
          <Header itemAmount={likedProductCount} />
          {switch likedProducts.edges {
          | [] => <NoItems />
          | edges =>
            <>
              <div
                className=%twc(
                  "flex pt-[18px] pb-[14px] mx-[50px] gap-[6px] justify-end items-center h-16 border-b-[1px] border-gray-100"
                )>
                <button
                  className=%twc(
                    "text-gray-700 text-sm bg-gray-100 rounded-lg px-3 py-1.5 hover:bg-gray-200 transition-colors"
                  )
                  onClick={_ => toEdit()}>
                  {`편집`->React.string}
                </button>
              </div>
              <div className=%twc("flex flex-col gap-1 h-full overflow-y-scroll flex-1 mt-2")>
                {edges
                ->Array.map(({cursor, node: {number, fragmentRefs}}) =>
                  <Like_Recent_List_Item.View
                    query=fragmentRefs key={`${cursor}-like`} pid=number
                  />
                )
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
      let {data: {likedProducts}, hasNext, loadNext} = query->Fragment.usePagination

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
        switch likedProducts.edges {
        | [] => <NoItems />
        | edges =>
          <>
            <div
              className=%twc(
                "flex w-full px-5 py-4 gap-[6px] justify-end items-center h-14 text-[15px] fixed bg-white z-[1]"
              )>
              <button className=%twc("text-green-gl") onClick={_ => toEdit()}>
                {`편집`->React.string}
              </button>
            </div>
            <div className=%twc("w-full h-14") />
            <div className=%twc("flex flex-col gap-1 h-full overflow-y-scroll flex-1")>
              {edges
              ->Array.map(({cursor, node: {number, fragmentRefs}}) =>
                <Like_Recent_List_Item.View query=fragmentRefs key={`${cursor}-like`} pid=number />
              )
              ->React.array}
              <div ref={ReactDOM.Ref.domRef(loadMoreRef)} className=%twc("h-5 w-full") />
            </div>
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
      <div
        className=%twc(
          "mx-16 my-10  rounded-sm bg-white shadow-[0px_10px_40px_10px_rgba(0,0,0,0.03)] min-w-[872px] max-w-[1280px] w-full h-fit"
        )>
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
