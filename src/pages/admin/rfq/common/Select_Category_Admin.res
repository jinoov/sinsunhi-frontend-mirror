open ReactSelect

module Query = %relay(`
  query SelectCategoryAdminQuery($parentId: ID) {
    categories(parentId: $parentId) {
      id
      name
    }
  }
`)

module Spec = {
  module Option = {
    let make = (id, name): ReactSelect.selectOption => {
      Selected({
        value: id,
        label: name,
      })
    }
  }

  module Placeholder = {
    type t = (string, string, string, string, string)
    let default = (`선택`, `선택`, `선택`, `선택`, `선택`)
  }

  module Level = {
    type t = C1 | C2 | C3 | C4 | C5

    let toString = l => {
      switch l {
      | C1 => "c1"
      | C2 => "c2"
      | C3 => "c3"
      | C4 => "c4"
      | C5 => "c5"
      }
    }
  }

  module Value = {
    type t = (selectOption, selectOption, selectOption, selectOption, selectOption)
    let default = (NotSelected, NotSelected, NotSelected, NotSelected, NotSelected)

    let fromApi = (
      fullyQualifiedName: array<
        SelectCategoryAdminRestoreQuery_graphql.Types.response_node_fullyQualifiedName,
      >,
    ) => {
      switch fullyQualifiedName {
      | [v1, v2, v3, v4, v5] => (
          Option.make(v1.id, v1.name),
          Option.make(v2.id, v2.name),
          Option.make(v3.id, v3.name),
          Option.make(v4.id, v4.name),
          Option.make(v5.id, v5.name),
        )

      | _ => default
      }
    }

    let getByLevel = (v, ~level: Level.t) => {
      let (v1, v2, v3, v4, v5) = v
      switch level {
      | C1 => v1
      | C2 => v2
      | C3 => v3
      | C4 => v4
      | C5 => v5
      }
    }

    let makeNextValue = (prev, ~level: Level.t, ~nextV) => {
      let (v1, v2, v3, v4, _) = prev
      switch level {
      | C1 => (nextV, NotSelected, NotSelected, NotSelected, NotSelected)
      | C2 => (v1, nextV, NotSelected, NotSelected, NotSelected)
      | C3 => (v1, v2, nextV, NotSelected, NotSelected)
      | C4 => (v1, v2, v3, nextV, NotSelected)
      | C5 => (v1, v2, v3, v4, nextV)
      }
    }

    let getLevel5 = v => {
      let (_, _, _, _, v5) = v
      switch v5 {
      | NotSelected => None
      | Selected({value}) => value->Some
      }
    }
  }

  module Base = {
    type t = {
      level: Level.t,
      placeholder: string,
      parent: selectOption,
    }

    let fromValue = (v: Value.t, ~placeholder: Placeholder.t) => {
      let (v1, v2, v3, v4, _) = v
      let (p1, p2, p3, p4, p5) = placeholder
      [
        {level: C1, parent: NotSelected, placeholder: p1},
        {level: C2, parent: v1, placeholder: p2},
        {level: C3, parent: v2, placeholder: p3},
        {level: C4, parent: v3, placeholder: p4},
        {level: C5, parent: v4, placeholder: p5},
      ]
    }
  }
}

module RootSelect = {
  @react.component
  let make = (~placeholder, ~level, ~value, ~onChange, ~disabled) => {
    let {categories} = Query.use(~variables=Query.makeVariables(), ())
    let v = value->Spec.Value.getByLevel(~level)
    let options = categories->Array.map(({id, name}) => Spec.Option.make(id, name))
    let handleChange = nextV => {
      if v == nextV {
        () // 이전에 선택했던 옵션과 동일한걸 다시 선택했을 땐, 대응하지 않는다.
      } else {
        value->Spec.Value.makeNextValue(~level, ~nextV)->onChange
      }
    }
    <ReactSelect.Plain isDisabled=disabled placeholder value=v options onChange=handleChange />
  }
}

module ChildSelect = {
  @react.component
  let make = (~placeholder, ~parentId, ~level, ~value, ~onChange, ~disabled) => {
    let {categories} = Query.use(~variables=Query.makeVariables(~parentId, ()), ())
    let v = value->Spec.Value.getByLevel(~level)
    let options = categories->Array.map(({id, name}) => Spec.Option.make(id, name))
    let handleChange = nextV => {
      if v == nextV {
        () // 이전에 선택했던 옵션과 동일한걸 다시 선택했을 땐, 대응하지 않는다.
      } else {
        value->Spec.Value.makeNextValue(~level, ~nextV)->onChange
      }
    }
    <ReactSelect.Plain isDisabled=disabled placeholder value=v options onChange=handleChange />
  }
}

module Skeleton = {
  @react.component
  let make = (~placeholder) => {
    <ReactSelect.Plain
      placeholder value=NotSelected options=[] onChange={_ => ()} isDisabled=true
    />
  }
}

module CategorySelect = {
  @react.component
  let make = (~level, ~placeholder, ~parent, ~value, ~onChange, ~disabled) => {
    switch level {
    // 1뎁스는 부모가 없다.
    | Spec.Level.C1 =>
      <React.Suspense fallback={<Skeleton placeholder />}>
        <RootSelect level placeholder value onChange disabled />
      </React.Suspense>

    // 나머지는 부모가 필수이고, 부모가 선택되기 전까지 스켈레톤을 보여준다.
    | Spec.Level.C2 | Spec.Level.C3 | Spec.Level.C4 | Spec.Level.C5 =>
      switch parent {
      | NotSelected => <Skeleton placeholder />
      | Selected({value: parentId}) =>
        <React.Suspense fallback={<Skeleton placeholder />}>
          <ChildSelect level placeholder parentId value onChange disabled />
        </React.Suspense>
      }
    }
  }
}

// publics -------------------------------------------------------------

module RestoreFromApi = {
  module Query = %relay(`
    query SelectCategoryAdminRestoreQuery($id: ID!) {
      node(id: $id) {
        ... on Category {
          fullyQualifiedName {
            id
            name
          }
        }
      }
    }
  `)

  let use = categoryId => {
    let {node} = Query.use(~variables=Query.makeVariables(~id=categoryId), ())
    switch node {
    | None => Spec.Value.default
    | Some({fullyQualifiedName}) => fullyQualifiedName->Spec.Value.fromApi
    }
  }
}

@react.component
let make = (
  ~className=%twc(""),
  ~placeholder=Spec.Placeholder.default,
  ~value,
  ~onChange,
  ~disabled=false,
) => {
  <div className={cx([%twc("grid grid-cols-5 gap-x-2"), className])}>
    {value
    ->Spec.Base.fromValue(~placeholder)
    ->Array.map(({level, placeholder, parent}) => {
      <CategorySelect
        key={level->Spec.Level.toString} level placeholder parent value onChange disabled
      />
    })
    ->React.array}
  </div>
}
