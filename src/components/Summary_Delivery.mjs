// Generated by ReScript, PLEASE EDIT WITH CARE

import * as React from "@rescript/react/src/React.mjs";
import * as React$1 from "react";
import * as CustomHooks from "../utils/CustomHooks.mjs";
import * as Garter_Array from "@greenlabs/garter/src/Garter_Array.mjs";

function Summary_Delivery$DeliveryCard(props) {
  var order = props.order;
  return React$1.createElement("div", {
              className: "inline-block border rounded py-4 px-5 min-w-4/5 mr-2 sm:min-w-1/2 lg:min-w-1/3 xl:min-w-1/5"
            }, React$1.createElement("div", {
                  className: "flex justify-between items-center"
                }, React$1.createElement("span", {
                      className: "text-sm"
                    }, order.productName), React$1.createElement("span", {
                      className: "text-green-gl font-bold ml-4"
                    }, "" + String(order.orderCount) + "건")), React$1.createElement("div", {
                  className: "text-sm text-gray-400"
                }, order.productOptionName));
}

var DeliveryCard = {
  make: Summary_Delivery$DeliveryCard
};

function Summary_Delivery(props) {
  var status = CustomHooks.OrdersSummaryFarmerDelivery.use(undefined);
  var match;
  if (typeof status === "number") {
    match = [
      0,
      []
    ];
  } else if (status.TAG === /* Loaded */0) {
    var orders$p = CustomHooks.OrdersSummaryFarmerDelivery.orders_decode(status._0);
    if (orders$p.TAG === /* Ok */0) {
      var orders$p$1 = orders$p._0;
      match = [
        orders$p$1.count,
        orders$p$1.data
      ];
    } else {
      match = [
        0,
        []
      ];
    }
  } else {
    match = [
      0,
      []
    ];
  }
  return React$1.createElement("div", {
              className: "px-0 lg:px-20"
            }, React$1.createElement("div", {
                  className: "px-4 py-7 mt-4 shadow-gl sm:px-7"
                }, React$1.createElement("div", {
                      className: "flex"
                    }, React$1.createElement("h3", {
                          className: "font-bold text-lg"
                        }, "출고요약"), React$1.createElement("span", {
                          className: "ml-4 text-green-gl text-sm"
                        }, "미출고", React$1.createElement("span", {
                              className: "ml-2 font-bold text-base"
                            }, String(match[0])))), React$1.createElement("div", {
                      className: "mt-3 flex overflow-x-scroll"
                    }, Garter_Array.map(match[1], (function (order) {
                            return React.createElementWithKey(Summary_Delivery$DeliveryCard, {
                                        order: order
                                      }, "" + order.productName + "-" + order.productOptionName + "");
                          })))));
}

var Admin;

var make = Summary_Delivery;

export {
  Admin ,
  DeliveryCard ,
  make ,
}
/* React Not a pure module */
