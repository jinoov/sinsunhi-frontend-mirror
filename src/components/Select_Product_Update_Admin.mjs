// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Cx from "rescript-classnames/src/Cx.mjs";
import * as React from "react";
import * as Garter_Array from "@greenlabs/garter/src/Garter_Array.mjs";
import * as IconArrowSelect from "./svgs/IconArrowSelect.mjs";

function encodeWeightUnit(unit) {
  switch (unit) {
    case /* G */0 :
        return "g";
    case /* Kg */1 :
        return "kg";
    case /* Ton */2 :
        return "t";
    
  }
}

function decodeWeightUnit(str) {
  switch (str) {
    case "g" :
        return /* G */0;
    case "kg" :
        return /* Kg */1;
    case "t" :
        return /* Ton */2;
    default:
      return ;
  }
}

function encodeSizeUnit(unit) {
  switch (unit) {
    case /* Mm */0 :
        return "mm";
    case /* Cm */1 :
        return "cm";
    case /* M */2 :
        return "m";
    
  }
}

function decodeSizeUnit(str) {
  switch (str) {
    case "cm" :
        return /* Cm */1;
    case "m" :
        return /* M */2;
    case "mm" :
        return /* Mm */0;
    default:
      return ;
  }
}

function Select_Product_Update_Admin$Weight(Props) {
  var unit = Props.unit;
  var onChange = Props.onChange;
  var disabledOpt = Props.disabled;
  var disabled = disabledOpt !== undefined ? disabledOpt : false;
  var displayUnit = encodeWeightUnit(unit);
  return React.createElement("span", undefined, React.createElement("label", {
                  className: "block relative"
                }, React.createElement("span", {
                      className: Cx.cx([
                            "md:w-20 flex items-center border border-border-default-L1 rounded-md px-3 text-enabled-L1 h-9",
                            disabled ? "bg-disabled-L3" : "bg-white"
                          ])
                    }, displayUnit), React.createElement("span", {
                      className: "absolute top-1.5 right-2"
                    }, React.createElement(IconArrowSelect.make, {
                          height: "24",
                          width: "24",
                          fill: "#121212"
                        })), React.createElement("select", {
                      className: "block w-full h-full absolute top-0 opacity-0",
                      disabled: disabled,
                      value: encodeWeightUnit(unit),
                      onChange: onChange
                    }, Garter_Array.map([
                          /* G */0,
                          /* Kg */1,
                          /* Ton */2
                        ], (function (s) {
                            return React.createElement("option", {
                                        key: encodeWeightUnit(s),
                                        value: encodeWeightUnit(s)
                                      }, encodeWeightUnit(s));
                          })))));
}

var Weight = {
  make: Select_Product_Update_Admin$Weight
};

function Select_Product_Update_Admin$Size(Props) {
  var unit = Props.unit;
  var onChange = Props.onChange;
  var disabledOpt = Props.disabled;
  var disabled = disabledOpt !== undefined ? disabledOpt : false;
  var displayUnit = encodeSizeUnit(unit);
  return React.createElement("span", undefined, React.createElement("label", {
                  className: "block relative"
                }, React.createElement("span", {
                      className: Cx.cx([
                            "md:w-20 flex items-center border border-border-default-L1 rounded-md h-9 px-3 text-enabled-L1",
                            disabled ? "bg-disabled-L3" : "bg-white"
                          ])
                    }, displayUnit), React.createElement("span", {
                      className: "absolute top-1.5 right-2"
                    }, React.createElement(IconArrowSelect.make, {
                          height: "24",
                          width: "24",
                          fill: "#121212"
                        })), React.createElement("select", {
                      className: "block w-full h-full absolute top-0 opacity-0",
                      disabled: disabled,
                      value: encodeSizeUnit(unit),
                      onChange: onChange
                    }, Garter_Array.map([
                          /* Mm */0,
                          /* Cm */1,
                          /* M */2
                        ], (function (s) {
                            return React.createElement("option", {
                                        key: encodeSizeUnit(s),
                                        value: encodeSizeUnit(s)
                                      }, encodeSizeUnit(s));
                          })))));
}

var Size = {
  make: Select_Product_Update_Admin$Size
};

export {
  encodeWeightUnit ,
  decodeWeightUnit ,
  encodeSizeUnit ,
  decodeSizeUnit ,
  Weight ,
  Size ,
}
/* react Not a pure module */
