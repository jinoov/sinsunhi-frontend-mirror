module Query = %relay(`
  query PCPLPChipList_Query($parentId: ID!) {
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

type t = {
  id: string,
  name: string,
}

module Item = {
  module Skeleton = {
    @react.component
    let make = () => {
      <div className=%twc("skeleton-base w-80 h-[46px] rounded-full") />
    }
  }
  @react.component
  let make = (~selected, ~name, ~id) => {
    let router = Next.Router.useRouter()
    let selectedStyle = selected
      ? %twc("border-[#1F2024] bg-[#1F2024] text-white")
      : %twc("bg-transparent text-[#1F2024] border-[1px] border-[#DCDFE3]")
    let baseStyle = %twc(
      "inline-block px-4 py-[11px] rounded-full w-fit whitespace-nowrap cursor-pointer mr-2 last-of-type:mr-0 mb-[10px]"
    )

    let targetSection =
      router.query
      ->Js.Dict.get("section")
      ->Product_FilterOption.Section.fromUrlParameter
      ->Option.mapWithDefault("", Product_FilterOption.Section.toUrlParameter)

    <li
      key={id}
      id={`category-${id}`}
      onClick={_ =>
        Next.Router.replace(
          router,
          `/categories/${id}?section=${targetSection}&sort=POPULARITY_DESC`,
        )}
      className={Cn.make([selectedStyle, baseStyle])}>
      {name->React.string}
    </li>
  }
}

module ChipBar = {
  @react.component
  let make = (~items) => {
    let router = Next.Router.useRouter()
    let categoryId = switch router.query->Js.Dict.get("cid") {
    | Some(_) as cid => cid
    | None => router.query->Js.Dict.get("category-id")
    }

    <div className=%twc("inline-flex flex-col w-full")>
      <section className={%twc("w-full")}>
        <ol id="horizontal-scroll-container" className=%twc("w-full flex-wrap")>
          {items
          ->Array.map(({id, name}) => {
            <Item selected={id == categoryId->Option.getWithDefault("")} key=id id name />
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
      <div className=%twc("inline-flex flex-col w-full")>
        <div className=%twc("w-[160px] h-6 rounded-lg animate-pulse bg-gray-150 mb-9") />
        <div className=%twc("h-12 px-5 scrollbar-hide")>
          <div className=%twc("flex gap-4 h-full")>
            {Array.range(0, 10)
            ->Array.map(idx => <Item.Skeleton key={idx->Int.toString} />)
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
      let (firstNodeId, restItem, title, show) = switch (node'.type_, node'.children) {
      | (#NORMAL, []) => {
          let parentNode = node'.parent
          let id = parentNode->Option.mapWithDefault("", parentNode' => parentNode'.id)
          let name = parentNode->Option.mapWithDefault("", parentNode' => parentNode'.name)

          let restItem =
            parentNode
            ->Option.mapWithDefault([], parentNode' => parentNode'.children)
            ->Array.map(item => {id: item.id, name: item.name})
          (id, restItem, name, true)
        }

      | (#SHOWCASE, []) => {
          let parentNode = node'.parent
          let id = parentNode->Option.mapWithDefault("", parentNode' => parentNode'.id)
          let name = node'.name

          let restItem =
            parentNode
            ->Option.mapWithDefault([], parentNode' => parentNode'.children)
            ->Array.map(item => {id: item.id, name: item.name})
          (id, restItem, name, false)
        }

      | (_, children) => {
          let id = node'.id
          let name = node'.name

          let restItem = children->Array.map(item => {id: item.id, name: item.name})
          (id, restItem, name, true)
        }
      }

      let firstItem = {
        id: firstNodeId,
        name: `${title} 전체`,
      }

      let items =
        [firstItem]->Array.concat(restItem->Array.map(item => {id: item.id, name: item.name}))

      <React.Suspense fallback={<Skeleton />}>
        <div className=%twc("inline-flex flex-col w-full")>
          <div className=%twc("font-bold text-3xl text-gray-800 mb-10")>
            {title->React.string}
          </div>
          {switch show {
          | true => <ChipBar items />
          | false => React.null
          }}
        </div>
      </React.Suspense>
    }

  | None => <Skeleton />
  }
}
