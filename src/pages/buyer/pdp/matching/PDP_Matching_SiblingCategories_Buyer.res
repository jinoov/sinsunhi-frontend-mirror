/*
 * 1. 컴포넌트 위치
 *    PDP > 매칭상품 > 모바일 > 상단 자매품종 셀렉터
 *
 * 2. 역할
 *    매칭 상품의 자매품종 셀렉터를 표현합니다.
 *
 */
module Fragment = %relay(`
  fragment PDPMatchingSiblingCategoriesBuyer_fragment on MatchingProduct {
    category {
      currentCategoryId: id
      parent {
        children {
          categoryId: id
          matchingProduct {
            ...PDPMatchingSiblingCategoriesBuyer_TabButton_fragment
          }
        }
      }
    }
  }
`)

type tabStatus =
  | Retired // 카테고리에 연결된 매칭상품이 판매종료
  | Selected // 현재 선택한 매칭상품
  | Selectable // 선택 가능한 매칭상품

module TabButton = {
  module Fragment = %relay(`
    fragment PDPMatchingSiblingCategoriesBuyer_TabButton_fragment on MatchingProduct {
      matchingProductId: number
      displayName
      status
      category {
        categoryId: id
        categoryName: name
        fullyQualifiedName {
          name
        }
      }
    }
  `)

  module ClickTabButtonGtm = {
    let make = (
      product: PDPMatchingSiblingCategoriesBuyer_TabButton_fragment_graphql.Types.fragment,
    ) => {
      let {matchingProductId, displayName, category: {fullyQualifiedName}} = product
      let categoryNames = fullyQualifiedName->Array.map(({name}) => name)

      {
        "event": "click_matching_kind", // 품종 탭 클릭 시
        "ecommerce": {
          "items": [
            {
              "item_id": matchingProductId->Int.toString, // 상품 코드
              "item_name": displayName, // 상품명
              "currency": "KRW", // 화폐 KRW 고정
              "item_category": categoryNames->Array.get(0)->Js.Nullable.fromOption, // 표준 카테고리 Depth 1
              "item_category2": categoryNames->Array.get(1)->Js.Nullable.fromOption, // 표준 카테고리 Depth 2
              "item_category3": categoryNames->Array.get(2)->Js.Nullable.fromOption, // 표준 카테고리 Depth 3
              "item_category4": categoryNames->Array.get(3)->Js.Nullable.fromOption, // 표준 카테고리 Depth 4
              "item_category5": categoryNames->Array.get(4)->Js.Nullable.fromOption, // 표준 카테고리 Depth 5
            },
          ],
        },
      }
    }
  }

  @react.component
  let make = (~id, ~query, ~currentCategoryId) => {
    let {useRouter, replace} = module(Next.Router)
    let router = useRouter()

    let product = query->Fragment.use
    let {matchingProductId, status, category: {categoryId, categoryName}} = product

    let tabStatus = switch status {
    | #RETIRE => Retired
    | _ if currentCategoryId == categoryId => Selected
    | _ => Selectable
    }

    switch tabStatus {
    // 판매 종료
    | Retired => React.null

    // 현재 선택된 품종
    | Selected =>
      let btnStyle = %twc(
        "mx-2 text-gray-800 border-b-[2px] border-gray-800 pt-2 pb-3 whitespace-nowrap font-bold"
      )
      <button id className=btnStyle disabled=true> {categoryName->React.string} </button>

    // 선택 가능한 품종
    | Selectable =>
      let btnStyle = %twc(
        "mx-2 text-gray-400 border-b-[2px] border-transparent pt-2 pb-3 whitespace-nowrap"
      )
      <button
        id
        onClick={_ => {
          {"ecommerce": Js.Nullable.null}->DataGtm.push
          product->ClickTabButtonGtm.make->DataGtm.mergeUserIdUnsafe->DataGtm.push
          router->replace(`/products/${matchingProductId->Int.toString}`)
        }}
        className=btnStyle>
        {categoryName->React.string}
      </button>
    }
  }
}

@react.component
let make = (~query) => {
  let direction = CustomHooks.Scroll.useScrollDirection()

  let {category: {currentCategoryId, parent}} = query->Fragment.use

  let siblings = parent->Option.mapWithDefault([], ({children}) => children)

  let foldableStyle = switch direction {
  | ScrollStop => %twc("top-14") // default
  | ScrollDown => %twc("top-0 ease-out duration-200")
  | ScrollUp => %twc("top-14 ease-out duration-200")
  }

  let scrollContainerId = "horizontal-scroll-container"
  let makeTabId = suffix => `display-category-${suffix}`

  // 선택된 카테고리를 센터에 위치하도록 하는 useEffect,
  // 추후 별도로 분리 예정
  React.useEffect2(() => {
    open Webapi
    let windowWidth = Dom.window->Dom.Window.innerWidth
    let container = Dom.document->Dom.Document.getElementById(scrollContainerId)
    let target = Dom.document->Dom.Document.getElementById(currentCategoryId->makeTabId)

    switch (container, target) {
    | (Some(container'), Some(target')) => {
        let targetWidth = target'->Dom.Element.clientWidth
        let targetLeft = switch target'->Dom.Element.asHtmlElement {
        | None => None
        | Some(target'') => Some(target''->Dom.HtmlElement.offsetLeft)
        }

        targetLeft
        ->Option.map(targetLeft' => {
          container'->Dom.Element.setScrollLeft(
            (targetLeft' - windowWidth / 2 + targetWidth / 2)->Int.toFloat,
          )
        })
        ->ignore
      }

    | _ => ()
    }

    None
  }, (currentCategoryId, siblings))

  <>
    // Horizontal Scroll
    <div className={%twc("w-full fixed z-[5] bg-white left-0 ") ++ foldableStyle}>
      <section className={%twc("w-full max-w-3xl mx-auto bg-white border-b border-gray-50")}>
        <ol
          id=scrollContainerId
          className=%twc("overflow-x-scroll scrollbar-hide flex items-center px-2")>
          {siblings
          ->Array.map(({categoryId, matchingProduct}) => {
            switch matchingProduct {
            | None => React.null
            | Some({fragmentRefs}) =>
              let id = categoryId->makeTabId
              <TabButton key=id id query=fragmentRefs currentCategoryId />
            }
          })
          ->React.array}
        </ol>
      </section>
    </div>
    // Placeholder
    <div className=%twc("w-full h-10") />
  </>
}
