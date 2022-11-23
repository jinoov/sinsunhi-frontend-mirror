@module("../../../../../public/assets/circle-checked.svg")
external circleCheckedkIcon: string = "default"

module Fragment = %relay(`
  fragment PDPMatching2Grade_fragment on MatchingProduct {
    qualityStandards {
      name
      description
      priceGroupPriority
    }
  }
`)

type quality = PDPMatching2Grade_fragment_graphql.Types.fragment_qualityStandards

// Quality standards would be more than 3. You need to make this with a carousel at that time.
@react.component
let make = (~query, ~selectedQuality, ~setSelectedQuality) => {
  let {qualityStandards} = query->Fragment.use

  let renderBox = (quality: quality) => {
    let {name, description, priceGroupPriority} = quality
    let active = name === selectedQuality
    <div
      key=quality.name
      className={"flex-1 p-3 border rounded-lg transition-all duration-150 hover:border-green-300 cursor-pointer" ++ (
        active ? " border-green-500 bg-green-50" : ""
      )}
      onClick={_ => setSelectedQuality(._ => (name, priceGroupPriority))}>
      <img
        src=circleCheckedkIcon className={"w-4" ++ (active ? "" : " grayscale brightness-150")}
      />
      <div className="mt-3 font-semibold leading-5 word-keep-all"> {name->React.string} </div>
      <div className="mt-2 text-sm"> {description->React.string} </div>
    </div>
  }

  <div className="flex place-content-evenly gap-2 mb-6">
    {qualityStandards->Array.map(renderBox)->React.array}
  </div>
}
