type placementType
module Custom: {
  module ToastContainer: {
    @react.component
    let make: (~children: React.element, ~placement: placementType) => React.element
  }

  module Toast: {
    @react.component
    let make: (
      ~children: React.element,
      ~transitionDuration: int,
      ~transitionState: string,
    ) => React.element
  }
}

module ToastProvider: {
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

  module Component: {
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
  let make: (
    // ~autoDismissTimeout=?,
    // ~autoDismiss=?,
    // ~components=?,
    ~placement: placementType=?,
    ~portalTargetSelector: string=?,
    ~transitionDuration: int=?,
    ~children: React.element,
  ) => React.element
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
