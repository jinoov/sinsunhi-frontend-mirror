@module("/public/assets/add-circle.svg")
external addCircle: string = "default"

module Fragment = %relay(`
  fragment PCInterestedProductMainBuyer_Fragment on Query
  @refetchable(queryName: "PCInterestedProductMainBuyerRefetchQuery")
  @argumentDefinitions(
    cursor: { type: "String", defaultValue: null }
    count: { type: "Int!" }
  ) {
    viewer {
      ...PCInterestedProductListBuyerFragment
        @arguments(count: $count, cursor: $cursor)
      likedProducts(
        first: $count
        after: $cursor
        orderBy: [
          { field: RFQ_DISPLAY_ORDER, direction: ASC_NULLS_FIRST }
          { field: LIKED_AT, direction: DESC }
        ]
        types: [MATCHING]
      ) {
        totalCount
      }
    }
  }
`)
module Query = %relay(`
  query PCInterestedProductMainBuyerQuery($cursor: String, $count: Int!) {
    ...PCInterestedProductMainBuyer_Fragment
      @arguments(cursor: $cursor, count: $count)
  }
`)

module Content = {
  @react.component
  let make = () => {
    let {fragmentRefs} = Query.use(
      ~variables={
        cursor: None,
        count: 20,
      },
      ~fetchPolicy=StoreAndNetwork,
      (),
    )
    let (data, refetch) = Fragment.useRefetchable(fragmentRefs)

    let {useRouter, replaceObj} = module(Next.Router)
    let isCsr = CustomHooks.useCsr()
    let router = useRouter()
    let isAddInterestedShown = router.query->Js.Dict.get("add-interested")->Option.isSome

    let (isShow, setIsShow) = React.Uncurried.useState(_ => isAddInterestedShown)

    let onClickHandle = () => {
      setIsShow(._ => true)
      let newQueryParam = router.query
      newQueryParam->Js.Dict.set("add-interested", "true")
      router->replaceObj({
        pathname: router.pathname,
        query: newQueryParam,
      })
    }

    let refetchQuery = _ => {
      refetch(
        ~variables={
          cursor: None,
          count: Some(20),
        },
        ~fetchPolicy=NetworkOnly,
        (),
      )->ignore
    }

    let onClose = _ => {
      setIsShow(._ => false)
      let newQueryParam =
        router.query
        ->Js.Dict.entries
        ->Array.keep(((key, _)) => key != "add-interested")
        ->Js.Dict.fromArray

      router->replaceObj({
        pathname: router.pathname,
        query: newQueryParam,
      })
      refetchQuery()
    }

    switch isCsr {
    | true =>
      <div>
        {switch data.viewer {
        | None =>
          <>
            <div className=%twc("px-4")>
              <h2 className=%twc("text-[19px] font-bold")> {"관심 상품"->React.string} </h2>
            </div>
          </>
        | Some(viewer') =>
          <>
            {switch viewer'.likedProducts.totalCount {
            | 0 =>
              <div className=%twc("px-4 text-[19px] font-bold h-[14] mb-1.5")>
                <h2> {`관심 상품`->React.string} </h2>
                <div className=%twc("text-[13px] text-[#8B8D94] mt-3 font-normal")>
                  {"추가한 상품의 정보를 알려드릴게요."->React.string}
                </div>
              </div>
            | n =>
              <div
                className=%twc(
                  "px-4 text-[19px] font-bold flex items-center justify-between h-[14] mb-1.5"
                )>
                <h2> {`관심 상품(${n->Int.toString})`->React.string} </h2>
                <Next.Link href="/buyer/me/interested" passHref=true>
                  <a
                    className=%twc(
                      "px-3 py-[6px] text-sm text-[#65666B] rounded-lg bg-[#F0F2F5] hover:bg-[#AEB0B5] font-bold active:bg-[#A7A9AF] ease-in-out duration-200"
                    )>
                    {"편집하기"->React.string}
                  </a>
                </Next.Link>
              </div>
            }}
            <PC_InterestedProduct_List_Buyer.Partial
              query={viewer'.fragmentRefs} limit={5} empty={React.null}
            />
            <button
              className=%twc(
                "flex items-center w-full interactable cursor-pointer rounded-lg hover:bg-[#FAFBFC] duration-200 ease-in-out p-4"
              )
              onClick={_ => onClickHandle()}>
              <img src=addCircle className=%twc("w-11 h-11") alt="" />
              <span className=%twc("text-[#8B8D94] ml-[14px]")>
                {"추가하기"->React.string}
              </span>
            </button>
            {switch viewer'.likedProducts.totalCount {
            | i if i > 5 =>
              <div className=%twc("px-4")>
                <Next.Link href="/buyer/me/interested">
                  <button
                    type_="button"
                    className=%twc(
                      "mt-4 rounded-lg py-2 text-center border border-[#DCDFE3] w-full interactable"
                    )>
                    {"더보기"->React.string}
                  </button>
                </Next.Link>
              </div>
            | _ => React.null
            }}
          </>
        }}
        <PC_InterestedProducts_Add_Buyer isShow onClose />
      </div>

    | false =>
      <>
        <div className=%twc("px-4")>
          <h2 className=%twc("text-[19px] font-bold")> {"관심 상품"->React.string} </h2>
        </div>
      </>
    }
  }
}

module Placeholder = {
  @react.component
  let make = () => {
    <div>
      {<>
        <div className=%twc("px-4 text-[19px] font-bold flex items-center justify-between")>
          <h2> {`관심 상품(  )`->React.string} </h2>
          <Next.Link href="/buyer/me/interested" passHref=true>
            <a
              className=%twc(
                "px-3 py-[6px] text-sm text-[#65666B] rounded-lg bg-[#F0F2F5] hover:bg-[#AEB0B5] font-bold active:bg-[#A7A9AF] ease-in-out duration-200"
              )>
              {"편집하기"->React.string}
            </a>
          </Next.Link>
        </div>
      </>}
    </div>
  }
}

@react.component
let make = () => {
  <React.Suspense fallback={<div />}>
    <Content />
  </React.Suspense>
}
