module Fragment = %relay(`
  fragment PDPMatching2Title_fragment on MatchingProduct {
    displayName
    origin
    image {
      thumb400x400
    }
    releaseEndMonth
    releaseStartMonth
  }
`)

@react.component
let make = (~query) => {
  let {displayName, origin, image, releaseEndMonth, releaseStartMonth} = query->Fragment.use
  let releasePeriod = `${releaseStartMonth->Int.toString}~${releaseEndMonth->Int.toString}월 출하`

  <div className="mb-8 flex h-16">
    <img src=image.thumb400x400 className="h-full rounded-lg bg-slate-100" alt=displayName />
    <div className="py-2 px-4">
      <div className="font-semibold text-lg"> {displayName->React.string} </div>
      <div className="font-light text-gray-500">
        {origin->Option.getWithDefault("")->React.string}
        {`, ${releasePeriod}`->React.string}
      </div>
    </div>
  </div>
}
