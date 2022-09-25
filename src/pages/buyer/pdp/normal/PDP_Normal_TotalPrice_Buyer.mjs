// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Curry from "rescript/lib/es6/curry.js";
import * as React from "react";
import * as Locale from "../../../../utils/Locale.mjs";
import * as Belt_Array from "rescript/lib/es6/belt_Array.js";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as CustomHooks from "../../../../utils/CustomHooks.mjs";
import * as ReactRelay from "react-relay";
import * as Belt_MapString from "rescript/lib/es6/belt_MapString.js";
import * as Js_null_undefined from "rescript/lib/es6/js_null_undefined.js";
import * as RescriptRelay_Internal from "rescript-relay/src/RescriptRelay_Internal.mjs";
import * as PDPNormalTotalPriceBuyerFragment_graphql from "../../../../__generated__/PDPNormalTotalPriceBuyerFragment_graphql.mjs";

function use(fRef) {
  var data = ReactRelay.useFragment(PDPNormalTotalPriceBuyerFragment_graphql.node, fRef);
  return RescriptRelay_Internal.internal_useConvertedValue(PDPNormalTotalPriceBuyerFragment_graphql.Internal.convertFragment, data);
}

function useOpt(opt_fRef) {
  var fr = opt_fRef !== undefined ? Caml_option.some(Caml_option.valFromOption(opt_fRef)) : undefined;
  var nullableFragmentData = ReactRelay.useFragment(PDPNormalTotalPriceBuyerFragment_graphql.node, fr !== undefined ? Js_null_undefined.fromOption(Caml_option.some(Caml_option.valFromOption(fr))) : null);
  var data = (nullableFragmentData == null) ? undefined : Caml_option.some(nullableFragmentData);
  return RescriptRelay_Internal.internal_useConvertedValue((function (rawFragment) {
                if (rawFragment !== undefined) {
                  return PDPNormalTotalPriceBuyerFragment_graphql.Internal.convertFragment(rawFragment);
                }
                
              }), data);
}

var Fragment_productStatus_decode = PDPNormalTotalPriceBuyerFragment_graphql.Utils.productStatus_decode;

var Fragment_productStatus_fromString = PDPNormalTotalPriceBuyerFragment_graphql.Utils.productStatus_fromString;

var Fragment = {
  productStatus_decode: Fragment_productStatus_decode,
  productStatus_fromString: Fragment_productStatus_fromString,
  Types: undefined,
  Operation: undefined,
  use: use,
  useOpt: useOpt
};

function makeOptionPrice(price, deliveryCost, isFreeShipping) {
  if (isFreeShipping) {
    return price;
  } else {
    return price - deliveryCost | 0;
  }
}

function makeOptionDeliveryCost(deliveryCost, isFreeShipping) {
  if (isFreeShipping) {
    return 0;
  } else {
    return deliveryCost;
  }
}

function sumPriceObjs(priceObjs) {
  return Belt_Array.reduce(priceObjs, [
              0,
              0
            ], (function (param, param$1) {
                var quantity = param$1.quantity;
                var isFreeShipping = param$1.isFreeShipping;
                var deliveryCost = param$1.deliveryCost;
                var optionPrice = Math.imul(makeOptionPrice(param$1.price, deliveryCost, isFreeShipping), quantity);
                var deliveryPrice = Math.imul(isFreeShipping ? 0 : deliveryCost, quantity);
                return [
                        param[0] + optionPrice | 0,
                        param[1] + deliveryPrice | 0
                      ];
              }));
}

function PDP_Normal_TotalPrice_Buyer$PC(props) {
  var withDeliveryCost = props.withDeliveryCost;
  var withDeliveryCost$1 = withDeliveryCost !== undefined ? withDeliveryCost : true;
  var user = Curry._1(CustomHooks.User.Buyer.use2, undefined);
  var match = use(props.query);
  var productOptions = match.productOptions;
  var makePriceObjs = function (options) {
    var makePriceObj = function (param) {
      var quantity = param[1];
      var optionId = param[0];
      return Belt_Option.flatMap(productOptions, (function (param) {
                    return Belt_Option.flatMap(Belt_Array.getBy(param.edges, (function (param) {
                                      return param.node.id === optionId;
                                    })), (function (param) {
                                  var match = param.node;
                                  var deliveryCost = match.productOptionCost.deliveryCost;
                                  var isFreeShipping = match.isFreeShipping;
                                  return Belt_Option.map(match.price, (function (price$p) {
                                                return {
                                                        price: price$p,
                                                        deliveryCost: deliveryCost,
                                                        isFreeShipping: isFreeShipping,
                                                        quantity: quantity
                                                      };
                                              }));
                                }));
                  }));
    };
    return Belt_Array.keepMap(Belt_MapString.toArray(options), makePriceObj);
  };
  var match$1 = makePriceObjs(props.selectedOptions);
  var priceLabelStatus = user === 0 ? /* Loading */0 : (
      match.status === "SOLDOUT" ? /* Soldout */2 : (
          typeof user === "number" ? /* Unauthorized */1 : (
              match$1.length !== 0 ? /* Available */({
                    _0: match$1
                  }) : /* NoOption */3
            )
        )
    );
  var tmp;
  if (typeof priceLabelStatus === "number") {
    tmp = null;
  } else {
    var match$2 = sumPriceObjs(priceLabelStatus._0);
    var totalPrice = match$2[0] + match$2[1] | 0;
    tmp = React.createElement("span", {
          className: "ml-2 text-green-500 font-bold text-2xl"
        }, "" + Locale.Float.show(undefined, totalPrice, 0) + "원");
  }
  var tmp$1;
  if (typeof priceLabelStatus === "number") {
    switch (priceLabelStatus) {
      case /* Loading */0 :
          tmp$1 = React.createElement("span", {
                className: "text-gray-500 text-sm"
              }, "");
          break;
      case /* Unauthorized */1 :
          tmp$1 = React.createElement("span", {
                className: "text-green-500 text-sm"
              }, "로그인을 하시면 총 결제 금액을 보실 수 있습니다");
          break;
      case /* Soldout */2 :
          tmp$1 = React.createElement("span", {
                className: "text-gray-500 text-sm"
              }, "품절된 상품으로 총 결제 금액을 보실 수 없습니다");
          break;
      case /* NoOption */3 :
          tmp$1 = React.createElement("span", {
                className: "text-green-500 text-sm"
              }, "단품을 선택하시면 총 결제 금액을 보실 수 있습니다");
          break;
      
    }
  } else {
    var match$3 = sumPriceObjs(priceLabelStatus._0);
    var totalDeliveryCost = match$3[1];
    var deliveryCostLabel = withDeliveryCost$1 ? (
        totalDeliveryCost !== 0 ? "배송비 " + Locale.Float.show(undefined, totalDeliveryCost, 0) + "원 포함" : "배송비 무료"
      ) : "택배 배송비 포함 금액(배송방식에 따라 변동됨)";
    tmp$1 = React.createElement("span", {
          className: "text-gray-600"
        }, deliveryCostLabel);
  }
  return React.createElement("div", {
              className: "py-7 px-6"
            }, React.createElement("div", {
                  className: "flex justify-between"
                }, React.createElement("span", {
                      className: "text-lg font-bold text-gray-800"
                    }, "총 결제 금액"), tmp), tmp$1);
}

var PC = {
  make: PDP_Normal_TotalPrice_Buyer$PC
};

function PDP_Normal_TotalPrice_Buyer$MO(props) {
  var withDeliveryCost = props.withDeliveryCost;
  var withDeliveryCost$1 = withDeliveryCost !== undefined ? withDeliveryCost : true;
  var user = Curry._1(CustomHooks.User.Buyer.use2, undefined);
  var match = use(props.query);
  var productOptions = match.productOptions;
  var makePriceObjs = function (options) {
    var makePriceObj = function (param) {
      var quantity = param[1];
      var optionId = param[0];
      return Belt_Option.flatMap(productOptions, (function (param) {
                    return Belt_Option.flatMap(Belt_Array.getBy(param.edges, (function (param) {
                                      return param.node.id === optionId;
                                    })), (function (param) {
                                  var match = param.node;
                                  var deliveryCost = match.productOptionCost.deliveryCost;
                                  var isFreeShipping = match.isFreeShipping;
                                  return Belt_Option.map(match.price, (function (price$p) {
                                                return {
                                                        price: price$p,
                                                        deliveryCost: deliveryCost,
                                                        isFreeShipping: isFreeShipping,
                                                        quantity: quantity
                                                      };
                                              }));
                                }));
                  }));
    };
    return Belt_Array.keepMap(Belt_MapString.toArray(options), makePriceObj);
  };
  var match$1 = makePriceObjs(props.selectedOptions);
  var priceLabelStatus = user === 0 ? /* Loading */0 : (
      match.status === "SOLDOUT" ? /* Soldout */2 : (
          typeof user === "number" ? /* Unauthorized */1 : (
              match$1.length !== 0 ? /* Available */({
                    _0: match$1
                  }) : /* NoOption */3
            )
        )
    );
  var tmp;
  if (typeof priceLabelStatus === "number") {
    tmp = null;
  } else {
    var match$2 = sumPriceObjs(priceLabelStatus._0);
    var totalPrice = match$2[0] + match$2[1] | 0;
    tmp = React.createElement("span", {
          className: "text-green-500 font-bold text-[22px]"
        }, "" + Locale.Float.show(undefined, totalPrice, 0) + "원");
  }
  var tmp$1;
  if (typeof priceLabelStatus === "number") {
    switch (priceLabelStatus) {
      case /* Loading */0 :
          var captionStyle = "text-[13px] text-gray-500";
          tmp$1 = React.createElement("span", {
                className: captionStyle
              }, "");
          break;
      case /* Unauthorized */1 :
          var captionStyle$1 = "text-[13px] text-green-500";
          tmp$1 = React.createElement("span", {
                className: captionStyle$1
              }, "로그인을 하시면 총 결제 금액을 보실 수 있습니다");
          break;
      case /* Soldout */2 :
          var captionStyle$2 = "text-[13px] text-gray-500";
          tmp$1 = React.createElement("span", {
                className: captionStyle$2
              }, "품절된 상품으로 총 결제 금액을 보실 수 없습니다");
          break;
      case /* NoOption */3 :
          var captionStyle$3 = "text-[13px] text-green-500";
          tmp$1 = React.createElement("span", {
                className: captionStyle$3
              }, "단품을 선택하시면 총 결제 금액을 보실 수 있습니다");
          break;
      
    }
  } else {
    var match$3 = sumPriceObjs(priceLabelStatus._0);
    var totalDeliveryCost = match$3[1];
    var deliveryCostLabel = withDeliveryCost$1 ? (
        totalDeliveryCost !== 0 ? "배송비 " + Locale.Float.show(undefined, totalDeliveryCost, 0) + "원 포함" : "배송비 무료"
      ) : "택배 배송비 포함 금액(배송방식에 따라 변동됨)";
    var captionStyle$4 = "text-[13px] text-gray-600";
    tmp$1 = React.createElement("span", {
          className: captionStyle$4
        }, deliveryCostLabel);
  }
  return React.createElement("div", undefined, React.createElement("div", {
                  className: "flex justify-between"
                }, React.createElement("h1", {
                      className: "text-base font-bold text-text-L1"
                    }, "총 결제 금액"), tmp), tmp$1);
}

var MO = {
  make: PDP_Normal_TotalPrice_Buyer$MO
};

export {
  Fragment ,
  makeOptionPrice ,
  makeOptionDeliveryCost ,
  sumPriceObjs ,
  PC ,
  MO ,
}
/* react Not a pure module */
