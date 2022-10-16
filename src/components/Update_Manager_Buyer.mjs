// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Cx from "rescript-classnames/src/Cx.mjs";
import * as Curry from "rescript/lib/es6/curry.js";
import * as React from "react";
import * as IconCheck from "./svgs/IconCheck.mjs";
import * as IconClose from "./svgs/IconClose.mjs";
import * as IconError from "./svgs/IconError.mjs";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as ReactEvents from "../utils/ReactEvents.mjs";
import * as ReactRelay from "react-relay";
import * as RelayRuntime from "relay-runtime";
import * as ValidatedState from "../utils/ValidatedState.mjs";
import * as ReactDialog from "@radix-ui/react-dialog";
import * as ReactToastNotifications from "react-toast-notifications";
import * as UpdateManagerBuyer_Mutation_graphql from "../__generated__/UpdateManagerBuyer_Mutation_graphql.mjs";

function commitMutation(environment, variables, optimisticUpdater, optimisticResponse, updater, onCompleted, onError, uploadables, param) {
  return RelayRuntime.commitMutation(environment, {
              mutation: UpdateManagerBuyer_Mutation_graphql.node,
              variables: UpdateManagerBuyer_Mutation_graphql.Internal.convertVariables(variables),
              onCompleted: (function (res, err) {
                  if (onCompleted !== undefined) {
                    return Curry._2(onCompleted, UpdateManagerBuyer_Mutation_graphql.Internal.convertResponse(res), (err == null) ? undefined : Caml_option.some(err));
                  }
                  
                }),
              onError: (function (err) {
                  if (onError !== undefined) {
                    return Curry._1(onError, (err == null) ? undefined : Caml_option.some(err));
                  }
                  
                }),
              optimisticResponse: optimisticResponse !== undefined ? UpdateManagerBuyer_Mutation_graphql.Internal.convertWrapRawResponse(optimisticResponse) : undefined,
              optimisticUpdater: optimisticUpdater,
              updater: updater !== undefined ? (function (store, r) {
                    Curry._2(updater, store, UpdateManagerBuyer_Mutation_graphql.Internal.convertResponse(r));
                  }) : undefined,
              uploadables: uploadables
            });
}

function use(param) {
  var match = ReactRelay.useMutation(UpdateManagerBuyer_Mutation_graphql.node);
  var mutate = match[0];
  return [
          React.useMemo((function () {
                  return function (param, param$1, param$2, param$3, param$4, param$5, param$6, param$7, param$8) {
                    return Curry._1(mutate, {
                                onError: param,
                                onCompleted: param$1 !== undefined ? (function (r, errors) {
                                      Curry._2(param$1, UpdateManagerBuyer_Mutation_graphql.Internal.convertResponse(r), (errors == null) ? undefined : Caml_option.some(errors));
                                    }) : undefined,
                                onUnsubscribe: param$2,
                                optimisticResponse: param$3 !== undefined ? UpdateManagerBuyer_Mutation_graphql.Internal.convertWrapRawResponse(param$3) : undefined,
                                optimisticUpdater: param$4,
                                updater: param$5 !== undefined ? (function (store, r) {
                                      Curry._2(param$5, store, UpdateManagerBuyer_Mutation_graphql.Internal.convertResponse(r));
                                    }) : undefined,
                                variables: UpdateManagerBuyer_Mutation_graphql.Internal.convertVariables(param$6),
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

function Update_Manager_Buyer(Props) {
  var isOpen = Props.isOpen;
  var onClose = Props.onClose;
  var defaultValueOpt = Props.defaultValue;
  var defaultValue = defaultValueOpt !== undefined ? defaultValueOpt : "";
  var match = ValidatedState.use(/* String */0, defaultValue, []);
  var setManager = match[1];
  var manager = match[0];
  var match$1 = use(undefined);
  var mutate = match$1[0];
  var match$2 = ReactToastNotifications.useToasts();
  var addToast = match$2.addToast;
  var handleOnChange = function (e) {
    var value = e.target.value;
    Curry._3(setManager, value, true, undefined);
  };
  var handleOnSubmit = function (param) {
    return ReactEvents.interceptingHandler((function (param) {
                  Curry.app(mutate, [
                        (function (err) {
                            addToast(React.createElement("div", {
                                      className: "flex items-center"
                                    }, React.createElement(IconError.make, {
                                          width: "24",
                                          height: "24",
                                          className: "mr-2"
                                        }), "오류가 발생하였습니다. 회사명를 확인하세요.", err.message), {
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
                                                }), "오류가 발생하였습니다. 회사명를 확인하세요."), {
                                          appearance: "error"
                                        });
                            } else if (variant === "User") {
                              addToast(React.createElement("div", {
                                        className: "flex items-center"
                                      }, React.createElement(IconCheck.make, {
                                            height: "24",
                                            width: "24",
                                            fill: "#12B564",
                                            className: "mr-2"
                                          }), "담당자명이 저장되었습니다."), {
                                    appearance: "success"
                                  });
                              return Curry._1(onClose, undefined);
                            } else {
                              return addToast(React.createElement("div", {
                                              className: "flex items-center"
                                            }, React.createElement(IconError.make, {
                                                  width: "24",
                                                  height: "24",
                                                  className: "mr-2"
                                                }), "오류가 발생하였습니다. 회사명를 확인하세요.", Belt_Option.getWithDefault(updateUser.VAL.message, "")), {
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
                            manager: manager
                          }
                        },
                        undefined,
                        undefined
                      ]);
                }), param);
  };
  React.useEffect((function () {
          if (!isOpen) {
            Curry._3(setManager, defaultValue, undefined, undefined);
          }
          
        }), [isOpen]);
  return React.createElement(ReactDialog.Root, {
              children: null,
              open: isOpen
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
                                      }, "담당자명 수정")), React.createElement(ReactDialog.Close, {
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
                                onSubmit: handleOnSubmit
                              }, React.createElement("div", {
                                    className: "flex flex-col "
                                  }, React.createElement("div", {
                                        className: "flex flex-col mb-10"
                                      }, React.createElement("div", {
                                            className: "mb-2"
                                          }, React.createElement("label", {
                                                className: "font-bold"
                                              }, "담당자명")), React.createElement("input", {
                                            className: "w-full border border-border-default-L1 p-3 rounded-xl focus:outline-none",
                                            placeholder: "담당자명을 입력해 주세요",
                                            value: manager,
                                            onChange: handleOnChange
                                          })), React.createElement("button", {
                                        className: Cx.cx([
                                              "rounded-xl w-full py-4",
                                              manager === "" ? "bg-disabled-L2" : "bg-green-500"
                                            ]),
                                        disabled: manager === "" || match$1[1],
                                        type: "submit"
                                      }, React.createElement("span", {
                                            className: "text-white"
                                          }, "저장")))))),
                  className: "dialog-content-plain bottom-0 left-0 xl:bottom-auto xl:left-auto xl:rounded-2xl xl:state-open:top-1/2 xl:state-open:left-1/2 xl:state-open:-translate-x-1/2 xl:state-open:-translate-y-1/2"
                }));
}

var make = Update_Manager_Buyer;

export {
  Mutation ,
  make ,
}
/* react Not a pure module */
