module Query = %relay(`
  query SelectMeatGradeAdminQuery {
    meatGrades(after: null, first: 999) {
      edges {
        node {
          id
          grade
        }
      }
    }
  }
`)

module Sekeleton = {
  @react.component
  let make = (~className=?) => {
    <label className={%twc("block relative ") ++ className->Option.getWithDefault("")}>
      <div
        className=%twc(
          "w-[72px] flex items-center h-8 border border-border-default-L1 rounded-md px-3 py-2 bg-white"
        )>
        <span> {`미선택`->React.string} </span>
        <span className=%twc("absolute top-1.5 right-2")>
          <IconArrowSelect height="24" width="24" fill="#121212" />
        </span>
      </div>
    </label>
  }
}

@react.component
let make = (~className=?, ~value, ~onChange) => {
  let {meatGrades} = Query.use(~variables=(), ())

  let makeSelected = gradeId => {
    meatGrades.edges->Array.getBy(({node: {id}}) => id == gradeId)
  }

  let handleChange = e => {
    (e->ReactEvent.Synthetic.target)["value"]->onChange
  }

  let selected = {
    switch value->makeSelected {
    | Some({node: {grade}}) => grade
    | None => `미선택`
    }
  }

  <label className={%twc("block relative ") ++ className->Option.getWithDefault("")}>
    <div
      className=%twc(
        "flex items-center h-[34px] border border-border-default-L1 rounded-lg px-3 py-2 bg-white"
      )>
      <span className={value == "" ? %twc("text-disabled-L1") : %twc("text-text-L1")}>
        {selected->React.string}
      </span>
      <span className=%twc("absolute top-1.5 right-2")>
        <IconArrowSelect height="24" width="24" fill="#121212" />
      </span>
    </div>
    <select
      className=%twc("block w-full h-full absolute top-0 opacity-0") value onChange=handleChange>
      <option value="" disabled=true hidden={value == "" ? false : true}>
        {`미선택`->React.string}
      </option>
      {meatGrades.edges
      ->Array.map(({node: {id, grade}}) => {
        <option key=id value=id> {grade->React.string} </option>
      })
      ->React.array}
    </select>
  </label>
}
