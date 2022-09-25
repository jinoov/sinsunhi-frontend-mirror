// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Badge from "./Badge.mjs";
import * as Curry from "rescript/lib/es6/curry.js";
import * as React from "react";
import * as Dialog from "./common/Dialog.mjs";
import * as Locale from "../utils/Locale.mjs";
import * as Checkbox from "./common/Checkbox.mjs";
import * as Belt_Array from "rescript/lib/es6/belt_Array.js";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as Belt_Result from "rescript/lib/es6/belt_Result.js";
import * as CustomHooks from "../utils/CustomHooks.mjs";
import * as Tracking_Buyer from "./Tracking_Buyer.mjs";
import * as Order_Detail_Button_Buyer_Seller from "./Order_Detail_Button_Buyer_Seller.mjs";

function formatDateTime(d) {
  return Locale.DateTime.formatFromUTC(new Date(d), "yyyy/MM/dd HH:mm");
}

function formatDate(d) {
  return Locale.DateTime.formatFromUTC(new Date(d), "yyyy/MM/dd");
}

function formatTime(d) {
  return Locale.DateTime.formatFromUTC(new Date(d), "HH:mm");
}

function payTypeToText(payType) {
  if (payType) {
    return "나중결제";
  } else {
    return "신선캐시";
  }
}

function Order_Buyer$Item$Table(props) {
  var onClickCancel = props.onClickCancel;
  var order = props.order;
  var match = React.useState(function () {
        return /* Hide */1;
      });
  var setShowCancelConfirm = match[1];
  var status = CustomHooks.Courier.use(undefined);
  var courierName;
  if (typeof status === "number" || status.TAG !== /* Loaded */0) {
    courierName = "입력전";
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
              })), "입력전");
  }
  var match$1 = order.status;
  var isDisabedCheckbox = match$1 !== 0;
  var match$2 = order.status;
  var match$3 = order.deliveryType;
  var tmp;
  var exit = 0;
  if (match$3 === 0) {
    tmp = React.createElement("div", {
          className: "h-full flex flex-col px-4 py-2"
        }, React.createElement("span", {
              className: "block"
            }, "직접수령"));
  } else {
    exit = 1;
  }
  if (exit === 1) {
    tmp = React.createElement("div", {
          className: "h-full flex flex-col px-4 py-2"
        }, React.createElement("span", {
              className: "block"
            }, Belt_Option.getWithDefault(order.receiverName, "-")), React.createElement("span", {
              className: "block"
            }, Belt_Option.getWithDefault(order.receiverPhone, "-")), React.createElement("span", {
              className: "block text-gray-500"
            }, Belt_Option.getWithDefault(order.receiverAddress, "-")), React.createElement("span", {
              className: "block text-gray-500"
            }, Belt_Option.getWithDefault(order.receiverZipcode, "-")));
  }
  return React.createElement(React.Fragment, undefined, React.createElement("li", {
                  className: "hidden lg:grid lg:grid-cols-9-buyer-order text-gray-700"
                }, React.createElement("div", {
                      className: "h-full flex flex-col px-4 py-2"
                    }, React.createElement(Checkbox.make, {
                          id: "checkbox-" + order.orderProductNo + "",
                          checked: Curry._1(props.check, order.orderProductNo),
                          onChange: Curry._1(props.onCheckOrder, order.orderProductNo),
                          disabled: isDisabedCheckbox
                        })), React.createElement("div", {
                      className: "h-full flex flex-col px-4 py-2"
                    }, React.createElement(Order_Detail_Button_Buyer_Seller.make, {
                          order: order
                        }), React.createElement("span", {
                          className: "block text-gray-400 mb-1"
                        }, formatDateTime(order.orderDate)), React.createElement("span", {
                          className: "block"
                        }, React.createElement(Badge.make, {
                              status: order.status
                            }))), React.createElement("div", {
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
                    }, match$2 !== 1 ? (
                        match$2 !== 0 ? React.createElement(React.Fragment, undefined, React.createElement("span", {
                                    className: "block"
                                  }, courierName), React.createElement("span", {
                                    className: "block text-gray-500"
                                  }, Belt_Option.getWithDefault(order.invoice, "-")), React.createElement(Tracking_Buyer.make, {
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
                                  }, "주문취소"))
                      ) : "미등록"), tmp, React.createElement("div", {
                      className: "h-full flex flex-col px-4 py-2"
                    }, React.createElement("span", {
                          className: "block"
                        }, Belt_Option.getWithDefault(order.ordererName, "")), React.createElement("span", {
                          className: "block"
                        }, Belt_Option.getWithDefault(order.ordererPhone, ""))), React.createElement("div", {
                      className: "h-full flex flex-col px-4 py-2"
                    }, React.createElement("span", {
                          className: "block"
                        }, Belt_Option.getWithDefault(Belt_Option.map(order.deliveryDate, formatDateTime), "-")))), React.createElement(Dialog.make, {
                  isShow: match[0],
                  children: React.createElement("p", {
                        className: "text-black-gl text-center whitespace-pre-wrap"
                      }, "선택한 주문을 취소하시겠습니까?"),
                  onCancel: (function (param) {
                      setShowCancelConfirm(function (param) {
                            return /* Hide */1;
                          });
                    }),
                  onConfirm: (function (param) {
                      setShowCancelConfirm(function (param) {
                            return /* Hide */1;
                          });
                      Curry._1(onClickCancel, [order.orderProductNo]);
                    }),
                  textOnCancel: "취소",
                  textOnConfirm: "확인"
                }));
}

var Table = {
  make: Order_Buyer$Item$Table
};

function Order_Buyer$Item$Card(props) {
  var onClickCancel = props.onClickCancel;
  var order = props.order;
  var match = React.useState(function () {
        return /* Hide */1;
      });
  var setShowCancelConfirm = match[1];
  var status = CustomHooks.Courier.use(undefined);
  var courierName;
  if (typeof status === "number" || status.TAG !== /* Loaded */0) {
    courierName = "택배사 선택";
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
              })), "택배사 선택");
  }
  var match$1 = order.status;
  var match$2 = order.deliveryType;
  var tmp;
  var exit = 0;
  if (match$2 === 0) {
    tmp = React.createElement("span", {
          className: "block"
        }, "직접수령");
  } else {
    exit = 1;
  }
  if (exit === 1) {
    tmp = React.createElement(React.Fragment, undefined, React.createElement("span", {
              className: "block"
            }, "" + Belt_Option.getWithDefault(order.receiverName, "-") + " " + Belt_Option.getWithDefault(order.receiverPhone, "-") + ""), React.createElement("span", {
              className: "block mt-1"
            }, Belt_Option.getWithDefault(order.receiverAddress, "-")), React.createElement("span", {
              className: "block mt-1"
            }, Belt_Option.getWithDefault(order.receiverZipcode, "-")));
  }
  return React.createElement(React.Fragment, undefined, React.createElement("li", {
                  className: "py-7 px-5 lg:mb-4 lg:hidden text-black-gl"
                }, React.createElement("section", {
                      className: "flex justify-between items-start"
                    }, React.createElement("div", undefined, React.createElement("div", {
                              className: "flex"
                            }, React.createElement("span", {
                                  className: "w-20 text-gray-gl"
                                }, "주문번호"), React.createElement("span", {
                                  className: "ml-2"
                                }, React.createElement(Order_Detail_Button_Buyer_Seller.make, {
                                      order: order
                                    }))), React.createElement("div", {
                              className: "flex mt-2"
                            }, React.createElement("span", {
                                  className: "w-20 text-gray-gl"
                                }, "일자"), React.createElement("span", {
                                  className: "ml-2"
                                }, formatDateTime(order.orderDate)))), React.createElement(Badge.make, {
                          status: order.status
                        })), React.createElement("div", {
                      className: "divide-y divide-gray-100"
                    }, React.createElement("section", {
                          className: "py-3"
                        }, React.createElement("div", {
                              className: "flex"
                            }, React.createElement("span", {
                                  className: "w-20 text-gray-gl"
                                }, "주문상품"), React.createElement("div", {
                                  className: "ml-2 "
                                }, React.createElement("span", {
                                      className: "block"
                                    }, "" + String(order.productId) + " ・ " + order.productSku + ""), React.createElement("span", {
                                      className: "block mt-1"
                                    }, order.productName), React.createElement("span", {
                                      className: "block mt-1"
                                    }, Belt_Option.getWithDefault(order.productOptionName, "")))), React.createElement("div", {
                              className: "flex mt-4 "
                            }, React.createElement("span", {
                                  className: "w-20 text-gray-gl"
                                }, "상품금액"), React.createElement("span", {
                                  className: "ml-2 "
                                }, "" + Locale.Float.show(undefined, order.productPrice, 0) + "원")), React.createElement("div", {
                              className: "flex mt-4 "
                            }, React.createElement("span", {
                                  className: "w-20 text-gray-gl"
                                }, "결제수단"), React.createElement("span", {
                                  className: "ml-2 "
                                }, order.payType ? "나중결제" : "신선캐시")), React.createElement("div", {
                              className: "flex mt-4"
                            }, React.createElement("span", {
                                  className: "w-20 text-gray-gl"
                                }, "수량"), React.createElement("span", {
                                  className: "ml-2"
                                }, String(order.quantity)))), React.createElement("section", {
                          className: "py-3"
                        }, React.createElement("div", {
                              className: "flex justify-between"
                            }, match$1 !== 1 ? (
                                match$1 !== 0 ? React.createElement(React.Fragment, undefined, React.createElement("div", {
                                            className: "flex"
                                          }, React.createElement("span", {
                                                className: "w-20 text-gray-gl"
                                              }, "운송장번호"), React.createElement("div", {
                                                className: "ml-2"
                                              }, React.createElement("span", undefined, React.createElement("span", {
                                                        className: "block"
                                                      }, courierName), React.createElement("span", {
                                                        className: "block"
                                                      }, Belt_Option.getWithDefault(order.invoice, "-"))))), React.createElement(Tracking_Buyer.make, {
                                            order: order
                                          })) : React.createElement("div", {
                                        className: "flex-1 flex justify-between"
                                      }, React.createElement("span", {
                                            className: "w-20 text-gray-gl"
                                          }, "운송장번호"), React.createElement("div", {
                                            className: "flex-1"
                                          }, React.createElement("button", {
                                                className: "w-full py-3 px-3 bg-gray-gl text-gray-gl rounded-lg whitespace-nowrap text-base font-bold",
                                                type: "button",
                                                onClick: (function (param) {
                                                    setShowCancelConfirm(function (param) {
                                                          return /* Show */0;
                                                        });
                                                  })
                                              }, "주문취소")))
                              ) : "미등록"), React.createElement("div", {
                              className: "flex mt-4"
                            }, React.createElement("span", {
                                  className: "w-20 text-gray-gl"
                                }, "배송정보"), React.createElement("div", {
                                  className: "flex-1 pl-2"
                                }, tmp)), React.createElement("div", {
                              className: "flex mt-4"
                            }, React.createElement("span", {
                                  className: "w-20 text-gray-gl"
                                }, "주문자명"), React.createElement("div", {
                                  className: "ml-2 "
                                }, React.createElement("span", {
                                      className: "block"
                                    }, Belt_Option.getWithDefault(order.ordererName, "-")))), React.createElement("div", {
                              className: "flex mt-2"
                            }, React.createElement("span", {
                                  className: "w-20 text-gray-gl"
                                }, "연락처"), React.createElement("div", {
                                  className: "ml-2"
                                }, React.createElement("span", {
                                      className: "block"
                                    }, Belt_Option.getWithDefault(order.ordererPhone, "-"))))), React.createElement("section", {
                          className: "py-3"
                        }, React.createElement("div", {
                              className: "flex"
                            }, React.createElement("span", {
                                  className: "w-20 text-gray-gl"
                                }, "출고일"), React.createElement("span", {
                                  className: "ml-2"
                                }, Belt_Option.getWithDefault(Belt_Option.map(order.deliveryDate, formatDateTime), "-")))))), React.createElement(Dialog.make, {
                  isShow: match[0],
                  children: React.createElement("p", {
                        className: "text-black-gl text-center whitespace-pre-wrap"
                      }, "선택한 주문을 취소하시겠습니까?"),
                  onCancel: (function (param) {
                      setShowCancelConfirm(function (param) {
                            return /* Hide */1;
                          });
                    }),
                  onConfirm: (function (param) {
                      setShowCancelConfirm(function (param) {
                            return /* Hide */1;
                          });
                      Curry._1(onClickCancel, [order.orderProductNo]);
                    }),
                  textOnCancel: "취소",
                  textOnConfirm: "확인"
                }));
}

var Card = {
  make: Order_Buyer$Item$Card
};

var Item = {
  Table: Table,
  Card: Card
};

function Order_Buyer(props) {
  var onClickCancel = props.onClickCancel;
  var order = props.order;
  return React.createElement(React.Fragment, undefined, React.createElement(Order_Buyer$Item$Table, {
                  order: order,
                  check: props.check,
                  onCheckOrder: props.onCheckOrder,
                  onClickCancel: onClickCancel
                }), React.createElement(Order_Buyer$Item$Card, {
                  order: order,
                  onClickCancel: onClickCancel
                }));
}

var make = Order_Buyer;

export {
  formatDateTime ,
  formatDate ,
  formatTime ,
  payTypeToText ,
  Item ,
  make ,
}
/* Badge Not a pure module */
