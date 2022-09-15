// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Env from "../constants/Env.mjs";
import * as Curry from "rescript/lib/es6/curry.js";
import * as Input from "./common/Input.mjs";
import * as Spice from "@greenlabs/ppx-spice/src/rescript/Spice.mjs";
import * as React from "react";
import * as Js_dict from "rescript/lib/es6/js_dict.js";
import * as Js_json from "rescript/lib/es6/js_json.js";
import * as IconCheck from "./svgs/IconCheck.mjs";
import * as IconClose from "./svgs/IconClose.mjs";
import * as IconError from "./svgs/IconError.mjs";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as FetchHelper from "../utils/FetchHelper.mjs";
import * as ReactEvents from "../utils/ReactEvents.mjs";
import * as ReactRelay from "react-relay";
import * as RelayRuntime from "relay-runtime";
import * as ValidatedState from "../utils/ValidatedState.mjs";
import * as ReactDialog from "@radix-ui/react-dialog";
import * as ReactToastNotifications from "react-toast-notifications";
import * as UpdateBusinessNumberBuyer_Mutation_graphql from "../__generated__/UpdateBusinessNumberBuyer_Mutation_graphql.mjs";

function commitMutation(environment, variables, optimisticUpdater, optimisticResponse, updater, onCompleted, onError, uploadables, param) {
  return RelayRuntime.commitMutation(environment, {
              mutation: UpdateBusinessNumberBuyer_Mutation_graphql.node,
              variables: UpdateBusinessNumberBuyer_Mutation_graphql.Internal.convertVariables(variables),
              onCompleted: (function (res, err) {
                  if (onCompleted !== undefined) {
                    return Curry._2(onCompleted, UpdateBusinessNumberBuyer_Mutation_graphql.Internal.convertResponse(res), (err == null) ? undefined : Caml_option.some(err));
                  }
                  
                }),
              onError: (function (err) {
                  if (onError !== undefined) {
                    return Curry._1(onError, (err == null) ? undefined : Caml_option.some(err));
                  }
                  
                }),
              optimisticResponse: optimisticResponse !== undefined ? UpdateBusinessNumberBuyer_Mutation_graphql.Internal.convertWrapRawResponse(optimisticResponse) : undefined,
              optimisticUpdater: optimisticUpdater,
              updater: updater !== undefined ? (function (store, r) {
                    Curry._2(updater, store, UpdateBusinessNumberBuyer_Mutation_graphql.Internal.convertResponse(r));
                  }) : undefined,
              uploadables: uploadables
            });
}

function use(param) {
  var match = ReactRelay.useMutation(UpdateBusinessNumberBuyer_Mutation_graphql.node);
  var mutate = match[0];
  return [
          React.useMemo((function () {
                  return function (param, param$1, param$2, param$3, param$4, param$5, param$6, param$7, param$8) {
                    return Curry._1(mutate, {
                                onError: param,
                                onCompleted: param$1 !== undefined ? (function (r, errors) {
                                      Curry._2(param$1, UpdateBusinessNumberBuyer_Mutation_graphql.Internal.convertResponse(r), (errors == null) ? undefined : Caml_option.some(errors));
                                    }) : undefined,
                                onUnsubscribe: param$2,
                                optimisticResponse: param$3 !== undefined ? UpdateBusinessNumberBuyer_Mutation_graphql.Internal.convertWrapRawResponse(param$3) : undefined,
                                optimisticUpdater: param$4,
                                updater: param$5 !== undefined ? (function (store, r) {
                                      Curry._2(param$5, store, UpdateBusinessNumberBuyer_Mutation_graphql.Internal.convertResponse(r));
                                    }) : undefined,
                                variables: UpdateBusinessNumberBuyer_Mutation_graphql.Internal.convertVariables(param$6),
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

function message_encode(v) {
  return "VALID";
}

function message_decode(v) {
  var str = Js_json.classify(v);
  if (typeof str === "number" || str.TAG !== /* JSONString */0) {
    return Spice.error(undefined, "Not a JSONString", v);
  } else if ("VALID" === str._0) {
    return {
            TAG: /* Ok */0,
            _0: /* VALID */0
          };
  } else {
    return Spice.error(undefined, "Not matched", v);
  }
}

function response_encode(v) {
  return Js_dict.fromArray([[
                "message",
                "VALID"
              ]]);
}

function response_decode(v) {
  var dict = Js_json.classify(v);
  if (typeof dict === "number") {
    return Spice.error(undefined, "Not an object", v);
  }
  if (dict.TAG !== /* JSONObject */2) {
    return Spice.error(undefined, "Not an object", v);
  }
  var message = message_decode(Belt_Option.getWithDefault(Js_dict.get(dict._0, "message"), null));
  if (message.TAG === /* Ok */0) {
    return {
            TAG: /* Ok */0,
            _0: {
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

function formatValidator(businessNumber) {
  var exp = new RegExp("^\\d{3}-\\d{2}-\\d{5}$");
  if (exp.test(businessNumber)) {
    return {
            TAG: /* Ok */0,
            _0: businessNumber
          };
  } else {
    return {
            TAG: /* Error */1,
            _0: {
              type_: "format",
              message: "사업자 등록번호 형식을 확인해주세요."
            }
          };
  }
}

function Update_BusinessNumber_Buyer(Props) {
  var isOpen = Props.isOpen;
  var onClose = Props.onClose;
  var defaultValueOpt = Props.defaultValue;
  var defaultValue = defaultValueOpt !== undefined ? defaultValueOpt : "";
  var match = ReactToastNotifications.useToasts();
  var addToast = match.addToast;
  var match$1 = ValidatedState.use(/* String */0, defaultValue, [formatValidator]);
  var state = match$1[2];
  var setBusinessNumber = match$1[1];
  var businessNumber = match$1[0];
  var match$2 = use(undefined);
  var mutate = match$2[0];
  var match$3 = React.useState(function () {
        return false;
      });
  var setIsVerifying = match$3[1];
  var isVerifying = match$3[0];
  var handleOnChangeBusinessNumber = function (e) {
    var newValue = e.currentTarget.value.replace(/[^\d]/g, "").replace(/(^\d{3})(\d+)?(\d{5})$/, "$1-$2-$3").replace("--", "-");
    Curry._3(setBusinessNumber, newValue, true, undefined);
  };
  var reset = function (param) {
    Curry._3(setBusinessNumber, "", undefined, undefined);
    setIsVerifying(function (param) {
          return false;
        });
  };
  var handleOnClickVerify = function (param) {
    return ReactEvents.interceptingHandler((function (param) {
                  setIsVerifying(function (param) {
                        return true;
                      });
                  var bNo = businessNumber.replace(new RegExp("\-", "g"), "");
                  var queryStr = new URLSearchParams(Js_dict.fromList({
                              hd: [
                                "b-no",
                                bNo
                              ],
                              tl: /* [] */0
                            })).toString();
                  FetchHelper.get("" + Env.restApiUrl + "/user/validate-business-number?" + queryStr + "", (function (json) {
                          var json$p = response_decode(json);
                          if (json$p.TAG === /* Ok */0) {
                            Curry.app(mutate, [
                                  (function (err) {
                                      addToast(React.createElement("div", {
                                                className: "flex items-center"
                                              }, React.createElement(IconError.make, {
                                                    width: "24",
                                                    height: "24",
                                                    className: "mr-2"
                                                  }), "오류가 발생하였습니다. 사업자 등록번호를 확인하세요.", err.message), {
                                            appearance: "error"
                                          });
                                    }),
                                  (function (param, param$1) {
                                      var updateUser = param.updateUser;
                                      var variant = updateUser.NAME;
                                      if (variant === "UnselectedUnionMember") {
                                        return addToast(React.createElement("div", {
                                                        className: "flex items-center"
                                                      }, React.createElement(IconError.make, {
                                                            width: "24",
                                                            height: "24",
                                                            className: "mr-2"
                                                          }), "오류가 발생하였습니다. 사업자 등록번호를 확인하세요."), {
                                                    appearance: "error"
                                                  });
                                      } else if (variant === "User") {
                                        return addToast(React.createElement("div", {
                                                        className: "flex items-center"
                                                      }, React.createElement(IconCheck.make, {
                                                            height: "24",
                                                            width: "24",
                                                            fill: "#12B564",
                                                            className: "mr-2"
                                                          }), "사업자 등록번호가 저장되었습니다."), {
                                                    appearance: "success"
                                                  });
                                      } else {
                                        return addToast(React.createElement("div", {
                                                        className: "flex items-center"
                                                      }, React.createElement(IconError.make, {
                                                            width: "24",
                                                            height: "24",
                                                            className: "mr-2"
                                                          }), "오류가 발생하였습니다. 사업자 등록번호를 확인하세요.", Belt_Option.getWithDefault(updateUser.VAL.message, "")), {
                                                    appearance: "error"
                                                  });
                                      }
                                    }),
                                  undefined,
                                  undefined,
                                  undefined,
                                  undefined,
                                  {
                                    input: {
                                      businessRegistrationNumber: bNo
                                    }
                                  },
                                  undefined,
                                  undefined
                                ]);
                            reset(undefined);
                            Curry._1(onClose, undefined);
                          } else {
                            addToast(React.createElement("div", {
                                      className: "flex items-center"
                                    }, React.createElement(IconError.make, {
                                          width: "24",
                                          height: "24",
                                          className: "mr-2"
                                        }), "유효하지 않은 사업자번호 입니다."), {
                                  appearance: "error"
                                });
                          }
                          setIsVerifying(function (param) {
                                return false;
                              });
                        }), (function (param) {
                          addToast(React.createElement("div", {
                                    className: "flex items-center"
                                  }, React.createElement(IconError.make, {
                                        width: "24",
                                        height: "24",
                                        className: "mr-2"
                                      }), "잠시후 다시 시도해주세요."), {
                                appearance: "error"
                              });
                          setIsVerifying(function (param) {
                                return false;
                              });
                        }));
                }), param);
  };
  return React.createElement(ReactDialog.Root, {
              children: null,
              open: isOpen,
              onOpenChange: reset
            }, React.createElement(ReactDialog.Overlay, {
                  className: "dialog-overlay"
                }), React.createElement(ReactDialog.Content, {
                  children: React.createElement("div", {
                        className: "fixed top-0 left-0 h-full xl:static bg-white w-full max-w-3xl xl:min-h-fit xl:min-w-min xl:w-[90vh] xl:max-w-[480px] xl:max-h-[85vh] "
                      }, React.createElement("section", {
                            className: "h-14 w-full xl:h-auto xl:w-auto xl:mt-10"
                          }, React.createElement("div", {
                                className: "flex items-center justify-between px-5 w-full py-4 xl:h-14 xl:w-full xl:pb-10"
                              }, React.createElement("div", {
                                    className: "w-6 xl:hidden"
                                  }), React.createElement("div", undefined, React.createElement("span", {
                                        className: "font-bold xl:text-2xl"
                                      }, "사업자 등록번호 수정")), React.createElement(ReactDialog.Close, {
                                    onClick: (function (param) {
                                        Curry._1(onClose, undefined);
                                      }),
                                    children: React.createElement(IconClose.make, {
                                          height: "24",
                                          width: "24",
                                          fill: "#262626"
                                        }),
                                    className: "focus:outline-none"
                                  }))), React.createElement("section", {
                            className: "pt-12 xl:pt-3 mb-6 px-4"
                          }, React.createElement("form", {
                                onSubmit: handleOnClickVerify
                              }, React.createElement("div", {
                                    className: "flex flex-col "
                                  }, React.createElement("div", {
                                        className: "flex flex-col mb-10"
                                      }, React.createElement("div", {
                                            className: "mb-2"
                                          }, React.createElement("label", {
                                                className: "font-bold"
                                              }, "사업자 등록번호")), React.createElement(Input.make, {
                                            type_: "text",
                                            name: "business-number",
                                            placeholder: "사업자 등록번호를 입력해주세요.",
                                            className: "w-full",
                                            value: businessNumber,
                                            onChange: handleOnChangeBusinessNumber,
                                            size: /* Large */0,
                                            error: Belt_Option.map(state.error, (function (param) {
                                                    return param.message;
                                                  })),
                                            disabled: isVerifying
                                          })), React.createElement("button", {
                                        className: "bg-green-500 rounded-xl w-full py-4",
                                        disabled: Belt_Option.isSome(state.error) || businessNumber === "" || isVerifying,
                                        type: "submit"
                                      }, React.createElement("span", {
                                            className: "text-white"
                                          }, "인증")))))),
                  className: "dialog-content-plain bottom-0 left-0 xl:bottom-auto xl:left-auto xl:rounded-2xl xl:state-open:top-1/2 xl:state-open:left-1/2 xl:state-open:-translate-x-1/2 xl:state-open:-translate-y-1/2"
                }));
}

var make = Update_BusinessNumber_Buyer;

export {
  Mutation ,
  message_encode ,
  message_decode ,
  response_encode ,
  response_decode ,
  formatValidator ,
  make ,
}
/* Env Not a pure module */