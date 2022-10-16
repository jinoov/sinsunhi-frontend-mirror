// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Curry from "rescript/lib/es6/curry.js";
import * as React from "react";
import * as Js_dict from "rescript/lib/es6/js_dict.js";
import Head from "next/head";
import * as Belt_Array from "rescript/lib/es6/belt_Array.js";
import * as Js_promise from "rescript/lib/es6/js_promise.js";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as Router from "next/router";
import * as ReactRelay from "react-relay";
import * as RescriptRelay from "rescript-relay/src/RescriptRelay.mjs";
import * as RelayRuntime from "relay-runtime";
import * as ChannelTalkHelper from "../../../utils/ChannelTalkHelper.mjs";
import * as SectionMain_PC_Title from "./SectionMain_PC_Title.mjs";
import * as Matching_PLP_Category from "./Matching_PLP_Category.mjs";
import * as RescriptRelay_Internal from "rescript-relay/src/RescriptRelay_Internal.mjs";
import * as Matching_PLP_ProductList from "./Matching_PLP_ProductList.mjs";
import * as ShopProductListItem_Buyer from "../../../components/ShopProductListItem_Buyer.mjs";
import * as RescriptReactErrorBoundary from "@rescript/react/src/RescriptReactErrorBoundary.mjs";
import * as MatchingPLPGetCategoryNameQuery_graphql from "../../../__generated__/MatchingPLPGetCategoryNameQuery_graphql.mjs";

function use(variables, fetchPolicy, fetchKey, networkCacheConfig, param) {
  var data = ReactRelay.useLazyLoadQuery(MatchingPLPGetCategoryNameQuery_graphql.node, RescriptRelay_Internal.internal_cleanObjectFromUndefinedRaw(MatchingPLPGetCategoryNameQuery_graphql.Internal.convertVariables(variables)), {
        fetchKey: fetchKey,
        fetchPolicy: RescriptRelay.mapFetchPolicy(fetchPolicy),
        networkCacheConfig: networkCacheConfig
      });
  return RescriptRelay_Internal.internal_useConvertedValue(MatchingPLPGetCategoryNameQuery_graphql.Internal.convertResponse, data);
}

function useLoader(param) {
  var match = ReactRelay.useQueryLoader(MatchingPLPGetCategoryNameQuery_graphql.node);
  var loadQueryFn = match[1];
  var loadQuery = React.useMemo((function () {
          return function (param, param$1, param$2, param$3) {
            return Curry._2(loadQueryFn, MatchingPLPGetCategoryNameQuery_graphql.Internal.convertVariables(param), {
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
  ReactRelay.fetchQuery(environment, MatchingPLPGetCategoryNameQuery_graphql.node, MatchingPLPGetCategoryNameQuery_graphql.Internal.convertVariables(variables), {
          networkCacheConfig: networkCacheConfig,
          fetchPolicy: RescriptRelay.mapFetchQueryFetchPolicy(fetchPolicy)
        }).subscribe({
        next: (function (res) {
            Curry._1(onResult, {
                  TAG: /* Ok */0,
                  _0: MatchingPLPGetCategoryNameQuery_graphql.Internal.convertResponse(res)
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
  var __x = ReactRelay.fetchQuery(environment, MatchingPLPGetCategoryNameQuery_graphql.node, MatchingPLPGetCategoryNameQuery_graphql.Internal.convertVariables(variables), {
          networkCacheConfig: networkCacheConfig,
          fetchPolicy: RescriptRelay.mapFetchQueryFetchPolicy(fetchPolicy)
        }).toPromise();
  return Js_promise.then_((function (res) {
                return Promise.resolve(MatchingPLPGetCategoryNameQuery_graphql.Internal.convertResponse(res));
              }), __x);
}

function usePreloaded(queryRef, param) {
  var data = ReactRelay.usePreloadedQuery(MatchingPLPGetCategoryNameQuery_graphql.node, queryRef);
  return RescriptRelay_Internal.internal_useConvertedValue(MatchingPLPGetCategoryNameQuery_graphql.Internal.convertResponse, data);
}

function retain(environment, variables) {
  var operationDescriptor = RelayRuntime.createOperationDescriptor(MatchingPLPGetCategoryNameQuery_graphql.node, MatchingPLPGetCategoryNameQuery_graphql.Internal.convertVariables(variables));
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

function Matching_PLP$PC$View(Props) {
  var categoryName = Props.categoryName;
  var subCategoryName = Props.subCategoryName;
  return React.createElement(React.Fragment, undefined, React.createElement(SectionMain_PC_Title.make, {
                  title: "신선매칭"
                }), React.createElement(Matching_PLP_Category.PC.make, {
                  categoryName: categoryName
                }), React.createElement(Matching_PLP_ProductList.PC.make, {
                  subCategoryName: subCategoryName
                }));
}

var View = {
  make: Matching_PLP$PC$View
};

function Matching_PLP$PC$Skeleton(Props) {
  return React.createElement("div", {
              className: "w-[1280px] pt-20 px-5 pb-16 mx-auto"
            }, React.createElement("div", {
                  className: "w-[160px] h-[44px] rounded-lg animate-pulse bg-gray-150"
                }), React.createElement("section", {
                  className: "w-full mt-[88px]"
                }, React.createElement("ol", {
                      className: "grid grid-cols-4 gap-x-10 gap-y-16"
                    }, Belt_Array.map(Belt_Array.range(1, 300), (function (number) {
                            return React.createElement(ShopProductListItem_Buyer.PC.Placeholder.make, {
                                        key: "box-" + String(number) + ""
                                      });
                          })))));
}

var Skeleton = {
  make: Matching_PLP$PC$Skeleton
};

function Matching_PLP$PC(Props) {
  var router = Router.useRouter();
  var categoryId = Belt_Option.getWithDefault(Js_dict.get(router.query, "category-id"), "");
  var subCategoryId = Belt_Option.getWithDefault(Js_dict.get(router.query, "sub-category-id"), "");
  var categoryName = Belt_Option.mapWithDefault(use({
            displayCategoryId: categoryId
          }, undefined, undefined, undefined, undefined).node, "전체 상품", (function (node) {
          return "" + node.name + " 전체";
        }));
  var subCategoryName = Belt_Option.mapWithDefault(use({
            displayCategoryId: subCategoryId
          }, undefined, undefined, undefined, undefined).node, categoryName, (function (node) {
          return node.name;
        }));
  return React.createElement(Matching_PLP$PC$View, {
              categoryName: categoryName,
              subCategoryName: subCategoryName
            });
}

var PC = {
  View: View,
  Skeleton: Skeleton,
  make: Matching_PLP$PC
};

function Matching_PLP$MO$View(Props) {
  var categoryName = Props.categoryName;
  var subCategoryName = Props.subCategoryName;
  return React.createElement(React.Fragment, undefined, React.createElement(Matching_PLP_Category.MO.make, {
                  categoryName: categoryName
                }), React.createElement(Matching_PLP_ProductList.MO.make, {
                  subCategoryName: subCategoryName
                }));
}

var View$1 = {
  make: Matching_PLP$MO$View
};

function Matching_PLP$MO$Skeleton(Props) {
  return React.createElement("div", {
              className: "w-full"
            }, React.createElement(Matching_PLP_Category.MO.Skeleton.make, {}), React.createElement("ol", {
                  className: "grid grid-cols-2 gap-x-4 gap-y-8  px-5"
                }, Belt_Array.map(Belt_Array.range(1, 100), (function (num) {
                        return React.createElement(ShopProductListItem_Buyer.MO.Placeholder.make, {
                                    key: "list-item-skeleton-" + String(num) + ""
                                  });
                      }))));
}

var Skeleton$1 = {
  make: Matching_PLP$MO$Skeleton
};

function Matching_PLP$MO(Props) {
  var router = Router.useRouter();
  var categoryId = Belt_Option.getWithDefault(Js_dict.get(router.query, "category-id"), "");
  var subCategoryId = Belt_Option.getWithDefault(Js_dict.get(router.query, "sub-category-id"), "");
  var categoryName = Belt_Option.mapWithDefault(use({
            displayCategoryId: categoryId
          }, undefined, undefined, undefined, undefined).node, "전체 상품", (function (node) {
          return "" + node.name + " 전체";
        }));
  var subCategoryName = Belt_Option.mapWithDefault(use({
            displayCategoryId: subCategoryId
          }, undefined, undefined, undefined, undefined).node, categoryName, (function (node) {
          return node.name;
        }));
  return React.createElement(Matching_PLP$MO$View, {
              categoryName: categoryName,
              subCategoryName: subCategoryName
            });
}

var MO = {
  View: View$1,
  Skeleton: Skeleton$1,
  make: Matching_PLP$MO
};

function Matching_PLP$Skeleton(Props) {
  var deviceType = Props.deviceType;
  switch (deviceType) {
    case /* Unknown */0 :
        return null;
    case /* PC */1 :
        return React.createElement(Matching_PLP$PC$Skeleton, {});
    case /* Mobile */2 :
        return React.createElement(Matching_PLP$MO$Skeleton, {});
    
  }
}

var Skeleton$2 = {
  make: Matching_PLP$Skeleton
};

function Matching_PLP$Container(Props) {
  var deviceType = Props.deviceType;
  ChannelTalkHelper.Hook.use(undefined, undefined, undefined);
  switch (deviceType) {
    case /* Unknown */0 :
        return null;
    case /* PC */1 :
        return React.createElement(Matching_PLP$PC, {});
    case /* Mobile */2 :
        return React.createElement(Matching_PLP$MO, {});
    
  }
}

var Container = {
  make: Matching_PLP$Container
};

function Matching_PLP(Props) {
  var deviceType = Props.deviceType;
  var match = React.useState(function () {
        return false;
      });
  var setIsCsr = match[1];
  React.useEffect((function () {
          setIsCsr(function (param) {
                return true;
              });
        }), []);
  return React.createElement(React.Fragment, undefined, React.createElement(Head, {
                  children: React.createElement("title", undefined, "신선하이 신선매칭")
                }), React.createElement(RescriptReactErrorBoundary.make, {
                  children: React.createElement(React.Suspense, {
                        children: match[0] ? React.createElement(Matching_PLP$Container, {
                                deviceType: deviceType
                              }) : React.createElement(Matching_PLP$Skeleton, {
                                deviceType: deviceType
                              }),
                        fallback: React.createElement(Matching_PLP$Skeleton, {
                              deviceType: deviceType
                            })
                      }),
                  fallback: (function (param) {
                      return React.createElement(Matching_PLP$Skeleton, {
                                  deviceType: deviceType
                                });
                    })
                }));
}

var make = Matching_PLP;

export {
  Query ,
  PC ,
  MO ,
  Skeleton$2 as Skeleton,
  Container ,
  make ,
}
/* react Not a pure module */
