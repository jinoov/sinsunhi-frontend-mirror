module Chips = {
  module Chip = PC_AuctionPrice_Chips_Buyer.Chip

  @react.component
  let make = (~setFilter) => {
    let router = Next.Router.useRouter()

    let value =
      router.query
      ->Js.Dict.get("type")
      ->Option.flatMap(Chip.fromString)
      ->Option.getWithDefault(#TODAY_RISE)

    <div className=%twc("sticky")>
      <PC_AuctionPrice_Chips_Buyer value scroll=true queryParam="type" setFilter />
    </div>
  }
}

module Lists = {
  module Placeholder = {
    @react.component
    let make = () => {
      <div className=%twc("h-[1940px] text-center pt-10")>
        <Spinner />
      </div>
    }
  }
  @react.component
  let make = (~query) => {
    let router = Next.Router.useRouter()

    let diffTerm = switch router.query->Js.Dict.get("type")->Option.flatMap(Chips.Chip.fromString) {
    | Some(#WEEK_RISE)
    | Some(#WEEK_FALL) =>
      #week
    | Some(#TODAY_RISE)
    | Some(#TODAY_FALL)
    | None =>
      #day
    }

    <React.Suspense fallback={<Placeholder />}>
      <PC_AuctionPrice_List_Buyer query diffTerm />
    </React.Suspense>
  }
}

@react.component
let make = (~query, ~setFilter) => {
  <>
    <Chips setFilter />
    <Lists query />
  </>
}
