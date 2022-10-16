// Generated by ReScript, PLEASE EDIT WITH CARE

import * as React from "react";
import * as Js_dict from "rescript/lib/es6/js_dict.js";
import * as Belt_Int from "rescript/lib/es6/belt_Int.js";
import * as Constants from "../constants/Constants.mjs";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as Router from "next/router";
import * as Garter_Array from "@greenlabs/garter/src/Garter_Array.mjs";
import * as IconArrowSelect from "./svgs/IconArrowSelect.mjs";

function getCountPerPage(q) {
  return Belt_Option.flatMap(Js_dict.get(q, "limit"), Belt_Int.fromString);
}

function Select_CountPerPage(Props) {
  var className = Props.className;
  var router = Router.useRouter();
  var onChange = function (e) {
    var limit = e.target.value;
    router.query["limit"] = limit;
    router.query["offset"] = "0";
    router.push("" + router.pathname + "?" + new URLSearchParams(router.query).toString() + "");
  };
  var displayCount = function (q) {
    return Belt_Option.mapWithDefault(getCountPerPage(q), "" + String(Constants.defaultCountPerPage) + "개씩 보기", (function (limit) {
                  return "" + String(limit) + "개씩 보기";
                }));
  };
  var tmp = {};
  if (className !== undefined) {
    tmp.className = Caml_option.valFromOption(className);
  }
  return React.createElement("span", tmp, React.createElement("label", {
                  className: "block relative"
                }, React.createElement("span", {
                      className: "w-36 flex items-center border border-border-default-L1 rounded-md h-9 px-3 text-enabled-L1"
                    }, displayCount(router.query)), React.createElement("span", {
                      className: "absolute top-1.5 right-2"
                    }, React.createElement(IconArrowSelect.make, {
                          height: "24",
                          width: "24",
                          fill: "#121212"
                        })), React.createElement("select", {
                      className: "block w-full h-full absolute top-0 opacity-0",
                      value: Belt_Option.mapWithDefault(getCountPerPage(router.query), String(Constants.defaultCountPerPage), (function (limit) {
                              return String(limit);
                            })),
                      onChange: onChange
                    }, Garter_Array.map(Constants.countsPerPage, (function (c) {
                            return React.createElement("option", {
                                        key: String(c),
                                        value: String(c)
                                      }, "" + String(c) + "개씩 보기");
                          })))));
}

var make = Select_CountPerPage;

export {
  getCountPerPage ,
  make ,
}
/* react Not a pure module */
