// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Curry from "rescript/lib/es6/curry.js";
import * as React from "react";
import * as IconClose from "./svgs/IconClose.mjs";
import * as Belt_Array from "rescript/lib/es6/belt_Array.js";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as RescriptRelay from "rescript-relay/src/RescriptRelay.mjs";
import * as RelayRuntime from "relay-runtime";
import * as Hooks from "react-relay/hooks";
import * as ReactDialog from "@radix-ui/react-dialog";
import * as RescriptRelay_Internal from "rescript-relay/src/RescriptRelay_Internal.mjs";
import * as BulkSaleProducerApplicationWithdrawnButton_Query_graphql from "../__generated__/BulkSaleProducerApplicationWithdrawnButton_Query_graphql.mjs";

function use(variables, fetchPolicy, fetchKey, networkCacheConfig, param) {
  var data = Hooks.useLazyLoadQuery(BulkSaleProducerApplicationWithdrawnButton_Query_graphql.node, RescriptRelay_Internal.internal_cleanObjectFromUndefinedRaw(BulkSaleProducerApplicationWithdrawnButton_Query_graphql.Internal.convertVariables(variables)), {
        fetchKey: fetchKey,
        fetchPolicy: RescriptRelay.mapFetchPolicy(fetchPolicy),
        networkCacheConfig: networkCacheConfig
      });
  return RescriptRelay_Internal.internal_useConvertedValue(BulkSaleProducerApplicationWithdrawnButton_Query_graphql.Internal.convertResponse, data);
}

function useLoader(param) {
  var match = Hooks.useQueryLoader(BulkSaleProducerApplicationWithdrawnButton_Query_graphql.node);
  var loadQueryFn = match[1];
  var loadQuery = React.useMemo((function () {
          return function (param, param$1, param$2, param$3) {
            return Curry._2(loadQueryFn, BulkSaleProducerApplicationWithdrawnButton_Query_graphql.Internal.convertVariables(param), {
                        fetchPolicy: param$1,
                        networkCacheConfig: param$2
                      });
          };
        }), [loadQueryFn]);
  return [
          Caml_option.nullable_to_opt(match[0]),
          loadQuery,
          match[2]
        ];
}

function $$fetch(environment, variables, onResult, networkCacheConfig, fetchPolicy, param) {
  Hooks.fetchQuery(environment, BulkSaleProducerApplicationWithdrawnButton_Query_graphql.node, BulkSaleProducerApplicationWithdrawnButton_Query_graphql.Internal.convertVariables(variables), {
          networkCacheConfig: networkCacheConfig,
          fetchPolicy: RescriptRelay.mapFetchQueryFetchPolicy(fetchPolicy)
        }).subscribe({
        next: (function (res) {
            return Curry._1(onResult, {
                        TAG: /* Ok */0,
                        _0: BulkSaleProducerApplicationWithdrawnButton_Query_graphql.Internal.convertResponse(res)
                      });
          }),
        error: (function (err) {
            return Curry._1(onResult, {
                        TAG: /* Error */1,
                        _0: err
                      });
          })
      });
  
}

function fetchPromised(environment, variables, networkCacheConfig, fetchPolicy, param) {
  var __x = Hooks.fetchQuery(environment, BulkSaleProducerApplicationWithdrawnButton_Query_graphql.node, BulkSaleProducerApplicationWithdrawnButton_Query_graphql.Internal.convertVariables(variables), {
          networkCacheConfig: networkCacheConfig,
          fetchPolicy: RescriptRelay.mapFetchQueryFetchPolicy(fetchPolicy)
        }).toPromise();
  return __x.then(function (res) {
              return Promise.resolve(BulkSaleProducerApplicationWithdrawnButton_Query_graphql.Internal.convertResponse(res));
            });
}

function usePreloaded(queryRef, param) {
  var data = Hooks.usePreloadedQuery(BulkSaleProducerApplicationWithdrawnButton_Query_graphql.node, queryRef);
  return RescriptRelay_Internal.internal_useConvertedValue(BulkSaleProducerApplicationWithdrawnButton_Query_graphql.Internal.convertResponse, data);
}

function retain(environment, variables) {
  var operationDescriptor = RelayRuntime.createOperationDescriptor(BulkSaleProducerApplicationWithdrawnButton_Query_graphql.node, BulkSaleProducerApplicationWithdrawnButton_Query_graphql.Internal.convertVariables(variables));
  return environment.retain(operationDescriptor);
}

var Query_makeVariables = BulkSaleProducerApplicationWithdrawnButton_Query_graphql.Utils.makeVariables;

var Query = {
  makeVariables: Query_makeVariables,
  Types: undefined,
  use: use,
  useLoader: useLoader,
  $$fetch: $$fetch,
  fetchPromised: fetchPromised,
  usePreloaded: usePreloaded,
  retain: retain
};

function BulkSale_Producer_Application_Withdrawn_Button$Reasons(Props) {
  var applicationId = Props.applicationId;
  var match = use({
        applicationId: applicationId
      }, undefined, undefined, undefined, undefined);
  return React.createElement("ul", {
              className: "py-5 border border-disabled-L2 border-x-0"
            }, Belt_Array.mapWithIndex(match.reasons, (function (i, r) {
                    return React.createElement("li", {
                                key: applicationId + "-" + String(i),
                                className: "list-disc list-inside mt-5 first-of-type:mt-0 font-bold"
                              }, r);
                  })));
}

var Reasons = {
  make: BulkSale_Producer_Application_Withdrawn_Button$Reasons
};

function BulkSale_Producer_Application_Withdrawn_Button(Props) {
  var applicationId = Props.applicationId;
  var match = React.useState(function () {
        return false;
      });
  var setShow = match[1];
  return React.createElement(ReactDialog.Root, {
              children: null,
              open: match[0]
            }, React.createElement(ReactDialog.Overlay, {
                  className: "dialog-overlay"
                }), React.createElement(ReactDialog.Trigger, {
                  onClick: (function (param) {
                      return setShow(function (param) {
                                  return true;
                                });
                    }),
                  children: React.createElement("span", {
                        className: "block mt-[10px] underline"
                      }, "취소사유"),
                  className: "absolute top-9 left-0 text-text-L2 focus:outline-none text-left underline"
                }), React.createElement(ReactDialog.Content, {
                  children: React.createElement("section", {
                        className: "p-5"
                      }, React.createElement("article", {
                            className: "flex"
                          }, React.createElement("h2", {
                                className: "text-xl font-bold"
                              }, "판매 취소 사유"), React.createElement(ReactDialog.Close, {
                                onClick: (function (param) {
                                    return setShow(function (param) {
                                                return false;
                                              });
                                  }),
                                children: React.createElement(IconClose.make, {
                                      height: "24",
                                      width: "24",
                                      fill: "#262626"
                                    }),
                                className: "inline-block p-1 focus:outline-none ml-auto"
                              })), React.createElement("article", {
                            className: "mt-5"
                          }, React.createElement("div", {
                                className: "pb-5"
                              }, "농민이 안심판매 신청을 취소한 사유입니다."), React.createElement(React.Suspense, {
                                children: React.createElement(BulkSale_Producer_Application_Withdrawn_Button$Reasons, {
                                      applicationId: applicationId
                                    }),
                                fallback: null
                              })), React.createElement("article", {
                            className: "flex justify-center items-center mt-5"
                          }, React.createElement(ReactDialog.Close, {
                                onClick: (function (param) {
                                    return setShow(function (param) {
                                                return false;
                                              });
                                  }),
                                children: React.createElement("span", {
                                      className: "btn-level6 py-3 px-5",
                                      id: "btn-close"
                                    }, "닫기"),
                                className: "flex mr-2"
                              }))),
                  className: "dialog-content overflow-y-auto"
                }));
}

var make = BulkSale_Producer_Application_Withdrawn_Button;

export {
  Query ,
  Reasons ,
  make ,
  
}
/* react Not a pure module */