// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Curry from "rescript/lib/es6/curry.js";
import * as React from "react";
import * as Belt_Array from "rescript/lib/es6/belt_Array.js";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as CustomHooks from "../utils/CustomHooks.mjs";
import * as Garter_Array from "@greenlabs/garter/src/Garter_Array.mjs";
import * as RescriptRelay from "rescript-relay/src/RescriptRelay.mjs";
import * as Js_null_undefined from "rescript/lib/es6/js_null_undefined.js";
import * as Hooks from "react-relay/hooks";
import * as IconDownloadCenter from "./svgs/IconDownloadCenter.mjs";
import * as RescriptRelay_Internal from "rescript-relay/src/RescriptRelay_Internal.mjs";
import * as BulkSaleRawProductSaleLedgersAdminFragment_graphql from "../__generated__/BulkSaleRawProductSaleLedgersAdminFragment_graphql.mjs";
import * as BulkSaleRawProductSaleLedgersAdminFragmentQuery_graphql from "../__generated__/BulkSaleRawProductSaleLedgersAdminFragmentQuery_graphql.mjs";

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
  var match = Hooks.useRefetchableFragment(BulkSaleRawProductSaleLedgersAdminFragment_graphql.node, fRef);
  var refetchFn = match[1];
  var data = RescriptRelay_Internal.internal_useConvertedValue(BulkSaleRawProductSaleLedgersAdminFragment_graphql.Internal.convertFragment, match[0]);
  return [
          data,
          React.useMemo((function () {
                  return function (param, param$1, param$2, param$3) {
                    return Curry._2(refetchFn, RescriptRelay_Internal.internal_cleanObjectFromUndefinedRaw(BulkSaleRawProductSaleLedgersAdminFragmentQuery_graphql.Internal.convertVariables(param)), internal_makeRefetchableFnOpts(param$1, param$2, undefined));
                  };
                }), [refetchFn])
        ];
}

function use(fRef) {
  var data = Hooks.useFragment(BulkSaleRawProductSaleLedgersAdminFragment_graphql.node, fRef);
  return RescriptRelay_Internal.internal_useConvertedValue(BulkSaleRawProductSaleLedgersAdminFragment_graphql.Internal.convertFragment, data);
}

function useOpt(opt_fRef) {
  var fr = opt_fRef !== undefined ? Caml_option.some(Caml_option.valFromOption(opt_fRef)) : undefined;
  var nullableFragmentData = Hooks.useFragment(BulkSaleRawProductSaleLedgersAdminFragment_graphql.node, fr !== undefined ? Js_null_undefined.fromOption(Caml_option.some(Caml_option.valFromOption(fr))) : null);
  var data = (nullableFragmentData == null) ? undefined : Caml_option.some(nullableFragmentData);
  return RescriptRelay_Internal.internal_useConvertedValue((function (rawFragment) {
                if (rawFragment !== undefined) {
                  return BulkSaleRawProductSaleLedgersAdminFragment_graphql.Internal.convertFragment(rawFragment);
                }
                
              }), data);
}

function usePagination(fr) {
  var p = Hooks.usePaginationFragment(BulkSaleRawProductSaleLedgersAdminFragment_graphql.node, fr);
  var data = RescriptRelay_Internal.internal_useConvertedValue(BulkSaleRawProductSaleLedgersAdminFragment_graphql.Internal.convertFragment, p.data);
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
                    return p.refetch(RescriptRelay_Internal.internal_cleanObjectFromUndefinedRaw(BulkSaleRawProductSaleLedgersAdminFragmentQuery_graphql.Internal.convertVariables(param)), internal_makeRefetchableFnOpts(param$1, param$2, undefined));
                  };
                }), [p.refetch])
        };
}

function useBlockingPagination(fRef) {
  var p = Hooks.useBlockingPaginationFragment(BulkSaleRawProductSaleLedgersAdminFragment_graphql.node, fRef);
  var data = RescriptRelay_Internal.internal_useConvertedValue(BulkSaleRawProductSaleLedgersAdminFragment_graphql.Internal.convertFragment, p.data);
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
                    return p.refetch(RescriptRelay_Internal.internal_cleanObjectFromUndefinedRaw(BulkSaleRawProductSaleLedgersAdminFragmentQuery_graphql.Internal.convertVariables(param)), internal_makeRefetchableFnOpts(param$1, param$2, undefined));
                  };
                }), [p.refetch])
        };
}

var makeRefetchVariables = BulkSaleRawProductSaleLedgersAdminFragmentQuery_graphql.Types.makeRefetchVariables;

var Fragment_getConnectionNodes = BulkSaleRawProductSaleLedgersAdminFragment_graphql.Utils.getConnectionNodes;

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

function BulkSale_RawProductSaleLedgers_Admin$LedgerFile(Props) {
  var path = Props.path;
  var status = CustomHooks.BulkSaleLedger.use(path);
  var match;
  if (typeof status === "number") {
    match = [
      undefined,
      "로딩 중"
    ];
  } else if (status.TAG === /* Loaded */0) {
    var resource$p = CustomHooks.BulkSaleLedger.response_decode(status._0);
    if (resource$p.TAG === /* Ok */0) {
      var resource$p$1 = resource$p._0;
      match = [
        resource$p$1.url,
        Belt_Option.getWithDefault(Garter_Array.last(resource$p$1.path.split("/")), "알 수 없는 파일명")
      ];
    } else {
      match = [
        undefined,
        "에러 발생"
      ];
    }
  } else {
    match = [
      undefined,
      "에러 발생"
    ];
  }
  return React.createElement("span", {
              className: "inline-flex max-w-full items-center border border-border-default-L1 rounded-lg p-2 mt-2 text-sm text-text-L1 bg-white"
            }, React.createElement("a", {
                  className: "mr-1",
                  download: "",
                  href: Belt_Option.getWithDefault(match[0], "#")
                }, React.createElement(IconDownloadCenter.make, {
                      width: "20",
                      height: "20",
                      fill: "#262626"
                    })), React.createElement("span", {
                  className: "truncate"
                }, match[1]));
}

var LedgerFile = {
  make: BulkSale_RawProductSaleLedgers_Admin$LedgerFile
};

function BulkSale_RawProductSaleLedgers_Admin(Props) {
  var query = Props.query;
  var ledgers = use(query);
  return React.createElement(React.Fragment, undefined, React.createElement("h3", {
                  className: "mt-4"
                }, "판매 원표"), React.createElement("article", {
                  className: "mt-2"
                }, React.createElement("div", {
                      className: "bg-surface rounded-lg p-3"
                    }, Belt_Array.map(ledgers.bulkSaleRawProductSaleLedgers.edges, (function (edge) {
                            return React.createElement("p", {
                                        className: "text-text-L2"
                                      }, React.createElement(BulkSale_RawProductSaleLedgers_Admin$LedgerFile, {
                                            path: edge.node.path
                                          }));
                          })))));
}

var make = BulkSale_RawProductSaleLedgers_Admin;

export {
  Fragment ,
  LedgerFile ,
  make ,
  
}
/* react Not a pure module */