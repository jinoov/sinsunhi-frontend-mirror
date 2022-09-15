module Data = {
  //~전체인지, 구체적인 하위 노드인지
  type kind =
    | All
    | Specific
  type t = {
    name: string,
    id: string,
    kind: kind,
  }
  let make = (~id, ~name, ~kind) => {
    id,
    name,
    kind,
  }
}

module PC = {
  module Skeleton = {
    @react.component
    let make = () => {
      <div className=%twc("skeleton-base w-20 mt-2 mb-3 rounded h-6") />
    }
  }

  @react.component
  let make = (~selected, ~item: Data.t) => {
    let router = Next.Router.useRouter()
    let selectedStyle = selected
      ? %twc("border-gray-800 text-gray-800 font-bold")
      : %twc("border-transparent text-gray-400")
    let baseStyle = %twc("pt-2 pb-3 border-b-2 w-fit whitespace-nowrap cursor-pointer")

    <li
      key={item.id}
      id={`category-${item.id}`}
      onClick={_ => Next.Router.replace(router, `/categories/${item.id}`)}>
      <div className={Cn.make([selectedStyle, baseStyle])}> {item.name->React.string} </div>
    </li>
  }
}
module MO = {
  module Skeleton = {
    @react.component
    let make = () => {
      <div className=%twc("skeleton-base w-20 mt-2 mb-3 rounded h-6") />
    }
  }

  @react.component
  let make = (~selected, ~item: Data.t) => {
    let router = Next.Router.useRouter()
    let selectedStyle = selected
      ? %twc("border-gray-800 text-gray-800 font-bold")
      : %twc("border-transparent text-gray-400")
    let baseStyle = %twc("pt-2 pb-3 border-b-2 w-fit whitespace-nowrap")

    <li
      key={item.id}
      id={`category-${item.id}`}
      onClick={_ => Next.Router.replace(router, `/categories/${item.id}`)}>
      <div className={Cn.make([selectedStyle, baseStyle])}> {item.name->React.string} </div>
    </li>
  }
}
