// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Cx from "rescript-classnames/src/Cx.mjs";
import * as Curry from "rescript/lib/es6/curry.js";
import * as Spice from "@greenlabs/ppx-spice/src/rescript/Spice.mjs";
import * as React from "react";
import * as Js_json from "rescript/lib/es6/js_json.js";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as Garter_Array from "@greenlabs/garter/src/Garter_Array.mjs";
import * as IconArrowSelect from "./svgs/IconArrowSelect.mjs";

function Select(Status) {
  var status_encode = Status.status_encode;
  var status_decode = Status.status_decode;
  var toString = function (status) {
    return Belt_Option.getWithDefault(Js_json.decodeString(Curry._1(status_encode, status)), "");
  };
  var fromString = Curry.__1(status_decode);
  var defaultStyle = "md:w-20 flex items-center border border-border-default-L1 rounded-md px-3 text-enabled-L1 h-9";
  var Select_Product_Option_Unit$Select = function (Props) {
    var status = Props.status;
    var onChange = Props.onChange;
    var forwardRef = Props.forwardRef;
    var disabledOpt = Props.disabled;
    var disabled = disabledOpt !== undefined ? disabledOpt : false;
    var displayStatus = toString(status);
    var handleProductOptionUnit = function (e) {
      var value = e.target.value;
      var status$p = Curry._1(status_decode, value);
      if (status$p.TAG === /* Ok */0) {
        return Curry._1(onChange, status$p._0);
      }
      
    };
    var tmp = {
      className: "block w-full h-full absolute top-0 opacity-0",
      disabled: disabled,
      value: toString(status),
      onChange: handleProductOptionUnit
    };
    if (forwardRef !== undefined) {
      tmp.ref = Caml_option.valFromOption(forwardRef);
    }
    return React.createElement("span", undefined, React.createElement("label", {
                    className: "block relative"
                  }, React.createElement("span", {
                        className: disabled ? Cx.cx([
                                defaultStyle,
                                "bg-disabled-L3"
                              ]) : Cx.cx([
                                defaultStyle,
                                "bg-white"
                              ])
                      }, displayStatus), React.createElement("span", {
                        className: "absolute top-1.5 right-2"
                      }, React.createElement(IconArrowSelect.make, {
                            height: "24",
                            width: "24",
                            fill: "#121212"
                          })), React.createElement("select", tmp, Garter_Array.map(Status.options, (function (s) {
                              return React.createElement("option", {
                                          key: toString(s),
                                          value: toString(s)
                                        }, toString(s));
                            })))));
  };
  return {
          options: Status.options,
          status_encode: status_encode,
          status_decode: status_decode,
          toString: toString,
          fromString: fromString,
          defaultStyle: defaultStyle,
          make: Select_Product_Option_Unit$Select
        };
}

function status_encode(v) {
  switch (v) {
    case /* G */0 :
        return "g";
    case /* KG */1 :
        return "kg";
    case /* T */2 :
        return "t";
    
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
  if ("g" === str$1) {
    return {
            TAG: /* Ok */0,
            _0: /* G */0
          };
  } else if ("kg" === str$1) {
    return {
            TAG: /* Ok */0,
            _0: /* KG */1
          };
  } else if ("t" === str$1) {
    return {
            TAG: /* Ok */0,
            _0: /* T */2
          };
  } else {
    return Spice.error(undefined, "Not matched", v);
  }
}

var options = [
  /* G */0,
  /* KG */1,
  /* T */2
];

var WeightStatus = {
  status_encode: status_encode,
  status_decode: status_decode,
  options: options
};

function status_encode$1(v) {
  switch (v) {
    case /* MM */0 :
        return "mm";
    case /* CM */1 :
        return "cm";
    case /* M */2 :
        return "m";
    
  }
}

function status_decode$1(v) {
  var str = Js_json.classify(v);
  if (typeof str === "number") {
    return Spice.error(undefined, "Not a JSONString", v);
  }
  if (str.TAG !== /* JSONString */0) {
    return Spice.error(undefined, "Not a JSONString", v);
  }
  var str$1 = str._0;
  if ("mm" === str$1) {
    return {
            TAG: /* Ok */0,
            _0: /* MM */0
          };
  } else if ("cm" === str$1) {
    return {
            TAG: /* Ok */0,
            _0: /* CM */1
          };
  } else if ("m" === str$1) {
    return {
            TAG: /* Ok */0,
            _0: /* M */2
          };
  } else {
    return Spice.error(undefined, "Not matched", v);
  }
}

var options$1 = [
  /* MM */0,
  /* CM */1,
  /* M */2
];

var SizeStatus = {
  status_encode: status_encode$1,
  status_decode: status_decode$1,
  options: options$1
};

function toString(status) {
  return Belt_Option.getWithDefault(Js_json.decodeString(status_encode(status)), "");
}

var fromString = status_decode;

var defaultStyle = "md:w-20 flex items-center border border-border-default-L1 rounded-md px-3 text-enabled-L1 h-9";

function Select_Product_Option_Unit$Select(Props) {
  var status = Props.status;
  var onChange = Props.onChange;
  var forwardRef = Props.forwardRef;
  var disabledOpt = Props.disabled;
  var disabled = disabledOpt !== undefined ? disabledOpt : false;
  var displayStatus = toString(status);
  var handleProductOptionUnit = function (e) {
    var value = e.target.value;
    var status$p = status_decode(value);
    if (status$p.TAG === /* Ok */0) {
      return Curry._1(onChange, status$p._0);
    }
    
  };
  var tmp = {
    className: "block w-full h-full absolute top-0 opacity-0",
    disabled: disabled,
    value: toString(status),
    onChange: handleProductOptionUnit
  };
  if (forwardRef !== undefined) {
    tmp.ref = Caml_option.valFromOption(forwardRef);
  }
  return React.createElement("span", undefined, React.createElement("label", {
                  className: "block relative"
                }, React.createElement("span", {
                      className: disabled ? Cx.cx([
                              defaultStyle,
                              "bg-disabled-L3"
                            ]) : Cx.cx([
                              defaultStyle,
                              "bg-white"
                            ])
                    }, displayStatus), React.createElement("span", {
                      className: "absolute top-1.5 right-2"
                    }, React.createElement(IconArrowSelect.make, {
                          height: "24",
                          width: "24",
                          fill: "#121212"
                        })), React.createElement("select", tmp, Garter_Array.map(options, (function (s) {
                            return React.createElement("option", {
                                        key: toString(s),
                                        value: toString(s)
                                      }, toString(s));
                          })))));
}

var Weight = {
  options: options,
  status_encode: status_encode,
  status_decode: status_decode,
  toString: toString,
  fromString: fromString,
  defaultStyle: defaultStyle,
  make: Select_Product_Option_Unit$Select
};

function toString$1(status) {
  return Belt_Option.getWithDefault(Js_json.decodeString(status_encode$1(status)), "");
}

var fromString$1 = status_decode$1;

var defaultStyle$1 = "md:w-20 flex items-center border border-border-default-L1 rounded-md px-3 text-enabled-L1 h-9";

function Select_Product_Option_Unit$Select$1(Props) {
  var status = Props.status;
  var onChange = Props.onChange;
  var forwardRef = Props.forwardRef;
  var disabledOpt = Props.disabled;
  var disabled = disabledOpt !== undefined ? disabledOpt : false;
  var displayStatus = toString$1(status);
  var handleProductOptionUnit = function (e) {
    var value = e.target.value;
    var status$p = status_decode$1(value);
    if (status$p.TAG === /* Ok */0) {
      return Curry._1(onChange, status$p._0);
    }
    
  };
  var tmp = {
    className: "block w-full h-full absolute top-0 opacity-0",
    disabled: disabled,
    value: toString$1(status),
    onChange: handleProductOptionUnit
  };
  if (forwardRef !== undefined) {
    tmp.ref = Caml_option.valFromOption(forwardRef);
  }
  return React.createElement("span", undefined, React.createElement("label", {
                  className: "block relative"
                }, React.createElement("span", {
                      className: disabled ? Cx.cx([
                              defaultStyle$1,
                              "bg-disabled-L3"
                            ]) : Cx.cx([
                              defaultStyle$1,
                              "bg-white"
                            ])
                    }, displayStatus), React.createElement("span", {
                      className: "absolute top-1.5 right-2"
                    }, React.createElement(IconArrowSelect.make, {
                          height: "24",
                          width: "24",
                          fill: "#121212"
                        })), React.createElement("select", tmp, Garter_Array.map(options$1, (function (s) {
                            return React.createElement("option", {
                                        key: toString$1(s),
                                        value: toString$1(s)
                                      }, toString$1(s));
                          })))));
}

var Size = {
  options: options$1,
  status_encode: status_encode$1,
  status_decode: status_decode$1,
  toString: toString$1,
  fromString: fromString$1,
  defaultStyle: defaultStyle$1,
  make: Select_Product_Option_Unit$Select$1
};

export {
  Select ,
  WeightStatus ,
  SizeStatus ,
  Weight ,
  Size ,
  
}
/* react Not a pure module */
