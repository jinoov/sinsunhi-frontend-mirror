// Generated by ReScript, PLEASE EDIT WITH CARE

import * as React from "react";
import * as Constants from "../constants/Constants.mjs";
import * as Belt_Array from "rescript/lib/es6/belt_Array.js";
import * as Pagination from "./common/Pagination.mjs";
import * as CustomHooks from "../utils/CustomHooks.mjs";
import * as OfflineOrder_Admin from "./OfflineOrder_Admin.mjs";

function OfflineOrder_List_Admin$Header(Props) {
  return React.createElement("div", {
              className: "grid grid-cols-12-gl-admin-offline bg-gray-50 text-text-L2 h-12"
            }, React.createElement("div", {
                  className: "h-full px-4 flex items-center whitespace-nowrap"
                }, "수정중"), React.createElement("div", {
                  className: "h-full px-4 flex items-center whitespace-nowrap"
                }, "주문상품번호·주문번호"), React.createElement("div", {
                  className: "h-full px-4 flex items-center whitespace-nowrap"
                }, "출고예정일·출고일"), React.createElement("div", {
                  className: "h-full px-4 flex items-center whitespace-nowrap"
                }, "바이어명·코드"), React.createElement("div", {
                  className: "h-full px-4 flex items-center whitespace-nowrap"
                }, "생산자명·코드"), React.createElement("div", {
                  className: "h-full px-4 flex items-center whitespace-nowrap"
                }, "작물·품종명(코드)"), React.createElement("div", {
                  className: "h-full px-4 flex items-center whitespace-nowrap"
                }, "단품번호"), React.createElement("div", {
                  className: "h-full px-4 flex items-center whitespace-nowrap"
                }, "중량·포장규격"), React.createElement("div", {
                  className: "h-full px-4 flex items-center whitespace-nowrap"
                }, "등급"), React.createElement("div", {
                  className: "h-full px-4 flex items-center whitespace-nowrap"
                }, "주문수량·판매금액"), React.createElement("div", {
                  className: "h-full px-4 flex items-center whitespace-nowrap"
                }, "납품확정수량· 확정판매금액"), React.createElement("div", {
                  className: "h-full px-4 flex items-center whitespace-nowrap"
                }, "원가·판매가"));
}

var Header = {
  make: OfflineOrder_List_Admin$Header
};

function OfflineOrder_List_Admin(Props) {
  var status = Props.status;
  if (typeof status === "number") {
    return null;
  }
  if (status.TAG !== /* Loaded */0) {
    return null;
  }
  var orders = status._0;
  var orders$p = CustomHooks.OfflineOrders.offlineOrders_decode(orders);
  var tmp;
  if (orders$p.TAG === /* Ok */0) {
    tmp = Belt_Array.map(orders$p._0.data, (function (order) {
            return React.createElement(OfflineOrder_Admin.make, {
                        order: order,
                        key: String(order.id)
                      });
          }));
  } else {
    console.log(orders$p._0);
    tmp = null;
  }
  var orders$p$1 = CustomHooks.OfflineOrders.offlineOrders_decode(orders);
  var tmp$1;
  if (orders$p$1.TAG === /* Ok */0) {
    var orders$p$2 = orders$p$1._0;
    tmp$1 = React.createElement(Pagination.make, {
          pageDisplySize: Constants.pageDisplySize,
          itemPerPage: orders$p$2.limit,
          total: orders$p$2.count
        });
  } else {
    console.log(orders$p$1._0);
    tmp$1 = null;
  }
  return React.createElement(React.Fragment, undefined, React.createElement("div", {
                  className: "w-full overflow-x-scroll"
                }, React.createElement("div", {
                      className: "min-w-max text-sm divide-y divide-gray-100"
                    }, React.createElement(OfflineOrder_List_Admin$Header, {}), React.createElement("ol", {
                          className: "divide-y divide-gray-100 lg:list-height-admin-buyer lg:overflow-y-scroll"
                        }, tmp))), React.createElement("div", {
                  className: "flex justify-center pt-5"
                }, tmp$1));
}

var make = OfflineOrder_List_Admin;

export {
  Header ,
  make ,
  
}
/* react Not a pure module */