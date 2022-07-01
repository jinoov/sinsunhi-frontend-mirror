// Generated by ReScript, PLEASE EDIT WITH CARE

import * as React from "react";
import * as Js_dict from "rescript/lib/es6/js_dict.js";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as Garter_Array from "@greenlabs/garter/src/Garter_Array.mjs";
import * as IconArrowSelect from "./svgs/IconArrowSelect.mjs";

function toString(std) {
  if (std === "Cultivar") {
    return "Cultivar";
  } else {
    return "Crop";
  }
}

function decodeStd(std) {
  if (std === "Crop") {
    return "Crop";
  } else if (std === "Cultivar") {
    return "Cultivar";
  } else {
    return ;
  }
}

function parseSearchStd(q) {
  return Belt_Option.flatMap(Js_dict.get(q, "searchStd"), decodeStd);
}

function formatStd(std) {
  if (std === "Cultivar") {
    return "품종";
  } else {
    return "작물";
  }
}

function Select_Crop_Search_Std(Props) {
  var std = Props.std;
  var onChange = Props.onChange;
  var displayStd = formatStd(std);
  return React.createElement("span", undefined, React.createElement("label", {
                  className: "block relative"
                }, React.createElement("span", {
                      className: "md:w-44 flex items-center border border-border-default-L1 bg-white rounded-md h-9 px-3 text-enabled-L1"
                    }, displayStd), React.createElement("span", {
                      className: "absolute top-1.5 right-2"
                    }, React.createElement(IconArrowSelect.make, {
                          height: "24",
                          width: "24",
                          fill: "#121212"
                        })), React.createElement("select", {
                      className: "block w-full h-full absolute top-0 opacity-0",
                      value: toString(std),
                      onChange: onChange
                    }, Garter_Array.map([
                          "Crop",
                          "Cultivar"
                        ], (function (s) {
                            return React.createElement("option", {
                                        key: toString(s),
                                        value: toString(s)
                                      }, formatStd(s));
                          })))));
}

var make = Select_Crop_Search_Std;

export {
  toString ,
  decodeStd ,
  parseSearchStd ,
  formatStd ,
  make ,
  
}
/* react Not a pure module */