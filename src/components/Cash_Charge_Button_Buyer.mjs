// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Curry from "rescript/lib/es6/curry.js";
import * as Spice from "@greenlabs/ppx-spice/src/rescript/Spice.mjs";
import * as React from "react";
import * as Locale from "../utils/Locale.mjs";
import * as Divider from "./common/Divider.mjs";
import * as Js_dict from "rescript/lib/es6/js_dict.js";
import * as Js_json from "rescript/lib/es6/js_json.js";
import * as Caml_obj from "rescript/lib/es6/caml_obj.js";
import * as Payments from "../bindings/Payments.mjs";
import * as IconArrow from "./svgs/IconArrow.mjs";
import * as IconClose from "./svgs/IconClose.mjs";
import * as IconError from "./svgs/IconError.mjs";
import * as Belt_Array from "rescript/lib/es6/belt_Array.js";
import * as Belt_Float from "rescript/lib/es6/belt_Float.js";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as ReactRelay from "react-relay";
import * as ReactHookForm from "../bindings/ReactHookForm/ReactHookForm.mjs";
import * as RelayRuntime from "relay-runtime";
import * as DetectBrowser from "detect-browser";
import * as ReactHookForm$1 from "react-hook-form";
import * as InputWithAdornment from "./common/InputWithAdornment.mjs";
import * as Webapi__Dom__Element from "rescript-webapi/src/Webapi/Dom/Webapi__Dom__Element.mjs";
import * as ToggleOrderAndPayment from "../utils/ToggleOrderAndPayment.mjs";
import * as ReactDialog from "@radix-ui/react-dialog";
import * as ReactToastNotifications from "react-toast-notifications";
import * as Webapi__Dom__HtmlInputElement from "rescript-webapi/src/Webapi/Dom/Webapi__Dom__HtmlInputElement.mjs";
import NoticeSvg from "../../public/assets/notice.svg";
import * as Buyer_Deposit_Detail_Button_Admin from "./Buyer_Deposit_Detail_Button_Admin.mjs";
import RadioFilledSvg from "../../public/assets/radio-filled.svg";
import RadioDefaultSvg from "../../public/assets/radio-default.svg";
import * as CashChargeButtonBuyerMutation_graphql from "../__generated__/CashChargeButtonBuyerMutation_graphql.mjs";
import CheckboxCheckedSvg from "../../public/assets/checkbox-checked.svg";
import CheckboxUncheckedSvg from "../../public/assets/checkbox-unchecked.svg";

var checkboxCheckedIcon = CheckboxCheckedSvg;

var checkboxUncheckedIcon = CheckboxUncheckedSvg;

var radioDefaultIcon = RadioDefaultSvg;

var radioFilledIcon = RadioFilledSvg;

var noticeIcon = NoticeSvg;

function form_encode(v) {
  return Js_dict.fromArray([
              [
                "payment-method",
                Payments.paymentMethod_encode(v.paymentMethod)
              ],
              [
                "amount",
                Spice.intToJson(v.amount)
              ]
            ]);
}

function form_decode(v) {
  var dict = Js_json.classify(v);
  if (typeof dict === "number") {
    return Spice.error(undefined, "Not an object", v);
  }
  if (dict.TAG !== /* JSONObject */2) {
    return Spice.error(undefined, "Not an object", v);
  }
  var dict$1 = dict._0;
  var paymentMethod = Payments.paymentMethod_decode(Belt_Option.getWithDefault(Js_dict.get(dict$1, "payment-method"), null));
  if (paymentMethod.TAG === /* Ok */0) {
    var amount = Spice.intFromJson(Belt_Option.getWithDefault(Js_dict.get(dict$1, "amount"), null));
    if (amount.TAG === /* Ok */0) {
      return {
              TAG: /* Ok */0,
              _0: {
                paymentMethod: paymentMethod._0,
                amount: amount._0
              }
            };
    }
    var e = amount._0;
    return {
            TAG: /* Error */1,
            _0: {
              path: ".amount" + e.path,
              message: e.message,
              value: e.value
            }
          };
  }
  var e$1 = paymentMethod._0;
  return {
          TAG: /* Error */1,
          _0: {
            path: ".payment-method" + e$1.path,
            message: e$1.message,
            value: e$1.value
          }
        };
}

function setValueToHtmlInputElement(name, v) {
  Belt_Option.map(Belt_Option.flatMap(Caml_option.nullable_to_opt(document.getElementById(name)), Webapi__Dom__HtmlInputElement.ofElement), (function (e) {
          e.value = v;
        }));
}

function commitMutation(environment, variables, optimisticUpdater, optimisticResponse, updater, onCompleted, onError, uploadables, param) {
  return RelayRuntime.commitMutation(environment, {
              mutation: CashChargeButtonBuyerMutation_graphql.node,
              variables: CashChargeButtonBuyerMutation_graphql.Internal.convertVariables(variables),
              onCompleted: (function (res, err) {
                  if (onCompleted !== undefined) {
                    return Curry._2(onCompleted, CashChargeButtonBuyerMutation_graphql.Internal.convertResponse(res), (err == null) ? undefined : Caml_option.some(err));
                  }
                  
                }),
              onError: (function (err) {
                  if (onError !== undefined) {
                    return Curry._1(onError, (err == null) ? undefined : Caml_option.some(err));
                  }
                  
                }),
              optimisticResponse: optimisticResponse !== undefined ? CashChargeButtonBuyerMutation_graphql.Internal.convertWrapRawResponse(optimisticResponse) : undefined,
              optimisticUpdater: optimisticUpdater,
              updater: updater !== undefined ? (function (store, r) {
                    Curry._2(updater, store, CashChargeButtonBuyerMutation_graphql.Internal.convertResponse(r));
                  }) : undefined,
              uploadables: uploadables
            });
}

function use(param) {
  var match = ReactRelay.useMutation(CashChargeButtonBuyerMutation_graphql.node);
  var mutate = match[0];
  return [
          React.useMemo((function () {
                  return function (param, param$1, param$2, param$3, param$4, param$5, param$6, param$7, param$8) {
                    return Curry._1(mutate, {
                                onError: param,
                                onCompleted: param$1 !== undefined ? (function (r, errors) {
                                      Curry._2(param$1, CashChargeButtonBuyerMutation_graphql.Internal.convertResponse(r), (errors == null) ? undefined : Caml_option.some(errors));
                                    }) : undefined,
                                onUnsubscribe: param$2,
                                optimisticResponse: param$3 !== undefined ? CashChargeButtonBuyerMutation_graphql.Internal.convertWrapRawResponse(param$3) : undefined,
                                optimisticUpdater: param$4,
                                updater: param$5 !== undefined ? (function (store, r) {
                                      Curry._2(param$5, store, CashChargeButtonBuyerMutation_graphql.Internal.convertResponse(r));
                                    }) : undefined,
                                variables: CashChargeButtonBuyerMutation_graphql.Internal.convertVariables(param$6),
                                uploadables: param$7
                              });
                  };
                }), [mutate]),
          match[1]
        ];
}

var MutationCreateCharge_device_decode = CashChargeButtonBuyerMutation_graphql.Utils.device_decode;

var MutationCreateCharge_device_fromString = CashChargeButtonBuyerMutation_graphql.Utils.device_fromString;

var MutationCreateCharge_errorCode_decode = CashChargeButtonBuyerMutation_graphql.Utils.errorCode_decode;

var MutationCreateCharge_errorCode_fromString = CashChargeButtonBuyerMutation_graphql.Utils.errorCode_fromString;

var MutationCreateCharge_paymentMethod_decode = CashChargeButtonBuyerMutation_graphql.Utils.paymentMethod_decode;

var MutationCreateCharge_paymentMethod_fromString = CashChargeButtonBuyerMutation_graphql.Utils.paymentMethod_fromString;

var MutationCreateCharge_paymentPurpose_decode = CashChargeButtonBuyerMutation_graphql.Utils.paymentPurpose_decode;

var MutationCreateCharge_paymentPurpose_fromString = CashChargeButtonBuyerMutation_graphql.Utils.paymentPurpose_fromString;

var MutationCreateCharge = {
  device_decode: MutationCreateCharge_device_decode,
  device_fromString: MutationCreateCharge_device_fromString,
  errorCode_decode: MutationCreateCharge_errorCode_decode,
  errorCode_fromString: MutationCreateCharge_errorCode_fromString,
  paymentMethod_decode: MutationCreateCharge_paymentMethod_decode,
  paymentMethod_fromString: MutationCreateCharge_paymentMethod_fromString,
  paymentPurpose_decode: MutationCreateCharge_paymentPurpose_decode,
  paymentPurpose_fromString: MutationCreateCharge_paymentPurpose_fromString,
  Operation: undefined,
  Types: undefined,
  commitMutation: commitMutation,
  use: use
};

function Cash_Charge_Button_Buyer(Props) {
  var hasRequireTerms = Props.hasRequireTerms;
  var buttonClassName = Props.buttonClassName;
  var buttonText = Props.buttonText;
  var match = ReactToastNotifications.useToasts();
  var addToast = match.addToast;
  var match$1 = ReactHookForm$1.useForm({
        mode: "onSubmit",
        revalidateMode: "onChange"
      }, undefined);
  var reset = match$1.reset;
  var isDirty = match$1.formState.isDirty;
  var control = match$1.control;
  var match$2 = use(undefined);
  var isMutating = match$2[1];
  var mutate = match$2[0];
  var match$3 = React.useState(function () {
        return false;
      });
  var setRequireTerms = match$3[1];
  var availableButton = ToggleOrderAndPayment.use(undefined);
  var close = function (param) {
    var buttonClose = document.getElementById("btn-close");
    Belt_Option.forEach(Belt_Option.flatMap((buttonClose == null) ? undefined : Caml_option.some(buttonClose), Webapi__Dom__Element.asHtmlElement), (function (buttonClose$p) {
            buttonClose$p.click();
          }));
    reset(undefined);
  };
  var errorElement = React.createElement(React.Fragment, undefined, React.createElement("img", {
            alt: "notice-icon",
            src: noticeIcon
          }), React.createElement("div", {
            className: "ml-1.5 text-sm"
          }, "최소 결제금액(1,000원 이상)을 입력해주세요."));
  var handleError = function (message, param) {
    addToast(React.createElement("div", {
              className: "flex items-center"
            }, React.createElement(IconError.make, {
                  width: "24",
                  height: "24",
                  className: "mr-2"
                }), "결제가 실패하였습니다. " + Belt_Option.getWithDefault(message, "") + ""), {
          appearance: "error"
        });
  };
  var detectIsMobile = function (param) {
    var match = DetectBrowser.detect();
    var os = match.os;
    var mobileOS = [
      "iOS",
      "Android OS",
      "BlackBerry OS",
      "Windows Mobile",
      "Amazon OS"
    ];
    return Belt_Array.some(mobileOS, (function (x) {
                  return x === os;
                }));
  };
  var handleConfirm = function (data, param) {
    var data$p = form_decode(data);
    if (data$p.TAG === /* Ok */0) {
      var data$p$1 = data$p._0;
      setValueToHtmlInputElement("good_mny", String(data$p$1.amount));
      setValueToHtmlInputElement("pay_method", Payments.methodToKCPValue(data$p$1.paymentMethod));
      var match = data$p$1.paymentMethod;
      if (!availableButton && match === "VIRTUAL_ACCOUNT") {
        window.alert("서비스 점검으로 가상계좌 결제 기능을 이용할 수 없습니다.");
        return ;
      }
      Curry.app(mutate, [
            (function (err) {
                handleError(err.message, undefined);
              }),
            (function (param, param$1) {
                var requestPayment = param.requestPayment;
                if (requestPayment === undefined) {
                  return handleError("주문 생성 요청 실패", undefined);
                }
                if (typeof requestPayment !== "object") {
                  return handleError("주문 생성 에러", undefined);
                }
                var variant = requestPayment.NAME;
                if (variant === "Error") {
                  return handleError("주문 생성 에러", undefined);
                }
                if (variant === "RequestPaymentTossPaymentsResult") {
                  var match = requestPayment.VAL;
                  var paymentId = match.paymentId;
                  var orderId = match.orderId;
                  var amount = match.amount;
                  return window.tossPayments.requestPayment(Payments.methodToTossValue(data$p$1.paymentMethod), {
                              amount: amount,
                              orderId: orderId,
                              orderName: "신선하이 " + String(amount) + "",
                              taxFreeAmount: undefined,
                              customerName: match.customerName,
                              successUrl: "" + window.location.origin + "/buyer/toss-payments/success?order-no=" + orderId + "&payment-id=" + String(paymentId) + "",
                              failUrl: "" + window.location.origin + "/buyer/toss-payments/fail?from=/transactions",
                              validHours: Payments.tossPaymentsValidHours(data$p$1.paymentMethod),
                              cashReceipt: Payments.tossPaymentsCashReceipt(data$p$1.paymentMethod),
                              appScheme: Belt_Option.map(Caml_option.nullable_to_opt(window.ReactNativeWebView), (function (param) {
                                      return encodeURIComponent("sinsunhi://com.greenlabs.sinsunhi/buyer/toss-payments/success?order-no=" + orderId + "&payment-id=" + String(paymentId) + "");
                                    }))
                            });
                }
                if (variant !== "RequestPaymentKCPResult") {
                  return handleError("주문 생성 에러", undefined);
                }
                var requestPaymnetKCPResult = requestPayment.VAL;
                close(undefined);
                setValueToHtmlInputElement("site_cd", requestPaymnetKCPResult.siteCd);
                setValueToHtmlInputElement("site_name", requestPaymnetKCPResult.siteName);
                setValueToHtmlInputElement("site_key", requestPaymnetKCPResult.siteKey);
                setValueToHtmlInputElement("ordr_idxx", requestPaymnetKCPResult.ordrIdxx);
                setValueToHtmlInputElement("currency", requestPaymnetKCPResult.currency);
                setValueToHtmlInputElement("shop_user_id", requestPaymnetKCPResult.shopUserId);
                setValueToHtmlInputElement("buyr_name", requestPaymnetKCPResult.buyrName);
                var orderInfo = document.getElementById("order_info");
                if (orderInfo == null) {
                  return handleError("폼 데이터를 찾을 수가 없습니다.", undefined);
                } else {
                  window.jsf__pay(orderInfo);
                  return ;
                }
              }),
            undefined,
            undefined,
            undefined,
            undefined,
            {
              amount: data$p$1.amount,
              device: detectIsMobile(undefined) ? "MOBILE" : "PC",
              paymentMethod: data$p$1.paymentMethod,
              purpose: "SINSUN_CASH"
            },
            undefined,
            undefined
          ]);
      return ;
    }
    var msg = data$p._0;
    console.log(msg);
    handleError(msg.message, undefined);
  };
  var changeToFormattedFloat = function (j) {
    return Belt_Option.mapWithDefault(Js_json.decodeNumber(j), "", (function (f) {
                  return Locale.Float.show(undefined, f, 0);
                }));
  };
  return React.createElement(ReactDialog.Root, {
              children: null
            }, React.createElement(ReactDialog.Trigger, {
                  children: React.createElement("span", undefined, buttonText),
                  className: buttonClassName
                }), React.createElement(ReactDialog.Portal, {
                  children: null
                }, React.createElement(ReactDialog.Overlay, {
                      className: "dialog-overlay"
                    }), React.createElement(ReactDialog.Content, {
                      children: null,
                      className: "dialog-content p-5 overflow-y-auto text-text-L1 rounded-2xl",
                      onOpenAutoFocus: (function (prim) {
                          prim.preventDefault();
                        })
                    }, React.createElement(ReactDialog.Close, {
                          children: "",
                          className: "hidden",
                          id: "btn-close"
                        }), React.createElement("div", {
                          className: "flex justify-between items-center"
                        }, React.createElement("h3", {
                              className: "font-bold text-xl"
                            }, "신선캐시 충전"), React.createElement("button", {
                              className: "cursor-pointer border-none",
                              onClick: (function (param) {
                                  close(undefined);
                                })
                            }, React.createElement(IconClose.make, {
                                  height: "24",
                                  width: "24",
                                  fill: "#262626"
                                }))), React.createElement("div", {
                          className: "flex items-center gap-4 mt-10 font-bold"
                        }, React.createElement("h3", {
                              className: "text-sm"
                            }, "신선캐시 잔액"), React.createElement(Buyer_Deposit_Detail_Button_Admin.Summary.Amount.make, {
                              kind: /* Deposit */6,
                              className: "text-primary"
                            })), React.createElement(Divider.make, {
                          className: "my-5"
                        }), React.createElement("form", {
                          onSubmit: match$1.handleSubmit(handleConfirm)
                        }, React.createElement("div", {
                              className: "flex items-center text-sm"
                            }, React.createElement("h3", {
                                  className: "font-bold mr-1"
                                }, "충전금액"), React.createElement("span", undefined, "* 최소금액 1,000원")), React.createElement(ReactHookForm$1.Controller, {
                              name: "amount",
                              control: control,
                              render: (function (param) {
                                  var match = param.field;
                                  var value = match.value;
                                  var onChange = match.onChange;
                                  return React.createElement(React.Fragment, undefined, React.createElement(InputWithAdornment.make, {
                                                  name: match.name,
                                                  type_: "string",
                                                  value: changeToFormattedFloat(value),
                                                  onChange: (function (param) {
                                                      var v = param.target.value;
                                                      var stringToFloat = function (str) {
                                                        return Belt_Option.getWithDefault(Belt_Float.fromString(str.replace(/\D/g, "")), 0);
                                                      };
                                                      return Curry._1(onChange, Curry._1(ReactHookForm.Controller.OnChangeArg.value, stringToFloat(v)));
                                                    }),
                                                  adornment: React.createElement("span", undefined, "원"),
                                                  placeholder: "금액을 입력해주세요",
                                                  errored: Belt_Option.isSome(param.fieldState.error),
                                                  errorElement: errorElement,
                                                  className: "mt-3 h-13"
                                                }), React.createElement("div", {
                                                  className: "w-full mt-2 mb-3 text-sm"
                                                }, Belt_Array.map(Belt_Array.zip([
                                                          "+50만원",
                                                          "+100만원",
                                                          "+500만원",
                                                          "+1000만원"
                                                        ], [
                                                          "500000",
                                                          "1000000",
                                                          "5000000",
                                                          "10000000"
                                                        ]), (function (param) {
                                                        var toPlusValue = param[1];
                                                        var label = param[0];
                                                        return React.createElement("button", {
                                                                    key: label,
                                                                    className: "h-9 w-1/4 py-[7px] border border-gray-button-gl bg-white text-text-L2",
                                                                    type: "button",
                                                                    onClick: (function (param) {
                                                                        param.preventDefault();
                                                                        var currentValue = Belt_Option.getWithDefault(Js_json.decodeNumber(value), 0);
                                                                        return Curry._1(onChange, Curry._1(ReactHookForm.Controller.OnChangeArg.value, currentValue + Belt_Option.getWithDefault(Belt_Float.fromString(toPlusValue), 0)));
                                                                      })
                                                                  }, label);
                                                      }))));
                                }),
                              defaultValue: "",
                              rules: ReactHookForm.Rules.make(undefined, undefined, undefined, undefined, undefined, undefined, Caml_option.some(Js_dict.fromArray([
                                            [
                                              "required",
                                              ReactHookForm.Validation.sync(function (value) {
                                                    return value !== "";
                                                  })
                                            ],
                                            [
                                              "over1000",
                                              ReactHookForm.Validation.sync(function (v) {
                                                    return v >= 1000;
                                                  })
                                            ]
                                          ])), undefined, undefined, undefined),
                              shouldUnregister: true
                            }), React.createElement("h3", {
                              className: "mt-7 mb-3 font-bold text-sm"
                            }, "결제수단"), React.createElement(ReactHookForm$1.Controller, {
                              name: "payment-method",
                              control: control,
                              render: (function (param) {
                                  var match = param.field;
                                  var value = match.value;
                                  var onChange = match.onChange;
                                  return React.createElement("div", {
                                              className: "flex gap-10"
                                            }, Belt_Array.map([
                                                  [
                                                    "virtual",
                                                    "가상계좌"
                                                  ],
                                                  [
                                                    "card",
                                                    "신용카드"
                                                  ]
                                                ], (function (param) {
                                                    var name = param[1];
                                                    var v = param[0];
                                                    return React.createElement("button", {
                                                                key: name,
                                                                className: "flex items-center cursor-pointer gap-2 text-sm",
                                                                onClick: (function (e) {
                                                                    e.preventDefault();
                                                                    e.stopPropagation();
                                                                    Curry._1(onChange, Curry._1(ReactHookForm.Controller.OnChangeArg.value, v));
                                                                  })
                                                              }, React.createElement("img", {
                                                                    alt: "",
                                                                    src: Caml_obj.equal(value, v) ? radioFilledIcon : radioDefaultIcon
                                                                  }), name);
                                                  })));
                                }),
                              defaultValue: "card",
                              shouldUnregister: true
                            }), hasRequireTerms ? React.createElement("div", {
                                className: "flex justify-between"
                              }, React.createElement("button", {
                                    className: "flex items-center cursor-pointer",
                                    onClick: (function (param) {
                                        setRequireTerms(function (prev) {
                                              return !prev;
                                            });
                                      })
                                  }, React.createElement("img", {
                                        alt: "",
                                        src: match$3[0] ? checkboxCheckedIcon : checkboxUncheckedIcon
                                      }), React.createElement("span", {
                                        className: "ml-2 text-sm"
                                      }, "신선하이 이용약관 동의(필수)")), React.createElement("a", {
                                    href: "/terms",
                                    target: "_blank"
                                  }, React.createElement(IconArrow.make, {
                                        height: "20",
                                        width: "20",
                                        fill: "#B2B2B2",
                                        className: "cursor-pointer"
                                      }))) : null, React.createElement("div", {
                              className: "flex justify-between gap-3 mt-10 text-lg"
                            }, React.createElement("button", {
                                  className: "w-1/2 py-3 btn-level6 font-bold",
                                  disabled: isMutating,
                                  type: "button",
                                  onClick: (function (param) {
                                      close(undefined);
                                    })
                                }, "닫기"), React.createElement("button", {
                                  className: isDirty ? "w-1/2 py-3 btn-level1 font-bold" : "w-1/2 py-3 btn-level1-disabled font-bold",
                                  disabled: isMutating || !isDirty,
                                  type: "submit"
                                }, "결제"))))));
}

var make = Cash_Charge_Button_Buyer;

export {
  checkboxCheckedIcon ,
  checkboxUncheckedIcon ,
  radioDefaultIcon ,
  radioFilledIcon ,
  noticeIcon ,
  form_encode ,
  form_decode ,
  setValueToHtmlInputElement ,
  MutationCreateCharge ,
  make ,
}
/* checkboxCheckedIcon Not a pure module */
