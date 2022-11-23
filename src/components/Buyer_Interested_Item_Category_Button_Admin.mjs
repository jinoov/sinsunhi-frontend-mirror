// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Curry from "rescript/lib/es6/curry.js";
import * as React from "react";
import * as IconClose from "./svgs/IconClose.mjs";
import * as Belt_Array from "rescript/lib/es6/belt_Array.js";
import * as Js_promise from "rescript/lib/es6/js_promise.js";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as ReactRelay from "react-relay";
import * as RescriptRelay from "rescript-relay/src/RescriptRelay.mjs";
import * as RelayRuntime from "relay-runtime";
import * as ReactDialog from "@radix-ui/react-dialog";
import * as RescriptRelay_Internal from "rescript-relay/src/RescriptRelay_Internal.mjs";
import * as BuyerInterestedItemCategoryButtonAdminQuery_graphql from "../__generated__/BuyerInterestedItemCategoryButtonAdminQuery_graphql.mjs";

function use(variables, fetchPolicy, fetchKey, networkCacheConfig, param) {
  var data = ReactRelay.useLazyLoadQuery(BuyerInterestedItemCategoryButtonAdminQuery_graphql.node, RescriptRelay_Internal.internal_cleanObjectFromUndefinedRaw(BuyerInterestedItemCategoryButtonAdminQuery_graphql.Internal.convertVariables(variables)), {
        fetchKey: fetchKey,
        fetchPolicy: RescriptRelay.mapFetchPolicy(fetchPolicy),
        networkCacheConfig: networkCacheConfig
      });
  return RescriptRelay_Internal.internal_useConvertedValue(BuyerInterestedItemCategoryButtonAdminQuery_graphql.Internal.convertResponse, data);
}

function useLoader(param) {
  var match = ReactRelay.useQueryLoader(BuyerInterestedItemCategoryButtonAdminQuery_graphql.node);
  var loadQueryFn = match[1];
  var loadQuery = React.useMemo((function () {
          return function (param, param$1, param$2, param$3) {
            return Curry._2(loadQueryFn, BuyerInterestedItemCategoryButtonAdminQuery_graphql.Internal.convertVariables(param), {
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
  ReactRelay.fetchQuery(environment, BuyerInterestedItemCategoryButtonAdminQuery_graphql.node, BuyerInterestedItemCategoryButtonAdminQuery_graphql.Internal.convertVariables(variables), {
          networkCacheConfig: networkCacheConfig,
          fetchPolicy: RescriptRelay.mapFetchQueryFetchPolicy(fetchPolicy)
        }).subscribe({
        next: (function (res) {
            Curry._1(onResult, {
                  TAG: /* Ok */0,
                  _0: BuyerInterestedItemCategoryButtonAdminQuery_graphql.Internal.convertResponse(res)
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
  var __x = ReactRelay.fetchQuery(environment, BuyerInterestedItemCategoryButtonAdminQuery_graphql.node, BuyerInterestedItemCategoryButtonAdminQuery_graphql.Internal.convertVariables(variables), {
          networkCacheConfig: networkCacheConfig,
          fetchPolicy: RescriptRelay.mapFetchQueryFetchPolicy(fetchPolicy)
        }).toPromise();
  return Js_promise.then_((function (res) {
                return Promise.resolve(BuyerInterestedItemCategoryButtonAdminQuery_graphql.Internal.convertResponse(res));
              }), __x);
}

function usePreloaded(queryRef, param) {
  var data = ReactRelay.usePreloadedQuery(BuyerInterestedItemCategoryButtonAdminQuery_graphql.node, queryRef);
  return RescriptRelay_Internal.internal_useConvertedValue(BuyerInterestedItemCategoryButtonAdminQuery_graphql.Internal.convertResponse, data);
}

function retain(environment, variables) {
  var operationDescriptor = RelayRuntime.createOperationDescriptor(BuyerInterestedItemCategoryButtonAdminQuery_graphql.node, BuyerInterestedItemCategoryButtonAdminQuery_graphql.Internal.convertVariables(variables));
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

function Buyer_Interested_Item_Category_Button_Admin$Items$Capsule(Props) {
  var label = Props.label;
  return React.createElement("li", {
              className: "bg-enabled-L5 px-4 py-2 rounded-full"
            }, label);
}

var Capsule = {
  make: Buyer_Interested_Item_Category_Button_Admin$Items$Capsule
};

function Buyer_Interested_Item_Category_Button_Admin$Items(Props) {
  var ids = Props.ids;
  var queryData = use({
        ids: ids
      }, undefined, undefined, undefined, undefined);
  var items = Belt_Option.flatMap(queryData.itemCategoriesListing, (function (listing) {
          return listing.itemCategories;
        }));
  return React.createElement("ul", {
              className: "flex flex-wrap gap-2"
            }, items !== undefined ? Belt_Array.map(items, (function (i) {
                      return React.createElement(Buyer_Interested_Item_Category_Button_Admin$Items$Capsule, {
                                  label: i.name,
                                  key: i.id
                                });
                    })) : React.createElement("li", undefined, "선택 없음"));
}

var Items = {
  Capsule: Capsule,
  make: Buyer_Interested_Item_Category_Button_Admin$Items
};

function Buyer_Interested_Item_Category_Button_Admin(Props) {
  var itemIds = Props.itemIds;
  return React.createElement(ReactDialog.Root, {
              children: null
            }, React.createElement(ReactDialog.Overlay, {
                  className: "dialog-overlay"
                }), itemIds !== undefined ? React.createElement(ReactDialog.Trigger, {
                    children: "조회하기",
                    className: "text-base focus:outline-none bg-primary-light rounded-lg text-primary py-1 px-5"
                  }) : React.createElement("div", {
                    className: "text-base focus:outline-none bg-disabled-L3 text-disabled-L2 rounded-lg py-1 px-5 inline-block"
                  }, "조회하기"), React.createElement(ReactDialog.Content, {
                  children: null,
                  className: "dialog-content-detail overflow-y-auto rounded-2xl",
                  onOpenAutoFocus: (function (prim) {
                      prim.preventDefault();
                    })
                }, React.createElement("section", {
                      className: "flex p-5"
                    }, React.createElement("h3", {
                          className: "text-lg font-bold"
                        }, "관심품목 조회"), React.createElement(ReactDialog.Close, {
                          children: React.createElement(IconClose.make, {
                                height: "24",
                                width: "24",
                                fill: "#262626"
                              }),
                          className: "focus:outline-none ml-auto"
                        })), React.createElement("section", {
                      className: "p-5 pt-0"
                    }, React.createElement(React.Suspense, {
                          children: React.createElement(Buyer_Interested_Item_Category_Button_Admin$Items, {
                                ids: itemIds
                              }),
                          fallback: React.createElement("div", undefined, "검색 중")
                        }))));
}

var make = Buyer_Interested_Item_Category_Button_Admin;

export {
  Query ,
  Items ,
  make ,
}
/* react Not a pure module */
