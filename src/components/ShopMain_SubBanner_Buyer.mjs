// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Curry from "rescript/lib/es6/curry.js";
import * as React from "react";
import Link from "next/link";
import * as Belt_Array from "rescript/lib/es6/belt_Array.js";
import * as Js_promise from "rescript/lib/es6/js_promise.js";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as ReactRelay from "react-relay";
import * as RescriptRelay from "rescript-relay/src/RescriptRelay.mjs";
import * as RelayRuntime from "relay-runtime";
import * as RescriptRelay_Internal from "rescript-relay/src/RescriptRelay_Internal.mjs";
import * as ShopMainSubBannerBuyerQuery_graphql from "../__generated__/ShopMainSubBannerBuyerQuery_graphql.mjs";

function use(variables, fetchPolicy, fetchKey, networkCacheConfig, param) {
  var data = ReactRelay.useLazyLoadQuery(ShopMainSubBannerBuyerQuery_graphql.node, RescriptRelay_Internal.internal_cleanObjectFromUndefinedRaw(ShopMainSubBannerBuyerQuery_graphql.Internal.convertVariables(variables)), {
        fetchKey: fetchKey,
        fetchPolicy: RescriptRelay.mapFetchPolicy(fetchPolicy),
        networkCacheConfig: networkCacheConfig
      });
  return RescriptRelay_Internal.internal_useConvertedValue(ShopMainSubBannerBuyerQuery_graphql.Internal.convertResponse, data);
}

function useLoader(param) {
  var match = ReactRelay.useQueryLoader(ShopMainSubBannerBuyerQuery_graphql.node);
  var loadQueryFn = match[1];
  var loadQuery = React.useMemo((function () {
          return function (param, param$1, param$2, param$3) {
            return Curry._2(loadQueryFn, ShopMainSubBannerBuyerQuery_graphql.Internal.convertVariables(param), {
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
  ReactRelay.fetchQuery(environment, ShopMainSubBannerBuyerQuery_graphql.node, ShopMainSubBannerBuyerQuery_graphql.Internal.convertVariables(variables), {
          networkCacheConfig: networkCacheConfig,
          fetchPolicy: RescriptRelay.mapFetchQueryFetchPolicy(fetchPolicy)
        }).subscribe({
        next: (function (res) {
            Curry._1(onResult, {
                  TAG: /* Ok */0,
                  _0: ShopMainSubBannerBuyerQuery_graphql.Internal.convertResponse(res)
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
  var __x = ReactRelay.fetchQuery(environment, ShopMainSubBannerBuyerQuery_graphql.node, ShopMainSubBannerBuyerQuery_graphql.Internal.convertVariables(variables), {
          networkCacheConfig: networkCacheConfig,
          fetchPolicy: RescriptRelay.mapFetchQueryFetchPolicy(fetchPolicy)
        }).toPromise();
  return Js_promise.then_((function (res) {
                return Promise.resolve(ShopMainSubBannerBuyerQuery_graphql.Internal.convertResponse(res));
              }), __x);
}

function usePreloaded(queryRef, param) {
  var data = ReactRelay.usePreloadedQuery(ShopMainSubBannerBuyerQuery_graphql.node, queryRef);
  return RescriptRelay_Internal.internal_useConvertedValue(ShopMainSubBannerBuyerQuery_graphql.Internal.convertResponse, data);
}

function retain(environment, variables) {
  var operationDescriptor = RelayRuntime.createOperationDescriptor(ShopMainSubBannerBuyerQuery_graphql.node, ShopMainSubBannerBuyerQuery_graphql.Internal.convertVariables(variables));
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

function ShopMain_SubBanner_Buyer$PC$Placeholder(Props) {
  return React.createElement("div", {
              className: "w-full flex flex-col gap-3"
            }, Belt_Array.map([
                  1,
                  2,
                  3
                ], (function (idx) {
                    return React.createElement("div", {
                                key: "sub-banner-skeleton-" + String(idx) + "",
                                className: "flex flex-1 aspect-[300/124] rounded-xl animate-pulse bg-gray-150"
                              });
                  })));
}

var Placeholder = {
  make: ShopMain_SubBanner_Buyer$PC$Placeholder
};

function ShopMain_SubBanner_Buyer$PC(Props) {
  var match = use(undefined, undefined, undefined, undefined, undefined);
  return React.createElement("div", {
              className: "w-full flex flex-col gap-3"
            }, Belt_Array.map(match.subBanners, (function (param) {
                    var key = "sub-banner-" + param.id + "";
                    var target = param.isNewTabPc ? "_blank" : "_self";
                    return React.createElement("div", {
                                key: key,
                                className: "flex flex-1 aspect-[300/124] rounded-xl overflow-hidden interactable"
                              }, React.createElement(Link, {
                                    href: param.landingUrl,
                                    children: React.createElement("a", {
                                          className: "w-full h-full",
                                          target: target
                                        }, React.createElement("img", {
                                              className: "w-full h-full object-cover",
                                              alt: key,
                                              src: param.imageUrlPc
                                            }))
                                  }));
                  })));
}

var PC = {
  Placeholder: Placeholder,
  make: ShopMain_SubBanner_Buyer$PC
};

function ShopMain_SubBanner_Buyer$MO$Placeholder(Props) {
  return React.createElement("div", {
              className: "w-full flex items-center gap-[10px]"
            }, Belt_Array.map([
                  1,
                  2,
                  3
                ], (function (idx) {
                    return React.createElement("div", {
                                key: "sub-banner-skeleton-" + String(idx) + "",
                                className: "flex flex-1 aspect-[228/168] rounded-xl animate-pulse bg-gray-150"
                              });
                  })));
}

var Placeholder$1 = {
  make: ShopMain_SubBanner_Buyer$MO$Placeholder
};

function ShopMain_SubBanner_Buyer$MO(Props) {
  var match = use(undefined, undefined, undefined, undefined, undefined);
  return React.createElement("div", {
              className: "w-full flex items-center gap-[10px]"
            }, Belt_Array.map(match.subBanners, (function (param) {
                    var key = "sub-banner-" + param.id + "";
                    var target = param.isNewTabMobile ? "_blank" : "_self";
                    return React.createElement("div", {
                                key: key,
                                className: "flex flex-1 aspect-[228/168] rounded-xl overflow-hidden interactable"
                              }, React.createElement(Link, {
                                    href: param.landingUrl,
                                    children: React.createElement("a", {
                                          className: "w-full h-full",
                                          target: target
                                        }, React.createElement("img", {
                                              className: "w-full h-full object-cover",
                                              alt: key,
                                              src: param.imageUrlMobile
                                            }))
                                  }));
                  })));
}

var MO = {
  Placeholder: Placeholder$1,
  make: ShopMain_SubBanner_Buyer$MO
};

export {
  Query ,
  PC ,
  MO ,
}
/* react Not a pure module */
