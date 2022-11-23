type inputElement
@set external setValue: (inputElement, string) => unit = "value"
@get external getValue: inputElement => option<string> = "value"
external getInput: Dom.element => inputElement = "%identity"
let resetInput = el => el->getInput->setValue("")

type inputStatus =
  | Blurred
  | Focused

module Item = {
  type t = {
    id: string,
    label: string,
  }

  type status =
    | NotSelected
    | Selected(t)

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
  let make = (~id, ~name, ~phone, ~select) => {
    let label = `${name}(${phone})`

    <div
      className=%twc("w-full px-3 py-2 rounded-lg hover:bg-gray-100")
      onClick={_ => select(Item.Selected({id, label}))}>
      {label->React.string}
    </div>
  }
}

module BuyerList = {
  module Query = %relay(`
    query SearchBuyerAdminQuery($name: String!) {
      users(name: $name, roles: [BUYER]) {
        edges {
          node {
            id
            name
            phone
          }
        }
      }
    }
  `)

  @react.component
  let make = (~keyword, ~select) => {
    let {users: {edges}} = Query.use(~variables=Query.makeVariables(~name=keyword), ())

    switch edges {
    | [] => <Empty />
    | nonEmptyEdges =>
      <ResultBox>
        <Scroll>
          {nonEmptyEdges
          ->Array.map(({node: {id, name, phone}}) => {
            <ResultItem key=id id name phone select />
          })
          ->React.array}
        </Scroll>
      </ResultBox>
    }
  }
}

module SearchResult = {
  @react.component
  let make = (~keyword, ~select) => {
    switch keyword {
    | "" => <Empty />
    | keyword' => <BuyerList keyword=keyword' select />
    }
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
          "w-full h-9 pl-9 py-2 pr-3 rounded-lg border border-border-default-L1 focus:outline-none focus:ring-1-gl focus:border-border-active focus:ring-opacity-100 remove-spin-button text-sm text-text-L1"
        )
        placeholder={`고객을 검색해주세요.`}
        defaultValue=label
        onChange=reset
      />
      <IconSearch
        className=%twc("absolute top-1/2 -translate-y-1/2 left-3")
        width="20"
        height="20"
        fill="#262626"
      />
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
          "w-full h-9 pl-9 py-2 pr-3 rounded-lg border border-border-default-L1 focus:outline-none focus:ring-1-gl focus:border-border-active focus:ring-opacity-100 remove-spin-button text-sm text-text-L1"
        )
        placeholder
        onChange={handleChange->makeDebounce(400)}
        onFocus
        onBlur
      />
      <IconSearch
        className=%twc("absolute top-1/2 -translate-y-1/2 left-3")
        width="20"
        height="20"
        fill="#262626"
      />
    </div>
  }
}

@react.component
let make = (
  ~defaultValue=Item.NotSelected,
  ~placeholder=`유저를 검색해주세요.`,
  ~onSelect,
) => {
  let inputRef = React.useRef(Js.Nullable.null)

  let (focused, setFocused) = React.Uncurried.useState(_ => Blurred)
  let (keyword, setKeyword) = React.Uncurried.useState(_ => "")
  let (selected, setSelected) = React.Uncurried.useState(_ => defaultValue)

  let select = s => {
    setFocused(._ => Blurred)
    setKeyword(._ => "")
    setSelected(._ => s)
    switch s {
    | NotSelected => None->onSelect
    | Selected({id}) => id->Some->onSelect
    }
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

  <div className=%twc("relative")>
    {switch selected {
    | NotSelected =>
      <DebouncedInput
        inputRef
        placeholder
        onChange={v => setKeyword(._ => v)}
        onFocus
        onBlur={_ => setFocused(._ => Blurred)}
      />
    | Selected({label}) => <SelectedItem label select />
    }}
    {switch (focused, keyword) {
    | (Blurred, "") => React.null
    | _ =>
      <React.Suspense fallback={<Loading />}>
        <div onClick=reset className=%twc("fixed top-0 left-0 w-full h-full") />
        <SearchResult keyword select />
      </React.Suspense>
    }}
  </div>
}
