// Generated by ReScript, PLEASE EDIT WITH CARE

import * as React from "react";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import InputCheckSvg from "../../../public/assets/input-check.svg";

var inputCheckIcon = InputCheckSvg;

function Checkbox(Props) {
  var id = Props.id;
  var name = Props.name;
  var checked = Props.checked;
  var onChange = Props.onChange;
  var disabled = Props.disabled;
  var style;
  var exit = 0;
  if (disabled !== undefined && disabled) {
    style = "w-5 h-5 border-2 border-gray-200 bg-gray-100 rounded flex justify-center items-center";
  } else {
    exit = 1;
  }
  if (exit === 1) {
    style = checked !== undefined ? (
        checked ? "w-5 h-5 bg-green-gl rounded flex justify-center items-center cursor-pointer" : "w-5 h-5 bg-white border-2 border-gray-300 rounded flex justify-center items-center cursor-pointer"
      ) : "w-5 h-5 border-2 border-gray-200 bg-gray-100 rounded flex justify-center items-center";
  }
  var tmp = {
    className: "hidden",
    type: "checkbox"
  };
  if (id !== undefined) {
    tmp.id = Caml_option.valFromOption(id);
  }
  if (checked !== undefined) {
    tmp.checked = Caml_option.valFromOption(checked);
  }
  if (disabled !== undefined) {
    tmp.disabled = Caml_option.valFromOption(disabled);
  }
  if (name !== undefined) {
    tmp.name = Caml_option.valFromOption(name);
  }
  if (onChange !== undefined) {
    tmp.onChange = Caml_option.valFromOption(onChange);
  }
  return React.createElement(React.Fragment, undefined, React.createElement("input", tmp), React.createElement("label", {
                  className: style,
                  htmlFor: Belt_Option.getWithDefault(id, "")
                }, Belt_Option.mapWithDefault(checked, null, (function (checked$p) {
                        if (checked$p) {
                          return React.createElement("img", {
                                      src: inputCheckIcon
                                    });
                        } else {
                          return null;
                        }
                      }))));
}

function Checkbox$Uncontrolled(Props) {
  var id = Props.id;
  var name = Props.name;
  var defaultChecked = Props.defaultChecked;
  var onBlur = Props.onBlur;
  var onChange = Props.onChange;
  var disabled = Props.disabled;
  var inputRef = Props.inputRef;
  var tmp = {
    className: "peer hidden",
    type: "checkbox"
  };
  if (inputRef !== undefined) {
    tmp.ref = Caml_option.valFromOption(inputRef);
  }
  if (defaultChecked !== undefined) {
    tmp.defaultChecked = Caml_option.valFromOption(defaultChecked);
  }
  if (id !== undefined) {
    tmp.id = Caml_option.valFromOption(id);
  }
  if (disabled !== undefined) {
    tmp.disabled = Caml_option.valFromOption(disabled);
  }
  if (name !== undefined) {
    tmp.name = Caml_option.valFromOption(name);
  }
  if (onBlur !== undefined) {
    tmp.onBlur = Caml_option.valFromOption(onBlur);
  }
  if (onChange !== undefined) {
    tmp.onChange = Caml_option.valFromOption(onChange);
  }
  return React.createElement(React.Fragment, undefined, React.createElement("input", tmp), React.createElement("label", {
                  className: "w-5 h-5 rounded flex justify-center items-center peer-default:bg-white border-2 peer-default:border-gray-300 peer-checked:bg-green-gl peer-disabled:border-2 peer-disabled:border-gray-200 peer-disabled:bg-gray-100",
                  htmlFor: Belt_Option.getWithDefault(id, "")
                }, React.createElement("img", {
                      src: inputCheckIcon
                    })));
}

var Uncontrolled = {
  make: Checkbox$Uncontrolled
};

var make = Checkbox;

export {
  inputCheckIcon ,
  make ,
  Uncontrolled ,
}
/* inputCheckIcon Not a pure module */
