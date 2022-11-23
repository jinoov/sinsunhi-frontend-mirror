module Item = {
  module Link = {
    @react.component
    let make = (~displayName, ~href, ~newTab=false) => {
      let itemStyle = %twc(
        "h-18 rounded-2xl flex px-12 justify-start items-center text-[19px] hover:bg-[#1F20240A] active:bg-[#1F202414] w-full ease-in-out duration-200 mb-[2px]"
      )

      <div className=%twc("w-full px-3")>
        <Next.Link href passHref=true>
          <a className=itemStyle target={newTab ? "_blank" : "_self"}>
            {displayName->React.string}
          </a>
        </Next.Link>
      </div>
    }
  }
  module Route = {
    @react.component
    let make = (
      ~displayName,
      ~pathObj: Next.Router.pathObj,
      ~routeFn: [#replace | #push],
      ~selected,
    ) => {
      let router = Next.Router.useRouter()

      let baseStyle = %twc(
        "h-18 rounded-2xl flex px-12 justify-start items-center text-[19px] hover:bg-[#1F20240A] active:bg-[#1F202414] w-full ease-in-out duration-200 mb-[2px]"
      )
      let selectedStyle = %twc("font-bold bg-[#1F20240A] hover:bg-[#1F202414]")
      let itemStyle = cx([selected ? selectedStyle : "", baseStyle])

      let onClick = _ => {
        let routeFn = switch routeFn {
        | #replace => Next.Router.replaceObj
        | #push => Next.Router.pushObj
        }
        router->routeFn(pathObj)
      }

      <div className=%twc("w-full px-3")>
        <button type_="button" onClick className=itemStyle> {displayName->React.string} </button>
      </div>
    }
  }

  module Action = {
    @react.component
    let make = (~displayName, ~selected, ~onClick) => {
      let baseStyle = %twc(
        "h-18 rounded-2xl flex px-12 justify-start items-center text-[19px] hover:bg-[#1F20240A] active:bg-[#1F202414] w-full ease-in-out duration-200 mb-[2px]"
      )
      let selectedStyle = %twc("font-bold bg-[#1F20240A] hover:bg-[#1F202414]")
      let itemStyle = cx([selected ? selectedStyle : "", baseStyle])

      <div className=%twc("w-full px-3")>
        <button type_="button" onClick className=itemStyle> {displayName->React.string} </button>
      </div>
    }
  }
}

@react.component
let make = (~children) => {
  <div
    className=%twc(
      "hidden lg:block bg-white max-w-[340px] min-w-[280px] w-full py-10 sticky top-[156px] border-r-[1px] border-[#EDEFF2] h-full min-h-screen"
    )>
    {children}
  </div>
}
