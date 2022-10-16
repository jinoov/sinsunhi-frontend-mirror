// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Cx from "rescript-classnames/src/Cx.mjs";
import * as React from "react";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as ReactSwitch from "@radix-ui/react-switch";

function Switcher(Props) {
  var checked = Props.checked;
  var containerClassNameOpt = Props.containerClassName;
  var thumbClassNameOpt = Props.thumbClassName;
  var onCheckedChange = Props.onCheckedChange;
  var disabled = Props.disabled;
  var defaultChecked = Props.defaultChecked;
  var name = Props.name;
  var value = Props.value;
  var containerClassName = containerClassNameOpt !== undefined ? containerClassNameOpt : "";
  var thumbClassName = thumbClassNameOpt !== undefined ? thumbClassNameOpt : "";
  var tmp = {
    children: React.createElement(ReactSwitch.Thumb, {
          className: Cx.cx([
                "w-6 h-6 block bg-white rounded-full transition-transform translate-x-[2px] will-change-transform state-checked:translate-x-[22px]",
                thumbClassName
              ])
        }),
    className: Cx.cx([
          "w-12 h-7 bg-disabled-L2 relative rounded-full state-checked:bg-primary",
          containerClassName
        ])
  };
  if (checked !== undefined) {
    tmp.checked = checked;
  }
  if (defaultChecked !== undefined) {
    tmp.defaultChecked = defaultChecked;
  }
  if (onCheckedChange !== undefined) {
    tmp.onCheckedChange = Caml_option.valFromOption(onCheckedChange);
  }
  if (disabled !== undefined) {
    tmp.disabled = disabled;
  }
  if (name !== undefined) {
    tmp.name = name;
  }
  if (value !== undefined) {
    tmp.value = value;
  }
  return React.createElement(ReactSwitch.Root, tmp);
}

var make = Switcher;

export {
  make ,
}
/* react Not a pure module */
