// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Env from "../../constants/Env.mjs";
import * as Swr from "swr";
import * as React from "react";
import * as Dialog from "../../components/common/Dialog.mjs";
import * as IconError from "../../components/svgs/IconError.mjs";
import * as Belt_Float from "rescript/lib/es6/belt_Float.js";
import * as DatePicker from "../../components/DatePicker.mjs";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as CustomHooks from "../../utils/CustomHooks.mjs";
import * as FetchHelper from "../../utils/FetchHelper.mjs";
import * as ReactEvents from "../../utils/ReactEvents.mjs";
import * as Router from "next/router";
import * as Garter_Array from "@greenlabs/garter/src/Garter_Array.mjs";
import * as Authorization from "../../utils/Authorization.mjs";
import * as Belt_MapString from "rescript/lib/es6/belt_MapString.js";
import * as Belt_SetString from "rescript/lib/es6/belt_SetString.js";
import * as Select_Cost_Kind from "../../components/Select_Cost_Kind.mjs";
import AddDays from "date-fns/addDays";
import * as Summary_Cost_Admin from "../../components/Summary_Cost_Admin.mjs";
import * as Select_CountPerPage from "../../components/Select_CountPerPage.mjs";
import * as CostManagement_List_Admin from "../../components/CostManagement_List_Admin.mjs";
import * as ReactToastNotifications from "react-toast-notifications";

function convertCost(cost) {
  return [
          cost.sku,
          {
            rawCost: undefined,
            workingCost: undefined,
            deliveryCost: undefined,
            effectiveDate: undefined,
            price: undefined,
            contractType: cost.contractType,
            producerName: cost.producerName,
            productName: cost.producerName,
            optionName: cost.optionName,
            producerId: cost.producerId,
            productId: cost.productId,
            sku: cost.sku
          }
        ];
}

function CostManagement_Admin$Costs(props) {
  var status = props.status;
  var router = Router.useRouter();
  var match = Swr.useSWRConfig();
  var mutate = match.mutate;
  var match$1 = ReactToastNotifications.useToasts();
  var addToast = match$1.addToast;
  var match$2 = React.useState(function () {
        
      });
  var setSkusToSave = match$2[1];
  var skusToSave = match$2[0];
  var match$3 = React.useState(function () {
        return AddDays(new Date(), 1);
      });
  var setStartDate = match$3[1];
  var startDate = match$3[0];
  var match$4 = React.useState(function () {
        
      });
  var setNewCosts = match$4[1];
  var newCosts = match$4[0];
  var match$5 = React.useState(function () {
        return /* Hide */1;
      });
  var setShowNothingToSave = match$5[1];
  var match$6 = React.useState(function () {
        return /* Hide */1;
      });
  var setShowInvalidCost = match$6[1];
  var match$7 = React.useState(function () {
        return /* Hide */1;
      });
  var setShowSuccessToSave = match$7[1];
  var handleOnChangeDate = function (e) {
    var newDate = e.detail.valueAsDate;
    if (newDate === undefined) {
      return ;
    }
    var newDate$p = Caml_option.valFromOption(newDate);
    setStartDate(function (param) {
          return newDate$p;
        });
  };
  var handleOnChangeEffectiveDate = function (sku, dateAsValue) {
    var newSkusToSave = Belt_SetString.add(skusToSave, sku);
    setSkusToSave(function (param) {
          return newSkusToSave;
        });
    console.log("date", dateAsValue.toISOString());
    setNewCosts(function (prevCosts) {
          return Belt_Option.mapWithDefault(Belt_Option.map(Belt_MapString.get(prevCosts, sku), (function (prevCost) {
                            return {
                                    rawCost: prevCost.rawCost,
                                    workingCost: prevCost.workingCost,
                                    deliveryCost: prevCost.deliveryCost,
                                    effectiveDate: Caml_option.some(dateAsValue),
                                    price: prevCost.price,
                                    contractType: prevCost.contractType,
                                    producerName: prevCost.producerName,
                                    productName: prevCost.productName,
                                    optionName: prevCost.optionName,
                                    producerId: prevCost.producerId,
                                    productId: prevCost.productId,
                                    sku: prevCost.sku
                                  };
                          })), prevCosts, (function (newCost) {
                        return Belt_MapString.set(prevCosts, sku, newCost);
                      }));
        });
  };
  var handleOnChangePrice = function (sku, newPrice) {
    var newSkusToSave = Belt_SetString.add(skusToSave, sku);
    setSkusToSave(function (param) {
          return newSkusToSave;
        });
    setNewCosts(function (prevCosts) {
          return Belt_Option.mapWithDefault(Belt_Option.map(Belt_MapString.get(prevCosts, sku), (function (prevCost) {
                            return {
                                    rawCost: prevCost.rawCost,
                                    workingCost: prevCost.workingCost,
                                    deliveryCost: prevCost.deliveryCost,
                                    effectiveDate: prevCost.effectiveDate,
                                    price: newPrice,
                                    contractType: prevCost.contractType,
                                    producerName: prevCost.producerName,
                                    productName: prevCost.productName,
                                    optionName: prevCost.optionName,
                                    producerId: prevCost.producerId,
                                    productId: prevCost.productId,
                                    sku: prevCost.sku
                                  };
                          })), prevCosts, (function (newCost) {
                        return Belt_MapString.set(prevCosts, sku, newCost);
                      }));
        });
  };
  var handleOnChangeRawCost = function (sku, newCost) {
    var newSkusToSave = Belt_SetString.add(skusToSave, sku);
    setSkusToSave(function (param) {
          return newSkusToSave;
        });
    setNewCosts(function (prevCosts) {
          return Belt_Option.mapWithDefault(Belt_Option.map(Belt_MapString.get(prevCosts, sku), (function (prevCost) {
                            return {
                                    rawCost: newCost,
                                    workingCost: prevCost.workingCost,
                                    deliveryCost: prevCost.deliveryCost,
                                    effectiveDate: prevCost.effectiveDate,
                                    price: prevCost.price,
                                    contractType: prevCost.contractType,
                                    producerName: prevCost.producerName,
                                    productName: prevCost.productName,
                                    optionName: prevCost.optionName,
                                    producerId: prevCost.producerId,
                                    productId: prevCost.productId,
                                    sku: prevCost.sku
                                  };
                          })), prevCosts, (function (newCost$p) {
                        return Belt_MapString.set(prevCosts, sku, newCost$p);
                      }));
        });
  };
  var handleOnChangeDeliveryCost = function (sku, newCost) {
    var newSkusToSave = Belt_SetString.add(skusToSave, sku);
    setSkusToSave(function (param) {
          return newSkusToSave;
        });
    setNewCosts(function (prevCosts) {
          return Belt_Option.mapWithDefault(Belt_Option.map(Belt_MapString.get(prevCosts, sku), (function (prevCost) {
                            return {
                                    rawCost: prevCost.rawCost,
                                    workingCost: prevCost.workingCost,
                                    deliveryCost: newCost,
                                    effectiveDate: prevCost.effectiveDate,
                                    price: prevCost.price,
                                    contractType: prevCost.contractType,
                                    producerName: prevCost.producerName,
                                    productName: prevCost.productName,
                                    optionName: prevCost.optionName,
                                    producerId: prevCost.producerId,
                                    productId: prevCost.productId,
                                    sku: prevCost.sku
                                  };
                          })), prevCosts, (function (newCost$p) {
                        return Belt_MapString.set(prevCosts, sku, newCost$p);
                      }));
        });
  };
  var handleOnChangeWorkingCost = function (sku, newCost) {
    var newSkusToSave = Belt_SetString.add(skusToSave, sku);
    setSkusToSave(function (param) {
          return newSkusToSave;
        });
    setNewCosts(function (prevCosts) {
          return Belt_Option.mapWithDefault(Belt_Option.map(Belt_MapString.get(prevCosts, sku), (function (prevCost) {
                            return {
                                    rawCost: prevCost.rawCost,
                                    workingCost: newCost,
                                    deliveryCost: prevCost.deliveryCost,
                                    effectiveDate: prevCost.effectiveDate,
                                    price: prevCost.price,
                                    contractType: prevCost.contractType,
                                    producerName: prevCost.producerName,
                                    productName: prevCost.productName,
                                    optionName: prevCost.optionName,
                                    producerId: prevCost.producerId,
                                    productId: prevCost.productId,
                                    sku: prevCost.sku
                                  };
                          })), prevCosts, (function (newCost$p) {
                        return Belt_MapString.set(prevCosts, sku, newCost$p);
                      }));
        });
  };
  var count;
  if (typeof status === "number" || status.TAG !== /* Loaded */0) {
    count = "-";
  } else {
    var costs$p = CustomHooks.Costs.costs_decode(status._0);
    count = costs$p.TAG === /* Ok */0 ? String(costs$p._0.count) : "-";
  }
  var handleOnChangeContractType = function (sku, typeAsValue) {
    var newSkusToSave = Belt_SetString.add(skusToSave, sku);
    setSkusToSave(function (param) {
          return newSkusToSave;
        });
    setNewCosts(function (prevCosts) {
          return Belt_Option.mapWithDefault(Belt_Option.map(Belt_MapString.get(prevCosts, sku), (function (prevCost) {
                            return {
                                    rawCost: prevCost.rawCost,
                                    workingCost: prevCost.workingCost,
                                    deliveryCost: prevCost.deliveryCost,
                                    effectiveDate: prevCost.effectiveDate,
                                    price: prevCost.price,
                                    contractType: typeAsValue,
                                    producerName: prevCost.producerName,
                                    productName: prevCost.productName,
                                    optionName: prevCost.optionName,
                                    producerId: prevCost.producerId,
                                    productId: prevCost.productId,
                                    sku: prevCost.sku
                                  };
                          })), prevCosts, (function (newCost$p) {
                        return Belt_MapString.set(prevCosts, sku, newCost$p);
                      }));
        });
  };
  var handleOnCheckCost = function (productSku, e) {
    var checked = e.target.checked;
    if (checked) {
      var newSkusToSave = Belt_SetString.add(skusToSave, productSku);
      return setSkusToSave(function (param) {
                  return newSkusToSave;
                });
    }
    var newSkusToSave$1 = Belt_SetString.remove(skusToSave, productSku);
    setSkusToSave(function (param) {
          return newSkusToSave$1;
        });
  };
  var check = function (productSku) {
    return Belt_SetString.has(skusToSave, productSku);
  };
  var handleCheckAll = function (e) {
    var checked = e.target.checked;
    if (!checked) {
      return setSkusToSave(function (param) {
                  
                });
    }
    if (typeof status === "number") {
      return ;
    }
    if (status.TAG !== /* Loaded */0) {
      return ;
    }
    var costs$p = CustomHooks.Costs.costs_decode(status._0);
    var allOrderProductNo;
    allOrderProductNo = costs$p.TAG === /* Ok */0 ? Belt_SetString.fromArray(Garter_Array.map(costs$p._0.data, (function (cost) {
                  return cost.sku;
                }))) : undefined;
    setSkusToSave(function (param) {
          return allOrderProductNo;
        });
  };
  var countOfChecked = Belt_SetString.size(skusToSave);
  var handleOnSave = function (param) {
    return ReactEvents.interceptingHandler((function (param) {
                  if (Belt_SetString.size(skusToSave) < 1) {
                    return setShowNothingToSave(function (param) {
                                return /* Show */0;
                              });
                  } else if (Garter_Array.keep(Garter_Array.keep(Belt_MapString.toArray(newCosts), (function (param) {
                                return Belt_SetString.has(skusToSave, param[0]);
                              })), (function (param) {
                            var v = param[1];
                            return Belt_Option.isSome(Belt_Option.flatMap(v.price, Belt_Float.fromString)) && Belt_Option.isSome(Belt_Option.flatMap(v.rawCost, Belt_Float.fromString)) && Belt_Option.isSome(v.effectiveDate) && Belt_Option.isSome(Belt_Option.flatMap(v.deliveryCost, Belt_Float.fromString)) ? Belt_Option.isSome(Belt_Option.flatMap(v.workingCost, Belt_Float.fromString)) : false;
                          })).length !== Belt_SetString.size(skusToSave)) {
                    return setShowInvalidCost(function (param) {
                                return /* Show */0;
                              });
                  } else {
                    return Belt_Option.forEach(JSON.stringify({
                                    list: Garter_Array.map(Garter_Array.keep(Belt_MapString.toArray(newCosts), (function (param) {
                                                return Belt_SetString.has(skusToSave, param[0]);
                                              })), (function (param) {
                                            var v = param[1];
                                            return {
                                                    price: Belt_Option.map(v.price, Belt_Float.fromString),
                                                    "raw-cost": Belt_Option.map(v.rawCost, Belt_Float.fromString),
                                                    "delivery-cost": Belt_Option.map(v.deliveryCost, Belt_Float.fromString),
                                                    "working-cost": Belt_Option.map(v.workingCost, Belt_Float.fromString),
                                                    "effective-date": Belt_Option.map(v.effectiveDate, (function (prim) {
                                                            return prim.toISOString();
                                                          })),
                                                    "producer-id": v.producerId,
                                                    "product-id": v.productId,
                                                    sku: v.sku,
                                                    "contract-type": CustomHooks.Costs.contractType_encode(v.contractType)
                                                  };
                                          }))
                                  }), (function (body) {
                                  FetchHelper.requestWithRetry(FetchHelper.postWithToken, "" + Env.restApiUrl + "/settlement/cost", body, 3, (function (param) {
                                          setShowSuccessToSave(function (param) {
                                                return /* Show */0;
                                              });
                                          mutate("" + Env.restApiUrl + "/settlement/cost?" + new URLSearchParams(router.query).toString() + "", undefined, true);
                                          setSkusToSave(function (param) {
                                                
                                              });
                                        }), (function (param) {
                                          addToast(React.createElement("div", {
                                                    className: "flex items-center"
                                                  }, React.createElement(IconError.make, {
                                                        width: "24",
                                                        height: "24",
                                                        className: "mr-2"
                                                      }), "저장 실패"), {
                                                appearance: "error"
                                              });
                                        }));
                                }));
                  }
                }), param);
  };
  var handleChangeAllEffectiveDate = function (param) {
    return ReactEvents.interceptingHandler((function (param) {
                  setNewCosts(function (prevCosts) {
                        return Belt_MapString.mapWithKey(prevCosts, (function (k, v) {
                                      if (Belt_SetString.has(skusToSave, k)) {
                                        return {
                                                rawCost: v.rawCost,
                                                workingCost: v.workingCost,
                                                deliveryCost: v.deliveryCost,
                                                effectiveDate: Caml_option.some(startDate),
                                                price: v.price,
                                                contractType: v.contractType,
                                                producerName: v.producerName,
                                                productName: v.productName,
                                                optionName: v.optionName,
                                                producerId: v.producerId,
                                                productId: v.productId,
                                                sku: v.sku
                                              };
                                      } else {
                                        return v;
                                      }
                                    }));
                      });
                }), param);
  };
  React.useEffect((function () {
          if (typeof status !== "number" && status.TAG === /* Loaded */0) {
            var costs$p = CustomHooks.Costs.costs_decode(status._0);
            if (costs$p.TAG === /* Ok */0) {
              var costs$p$1 = costs$p._0;
              setNewCosts(function (param) {
                    return Belt_MapString.fromArray(Garter_Array.map(costs$p$1.data, convertCost));
                  });
            }
            
          }
          return (function (param) {
                    setNewCosts(function (param) {
                          
                        });
                  });
        }), [status]);
  return React.createElement(React.Fragment, undefined, React.createElement("div", {
                  className: "max-w-gnb-panel overflow-auto overflow-x-scroll bg-div-shape-L1 min-h-screen"
                }, React.createElement("header", {
                      className: "flex items-baseline p-7 pb-0"
                    }, React.createElement("h1", {
                          className: "text-text-L1 text-xl font-bold"
                        }, "단품 가격관리")), React.createElement(Summary_Cost_Admin.make, {}), React.createElement("div", {
                      className: "p-7 m-4 bg-white rounded shadow-gl overflow-auto overflow-x-scroll"
                    }, React.createElement("div", {
                          className: "divide-y"
                        }, React.createElement("div", {
                              className: "flex flex-auto justify-between pb-3"
                            }, React.createElement("h3", {
                                  className: "text-lg font-bold"
                                }, "내역", React.createElement("span", {
                                      className: "text-base text-primary font-normal ml-1"
                                    }, "" + count + "건")), React.createElement("div", {
                                  className: "flex"
                                }, React.createElement(Select_CountPerPage.make, {
                                      className: "mr-2"
                                    }), React.createElement(Select_Cost_Kind.make, {}))), React.createElement("div", {
                              className: "flex items-center mb-3 pt-3"
                            }, React.createElement("div", {
                                  className: "mr-2"
                                }, "선택됨", React.createElement("span", {
                                      className: "text-default font-bold ml-1"
                                    }, String(countOfChecked))), React.createElement("div", {
                                  className: "flex items-center mx-2"
                                }, React.createElement(DatePicker.make, {
                                      id: "start-date",
                                      onChange: handleOnChangeDate,
                                      date: Caml_option.some(startDate),
                                      minDate: "2021-01-01",
                                      firstDayOfWeek: 0,
                                      align: /* Left */0
                                    }), React.createElement("span", {
                                      className: "w-auto"
                                    }, React.createElement("button", {
                                          className: Belt_SetString.size(skusToSave) > 0 ? "btn-level6 p-2 px-4 ml-2" : "btn-level6-disabled p-2 px-4 ml-2",
                                          disabled: Belt_SetString.size(skusToSave) < 1,
                                          onClick: handleChangeAllEffectiveDate
                                        }, "변경원가시작일 일괄적용"))), React.createElement("div", {
                                  className: "ml-2"
                                }, React.createElement("button", {
                                      className: "btn-level1 p-2 px-4",
                                      onClick: handleOnSave
                                    }, "저장")))), React.createElement(CostManagement_List_Admin.make, {
                          status: status,
                          newCosts: newCosts,
                          onChangeEffectiveDate: handleOnChangeEffectiveDate,
                          onChangePrice: handleOnChangePrice,
                          onChangeRawCost: handleOnChangeRawCost,
                          onChangeDeliveryCost: handleOnChangeDeliveryCost,
                          onChangeWorkingCost: handleOnChangeWorkingCost,
                          check: check,
                          onCheckCost: handleOnCheckCost,
                          onCheckAll: handleCheckAll,
                          countOfChecked: countOfChecked,
                          onChangeContractType: handleOnChangeContractType
                        }))), React.createElement(Dialog.make, {
                  isShow: match$5[0],
                  children: React.createElement("p", {
                        className: "text-gray-500 text-center whitespace-pre-wrap"
                      }, "저장할 상품 항목을 선택해주세요"),
                  onCancel: (function (param) {
                      setShowNothingToSave(function (param) {
                            return /* Hide */1;
                          });
                    }),
                  textOnCancel: "확인"
                }), React.createElement(Dialog.make, {
                  isShow: match$6[0],
                  children: React.createElement("p", {
                        className: "text-gray-500 text-center whitespace-pre-wrap"
                      }, "입력하신 변경원가시작일과 변경원가,변경바이어판매가를 확인해주세요."),
                  onCancel: (function (param) {
                      setShowInvalidCost(function (param) {
                            return /* Hide */1;
                          });
                    }),
                  textOnCancel: "확인"
                }), React.createElement(Dialog.make, {
                  isShow: match$7[0],
                  children: React.createElement("p", {
                        className: "text-gray-500 text-center whitespace-pre-wrap"
                      }, "선택한 변경원가,변경바이어판매가,변경원가시작일이 저장되었습니다."),
                  onCancel: (function (param) {
                      setShowSuccessToSave(function (param) {
                            return /* Hide */1;
                          });
                    }),
                  textOnCancel: "확인"
                }));
}

var Costs = {
  make: CostManagement_Admin$Costs
};

function CostManagement_Admin(props) {
  var router = Router.useRouter();
  var status = CustomHooks.Costs.use(new URLSearchParams(router.query).toString());
  return React.createElement(Authorization.Admin.make, {
              children: React.createElement(CostManagement_Admin$Costs, {
                    status: status
                  }),
              title: "관리자 단품가격관리"
            });
}

var List;

var make = CostManagement_Admin;

export {
  List ,
  convertCost ,
  Costs ,
  make ,
}
/* Env Not a pure module */
