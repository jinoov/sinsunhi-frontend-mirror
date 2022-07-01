// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Spice from "@greenlabs/ppx-spice/src/rescript/Spice.mjs";
import * as React from "react";
import * as Js_dict from "rescript/lib/es6/js_dict.js";
import * as Js_json from "rescript/lib/es6/js_json.js";
import * as Belt_Int from "rescript/lib/es6/belt_Int.js";
import Link from "next/link";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as Router from "next/router";
import * as ReactDialog from "@radix-ui/react-dialog";

function tossPaymentsErrorCode_encode(v) {
  switch (v) {
    case /* PAY_PROCESS_CANCELED */0 :
        return "PAY_PROCESS_CANCELED";
    case /* PAY_PROCESS_ABORTED */1 :
        return "PAY_PROCESS_ABORTED";
    case /* REJECT_CARD_COMPANY */2 :
        return "REJECT_CARD_COMPANY";
    
  }
}

function tossPaymentsErrorCode_decode(v) {
  var str = Js_json.classify(v);
  if (typeof str === "number") {
    return Spice.error(undefined, "Not a JSONString", v);
  }
  if (str.TAG !== /* JSONString */0) {
    return Spice.error(undefined, "Not a JSONString", v);
  }
  var str$1 = str._0;
  if ("PAY_PROCESS_CANCELED" === str$1) {
    return {
            TAG: /* Ok */0,
            _0: /* PAY_PROCESS_CANCELED */0
          };
  } else if ("PAY_PROCESS_ABORTED" === str$1) {
    return {
            TAG: /* Ok */0,
            _0: /* PAY_PROCESS_ABORTED */1
          };
  } else if ("REJECT_CARD_COMPANY" === str$1) {
    return {
            TAG: /* Ok */0,
            _0: /* REJECT_CARD_COMPANY */2
          };
  } else {
    return Spice.error(undefined, "Not matched", v);
  }
}

function codeToString(code) {
  switch (code) {
    case /* PAY_PROCESS_CANCELED */0 :
        return "사용자에 의해 결제가 취소되었습니다.";
    case /* PAY_PROCESS_ABORTED */1 :
        return "결제 진행 중 승인에 실패하여 결제가 중단되었습니다.";
    case /* REJECT_CARD_COMPANY */2 :
        return "결제 승인이 거절되었습니다.";
    
  }
}

function TossPaymentsFail_Buyer$ErrorDialog(Props) {
  var children = Props.children;
  var show = Props.show;
  var href = Props.href;
  return React.createElement(ReactDialog.Root, {
              children: React.createElement(ReactDialog.Portal, {
                    children: null
                  }, React.createElement(ReactDialog.Overlay, {
                        className: "dialog-overlay"
                      }), React.createElement(ReactDialog.Content, {
                        children: null,
                        className: "dialog-content p-7 bg-white rounded-xl w-[480px] flex flex-col items-center justify-center"
                      }, children, React.createElement(Link, {
                            href: href,
                            children: React.createElement("a", {
                                  className: "flex w-full xl:w-1/2 h-13 bg-surface rounded-lg justify-center items-center text-lg cursor-pointer text-enabled-L1"
                                }, "닫기")
                          }))),
              open: show
            });
}

var ErrorDialog = {
  make: TossPaymentsFail_Buyer$ErrorDialog
};

function TossPaymentsFail_Buyer(Props) {
  var router = Router.useRouter();
  var match = React.useState(function () {
        return "잘못된 접근";
      });
  var setErrMsg = match[1];
  var match$1 = React.useState(function () {
        return false;
      });
  var setShowErr = match$1[1];
  var match$2 = React.useState(function () {
        return "/buyer";
      });
  var setRedirect = match$2[1];
  React.useEffect((function () {
          var params = new URLSearchParams(router.query);
          var code = Belt_Option.map(Caml_option.nullable_to_opt(params.get("code")), tossPaymentsErrorCode_decode);
          var productId = Js_dict.get(router.query, "product-id");
          var productOptionId = Js_dict.get(router.query, "product-option-id");
          var quantity = Belt_Option.flatMap(Js_dict.get(router.query, "quantity"), Belt_Int.fromString);
          var exit = 0;
          if (productId !== undefined && productOptionId !== undefined && quantity !== undefined) {
            setRedirect(function (param) {
                  return "/buyer/web-order/" + productId + "/" + productOptionId + "?quantity=" + String(quantity);
                });
          } else {
            exit = 1;
          }
          if (exit === 1) {
            setRedirect(function (param) {
                  return "/buyer/transactions";
                });
          }
          var exit$1 = 0;
          if (code !== undefined && code.TAG === /* Ok */0) {
            var decode$p = code._0;
            setErrMsg(function (param) {
                  return codeToString(decode$p);
                });
            setShowErr(function (param) {
                  return true;
                });
          } else {
            exit$1 = 1;
          }
          if (exit$1 === 1) {
            setShowErr(function (param) {
                  return true;
                });
          }
          
        }), [router.query]);
  return React.createElement(TossPaymentsFail_Buyer$ErrorDialog, {
              children: React.createElement("div", {
                    className: "flex flex-col items-center justify-center"
                  }, React.createElement("span", undefined, "결제가 실패하여"), React.createElement("span", {
                        className: "mb-5"
                      }, "주문이 정상 처리되지 못했습니다."), React.createElement("span", undefined, "주문/결제하기 페이지에서"), React.createElement("span", {
                        className: "mb-5"
                      }, "결제를 다시 시도해주세요."), React.createElement("span", {
                        className: "mb-5 text-notice"
                      }, match[0])),
              show: match$1[0],
              href: match$2[0]
            });
}

var make = TossPaymentsFail_Buyer;

export {
  tossPaymentsErrorCode_encode ,
  tossPaymentsErrorCode_decode ,
  codeToString ,
  ErrorDialog ,
  make ,
  
}
/* react Not a pure module */
