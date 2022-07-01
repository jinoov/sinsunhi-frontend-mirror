// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Curry from "rescript/lib/es6/curry.js";
import * as Input from "./common/Input.mjs";
import * as React from "react";
import * as Locale from "../utils/Locale.mjs";
import * as Checkbox from "./common/Checkbox.mjs";
import * as Skeleton from "./Skeleton.mjs";
import * as Belt_Float from "rescript/lib/es6/belt_Float.js";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as CustomHooks from "../utils/CustomHooks.mjs";
import Format from "date-fns/format";
import StartOfDay from "date-fns/startOfDay";
import * as Select_ContractType_Admin from "./Select_ContractType_Admin.mjs";

function formatDate(d) {
  return Locale.DateTime.formatFromUTC(new Date(d), "yyyy/MM/dd");
}

function Cost_Admin$Item$Table(Props) {
  var cost = Props.cost;
  var newCost = Props.newCost;
  var check = Props.check;
  var onCheckCost = Props.onCheckCost;
  var onChangePrice = Props.onChangePrice;
  var onChangeDeliveryCost = Props.onChangeDeliveryCost;
  var onChangeWorkingCost = Props.onChangeWorkingCost;
  var onChangeEffectiveDate = Props.onChangeEffectiveDate;
  var onChangeRawCost = Props.onChangeRawCost;
  var onChangeContractType = Props.onChangeContractType;
  var handleOnChangeType = function (e) {
    var newType = e.target.value;
    var t = CustomHooks.Costs.contractType_decode(newType);
    if (t.TAG === /* Ok */0) {
      return Curry._1(onChangeContractType, t._0);
    }
    
  };
  return React.createElement("li", {
              className: "grid grid-cols-14-admin-cost text-gray-700"
            }, React.createElement("div", {
                  className: "h-full flex flex-col px-4 py-2"
                }, React.createElement(Checkbox.make, {
                      id: "checkbox-" + cost.sku,
                      checked: Curry._1(check, cost.sku),
                      onChange: Curry._1(onCheckCost, cost.sku)
                    })), React.createElement("div", {
                  className: "h-full flex flex-col px-4 py-2"
                }, React.createElement("span", {
                      className: "block mb-1"
                    }, cost.producerName)), React.createElement("div", {
                  className: "h-full flex flex-col px-4 py-2"
                }, React.createElement("span", {
                      className: "block text-gray-400"
                    }, String(cost.productId)), React.createElement("span", {
                      className: "block"
                    }, cost.sku)), React.createElement("div", {
                  className: "h-full flex flex-col px-4 py-2"
                }, React.createElement("span", {
                      className: "whitespace-nowrap"
                    }, cost.productName), React.createElement("span", {
                      className: "whitespace-nowrap"
                    }, cost.optionName)), React.createElement("div", {
                  className: "h-full flex flex-col px-4 py-2"
                }, React.createElement("span", {
                      className: "block"
                    }, formatDate(cost.effectiveDate))), React.createElement("div", {
                  className: "h-full flex flex-col px-4 py-2"
                }, React.createElement("span", {
                      className: "whitespace-nowrap text-center"
                    }, Belt_Option.mapWithDefault(cost.cost, "- / ", (function (cost) {
                            return Locale.Float.show(undefined, cost, 0) + "원 / ";
                          })), Belt_Option.mapWithDefault(cost.rawCost, "- / ", (function (cost) {
                            return Locale.Float.show(undefined, cost, 0) + "원 / ";
                          })), Belt_Option.mapWithDefault(cost.workingCost, "- / ", (function (cost) {
                            return Locale.Float.show(undefined, cost, 0) + "원 / ";
                          })), Belt_Option.mapWithDefault(cost.deliveryCost, "-", (function (cost) {
                            return Locale.Float.show(undefined, cost, 0) + "원";
                          })))), React.createElement("div", {
                  className: "h-full flex flex-col pl-8 pr-4 py-2"
                }, React.createElement("span", {
                      className: "block"
                    }, Locale.Float.show(undefined, cost.price, 0) + "원")), React.createElement("div", {
                  className: "h-full flex flex-col px-4 py-2 relative"
                }, React.createElement(Select_ContractType_Admin.make, {
                      contractType: newCost.contractType,
                      onChange: handleOnChangeType
                    })), React.createElement("div", {
                  className: "h-full flex flex-col px-4 py-2"
                }, React.createElement(Input.make, {
                      type_: "date",
                      name: "new-effective-date",
                      value: Belt_Option.mapWithDefault(newCost.effectiveDate, "", (function (d) {
                              return Format(d, "yyyy-MM-dd");
                            })),
                      onChange: (function (param) {
                          var newDate = param.target.valueAsDate;
                          return Curry._1(onChangeEffectiveDate, StartOfDay(newDate));
                        }),
                      size: /* Small */2,
                      error: undefined,
                      min: "2021-01-01"
                    })), React.createElement("div", {
                  className: "p-2 px-4 ml-2 align-top"
                }, React.createElement(Input.make, {
                      type_: "number",
                      name: "new-cost",
                      placeholder: "바이어판매가 입력",
                      value: Belt_Option.getWithDefault(newCost.price, ""),
                      onChange: (function (param) {
                          return Curry._1(onChangePrice, param.target.value);
                        }),
                      size: /* Small */2,
                      error: undefined
                    })), React.createElement("div", {
                  className: "p-2 pr-4 align-top"
                }, React.createElement("div", {
                      className: "bg-disabled-L3 border border-disabled-L1 text-sm rounded-lg h-8 items-center flex px-3"
                    }, React.createElement("span", {
                          className: "block"
                        }, Locale.Float.show(undefined, Belt_Option.getWithDefault(Belt_Option.flatMap(newCost.rawCost, Belt_Float.fromString), 0) + Belt_Option.getWithDefault(Belt_Option.flatMap(newCost.deliveryCost, Belt_Float.fromString), 0) + Belt_Option.getWithDefault(Belt_Option.flatMap(newCost.workingCost, Belt_Float.fromString), 0), 0)))), React.createElement("div", {
                  className: "p-2 pr-4 align-top"
                }, React.createElement(Input.make, {
                      type_: "number",
                      name: "new-cost",
                      placeholder: "원물원가 입력",
                      value: Belt_Option.getWithDefault(newCost.rawCost, ""),
                      onChange: (function (param) {
                          return Curry._1(onChangeRawCost, param.target.value);
                        }),
                      size: /* Small */2,
                      error: undefined
                    })), React.createElement("div", {
                  className: "p-2 pr-4 align-top"
                }, React.createElement(Input.make, {
                      type_: "number",
                      name: "new-cost",
                      placeholder: "포장작업비 입력",
                      value: Belt_Option.getWithDefault(newCost.workingCost, ""),
                      onChange: (function (param) {
                          return Curry._1(onChangeWorkingCost, param.target.value);
                        }),
                      size: /* Small */2,
                      error: undefined
                    })), React.createElement("div", {
                  className: "p-2 pr-4 align-top"
                }, React.createElement(Input.make, {
                      type_: "number",
                      name: "new-cost",
                      placeholder: "택배비 입력",
                      value: Belt_Option.getWithDefault(newCost.deliveryCost, ""),
                      onChange: (function (param) {
                          return Curry._1(onChangeDeliveryCost, param.target.value);
                        }),
                      size: /* Small */2,
                      error: undefined
                    })));
}

function Cost_Admin$Item$Table$Loading(Props) {
  return React.createElement("li", {
              className: "grid grid-cols-14-admin-cost text-gray-700"
            }, React.createElement("div", {
                  className: "h-full flex flex-col px-4 py-2"
                }, React.createElement(Skeleton.Box.make, {
                      className: "w-6"
                    })), React.createElement("div", {
                  className: "h-full flex flex-col px-4 py-2"
                }, React.createElement(Skeleton.Box.make, {
                      className: "w-2/3"
                    })), React.createElement("div", {
                  className: "h-full flex flex-col px-4 py-2"
                }, React.createElement(Skeleton.Box.make, {
                      className: "w-1/2"
                    }), React.createElement(Skeleton.Box.make, {
                      className: "w-2/3"
                    })), React.createElement("div", {
                  className: "h-full flex flex-col px-4 py-2"
                }, React.createElement(Skeleton.Box.make, {})), React.createElement("div", {
                  className: "h-full flex flex-col px-4 py-2"
                }, React.createElement(Skeleton.Box.make, {})), React.createElement("div", {
                  className: "h-full flex flex-col px-4 py-2"
                }, React.createElement(Skeleton.Box.make, {})), React.createElement("div", {
                  className: "h-full flex flex-col px-4 py-2"
                }, React.createElement(Skeleton.Box.make, {})), React.createElement("div", {
                  className: "p-2 pr-4 align-top"
                }, React.createElement(Skeleton.Box.make, {})));
}

var Loading = {
  make: Cost_Admin$Item$Table$Loading
};

var Table = {
  make: Cost_Admin$Item$Table,
  Loading: Loading
};

var Item = {
  Table: Table
};

function Cost_Admin(Props) {
  var cost = Props.cost;
  var newCost = Props.newCost;
  var check = Props.check;
  var onCheckCost = Props.onCheckCost;
  var onChangeEffectiveDate = Props.onChangeEffectiveDate;
  var onChangePrice = Props.onChangePrice;
  var onChangeRawCost = Props.onChangeRawCost;
  var onChangeDeliveryCost = Props.onChangeDeliveryCost;
  var onChangeWorkingCost = Props.onChangeWorkingCost;
  var onChangeContractType = Props.onChangeContractType;
  return React.createElement(Cost_Admin$Item$Table, {
              cost: cost,
              newCost: newCost,
              check: check,
              onCheckCost: onCheckCost,
              onChangePrice: onChangePrice,
              onChangeDeliveryCost: onChangeDeliveryCost,
              onChangeWorkingCost: onChangeWorkingCost,
              onChangeEffectiveDate: onChangeEffectiveDate,
              onChangeRawCost: onChangeRawCost,
              onChangeContractType: onChangeContractType
            });
}

var make = Cost_Admin;

export {
  formatDate ,
  Item ,
  make ,
  
}
/* Input Not a pure module */
