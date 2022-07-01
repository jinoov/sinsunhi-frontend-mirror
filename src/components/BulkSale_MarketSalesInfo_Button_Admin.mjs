// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Curry from "rescript/lib/es6/curry.js";
import * as React from "react";
import * as IconClose from "./svgs/IconClose.mjs";
import * as Belt_Array from "rescript/lib/es6/belt_Array.js";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as RescriptRelay from "rescript-relay/src/RescriptRelay.mjs";
import * as Js_null_undefined from "rescript/lib/es6/js_null_undefined.js";
import * as Hooks from "react-relay/hooks";
import * as ReactDialog from "@radix-ui/react-dialog";
import * as RescriptRelay_Internal from "rescript-relay/src/RescriptRelay_Internal.mjs";
import * as BulkSale_RawProductSaleLedgers_Admin from "./BulkSale_RawProductSaleLedgers_Admin.mjs";
import * as BulkSaleMarketSalesInfoButtonAdminFragment_graphql from "../__generated__/BulkSaleMarketSalesInfoButtonAdminFragment_graphql.mjs";
import * as BulkSaleMarketSalesInfoButtonAdminRefetchQuery_graphql from "../__generated__/BulkSaleMarketSalesInfoButtonAdminRefetchQuery_graphql.mjs";

function internal_makeRefetchableFnOpts(fetchPolicy, onComplete, param) {
  var tmp = {};
  var tmp$1 = RescriptRelay.mapFetchPolicy(fetchPolicy);
  if (tmp$1 !== undefined) {
    tmp.fetchPolicy = Caml_option.valFromOption(tmp$1);
  }
  var tmp$2 = RescriptRelay_Internal.internal_nullableToOptionalExnHandler(onComplete);
  if (tmp$2 !== undefined) {
    tmp.onComplete = Caml_option.valFromOption(tmp$2);
  }
  return tmp;
}

function useRefetchable(fRef) {
  var match = Hooks.useRefetchableFragment(BulkSaleMarketSalesInfoButtonAdminFragment_graphql.node, fRef);
  var refetchFn = match[1];
  var data = RescriptRelay_Internal.internal_useConvertedValue(BulkSaleMarketSalesInfoButtonAdminFragment_graphql.Internal.convertFragment, match[0]);
  return [
          data,
          React.useMemo((function () {
                  return function (param, param$1, param$2, param$3) {
                    return Curry._2(refetchFn, RescriptRelay_Internal.internal_cleanObjectFromUndefinedRaw(BulkSaleMarketSalesInfoButtonAdminRefetchQuery_graphql.Internal.convertVariables(param)), internal_makeRefetchableFnOpts(param$1, param$2, undefined));
                  };
                }), [refetchFn])
        ];
}

function use(fRef) {
  var data = Hooks.useFragment(BulkSaleMarketSalesInfoButtonAdminFragment_graphql.node, fRef);
  return RescriptRelay_Internal.internal_useConvertedValue(BulkSaleMarketSalesInfoButtonAdminFragment_graphql.Internal.convertFragment, data);
}

function useOpt(opt_fRef) {
  var fr = opt_fRef !== undefined ? Caml_option.some(Caml_option.valFromOption(opt_fRef)) : undefined;
  var nullableFragmentData = Hooks.useFragment(BulkSaleMarketSalesInfoButtonAdminFragment_graphql.node, fr !== undefined ? Js_null_undefined.fromOption(Caml_option.some(Caml_option.valFromOption(fr))) : null);
  var data = (nullableFragmentData == null) ? undefined : Caml_option.some(nullableFragmentData);
  return RescriptRelay_Internal.internal_useConvertedValue((function (rawFragment) {
                if (rawFragment !== undefined) {
                  return BulkSaleMarketSalesInfoButtonAdminFragment_graphql.Internal.convertFragment(rawFragment);
                }
                
              }), data);
}

function usePagination(fr) {
  var p = Hooks.usePaginationFragment(BulkSaleMarketSalesInfoButtonAdminFragment_graphql.node, fr);
  var data = RescriptRelay_Internal.internal_useConvertedValue(BulkSaleMarketSalesInfoButtonAdminFragment_graphql.Internal.convertFragment, p.data);
  return {
          data: data,
          loadNext: React.useMemo((function () {
                  return function (param, param$1, param$2) {
                    return p.loadNext(param, {
                                onComplete: RescriptRelay_Internal.internal_nullableToOptionalExnHandler(param$1)
                              });
                  };
                }), [p.loadNext]),
          loadPrevious: React.useMemo((function () {
                  return function (param, param$1, param$2) {
                    return p.loadPrevious(param, {
                                onComplete: RescriptRelay_Internal.internal_nullableToOptionalExnHandler(param$1)
                              });
                  };
                }), [p.loadPrevious]),
          hasNext: p.hasNext,
          hasPrevious: p.hasPrevious,
          isLoadingNext: p.isLoadingNext,
          isLoadingPrevious: p.isLoadingPrevious,
          refetch: React.useMemo((function () {
                  return function (param, param$1, param$2, param$3) {
                    return p.refetch(RescriptRelay_Internal.internal_cleanObjectFromUndefinedRaw(BulkSaleMarketSalesInfoButtonAdminRefetchQuery_graphql.Internal.convertVariables(param)), internal_makeRefetchableFnOpts(param$1, param$2, undefined));
                  };
                }), [p.refetch])
        };
}

function useBlockingPagination(fRef) {
  var p = Hooks.useBlockingPaginationFragment(BulkSaleMarketSalesInfoButtonAdminFragment_graphql.node, fRef);
  var data = RescriptRelay_Internal.internal_useConvertedValue(BulkSaleMarketSalesInfoButtonAdminFragment_graphql.Internal.convertFragment, p.data);
  return {
          data: data,
          loadNext: React.useMemo((function () {
                  return function (param, param$1, param$2) {
                    return p.loadNext(param, {
                                onComplete: RescriptRelay_Internal.internal_nullableToOptionalExnHandler(param$1)
                              });
                  };
                }), [p.loadNext]),
          loadPrevious: React.useMemo((function () {
                  return function (param, param$1, param$2) {
                    return p.loadPrevious(param, {
                                onComplete: RescriptRelay_Internal.internal_nullableToOptionalExnHandler(param$1)
                              });
                  };
                }), [p.loadPrevious]),
          hasNext: p.hasNext,
          hasPrevious: p.hasPrevious,
          refetch: React.useMemo((function () {
                  return function (param, param$1, param$2, param$3) {
                    return p.refetch(RescriptRelay_Internal.internal_cleanObjectFromUndefinedRaw(BulkSaleMarketSalesInfoButtonAdminRefetchQuery_graphql.Internal.convertVariables(param)), internal_makeRefetchableFnOpts(param$1, param$2, undefined));
                  };
                }), [p.refetch])
        };
}

var makeRefetchVariables = BulkSaleMarketSalesInfoButtonAdminRefetchQuery_graphql.Types.makeRefetchVariables;

var Fragment_getConnectionNodes = BulkSaleMarketSalesInfoButtonAdminFragment_graphql.Utils.getConnectionNodes;

var Fragment = {
  getConnectionNodes: Fragment_getConnectionNodes,
  Types: undefined,
  internal_makeRefetchableFnOpts: internal_makeRefetchableFnOpts,
  useRefetchable: useRefetchable,
  use: use,
  useOpt: useOpt,
  usePagination: usePagination,
  useBlockingPagination: useBlockingPagination,
  makeRefetchVariables: makeRefetchVariables
};

function BulkSale_MarketSalesInfo_Button_Admin(Props) {
  var query = Props.query;
  var marketSales = use(query);
  return React.createElement(ReactDialog.Root, {
              children: null
            }, React.createElement(ReactDialog.Overlay, {
                  className: "dialog-overlay"
                }), marketSales.bulkSaleMarketSalesInfo.edges.length !== 0 ? React.createElement(ReactDialog.Trigger, {
                    children: "입력 내용 보기",
                    className: "underline text-text-L2 text-left"
                  }) : React.createElement("span", undefined, "아니오"), React.createElement(ReactDialog.Content, {
                  children: React.createElement("section", {
                        className: "p-5 text-text-L1"
                      }, React.createElement("article", {
                            className: "flex"
                          }, React.createElement("h2", {
                                className: "text-xl font-bold"
                              }, "출하 시장 정보"), React.createElement(ReactDialog.Close, {
                                children: React.createElement(IconClose.make, {
                                      height: "24",
                                      width: "24",
                                      fill: "#262626"
                                    }),
                                className: "inline-block p-1 focus:outline-none ml-auto"
                              })), React.createElement("h3", {
                            className: "mt-4"
                          }, "시장명"), React.createElement("article", {
                            className: "mt-2"
                          }, React.createElement("div", {
                                className: "bg-surface rounded-lg p-3"
                              }, Belt_Array.map(marketSales.bulkSaleMarketSalesInfo.edges, (function (edge) {
                                      return React.createElement("p", {
                                                  key: edge.cursor,
                                                  className: "text-text-L2"
                                                }, edge.node.farmMarket.name);
                                    })))), React.createElement(BulkSale_RawProductSaleLedgers_Admin.make, {
                            query: query
                          })),
                  className: "dialog-content overflow-y-auto"
                }));
}

var make = BulkSale_MarketSalesInfo_Button_Admin;

export {
  Fragment ,
  make ,
  
}
/* react Not a pure module */