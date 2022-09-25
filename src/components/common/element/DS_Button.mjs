// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Cn from "rescript-classnames/src/Cn.mjs";
import * as Cx from "rescript-classnames/src/Cx.mjs";
import * as React from "react";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as Caml_option from "rescript/lib/es6/caml_option.js";

function buttonStyle(disabled, buttonType) {
  if (disabled) {
    return "bg-disabled-L2 text-inverted text-opacity-50";
  } else if (buttonType === "secondary") {
    return "bg-primary bg-opacity-10 text-primary";
  } else if (buttonType === "primary") {
    return "bg-primary text-white";
  } else {
    return "bg-surface border border-border-default-L1 text-enabled-L1";
  }
}

var make = React.forwardRef(function (props, ref) {
      var buttonType = props.buttonType;
      var disabled = props.disabled;
      var buttonType$1 = buttonType !== undefined ? buttonType : "primary";
      var disabled$1 = disabled !== undefined ? disabled : false;
      var defaultStyle = Cx.cx([
            buttonStyle(disabled$1, buttonType$1),
            "px-5 py-4 w-full rounded-xl font-bold"
          ]);
      var tmp = {
        className: Belt_Option.mapWithDefault(props.className, defaultStyle, (function (className$p) {
                return Cx.cx([
                            defaultStyle,
                            className$p
                          ]);
              })),
        disabled: disabled$1
      };
      var tmp$1 = Belt_Option.map((ref == null) ? undefined : Caml_option.some(ref), (function (prim) {
              return prim;
            }));
      if (tmp$1 !== undefined) {
        tmp.ref = Caml_option.valFromOption(tmp$1);
      }
      if (props.onClick !== undefined) {
        tmp.onClick = Caml_option.valFromOption(props.onClick);
      }
      return React.createElement("button", tmp, props.label);
    });

var Large1 = {
  make: make
};

var make$1 = React.forwardRef(function (props, ref) {
      var buttonType = props.buttonType;
      var disabled = props.disabled;
      var buttonType$1 = buttonType !== undefined ? buttonType : "primary";
      var disabled$1 = disabled !== undefined ? disabled : false;
      var tmp = {
        className: Cn.make([
              buttonStyle(disabled$1, buttonType$1),
              "w-full py-4"
            ]),
        disabled: disabled$1
      };
      var tmp$1 = Belt_Option.map((ref == null) ? undefined : Caml_option.some(ref), (function (prim) {
              return prim;
            }));
      if (tmp$1 !== undefined) {
        tmp.ref = Caml_option.valFromOption(tmp$1);
      }
      if (props.onClick !== undefined) {
        tmp.onClick = Caml_option.valFromOption(props.onClick);
      }
      return React.createElement("button", tmp, props.label);
    });

var Full1 = {
  make: make$1
};

var Normal = {
  buttonStyle: buttonStyle,
  Large1: Large1,
  Full1: Full1
};

function DS_Button$Chip$TextSmall1(props) {
  var selected = props.selected;
  var selected$1 = selected !== undefined ? selected : false;
  var defaultStyle = Cx.cx([
        selected$1 ? "bg-gray-800 text-white" : "bg-white text-gray-500",
        "px-3 py-1.5 rounded-full"
      ]);
  var tmp = {
    className: Belt_Option.mapWithDefault(props.className, defaultStyle, (function (className$p) {
            return Cx.cx([
                        defaultStyle,
                        className$p
                      ]);
          }))
  };
  if (props.onClick !== undefined) {
    tmp.onClick = Caml_option.valFromOption(props.onClick);
  }
  return React.createElement("button", tmp, props.label);
}

var TextSmall1 = {
  make: DS_Button$Chip$TextSmall1
};

var Chip = {
  TextSmall1: TextSmall1
};

var make$2 = React.forwardRef(function (props, ref) {
      var selected = props.selected;
      var selected$1 = selected !== undefined ? selected : false;
      var tmp = {
        className: Cn.make([
              selected$1 ? "border-b-[3px] border-default text-default" : "text-enabled-L4",
              "h-11 inline-flex flex-row items-center text-lg"
            ])
      };
      var tmp$1 = Belt_Option.map((ref == null) ? undefined : Caml_option.some(ref), (function (prim) {
              return prim;
            }));
      if (tmp$1 !== undefined) {
        tmp.ref = Caml_option.valFromOption(tmp$1);
      }
      if (props.onClick !== undefined) {
        tmp.onClick = Caml_option.valFromOption(props.onClick);
      }
      return React.createElement("button", tmp, React.createElement("span", {
                      className: "leading-7 font-bold"
                    }, props.text), Belt_Option.mapWithDefault(props.labelNumber, null, (function (number) {
                        return Belt_Option.mapWithDefault(number, null, (function (number$p) {
                                      return React.createElement("div", {
                                                  className: "flex items-center"
                                                }, React.createElement("span", {
                                                      className: "inline ml-1 text-primary bg-opacity-10 bg-primary-variant px-[6px] rounded-xl text-xs text-center font-bold"
                                                    }, number$p));
                                    }));
                      })));
    });

var LeftTab1 = {
  make: make$2
};

var Tab = {
  LeftTab1: LeftTab1
};

export {
  Normal ,
  Chip ,
  Tab ,
}
/* make Not a pure module */
