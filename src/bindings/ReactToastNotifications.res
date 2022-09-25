type placementType = [
  | #"top-left"
  | #"top-center"
  | #"top-right"
  | #"bottom-left"
  | #"bottom-center"
  | #"bottom-right"
]
module Custom = {
  module Styles = {
    open CssJs

    let placements = placement =>
      switch placement {
      | #"top-left" => [top(px(0)), left(px(0))]
      | #"top-center" => [top(px(0)), left(pct(50.)), transform(translateX(pct(-50.)))]
      | #"top-right" => [top(px(0)), right(px(0))]
      | #"bottom-left" => [bottom(px(0)), left(px(0))]
      | #"bottom-center" => [bottom(px(0)), left(pct(50.)), transform(translateX(pct(-50.)))]
      | #"bottom-right" => [bottom(px(0)), right(px(0))]
      }

    let container = placement =>
      style(.
        [
          position(#fixed),
          zIndex(1000),
          width(pct(100.0)),
          maxWidth(px(728)),
          maxHeight(pct(100.0)),
          paddingRight(px(16)),
          paddingLeft(px(16)),
          overflow(#hidden),
        ]->Array.concat(placements(placement)),
      )

    let toast = (transitionDuration, transitionState) =>
      style(. [
        display(#flex),
        alignItems(#center),
        width(pct(100.0)),
        height(px(50)),
        paddingRight(px(16)),
        paddingLeft(px(16)),
        borderRadius(px(10)),
        backgroundColor(hsla(deg(0.0), pct(0.0), pct(0.0), #num(0.8))),
        transition("all", ~duration=transitionDuration, ~timingFunction=#easeInOut),
        opacity(
          switch transitionState {
          | "entered" => 1.0
          | _ => 0.0
          },
        ),
        marginBottom(rem(0.5)),
      ])

    let p = style(. [
      fontSize(px(15)),
      color(white),
      overflow(#hidden),
      textOverflow(#ellipsis),
      whiteSpace(#nowrap),
    ])
  }

  module ToastContainer = {
    @react.component
    let make = (~children, ~placement) => {
      <div className={Styles.container(placement)}> {children} </div>
    }
  }

  module Toast = {
    @react.component
    let make = (~children, ~transitionDuration, ~transitionState) => {
      <div className={Styles.toast(transitionDuration, transitionState)}>
        <p className=Styles.p> {children} </p>
      </div>
    }
  }
}

module ToastProvider = {
  type containerProps = {
    // autoDismiss,
    // autoDismissTimeout,
    // isRunning,
    // onMouseEnter,
    // onMouseLeave,
    // appearance,
    // onDismiss,
    placement: placementType,
    transitionDuration: int,
    transitionState: string,
    children: React.element,
  }

  type componentProps = {
    transitionDuration: int,
    transitionState: string,
    children: React.element,
  }

  type components = {
    "ToastContainer": containerProps => React.element,
    "Toast": componentProps => React.element,
  }

  module Component = {
    @module("react-toast-notifications") @react.component
    external make: (
      ~autoDismissTimeout: int,
      ~autoDismiss: bool,
      ~components: components,
      ~placement: placementType,
      ~portalTargetSelector: option<string>,
      ~transitionDuration: option<int>,
      ~children: React.element,
    ) => React.element = "ToastProvider"
  }

  @react.component
  let make = (
    // ~autoDismissTimeout=?,
    // ~autoDismiss=?,
    // ~components=?,
    ~placement: placementType=#"top-center",
    ~portalTargetSelector=?,
    ~transitionDuration=?,
    ~children,
  ) => {
    <Component
      autoDismissTimeout=2000
      autoDismiss=true
      components={{
        "ToastContainer": ({children, placement}: containerProps) =>
          <Custom.ToastContainer placement> {children} </Custom.ToastContainer>,
        "Toast": ({children, transitionDuration, transitionState}) =>
          <Custom.Toast transitionDuration transitionState> {children} </Custom.Toast>,
      }}
      placement
      portalTargetSelector
      transitionDuration>
      {children}
    </Component>
  }
}

type addToast = {appearance: string}

type hook = {
  addToast: (. React.element, addToast) => unit,
  // removeToast: removeToastT,
  // removeAllToasts: removeAllToastsT,
  // updateToast: updateToastT,
  // toastStack: toastStackT,
}

@module("react-toast-notifications")
external useToasts: unit => hook = "useToasts"
