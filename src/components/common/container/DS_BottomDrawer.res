let toStyle = (isShow, show, hide, style) => {
  cx([isShow ? show : hide, style])
}

let useLockBodyScroll = isLock => {
  open Webapi

  React.useEffect1(_ => {
    let bodyElement = Dom.document->Dom.Document.querySelector("body")

    switch (isLock, bodyElement) {
    | (true, Some(el)) => {
        el->Dom.Element.classList->Webapi.Dom.DomTokenList.add("overflow-hidden")
        Some(() => el->Dom.Element.classList->Webapi.Dom.DomTokenList.remove("overflow-hidden"))
      }

    | (false, Some(el)) => {
        el->Dom.Element.classList->Webapi.Dom.DomTokenList.remove("overflow-hidden")
        None
      }

    | _ => None
    }
  }, [isLock])
}

module BottomDrawerContext = {
  let context = React.createContext(() => ())

  module Provider = {
    let provider = React.Context.provider(context)

    @react.component
    let make = (~value, ~children) => {
      React.createElement(provider, {"value": value, "children": children})
    }
  }
}

module Overlay = {
  @react.component
  let make = (~isShow) => {
    let overlayStyle = isShow->toStyle(%twc("opacity-100"), %twc("opacity-0 pointer-events-none"))
    let handleClose = React.useContext(BottomDrawerContext.context)
    <div
      className={%twc(
        "fixed top-0 left-0 w-full h-full bg-dim transition-opacity z-[12]"
      )->overlayStyle}
      onClick={_ => handleClose()}
    />
  }
}

module Header = {
  @react.component
  let make = (~children=?) => {
    let handleClose = React.useContext(BottomDrawerContext.context)

    <header className=%twc("flex justify-between items-center")>
      <div className=%twc("m-4")> {children->Option.getWithDefault(React.null)} </div>
      <span onClick={_ => handleClose()} className=%twc("cursor-pointer p-4")>
        <IconClose width="24" height="24" />
      </span>
    </header>
  }
}

module Body = {
  @react.component
  let make = (~children, ~scrollable=false) => {
    <div
      className={cx([
        %twc("flex flex-col"),
        scrollable ? %twc("overflow-auto") : %twc("overflow-hidden"),
      ])}>
      children
    </div>
  }
}

type dimLocation =
  | Body
  | Declared

module Root = {
  @react.component
  let make = (~isShow, ~onClose, ~children, ~full=false, ~dimLocation=Declared) => {
    useLockBodyScroll(isShow)
    let showStyle = isShow->toStyle(%twc("bottom-0"), %twc("-bottom-full"))

    let content =
      <BottomDrawerContext.Provider value={onClose}>
        <Overlay isShow={isShow} />
        <div
          ariaHidden={!isShow}
          className={cx([
            full ? "h-full" : "max-h-[85vh]",
            %twc(
              "flex flex-col fixed w-full z-[13] left-1/2 -translate-x-1/2 max-w-3xl mx-auto bg-white rounded-t-2xl drawer-transition"
            ),
          ])->showStyle}>
          children
        </div>
      </BottomDrawerContext.Provider>

    switch dimLocation {
    | Body => <RadixUI.Portal.Root> {content} </RadixUI.Portal.Root>
    | Declared => content
    }
  }
}
