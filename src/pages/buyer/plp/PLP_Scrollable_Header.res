module Query = %relay(`
  query PLPScrollableHeaderQuery($parentId: ID!) {
    node(id: $parentId) {
      ... on DisplayCategory {
        type_: type
        parent {
          id
          name
          children(orderBy: [{ buyableProductsCount: DESC }]) {
            id
            name
          }
        }
        id
        name
        children(orderBy: [{ buyableProductsCount: DESC }]) {
          id
          name
        }
      }
    }
  }
`)

module PC = {
  module ScrollTab = {
    @react.component
    let make = (~items: array<PLP_Scrollable_Tab_Item.Data.t>) => {
      let router = Next.Router.useRouter()
      let categoryId = switch router.query->Js.Dict.get("cid") {
      | Some(_) as cid => cid
      | None => router.query->Js.Dict.get("category-id")
      }

      React.useEffect1(() => {
        open Webapi
        let windowWidth = Dom.window->Dom.Window.innerWidth
        let container = Dom.document->Dom.Document.getElementById("horizontal-scroll-container")
        let target =
          Dom.document->Dom.Document.getElementById(
            `category-${categoryId->Option.getWithDefault("")}`,
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
      }, [categoryId])

      <section className={%twc("w-full mx-auto bg-white border-b border-gray-50 ")}>
        <ol
          id="horizontal-scroll-container"
          className=%twc("overflow-x-scroll scrollbar-hide flex items-center px-2 gap-4")>
          {items
          ->Array.map(item => {
            <PLP_Scrollable_Tab_Item.PC
              item selected={item.id == categoryId->Option.getWithDefault("")} key=item.id
            />
          })
          ->React.array}
        </ol>
      </section>
    }
  }
  module Skeleton = {
    @react.component
    let make = () => {
      <>
        <div className=%twc("inline-flex flex-col w-full")>
          <div className=%twc("w-[160px] h-6 rounded-lg animate-pulse bg-gray-150 mb-9") />
          <div className=%twc("h-12 px-5 scrollbar-hide border-b border-gray-50")>
            <div className=%twc("flex gap-4 h-full")>
              {Array.range(0, 10)
              ->Array.map(idx => <PLP_Scrollable_Tab_Item.PC.Skeleton key={idx->Int.toString} />)
              ->React.array}
            </div>
          </div>
        </div>
      </>
    }
  }
  @react.component
  let make = (~parentId) => {
    let {node} = Query.use(~variables=Query.makeVariables(~parentId), ())
    switch node {
    | Some(node') => {
        let (firstNodeId, restItem, title, showScrollableTab) = switch (
          node'.type_,
          node'.children,
        ) {
        | (#NORMAL, []) => {
            let parentNode = node'.parent
            let id = parentNode->Option.mapWithDefault("", parentNode' => parentNode'.id)
            let name = parentNode->Option.mapWithDefault("", parentNode' => parentNode'.name)

            let restItem =
              parentNode
              ->Option.mapWithDefault([], parentNode' => parentNode'.children)
              ->Array.map(item =>
                PLP_Scrollable_Tab_Item.Data.make(
                  ~id=item.id,
                  ~name=item.name,
                  ~kind=PLP_Scrollable_Tab_Item.Data.Specific,
                )
              )
            (id, restItem, name, true)
          }

        | (#SHOWCASE, []) => {
            let parentNode = node'.parent
            let id = parentNode->Option.mapWithDefault("", parentNode' => parentNode'.id)
            let name = node'.name

            let restItem =
              parentNode
              ->Option.mapWithDefault([], parentNode' => parentNode'.children)
              ->Array.map(item =>
                PLP_Scrollable_Tab_Item.Data.make(
                  ~id=item.id,
                  ~name=item.name,
                  ~kind=PLP_Scrollable_Tab_Item.Data.Specific,
                )
              )
            (id, restItem, name, false)
          }

        | (_, children) => {
            let id = node'.id
            let name = node'.name

            let restItem =
              children->Array.map(item =>
                PLP_Scrollable_Tab_Item.Data.make(
                  ~id=item.id,
                  ~name=item.name,
                  ~kind=PLP_Scrollable_Tab_Item.Data.Specific,
                )
              )
            (id, restItem, name, true)
          }
        }

        let firstItem = PLP_Scrollable_Tab_Item.Data.make(
          ~id=firstNodeId,
          ~name=`${title} 전체`,
          ~kind=PLP_Scrollable_Tab_Item.Data.All,
        )

        let items =
          [firstItem]->Array.concat(
            restItem->Array.map(item =>
              PLP_Scrollable_Tab_Item.Data.make(
                ~id=item.id,
                ~name=item.name,
                ~kind=PLP_Scrollable_Tab_Item.Data.Specific,
              )
            ),
          )

        <React.Suspense fallback={<Skeleton />}>
          <div className=%twc("inline-flex flex-col w-full")>
            <div className=%twc("font-bold text-3xl text-gray-800 mb-[29px]")>
              {title->React.string}
            </div>
            {switch showScrollableTab {
            | true => <ScrollTab items />
            | false => React.null
            }}
          </div>
        </React.Suspense>
      }

    | None => <Skeleton />
    }
  }
}

module MO = {
  module View = {
    @react.component
    let make = (~items: array<PLP_Scrollable_Tab_Item.Data.t>) => {
      let router = Next.Router.useRouter()
      let categoryId = switch router.query->Js.Dict.get("cid") {
      | Some(_) as cid => cid
      | None => router.query->Js.Dict.get("category-id")
      }

      React.useEffect1(() => {
        open Webapi
        let windowWidth = Dom.window->Dom.Window.innerWidth
        let container = Dom.document->Dom.Document.getElementById("horizontal-scroll-container")
        let target =
          Dom.document->Dom.Document.getElementById(
            `category-${categoryId->Option.getWithDefault("")}`,
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
      }, [categoryId])

      <div className={Cn.make([%twc("w-full z-[5] bg-white left-0")])}>
        <section className={%twc("w-full max-w-3xl mx-auto bg-white border-b border-gray-50")}>
          <ol
            id="horizontal-scroll-container"
            className=%twc("overflow-x-scroll scrollbar-hide flex items-center px-4 gap-4")>
            {items
            ->Array.map(item => {
              <PLP_Scrollable_Tab_Item.MO
                item selected={item.id == categoryId->Option.getWithDefault("")} key=item.id
              />
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
            ->Array.map(idx => <PLP_Scrollable_Tab_Item.MO.Skeleton key={idx->Int.toString} />)
            ->React.array}
          </ol>
        </section>
        <Divider className=%twc("mt-0 bg-gray-50") />
      </>
    }
  }
  @react.component
  let make = (~parentId) => {
    let {node} = Query.use(~variables=Query.makeVariables(~parentId), ())

    let (firstItem, restItem) = switch node->Option.mapWithDefault([], node => node.children) {
    | [] => {
        let parentNode = node->Option.flatMap(node' => node'.parent)
        let id = parentNode->Option.mapWithDefault("", parentNode' => parentNode'.id)
        let name = parentNode->Option.mapWithDefault("", parentNode' => parentNode'.name)

        let firstItem = PLP_Scrollable_Tab_Item.Data.make(
          ~id,
          ~name=`${name} 전체`,
          ~kind=PLP_Scrollable_Tab_Item.Data.All,
        )
        let restItem =
          parentNode
          ->Option.mapWithDefault([], node => node.children)
          ->Array.map(item =>
            PLP_Scrollable_Tab_Item.Data.make(
              ~id=item.id,
              ~name=item.name,
              ~kind=PLP_Scrollable_Tab_Item.Data.Specific,
            )
          )
        (firstItem, restItem)
      }

    | children => {
        let id = node->Option.mapWithDefault("", node' => node'.id)
        let name = node->Option.mapWithDefault("", node' => node'.name)

        let firstItem = PLP_Scrollable_Tab_Item.Data.make(
          ~id,
          ~name=`${name} 전체`,
          ~kind=PLP_Scrollable_Tab_Item.Data.All,
        )
        let restItem =
          children->Array.map(item =>
            PLP_Scrollable_Tab_Item.Data.make(
              ~id=item.id,
              ~name=item.name,
              ~kind=PLP_Scrollable_Tab_Item.Data.Specific,
            )
          )
        (firstItem, restItem)
      }
    }

    let items =
      [firstItem]->Array.concat(
        restItem->Array.map(item =>
          PLP_Scrollable_Tab_Item.Data.make(
            ~id=item.id,
            ~name=item.name,
            ~kind=PLP_Scrollable_Tab_Item.Data.Specific,
          )
        ),
      )

    <React.Suspense fallback={<Skeleton />}>
      <View items />
    </React.Suspense>
  }
}
