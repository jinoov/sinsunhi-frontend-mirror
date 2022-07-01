// Generated by ReScript, PLEASE EDIT WITH CARE

import * as React from "react";
import * as Locale from "../../../utils/Locale.mjs";
import * as Spinbox from "../../../components/common/Spinbox.mjs";
import * as Belt_Array from "rescript/lib/es6/belt_Array.js";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as Js_null_undefined from "rescript/lib/es6/js_null_undefined.js";
import * as Hooks from "react-relay/hooks";
import * as RescriptRelay_Internal from "rescript-relay/src/RescriptRelay_Internal.mjs";
import * as PDPProductNormalQuantityInputBuyer_graphql from "../../../__generated__/PDPProductNormalQuantityInputBuyer_graphql.mjs";

function use(fRef) {
  var data = Hooks.useFragment(PDPProductNormalQuantityInputBuyer_graphql.node, fRef);
  return RescriptRelay_Internal.internal_useConvertedValue(PDPProductNormalQuantityInputBuyer_graphql.Internal.convertFragment, data);
}

function useOpt(opt_fRef) {
  var fr = opt_fRef !== undefined ? Caml_option.some(Caml_option.valFromOption(opt_fRef)) : undefined;
  var nullableFragmentData = Hooks.useFragment(PDPProductNormalQuantityInputBuyer_graphql.node, fr !== undefined ? Js_null_undefined.fromOption(Caml_option.some(Caml_option.valFromOption(fr))) : null);
  var data = (nullableFragmentData == null) ? undefined : Caml_option.some(nullableFragmentData);
  return RescriptRelay_Internal.internal_useConvertedValue((function (rawFragment) {
                if (rawFragment !== undefined) {
                  return PDPProductNormalQuantityInputBuyer_graphql.Internal.convertFragment(rawFragment);
                }
                
              }), data);
}

var Fragment = {
  Types: undefined,
  use: use,
  useOpt: useOpt
};

function PDP_Product_Normal_QuantityInput_Buyer$PC(Props) {
  var query = Props.query;
  var selectedItem = Props.selectedItem;
  var quantity = Props.quantity;
  var setQuantity = Props.setQuantity;
  var match = use(query);
  if (selectedItem === undefined) {
    return null;
  }
  var selectedSku = Belt_Array.getBy(match.productOptions.edges, (function (param) {
          return param.node.stockSku === selectedItem.stockSku;
        }));
  var totalProductPrice = Belt_Option.flatMap(selectedSku, (function (selectedSku$p) {
          return Belt_Option.map(selectedSku$p.node.price, (function (price) {
                        var deliveryCost = selectedSku$p.node.productOptionCost.deliveryCost;
                        return Math.imul(price - deliveryCost | 0, quantity);
                      }));
        }));
  return React.createElement("div", {
              className: "pt-6 flex items-center justify-between"
            }, React.createElement(Spinbox.make, {
                  value: quantity,
                  setValue: setQuantity
                }), React.createElement("div", {
                  className: "flex flex-col"
                }, React.createElement("span", {
                      className: "mt-1 text-gray-800 text-right text-[15px]"
                    }, React.createElement("span", undefined, selectedItem.label)), React.createElement("span", {
                      className: "mt-1 text-gray-800 font-bold text-xl text-right"
                    }, Belt_Option.mapWithDefault(totalProductPrice, "", (function (totalProductPrice$p) {
                            return Locale.Float.show(undefined, totalProductPrice$p, 0) + "원";
                          })))));
}

var PC = {
  make: PDP_Product_Normal_QuantityInput_Buyer$PC
};

function PDP_Product_Normal_QuantityInput_Buyer$MO(Props) {
  var query = Props.query;
  var selectedItem = Props.selectedItem;
  var quantity = Props.quantity;
  var setQuantity = Props.setQuantity;
  var match = use(query);
  if (selectedItem === undefined) {
    return null;
  }
  var selectedSku = Belt_Array.getBy(match.productOptions.edges, (function (param) {
          return param.node.stockSku === selectedItem.stockSku;
        }));
  var totalProductPrice = Belt_Option.flatMap(selectedSku, (function (selectedSku$p) {
          return Belt_Option.map(selectedSku$p.node.price, (function (price) {
                        var deliveryCost = selectedSku$p.node.productOptionCost.deliveryCost;
                        return Math.imul(price - deliveryCost | 0, quantity);
                      }));
        }));
  return React.createElement("section", {
              className: "py-8 flex items-center justify-between"
            }, React.createElement(Spinbox.make, {
                  value: quantity,
                  setValue: setQuantity
                }), React.createElement("div", {
                  className: "flex flex-col"
                }, React.createElement("span", {
                      className: "mt-1 text-gray-800 text-right text-[15px]"
                    }, React.createElement("span", undefined, selectedItem.label)), React.createElement("span", {
                      className: "mt-1 text-gray-800 font-bold text-xl text-right"
                    }, Belt_Option.mapWithDefault(totalProductPrice, "", (function (totalProductPrice$p) {
                            return Locale.Float.show(undefined, totalProductPrice$p, 0) + "원";
                          })))));
}

var MO = {
  make: PDP_Product_Normal_QuantityInput_Buyer$MO
};

export {
  Fragment ,
  PC ,
  MO ,
  
}
/* react Not a pure module */
