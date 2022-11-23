module Chip = {
  type t = [
    | #TODAY_RISE
    | #TODAY_FALL
    | #WEEK_RISE
    | #WEEK_FALL
  ]

  let fromString = t =>
    switch t {
    | "TODAY_RISE" => Some(#TODAY_RISE)
    | "TODAY_FALL" => Some(#TODAY_FALL)
    | "WEEK_RISE" => Some(#WEEK_RISE)
    | "WEEK_FALL" => Some(#WEEK_FALL)
    | _ => None
    }

  let toLabel = t =>
    switch t {
    | #TODAY_RISE => "오늘 급등"
    | #TODAY_FALL => "오늘 급락"
    | #WEEK_RISE => "이번주 급등"
    | #WEEK_FALL => "이번주 급락"
    }

  let style = %twc(
    "inline-flex justify-center items-center rounded-full w-fit h-10 text-[15px] border-[1px] px-3 mr-2 last-of-type:mr-0"
  )

  @react.component
  let make = (~value: t, ~isClicked, ~scroll, ~queryParam, ~setFilter) => {
    let router = Next.Router.useRouter()

    let newRouterQuery = Js.Dict.fromArray(router.query->Js.Dict.entries)
    newRouterQuery->Js.Dict.set(queryParam, (value :> string))

    <Next.Link
      replace=true
      shallow=true
      scroll
      href={`${router.pathname}?${newRouterQuery
        ->Webapi.Url.URLSearchParams.makeWithDict
        ->Webapi.Url.URLSearchParams.toString}`}>
      <li
        className={cx([
          style,
          isClicked
            ? %twc("bg-gray-800 text-white border-gray-800")
            : %twc("text-gray-800 border-[#DCDFE3]"),
        ])}
        role="button"
        onClick={_ => setFilter(value)}>
        {value->toLabel->React.string}
      </li>
    </Next.Link>
  }
}
@react.component
let make = (~value, ~scroll, ~queryParam, ~setFilter) => {
  <div className=%twc("w-full overflow-x-scroll scrollbar-hide py-4 top-[56px] bg-white")>
    <ol className=%twc("mx-4 w-max")>
      <Chip value=#TODAY_RISE isClicked={value == #TODAY_RISE} scroll queryParam setFilter />
      <Chip value=#TODAY_FALL isClicked={value == #TODAY_FALL} scroll queryParam setFilter />
      <Chip value=#WEEK_RISE isClicked={value == #WEEK_RISE} scroll queryParam setFilter />
      <Chip value=#WEEK_FALL isClicked={value == #WEEK_FALL} scroll queryParam setFilter />
    </ol>
  </div>
}
