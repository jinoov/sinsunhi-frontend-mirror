// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Spice from "@greenlabs/ppx-spice/src/rescript/Spice.mjs";
import * as React from "react";
import * as Js_json from "rescript/lib/es6/js_json.js";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as ReactRadioGroup from "@radix-ui/react-radio-group";

function status_encode(v) {
  switch (v) {
    case /* ALL */0 :
        return "all";
    case /* AVAILABLE */1 :
        return "available";
    case /* UNAVAILABLE */2 :
        return "unavailable";
    
  }
}

function status_decode(v) {
  var str = Js_json.classify(v);
  if (typeof str === "number") {
    return Spice.error(undefined, "Not a JSONString", v);
  }
  if (str.TAG !== /* JSONString */0) {
    return Spice.error(undefined, "Not a JSONString", v);
  }
  var str$1 = str._0;
  if ("all" === str$1) {
    return {
            TAG: /* Ok */0,
            _0: /* ALL */0
          };
  } else if ("available" === str$1) {
    return {
            TAG: /* Ok */0,
            _0: /* AVAILABLE */1
          };
  } else if ("unavailable" === str$1) {
    return {
            TAG: /* Ok */0,
            _0: /* UNAVAILABLE */2
          };
  } else {
    return Spice.error(undefined, "Not matched", v);
  }
}

function Select_Delivery_Available(Props) {
  var value = Props.value;
  var onChange = Props.onChange;
  var name = Props.name;
  return React.createElement(ReactRadioGroup.Root, {
              children: null,
              value: Belt_Option.getWithDefault(Js_json.decodeString(status_encode(value)), "all"),
              onValueChange: onChange,
              name: name,
              className: "flex items-center"
            }, React.createElement(ReactRadioGroup.Item, {
                  children: React.createElement(ReactRadioGroup.Indicator, {
                        className: "radio-indicator"
                      }),
                  value: "all",
                  className: "radio-item",
                  id: "delivery-all"
                }), React.createElement("label", {
                  className: "ml-2 mr-6",
                  htmlFor: "delivery-all"
                }, "전체"), React.createElement(ReactRadioGroup.Item, {
                  children: React.createElement(ReactRadioGroup.Indicator, {
                        className: "radio-indicator"
                      }),
                  value: "available",
                  className: "radio-item",
                  id: "delivery-available"
                }), React.createElement("label", {
                  className: "ml-2 mr-6",
                  htmlFor: "delivery-available"
                }, "가능"), React.createElement(ReactRadioGroup.Item, {
                  children: React.createElement(ReactRadioGroup.Indicator, {
                        className: "radio-indicator"
                      }),
                  value: "unavailable",
                  className: "radio-item",
                  id: "delivery-unavailable"
                }), React.createElement("label", {
                  className: "ml-2 mr-6",
                  htmlFor: "delivery-unavailable"
                }, "불가능"));
}

var make = Select_Delivery_Available;

export {
  status_encode ,
  status_decode ,
  make ,
}
/* react Not a pure module */
