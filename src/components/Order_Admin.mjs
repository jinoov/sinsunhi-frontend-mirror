// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Curry from "rescript/lib/es6/curry.js";
import * as React from "react";
import * as Locale from "../utils/Locale.mjs";
import * as Checkbox from "./common/Checkbox.mjs";
import * as Skeleton from "./Skeleton.mjs";
import * as Belt_Array from "rescript/lib/es6/belt_Array.js";
import * as Badge_Admin from "./Badge_Admin.mjs";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as Belt_Result from "rescript/lib/es6/belt_Result.js";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as CustomHooks from "../utils/CustomHooks.mjs";
import * as Tracking_Admin from "./Tracking_Admin.mjs";
import * as Order_Detail_Button_Admin from "./Order_Detail_Button_Admin.mjs";
import * as Orders_Cancel_Dialog_Admin from "./Orders_Cancel_Dialog_Admin.mjs";

function formatDate(d) {
  return Locale.DateTime.formatFromUTC(new Date(d), "yyyy/MM/dd HH:mm");
}

function isCheckableOrder(order) {
  var match = order.status;
  switch (match) {
    case /* CREATE */0 :
    case /* PACKING */1 :
    case /* DEPARTURE */2 :
    case /* COMPLETE */4 :
    case /* ERROR */6 :
    case /* NEGOTIATING */8 :
        return true;
    case /* DELIVERING */3 :
    case /* CANCEL */5 :
    case /* REFUND */7 :
    case /* DEPOSIT_PENDING */9 :
        return false;
    
  }
}

function payTypeToText(payType) {
  if (payType) {
    return "나중결제";
  } else {
    return "신선캐시";
  }
}

function Order_Admin$Item$Table(Props) {
  var order = Props.order;
  var check = Props.check;
  var onCheckOrder = Props.onCheckOrder;
  var onClickCancel = Props.onClickCancel;
  var match = React.useState(function () {
        return /* Hide */1;
      });
  var setShowCancelConfirm = match[1];
  var status = CustomHooks.Courier.use(undefined);
  var courierName;
  if (typeof status === "number" || status.TAG !== /* Loaded */0) {
    courierName = "-";
  } else {
    var couriers = status._0;
    courierName = Belt_Option.getWithDefault(Belt_Option.map(Belt_Option.flatMap(order.courierCode, (function (courierCode$p) {
                    return Belt_Result.getWithDefault(Belt_Result.map(CustomHooks.Courier.response_decode(couriers), (function (couriers$p) {
                                      return Belt_Array.getBy(couriers$p.data, (function (courier) {
                                                    return courier.code === courierCode$p;
                                                  }));
                                    })), undefined);
                  })), (function (courier) {
                return courier.name;
              })), "-");
  }
  var isDisabedCheckbox = !isCheckableOrder(order);
  var refundReason = order.refundReason;
  var tmp = {
    status: order.status
  };
  if (refundReason !== undefined) {
    tmp.refundReason = Caml_option.valFromOption(refundReason);
  }
  var match$1 = order.status;
  var match$2 = order.deliveryType;
  var tmp$1;
  var exit = 0;
  if (match$2 === 0) {
    tmp$1 = React.createElement("div", {
          className: "h-full flex flex-col px-4 py-2"
        }, React.createElement("span", {
              className: "block"
            }, "직접수령"));
  } else {
    exit = 1;
  }
  if (exit === 1) {
    tmp$1 = React.createElement("div", {
          className: "h-full flex flex-col px-4 py-2"
        }, React.createElement("span", {
              className: "block"
            }, Belt_Option.getWithDefault(order.receiverName, "-")), React.createElement("span", {
              className: "block"
            }, Belt_Option.getWithDefault(order.receiverPhone, "-")), React.createElement("span", {
              className: "block text-gray-500"
            }, Belt_Option.getWithDefault(order.receiverAddress, "-")), React.createElement("span", {
              className: "block text-gray-500 whitespace-nowrap"
            }, Belt_Option.getWithDefault(order.receiverZipcode, "-")));
  }
  return React.createElement(React.Fragment, undefined, React.createElement("li", {
                  className: "grid grid-cols-10-gl-admin text-gray-700"
                }, React.createElement("div", {
                      className: "h-full flex flex-col px-4 py-2"
                    }, React.createElement(Checkbox.make, {
                          id: "checkbox-" + order.orderProductNo + "",
                          checked: Curry._1(check, order.orderProductNo),
                          onChange: Curry._1(onCheckOrder, order.orderProductNo),
                          disabled: isDisabedCheckbox
                        })), React.createElement("div", {
                      className: "h-full flex flex-col px-4 py-2"
                    }, React.createElement(Order_Detail_Button_Admin.make, {
                          order: order
                        }), React.createElement("span", {
                          className: "block text-gray-400 mb-1"
                        }, formatDate(order.orderDate)), Belt_Option.mapWithDefault(order.refundRequestorName, null, (function (v) {
                            return React.createElement("span", {
                                        className: "block mb-1"
                                      }, "(담당: " + v + ")");
                          })), React.createElement(Badge_Admin.make, tmp)), React.createElement("div", {
                      className: "h-full flex flex-col px-4 py-2"
                    }, React.createElement("span", {
                          className: "block mb-1"
                        }, Belt_Option.getWithDefault(order.buyerName, "-")), React.createElement("span", {
                          className: "block mb-1"
                        }, Belt_Option.getWithDefault(order.farmerName, "-"))), React.createElement("div", {
                      className: "h-full flex flex-col px-4 py-2"
                    }, React.createElement("span", {
                          className: "block text-gray-400"
                        }, "" + String(order.productId) + " ・ " + order.productSku + ""), React.createElement("span", {
                          className: "block truncate"
                        }, order.productName), React.createElement("span", {
                          className: "block"
                        }, Belt_Option.getWithDefault(order.productOptionName, ""))), React.createElement("div", {
                      className: "h-full flex flex-col px-4 py-2"
                    }, React.createElement("span", {
                          className: "whitespace-nowrap text-right"
                        }, "" + Locale.Float.show(undefined, order.productPrice, 0) + "원", React.createElement("br", undefined), order.payType ? "나중결제" : "신선캐시")), React.createElement("div", {
                      className: "h-full flex flex-col px-4 py-2"
                    }, React.createElement("span", {
                          className: "block"
                        }, String(order.quantity))), React.createElement("div", {
                      className: "h-full flex flex-col px-4 py-2"
                    }, match$1 >= 2 ? React.createElement(React.Fragment, undefined, React.createElement("span", {
                                className: "block"
                              }, courierName), React.createElement("span", {
                                className: "block text-gray-500"
                              }, Belt_Option.getWithDefault(order.invoice, "-")), React.createElement(Tracking_Admin.make, {
                                order: order
                              })) : React.createElement("div", {
                            className: "flex flex-col"
                          }, React.createElement("span", undefined, "미등록"), React.createElement("button", {
                                className: "px-3 max-h-10 bg-gray-gl text-gray-gl rounded-lg whitespace-nowrap py-1 mt-2 max-w-min",
                                type: "button",
                                onClick: (function (param) {
                                    setShowCancelConfirm(function (param) {
                                          return /* Show */0;
                                        });
                                  })
                              }, "주문취소"))), tmp$1, React.createElement("div", {
                      className: "p-2 pr-4 align-top"
                    }, React.createElement("span", {
                          className: "block"
                        }, Belt_Option.getWithDefault(order.ordererName, "")), React.createElement("span", {
                          className: "block"
                        }, Belt_Option.getWithDefault(order.ordererPhone, ""))), React.createElement("div", {
                      className: "h-full flex flex-col px-4 py-2 whitespace-nowrap"
                    }, React.createElement("span", {
                          className: "block"
                        }, Belt_Option.getWithDefault(Belt_Option.map(order.deliveryDate, formatDate), "-")))), React.createElement(Orders_Cancel_Dialog_Admin.make, {
                  isShowCancelConfirm: match[0],
                  setShowCancelConfirm: setShowCancelConfirm,
                  selectedOrders: [order.orderProductNo],
                  confirmFn: onClickCancel
                }));
}

function Order_Admin$Item$Table$Loading(Props) {
  return React.createElement("li", {
              className: "grid grid-cols-10-gl-admin"
            }, React.createElement("div", {
                  className: "h-full flex flex-col px-4 py-2"
                }, React.createElement(Checkbox.make, {})), React.createElement("div", {
                  className: "h-full flex flex-col px-4 py-2"
                }, React.createElement(Skeleton.Box.make, {
                      className: "w-20"
                    }), React.createElement(Skeleton.Box.make, {}), React.createElement(Skeleton.Box.make, {
                      className: "w-12"
                    })), React.createElement("div", {
                  className: "h-full flex flex-col px-4 py-2"
                }, React.createElement(Skeleton.Box.make, {}), React.createElement(Skeleton.Box.make, {})), React.createElement("div", {
                  className: "h-full flex flex-col px-4 py-2"
                }, React.createElement(Skeleton.Box.make, {}), React.createElement(Skeleton.Box.make, {
                      className: "w-2/3"
                    }), React.createElement(Skeleton.Box.make, {
                      className: "w-8"
                    })), React.createElement("div", {
                  className: "h-full flex flex-col px-4 py-2"
                }, React.createElement(Skeleton.Box.make, {})), React.createElement("div", {
                  className: "h-full flex flex-col px-4 py-2"
                }, React.createElement(Skeleton.Box.make, {})), React.createElement("div", {
                  className: "h-full flex flex-col px-4 py-2"
                }, React.createElement(Skeleton.Box.make, {}), React.createElement(Skeleton.Box.make, {})), React.createElement("div", {
                  className: "h-full flex flex-col px-4 py-2"
                }, React.createElement(Skeleton.Box.make, {}), React.createElement(Skeleton.Box.make, {
                      className: "w-2/3"
                    }), React.createElement(Skeleton.Box.make, {
                      className: "w-1/3"
                    })), React.createElement("div", {
                  className: "p-2 pr-4 align-top"
                }, React.createElement(Skeleton.Box.make, {
                      className: "w-1/2"
                    }), React.createElement(Skeleton.Box.make, {})), React.createElement("div", {
                  className: "h-full flex flex-col px-4 py-2"
                }, React.createElement(Skeleton.Box.make, {})));
}

var Loading = {
  make: Order_Admin$Item$Table$Loading
};

var Table = {
  make: Order_Admin$Item$Table,
  Loading: Loading
};

var Item = {
  Table: Table
};

function Order_Admin(Props) {
  var order = Props.order;
  var check = Props.check;
  var onCheckOrder = Props.onCheckOrder;
  var onClickCancel = Props.onClickCancel;
  return React.createElement(Order_Admin$Item$Table, {
              order: order,
              check: check,
              onCheckOrder: onCheckOrder,
              onClickCancel: onClickCancel
            });
}

var make = Order_Admin;

export {
  formatDate ,
  isCheckableOrder ,
  payTypeToText ,
  Item ,
  make ,
}
/* react Not a pure module */
