// Generated by ReScript, PLEASE EDIT WITH CARE

import * as CssJs from "bs-css-emotion/src/CssJs.mjs";
import * as React from "react";
import * as Belt_Array from "rescript/lib/es6/belt_Array.js";
import * as ReactToastNotifications from "react-toast-notifications";

function placements(placement) {
  if (placement === "top-left") {
    return [
            CssJs.top(CssJs.px(0)),
            CssJs.left(CssJs.px(0))
          ];
  } else if (placement === "top-center") {
    return [
            CssJs.top(CssJs.px(0)),
            CssJs.left(CssJs.pct(50)),
            CssJs.transform(CssJs.translateX(CssJs.pct(-50)))
          ];
  } else if (placement === "top-right") {
    return [
            CssJs.top(CssJs.px(0)),
            CssJs.right(CssJs.px(0))
          ];
  } else if (placement === "bottom-left") {
    return [
            CssJs.bottom(CssJs.px(0)),
            CssJs.left(CssJs.px(0))
          ];
  } else if (placement === "bottom-right") {
    return [
            CssJs.bottom(CssJs.px(0)),
            CssJs.right(CssJs.px(0))
          ];
  } else {
    return [
            CssJs.bottom(CssJs.px(0)),
            CssJs.left(CssJs.pct(50)),
            CssJs.transform(CssJs.translateX(CssJs.pct(-50)))
          ];
  }
}

function container(placement) {
  return CssJs.style(Belt_Array.concat([
                  CssJs.position("fixed"),
                  CssJs.zIndex(1000),
                  CssJs.width(CssJs.pct(100.0)),
                  CssJs.maxWidth(CssJs.px(728)),
                  CssJs.maxHeight(CssJs.pct(100.0)),
                  CssJs.paddingRight(CssJs.px(16)),
                  CssJs.paddingLeft(CssJs.px(16)),
                  CssJs.overflow("hidden")
                ], placements(placement)));
}

function toast(transitionDuration, transitionState) {
  var tmp = transitionState === "entered" ? 1.0 : 0.0;
  return CssJs.style([
              CssJs.display("flex"),
              CssJs.alignItems("center"),
              CssJs.width(CssJs.pct(100.0)),
              CssJs.height(CssJs.px(50)),
              CssJs.paddingRight(CssJs.px(16)),
              CssJs.paddingLeft(CssJs.px(16)),
              CssJs.borderRadius(CssJs.px(10)),
              CssJs.backgroundColor(CssJs.hsla(CssJs.deg(0.0), CssJs.pct(0.0), CssJs.pct(0.0), {
                        NAME: "num",
                        VAL: 0.8
                      })),
              CssJs.transition(transitionDuration, undefined, "easeInOut", "all"),
              CssJs.opacity(tmp),
              CssJs.marginBottom(CssJs.rem(0.5))
            ]);
}

var p = CssJs.style([
      CssJs.fontSize(CssJs.px(15)),
      CssJs.color(CssJs.white),
      CssJs.overflow("hidden"),
      CssJs.textOverflow("ellipsis"),
      CssJs.whiteSpace("nowrap")
    ]);

function ReactToastNotifications$Custom$ToastContainer(props) {
  return React.createElement("div", {
              className: container(props.placement)
            }, props.children);
}

var ToastContainer = {
  make: ReactToastNotifications$Custom$ToastContainer
};

function ReactToastNotifications$Custom$Toast(props) {
  return React.createElement("div", {
              className: toast(props.transitionDuration, props.transitionState)
            }, React.createElement("p", {
                  className: p
                }, props.children));
}

var Toast = {
  make: ReactToastNotifications$Custom$Toast
};

var Component = {};

function ReactToastNotifications$ToastProvider(props) {
  var placement = props.placement;
  var placement$1 = placement !== undefined ? placement : "top-center";
  return React.createElement(ReactToastNotifications.ToastProvider, {
              autoDismissTimeout: 2000,
              autoDismiss: true,
              components: {
                ToastContainer: (function (param) {
                    return React.createElement(ReactToastNotifications$Custom$ToastContainer, {
                                children: param.children,
                                placement: param.placement
                              });
                  }),
                Toast: (function (param) {
                    return React.createElement(ReactToastNotifications$Custom$Toast, {
                                children: param.children,
                                transitionDuration: param.transitionDuration,
                                transitionState: param.transitionState
                              });
                  })
              },
              placement: placement$1,
              portalTargetSelector: props.portalTargetSelector,
              transitionDuration: props.transitionDuration,
              children: props.children
            });
}

var ToastProvider = {
  Component: Component,
  make: ReactToastNotifications$ToastProvider
};

var Custom = {
  ToastContainer: ToastContainer,
  Toast: Toast
};

export {
  Custom ,
  ToastProvider ,
}
/* p Not a pure module */
