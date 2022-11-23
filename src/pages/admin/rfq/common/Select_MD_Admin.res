type inputElement
@set external setValue: (inputElement, string) => unit = "value"
@get external getValue: inputElement => option<string> = "value"
external getInput: Dom.element => inputElement = "%identity"
let resetInput = el => el->getInput->setValue("")

type inputStatus =
  | Blurred
  | Focused

module Item = {
  type item = {
    id: string,
    label: string,
  }

  type t =
    | NotSelected
    | Selected(item)

  let make = item => Selected(item)
}

module Scroll = {
  @react.component
  let make = (~children) => {
    open RadixUI.ScrollArea
    <Root className=%twc("max-h-[260px] w-[310px] flex flex-col")>
      <Viewport className=%twc("w-full h-full")> {children} </Viewport>
      <Scrollbar>
        <Thumb />
      </Scrollbar>
    </Root>
  }
}

module ResultBox = {
  @react.component
  let make = (~children) => {
    <div
      className=%twc(
        "absolute z-10 top-10 left-0 p-1 w-full rounded-lg overflow-hidden shadow-md border border-border-default-L1 bg-white"
      )>
      children
    </div>
  }
}

module Empty = {
  @react.component
  let make = () => {
    <ResultBox>
      <div className=%twc("w-full h-9 flex items-center justify-center text-disabled-L1 text-sm")>
        {`검색 결과가 없습니다.`->React.string}
      </div>
    </ResultBox>
  }
}

module Loading = {
  @react.component
  let make = () => {
    <ResultBox>
      <div className=%twc("w-full h-9 flex items-center justify-center text-disabled-L1 text-sm")>
        <Spinner width="24" height="24" />
      </div>
    </ResultBox>
  }
}

module ResultItem = {
  @react.component
  let make = (~id, ~name, ~select) => {
    <div
      className=%twc("w-full px-3 py-2 rounded-lg hover:bg-gray-100")
      onClick={_ => select(Item.Selected({id, label: name}))}>
      {name->React.string}
    </div>
  }
}

module AdminList = {
  module Fragment = %relay(`
    fragment SelectMDAdminFragment on Query
    @argumentDefinitions(roles: { type: "[UserRole!]!", defaultValue: [ADMIN] }) {
      users(roles: $roles) {
        edges {
          node {
            id
            name
          }
        }
      }
    }
  `)

  @react.component
  let make = (~query, ~keyword, ~select) => {
    let {users: {edges}} = query->Fragment.use
    let includeKeyword = str => str->Js.String2.includes(keyword)

    switch edges {
    | [] => <Empty />
    | nonEmptyEdges =>
      <ResultBox>
        <Scroll>
          {nonEmptyEdges
          ->Array.keep(({node: {name}}) => name->includeKeyword)
          ->Array.map(({node: {id, name}}) => {
            <ResultItem key=id id name select />
          })
          ->React.array}
        </Scroll>
      </ResultBox>
    }
  }
}

module SearchResult = {
  @react.component
  let make = (~query, ~keyword, ~select) => {
    <AdminList query keyword select />
  }
}

module SelectedItem = {
  @react.component
  let make = (~label, ~select) => {
    let reset = _ => select(Item.NotSelected)
    <div className=%twc("relative")>
      <input
        type_="text"
        className=%twc(
          "w-full h-9 py-2 px-3 rounded-lg border border-border-default-L1 focus:outline-none focus:ring-1-gl focus:border-border-active focus:ring-opacity-100 remove-spin-button text-sm text-text-L1 underline"
        )
        placeholder={`고객을 검색해주세요.`}
        defaultValue=label
        onChange=reset
      />
      <span className=%twc("absolute top-1/2 -translate-y-1/2 right-2")>
        <IconArrowSelect height="24" width="24" fill="#121212" />
      </span>
      <button onClick=reset className=%twc("absolute top-1/2 -translate-y-1/2 right-3")>
        <IconCloseInput height="20" width="20" fill="#B2B2B2" />
      </button>
    </div>
  }
}

module DebouncedInput = {
  let makeDebounce = (fn, ms) => {
    let timeoutId = ref(None)

    let reset = id => {
      id->Js.Global.clearTimeout
      timeoutId := None
    }

    v => {
      timeoutId.contents->Option.map(reset)->ignore
      timeoutId := Js.Global.setTimeout(_ => fn(v), ms)->Some
    }
  }

  @react.component
  let make = (~inputRef, ~placeholder, ~onChange, ~onFocus, ~onBlur) => {
    let handleChange = e => {
      (e->ReactEvent.Synthetic.target)["value"]->onChange
    }

    <div className=%twc("relative")>
      <input
        ref={inputRef->ReactDOM.Ref.domRef}
        type_="text"
        className=%twc(
          "w-full h-9 py-2 pl-3 pr-6 rounded-lg border border-border-default-L1 focus:outline-none focus:ring-1-gl focus:border-border-active focus:ring-opacity-100 remove-spin-button text-sm text-text-L1"
        )
        placeholder
        onChange={handleChange->makeDebounce(300)}
        onFocus
        onBlur
      />
      <span className=%twc("absolute top-1/2 -translate-y-1/2 right-2")>
        <IconArrowSelect height="24" width="24" fill="#121212" />
      </span>
    </div>
  }
}

// ----------------------------------------------------------------------------

@react.component
let make = (~query, ~placeholder=`담당 MD를 선택해주세요.`, ~value, ~onChange) => {
  let inputRef = React.useRef(Js.Nullable.null)

  let (focused, setFocused) = React.Uncurried.useState(_ => Blurred)
  let (keyword, setKeyword) = React.Uncurried.useState(_ => "")

  let select = s => {
    setFocused(._ => Blurred)
    setKeyword(._ => "")
    s->onChange
  }

  let onFocus = _ => {
    setFocused(._ => Focused)
    setKeyword(._ => "")
  }

  let reset = _ => {
    switch inputRef.current->Js.Nullable.toOption {
    | None => ()
    | Some(el) => el->resetInput
    }
    setFocused(._ => Blurred)
    setKeyword(._ => "")
  }

  <div className=%twc("relative w-full")>
    {switch value {
    | Item.NotSelected =>
      <DebouncedInput
        inputRef placeholder onChange={v => setKeyword(._ => v)} onFocus onBlur={_ => ()}
      />
    | Item.Selected({label}) => <SelectedItem label select />
    }}
    {switch focused {
    | Blurred => React.null
    | _ =>
      <React.Suspense fallback={<Loading />}>
        <div onClick=reset className=%twc("fixed top-0 left-0 w-full h-full") />
        <SearchResult query keyword select />
      </React.Suspense>
    }}
  </div>
}
