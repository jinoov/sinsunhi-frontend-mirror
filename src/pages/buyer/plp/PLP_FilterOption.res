module Sort = {
  let encodeSort = sort => {
    switch sort {
    | #UPDATED_DESC => "updated-desc"
    | #PRICE_ASC => "price-asc"
    | #PRICE_PER_KG_ASC => "price-per-kg-asc"
    | _ => ""
    }
  }

  let decodeSort = (sectionType, sortStr) => {
    switch (sectionType, sortStr) {
    | (_, "updated-asc") => #UPDATED_ASC
    | (_, "updated-desc") => #UPDATED_DESC

    | (#MATCHING, "price-asc") => #PRICE_PER_KG_ASC
    | (_, "price-asc") => #PRICE_ASC
    | (_, "price-desc") => #PRICE_DESC

    | (#MATCHING, "price-per-kg-asc") => #PRICE_PER_KG_ASC
    | (_, "price-per-kg-asc") => #PRICE_ASC
    | (_, "price-per-kg-desc") => #PRICE_PER_KG_DESC
    | _ => #UPDATED_DESC
    }
  }

  let makeSortLabel = sort => {
    switch sort {
    | #UPDATED_DESC => `최신순`
    | #PRICE_ASC => `낮은가격순`
    | #PRICE_PER_KG_ASC => `낮은가격순(kg당)`
    | _ => ""
    }
  }
}

module Section = {
  type t = [
    | #MATCHING
    | #DELIVERY
    | #ALL
    | #NONE
  ]

  let make = s => {
    switch s {
    | Some("matching") => #MATCHING
    | Some("delivery") => #DELIVERY
    | Some("all") => #ALL
    | Some("none") => #NONE
    | _ => #ALL
    }
  }

  let toCheckBoxSelection = t =>
    switch t {
    | #MATCHING => (true, false)
    | #DELIVERY => (false, true)
    | #ALL => (true, true)
    | #NONE => (false, false)
    }

  let fromCheckBoxSelection = (matching, delivery) => {
    switch (matching, delivery) {
    | (true, false) => #MATCHING
    | (false, true) => #DELIVERY
    | (true, true) => #ALL
    | (false, false) => #NONE
    }
  }

  let toString = t => {
    switch t {
    | #MATCHING => "matching"
    | #DELIVERY => "delivery"
    | #ALL => "all"
    | #NONE => "none"
    }
  }

  let toQueryParam = t =>
    switch t {
    | #MATCHING => [#MATCHING, #QUOTED]
    | #DELIVERY => [#NORMAL, #QUOTABLE]
    | #ALL => [#MATCHING, #QUOTED, #NORMAL, #QUOTABLE]
    | #NONE => []
    }
}
