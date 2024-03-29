let getFallback = fallback =>
  fallback->Option.getWithDefault(<div> {j`인증 확인 중 입니다.`->React.string} </div>)

module type UserHook = {
  let use: unit => CustomHooks.Auth.status
}

module Layout = (UserHook: UserHook) => {
  @react.component
  let make = (~children, ~title=?, ~fallback=?, ~ssrFallback=React.null) => {
    let user = UserHook.use()
    <>
      <Next.Head>
        <title>
          {j`신선하이 ${title->Option.mapWithDefault("", t => `| ${t}`)}`->React.string}
        </title>
      </Next.Head>
      <OpenGraph_Header title={`신선하이 ${title->Option.mapWithDefault("", t => `| ${t}`)}`}/>
      {switch user {
      // TODO 로딩상태 페이지 추가 필요
      | Unknown => ssrFallback
      | NotLoggedIn => fallback->getFallback
      | LoggedIn(_) => children
      }}
    </>
  }
}

module Admin = Layout(CustomHooks.User.Admin)

module Buyer = Layout(CustomHooks.User.Buyer)

module Seller = Layout(CustomHooks.User.Seller)
