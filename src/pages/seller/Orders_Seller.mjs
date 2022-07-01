// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Env from "../../constants/Env.mjs";
import * as Swr from "swr";
import * as Spice from "@greenlabs/ppx-spice/src/rescript/Spice.mjs";
import * as React from "react";
import * as Dialog from "../../components/common/Dialog.mjs";
import * as Period from "../../utils/Period.mjs";
import * as Js_dict from "rescript/lib/es6/js_dict.js";
import * as Js_json from "rescript/lib/es6/js_json.js";
import * as Checkbox from "../../components/common/Checkbox.mjs";
import * as Constants from "../../constants/Constants.mjs";
import * as ErrorPanel from "../../components/common/ErrorPanel.mjs";
import * as Pagination from "../../components/common/Pagination.mjs";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as CustomHooks from "../../utils/CustomHooks.mjs";
import * as EmptyOrders from "../../components/common/EmptyOrders.mjs";
import * as FetchHelper from "../../utils/FetchHelper.mjs";
import * as Router from "next/router";
import * as Garter_Array from "@greenlabs/garter/src/Garter_Array.mjs";
import * as Order_Seller from "../../components/Order_Seller.mjs";
import * as Authorization from "../../utils/Authorization.mjs";
import * as Select_Sorted from "../../components/Select_Sorted.mjs";
import * as Belt_SetString from "rescript/lib/es6/belt_SetString.js";
import * as Select_CountPerPage from "../../components/Select_CountPerPage.mjs";
import * as Summary_Order_Seller from "../../components/Summary_Order_Seller.mjs";
import * as Excel_Download_Request_Button from "../../components/Excel_Download_Request_Button.mjs";

function Orders_Seller$Notice(Props) {
  return React.createElement("div", {
              className: "mt-5 bg-div-shape-L2 rounded-lg"
            }, React.createElement("div", {
                  className: "p-7"
                }, React.createElement("div", {
                      className: "relative"
                    }, "사전 품질관리를 통해 바이어와 소비자들의 신뢰도를 높이고 이를 통해 생산자분들께서 더 많은 매출을 올리실 수 있게끔", React.createElement("br", undefined), "온라인 QC - PASS 제도가 다음과 같이 시행될 예정임을 안내드립니다.", React.createElement("span", {
                          className: "absolute bottom-0 right-0 underline text-text-L1"
                        }, React.createElement("a", {
                              href: "https://greenlabs.notion.site/QC-PASS-a76474ecbdf545929b0b887de8d00801",
                              target: "_blank"
                            }, "자세히보기")))));
}

var Notice = {
  make: Orders_Seller$Notice
};

function Orders_Seller$List(Props) {
  var status = Props.status;
  var check = Props.check;
  var onCheckOrder = Props.onCheckOrder;
  var countOfChecked = Props.countOfChecked;
  var onCheckAll = Props.onCheckAll;
  var onClickPacking = Props.onClickPacking;
  if (typeof status === "number") {
    return React.createElement("div", undefined, "로딩 중..");
  }
  if (status.TAG !== /* Loaded */0) {
    return React.createElement(ErrorPanel.make, {
                error: status._0
              });
  }
  var orders = status._0;
  var orders$p = CustomHooks.Orders.orders_decode(orders);
  var countOfOrdersToCheck;
  countOfOrdersToCheck = orders$p.TAG === /* Ok */0 ? Garter_Array.keep(orders$p._0.data, (function (order) {
            return order.status === /* CREATE */0;
          })).length : 0;
  var isCheckAll = countOfOrdersToCheck !== 0 && countOfOrdersToCheck === countOfChecked;
  var isDisabledCheckAll;
  if (typeof status === "number" || status.TAG !== /* Loaded */0) {
    isDisabledCheckAll = true;
  } else {
    var orders$p$1 = CustomHooks.Orders.orders_decode(status._0);
    isDisabledCheckAll = orders$p$1.TAG === /* Ok */0 ? Garter_Array.keep(orders$p$1._0.data, (function (order) {
              return order.status === /* CREATE */0;
            })).length === 0 : true;
  }
  var orders$p$2 = CustomHooks.Orders.orders_decode(orders);
  var tmp;
  if (orders$p$2.TAG === /* Ok */0) {
    var orders$p$3 = orders$p$2._0;
    tmp = React.createElement("ol", {
          className: "divide-y divide-gray-300 lg:divide-gray-100 lg:list-height-seller lg:overflow-y-scroll"
        }, orders$p$3.data.length !== 0 ? Garter_Array.map(orders$p$3.data, (function (order) {
                  return React.createElement(Order_Seller.make, {
                              order: order,
                              check: check,
                              onCheckOrder: onCheckOrder,
                              onClickPacking: onClickPacking,
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
            className: "flex justify-center py-5"
          }, React.createElement(Pagination.make, {
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
                      className: "text-sm lg:min-w-max"
                    }, React.createElement("div", {
                          className: "hidden lg:grid lg:grid-cols-11-gl-seller bg-gray-100 text-gray-500 h-12"
                        }, React.createElement("div", {
                              className: "h-full px-4 flex items-center whitespace-nowrap"
                            }, React.createElement(Checkbox.make, {
                                  id: "check-all",
                                  checked: isCheckAll,
                                  onChange: onCheckAll,
                                  disabled: isDisabledCheckAll
                                })), React.createElement("div", {
                              className: "h-full px-4 flex items-center whitespace-nowrap"
                            }, "요청일"), React.createElement("div", {
                              className: "h-full px-4 flex items-center whitespace-nowrap"
                            }, "상품번호·옵션번호"), React.createElement("div", {
                              className: "h-full px-4 flex items-center whitespace-nowrap"
                            }, "주문번호"), React.createElement("div", {
                              className: "h-full px-4 flex items-center whitespace-nowrap"
                            }, "택배사명·송장번호"), React.createElement("div", {
                              className: "h-full px-4 flex items-center whitespace-nowrap"
                            }, "상품명·옵션·수량"), React.createElement("div", {
                              className: "h-full px-4 flex items-center whitespace-nowrap"
                            }, "수취인·연락처"), React.createElement("div", {
                              className: "h-full px-4 flex items-center whitespace-nowrap"
                            }, "가격정보"), React.createElement("div", {
                              className: "h-full px-4 flex items-center whitespace-nowrap"
                            }, "주소·우편번호"), React.createElement("div", {
                              className: "h-full px-4 flex items-center whitespace-nowrap"
                            }, "주문자명·연락처"), React.createElement("div", {
                              className: "h-full px-4 flex items-center whitespace-nowrap"
                            }, "배송메세지")), tmp)), tmp$1);
}

var List = {
  make: Orders_Seller$List
};

function data_encode(v) {
  return Js_dict.fromArray([
              [
                "total-count",
                Spice.intToJson(v.totalCount)
              ],
              [
                "update-count",
                Spice.intToJson(v.updateCount)
              ]
            ]);
}

function data_decode(v) {
  var dict = Js_json.classify(v);
  if (typeof dict === "number") {
    return Spice.error(undefined, "Not an object", v);
  }
  if (dict.TAG !== /* JSONObject */2) {
    return Spice.error(undefined, "Not an object", v);
  }
  var dict$1 = dict._0;
  var totalCount = Spice.intFromJson(Belt_Option.getWithDefault(Js_dict.get(dict$1, "total-count"), null));
  if (totalCount.TAG === /* Ok */0) {
    var updateCount = Spice.intFromJson(Belt_Option.getWithDefault(Js_dict.get(dict$1, "update-count"), null));
    if (updateCount.TAG === /* Ok */0) {
      return {
              TAG: /* Ok */0,
              _0: {
                totalCount: totalCount._0,
                updateCount: updateCount._0
              }
            };
    }
    var e = updateCount._0;
    return {
            TAG: /* Error */1,
            _0: {
              path: ".update-count" + e.path,
              message: e.message,
              value: e.value
            }
          };
  }
  var e$1 = totalCount._0;
  return {
          TAG: /* Error */1,
          _0: {
            path: ".total-count" + e$1.path,
            message: e$1.message,
            value: e$1.value
          }
        };
}

function response_encode(v) {
  return Js_dict.fromArray([
              [
                "data",
                data_encode(v.data)
              ],
              [
                "message",
                Spice.stringToJson(v.message)
              ]
            ]);
}

function response_decode(v) {
  var dict = Js_json.classify(v);
  if (typeof dict === "number") {
    return Spice.error(undefined, "Not an object", v);
  }
  if (dict.TAG !== /* JSONObject */2) {
    return Spice.error(undefined, "Not an object", v);
  }
  var dict$1 = dict._0;
  var data = data_decode(Belt_Option.getWithDefault(Js_dict.get(dict$1, "data"), null));
  if (data.TAG === /* Ok */0) {
    var message = Spice.stringFromJson(Belt_Option.getWithDefault(Js_dict.get(dict$1, "message"), null));
    if (message.TAG === /* Ok */0) {
      return {
              TAG: /* Ok */0,
              _0: {
                data: data._0,
                message: message._0
              }
            };
    }
    var e = message._0;
    return {
            TAG: /* Error */1,
            _0: {
              path: ".message" + e.path,
              message: e.message,
              value: e.value
            }
          };
  }
  var e$1 = data._0;
  return {
          TAG: /* Error */1,
          _0: {
            path: ".data" + e$1.path,
            message: e$1.message,
            value: e$1.value
          }
        };
}

function Orders_Seller$Orders(Props) {
  var router = Router.useRouter();
  var match = Swr.useSWRConfig();
  var mutate = match.mutate;
  var status = CustomHooks.Orders.use(new URLSearchParams(router.query).toString());
  var match$1 = React.useState(function () {
        
      });
  var setOrdersToPacking = match$1[1];
  var ordersToPacking = match$1[0];
  var match$2 = React.useState(function () {
        return /* Hide */1;
      });
  var setShowPackingConfirm = match$2[1];
  var match$3 = React.useState(function () {
        return /* Hide */1;
      });
  var setShowNothingToPacking = match$3[1];
  var match$4 = React.useState(function () {
        
      });
  var setSuccessResultPacking = match$4[1];
  var match$5 = React.useState(function () {
        return /* Hide */1;
      });
  var setShowPackingSuccess = match$5[1];
  var match$6 = React.useState(function () {
        return /* Hide */1;
      });
  var setShowPackingError = match$6[1];
  React.useEffect((function () {
          setOrdersToPacking(function (param) {
                
              });
          
        }), [router.query]);
  var count;
  if (typeof status === "number") {
    count = "-";
  } else if (status.TAG === /* Loaded */0) {
    var orders$p = CustomHooks.Orders.orders_decode(status._0);
    count = orders$p.TAG === /* Ok */0 ? String(orders$p._0.count) : "-";
  } else {
    count = "-";
  }
  var handleOnCheckOrder = function (orderProductNo, e) {
    var checked = e.target.checked;
    if (checked) {
      var newOrdersToPacking = Belt_SetString.add(ordersToPacking, orderProductNo);
      return setOrdersToPacking(function (param) {
                  return newOrdersToPacking;
                });
    }
    var newOrdersToPacking$1 = Belt_SetString.remove(ordersToPacking, orderProductNo);
    return setOrdersToPacking(function (param) {
                return newOrdersToPacking$1;
              });
  };
  var check = function (orderProductNo) {
    return Belt_SetString.has(ordersToPacking, orderProductNo);
  };
  var handleCheckAll = function (e) {
    var checked = e.target.checked;
    if (!checked) {
      return setOrdersToPacking(function (param) {
                  
                });
    }
    if (typeof status === "number") {
      return ;
    }
    if (status.TAG !== /* Loaded */0) {
      return ;
    }
    var orders$p = CustomHooks.Orders.orders_decode(status._0);
    var allOrderProductNo;
    allOrderProductNo = orders$p.TAG === /* Ok */0 ? Belt_SetString.fromArray(Garter_Array.map(Garter_Array.keep(orders$p._0.data, (function (order) {
                      return order.status === /* CREATE */0;
                    })), (function (order) {
                  return order.orderProductNo;
                }))) : undefined;
    return setOrdersToPacking(function (param) {
                return allOrderProductNo;
              });
  };
  var countOfChecked = Belt_SetString.size(ordersToPacking);
  var changeOrdersToPacking = function (orders) {
    setShowPackingConfirm(function (param) {
          return /* Hide */1;
        });
    Belt_Option.map(JSON.stringify({
              "order-product-numbers": orders
            }), (function (body) {
            return FetchHelper.requestWithRetry(FetchHelper.postWithToken, Env.restApiUrl + "/order/packing", body, 3, (function (res) {
                          var res$p = response_decode(res);
                          var result;
                          if (res$p.TAG === /* Ok */0) {
                            var res$p$1 = res$p._0;
                            result = [
                              res$p$1.data.totalCount,
                              res$p$1.data.updateCount
                            ];
                          } else {
                            result = undefined;
                          }
                          setSuccessResultPacking(function (param) {
                                return result;
                              });
                          setShowPackingSuccess(function (param) {
                                return /* Show */0;
                              });
                          setOrdersToPacking(function (param) {
                                
                              });
                          mutate(Env.restApiUrl + "/order?" + new URLSearchParams(router.query).toString(), undefined, undefined);
                          return mutate(Env.restApiUrl + "/order/summary?" + Period.currentPeriod(router), undefined, undefined);
                        }), (function (param) {
                          return setShowPackingError(function (param) {
                                      return /* Show */0;
                                    });
                        }));
          }));
    
  };
  var isTotalSelected = Belt_Option.isNone(Js_dict.get(router.query, "status"));
  var isCreateSelected = Belt_Option.isSome(Belt_Option.keep(Js_dict.get(router.query, "status"), (function (status) {
              return status === "CREATE";
            })));
  return React.createElement(React.Fragment, undefined, React.createElement("div", {
                  className: "sm:px-10 md:px-20"
                }, React.createElement(Orders_Seller$Notice, {}), React.createElement(Summary_Order_Seller.make, {}), React.createElement("div", {
                      className: "lg:px-7 mt-4 shadow-gl overflow-x-scroll"
                    }, React.createElement("div", {
                          className: "md:flex md:justify-between pb-4 text-base"
                        }, React.createElement("div", {
                              className: "pt-10 px-5 lg:px-0 flex flex-col lg:flex-row sm:flex-auto sm:justify-between"
                            }, React.createElement("h3", {
                                  className: "font-bold"
                                }, "주문내역", React.createElement("span", {
                                      className: "ml-1 text-green-gl font-normal"
                                    }, count + "건")), React.createElement("div", {
                                  className: "flex flex-col lg:flex-row mt-4 lg:mt-0"
                                }, React.createElement("div", {
                                      className: "flex items-center"
                                    }, React.createElement(Select_CountPerPage.make, {
                                          className: "mr-2"
                                        }), React.createElement(Select_Sorted.make, {
                                          className: "mr-2"
                                        })), React.createElement("div", {
                                      className: "flex mt-2 lg:mt-0"
                                    }, isTotalSelected || isCreateSelected ? React.createElement("button", {
                                            className: "hidden lg:flex h-9 px-3 text-white bg-green-gl rounded-lg items-center mr-2",
                                            onClick: (function (param) {
                                                if (countOfChecked > 0) {
                                                  return setShowPackingConfirm(function (param) {
                                                              return /* Show */0;
                                                            });
                                                } else {
                                                  return setShowNothingToPacking(function (param) {
                                                              return /* Show */0;
                                                            });
                                                }
                                              })
                                          }, "상품준비중으로 변경") : null, React.createElement(Excel_Download_Request_Button.make, {
                                          userType: /* Seller */0,
                                          requestUrl: "/order/request-excel/farmer"
                                        }))))), React.createElement(Orders_Seller$List, {
                          status: status,
                          check: check,
                          onCheckOrder: handleOnCheckOrder,
                          countOfChecked: countOfChecked,
                          onCheckAll: handleCheckAll,
                          onClickPacking: changeOrdersToPacking
                        }))), React.createElement(Dialog.make, {
                  isShow: match$2[0],
                  children: React.createElement("p", {
                        className: "text-black-gl text-center whitespace-pre-wrap"
                      }, React.createElement("span", {
                            className: "font-bold"
                          }, "선택한 " + String(countOfChecked) + "개"), "의 주문을\n상품준비중으로 변경하시겠습니까?"),
                  onCancel: (function (param) {
                      return setShowPackingConfirm(function (param) {
                                  return /* Hide */1;
                                });
                    }),
                  onConfirm: (function (param) {
                      return changeOrdersToPacking(Belt_SetString.toArray(ordersToPacking));
                    }),
                  textOnCancel: "취소",
                  textOnConfirm: "확인"
                }), React.createElement(Dialog.make, {
                  isShow: match$3[0],
                  children: null,
                  onCancel: (function (param) {
                      return setShowNothingToPacking(function (param) {
                                  return /* Hide */1;
                                });
                    }),
                  textOnCancel: "확인"
                }, React.createElement("a", {
                      className: "hidden",
                      id: "link-of-guide",
                      href: Env.cancelFormUrl,
                      target: "_blank"
                    }), React.createElement("p", {
                      className: "text-black-gl text-center whitespace-pre-wrap"
                    }, "상품준비중으로 변경할 주문을 선택해주세요.")), React.createElement(Dialog.make, {
                  isShow: match$5[0],
                  children: React.createElement("p", {
                        className: "text-gray-500 text-center whitespace-pre-wrap"
                      }, Belt_Option.mapWithDefault(match$4[0], "상품준비중 변경에 성공하였습니다.", (function (param) {
                              var updateCount = param[1];
                              var totalCount = param[0];
                              if ((totalCount - updateCount | 0) > 0) {
                                return React.createElement(React.Fragment, undefined, React.createElement("span", {
                                                className: "font-bold"
                                              }, String(totalCount) + "개 중 " + String(updateCount) + "개가 정상적으로 상품준비중으로 처리되었습니다."), "\n\n" + String(totalCount - updateCount | 0) + "개의 주문은 바이어 주문취소 등의 이유로 상품준비중으로 처리되지 못했습니다");
                              } else {
                                return String(totalCount) + "개의 주문을 상품준비중으로 변경에 성공하였습니다.";
                              }
                            }))),
                  onConfirm: (function (param) {
                      return setShowPackingSuccess(function (param) {
                                  return /* Hide */1;
                                });
                    })
                }), React.createElement(Dialog.make, {
                  isShow: match$6[0],
                  children: React.createElement("p", {
                        className: "text-gray-500 text-center whitespace-pre-wrap"
                      }, "상품준비중 변경에 실패하였습니다.\n다시 시도하시기 바랍니다."),
                  onConfirm: (function (param) {
                      return setShowPackingError(function (param) {
                                  return /* Hide */1;
                                });
                    })
                }));
}

var Orders = {
  make: Orders_Seller$Orders
};

function Orders_Seller(Props) {
  return React.createElement(Authorization.Seller.make, {
              children: React.createElement(Orders_Seller$Orders, {}),
              title: "주문내역 조회"
            });
}

var make = Orders_Seller;

export {
  Notice ,
  List ,
  data_encode ,
  data_decode ,
  response_encode ,
  response_decode ,
  Orders ,
  make ,
  
}
/* Env Not a pure module */