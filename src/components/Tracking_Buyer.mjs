// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Env from "../constants/Env.mjs";
import * as React from "react";
import * as Global from "./Global.mjs";
import * as Helper from "../utils/Helper.mjs";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as CustomHooks from "../utils/CustomHooks.mjs";
import * as ReactEvents from "../utils/ReactEvents.mjs";

function Tracking_Buyer(Props) {
  var order = Props.order;
  var status = CustomHooks.SweetTracker.use(undefined);
  var openPopupPostFormData = function (param) {
    return ReactEvents.interceptingHandler((function (param) {
                  var popUpWindowName = "tacking";
                  var form = document.getElementById("" + order.orderProductNo + "-tracking-form");
                  if (Global.$$window === undefined) {
                    return ;
                  }
                  if (form == null) {
                    return ;
                  }
                  var match = window.ReactNativeWebView;
                  if (match == null) {
                    Caml_option.valFromOption(Global.$$window).open("", popUpWindowName, "width=800, height=1000,location=yes,resizable=yes,scrollbars=yes,status=yes");
                    form.setAttribute("target", popUpWindowName);
                  }
                  form.setAttribute("action", Env.sweettrackerUrl);
                  form.submit();
                }), param);
  };
  var tmp;
  var exit = 0;
  if (typeof status === "number" || status.TAG !== /* Loaded */0) {
    exit = 1;
  } else {
    var data$p = CustomHooks.SweetTracker.response_decode(status._0);
    if (data$p.TAG === /* Ok */0) {
      var data$p$1 = data$p._0;
      tmp = Belt_Option.getWithDefault(Helper.$$Option.map2(order.courierCode, order.invoice, (function (courierCode, invoice) {
                  return React.createElement(React.Fragment, undefined, React.createElement("form", {
                                  className: "hidden",
                                  id: "" + order.orderProductNo + "-tracking-form",
                                  action: Env.sweettrackerUrl,
                                  method: "post"
                                }, React.createElement("input", {
                                      defaultValue: data$p$1.data.stApiKey,
                                      name: "t_key",
                                      type: "text"
                                    }), React.createElement("input", {
                                      defaultValue: courierCode,
                                      name: "t_code",
                                      type: "text"
                                    }), React.createElement("input", {
                                      defaultValue: invoice,
                                      name: "t_invoice",
                                      type: "text"
                                    })), React.createElement("button", {
                                  className: "px-3 max-h-10 bg-green-gl-light text-green-gl font-bold rounded-lg whitespace-nowrap py-1 mt-2",
                                  type: "button",
                                  onClick: openPopupPostFormData
                                }, "조회하기"));
                })), React.createElement("button", {
                className: "px-3 max-h-10 bg-gray-100 text-gray-300 rounded-lg whitespace-nowrap py-1 mt-2",
                disabled: true,
                type: "button",
                onClick: openPopupPostFormData
              }, "조회하기"));
    } else {
      tmp = React.createElement("button", {
            className: "px-3 max-h-10 bg-gray-100 text-gray-300 rounded-lg whitespace-nowrap py-1 mt-2",
            disabled: true,
            type: "button"
          }, "조회하기");
    }
  }
  if (exit === 1) {
    tmp = React.createElement("button", {
          className: "px-3 max-h-10 bg-gray-100 text-gray-300 rounded-lg whitespace-nowrap py-1 mt-2",
          disabled: true,
          type: "button"
        }, "조회하기");
  }
  return React.createElement("div", {
              className: "mt-2"
            }, tmp);
}

var make = Tracking_Buyer;

export {
  make ,
}
/* Env Not a pure module */
