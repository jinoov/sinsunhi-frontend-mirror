module Query = %relay(`
  query MatchingMainCategoryQuery {
    section(type: MATCHING) {
      featuredDisplayCategories(
        onlyDisplayable: true
        onlyHasBuyableProducts: true
        type: NORMAL
        orderBy: [{ displayOrder: ASC }]
      ) {
        id
        name
        image {
          original
        }
      }
    }
  }
`)

module ListItem = {
  type t = {
    id: string,
    src: string,
    name: string,
  }
  let fromQueryData = (id, src, name) => {
    id: id,
    src: src,
    name: name,
  }
  module PC = {
    module Skeleton = {
      @react.component
      let make = () => {
        <li className=%twc("mx-6 w-[112px]")>
          <div
            className=%twc(
              "w-28 aspect-square rounded-lg overflow-hidden animate-pulse bg-gray-150"
            )
          />
          <div
            className=%twc(
              "text-gray-800 font-bold text-center h-7 flex justify-center items-center"
            )>
            <div className=%twc("w-14 h-6 rounded-lg animate-pulse bg-gray-150") />
          </div>
        </li>
      }
    }

    @react.component
    let make = (~id, ~src, ~name) => {
      let queryStr = {
        [("category-id", id)]
        ->Webapi.Url.URLSearchParams.makeWithArray
        ->Webapi.Url.URLSearchParams.toString
      }

      <li className=%twc("cursor-pointer")>
        <Next.Link href={`/buyer/matching/products?${queryStr}`}>
          <a className=%twc("w-28 flex flex-col items-center gap-[18px]")>
            <div className=%twc("w-28 aspect-square rounded-lg overflow-hidden")>
              <Image
                src
                placeholder=Image.Placeholder.Sm
                className=%twc("w-full h-full object-cover")
                alt=id
              />
            </div>
            <div className=%twc("h-[22px] flex items-center justify-center overflow-hidden")>
              <div
                className=%twc(
                  "w-28 h-7 overflow-hidden text-gray-800 font-bold text-center items-center whitespace-nowrap text-ellipsis block"
                )>
                {name->React.string}
              </div>
            </div>
          </a>
        </Next.Link>
      </li>
    }
  }
  module MO = {
    module Skeleton = {
      @react.component
      let make = () => {
        <li>
          <div className=%twc("flex flex-col items-center w-[75px] gap-[9px]")>
            <div
              className=%twc(
                "w-14 aspect-square rounded-lg overflow-hidden bg-gray-150 animate-pulse"
              )
            />
            <div className=%twc("h-[22px] flex items-center justify-center")>
              <div
                className=%twc(
                  "w-8 h-3 text-gray-800 text-sm text-center leading-[22px] animate-pulse rounded-lg bg-gray-150"
                )
              />
            </div>
          </div>
        </li>
      }
    }

    @react.component
    let make = (~id, ~src, ~name) => {
      let queryStr = {
        [("category-id", id)]
        ->Webapi.Url.URLSearchParams.makeWithArray
        ->Webapi.Url.URLSearchParams.toString
      }
      <li>
        <Next.Link href={`/buyer/matching/products?${queryStr}`}>
          <a className=%twc("w-[75px] flex flex-col items-center gap-[9px]")>
            <div className=%twc("w-14 aspect-square rounded-lg overflow-hidden")>
              <Image
                src
                placeholder=Image.Placeholder.Sm
                className=%twc("w-full h-full object-cover")
                alt=id
              />
            </div>
            <div
              className=%twc(
                "w-[75px] overflow-hidden text-gray-800 text-sm text-center leading-[22px] whitespace-nowrap text-ellipsis"
              )>
              {name->React.string}
            </div>
          </a>
        </Next.Link>
      </li>
    }
  }
}

module PC = {
  module View = {
    @react.component
    let make = (~title, ~items: array<ListItem.t>) => {
      <div className=%twc("w-[1280px] mx-auto mt-20")>
        <div className=%twc("text-2xl text-gray-800 font-bold mb-6")>
          <span> {title->React.string} </span>
        </div>
        <ol
          className=%twc("w-full flex overflow-hidden gap-[78px] overflow-x-scroll scrollbar-hide")>
          {items
          ->Array.map(({id, src, name}) =>
            <ListItem.PC key={`display-category-${id}-pc`} id src name />
          )
          ->React.array}
        </ol>
      </div>
    }
  }
  module Skeleton = {
    @react.component
    let make = () => {
      <div
        className=%twc("w-[1280px] mx-auto mt-20 overflow-hidden overflow-x-scroll scrollbar-hide")>
        <div className=%twc("mb-6")>
          <div className=%twc("w-40 h-8 animate-pulse rounded-lg bg-gray-150") />
        </div>
        <ol className=%twc("w-full flex items-center ")>
          {[0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15]
          ->Array.map(index => {
            let key = `matching-main-category-placeholder-${index->Int.toString}`
            <ListItem.PC.Skeleton key />
          })
          ->React.array}
        </ol>
      </div>
    }
  }

  @react.component
  let make = () => {
    let query: MatchingMainCategoryQuery_graphql.Types.response = Query.use(~variables=(), ())

    let items =
      query.section
      ->Option.map(section =>
        section.featuredDisplayCategories->Array.map(({id, image, name}) => {
          let image = image->Option.mapWithDefault("", image => image.original)
          ListItem.fromQueryData(id, image, name)
        })
      )
      ->Option.getWithDefault([])

    <View title={`카테고리`} items />
  }
}

module MO = {
  module View = {
    @react.component
    let make = (~title, ~items: array<ListItem.t>) => {
      <div className=%twc("w-full flex flex-col mb-5")>
        <div className=%twc("h-[50px] flex items-end  text-gray-800 font-bold ml-5 mb-6")>
          {title->React.string}
        </div>
        <ol className=%twc("w-full flex gap-2 overflow-x-scroll  scrollbar-hide")>
          {items
          ->Array.map(({id, src, name}) =>
            <ListItem.MO key={`display-category-${id}-mo`} id src name />
          )
          ->React.array}
        </ol>
      </div>
    }
  }
  module Skeleton = {
    @react.component
    let make = () => {
      <div className=%twc("w-full flex flex-col mb-5")>
        <div className=%twc("h-[50px] flex items-end  text-gray-800 font-bold ml-5")>
          <div className=%twc("w-20 h-7 rounded-lg animate-pulse bg-gray-150") />
        </div>
        <ol className=%twc("mt-6 w-full flex gap-2 overflow-x-scroll scrollbar-hide")>
          {[0, 1, 2, 3, 4, 5, 6, 7]
          ->Array.map(index => {
            let key = `matching-main-category-placeholder-${index->Int.toString}`
            <ListItem.MO.Skeleton key />
          })
          ->React.array}
        </ol>
      </div>
    }
  }
  @react.component
  let make = () => {
    let query: MatchingMainCategoryQuery_graphql.Types.response = Query.use(~variables=(), ())

    let items =
      query.section
      ->Option.map(section =>
        section.featuredDisplayCategories->Array.map(({id, image, name}) => {
          let image = image->Option.mapWithDefault("", image => image.original)

          ListItem.fromQueryData(id, image, name)
        })
      )
      ->Option.getWithDefault([])

    <View title={`카테고리`} items />
  }
}
