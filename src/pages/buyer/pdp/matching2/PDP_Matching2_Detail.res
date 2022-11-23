module Fragment = %relay(`
  fragment PDPMatching2Detail_fragment on MatchingProduct {
    productQualityImages {
      imageUrl {
        thumb800x800
      }
      memo
    }
    qualityStandards {
      color
      description
      fault
      foreignMatter
      freshness
      length
      perRegularity
      perSize
      name
      priceGroupPriority
      shape
      sugar
      trimming
    }
  }
`)

module DescriptionList = {
  @react.component
  let make = (~quality: PDPMatching2Detail_fragment_graphql.Types.fragment_qualityStandards) => {
    let {
      name,
      sugar,
      perSize,
      perRegularity,
      length,
      shape,
      trimming,
      color,
      freshness,
      fault,
      foreignMatter,
      description,
    } = quality
    <dl
      key={`pdp-matching-qs-${name}-${description}`}
      className="grid grid-cols-4 gap-x-2 gap-y-4 xs:text-sm sm:text-base">
      {sugar->Option.mapWithDefault(React.null, value => {
        <>
          <dt className="font-semibold"> {`당도`->React.string} </dt>
          <dd className="col-span-3"> {value->ReactNl2br.nl2br} </dd>
        </>
      })}
      {perSize->Option.mapWithDefault(React.null, value => {
        <>
          <dt className="font-semibold"> {`낱개 크기`->React.string} </dt>
          <dd className="col-span-3"> {value->ReactNl2br.nl2br} </dd>
        </>
      })}
      {perRegularity->Option.mapWithDefault(React.null, value => {
        <>
          <dt className="font-semibold"> {`낱개 고르기`->React.string} </dt>
          <dd className="col-span-3"> {value->ReactNl2br.nl2br} </dd>
        </>
      })}
      {length->Option.mapWithDefault(React.null, value => {
        <>
          <dt className="font-semibold"> {`길이`->React.string} </dt>
          <dd className="col-span-3"> {value->ReactNl2br.nl2br} </dd>
        </>
      })}
      {shape->Option.mapWithDefault(React.null, value => {
        <>
          <dt className="font-semibold"> {`모양`->React.string} </dt>
          <dd className="col-span-3"> {value->ReactNl2br.nl2br} </dd>
        </>
      })}
      {trimming->Option.mapWithDefault(React.null, value => {
        <>
          <dt className="font-semibold"> {`손질`->React.string} </dt>
          <dd className="col-span-3"> {value->ReactNl2br.nl2br} </dd>
        </>
      })}
      {color->Option.mapWithDefault(React.null, value => {
        <>
          <dt className="font-semibold"> {`색택`->React.string} </dt>
          <dd className="col-span-3"> {value->ReactNl2br.nl2br} </dd>
        </>
      })}
      {freshness->Option.mapWithDefault(React.null, value => {
        <>
          <dt className="font-semibold"> {`신선도`->React.string} </dt>
          <dd className="col-span-3"> {value->ReactNl2br.nl2br} </dd>
        </>
      })}
      {fault->Option.mapWithDefault(React.null, value => {
        <>
          <dt className="font-semibold"> {`결점`->React.string} </dt>
          <dd className="col-span-3"> {value->ReactNl2br.nl2br} </dd>
        </>
      })}
      {foreignMatter->Option.mapWithDefault(React.null, value => {
        <>
          <dt className="font-semibold"> {`이물`->React.string} </dt>
          <dd className="col-span-3"> {value->ReactNl2br.nl2br} </dd>
        </>
      })}
    </dl>
  }
}

@react.component
let make = (~query, ~selectedQuality) => {
  let {qualityStandards, productQualityImages} = query->Fragment.use

  <div className="mb-8">
    <div className="mb-6 font-semibold text-lg"> {`상품 정보`->React.string} </div>
    {switch productQualityImages->Array.size > 0 {
    | true =>
      <div
        className="h-40 md:h-80 mb-8 flex overflow-auto whitespace-nowrap snap-x gap-x-4 snap-mandatory">
        {productQualityImages
        ->Array.mapWithIndex((idx, image) =>
          <div
            key={`pdp-matching-detail-image-${selectedQuality}-${idx->Int.toString}`}
            className="min-w-[90%] h-full border rounded-lg snap-center">
            <img
              src={image.imageUrl.thumb800x800} className="w-full h-full rounded-lg object-cover"
            />
          </div>
        )
        ->React.array}
      </div>
    | false => React.null
    }}
    {switch qualityStandards
    ->Array.keep(quality => quality.name === selectedQuality)
    ->Garter.Array.first {
    | Some(quality) => <DescriptionList quality />
    | None => React.null
    }}
  </div>
}
