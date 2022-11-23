module Section = {
  type t = [
    | #ALL
    | #MATCHING
    | #DELIVERY
  ]

  let make = s => {
    switch s {
    | Some(["matching", "delivery"]) => Some(#ALL)
    | Some(["matching"]) => Some(#MATCHING)
    | Some(["delivery"]) => Some(#DELIVERY)
    | _ => None
    }
  }

  let toCheckBoxSelection = t =>
    switch t {
    | #ALL => (true, true)
    | #MATCHING => (true, false)
    | #DELIVERY => (false, true)
    }

  let fromCheckBoxSelection = (matching, delivery) => {
    switch (matching, delivery) {
    | (true, true) => Some(#ALL)
    | (true, false) => Some(#MATCHING)
    | (false, true) => Some(#DELIVERY)
    | (false, false) => None
    }
  }

  let toUrlParameter = t => {
    switch t {
    | #ALL => ["matching", "delivery"]
    | #MATCHING => ["matching"]
    | #DELIVERY => ["delivery"]
    }->Js.Array2.toString
  }

  let toLabel = t =>
    switch t {
    | #ALL => "전체"
    | #DELIVERY => "즉시구매"
    | #MATCHING => "견적요청"
    }

  let fromUrlParameter = s => {
    s->Option.map(Js.String.split(","))->make
  }

  let toQueryParam = t =>
    switch t {
    | #ALL => [#MATCHING, #QUOTED, #NORMAL, #QUOTABLE]
    | #MATCHING => [#MATCHING, #QUOTED, #QUOTABLE]
    | #DELIVERY => [#NORMAL, #QUOTABLE]
    }
}

module Sort = {
  let defaultValue = #POPULARITY_DESC
  let searchDefaultValue = #RELEVANCE_DESC

  let make = (sectionType: Section.t, sortStr) =>
    switch (sectionType, sortStr) {
    | (_, Some("UPDATED_ASC")) => Some(#UPDATED_ASC)
    | (_, Some("UPDATED_DESC")) => Some(#UPDATED_DESC)

    | (#MATCHING, Some("PRICE_ASC")) => Some(#PRICE_PER_KG_ASC)
    | (_, Some("PRICE_ASC")) => Some(#PRICE_ASC)

    | (#MATCHING, Some("PRICE_PER_KG_ASC")) => Some(#PRICE_PER_KG_ASC)
    | (_, Some("PRICE_PER_KG_ASC")) => Some(#PRICE_ASC)

    | (#MATCHING, Some("PRICE_DESC")) => Some(#PRICE_PER_KG_DESC)
    | (_, Some("PRICE_DESC")) => Some(#PRICE_DESC)

    | (_, Some("POPULARITY_DESC")) => Some(#POPULARITY_DESC)

    | _ => None
    }

  let makeSearch = (sectionType: Section.t, sortStr) =>
    switch (sectionType, sortStr) {
    | (_, Some("UPDATED_ASC")) => Some(#UPDATED_ASC)
    | (_, Some("UPDATED_DESC")) => Some(#UPDATED_DESC)

    | (#MATCHING, Some("PRICE_ASC")) => Some(#PRICE_PER_KG_ASC)
    | (_, Some("PRICE_ASC")) => Some(#PRICE_ASC)

    | (#MATCHING, Some("PRICE_PER_KG_ASC")) => Some(#PRICE_PER_KG_ASC)
    | (_, Some("PRICE_PER_KG_ASC")) => Some(#PRICE_ASC)

    | (#MATCHING, Some("PRICE_DESC")) => Some(#PRICE_PER_KG_DESC)
    | (_, Some("PRICE_DESC")) => Some(#PRICE_DESC)

    | (_, Some("RELEVANCE_DESC")) => Some(#RELEVANCE_DESC)

    | (_, Some("POPULARITY_DESC")) => Some(#POPULARITY_DESC)

    | _ => None
    }

  let toSortLabel = sort => {
    switch sort {
    | #UPDATED_ASC => `오래된순`
    | #UPDATED_DESC => `최신순`
    | #PRICE_ASC => `낮은가격순`
    | #PRICE_PER_KG_ASC => `낮은가격순(kg당)`
    | #PRICE_DESC => `높은가격순`
    | #PRICE_PER_KG_DESC => `높은가격순(kg당)`
    | #RELEVANCE_DESC => `관련도순`
    | #POPULARITY_DESC => `인기순`
    }
  }

  let toString = sort =>
    switch sort {
    | #UPDATED_ASC => "UPDATED_ASC"
    | #UPDATED_DESC => "UPDATED_DESC"
    | #PRICE_ASC => "PRICE_ASC"
    | #PRICE_PER_KG_ASC => "PRICE_PER_KG_ASC"
    | #PRICE_DESC => "PRICE_DESC"
    | #PRICE_PER_KG_DESC => "PRICE_PER_KG_DESC"
    | #RELEVANCE_DESC => "RELEVANCE_DESC"
    | #POPULARITY_DESC => "POPULARITY_DESC"
    }

  let toSearchProductParam = (sort): option<
    array<SRPBuyer_Query_graphql.Types.searchProductsOrderBy>,
  > =>
    switch sort {
    | #UPDATED_ASC =>
      Some([{field: #STATUS_PRIORITY, direction: #ASC}, {field: #UPDATED_AT, direction: #ASC}])
    | #UPDATED_DESC =>
      Some([{field: #STATUS_PRIORITY, direction: #ASC}, {field: #UPDATED_AT, direction: #DESC}])
    | #PRICE_ASC =>
      Some([
        {field: #STATUS_PRIORITY, direction: #ASC},
        {field: #PRICE, direction: #ASC_NULLS_LAST},
        {field: #UPDATED_AT, direction: #DESC},
      ])
    | #PRICE_PER_KG_ASC =>
      Some([
        {field: #STATUS_PRIORITY, direction: #ASC},
        {field: #PRICE_PER_KG, direction: #ASC_NULLS_LAST},
        {field: #UPDATED_AT, direction: #DESC},
      ])
    | #PRICE_DESC =>
      Some([
        {field: #STATUS_PRIORITY, direction: #ASC},
        {field: #PRICE, direction: #DESC_NULLS_LAST},
        {field: #UPDATED_AT, direction: #DESC},
      ])
    | #PRICE_PER_KG_DESC =>
      Some([
        {field: #STATUS_PRIORITY, direction: #ASC},
        {field: #PRICE_PER_KG, direction: #DESC_NULLS_LAST},
        {field: #UPDATED_AT, direction: #DESC},
      ])
    | #RELEVANCE_DESC =>
      Some([
        {field: #STATUS_PRIORITY, direction: #ASC},
        {field: #RELEVANCE_SCORE, direction: #DESC},
        {field: #UPDATED_AT, direction: #DESC},
      ])
    | #POPULARITY_DESC =>
      Some([{field: #STATUS_PRIORITY, direction: #ASC}, {field: #POPULARITY, direction: #DESC}])
    }
}

let defaultFilterOptionUrlParam = `section=matching,delivery&sort=${(Sort.defaultValue: [
    | #POPULARITY_DESC
  ] :> string)}`
