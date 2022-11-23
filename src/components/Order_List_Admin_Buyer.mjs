// Generated by ReScript, PLEASE EDIT WITH CARE

import * as React from "react";
import * as Checkbox from "./common/Checkbox.mjs";
import * as Constants from "../constants/Constants.mjs";
import * as ErrorPanel from "./common/ErrorPanel.mjs";
import * as Pagination from "./common/Pagination.mjs";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as CustomHooks from "../utils/CustomHooks.mjs";
import * as EmptyOrders from "./common/EmptyOrders.mjs";
import * as Order_Admin from "./Order_Admin.mjs";
import * as Garter_Array from "@greenlabs/garter/src/Garter_Array.mjs";

function Order_List_Admin_Buyer$Header(Props) {
  var checked = Props.checked;
  var onChange = Props.onChange;
  var disabled = Props.disabled;
  var tmp = {
    id: "check-all"
  };
  if (checked !== undefined) {
    tmp.checked = Caml_option.valFromOption(checked);
  }
  if (onChange !== undefined) {
    tmp.onChange = Caml_option.valFromOption(onChange);
  }
  if (disabled !== undefined) {
    tmp.disabled = Caml_option.valFromOption(disabled);
  }
  return React.createElement("div", {
              className: "grid grid-cols-10-gl-admin bg-gray-100 text-gray-500 h-12"
            }, React.createElement("div", {
                  className: "h-full px-4 flex items-center whitespace-nowrap"
                }, React.createElement(Checkbox.make, tmp)), React.createElement("div", {
                  className: "h-full px-4 flex items-center whitespace-nowrap"
                }, "주문번호·일자"), React.createElement("div", {
                  className: "h-full px-4 flex items-center whitespace-nowrap"
                }, "바이어·생산자"), React.createElement("div", {
                  className: "h-full px-4 flex items-center whitespace-nowrap"
                }, "주문상품"), React.createElement("div", {
                  className: "h-full px-4 flex items-center whitespace-nowrap"
                }, "상품금액·결제수단"), React.createElement("div", {
                  className: "h-full px-4 flex items-center whitespace-nowrap"
                }, "수량"), React.createElement("div", {
                  className: "h-full px-4 flex items-center whitespace-nowrap"
                }, "운송장번호"), React.createElement("div", {
                  className: "h-full px-4 flex items-center whitespace-nowrap"
                }, "배송정보"), React.createElement("div", {
                  className: "h-full px-4 flex items-center whitespace-nowrap"
                }, "주문자명·연락처"), React.createElement("div", {
                  className: "h-full px-4 flex items-center whitespace-nowrap text-center"
                }, "출고일"));
}

var Header = {
  make: Order_List_Admin_Buyer$Header
};

function Order_List_Admin_Buyer$Loading(Props) {
  return React.createElement("div", {
              className: "w-full overflow-x-scroll"
            }, React.createElement("div", {
                  className: "min-w-max text-sm divide-y divide-gray-100"
                }, React.createElement(Order_List_Admin_Buyer$Header, {}), React.createElement("ol", {
                      className: "divide-y divide-gray-100 lg:list-height-admin-buyer lg:overflow-y-scroll"
                    }, Garter_Array.mapWithIndex(Garter_Array.make(5, 0), (function (idx, param) {
                            return React.createElement(Order_Admin.Item.Table.Loading.make, {
                                        key: "" + String(idx) + "-table-loading"
                                      });
                          })))));
}

var Loading = {
  make: Order_List_Admin_Buyer$Loading
};

function Order_List_Admin_Buyer(Props) {
  var status = Props.status;
  var check = Props.check;
  var onCheckOrder = Props.onCheckOrder;
  var onCheckAll = Props.onCheckAll;
  var countOfChecked = Props.countOfChecked;
  var onClickCancel = Props.onClickCancel;
  if (typeof status === "number") {
    return React.createElement(Order_List_Admin_Buyer$Loading, {});
  }
  if (status.TAG !== /* Loaded */0) {
    return React.createElement(ErrorPanel.make, {
                error: status._0,
                renderOnRetry: React.createElement(Order_List_Admin_Buyer$Loading, {})
              });
  }
  var orders = status._0;
  var orders$p = CustomHooks.Orders.orders_decode(orders);
  var countOfOrdersToCheck;
  countOfOrdersToCheck = orders$p.TAG === /* Ok */0 ? Garter_Array.keep(orders$p._0.data, Order_Admin.isCheckableOrder).length : 0;
  var isCheckAll = countOfOrdersToCheck !== 0 && countOfOrdersToCheck === countOfChecked;
  var isDisabledCheckAll;
  if (typeof status === "number" || status.TAG !== /* Loaded */0) {
    isDisabledCheckAll = true;
  } else {
    var orders$p$1 = CustomHooks.Orders.orders_decode(status._0);
    isDisabledCheckAll = orders$p$1.TAG === /* Ok */0 ? Garter_Array.keep(orders$p$1._0.data, Order_Admin.isCheckableOrder).length === 0 : true;
  }
  var orders$p$2 = CustomHooks.Orders.orders_decode(orders);
  var tmp;
  if (orders$p$2.TAG === /* Ok */0) {
    var orders$p$3 = orders$p$2._0;
    tmp = React.createElement("ol", {
          className: "divide-y divide-gray-100 lg:list-height-admin-buyer lg:overflow-y-scroll"
        }, orders$p$3.data.length !== 0 ? Garter_Array.map(orders$p$3.data, (function (order) {
                  return React.createElement(Order_Admin.make, {
                              order: order,
                              check: check,
                              onCheckOrder: onCheckOrder,
                              onClickCancel: onClickCancel,
                              key: order.orderProductNo
                            });
                })) : React.createElement(EmptyOrders.make, {}));
  } else {
    console.log(orders$p$2._0);
    tmp = null;
  }
  var tmp$1;
  if (typeof status === "number" || status.TAG !== /* Loaded */0) {
    tmp$1 = null;
  } else {
    var orders$p$4 = CustomHooks.Orders.orders_decode(status._0);
    if (orders$p$4.TAG === /* Ok */0) {
      var orders$p$5 = orders$p$4._0;
      tmp$1 = React.createElement("div", {
            className: "flex justify-center pt-5"
          }, null, React.createElement(Pagination.make, {
                pageDisplySize: Constants.pageDisplySize,
                itemPerPage: orders$p$5.limit,
                total: orders$p$5.count
              }));
    } else {
      tmp$1 = null;
    }
  }
  return React.createElement(React.Fragment, undefined, React.createElement("div", {
                  className: "w-full overflow-x-scroll"
                }, React.createElement("div", {
                      className: "min-w-max text-sm divide-y divide-gray-100"
                    }, React.createElement(Order_List_Admin_Buyer$Header, {
                          checked: isCheckAll,
                          onChange: onCheckAll,
                          disabled: isDisabledCheckAll
                        }), tmp)), tmp$1);
}

var make = Order_List_Admin_Buyer;

export {
  Header ,
  Loading ,
  make ,
}
/* react Not a pure module */
