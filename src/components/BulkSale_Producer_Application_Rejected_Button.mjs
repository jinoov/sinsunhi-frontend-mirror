// Generated by ReScript, PLEASE EDIT WITH CARE

import * as V from "../utils/V.mjs";
import * as Curry from "rescript/lib/es6/curry.js";
import * as Input from "./common/Input.mjs";
import * as React from "react";
import * as IconCheck from "./svgs/IconCheck.mjs";
import * as IconClose from "./svgs/IconClose.mjs";
import * as IconError from "./svgs/IconError.mjs";
import * as Belt_Array from "rescript/lib/es6/belt_Array.js";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as Belt_Result from "rescript/lib/es6/belt_Result.js";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as ReactRelay from "react-relay";
import * as Garter_Array from "@greenlabs/garter/src/Garter_Array.mjs";
import * as RelayRuntime from "relay-runtime";
import * as ReactDialog from "@radix-ui/react-dialog";
import * as ReactToastNotifications from "react-toast-notifications";
import * as BulkSaleProducerApplicationRejectedButtonMutation_graphql from "../__generated__/BulkSaleProducerApplicationRejectedButtonMutation_graphql.mjs";

function commitMutation(environment, variables, optimisticUpdater, optimisticResponse, updater, onCompleted, onError, uploadables, param) {
  return RelayRuntime.commitMutation(environment, {
              mutation: BulkSaleProducerApplicationRejectedButtonMutation_graphql.node,
              variables: BulkSaleProducerApplicationRejectedButtonMutation_graphql.Internal.convertVariables(variables),
              onCompleted: (function (res, err) {
                  if (onCompleted !== undefined) {
                    return Curry._2(onCompleted, BulkSaleProducerApplicationRejectedButtonMutation_graphql.Internal.convertResponse(res), (err == null) ? undefined : Caml_option.some(err));
                  }
                  
                }),
              onError: (function (err) {
                  if (onError !== undefined) {
                    return Curry._1(onError, (err == null) ? undefined : Caml_option.some(err));
                  }
                  
                }),
              optimisticResponse: optimisticResponse !== undefined ? BulkSaleProducerApplicationRejectedButtonMutation_graphql.Internal.convertWrapRawResponse(optimisticResponse) : undefined,
              optimisticUpdater: optimisticUpdater,
              updater: updater !== undefined ? (function (store, r) {
                    Curry._2(updater, store, BulkSaleProducerApplicationRejectedButtonMutation_graphql.Internal.convertResponse(r));
                  }) : undefined,
              uploadables: uploadables
            });
}

function use(param) {
  var match = ReactRelay.useMutation(BulkSaleProducerApplicationRejectedButtonMutation_graphql.node);
  var mutate = match[0];
  return [
          React.useMemo((function () {
                  return function (param, param$1, param$2, param$3, param$4, param$5, param$6, param$7, param$8) {
                    return Curry._1(mutate, {
                                onError: param,
                                onCompleted: param$1 !== undefined ? (function (r, errors) {
                                      Curry._2(param$1, BulkSaleProducerApplicationRejectedButtonMutation_graphql.Internal.convertResponse(r), (errors == null) ? undefined : Caml_option.some(errors));
                                    }) : undefined,
                                onUnsubscribe: param$2,
                                optimisticResponse: param$3 !== undefined ? BulkSaleProducerApplicationRejectedButtonMutation_graphql.Internal.convertWrapRawResponse(param$3) : undefined,
                                optimisticUpdater: param$4,
                                updater: param$5 !== undefined ? (function (store, r) {
                                      Curry._2(param$5, store, BulkSaleProducerApplicationRejectedButtonMutation_graphql.Internal.convertResponse(r));
                                    }) : undefined,
                                variables: BulkSaleProducerApplicationRejectedButtonMutation_graphql.Internal.convertVariables(param$6),
                                uploadables: param$7
                              });
                  };
                }), [mutate]),
          match[1]
        ];
}

var Mutation_bulkSaleApplicationProgress_decode = BulkSaleProducerApplicationRejectedButtonMutation_graphql.Utils.bulkSaleApplicationProgress_decode;

var Mutation_bulkSaleApplicationProgress_fromString = BulkSaleProducerApplicationRejectedButtonMutation_graphql.Utils.bulkSaleApplicationProgress_fromString;

var Mutation = {
  bulkSaleApplicationProgress_decode: Mutation_bulkSaleApplicationProgress_decode,
  bulkSaleApplicationProgress_fromString: Mutation_bulkSaleApplicationProgress_fromString,
  Operation: undefined,
  Types: undefined,
  commitMutation: commitMutation,
  use: use
};

function makeInput(progress, reason) {
  return {
          progress: progress,
          reason: reason
        };
}

function BulkSale_Producer_Application_Rejected_Button(props) {
  var refetchSummary = props.refetchSummary;
  var close = props.close;
  var _open = props._open;
  var application = props.application;
  var match = ReactToastNotifications.useToasts();
  var addToast = match.addToast;
  var match$1 = use(undefined);
  var isMutating = match$1[1];
  var mutate = match$1[0];
  var reason = Belt_Option.map(Belt_Array.get(application.bulkSaleEvaluations.edges, 0), (function (r) {
          return r.node.reason;
        }));
  var match$2 = React.useState(function () {
        return reason;
      });
  var setReason = match$2[1];
  var reason$1 = match$2[0];
  var match$3 = React.useState(function () {
        return [];
      });
  var setFormErrors = match$3[1];
  var match$4 = application.progress;
  var triggerStyle = match$4 === "REJECTED" ? "absolute top-9 left-0 text-text-L2 focus:outline-none text-left underline" : "hidden";
  return React.createElement(ReactDialog.Root, {
              children: null,
              _open: props.isShow
            }, React.createElement(ReactDialog.Overlay, {
                  className: "dialog-overlay"
                }), React.createElement(ReactDialog.Trigger, {
                  onClick: (function (param) {
                      Curry._1(_open, undefined);
                    }),
                  children: React.createElement("span", {
                        className: "block mt-[10px]"
                      }, "보류사유"),
                  className: triggerStyle
                }), React.createElement(ReactDialog.Content, {
                  children: React.createElement("section", {
                        className: "p-5"
                      }, React.createElement("article", {
                            className: "flex"
                          }, React.createElement("h2", {
                                className: "text-xl font-bold"
                              }, "판매 보류 사유"), React.createElement(ReactDialog.Close, {
                                onClick: (function (param) {
                                    Curry._1(close, undefined);
                                  }),
                                children: React.createElement(IconClose.make, {
                                      height: "24",
                                      width: "24",
                                      fill: "#262626"
                                    }),
                                className: "inline-block p-1 focus:outline-none ml-auto"
                              })), React.createElement("article", {
                            className: "mt-4 whitespace-pre"
                          }, React.createElement("p", undefined, "해당 사유는 농민에게 노출됩니다.\n신중히 입력 바랍니다.")), React.createElement("article", {
                            className: "mt-5"
                          }, React.createElement("h3", undefined, "내용"), React.createElement("div", {
                                className: "flex mt-2"
                              }, React.createElement(Input.make, {
                                    type_: "rejected-reason",
                                    name: "rejected-reason",
                                    placeholder: "내용 입력",
                                    className: "flex-1 mr-1",
                                    value: Belt_Option.getWithDefault(reason$1, ""),
                                    onChange: (function (param) {
                                        var cleanUpFn;
                                        var value = param.target.value;
                                        setReason(function (param) {
                                              return value;
                                            });
                                        if (cleanUpFn !== undefined) {
                                          return Curry._1(cleanUpFn, undefined);
                                        }
                                        
                                      }),
                                    error: Garter_Array.first(Belt_Array.keepMap(match$3[0], (function (error) {
                                                if (typeof error === "object" && error.NAME === "ErrorReason") {
                                                  return error.VAL;
                                                }
                                                
                                              })))
                                  }))), React.createElement("article", {
                            className: "flex justify-center items-center mt-5"
                          }, React.createElement(ReactDialog.Close, {
                                onClick: (function (param) {
                                    Curry._1(close, undefined);
                                  }),
                                children: React.createElement("span", {
                                      className: "btn-level6 py-3 px-5",
                                      id: "btn-close"
                                    }, "닫기"),
                                className: "flex mr-2"
                              }), React.createElement("span", {
                                className: "flex mr-2"
                              }, React.createElement("button", {
                                    className: isMutating ? "btn-level1-disabled py-3 px-5" : "btn-level1 py-3 px-5",
                                    disabled: isMutating,
                                    onClick: (function (param) {
                                        var input = V.ap(V.map(makeInput, V.pure("REJECTED")), Belt_Result.map(V.$$Option.nonEmpty({
                                                      NAME: "ErrorReason",
                                                      VAL: "보류 사유를 입력해주세요"
                                                    }, reason$1), (function (r) {
                                                    return r;
                                                  })));
                                        if (input.TAG === /* Ok */0) {
                                          Curry.app(mutate, [
                                                (function (err) {
                                                    console.log(err);
                                                    addToast(React.createElement("div", {
                                                              className: "flex items-center"
                                                            }, React.createElement(IconError.make, {
                                                                  width: "24",
                                                                  height: "24",
                                                                  className: "mr-2"
                                                                }), err.message), {
                                                          appearance: "error"
                                                        });
                                                    setFormErrors(function (param) {
                                                          return [];
                                                        });
                                                  }),
                                                (function (param, param$1) {
                                                    addToast(React.createElement("div", {
                                                              className: "flex items-center"
                                                            }, React.createElement(IconCheck.make, {
                                                                  height: "24",
                                                                  width: "24",
                                                                  fill: "#12B564",
                                                                  className: "mr-2"
                                                                }), "수정 요청에 성공하였습니다."), {
                                                          appearance: "success"
                                                        });
                                                    Curry._1(close, undefined);
                                                    setFormErrors(function (param) {
                                                          return [];
                                                        });
                                                    Curry._1(refetchSummary, undefined);
                                                  }),
                                                undefined,
                                                undefined,
                                                undefined,
                                                undefined,
                                                {
                                                  id: application.id,
                                                  input: input._0
                                                },
                                                undefined,
                                                undefined
                                              ]);
                                          return ;
                                        }
                                        var errors = input._0;
                                        setFormErrors(function (param) {
                                              return errors;
                                            });
                                      })
                                  }, "저장")))),
                  className: "dialog-content overflow-y-auto"
                }));
}

var make = BulkSale_Producer_Application_Rejected_Button;

export {
  Mutation ,
  makeInput ,
  make ,
}
/* Input Not a pure module */
