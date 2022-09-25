// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Spice from "@greenlabs/ppx-spice/src/rescript/Spice.mjs";
import * as React from "react";
import * as Js_dict from "rescript/lib/es6/js_dict.js";
import * as Js_json from "rescript/lib/es6/js_json.js";
import * as Converter from "../utils/Converter.mjs";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as Router from "next/router";
import * as Garter_Array from "@greenlabs/garter/src/Garter_Array.mjs";
import * as IconArrowSelect from "./svgs/IconArrowSelect.mjs";

function kind_encode(v) {
  if (v) {
    return "false";
  } else {
    return "true";
  }
}

function kind_decode(v) {
  var str = Js_json.classify(v);
  if (typeof str === "number") {
    return Spice.error(undefined, "Not a JSONString", v);
  }
  if (str.TAG !== /* JSONString */0) {
    return Spice.error(undefined, "Not a JSONString", v);
  }
  var str$1 = str._0;
  if ("true" === str$1) {
    return {
            TAG: /* Ok */0,
            _0: /* OnlyNullCost */0
          };
  } else if ("false" === str$1) {
    return {
            TAG: /* Ok */0,
            _0: /* ExcludeNullCost */1
          };
  } else {
    return Spice.error(undefined, "Not matched", v);
  }
}

function getIsOnlyNull(q) {
  return Js_dict.get(q, "only-null");
}

function displayKind(k) {
  if (k) {
    return "원가 있음";
  } else {
    return "원가 없음";
  }
}

function Select_Cost_Kind(props) {
  var router = Router.useRouter();
  var onChange = function (e) {
    var isOnlyNull = e.target.value;
    router.query["only-null"] = isOnlyNull;
    router.push("" + router.pathname + "?" + new URLSearchParams(router.query).toString() + "");
  };
  var tmp = {};
  if (props.className !== undefined) {
    tmp.className = Caml_option.valFromOption(props.className);
  }
  return React.createElement("span", tmp, React.createElement("label", {
                  className: "block relative"
                }, React.createElement("span", {
                      className: "w-36 flex items-center border border-border-default-L1 rounded-md h-9 px-3 text-enabled-L1"
                    }, Belt_Option.getWithDefault(Belt_Option.map(Belt_Option.flatMap(Js_dict.get(router.query, "only-null"), (function (kind) {
                                    var kind$p = kind_decode(kind);
                                    if (kind$p.TAG === /* Ok */0) {
                                      return kind$p._0;
                                    }
                                    
                                  })), displayKind), "전체")), React.createElement("span", {
                      className: "absolute top-1.5 right-2"
                    }, React.createElement(IconArrowSelect.make, {
                          height: "24",
                          width: "24",
                          fill: "#121212"
                        })), React.createElement("select", {
                      className: "block w-full h-full absolute top-0 opacity-0",
                      value: Belt_Option.getWithDefault(Js_dict.get(router.query, "only-null"), ""),
                      onChange: onChange
                    }, React.createElement("option", {
                          value: ""
                        }, "전체"), Garter_Array.map([
                          /* OnlyNullCost */0,
                          /* ExcludeNullCost */1
                        ], (function (k) {
                            return React.createElement("option", {
                                        key: Converter.getStringFromJsonWithDefault(k ? "false" : "true", ""),
                                        value: Converter.getStringFromJsonWithDefault(k ? "false" : "true", "")
                                      }, k ? "원가 있음" : "원가 없음");
                          })))));
}

var make = Select_Cost_Kind;

export {
  kind_encode ,
  kind_decode ,
  getIsOnlyNull ,
  displayKind ,
  make ,
}
/* react Not a pure module */
