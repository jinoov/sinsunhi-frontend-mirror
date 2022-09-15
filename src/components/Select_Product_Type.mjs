// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Cx from "rescript-classnames/src/Cx.mjs";
import * as Curry from "rescript/lib/es6/curry.js";
import * as Spice from "@greenlabs/ppx-spice/src/rescript/Spice.mjs";
import * as React from "react";
import * as Js_json from "rescript/lib/es6/js_json.js";
import * as Belt_Array from "rescript/lib/es6/belt_Array.js";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as IconArrowSelect from "./svgs/IconArrowSelect.mjs";

function status_encode(v) {
  switch (v) {
    case /* NORMAL */0 :
        return "일반상품";
    case /* QUOTED */1 :
        return "견적상품";
    case /* MATCHING */2 :
        return "매칭상품";
    
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
  if ("일반상품" === str$1) {
    return {
            TAG: /* Ok */0,
            _0: /* NORMAL */0
          };
  } else if ("견적상품" === str$1) {
    return {
            TAG: /* Ok */0,
            _0: /* QUOTED */1
          };
  } else if ("매칭상품" === str$1) {
    return {
            TAG: /* Ok */0,
            _0: /* MATCHING */2
          };
  } else {
    return Spice.error(undefined, "Not matched", v);
  }
}

function toString(status) {
  return Belt_Option.getWithDefault(Js_json.decodeString(status_encode(status)), "");
}

function Select_Product_Type(Props) {
  var status = Props.status;
  var onChange = Props.onChange;
  var tmp;
  switch (status) {
    case /* NORMAL */0 :
        tmp = "left-0";
        break;
    case /* QUOTED */1 :
        tmp = "left-1/3";
        break;
    case /* MATCHING */2 :
        tmp = "left-2/3";
        break;
    
  }
  return React.createElement("div", {
              className: "bg-bg-pressed-L2 w-full p-2 rounded-xl "
            }, React.createElement("div", {
                  className: "p-1 relative flex"
                }, React.createElement("div", {
                      className: Cx.cx([
                            "absolute bg-white top-0 h-full w-1/3 rounded-lg",
                            tmp
                          ])
                    }), React.createElement("div", {
                      className: Cx.cx([
                            "text-center py-2 px-6 flex-1 z-10 cursor-pointer",
                            status !== 0 ? "text-text-L2" : "text-text-L1"
                          ]),
                      onClick: (function (param) {
                          Curry._1(onChange, /* NORMAL */0);
                        })
                    }, toString(/* NORMAL */0)), React.createElement("div", {
                      className: Cx.cx([
                            "text-center py-2 px-6 flex-1 z-10 cursor-pointer",
                            status !== 1 ? "text-text-L2" : "text-text-L1"
                          ]),
                      onClick: (function (param) {
                          Curry._1(onChange, /* QUOTED */1);
                        })
                    }, toString(/* QUOTED */1)), React.createElement("div", {
                      className: Cx.cx([
                            "text-center py-2 px-6 flex-1 z-10 cursor-pointer",
                            status >= 2 ? "text-text-L1" : "text-text-L2"
                          ]),
                      onClick: (function (param) {
                          Curry._1(onChange, /* MATCHING */2);
                        })
                    }, "매칭상품")));
}

function status_encode$1(v) {
  switch (v) {
    case /* ALL */0 :
        return "ALL";
    case /* NORMAL */1 :
        return "NORMAL";
    case /* QUOTED */2 :
        return "QUOTED";
    case /* QUOTABLE */3 :
        return "QUOTABLE";
    case /* MATCHING */4 :
        return "MATCHING";
    
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
  if ("ALL" === str$1) {
    return {
            TAG: /* Ok */0,
            _0: /* ALL */0
          };
  } else if ("NORMAL" === str$1) {
    return {
            TAG: /* Ok */0,
            _0: /* NORMAL */1
          };
  } else if ("QUOTED" === str$1) {
    return {
            TAG: /* Ok */0,
            _0: /* QUOTED */2
          };
  } else if ("QUOTABLE" === str$1) {
    return {
            TAG: /* Ok */0,
            _0: /* QUOTABLE */3
          };
  } else if ("MATCHING" === str$1) {
    return {
            TAG: /* Ok */0,
            _0: /* MATCHING */4
          };
  } else {
    return Spice.error(undefined, "Not matched", v);
  }
}

function toString$1(status) {
  return Belt_Option.getWithDefault(Js_json.decodeString(status_encode$1(status)), "ALL");
}

function toDisplayName(status) {
  switch (status) {
    case /* ALL */0 :
        return "전체";
    case /* NORMAL */1 :
        return "일반상품";
    case /* QUOTED */2 :
        return "견적상품";
    case /* QUOTABLE */3 :
        return "일반+견적상품";
    case /* MATCHING */4 :
        return "매칭상품";
    
  }
}

var defaultStyle = "flex px-3 py-2 border items-center border-border-default-L1 rounded-lg h-9 text-enabled-L1 focus:outline bg-white";

function Select_Product_Type$Search(Props) {
  var status = Props.status;
  var onChange = Props.onChange;
  var value = toString$1(status);
  var handleProductOperationStatus = function (e) {
    var status = e.target.value;
    var status$p = status_decode$1(status);
    if (status$p.TAG === /* Ok */0) {
      return Curry._1(onChange, status$p._0);
    }
    
  };
  return React.createElement("span", undefined, React.createElement("label", {
                  className: "block relative"
                }, React.createElement("span", {
                      className: defaultStyle
                    }, toDisplayName(status)), React.createElement("span", {
                      className: "absolute top-1.5 right-2"
                    }, React.createElement(IconArrowSelect.make, {
                          height: "24",
                          width: "24",
                          fill: "#121212"
                        })), React.createElement("select", {
                      className: "block w-full h-full absolute top-0 opacity-0",
                      value: value,
                      onChange: handleProductOperationStatus
                    }, React.createElement("option", {
                          hidden: value !== "",
                          disabled: true,
                          value: ""
                        }, "운영상태 선택"), Belt_Array.map([
                          /* ALL */0,
                          /* NORMAL */1,
                          /* QUOTED */2,
                          /* QUOTABLE */3,
                          /* MATCHING */4
                        ], (function (s) {
                            var value = toString$1(s);
                            return React.createElement("option", {
                                        key: value,
                                        value: value
                                      }, toDisplayName(s));
                          })))));
}

var Search = {
  status_encode: status_encode$1,
  status_decode: status_decode$1,
  toString: toString$1,
  toDisplayName: toDisplayName,
  defaultStyle: defaultStyle,
  make: Select_Product_Type$Search
};

var make = Select_Product_Type;

export {
  status_encode ,
  status_decode ,
  toString ,
  make ,
  Search ,
}
/* react Not a pure module */
