// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Env from "../../constants/Env.mjs";
import * as Swr from "swr";
import * as Curry from "rescript/lib/es6/curry.js";
import * as Spice from "@greenlabs/ppx-spice/src/rescript/Spice.mjs";
import * as React from "react";
import * as Dialog from "../../components/common/Dialog.mjs";
import * as Period from "../../utils/Period.mjs";
import * as Js_dict from "rescript/lib/es6/js_dict.js";
import * as Js_json from "rescript/lib/es6/js_json.js";
import * as Checkbox from "../../components/common/Checkbox.mjs";
import * as Constants from "../../constants/Constants.mjs";
import * as IconCheck from "../../components/svgs/IconCheck.mjs";
import * as IconError from "../../components/svgs/IconError.mjs";
import * as ErrorPanel from "../../components/common/ErrorPanel.mjs";
import * as Pagination from "../../components/common/Pagination.mjs";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as CustomHooks from "../../utils/CustomHooks.mjs";
import * as EmptyOrders from "../../components/common/EmptyOrders.mjs";
import * as Order_Buyer from "../../components/Order_Buyer.mjs";
import * as Router from "next/router";
import * as ReactRelay from "react-relay";
import * as Garter_Array from "@greenlabs/garter/src/Garter_Array.mjs";
import * as Authorization from "../../utils/Authorization.mjs";
import * as Select_Sorted from "../../components/Select_Sorted.mjs";
import * as RelayRuntime from "relay-runtime";
import * as Belt_SetString from "rescript/lib/es6/belt_SetString.js";
import * as PC_MyInfo_Sidebar from "./pc/me/PC_MyInfo_Sidebar.mjs";
import * as FeatureFlagWrapper from "./pc/FeatureFlagWrapper.mjs";
import * as Select_CountPerPage from "../../components/Select_CountPerPage.mjs";
import * as Summary_Order_Buyer from "../../components/Summary_Order_Buyer.mjs";
import * as ReactToastNotifications from "react-toast-notifications";
import * as OrdersBuyer_Mutation_graphql from "../../__generated__/OrdersBuyer_Mutation_graphql.mjs";
import * as Excel_Download_Request_Button from "../../components/Excel_Download_Request_Button.mjs";

function commitMutation(environment, variables, optimisticUpdater, optimisticResponse, updater, onCompleted, onError, uploadables, param) {
  return RelayRuntime.commitMutation(environment, {
              mutation: OrdersBuyer_Mutation_graphql.node,
              variables: OrdersBuyer_Mutation_graphql.Internal.convertVariables(variables),
              onCompleted: (function (res, err) {
                  if (onCompleted !== undefined) {
                    return Curry._2(onCompleted, OrdersBuyer_Mutation_graphql.Internal.convertResponse(res), (err == null) ? undefined : Caml_option.some(err));
                  }
                  
                }),
              onError: (function (err) {
                  if (onError !== undefined) {
                    return Curry._1(onError, (err == null) ? undefined : Caml_option.some(err));
                  }
                  
                }),
              optimisticResponse: optimisticResponse !== undefined ? OrdersBuyer_Mutation_graphql.Internal.convertWrapRawResponse(optimisticResponse) : undefined,
              optimisticUpdater: optimisticUpdater,
              updater: updater !== undefined ? (function (store, r) {
                    Curry._2(updater, store, OrdersBuyer_Mutation_graphql.Internal.convertResponse(r));
                  }) : undefined,
              uploadables: uploadables
            });
}

function use(param) {
  var match = ReactRelay.useMutation(OrdersBuyer_Mutation_graphql.node);
  var mutate = match[0];
  return [
          React.useMemo((function () {
                  return function (param, param$1, param$2, param$3, param$4, param$5, param$6, param$7, param$8) {
                    return Curry._1(mutate, {
                                onError: param,
                                onCompleted: param$1 !== undefined ? (function (r, errors) {
                                      Curry._2(param$1, OrdersBuyer_Mutation_graphql.Internal.convertResponse(r), (errors == null) ? undefined : Caml_option.some(errors));
                                    }) : undefined,
                                onUnsubscribe: param$2,
                                optimisticResponse: param$3 !== undefined ? OrdersBuyer_Mutation_graphql.Internal.convertWrapRawResponse(param$3) : undefined,
                                optimisticUpdater: param$4,
                                updater: param$5 !== undefined ? (function (store, r) {
                                      Curry._2(param$5, store, OrdersBuyer_Mutation_graphql.Internal.convertResponse(r));
                                    }) : undefined,
                                variables: OrdersBuyer_Mutation_graphql.Internal.convertVariables(param$6),
                                uploadables: param$7
                              });
                  };
                }), [mutate]),
          match[1]
        ];
}

var Mutation = {
  Operation: undefined,
  Types: undefined,
  commitMutation: commitMutation,
  use: use
};

function Orders_Buyer$List(Props) {
  var status = Props.status;
  var check = Props.check;
  var onCheckOrder = Props.onCheckOrder;
  var onCheckAll = Props.onCheckAll;
  var countOfChecked = Props.countOfChecked;
  var onClickCancel = Props.onClickCancel;
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
          className: "divide-y divide-gray-300 lg:divide-gray-100 lg:list-height-buyer lg:overflow-y-scroll"
        }, orders$p$3.data.length !== 0 ? Garter_Array.map(orders$p$3.data, (function (order) {
                  return React.createElement(Order_Buyer.make, {
                              order: order,
                              check: check,
                              onCheckOrder: onCheckOrder,
                              onClickCancel: onClickCancel,
                              key: order.orderProductNo
                            });
                })) : React.createElement(EmptyOrders.make, {}));
  } else {
    tmp = React.createElement(EmptyOrders.make, {});
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
                          className: "hidden lg:grid lg:grid-cols-9-buyer-order bg-gray-100 text-gray-500 h-12"
                        }, React.createElement("div", {
                              className: "h-full px-4 flex items-center whitespace-nowrap"
                            }, React.createElement(Checkbox.make, {
                                  id: "check-all",
                                  checked: isCheckAll,
                                  onChange: onCheckAll,
                                  disabled: isDisabledCheckAll
                                })), React.createElement("div", {
                              className: "h-full px-4 flex items-center whitespace-nowrap"
                            }, "주문번호·일자·바이어"), React.createElement("div", {
                              className: "h-full px-4 flex items-center whitespace-nowrap"
                            }, "주문상품"), React.createElement("div", {
                              className: "h-full px-4 flex items-center text-center whitespace-nowrap"
                            }, "상품금액·결제수단"), React.createElement("div", {
                              className: "h-full px-4 flex items-center text-center whitespace-nowrap"
                            }, "수량"), React.createElement("div", {
                              className: "h-full px-4 flex items-center whitespace-nowrap"
                            }, "운송장번호"), React.createElement("div", {
                              className: "h-full px-4 flex items-center whitespace-nowrap"
                            }, "배송정보"), React.createElement("div", {
                              className: "h-full px-4 flex items-center whitespace-nowrap"
                            }, "주문자명·연락처"), React.createElement("div", {
                              className: "h-full px-4 flex items-center whitespace-nowrap text-center"
                            }, "출고일")), tmp)), tmp$1);
}

var List = {
  make: Orders_Buyer$List
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

function Orders_Buyer$Orders(Props) {
  var router = Router.useRouter();
  var match = Swr.useSWRConfig();
  var mutate = match.mutate;
  var match$1 = ReactToastNotifications.useToasts();
  var addToast = match$1.addToast;
  var match$2 = use(undefined);
  var isMutating = match$2[1];
  var cancelMutate = match$2[0];
  var status = CustomHooks.Orders.use(new URLSearchParams(router.query).toString());
  var match$3 = React.useState(function () {
        
      });
  var setOrdersToCancel = match$3[1];
  var ordersToCancel = match$3[0];
  var match$4 = React.useState(function () {
        return /* Hide */1;
      });
  var setShowCancelConfirm = match$4[1];
  var isShowCancelConfirm = match$4[0];
  var match$5 = React.useState(function () {
        return /* Hide */1;
      });
  var setShowNothingToCancel = match$5[1];
  var isShowNothingToCancel = match$5[0];
  var match$6 = React.useState(function () {
        return /* Hide */1;
      });
  var setShowCancelError = match$6[1];
  var isShowCancelError = match$6[0];
  React.useEffect((function () {
          setOrdersToCancel(function (param) {
                
              });
        }), [router.query]);
  var count;
  if (typeof status === "number" || status.TAG !== /* Loaded */0) {
    count = "-";
  } else {
    var orders$p = CustomHooks.Orders.orders_decode(status._0);
    count = orders$p.TAG === /* Ok */0 ? String(orders$p._0.count) : "-";
  }
  var handleOnCheckOrder = function (orderProductNo, e) {
    var checked = e.target.checked;
    if (checked) {
      var newOrdersToCancel = Belt_SetString.add(ordersToCancel, orderProductNo);
      return setOrdersToCancel(function (param) {
                  return newOrdersToCancel;
                });
    }
    var newOrdersToCancel$1 = Belt_SetString.remove(ordersToCancel, orderProductNo);
    setOrdersToCancel(function (param) {
          return newOrdersToCancel$1;
        });
  };
  var check = function (orderProductNo) {
    return Belt_SetString.has(ordersToCancel, orderProductNo);
  };
  var handleCheckAll = function (e) {
    var checked = e.target.checked;
    if (!checked) {
      return setOrdersToCancel(function (param) {
                  
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
    setOrdersToCancel(function (param) {
          return allOrderProductNo;
        });
  };
  var countOfChecked = Belt_SetString.size(ordersToCancel);
  var handleError = function (message) {
    addToast(React.createElement("div", {
              className: "flex items-center"
            }, React.createElement(IconError.make, {
                  width: "24",
                  height: "24",
                  className: "mr-2"
                }), message), {
          appearance: "error"
        });
  };
  var cancelOrder = function (orders) {
    if (isMutating) {
      return ;
    } else {
      Curry.app(cancelMutate, [
            (function (err) {
                handleError(err.message);
              }),
            (function (param, param$1) {
                var cancelWosOrderProductOption = param.cancelWosOrderProductOption;
                if (cancelWosOrderProductOption === undefined) {
                  return handleError("주문 취소에 실패하였습니다.");
                }
                if (typeof cancelWosOrderProductOption !== "object") {
                  return handleError("주문 취소에 실패하였습니다.");
                }
                var variant = cancelWosOrderProductOption.NAME;
                if (variant === "CancelWosOrderProductOptionResult") {
                  setShowCancelConfirm(function (param) {
                        return /* Hide */1;
                      });
                  setOrdersToCancel(function (param) {
                        
                      });
                  mutate("" + Env.restApiUrl + "/order?" + new URLSearchParams(router.query).toString() + "", undefined, undefined);
                  mutate("" + Env.restApiUrl + "/order/summary?" + Period.currentPeriod(router) + "", undefined, undefined);
                  return addToast(React.createElement("div", {
                                  className: "flex items-center"
                                }, React.createElement(IconCheck.make, {
                                      height: "24",
                                      width: "24",
                                      fill: "#12B564",
                                      className: "mr-2"
                                    }), "주문이 취소되었습니다."), {
                              appearance: "success"
                            });
                } else if (variant === "Error") {
                  return handleError(Belt_Option.getWithDefault(cancelWosOrderProductOption.VAL.message, "주문 취소에 실패하였습니다."));
                } else {
                  return handleError("주문 취소에 실패하였습니다.");
                }
              }),
            undefined,
            undefined,
            undefined,
            undefined,
            {
              input: orders
            },
            undefined,
            undefined
          ]);
      return ;
    }
  };
  var isTotalSelected = Belt_Option.isNone(Js_dict.get(router.query, "status"));
  var isCreateSelected = Belt_Option.isSome(Belt_Option.keep(Js_dict.get(router.query, "status"), (function (status) {
              return status === "CREATE";
            })));
  var oldUI = React.createElement(React.Fragment, undefined, React.createElement("div", {
            className: "sm:px-10 md:px-20"
          }, React.createElement(Summary_Order_Buyer.make, {}), React.createElement("div", {
                className: "lg:px-7 mt-4 shadow-gl"
              }, React.createElement("div", {
                    className: "md:flex md:justify-between pb-4 text-base"
                  }, React.createElement("div", {
                        className: "pt-10 px-5 flex flex-col lg:flex-row sm:flex-auto sm:justify-between"
                      }, React.createElement("h3", {
                            className: "font-bold"
                          }, "주문내역", React.createElement("span", {
                                className: "ml-1 text-green-gl font-normal"
                              }, "" + count + "건")), React.createElement("div", {
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
                                      className: "hidden lg:flex items-center h-9 px-3 text-white bg-green-gl rounded-lg mr-2",
                                      onClick: (function (param) {
                                          if (countOfChecked > 0) {
                                            return setShowCancelConfirm(function (param) {
                                                        return /* Show */0;
                                                      });
                                          } else {
                                            return setShowNothingToCancel(function (param) {
                                                        return /* Show */0;
                                                      });
                                          }
                                        })
                                    }, "선택한 항목 주문 취소") : null, React.createElement(Excel_Download_Request_Button.make, {
                                    userType: /* Buyer */1,
                                    requestUrl: "/order/request-excel/buyer"
                                  }))))), React.createElement(Orders_Buyer$List, {
                    status: status,
                    check: check,
                    onCheckOrder: handleOnCheckOrder,
                    onCheckAll: handleCheckAll,
                    countOfChecked: countOfChecked,
                    onClickCancel: cancelOrder
                  }))), React.createElement(Dialog.make, {
            isShow: isShowCancelConfirm,
            children: null,
            onCancel: (function (param) {
                setShowCancelConfirm(function (param) {
                      return /* Hide */1;
                    });
              }),
            onConfirm: (function (param) {
                cancelOrder(Belt_SetString.toArray(ordersToCancel));
              }),
            textOnCancel: "취소",
            textOnConfirm: "확인"
          }, React.createElement("a", {
                className: "hidden",
                id: "link-of-guide",
                href: Env.cancelFormUrl,
                target: "_blank"
              }), React.createElement("p", {
                className: "text-black-gl text-center whitespace-pre-wrap"
              }, React.createElement("span", {
                    className: "font-bold"
                  }, "선택한 " + String(countOfChecked) + "개"), "의 주문을 취소하시겠습니까?")), React.createElement(Dialog.make, {
            isShow: isShowNothingToCancel,
            children: null,
            onCancel: (function (param) {
                setShowNothingToCancel(function (param) {
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
              }, "취소할 주문을 선택해주세요.")), React.createElement(Dialog.make, {
            isShow: isShowCancelError,
            children: React.createElement("p", {
                  className: "text-gray-500 text-center whitespace-pre-wrap"
                }, "주문 취소에 실패하였습니다.\n다시 시도하시기 바랍니다."),
            onConfirm: (function (param) {
                setShowCancelError(function (param) {
                      return /* Hide */1;
                    });
              })
          }));
  return React.createElement(FeatureFlagWrapper.make, {
              children: React.createElement("div", {
                    className: "lg:w-[1920px] mx-auto bg-[#FAFBFC] flex"
                  }, React.createElement("div", {
                        className: "hidden lg:block "
                      }, React.createElement(PC_MyInfo_Sidebar.make, {})), React.createElement("div", {
                        className: "sm:px-10 md:px-20 lg:mx-16 lg:px-0 lg:mt-10 lg:rounded-sm shadow-[0px_10px_40px_10px_rgba(0,0,0,0.03)] lg:max-w-[1280px] lg:min-w-[872px] w-full lg:mb-10 lg:h-fit"
                      }, React.createElement(Summary_Order_Buyer.make, {}), React.createElement("div", {
                            className: "lg:px-7 bg-white "
                          }, React.createElement("div", {
                                className: "md:flex md:justify-between mt-4 lg:mt-0 pb-4 text-base"
                              }, React.createElement("div", {
                                    className: "pt-10 px-5 flex flex-col lg:flex-row sm:flex-auto sm:justify-between"
                                  }, React.createElement("h3", {
                                        className: "font-bold"
                                      }, "주문내역", React.createElement("span", {
                                            className: "ml-1 text-green-gl font-normal"
                                          }, "" + count + "건")), React.createElement("div", {
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
                                                  className: "hidden lg:flex items-center h-9 px-3 text-white bg-green-gl rounded-lg mr-2",
                                                  onClick: (function (param) {
                                                      if (countOfChecked > 0) {
                                                        return setShowCancelConfirm(function (param) {
                                                                    return /* Show */0;
                                                                  });
                                                      } else {
                                                        return setShowNothingToCancel(function (param) {
                                                                    return /* Show */0;
                                                                  });
                                                      }
                                                    })
                                                }, "선택한 항목 주문 취소") : null, React.createElement(Excel_Download_Request_Button.make, {
                                                userType: /* Buyer */1,
                                                requestUrl: "/order/request-excel/buyer"
                                              }))))), React.createElement(Orders_Buyer$List, {
                                status: status,
                                check: check,
                                onCheckOrder: handleOnCheckOrder,
                                onCheckAll: handleCheckAll,
                                countOfChecked: countOfChecked,
                                onClickCancel: cancelOrder
                              }))), React.createElement(Dialog.make, {
                        isShow: isShowCancelConfirm,
                        children: null,
                        onCancel: (function (param) {
                            setShowCancelConfirm(function (param) {
                                  return /* Hide */1;
                                });
                          }),
                        onConfirm: (function (param) {
                            cancelOrder(Belt_SetString.toArray(ordersToCancel));
                          }),
                        textOnCancel: "취소",
                        textOnConfirm: "확인"
                      }, React.createElement("a", {
                            className: "hidden",
                            id: "link-of-guide",
                            href: Env.cancelFormUrl,
                            target: "_blank"
                          }), React.createElement("p", {
                            className: "text-black-gl text-center whitespace-pre-wrap"
                          }, React.createElement("span", {
                                className: "font-bold"
                              }, "선택한 " + String(countOfChecked) + "개"), "의 주문을 취소하시겠습니까?")), React.createElement(Dialog.make, {
                        isShow: isShowNothingToCancel,
                        children: null,
                        onCancel: (function (param) {
                            setShowNothingToCancel(function (param) {
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
                          }, "취소할 주문을 선택해주세요.")), React.createElement(Dialog.make, {
                        isShow: isShowCancelError,
                        children: React.createElement("p", {
                              className: "text-gray-500 text-center whitespace-pre-wrap"
                            }, "주문 취소에 실패하였습니다.\n다시 시도하시기 바랍니다."),
                        onConfirm: (function (param) {
                            setShowCancelError(function (param) {
                                  return /* Hide */1;
                                });
                          })
                      })),
              fallback: oldUI,
              featureFlag: "HOME_UI_UX"
            });
}

var Orders = {
  make: Orders_Buyer$Orders
};

function Orders_Buyer(Props) {
  return React.createElement(Authorization.Buyer.make, {
              children: React.createElement(Orders_Buyer$Orders, {}),
              title: "주문내역 조회"
            });
}

var make = Orders_Buyer;

export {
  Mutation ,
  List ,
  data_encode ,
  data_decode ,
  response_encode ,
  response_decode ,
  Orders ,
  make ,
}
/* Env Not a pure module */
