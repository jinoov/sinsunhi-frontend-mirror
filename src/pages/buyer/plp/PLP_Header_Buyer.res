/*
 * 1. 컴포넌트 위치
 *    PLP (전시 카테고리 내 상품 리스트 페이지) 헤더
 *
 * 2. 역할
 *    쿼리 파라메터로 전달된 display-category-id 또는 `/categories/[cid]`를 활용하여, 전시 카테고리 이름을 조회, Gnb에 표현합니다
 *
 */

@module("../../../../public/assets/arrow-left-line.svg")
external arrowLeftLineIcon: string = "default"
module DisplayCategoryName = {
  module Query = %relay(`
    query PLPHeaderBuyerQuery($displayCategoryId: ID!) {
      node(id: $displayCategoryId) {
        ... on DisplayCategory {
          parent {
            name
          }
          id
          name
          children {
            id
          }
        }
      }
    }
  `)

  @react.component
  let make = (~displayCategoryId) => {
    let {node} = Query.use(~variables=Query.makeVariables(~displayCategoryId), ())

    let title = switch node {
    | None => ""
    | Some(node) =>
      switch node.children {
      | [] => node.parent->Option.mapWithDefault(node.name, parent => parent.name)
      | _ => node.name
      }
    }

    <span className=%twc("font-bold text-xl")> {title->React.string} </span>
  }
}

@react.component
let make = () => {
  let router = Next.Router.useRouter()
  let displayCategoryId = switch router.query->Js.Dict.get("cid") {
  | Some(_) as cid => cid
  | None => router.query->Js.Dict.get("category-id")
  }

  let (isCsr, setIsCsr) = React.Uncurried.useState(_ => false)

  React.useEffect0(() => {
    setIsCsr(._ => true)
    None
  })

  <>
    // position fixed
    <div className=%twc("w-full fixed top-0 left-0 z-10 bg-white")>
      <header className=%twc("w-full max-w-3xl mx-auto h-14 bg-white")>
        <div className=%twc("px-5 py-4 flex w-full items-center justify-between")>
          <div className=%twc("flex-1 flex justify-start")>
            <button onClick={_ => router->Next.Router.back}>
              <img src=arrowLeftLineIcon className=%twc("w-6 h-6") />
            </button>
          </div>
          {switch isCsr {
          | false => <span />
          | true =>
            switch displayCategoryId {
            // 전체 상품 리스트
            | None =>
              <>
                <div className=%twc("flex-1 flex justify-center")>
                  <span className=%twc("font-bold text-xl")> {`전체 상품`->React.string} </span>
                </div>
                <div className=%twc("flex-1 flex justify-end gap-2")>
                  <CartLinkIcon />
                </div>
              </>
            // 특정 전시카테고리 내 상품 리스트
            | Some(displayCategoryId') =>
              <RescriptReactErrorBoundary fallback={_ => <span />}>
                <div className=%twc("flex-1 flex justify-center min-w-fit")>
                  <React.Suspense fallback={<span />}>
                    <DisplayCategoryName displayCategoryId=displayCategoryId' />
                  </React.Suspense>
                </div>
                <div className=%twc("flex-1 flex justify-end gap-2")>
                  <CartLinkIcon />
                </div>
              </RescriptReactErrorBoundary>
            }
          }}
        </div>
      </header>
    </div>
    // placeholder
    <div className=%twc("w-full h-14") />
  </>
}
