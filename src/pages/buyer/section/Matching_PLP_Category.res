module Query = %relay(`
  query MatchingPLPCategoryQuery($parentId: ID) {
    section(type: MATCHING) {
      displayCategories(
        onlyHasBuyableProducts: true
        onlyDisplayable: true
        parentId: $parentId
        orderBy: [{ buyableProductsCount: DESC }, { id: ASC }]
      ) {
        id
        name
      }
    }
  }
`)

module ListItem = {
  type kind =
    | All
    | Specific
  type t = {
    name: string,
    id: string,
    kind: kind,
  }
  let make = (id, name) => {
    id: id,
    name: name,
    kind: All,
  }
  let fromQuery = (
    query: MatchingPLPCategoryQuery_graphql.Types.response_section_displayCategories,
  ) => {id: query.id, name: query.name, kind: Specific}

  module PC = {
    module Skeleton = {
      @react.component
      let make = () => {
        <div className=%twc("skeleton-base w-16 mt-2 mb-3 rounded h-6") />
      }
    }
  }
}

module PC = {
  module View = {
    @react.component
    let make = (~items: array<ListItem.t>) => {
      let router = Next.Router.useRouter()
      let subCategoryId = router.query->Js.Dict.get("sub-category-id")
      let categoryId = router.query->Js.Dict.get("category-id")

      let direction = CustomHooks.Scroll.useScrollDirection()
      let foldableStyle = switch direction {
      | ScrollStop => %twc("top-14") // default
      | ScrollDown => %twc("top-0 ease-out duration-200")
      | ScrollUp => %twc("top-14 ease-out duration-200")
      }

      React.useEffect1(() => {
        open Webapi
        let windowWidth = Dom.window->Dom.Window.innerWidth
        let container = Dom.document->Dom.Document.getElementById("horizontal-scroll-container")
        let target =
          Dom.document->Dom.Document.getElementById(
            `category-${subCategoryId->Option.getWithDefault("")}`,
          )

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
      }, [subCategoryId])

      <div
        className={Cn.make([%twc("w-full z-[5] bg-white left-0 cursor-pointer"), foldableStyle])}>
        <section className={%twc("w-[1280px] mx-auto bg-white border-b border-gray-50 ")}>
          <ol
            id="horizontal-scroll-container"
            className=%twc("overflow-x-scroll scrollbar-hide flex items-center px-2 gap-4")>
            {items
            ->Array.map(item => {
              let baseStyle = %twc("pt-2 pb-3 border-b-2 w-fit whitespace-nowrap")
              let selectedStyle = switch (item.kind, subCategoryId) {
              | (All, None) =>
                item.id == categoryId->Option.getWithDefault("")
                  ? %twc("border-gray-800 text-gray-800 font-bold")
                  : %twc("border-transparent text-gray-400")
              | (All, Some(_)) => %twc("border-transparent text-gray-400")
              | (Specific, Some(subCategoryId)) =>
                item.id == subCategoryId
                  ? %twc("border-gray-800 text-gray-800 font-bold")
                  : %twc("border-transparent text-gray-400")
              | (Specific, None) => %twc("border-transparent text-gray-400")
              }

              let query = switch item.kind {
              | All =>
                `/buyer/matching/products?category-id=${categoryId->Option.getWithDefault("")}`
              | Specific =>
                `/buyer/matching/products?category-id=${categoryId->Option.getWithDefault(
                    "",
                  )}&sub-category-id=${item.id}`
              }
              <li
                key={item.id}
                id={`category-${item.id}`}
                onClick={_ => Next.Router.replace(router, query)}>
                <div className={Cn.make([selectedStyle, baseStyle])}>
                  {item.name->React.string}
                </div>
              </li>
            })
            ->React.array}
          </ol>
        </section>
      </div>
    }
  }
  module Skeleton = {
    @react.component
    let make = () => {
      <>
        <div className=%twc("h-11 px-5 scrollbar-hide")>
          <div className=%twc("flex gap-4 h-full")>
            {Array.range(0, 3)
            ->Array.map(idx => <ListItem.PC.Skeleton key={idx->Int.toString} />)
            ->React.array}
          </div>
        </div>
        <Divider className=%twc("mt-0 bg-gray-50") />
      </>
    }
  }
  @react.component
  let make = (~categoryName) => {
    let router = Next.Router.useRouter()
    let displayCategoryId = router.query->Js.Dict.get("category-id")
    let {section} = Query.use(~variables={parentId: displayCategoryId}, ())

    let items =
      section
      ->Option.map(section' =>
        [ListItem.make(displayCategoryId->Option.getWithDefault(""), categoryName)]->Array.concat(
          section'.displayCategories->Array.map(ListItem.fromQuery),
        )
      )
      ->Option.getWithDefault([])

    <React.Suspense fallback={<Skeleton />}> <View items /> </React.Suspense>
  }
}

module MO = {
  module View = {
    @react.component
    let make = (~items: array<ListItem.t>) => {
      let router = Next.Router.useRouter()
      let subCategoryId = router.query->Js.Dict.get("sub-category-id")
      let categoryId = router.query->Js.Dict.get("category-id")

      let direction = CustomHooks.Scroll.useScrollDirection()
      let foldableStyle = switch direction {
      | ScrollStop => %twc("top-14") // default
      | ScrollDown => %twc("top-0 ease-out duration-200")
      | ScrollUp => %twc("top-14 ease-out duration-200")
      }

      React.useEffect1(() => {
        open Webapi
        let windowWidth = Dom.window->Dom.Window.innerWidth
        let container = Dom.document->Dom.Document.getElementById("horizontal-scroll-container")
        let target =
          Dom.document->Dom.Document.getElementById(
            `category-${subCategoryId->Option.getWithDefault("")}`,
          )

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
      }, [subCategoryId])

      <div className={Cn.make([%twc("w-full z-[5] bg-white left-0"), foldableStyle])}>
        <section className={%twc("w-full max-w-3xl mx-auto bg-white border-b border-gray-50 ")}>
          <ol
            id="horizontal-scroll-container"
            className=%twc("overflow-x-scroll scrollbar-hide flex items-center px-4 gap-4")>
            {items
            ->Array.map(item => {
              let baseStyle = %twc("pt-2 pb-3 border-b-2 w-fit whitespace-nowrap")
              let selectedStyle = switch (item.kind, subCategoryId) {
              | (All, None) =>
                item.id == categoryId->Option.getWithDefault("")
                  ? %twc("border-gray-800 text-gray-800 font-bold")
                  : %twc("border-transparent text-gray-400")
              | (All, Some(_)) => %twc("border-transparent text-gray-400")
              | (Specific, Some(subCategoryId)) =>
                item.id == subCategoryId
                  ? %twc("border-gray-800 text-gray-800 font-bold")
                  : %twc("border-transparent text-gray-400")
              | (Specific, None) => %twc("border-transparent text-gray-400")
              }
              let query = switch item.kind {
              | All =>
                `/buyer/matching/products?category-id=${categoryId->Option.getWithDefault("")}`
              | Specific =>
                `/buyer/matching/products?category-id=${categoryId->Option.getWithDefault(
                    "",
                  )}&sub-category-id=${item.id}`
              }
              <li
                key={item.id}
                id={`category-${item.id}`}
                onClick={_ => Next.Router.replace(router, query)}>
                <div className={selectedStyle ++ " " ++ baseStyle}> {item.name->React.string} </div>
              </li>
            })
            ->React.array}
          </ol>
        </section>
      </div>
    }
  }
  module Skeleton = {
    @react.component
    let make = () => {
      <>
        <section className=%twc("h-11 px-2 scrollbar-hide w-full overflow-x-scroll")>
          <ol className=%twc("w-fit flex items-center gap-2")>
            {Array.range(0, 8)
            ->Array.map(idx =>
              <div
                className=%twc("skeleton-base mt-2 mb-3 rounded h-6 w-16") key={idx->Int.toString}
              />
            )
            ->React.array}
          </ol>
        </section>
        <Divider className=%twc("mt-0 bg-gray-50") />
      </>
    }
  }
  @react.component
  let make = (~categoryName) => {
    let router = Next.Router.useRouter()
    let displayCategoryId = router.query->Js.Dict.get("category-id")
    let {section} = Query.use(~variables={parentId: displayCategoryId}, ())

    let items =
      section
      ->Option.map(section' =>
        [ListItem.make(displayCategoryId->Option.getWithDefault(""), categoryName)]->Array.concat(
          section'.displayCategories->Array.map(ListItem.fromQuery),
        )
      )
      ->Option.getWithDefault([])

    <React.Suspense fallback={<Skeleton />}> <View items /> </React.Suspense>
  }
}
