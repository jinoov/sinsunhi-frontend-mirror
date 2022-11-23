// Generated by ReScript, PLEASE EDIT WITH CARE

import * as React from "react";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as ReactRelay from "react-relay";
import * as Js_null_undefined from "rescript/lib/es6/js_null_undefined.js";
import * as RescriptRelay_Internal from "rescript-relay/src/RescriptRelay_Internal.mjs";
import * as PDPNormalDeliveryGuideBuyer_fragment_graphql from "../../../../__generated__/PDPNormalDeliveryGuideBuyer_fragment_graphql.mjs";

function use(fRef) {
  var data = ReactRelay.useFragment(PDPNormalDeliveryGuideBuyer_fragment_graphql.node, fRef);
  return RescriptRelay_Internal.internal_useConvertedValue(PDPNormalDeliveryGuideBuyer_fragment_graphql.Internal.convertFragment, data);
}

function useOpt(opt_fRef) {
  var fr = opt_fRef !== undefined ? Caml_option.some(Caml_option.valFromOption(opt_fRef)) : undefined;
  var nullableFragmentData = ReactRelay.useFragment(PDPNormalDeliveryGuideBuyer_fragment_graphql.node, fr !== undefined ? Js_null_undefined.fromOption(Caml_option.some(Caml_option.valFromOption(fr))) : null);
  var data = (nullableFragmentData == null) ? undefined : Caml_option.some(nullableFragmentData);
  return RescriptRelay_Internal.internal_useConvertedValue((function (rawFragment) {
                if (rawFragment !== undefined) {
                  return PDPNormalDeliveryGuideBuyer_fragment_graphql.Internal.convertFragment(rawFragment);
                }
                
              }), data);
}

var Fragment = {
  Types: undefined,
  Operation: undefined,
  use: use,
  useOpt: useOpt
};

function PDP_Normal_DeliveryGuide_Buyer$PC(Props) {
  var query = Props.query;
  var match = use(query);
  var isCourierAvailable;
  if (typeof match === "object") {
    var variant = match.NAME;
    isCourierAvailable = variant === "QuotableProduct" || variant === "NormalProduct" ? match.VAL.isCourierAvailable : undefined;
  } else {
    isCourierAvailable = undefined;
  }
  var tmp;
  var exit = 0;
  if (isCourierAvailable !== undefined && isCourierAvailable) {
    tmp = React.createElement(React.Fragment, undefined, React.createElement("div", {
              className: "flex"
            }, React.createElement("span", {
                  className: "text-text-L2"
                }, "・"), React.createElement("div", {
                  className: "flex flex-col text-gray-800"
                }, React.createElement("span", undefined, React.createElement("span", {
                          className: "text-green-500"
                        }, "원물, 대량구매는 1:1 채팅"), "을 이용해주세요"))), React.createElement("div", {
              className: "flex mt-2"
            }, React.createElement("span", {
                  className: "text-gray-500"
                }, "・"), React.createElement("div", {
                  className: "flex flex-col text-gray-800"
                }, React.createElement("span", undefined, "일부 상품은 ", React.createElement("span", {
                          className: "font-bold"
                        }, "배송비가 별도로 부과"), "됩니다."))));
  } else {
    exit = 1;
  }
  if (exit === 1) {
    tmp = React.createElement("div", {
          className: "flex"
        }, React.createElement("span", {
              className: "text-text-L2"
            }, "・"), React.createElement("div", {
              className: "flex flex-col text-gray-800"
            }, React.createElement("span", undefined, React.createElement("span", {
                      className: "font-bold"
                    }, "화물 배송"), " 또는 ", React.createElement("span", {
                      className: "font-bold"
                    }, "직접 수령 상품"), "입니다")));
  }
  return React.createElement("div", {
              className: "w-full"
            }, React.createElement("h1", {
                  className: "text-base font-bold text-text-L1"
                }, "배송 안내"), React.createElement("div", {
                  className: "mt-4 w-full bg-gray-50 p-4 rounded-xl"
                }, tmp));
}

var PC = {
  make: PDP_Normal_DeliveryGuide_Buyer$PC
};

function PDP_Normal_DeliveryGuide_Buyer$MO(Props) {
  var query = Props.query;
  var match = use(query);
  var isCourierAvailable;
  if (typeof match === "object") {
    var variant = match.NAME;
    isCourierAvailable = variant === "QuotableProduct" || variant === "NormalProduct" ? match.VAL.isCourierAvailable : undefined;
  } else {
    isCourierAvailable = undefined;
  }
  var tmp;
  var exit = 0;
  if (isCourierAvailable !== undefined && isCourierAvailable) {
    tmp = React.createElement(React.Fragment, undefined, React.createElement("div", {
              className: "flex"
            }, React.createElement("span", {
                  className: "text-text-L2"
                }, "・"), React.createElement("div", {
                  className: "flex flex-col text-text-L1"
                }, React.createElement("span", undefined, React.createElement("span", {
                          className: "text-primary"
                        }, "원물, 대량구매는 1:1 채팅"), "을 이용해주세요"))), React.createElement("div", {
              className: "flex"
            }, React.createElement("span", {
                  className: "text-text-L2"
                }, "・"), React.createElement("div", {
                  className: "flex flex-col text-text-L1"
                }, React.createElement("span", undefined, "일부 상품은 ", React.createElement("span", {
                          className: "font-bold"
                        }, "배송비가 별도로 부과"), "됩니다."))));
  } else {
    exit = 1;
  }
  if (exit === 1) {
    tmp = React.createElement("div", {
          className: "flex"
        }, React.createElement("span", {
              className: "text-text-L2"
            }, "・"), React.createElement("div", {
              className: "flex flex-col text-text-L1"
            }, React.createElement("span", undefined, React.createElement("span", {
                      className: "font-bold"
                    }, "화물 배송"), " 또는 ", React.createElement("span", {
                      className: "font-bold"
                    }, "직접 수령 상품"), "입니다")));
  }
  return React.createElement("div", {
              className: "w-full"
            }, React.createElement("h1", {
                  className: "text-base font-bold text-text-L1"
                }, "배송 안내"), React.createElement("div", {
                  className: "mt-4 w-full bg-surface p-4 rounded-xl flex flex-col gap-2"
                }, tmp));
}

var MO = {
  make: PDP_Normal_DeliveryGuide_Buyer$MO
};

export {
  Fragment ,
  PC ,
  MO ,
}
/* react Not a pure module */
