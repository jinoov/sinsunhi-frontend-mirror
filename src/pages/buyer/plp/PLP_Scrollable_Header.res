/*
 * 1. 컴포넌트 위치
 *    PLP 최상단

 * 2. 역할
 *    2-depth displaycateogry 목록을 보여줍니다.
 *    모바일에서는 가로로 스크롤을 할수 있는 바의 형태이고,
 *    PC에서는 가로로 스크롤 할 수 있고, 좌우 버튼을 이용해서 스크롤을 할 수 있는 형태의 컴포넌트입니다.
 */

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
      open Webapi
      let router = Next.Router.useRouter()
      let categoryId = switch router.query->Js.Dict.get("cid") {
      | Some(_) as cid => cid
      | None => router.query->Js.Dict.get("category-id")
      }

      let container = React.useRef(Js.Nullable.null)
      let target = React.useRef(Js.Nullable.null)

      let (showLeftArrow, setShowLeftArrow) = React.Uncurried.useState(_ => false)

      let (showRightArrow, setShowRightArrow) = React.Uncurried.useState(_ => false)

      //스크롤이 발생했을 때에 좌 우 버튼을 보여줄 지 결정한다.
      let modifyArrowVisibility = _ => {
        switch container.current->Js.Nullable.toOption {
        | Some(container') => {
            let currentScrollLeft = container'->Dom.Element.scrollLeft


            setShowLeftArrow(._ => currentScrollLeft > 0.0)
            // 스크롤 위치 (currentScrollLeft)의 값이 float 값으로, 0 < currentScrollLeft < 1 사이의 값인 경우 버튼이 없어지지 않을 수 있어서, 높임(ceil)을 합니다.
            setShowRightArrow(._ =>
              currentScrollLeft->Js.Math.ceil_float->Float.toInt + container'->Dom.Element.clientWidth <
                container'->Dom.Element.scrollWidth
            )
          }

        | None => ()
        }
      }

      // 스크롤 위치를 선택한 아이템으로 이동시킨다.
      let scrollToSelectedItem = () => {
        target.current =
          Dom.document
          ->Dom.Document.getElementById(`category-${categoryId->Option.getWithDefault("")}`)
          ->Js.Nullable.fromOption

        switch (container.current->Js.Nullable.toOption, target.current->Js.Nullable.toOption) {
        | (Some(container'), Some(target')) => {
            let targetWidth = target'->Dom.Element.clientWidth
            let targetLeft = switch (
              target'->Dom.Element.asHtmlElement,
              container'->Dom.Element.asHtmlElement,
            ) {
            | (Some(target''), Some(container'')) =>
              Some(target''->Dom.HtmlElement.offsetLeft - container''->Dom.HtmlElement.offsetLeft)
            | _ => None
            }

            let containerClientWidth = container'->Dom.Element.clientWidth

            targetLeft
            ->Option.map(targetLeft' => {
              container'->Dom.Element.setScrollLeft(
                //선택한 하위 아이템을 가운데 정렬하는 대상이 윈도우가 아닌 이 컨테이너의 뷰포트 내의 위치를 기준으로 한다.
                //이동되는 위치가 대상 컴포넌트의 좌측 위치를 기준으로 하므로, 해당 컴포넌트의 폭의 절반만큼을 추가한다.
                (targetLeft' - containerClientWidth / 2 + targetWidth / 2)->Int.toFloat,
              )
            })
            ->ignore
          }

        | _ => ()
        }
      }

      //컴포넌트가 리렌더링된 후에 선택한 카테고리 아이템으로 이동한 후에 좌우 버튼을 보여줄 지 여부를 결정한다.
      React.useEffect1(() => {
        scrollToSelectedItem()
        modifyArrowVisibility()
        None
      }, [categoryId])

      // 왼쪽 화살표 버튼을 클릭했을 때 스크롤 위치를 왼쪽으로 이동시킨다.
      let handleClickLeftArrow = _ => {
        switch container.current->Js.Nullable.toOption {
        | Some(container') =>
          container'->Dom.Element.scrollByWithOptions({
            "behavior": "smooth",
            "left": -120.0,
            "top": 0.0,
          })
        | _ => ()
        }
      }

      //오른쪽 화살표 버튼을 클릭했을 때에, 스크롤을 오른쪽으로 이동시킨다.
      let handleClickRightArrow = _ => {
        switch container.current->Js.Nullable.toOption {
        | Some(container') =>
          container'->Dom.Element.scrollByWithOptions({
            "behavior": "smooth",
            "left": 120.0,
            "top": 0.0,
          })
        | _ => ()
        }
      }

      <div className=%twc("inline-flex flex-col w-full")>
        <section className={%twc("w-full mx-auto bg-white border-b border-gray-50 scroll-smooth")}>
          <ol
            ref={ReactDOM.Ref.domRef(container)}
            id="horizontal-scroll-container"
            className=%twc("overflow-x-scroll scrollbar-hide flex items-center px-2 gap-4")
            onScroll=modifyArrowVisibility>
            {items
            ->Array.map(item => {
              <PLP_Scrollable_Tab_Item.PC
                item selected={item.id == categoryId->Option.getWithDefault("")} key=item.id
              />
            })
            ->React.array}
          </ol>
        </section>
        <div className=%twc("-mt-11 flex pointer-events-none")>
          {switch showLeftArrow {
          | true =>
            <div className=%twc("w-[88px] h-11 inline-flex gradient-tab-l mr-auto")>
              <button
                onClick={handleClickLeftArrow}
                className=%twc(
                  "w-8 h-8 flex justify-center items-center border-[1px] border-gray-300 pointer-events-auto rotate-180"
                )>
                <IconArrow height="16px" width="16px" />
              </button>
            </div>
          | _ => React.null
          }}
          {switch showRightArrow {
          | true =>
            <div
              className=%twc(
                "w-[88px] h-11 float-left inline-flex gradient-tab-r justify-end self-end ml-auto"
              )>
              <button
                onClick={handleClickRightArrow}
                className=%twc(
                  "w-8 h-8 flex justify-center items-center border-[1px] border-gray-300 pointer-events-auto"
                )>
                <IconArrow height="16px" width="16px" />
              </button>
            </div>
          | _ => React.null
          }}
        </div>
      </div>
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
      let container = React.useRef(Js.Nullable.null)

      React.useEffect1(() => {
        open Webapi
        let windowWidth = Dom.window->Dom.Window.innerWidth
        let target =
          Dom.document->Dom.Document.getElementById(
            `category-${categoryId->Option.getWithDefault("")}`,
          )

        switch (container.current->Js.Nullable.toOption, target) {
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
            ref={ReactDOM.Ref.domRef(container)}
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
