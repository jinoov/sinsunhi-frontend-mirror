// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Curry from "rescript/lib/es6/curry.js";
import * as React from "react";
import * as Js_dict from "rescript/lib/es6/js_dict.js";
import * as Js_promise from "rescript/lib/es6/js_promise.js";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as Router from "next/router";
import * as ReactRelay from "react-relay";
import * as CartLinkIcon from "../../../components/common/CartLinkIcon.mjs";
import * as HomeLinkIcon from "../../../components/HomeLinkIcon.mjs";
import * as RescriptRelay from "rescript-relay/src/RescriptRelay.mjs";
import * as RelayRuntime from "relay-runtime";
import * as RescriptRelay_Internal from "rescript-relay/src/RescriptRelay_Internal.mjs";
import * as RescriptReactErrorBoundary from "@rescript/react/src/RescriptReactErrorBoundary.mjs";
import * as PLPHeaderBuyerQuery_graphql from "../../../__generated__/PLPHeaderBuyerQuery_graphql.mjs";

function use(variables, fetchPolicy, fetchKey, networkCacheConfig, param) {
  var data = ReactRelay.useLazyLoadQuery(PLPHeaderBuyerQuery_graphql.node, RescriptRelay_Internal.internal_cleanObjectFromUndefinedRaw(PLPHeaderBuyerQuery_graphql.Internal.convertVariables(variables)), {
        fetchKey: fetchKey,
        fetchPolicy: RescriptRelay.mapFetchPolicy(fetchPolicy),
        networkCacheConfig: networkCacheConfig
      });
  return RescriptRelay_Internal.internal_useConvertedValue(PLPHeaderBuyerQuery_graphql.Internal.convertResponse, data);
}

function useLoader(param) {
  var match = ReactRelay.useQueryLoader(PLPHeaderBuyerQuery_graphql.node);
  var loadQueryFn = match[1];
  var loadQuery = React.useMemo((function () {
          return function (param, param$1, param$2, param$3) {
            return Curry._2(loadQueryFn, PLPHeaderBuyerQuery_graphql.Internal.convertVariables(param), {
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
  ReactRelay.fetchQuery(environment, PLPHeaderBuyerQuery_graphql.node, PLPHeaderBuyerQuery_graphql.Internal.convertVariables(variables), {
          networkCacheConfig: networkCacheConfig,
          fetchPolicy: RescriptRelay.mapFetchQueryFetchPolicy(fetchPolicy)
        }).subscribe({
        next: (function (res) {
            Curry._1(onResult, {
                  TAG: /* Ok */0,
                  _0: PLPHeaderBuyerQuery_graphql.Internal.convertResponse(res)
                });
          }),
        error: (function (err) {
            Curry._1(onResult, {
                  TAG: /* Error */1,
                  _0: err
                });
          })
      });
}

function fetchPromised(environment, variables, networkCacheConfig, fetchPolicy, param) {
  var __x = ReactRelay.fetchQuery(environment, PLPHeaderBuyerQuery_graphql.node, PLPHeaderBuyerQuery_graphql.Internal.convertVariables(variables), {
          networkCacheConfig: networkCacheConfig,
          fetchPolicy: RescriptRelay.mapFetchQueryFetchPolicy(fetchPolicy)
        }).toPromise();
  return Js_promise.then_((function (res) {
                return Promise.resolve(PLPHeaderBuyerQuery_graphql.Internal.convertResponse(res));
              }), __x);
}

function usePreloaded(queryRef, param) {
  var data = ReactRelay.usePreloadedQuery(PLPHeaderBuyerQuery_graphql.node, queryRef);
  return RescriptRelay_Internal.internal_useConvertedValue(PLPHeaderBuyerQuery_graphql.Internal.convertResponse, data);
}

function retain(environment, variables) {
  var operationDescriptor = RelayRuntime.createOperationDescriptor(PLPHeaderBuyerQuery_graphql.node, PLPHeaderBuyerQuery_graphql.Internal.convertVariables(variables));
  return environment.retain(operationDescriptor);
}

var Query = {
  Operation: undefined,
  Types: undefined,
  use: use,
  useLoader: useLoader,
  $$fetch: $$fetch,
  fetchPromised: fetchPromised,
  usePreloaded: usePreloaded,
  retain: retain
};

function PLP_Header_Buyer$DisplayCategoryName(props) {
  var match = use({
        displayCategoryId: props.displayCategoryId
      }, undefined, undefined, undefined, undefined);
  var node = match.node;
  var title;
  if (node !== undefined) {
    var match$1 = node.children;
    title = match$1.length !== 0 ? node.name : Belt_Option.mapWithDefault(node.parent, "", (function (parent) {
              return parent.name;
            }));
  } else {
    title = "";
  }
  return React.createElement("span", {
              className: "font-bold text-xl"
            }, title);
}

var DisplayCategoryName = {
  Query: Query,
  make: PLP_Header_Buyer$DisplayCategoryName
};

function PLP_Header_Buyer(props) {
  var router = Router.useRouter();
  var cid = Js_dict.get(router.query, "cid");
  var displayCategoryId = cid !== undefined ? cid : Js_dict.get(router.query, "category-id");
  var match = React.useState(function () {
        return false;
      });
  var setIsCsr = match[1];
  React.useEffect((function () {
          setIsCsr(function (param) {
                return true;
              });
        }), []);
  return React.createElement(React.Fragment, undefined, React.createElement("div", {
                  className: "w-full fixed top-0 left-0 z-10 bg-white"
                }, React.createElement("header", {
                      className: "w-full max-w-3xl mx-auto h-14 bg-white"
                    }, React.createElement("div", {
                          className: "px-5 py-4 flex w-full items-center"
                        }, React.createElement("div", {
                              className: "w-1/3 flex justify-start"
                            }, React.createElement("button", {
                                  onClick: (function (param) {
                                      router.back();
                                    })
                                }, React.createElement("img", {
                                      className: "w-6 h-6 rotate-180",
                                      src: "/assets/arrow-right.svg"
                                    }))), match[0] ? (
                            displayCategoryId !== undefined ? React.createElement(RescriptReactErrorBoundary.make, {
                                    children: null,
                                    fallback: (function (param) {
                                        return React.createElement("span", undefined);
                                      })
                                  }, React.createElement("div", {
                                        className: "w-1/3 flex justify-center"
                                      }, React.createElement(React.Suspense, {
                                            children: Caml_option.some(React.createElement(PLP_Header_Buyer$DisplayCategoryName, {
                                                      displayCategoryId: displayCategoryId
                                                    })),
                                            fallback: Caml_option.some(React.createElement("span", undefined))
                                          })), React.createElement("div", {
                                        className: "w-1/3 flex justify-end gap-2"
                                      }, React.createElement(CartLinkIcon.make, {}), React.createElement(HomeLinkIcon.make, {}))) : React.createElement(React.Fragment, undefined, React.createElement("div", {
                                        className: "w-1/3 flex justify-center"
                                      }, React.createElement("span", {
                                            className: "font-bold text-xl"
                                          }, "전체 상품")), React.createElement("div", {
                                        className: "w-1/3 flex justify-end gap-2"
                                      }, React.createElement(CartLinkIcon.make, {}), React.createElement(HomeLinkIcon.make, {})))
                          ) : React.createElement("span", undefined)))), React.createElement("div", {
                  className: "w-full h-14"
                }));
}

var make = PLP_Header_Buyer;

export {
  DisplayCategoryName ,
  make ,
}
/* react Not a pure module */
