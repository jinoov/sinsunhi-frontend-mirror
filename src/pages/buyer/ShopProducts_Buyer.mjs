// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Curry from "rescript/lib/es6/curry.js";
import * as React from "react";
import * as Js_dict from "rescript/lib/es6/js_dict.js";
import Head from "next/head";
import * as Belt_Array from "rescript/lib/es6/belt_Array.js";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as CustomHooks from "../../utils/CustomHooks.mjs";
import * as Router from "next/router";
import * as Layout_Buyer from "../../layouts/Layout_Buyer.mjs";
import * as RescriptRelay from "rescript-relay/src/RescriptRelay.mjs";
import * as RelayRuntime from "relay-runtime";
import * as ChannelTalkHelper from "../../utils/ChannelTalkHelper.mjs";
import * as Js_null_undefined from "rescript/lib/es6/js_null_undefined.js";
import * as Hooks from "react-relay/hooks";
import * as RescriptRelay_Internal from "rescript-relay/src/RescriptRelay_Internal.mjs";
import * as ShopProductListItem_Buyer from "../../components/ShopProductListItem_Buyer.mjs";
import * as RescriptReactErrorBoundary from "@rescript/react/src/RescriptReactErrorBoundary.mjs";
import * as ShopProductsSortSelect_Buyer from "../../components/ShopProductsSortSelect_Buyer.mjs";
import * as ShopProductsBuyerQuery_graphql from "../../__generated__/ShopProductsBuyerQuery_graphql.mjs";
import * as ShopProductsBuyerFragment_graphql from "../../__generated__/ShopProductsBuyerFragment_graphql.mjs";
import * as ShopProductsBuyerRefetchQuery_graphql from "../../__generated__/ShopProductsBuyerRefetchQuery_graphql.mjs";

var makeVariables = ShopProductsBuyerQuery_graphql.Utils.makeVariables;

function use(variables, fetchPolicy, fetchKey, networkCacheConfig, param) {
  var data = Hooks.useLazyLoadQuery(ShopProductsBuyerQuery_graphql.node, RescriptRelay_Internal.internal_cleanObjectFromUndefinedRaw(ShopProductsBuyerQuery_graphql.Internal.convertVariables(variables)), {
        fetchKey: fetchKey,
        fetchPolicy: RescriptRelay.mapFetchPolicy(fetchPolicy),
        networkCacheConfig: networkCacheConfig
      });
  return RescriptRelay_Internal.internal_useConvertedValue(ShopProductsBuyerQuery_graphql.Internal.convertResponse, data);
}

function useLoader(param) {
  var match = Hooks.useQueryLoader(ShopProductsBuyerQuery_graphql.node);
  var loadQueryFn = match[1];
  var loadQuery = React.useMemo((function () {
          return function (param, param$1, param$2, param$3) {
            return Curry._2(loadQueryFn, ShopProductsBuyerQuery_graphql.Internal.convertVariables(param), {
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
  Hooks.fetchQuery(environment, ShopProductsBuyerQuery_graphql.node, ShopProductsBuyerQuery_graphql.Internal.convertVariables(variables), {
          networkCacheConfig: networkCacheConfig,
          fetchPolicy: RescriptRelay.mapFetchQueryFetchPolicy(fetchPolicy)
        }).subscribe({
        next: (function (res) {
            return Curry._1(onResult, {
                        TAG: /* Ok */0,
                        _0: ShopProductsBuyerQuery_graphql.Internal.convertResponse(res)
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
  var __x = Hooks.fetchQuery(environment, ShopProductsBuyerQuery_graphql.node, ShopProductsBuyerQuery_graphql.Internal.convertVariables(variables), {
          networkCacheConfig: networkCacheConfig,
          fetchPolicy: RescriptRelay.mapFetchQueryFetchPolicy(fetchPolicy)
        }).toPromise();
  return __x.then(function (res) {
              return Promise.resolve(ShopProductsBuyerQuery_graphql.Internal.convertResponse(res));
            });
}

function usePreloaded(queryRef, param) {
  var data = Hooks.usePreloadedQuery(ShopProductsBuyerQuery_graphql.node, queryRef);
  return RescriptRelay_Internal.internal_useConvertedValue(ShopProductsBuyerQuery_graphql.Internal.convertResponse, data);
}

function retain(environment, variables) {
  var operationDescriptor = RelayRuntime.createOperationDescriptor(ShopProductsBuyerQuery_graphql.node, ShopProductsBuyerQuery_graphql.Internal.convertVariables(variables));
  return environment.retain(operationDescriptor);
}

var Query_displayCategoryProductsSort_decode = ShopProductsBuyerQuery_graphql.Utils.displayCategoryProductsSort_decode;

var Query_displayCategoryProductsSort_fromString = ShopProductsBuyerQuery_graphql.Utils.displayCategoryProductsSort_fromString;

var Query = {
  displayCategoryProductsSort_decode: Query_displayCategoryProductsSort_decode,
  displayCategoryProductsSort_fromString: Query_displayCategoryProductsSort_fromString,
  makeVariables: makeVariables,
  Types: undefined,
  use: use,
  useLoader: useLoader,
  $$fetch: $$fetch,
  fetchPromised: fetchPromised,
  usePreloaded: usePreloaded,
  retain: retain
};

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
  var match = Hooks.useRefetchableFragment(ShopProductsBuyerFragment_graphql.node, fRef);
  var refetchFn = match[1];
  var data = RescriptRelay_Internal.internal_useConvertedValue(ShopProductsBuyerFragment_graphql.Internal.convertFragment, match[0]);
  return [
          data,
          React.useMemo((function () {
                  return function (param, param$1, param$2, param$3) {
                    return Curry._2(refetchFn, RescriptRelay_Internal.internal_cleanObjectFromUndefinedRaw(ShopProductsBuyerRefetchQuery_graphql.Internal.convertVariables(param)), internal_makeRefetchableFnOpts(param$1, param$2, undefined));
                  };
                }), [refetchFn])
        ];
}

function use$1(fRef) {
  var data = Hooks.useFragment(ShopProductsBuyerFragment_graphql.node, fRef);
  return RescriptRelay_Internal.internal_useConvertedValue(ShopProductsBuyerFragment_graphql.Internal.convertFragment, data);
}

function useOpt(opt_fRef) {
  var fr = opt_fRef !== undefined ? Caml_option.some(Caml_option.valFromOption(opt_fRef)) : undefined;
  var nullableFragmentData = Hooks.useFragment(ShopProductsBuyerFragment_graphql.node, fr !== undefined ? Js_null_undefined.fromOption(Caml_option.some(Caml_option.valFromOption(fr))) : null);
  var data = (nullableFragmentData == null) ? undefined : Caml_option.some(nullableFragmentData);
  return RescriptRelay_Internal.internal_useConvertedValue((function (rawFragment) {
                if (rawFragment !== undefined) {
                  return ShopProductsBuyerFragment_graphql.Internal.convertFragment(rawFragment);
                }
                
              }), data);
}

function usePagination(fr) {
  var p = Hooks.usePaginationFragment(ShopProductsBuyerFragment_graphql.node, fr);
  var data = RescriptRelay_Internal.internal_useConvertedValue(ShopProductsBuyerFragment_graphql.Internal.convertFragment, p.data);
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
                    return p.refetch(RescriptRelay_Internal.internal_cleanObjectFromUndefinedRaw(ShopProductsBuyerRefetchQuery_graphql.Internal.convertVariables(param)), internal_makeRefetchableFnOpts(param$1, param$2, undefined));
                  };
                }), [p.refetch])
        };
}

function useBlockingPagination(fRef) {
  var p = Hooks.useBlockingPaginationFragment(ShopProductsBuyerFragment_graphql.node, fRef);
  var data = RescriptRelay_Internal.internal_useConvertedValue(ShopProductsBuyerFragment_graphql.Internal.convertFragment, p.data);
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
                    return p.refetch(RescriptRelay_Internal.internal_cleanObjectFromUndefinedRaw(ShopProductsBuyerRefetchQuery_graphql.Internal.convertVariables(param)), internal_makeRefetchableFnOpts(param$1, param$2, undefined));
                  };
                }), [p.refetch])
        };
}

var makeRefetchVariables = ShopProductsBuyerRefetchQuery_graphql.Types.makeRefetchVariables;

var Fragment_displayCategoryType_decode = ShopProductsBuyerFragment_graphql.Utils.displayCategoryType_decode;

var Fragment_displayCategoryType_fromString = ShopProductsBuyerFragment_graphql.Utils.displayCategoryType_fromString;

var Fragment_getConnectionNodes = ShopProductsBuyerFragment_graphql.Utils.getConnectionNodes;

var Fragment = {
  displayCategoryType_decode: Fragment_displayCategoryType_decode,
  displayCategoryType_fromString: Fragment_displayCategoryType_fromString,
  getConnectionNodes: Fragment_getConnectionNodes,
  Types: undefined,
  internal_makeRefetchableFnOpts: internal_makeRefetchableFnOpts,
  useRefetchable: useRefetchable,
  use: use$1,
  useOpt: useOpt,
  usePagination: usePagination,
  useBlockingPagination: useBlockingPagination,
  makeRefetchVariables: makeRefetchVariables
};

function ShopProducts_Buyer$PC$Empty(Props) {
  var name = Props.name;
  return React.createElement(React.Fragment, undefined, React.createElement("div", {
                  className: "font-bold text-3xl text-gray-800"
                }, name), React.createElement("div", {
                  className: "pt-20 flex flex-col items-center justify-center text-gray-800"
                }, React.createElement("h1", {
                      className: "text-3xl"
                    }, "상품이 존재하지 않습니다"), React.createElement("span", {
                      className: "mt-7"
                    }, "해당 카테고리에 상품이 존재하지 않습니다."), React.createElement("span", undefined, "다른 카테고리를 선택해 주세요.")));
}

var Empty = {
  make: ShopProducts_Buyer$PC$Empty
};

function ShopProducts_Buyer$PC(Props) {
  var query = Props.query;
  var match = usePagination(query);
  var hasNext = match.hasNext;
  var loadNext = match.loadNext;
  var match$1 = match.data;
  var products = match$1.products;
  var name = match$1.name;
  var loadMoreRef = React.useRef(null);
  var isIntersecting = CustomHooks.$$IntersectionObserver.use(undefined, loadMoreRef, 0.1, "50px", undefined);
  React.useEffect((function () {
          if (hasNext && isIntersecting) {
            Curry._3(loadNext, 20, undefined, undefined);
          }
          
        }), [
        hasNext,
        isIntersecting
      ]);
  if (products.edges.length === 0) {
    return React.createElement(ShopProducts_Buyer$PC$Empty, {
                name: name
              });
  } else {
    return React.createElement("div", {
                className: "w-[1280px] pt-20 px-5 pb-16 mx-auto min-h-full"
              }, React.createElement("div", {
                    className: "font-bold text-3xl text-gray-800"
                  }, name), React.createElement("div", {
                    className: "mt-[88px]"
                  }, match$1.type_ === "NORMAL" ? React.createElement("div", {
                          className: "mb-12 w-full flex items-center justify-end"
                        }, React.createElement(ShopProductsSortSelect_Buyer.make, {})) : null, React.createElement("ol", {
                        className: "grid grid-cols-4 gap-x-10 gap-y-16"
                      }, Belt_Array.map(products.edges, (function (param) {
                              return React.createElement(ShopProductListItem_Buyer.PC.make, {
                                          query: param.node.fragmentRefs,
                                          key: param.cursor
                                        });
                            }))), React.createElement("div", {
                        ref: loadMoreRef,
                        className: "h-20 w-full"
                      })));
  }
}

var PC = {
  Empty: Empty,
  make: ShopProducts_Buyer$PC
};

function ShopProducts_Buyer$MO$Empty(Props) {
  return React.createElement("div", {
              className: "pt-[126px] flex flex-col items-center justify-center text-gray-800 px-5"
            }, React.createElement("h1", {
                  className: "text-xl"
                }, "상품이 존재하지 않습니다"), React.createElement("span", {
                  className: "mt-2 text-sm text-gray-600 text-center"
                }, "해당 카테고리에 상품이 존재하지 않습니다."), React.createElement("span", {
                  className: "mt-2 text-sm text-gray-600 text-center"
                }, "다른 카테고리를 선택해 주세요."));
}

var Empty$1 = {
  make: ShopProducts_Buyer$MO$Empty
};

function ShopProducts_Buyer$MO(Props) {
  var query = Props.query;
  var match = usePagination(query);
  var hasNext = match.hasNext;
  var loadNext = match.loadNext;
  var match$1 = match.data;
  var products = match$1.products;
  var loadMoreRef = React.useRef(null);
  var isIntersecting = CustomHooks.$$IntersectionObserver.use(undefined, loadMoreRef, 0.1, "50px", undefined);
  React.useEffect((function () {
          if (hasNext && isIntersecting) {
            Curry._3(loadNext, 20, undefined, undefined);
          }
          
        }), [
        hasNext,
        isIntersecting
      ]);
  if (products.edges.length === 0) {
    return React.createElement(ShopProducts_Buyer$MO$Empty, {});
  } else {
    return React.createElement("div", {
                className: "w-full pt-4 px-5"
              }, match$1.type_ === "NORMAL" ? React.createElement("div", {
                      className: "mb-4 w-full flex items-center justify-end"
                    }, React.createElement(ShopProductsSortSelect_Buyer.MO.make, {})) : null, React.createElement("ol", {
                    className: "grid grid-cols-2 gap-x-4 gap-y-8"
                  }, Belt_Array.map(products.edges, (function (param) {
                          return React.createElement(ShopProductListItem_Buyer.MO.make, {
                                      query: param.node.fragmentRefs,
                                      key: param.cursor
                                    });
                        }))), React.createElement("div", {
                    ref: loadMoreRef,
                    className: "h-20 w-full"
                  }));
  }
}

var MO = {
  Empty: Empty$1,
  make: ShopProducts_Buyer$MO
};

function ShopProducts_Buyer$Placeholder(Props) {
  return React.createElement(Layout_Buyer.Responsive.make, {
              pc: React.createElement("div", {
                    className: "w-[1280px] pt-20 px-5 pb-16 mx-auto"
                  }, React.createElement("div", {
                        className: "w-[160px] h-[44px] rounded-lg animate-pulse bg-gray-150"
                      }), React.createElement("section", {
                        className: "w-full mt-[88px]"
                      }, React.createElement("ol", {
                            className: "grid grid-cols-4 gap-x-10 gap-y-16"
                          }, Belt_Array.map(Belt_Array.range(1, 300), (function (number) {
                                  return React.createElement(ShopProductListItem_Buyer.PC.Placeholder.make, {
                                              key: "box-" + String(number)
                                            });
                                }))))),
              mobile: React.createElement("div", {
                    className: "w-full py-4 px-5"
                  }, React.createElement("div", {
                        className: "mb-4 w-full flex items-center justify-end"
                      }, React.createElement("div", {
                            className: "w-12 h-5 bg-gray-150 rounded-lg animate-pulse"
                          })), React.createElement("ol", {
                        className: "grid grid-cols-2 gap-x-4 gap-y-8"
                      }, Belt_Array.map(Belt_Array.range(1, 300), (function (num) {
                              return React.createElement(ShopProductListItem_Buyer.MO.Placeholder.make, {
                                          key: "list-item-skeleton-" + String(num)
                                        });
                            }))))
            });
}

var Placeholder = {
  make: ShopProducts_Buyer$Placeholder
};

function ShopProducts_Buyer$Container(Props) {
  var displayCategoryId = Props.displayCategoryId;
  var sort = Props.sort;
  ChannelTalkHelper.Hook.use(undefined, undefined, undefined);
  var variables = Curry._6(makeVariables, displayCategoryId, undefined, 20, sort, true, undefined);
  var match = use(variables, /* StoreOrNetwork */1, undefined, undefined, undefined);
  var node = match.node;
  if (node === undefined) {
    return null;
  }
  var fragmentRefs = node.fragmentRefs;
  return React.createElement(Layout_Buyer.Responsive.make, {
              pc: React.createElement(ShopProducts_Buyer$PC, {
                    query: fragmentRefs
                  }),
              mobile: React.createElement(ShopProducts_Buyer$MO, {
                    query: fragmentRefs
                  })
            });
}

var Container = {
  make: ShopProducts_Buyer$Container
};

function ShopProducts_Buyer(Props) {
  var router = Router.useRouter();
  var displayCategoryId = Js_dict.get(router.query, "category-id");
  var sort = Belt_Option.flatMap(Js_dict.get(router.query, "sort"), ShopProductsSortSelect_Buyer.decodeSort);
  return React.createElement(React.Fragment, undefined, React.createElement(Head, {
                  children: React.createElement("title", undefined, "신선하이")
                }), React.createElement(RescriptReactErrorBoundary.make, {
                  children: React.createElement(React.Suspense, {
                        children: displayCategoryId !== undefined ? React.createElement(ShopProducts_Buyer$Container, {
                                displayCategoryId: displayCategoryId,
                                sort: sort
                              }) : React.createElement(ShopProducts_Buyer$Placeholder, {}),
                        fallback: React.createElement(ShopProducts_Buyer$Placeholder, {})
                      }),
                  fallback: (function (param) {
                      return React.createElement(ShopProducts_Buyer$Placeholder, {});
                    })
                }));
}

var make = ShopProducts_Buyer;

export {
  Query ,
  Fragment ,
  PC ,
  MO ,
  Placeholder ,
  Container ,
  make ,
  
}
/* react Not a pure module */
