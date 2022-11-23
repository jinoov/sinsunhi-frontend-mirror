module Chips = {
  module Chip = MO_AuctionPrice_Chips_Buyer.Chip

  @react.component
  let make = (~setFilter) => {
    let router = Next.Router.useRouter()

    let value =
      router.query
      ->Js.Dict.get("auction-price")
      ->Option.flatMap(Chip.fromString)
      ->Option.getWithDefault(#TODAY_RISE)

    <MO_AuctionPrice_Chips_Buyer value scroll=false queryParam="auction-price" setFilter />
  }
}

module Lists = {
  module Placeholder = {
    @react.component
    let make = () => {
      <div className=%twc("pt-5 text-center h-[425px]")>
        <Spinner />
      </div>
    }
  }

  @react.component
  let make = (~query) => {
    let router = Next.Router.useRouter()

    let diffTerm = switch router.query
    ->Js.Dict.get("auction-price")
    ->Option.flatMap(Chips.Chip.fromString) {
    | Some(#WEEK_RISE)
    | Some(#WEEK_FALL) =>
      #week
    | Some(#TODAY_RISE)
    | Some(#TODAY_FALL)
    | None =>
      #day
    }

    <React.Suspense fallback={<Placeholder />}>
      <MO_AuctionPrice_List_Buyer.Partial query diffTerm limit=5 />
    </React.Suspense>
  }
}

@react.component
let make = (~query, ~setFilter) => {
  <>
    <div className=%twc("py-3 px-4 text-[19px] font-bold text-[#1F2024]")>
      <h2> {`전국 농산물 경매가`->React.string} </h2>
    </div>
    <div>
      <Chips setFilter />
      <Lists query />
    </div>
  </>
}
