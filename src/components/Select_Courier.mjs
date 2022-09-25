// Generated by ReScript, PLEASE EDIT WITH CARE

import * as React from "react";
import * as Belt_Array from "rescript/lib/es6/belt_Array.js";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as Belt_Result from "rescript/lib/es6/belt_Result.js";
import * as CustomHooks from "../utils/CustomHooks.mjs";
import * as Garter_Array from "@greenlabs/garter/src/Garter_Array.mjs";
import * as IconArrowSelect from "./svgs/IconArrowSelect.mjs";

function Select_Courier(props) {
  var setCourier = props.setCourier;
  var courierCode = props.courierCode;
  var status = CustomHooks.Courier.use(undefined);
  var onChange = function (e) {
    var code = e.target.value;
    if (typeof status === "number") {
      return ;
    }
    if (status.TAG !== /* Loaded */0) {
      return ;
    }
    Belt_Result.map(CustomHooks.Courier.response_decode(status._0), (function (couriers$p) {
            var selected = Belt_Option.map(Belt_Array.getBy(couriers$p.data, (function (courier) {
                        return courier.code === code;
                      })), (function (courier) {
                    return courier.code;
                  }));
            return setCourier(function (param) {
                        return selected;
                      });
          }));
  };
  var courierName;
  if (typeof status === "number" || status.TAG !== /* Loaded */0) {
    courierName = "택배사 선택";
  } else {
    var couriers = status._0;
    courierName = Belt_Option.getWithDefault(Belt_Option.map(Belt_Option.flatMap(courierCode, (function (courierCode$p) {
                    return Belt_Result.getWithDefault(Belt_Result.map(CustomHooks.Courier.response_decode(couriers), (function (couriers$p) {
                                      return Belt_Array.getBy(couriers$p.data, (function (courier) {
                                                    return courier.code === courierCode$p;
                                                  }));
                                    })), undefined);
                  })), (function (courier) {
                return courier.name;
              })), "택배사 선택");
  }
  var tmp;
  tmp = typeof status === "number" ? (
      status === /* Loading */1 ? "..." : "택배사 선택"
    ) : (
      status.TAG === /* Loaded */0 ? courierName : "택배사 선택"
    );
  var tmp$1;
  if (typeof status === "number" || status.TAG !== /* Loaded */0) {
    tmp$1 = null;
  } else {
    var couriers$p = CustomHooks.Courier.response_decode(status._0);
    tmp$1 = couriers$p.TAG === /* Ok */0 ? Garter_Array.map(couriers$p._0.data, (function (courier) {
              return React.createElement("option", {
                          key: courier.code,
                          value: courier.code
                        }, courier.name);
            })) : null;
  }
  return React.createElement("label", {
              className: "block relative h-13 lg:h-8"
            }, React.createElement("span", {
                  className: "block border border-gray-gl-light rounded-xl py-3 lg:py-1 lg:rounded-md px-3 text-gray-500"
                }, tmp), React.createElement("select", {
                  className: "block w-full h-full absolute top-0 opacity-0",
                  value: Belt_Option.getWithDefault(courierCode, "-1"),
                  onChange: onChange
                }, React.createElement("option", {
                      value: "택배사 선택"
                    }, "-- 택배사 선택 --"), tmp$1), React.createElement("span", {
                  className: "absolute top-3 lg:top-0.5 right-2"
                }, React.createElement(IconArrowSelect.make, {
                      height: "24",
                      width: "24",
                      fill: "#121212"
                    })));
}

var make = Select_Courier;

export {
  make ,
}
/* react Not a pure module */
