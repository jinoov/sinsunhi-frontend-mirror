// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Cx from "rescript-classnames/src/Cx.mjs";
import * as React from "react";
import * as Locale from "../utils/Locale.mjs";
import * as Skeleton from "./Skeleton.mjs";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as CustomHooks from "../utils/CustomHooks.mjs";
import * as ReactHookForm from "react-hook-form";
import * as Js_null_undefined from "rescript/lib/es6/js_null_undefined.js";
import * as Hooks from "react-relay/hooks";
import * as Web_Order_Buyer_Form from "./Web_Order_Buyer_Form.mjs";
import * as RescriptRelay_Internal from "rescript-relay/src/RescriptRelay_Internal.mjs";
import * as WebOrderPaymentInfoBuyerFragment_graphql from "../__generated__/WebOrderPaymentInfoBuyerFragment_graphql.mjs";

function use(fRef) {
  var data = Hooks.useFragment(WebOrderPaymentInfoBuyerFragment_graphql.node, fRef);
  return RescriptRelay_Internal.internal_useConvertedValue(WebOrderPaymentInfoBuyerFragment_graphql.Internal.convertFragment, data);
}

function useOpt(opt_fRef) {
  var fr = opt_fRef !== undefined ? Caml_option.some(Caml_option.valFromOption(opt_fRef)) : undefined;
  var nullableFragmentData = Hooks.useFragment(WebOrderPaymentInfoBuyerFragment_graphql.node, fr !== undefined ? Js_null_undefined.fromOption(Caml_option.some(Caml_option.valFromOption(fr))) : null);
  var data = (nullableFragmentData == null) ? undefined : Caml_option.some(nullableFragmentData);
  return RescriptRelay_Internal.internal_useConvertedValue((function (rawFragment) {
                if (rawFragment !== undefined) {
                  return WebOrderPaymentInfoBuyerFragment_graphql.Internal.convertFragment(rawFragment);
                }
                
              }), data);
}

var Fragment = {
  Types: undefined,
  use: use,
  useOpt: useOpt
};

function Web_Order_Payment_Info_Buyer$PlaceHolder(Props) {
  return React.createElement("div", {
              className: "rounded-sm bg-white w-full p-7"
            }, React.createElement("span", {
                  className: "text-lg xl:text-xl text-enabled-L1 font-bold"
                }, "결제 정보"), React.createElement("ul", {
                  className: "text-sm flex flex-col gap-4 py-7 border border-x-0 border-t-0 border-div-border-L2"
                }, React.createElement("li", {
                      key: "product-price",
                      className: "flex justify-between items-center"
                    }, React.createElement("span", {
                          className: "text-text-L2"
                        }, "총 상품금액"), React.createElement(Skeleton.Box.make, {
                          className: "w-20"
                        })), React.createElement("li", {
                      key: "delivery-cost",
                      className: "flex justify-between items-center"
                    }, React.createElement("span", {
                          className: "text-text-L2"
                        }, "배송비"), React.createElement(Skeleton.Box.make, {
                          className: "w-20"
                        })), React.createElement("li", {
                      key: "total-price",
                      className: "flex justify-between items-center"
                    }, React.createElement("span", {
                          className: "text-text-L2"
                        }, "총 결제금액"), React.createElement(Skeleton.Box.make, {
                          className: "w-24"
                        }))), React.createElement("div", {
                  className: "mt-7 mb-10 flex justify-center items-center text-text-L1"
                }, React.createElement(Skeleton.Box.make, {
                      className: "w-44"
                    })), React.createElement(Skeleton.Box.make, {
                  className: "w-full min-h-[3.5rem] rounded-xl"
                }));
}

var PlaceHolder = {
  make: Web_Order_Payment_Info_Buyer$PlaceHolder
};

function Web_Order_Payment_Info_Buyer(Props) {
  var query = Props.query;
  var quantity = Props.quantity;
  var fragments = use(query);
  var deliveryType = ReactHookForm.useWatch({
        name: Web_Order_Buyer_Form.names.deliveryType
      });
  var match = fragments.node;
  var match$1;
  if (match !== undefined) {
    var deliveryCost = match.productOptionCost.deliveryCost;
    if (deliveryType !== undefined) {
      var price = match.price;
      var decode = Web_Order_Buyer_Form.deliveryType_decode(deliveryType);
      if (decode.TAG === /* Ok */0) {
        var decode$1 = decode._0;
        match$1 = decode$1 === "PARCEL" ? [
            Math.imul(Belt_Option.getWithDefault(price, 0) - deliveryCost | 0, quantity),
            Math.imul(deliveryCost, quantity),
            false
          ] : (
            decode$1 === "SELF" ? [
                Math.imul(Belt_Option.getWithDefault(price, 0), quantity),
                0,
                false
              ] : [
                Math.imul(Belt_Option.getWithDefault(price, 0), quantity),
                0,
                true
              ]
          );
      } else {
        match$1 = [
          0,
          0,
          false
        ];
      }
    } else {
      match$1 = [
        0,
        Math.imul(deliveryCost, quantity),
        false
      ];
    }
  } else {
    match$1 = [
      0,
      0,
      false
    ];
  }
  var totalDeliveryCost = match$1[1];
  var totalProductPrice = match$1[0];
  var match$2 = CustomHooks.Scroll.useScrollObserver({
        TAG: /* Px */1,
        _0: 50.0
      }, undefined);
  var scrollY = match$2[3];
  var match$3 = React.useState(function () {
        return false;
      });
  var setIsFixedOff = match$3[1];
  var match$4 = Belt_Option.mapWithDefault(Caml_option.nullable_to_opt(document.getElementsByTagName("body").item(0)), [
        0,
        0
      ], (function (a) {
          return [
                  a.scrollHeight,
                  window.innerHeight
                ];
        }));
  var innerHeight = match$4[1];
  var scrollHeight = match$4[0];
  React.useEffect((function () {
          setIsFixedOff(function (param) {
                return ((scrollHeight - innerHeight | 0) - (scrollY | 0) | 0) < 140;
              });
          
        }), [
        scrollHeight,
        innerHeight,
        scrollY
      ]);
  return React.createElement("div", {
              className: Cx.cx([
                    "rounded-sm bg-white p-7 w-full xl:w-fit",
                    match$3[0] ? "xl:absolute xl:bottom-0" : "xl:fixed"
                  ])
            }, React.createElement("span", {
                  className: "text-lg xl:text-xl text-enabled-L1 font-bold"
                }, "결제 정보"), React.createElement("ul", {
                  className: "text-sm flex flex-col gap-5 py-7 border border-x-0 border-t-0 border-div-border-L2 xl:w-[440px]"
                }, React.createElement("li", {
                      key: "product-price",
                      className: "flex justify-between items-center"
                    }, React.createElement("span", {
                          className: "text-text-L2"
                        }, "총 상품금액"), React.createElement("span", {
                          className: "text-base font-bold xl:text-sm xl:font-normal"
                        }, Locale.Int.show(undefined, totalProductPrice) + "원")), React.createElement("li", {
                      key: "delivery-cost",
                      className: "flex justify-between items-center"
                    }, React.createElement("span", {
                          className: "text-text-L2"
                        }, "배송비"), React.createElement("span", {
                          className: "text-base font-bold xl:text-sm xl:font-normal"
                        }, match$1[2] ? "협의" : Locale.Int.show(undefined, totalDeliveryCost) + "원")), React.createElement("li", {
                      key: "total-price",
                      className: "flex justify-between items-center"
                    }, React.createElement("span", {
                          className: "text-text-L2"
                        }, "총 결제금액"), React.createElement("span", {
                          className: "text-xl xl:text-lg text-primary font-bold"
                        }, Locale.Int.show(undefined, totalProductPrice + totalDeliveryCost | 0) + "원"))), React.createElement("div", {
                  className: "mt-7 mb-10 text-center text-text-L1"
                }, React.createElement("span", undefined, "주문 내용을 확인했으며, 정보 제공에 동의합니다.")), React.createElement("button", {
                  className: "w-full h-14 flex justify-center items-center bg-primary text-lg text-white rounded-xl",
                  type: "submit"
                }, "결제하기"));
}

var Form;

var make = Web_Order_Payment_Info_Buyer;

export {
  Form ,
  Fragment ,
  PlaceHolder ,
  make ,
  
}
/* react Not a pure module */