// Generated by ReScript, PLEASE EDIT WITH CARE

import * as React from "react";
import * as Dialog from "./common/Dialog.mjs";
import * as Locale from "../utils/Locale.mjs";
import * as Skeleton from "./Skeleton.mjs";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as CustomHooks from "../utils/CustomHooks.mjs";
import * as Router from "next/router";
import * as ReactDialog from "@radix-ui/react-dialog";
import * as ReactSeparator from "@radix-ui/react-separator";

function formatDate(d) {
  return Locale.DateTime.formatFromUTC(new Date(d), "yyyy/MM/dd HH:mm");
}

function Buyer_Deposit_Detail_Button_Admin$Summary$Amount(Props) {
  var kind = Props.kind;
  var className = Props.className;
  var router = Router.useRouter();
  var status = CustomHooks.TransactionSummary.use(new URLSearchParams(router.query).toString());
  if (typeof status === "number") {
    return React.createElement(Skeleton.Box.make, {
                className: "w-20"
              });
  }
  if (status.TAG === /* Loaded */0) {
    var response$p = CustomHooks.TransactionSummary.response_decode(status._0);
    if (response$p.TAG === /* Ok */0) {
      var response$p$1 = response$p._0;
      var tmp = {};
      if (className !== undefined) {
        tmp.className = Caml_option.valFromOption(className);
      }
      var tmp$1;
      switch (kind) {
        case /* OrderComplete */0 :
            tmp$1 = "" + Locale.Float.show(true, response$p$1.data.orderComplete, 0) + "원";
            break;
        case /* CashRefund */1 :
            tmp$1 = "" + Locale.Float.show(true, response$p$1.data.cashRefund, 0) + "원";
            break;
        case /* ImwebPay */2 :
            tmp$1 = "" + Locale.Float.show(true, response$p$1.data.imwebPay, 0) + "원";
            break;
        case /* ImwebCancel */3 :
            tmp$1 = "" + Locale.Float.show(true, response$p$1.data.imwebCancel, 0) + "원";
            break;
        case /* OrderCancel */4 :
            tmp$1 = "" + Locale.Float.show(true, response$p$1.data.orderCancel, 0) + "원";
            break;
        case /* OrderRefund */5 :
            tmp$1 = "" + Locale.Float.show(true, response$p$1.data.orderRefund, 0) + "원";
            break;
        case /* Deposit */6 :
            tmp$1 = "" + Locale.Float.show(true, response$p$1.data.deposit, 0) + "원";
            break;
        case /* SinsunCash */7 :
            tmp$1 = "" + Locale.Float.show(true, response$p$1.data.sinsunCash, 0) + "원";
            break;
        
      }
      return React.createElement("span", tmp, tmp$1);
    }
    console.log(response$p._0);
    return React.createElement(Skeleton.Box.make, {
                className: "w-20"
              });
  }
  console.log(status._0);
  return React.createElement(Skeleton.Box.make, {
              className: "w-20"
            });
}

var Amount = {
  make: Buyer_Deposit_Detail_Button_Admin$Summary$Amount
};

function Buyer_Deposit_Detail_Button_Admin$Summary(Props) {
  return React.createElement("div", {
              className: "p-5"
            }, React.createElement("ol", {
                  className: "text-text-L1"
                }, React.createElement("li", {
                      className: "flex justify-between items-center py-1.5"
                    }, React.createElement("span", undefined, "주문가능 잔액"), React.createElement(Buyer_Deposit_Detail_Button_Admin$Summary$Amount, {
                          kind: /* Deposit */6,
                          className: "font-bold text-primary"
                        })), React.createElement(ReactSeparator.Root, {
                      className: "h-px bg-disabled-L2 my-3"
                    }), React.createElement("li", {
                      className: "flex justify-between items-center py-1.5"
                    }, React.createElement("span", undefined, "신선캐시 충전"), React.createElement(Buyer_Deposit_Detail_Button_Admin$Summary$Amount, {
                          kind: /* SinsunCash */7,
                          className: "font-bold"
                        })), React.createElement("li", {
                      className: "flex justify-between items-center py-1.5"
                    }, React.createElement("span", undefined, "상품결제"), React.createElement(Buyer_Deposit_Detail_Button_Admin$Summary$Amount, {
                          kind: /* ImwebPay */2,
                          className: "font-bold"
                        })), React.createElement("li", {
                      className: "flex justify-between items-center py-1.5"
                    }, React.createElement("span", undefined, "상품발주"), React.createElement(Buyer_Deposit_Detail_Button_Admin$Summary$Amount, {
                          kind: /* OrderComplete */0,
                          className: "font-bold"
                        })), React.createElement("li", {
                      className: "flex justify-between items-center py-1.5"
                    }, React.createElement("span", undefined, "주문취소"), React.createElement(Buyer_Deposit_Detail_Button_Admin$Summary$Amount, {
                          kind: /* OrderCancel */4,
                          className: "font-bold"
                        })), React.createElement("li", {
                      className: "flex justify-between items-center py-1.5"
                    }, React.createElement("span", undefined, "상품결제취소"), React.createElement(Buyer_Deposit_Detail_Button_Admin$Summary$Amount, {
                          kind: /* ImwebCancel */3,
                          className: "font-bold"
                        })), React.createElement("li", {
                      className: "flex justify-between items-center py-1.5"
                    }, React.createElement("span", undefined, "환불금액"), React.createElement(Buyer_Deposit_Detail_Button_Admin$Summary$Amount, {
                          kind: /* OrderRefund */5,
                          className: "font-bold"
                        })), React.createElement("li", {
                      className: "flex justify-between items-center py-1.5"
                    }, React.createElement("span", undefined, "잔액환불"), React.createElement(Buyer_Deposit_Detail_Button_Admin$Summary$Amount, {
                          kind: /* CashRefund */1,
                          className: "font-bold"
                        }))));
}

var Summary = {
  Amount: Amount,
  make: Buyer_Deposit_Detail_Button_Admin$Summary
};

function Buyer_Deposit_Detail_Button_Admin(Props) {
  return React.createElement(ReactDialog.Root, {
              children: null
            }, React.createElement(ReactDialog.Overlay, {
                  className: "dialog-overlay"
                }), React.createElement(ReactDialog.Trigger, {
                  children: React.createElement("button", {
                        className: "btn-level6-small px-3 h-9"
                      }, "잔액 자세히보기"),
                  className: "focus:outline-none"
                }), React.createElement(ReactDialog.Content, {
                  children: null,
                  className: "dialog-content overflow-y-auto",
                  onOpenAutoFocus: (function (prim) {
                      prim.preventDefault();
                    })
                }, React.createElement("h3", {
                      className: "p-5 font-bold text-center"
                    }, "주문가능 잔액 상세"), React.createElement(Buyer_Deposit_Detail_Button_Admin$Summary, {}), React.createElement(ReactDialog.Close, {
                      children: React.createElement(Dialog.ButtonBox.make, {
                            onCancel: (function (param) {
                                console.log("!!");
                              }),
                            textOnCancel: "닫기"
                          }),
                      className: "w-full focus:outline-none"
                    })));
}

var CustomDialog;

var make = Buyer_Deposit_Detail_Button_Admin;

export {
  CustomDialog ,
  formatDate ,
  Summary ,
  make ,
}
/* react Not a pure module */
