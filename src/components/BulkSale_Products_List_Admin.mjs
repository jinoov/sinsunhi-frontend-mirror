// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Curry from "rescript/lib/es6/curry.js";
import * as React from "react";
import * as Js_dict from "rescript/lib/es6/js_dict.js";
import * as Skeleton from "./Skeleton.mjs";
import * as Belt_Array from "rescript/lib/es6/belt_Array.js";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as CustomHooks from "../utils/CustomHooks.mjs";
import * as Order_Admin from "./Order_Admin.mjs";
import * as Router from "next/router";
import * as ReactRelay from "react-relay";
import * as Garter_Array from "@greenlabs/garter/src/Garter_Array.mjs";
import * as RescriptRelay from "rescript-relay/src/RescriptRelay.mjs";
import * as Js_null_undefined from "rescript/lib/es6/js_null_undefined.js";
import * as BulkSale_Product_Admin from "./BulkSale_Product_Admin.mjs";
import * as RescriptRelay_Internal from "rescript-relay/src/RescriptRelay_Internal.mjs";
import * as Status_BulkSale_Product from "./common/Status_BulkSale_Product.mjs";
import * as BulkSale_Product_Create_Button from "./BulkSale_Product_Create_Button.mjs";
import * as BulkSaleProductsListAdminFragment_graphql from "../__generated__/BulkSaleProductsListAdminFragment_graphql.mjs";
import * as BulkSaleProductsListAdminRefetchQuery_graphql from "../__generated__/BulkSaleProductsListAdminRefetchQuery_graphql.mjs";

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
  var match = ReactRelay.useRefetchableFragment(BulkSaleProductsListAdminFragment_graphql.node, fRef);
  var refetchFn = match[1];
  var data = RescriptRelay_Internal.internal_useConvertedValue(BulkSaleProductsListAdminFragment_graphql.Internal.convertFragment, match[0]);
  return [
          data,
          React.useMemo((function () {
                  return function (param, param$1, param$2, param$3) {
                    return Curry._2(refetchFn, RescriptRelay_Internal.internal_removeUndefinedAndConvertNullsRaw(BulkSaleProductsListAdminRefetchQuery_graphql.Internal.convertVariables(param)), internal_makeRefetchableFnOpts(param$1, param$2, undefined));
                  };
                }), [refetchFn])
        ];
}

function use(fRef) {
  var data = ReactRelay.useFragment(BulkSaleProductsListAdminFragment_graphql.node, fRef);
  return RescriptRelay_Internal.internal_useConvertedValue(BulkSaleProductsListAdminFragment_graphql.Internal.convertFragment, data);
}

function useOpt(opt_fRef) {
  var fr = opt_fRef !== undefined ? Caml_option.some(Caml_option.valFromOption(opt_fRef)) : undefined;
  var nullableFragmentData = ReactRelay.useFragment(BulkSaleProductsListAdminFragment_graphql.node, fr !== undefined ? Js_null_undefined.fromOption(Caml_option.some(Caml_option.valFromOption(fr))) : null);
  var data = (nullableFragmentData == null) ? undefined : Caml_option.some(nullableFragmentData);
  return RescriptRelay_Internal.internal_useConvertedValue((function (rawFragment) {
                if (rawFragment !== undefined) {
                  return BulkSaleProductsListAdminFragment_graphql.Internal.convertFragment(rawFragment);
                }
                
              }), data);
}

function usePagination(fr) {
  var p = ReactRelay.usePaginationFragment(BulkSaleProductsListAdminFragment_graphql.node, fr);
  var data = RescriptRelay_Internal.internal_useConvertedValue(BulkSaleProductsListAdminFragment_graphql.Internal.convertFragment, p.data);
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
                    return p.refetch(RescriptRelay_Internal.internal_cleanObjectFromUndefinedRaw(BulkSaleProductsListAdminRefetchQuery_graphql.Internal.convertVariables(param)), internal_makeRefetchableFnOpts(param$1, param$2, undefined));
                  };
                }), [p.refetch])
        };
}

function useBlockingPagination(fRef) {
  var p = ReactRelay.useBlockingPaginationFragment(BulkSaleProductsListAdminFragment_graphql.node, fRef);
  var data = RescriptRelay_Internal.internal_useConvertedValue(BulkSaleProductsListAdminFragment_graphql.Internal.convertFragment, p.data);
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
                    return p.refetch(RescriptRelay_Internal.internal_cleanObjectFromUndefinedRaw(BulkSaleProductsListAdminRefetchQuery_graphql.Internal.convertVariables(param)), internal_makeRefetchableFnOpts(param$1, param$2, undefined));
                  };
                }), [p.refetch])
        };
}

var makeRefetchVariables = BulkSaleProductsListAdminRefetchQuery_graphql.Types.makeRefetchVariables;

var Fragment_getConnectionNodes = BulkSaleProductsListAdminFragment_graphql.Utils.getConnectionNodes;

var Fragment = {
  getConnectionNodes: Fragment_getConnectionNodes,
  Types: undefined,
  internal_makeRefetchableFnOpts: internal_makeRefetchableFnOpts,
  useRefetchable: useRefetchable,
  Operation: undefined,
  use: use,
  useOpt: useOpt,
  usePagination: usePagination,
  useBlockingPagination: useBlockingPagination,
  makeRefetchVariables: makeRefetchVariables
};

function BulkSale_Products_List_Admin$Header(Props) {
  return React.createElement("div", {
              className: "grid grid-cols-7-admin-bulk-sale-product bg-gray-50 text-gray-500 h-12 divide-y divide-gray-100"
            }, React.createElement("div", {
                  className: "h-full px-4 flex items-center whitespace-nowrap"
                }, "생성일자"), React.createElement("div", {
                  className: "h-full px-4 flex items-center whitespace-nowrap"
                }, "상태"), React.createElement("div", {
                  className: "h-full px-4 flex items-center whitespace-nowrap"
                }, "작물"), React.createElement("div", {
                  className: "h-full px-4 flex items-center whitespace-nowrap"
                }, "적정 구매가격"), React.createElement("div", {
                  className: "h-full px-4 flex items-center whitespace-nowrap"
                }, "노출단위"), React.createElement("div", {
                  className: "col-span-2 h-full px-4 flex items-center whitespace-nowrap"
                }, "추가비율"));
}

var Header = {
  make: BulkSale_Products_List_Admin$Header
};

function BulkSale_Products_List_Admin$Loading(Props) {
  return React.createElement("div", {
              className: "w-full overflow-x-scroll"
            }, React.createElement("div", {
                  className: "min-w-max text-sm"
                }, React.createElement(BulkSale_Products_List_Admin$Header, {}), React.createElement("ol", {
                      className: "divide-y divide-gray-100 lg:list-height-admin-bulk-sale lg:overflow-y-scroll"
                    }, Garter_Array.map(Garter_Array.make(5, 0), (function (param) {
                            return React.createElement(Order_Admin.Item.Table.Loading.make, {});
                          })))));
}

var Loading = {
  make: BulkSale_Products_List_Admin$Loading
};

function BulkSale_Products_List_Admin$Skeleton(Props) {
  return React.createElement(React.Fragment, undefined, React.createElement("div", {
                  className: "md:flex md:justify-between pb-4"
                }, React.createElement("div", {
                      className: "flex flex-auto justify-between h-8"
                    }, React.createElement("h3", {
                          className: "flex text-lg font-bold"
                        }, "내역", React.createElement(Skeleton.Box.make, {
                              className: "ml-1 w-10"
                            })), React.createElement(Skeleton.Box.make, {
                          className: "w-28"
                        }))), React.createElement("div", {
                  className: "w-full overflow-x-scroll"
                }, React.createElement("div", {
                      className: "min-w-max text-sm"
                    }, React.createElement("div", {
                          className: "grid grid-cols-7-admin-bulk-sale-product bg-gray-50 text-gray-500 h-12 divide-y divide-gray-100"
                        }), React.createElement("span", {
                          className: "w-full h-[500px] flex items-center justify-center"
                        }, "로딩중.."))));
}

var Skeleton$1 = {
  make: BulkSale_Products_List_Admin$Skeleton
};

function BulkSale_Products_List_Admin$List(Props) {
  var query = Props.query;
  var refetchSummary = Props.refetchSummary;
  var statistics = Props.statistics;
  var router = Router.useRouter();
  var queried = Belt_Option.flatMap(Js_dict.get(router.query, "status"), (function (status) {
          var status$p = Status_BulkSale_Product.status_decode(status);
          if (status$p.TAG === /* Ok */0) {
            return status$p._0;
          }
          
        }));
  var count;
  if (queried !== undefined) {
    if (queried !== 0) {
      switch (queried) {
        case /* OPEN */1 :
            count = statistics.openCount;
            break;
        case /* ENDED */2 :
            count = statistics.notOpenCount;
            break;
        case /* CANCELED */3 :
            count = 0;
            break;
        
      }
    } else {
      count = 0;
    }
  } else {
    count = statistics.count;
  }
  var listContainerRef = React.useRef(null);
  var loadMoreRef = React.useRef(null);
  var match = usePagination(query);
  var hasNext = match.hasNext;
  var loadNext = match.loadNext;
  var data = match.data;
  var isIntersecting = CustomHooks.$$IntersectionObserver.use(listContainerRef, loadMoreRef, 0.1, "50px", undefined);
  React.useEffect((function () {
          if (hasNext && isIntersecting) {
            Curry._3(loadNext, 5, undefined, undefined);
          }
          
        }), [
        hasNext,
        isIntersecting
      ]);
  return React.createElement(React.Fragment, undefined, React.createElement("div", {
                  className: "md:flex md:justify-between pb-4"
                }, React.createElement("div", {
                      className: "flex flex-auto justify-between"
                    }, React.createElement("h3", {
                          className: "text-lg font-bold"
                        }, "내역", React.createElement("span", {
                              className: "text-base ml-1 text-green-gl font-normal"
                            }, "" + String(count) + "건")), React.createElement("div", {
                          className: "flex"
                        }, React.createElement(BulkSale_Product_Create_Button.make, {
                              connectionId: data.bulkSaleCampaigns.__id,
                              refetchSummary: refetchSummary
                            })))), React.createElement("div", {
                  className: "w-full overflow-x-scroll"
                }, React.createElement("div", {
                      className: "min-w-max text-sm"
                    }, React.createElement(BulkSale_Products_List_Admin$Header, {}), React.createElement("ol", {
                          ref: listContainerRef,
                          className: "divide-y divide-gray-100 lg:list-height-admin-bulk-sale lg:overflow-y-scroll"
                        }, Belt_Array.map(data.bulkSaleCampaigns.edges, (function (edge) {
                                return React.createElement(BulkSale_Product_Admin.make, {
                                            node: edge.node,
                                            refetchSummary: refetchSummary
                                          });
                              })), match.isLoadingNext ? React.createElement("div", undefined, "로딩중...") : null, React.createElement("div", {
                              ref: loadMoreRef,
                              className: "h-5"
                            })))));
}

var List = {
  make: BulkSale_Products_List_Admin$List
};

function BulkSale_Products_List_Admin(Props) {
  var query = Props.query;
  var refetchSummary = Props.refetchSummary;
  var statistics = Props.statistics;
  return React.createElement(BulkSale_Products_List_Admin$List, {
              query: query,
              refetchSummary: refetchSummary,
              statistics: statistics
            });
}

var make = BulkSale_Products_List_Admin;

export {
  Fragment ,
  Header ,
  Loading ,
  Skeleton$1 as Skeleton,
  List ,
  make ,
}
/* react Not a pure module */
