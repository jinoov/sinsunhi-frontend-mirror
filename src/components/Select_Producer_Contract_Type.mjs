// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Curry from "rescript/lib/es6/curry.js";
import * as Spice from "@greenlabs/ppx-spice/src/rescript/Spice.mjs";
import * as React from "react";
import * as Js_json from "rescript/lib/es6/js_json.js";
import * as Belt_Array from "rescript/lib/es6/belt_Array.js";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as IconArrowSelect from "./svgs/IconArrowSelect.mjs";

function status_encode(v) {
  if (v) {
    return "전량판매";
  } else {
    return "온라인택배";
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
  if ("온라인택배" === str$1) {
    return {
            TAG: /* Ok */0,
            _0: /* ONLINESALE */0
          };
  } else if ("전량판매" === str$1) {
    return {
            TAG: /* Ok */0,
            _0: /* BULKSALE */1
          };
  } else {
    return Spice.error(undefined, "Not matched", v);
  }
}

function toString(status) {
  return Js_json.decodeString(status ? "전량판매" : "온라인택배");
}

function Select_Producer_Contract_Type(Props) {
  var status = Props.status;
  var onChange = Props.onChange;
  var forwardRef = Props.forwardRef;
  var displayStatus = Belt_Option.getWithDefault(Belt_Option.flatMap(status, toString), "공급가 타입 선택");
  var value = Belt_Option.getWithDefault(Belt_Option.flatMap(status, toString), "");
  var handleOnChange = function (e) {
    var status = e.target.value;
    var status$p = status_decode(status);
    if (status$p.TAG === /* Ok */0) {
      return Curry._1(onChange, status$p._0);
    }
    
  };
  return React.createElement("span", undefined, React.createElement("label", {
                  className: "block relative"
                }, React.createElement("span", {
                      className: "flex px-3 py-2 border items-center bg-white border-border-default-L1 rounded-lg h-9 text-enabled-L1 focus:outline"
                    }, displayStatus), React.createElement("span", {
                      className: "absolute top-1.5 right-2"
                    }, React.createElement(IconArrowSelect.make, {
                          height: "24",
                          width: "24",
                          fill: "#121212"
                        })), React.createElement("select", {
                      ref: forwardRef,
                      className: "block w-full h-full absolute top-0 opacity-0",
                      value: value,
                      onChange: handleOnChange
                    }, React.createElement("option", {
                          hidden: value !== "",
                          disabled: true,
                          value: ""
                        }, "공급가 타입 선택"), Belt_Array.map([
                          /* ONLINESALE */0,
                          /* BULKSALE */1
                        ], (function (s) {
                            var value = Belt_Option.getWithDefault(Js_json.decodeString(s ? "전량판매" : "온라인택배"), "");
                            return React.createElement("option", {
                                        key: value,
                                        value: value
                                      }, value);
                          })))));
}

var make = Select_Producer_Contract_Type;

export {
  status_encode ,
  status_decode ,
  toString ,
  make ,
}
/* react Not a pure module */
