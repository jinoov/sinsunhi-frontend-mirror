// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Curry from "rescript/lib/es6/curry.js";
import * as React from "react";
import * as Period from "../../utils/Period.mjs";
import * as Js_dict from "rescript/lib/es6/js_dict.js";
import * as IconInfo from "../svgs/IconInfo.mjs";
import * as Converter from "../../utils/Converter.mjs";
import * as Belt_Array from "rescript/lib/es6/belt_Array.js";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as CustomHooks from "../../utils/CustomHooks.mjs";
import * as ReactEvents from "../../utils/ReactEvents.mjs";
import * as Router from "next/router";
import * as Garter_Array from "@greenlabs/garter/src/Garter_Array.mjs";
import * as ReactTooltip from "@radix-ui/react-tooltip";

function clearQueries(q) {
  return Js_dict.fromArray(Garter_Array.keep(Js_dict.entries(q), (function (param) {
                    var k = param[0];
                    if (k === "limit" || k === "from") {
                      return true;
                    } else {
                      return k === "to";
                    }
                  })));
}

function isSeller(r) {
  var firstPathname = Belt_Array.getBy(r.pathname.split("/"), (function (x) {
          return x !== "";
        }));
  return firstPathname === "seller";
}

function handleOnClickStatus(router, status, param) {
  return function (param) {
    return ReactEvents.interceptingHandler((function (param) {
                  var newQueries = clearQueries(router.query);
                  if (status !== undefined) {
                    newQueries["status"] = Converter.getStringFromJsonWithDefault(CustomHooks.OrdersSummary.status_encode(status), "");
                    var match = isSeller(router);
                    if (status !== 0 || !match) {
                      
                    } else {
                      newQueries["sort"] = "created";
                    }
                  } else {
                    Js_dict.unsafeDeleteKey(newQueries, "status");
                  }
                  var newQueryString = new URLSearchParams(newQueries).toString();
                  router.push(router.pathname + "?" + newQueryString);
                  
                }), param);
  };
}

function queriedStyle(router, status, param) {
  var queried = Belt_Option.flatMap(Js_dict.get(router.query, "status"), (function (status$p) {
          var status$p$p = CustomHooks.OrdersSummary.status_decode(status$p);
          if (status$p$p.TAG === /* Ok */0) {
            return status$p$p._0;
          }
          
        }));
  var match = status === queried;
  if (match) {
    return "py-1 px-2 flex justify-between border border-green-gl text-green-gl sm:border-0 sm:flex-1 sm:flex-col sm:p-4 bg-green-gl-light sm:rounded-lg";
  }
  if (status === undefined) {
    return "py-1 px-2 flex justify-between border border-gray-200 border-b-0 text-gray-700 sm:flex-1 sm:flex-col sm:border-0 sm:p-4";
  }
  switch (status) {
    case /* CREATE */0 :
        return "py-1 px-2 flex justify-between border border-gray-200 border-l-0 border-b-0 text-gray-700 sm:flex-1 sm:flex-col sm:border-0 sm:p-4";
    case /* PACKING */1 :
        return "py-1 px-2 flex justify-between border border-gray-200 text-gray-700 sm:flex-1 sm:flex-col sm:border-0 sm:p-4";
    case /* DEPARTURE */2 :
        return "py-1 px-2 flex justify-between border border-gray-200 border-l-0 text-gray-700 sm:flex-1 sm:flex-col sm:border-0 sm:p-4";
    case /* COMPLETE */4 :
    case /* REFUND */7 :
        return "py-1 px-2 flex justify-between border border-gray-200 border-t-0 border-l-0 text-gray-700 sm:flex-1 sm:flex-col sm:border-0 sm:p-4";
    case /* DELIVERING */3 :
    case /* CANCEL */5 :
    case /* ERROR */6 :
    case /* NEGOTIATING */8 :
        return "py-1 px-2 flex justify-between border border-gray-200 border-t-0 text-gray-700 sm:flex-1 sm:flex-col sm:border-0 sm:p-4";
    
  }
}

function queriedFill(router, status, param) {
  var queried = Belt_Option.flatMap(Js_dict.get(router.query, "status"), (function (status$p) {
          var status$p$p = CustomHooks.OrdersSummary.status_decode(status$p);
          if (status$p$p.TAG === /* Ok */0) {
            return status$p$p._0;
          }
          
        }));
  if (status === queried) {
    return "#12b564";
  } else {
    return "#262626";
  }
}

function displayCount(status, s) {
  if (typeof status === "number") {
    return "-";
  }
  if (status.TAG !== /* Loaded */0) {
    return "-";
  }
  var orders$p = CustomHooks.OrdersSummary.orders_decode(status._0);
  if (orders$p.TAG === /* Ok */0) {
    return String(Belt_Option.mapWithDefault(Garter_Array.getBy(orders$p._0.data, (function (d) {
                          return d.status === s;
                        })), 0, (function (d) {
                      return d.count;
                    }))) + "건";
  } else {
    return "에러";
  }
}

function Status$Tooltip(Props) {
  var text = Props.text;
  var fill = Props.fill;
  return React.createElement(ReactTooltip.Root, {
              children: null,
              delayDuration: 300
            }, React.createElement(ReactTooltip.Trigger, {
                  children: React.createElement(IconInfo.make, {
                        height: "16",
                        width: "16",
                        fill: fill
                      })
                }), React.createElement(ReactTooltip.Content, {
                  children: React.createElement("div", {
                        className: "block w-32 bg-red-400 relative"
                      }, React.createElement("div", {
                            className: "absolute w-full -top-6 left-1/2 transform -translate-x-1/2 flex flex-col justify-center"
                          }, React.createElement("h5", {
                                className: "absolute w-full left-1/2 transform -translate-x-1/2 bg-white border border-primary text-primary text-sm text-center py-1.5 font-bold rounded-xl shadow-tooltip"
                              }, text), React.createElement("div", {
                                className: "absolute h-3 w-3 rounded-sm top-3 bg-white border-b border-r border-primary left-1/2 transform -translate-x-1/2 rotate-45"
                              }))),
                  side: "top",
                  sideOffset: 4
                }));
}

var Tooltip = {
  make: Status$Tooltip
};

function Status$Total(Props) {
  var router = Router.useRouter();
  var status = CustomHooks.OrdersSummary.use(Period.currentPeriod(router), undefined);
  var totalCount = function (param) {
    if (typeof status === "number") {
      return "-";
    }
    if (status.TAG !== /* Loaded */0) {
      return "-";
    }
    var orders$p = CustomHooks.OrdersSummary.orders_decode(status._0);
    if (orders$p.TAG === /* Ok */0) {
      return String(Garter_Array.reduce(orders$p._0.data, 0, (function (acc, cur) {
                        return acc + cur.count | 0;
                      }))) + "건";
    } else {
      return "에러";
    }
  };
  return React.createElement("li", {
              className: queriedStyle(router, undefined, undefined),
              onClick: handleOnClickStatus(router, undefined, undefined)
            }, React.createElement("span", {
                  className: "flex justify-center items-center pb-1 text-sm"
                }, "전체"), React.createElement("span", {
                  className: "block font-bold sm:text-center"
                }, totalCount(undefined)));
}

var Total = {
  make: Status$Total
};

function Status$Item(Props) {
  var kind = Props.kind;
  var router = Router.useRouter();
  var status = CustomHooks.OrdersSummary.use(Period.currentPeriod(router), undefined);
  var Converter$1 = Converter.Status({});
  return React.createElement("li", {
              className: queriedStyle(router, kind, undefined),
              onClick: handleOnClickStatus(router, kind, undefined)
            }, React.createElement("span", {
                  className: "flex justify-center items-center pb-1 text-sm"
                }, Curry._1(Converter$1.displayStatus, kind)), React.createElement("span", {
                  className: "block font-bold sm:text-center"
                }, displayCount(status, kind)));
}

var Item = {
  make: Status$Item
};

export {
  clearQueries ,
  isSeller ,
  handleOnClickStatus ,
  queriedStyle ,
  queriedFill ,
  displayCount ,
  Tooltip ,
  Total ,
  Item ,
  
}
/* react Not a pure module */