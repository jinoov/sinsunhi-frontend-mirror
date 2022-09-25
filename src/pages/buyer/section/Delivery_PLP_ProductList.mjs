// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Curry from "rescript/lib/es6/curry.js";
import * as React from "react";
import * as Js_dict from "rescript/lib/es6/js_dict.js";
import * as Belt_Array from "rescript/lib/es6/belt_Array.js";
import * as Js_promise from "rescript/lib/es6/js_promise.js";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as CustomHooks from "../../../utils/CustomHooks.mjs";
import * as Router from "next/router";
import * as ReactRelay from "react-relay";
import * as RescriptRelay from "rescript-relay/src/RescriptRelay.mjs";
import * as RelayRuntime from "relay-runtime";
import * as Js_null_undefined from "rescript/lib/es6/js_null_undefined.js";
import * as DeliverySortSelect from "./DeliverySortSelect.mjs";
import * as RescriptRelay_Internal from "rescript-relay/src/RescriptRelay_Internal.mjs";
import * as DeliveryProductListItem from "./DeliveryProductListItem.mjs";
import * as ShopProductListItem_Buyer from "../../../components/ShopProductListItem_Buyer.mjs";
import * as RescriptReactErrorBoundary from "@rescript/react/src/RescriptReactErrorBoundary.mjs";
import * as DeliveryPLPProductListQuery_graphql from "../../../__generated__/DeliveryPLPProductListQuery_graphql.mjs";
import * as DeliveryPLPProductListFragment_graphql from "../../../__generated__/DeliveryPLPProductListFragment_graphql.mjs";
import * as DeliveryPLPProductListRefetchQuery_graphql from "../../../__generated__/DeliveryPLPProductListRefetchQuery_graphql.mjs";

function use(variables, fetchPolicy, fetchKey, networkCacheConfig, param) {
  var data = ReactRelay.useLazyLoadQuery(DeliveryPLPProductListQuery_graphql.node, RescriptRelay_Internal.internal_cleanObjectFromUndefinedRaw(DeliveryPLPProductListQuery_graphql.Internal.convertVariables(variables)), {
        fetchKey: fetchKey,
        fetchPolicy: RescriptRelay.mapFetchPolicy(fetchPolicy),
        networkCacheConfig: networkCacheConfig
      });
  return RescriptRelay_Internal.internal_useConvertedValue(DeliveryPLPProductListQuery_graphql.Internal.convertResponse, data);
}

function useLoader(param) {
  var match = ReactRelay.useQueryLoader(DeliveryPLPProductListQuery_graphql.node);
  var loadQueryFn = match[1];
  var loadQuery = React.useMemo((function () {
          return function (param, param$1, param$2, param$3) {
            return Curry._2(loadQueryFn, DeliveryPLPProductListQuery_graphql.Internal.convertVariables(param), {
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
  ReactRelay.fetchQuery(environment, DeliveryPLPProductListQuery_graphql.node, DeliveryPLPProductListQuery_graphql.Internal.convertVariables(variables), {
          networkCacheConfig: networkCacheConfig,
          fetchPolicy: RescriptRelay.mapFetchQueryFetchPolicy(fetchPolicy)
        }).subscribe({
        next: (function (res) {
            Curry._1(onResult, {
                  TAG: /* Ok */0,
                  _0: DeliveryPLPProductListQuery_graphql.Internal.convertResponse(res)
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
  var __x = ReactRelay.fetchQuery(environment, DeliveryPLPProductListQuery_graphql.node, DeliveryPLPProductListQuery_graphql.Internal.convertVariables(variables), {
          networkCacheConfig: networkCacheConfig,
          fetchPolicy: RescriptRelay.mapFetchQueryFetchPolicy(fetchPolicy)
        }).toPromise();
  return Js_promise.then_((function (res) {
                return Promise.resolve(DeliveryPLPProductListQuery_graphql.Internal.convertResponse(res));
              }), __x);
}

function usePreloaded(queryRef, param) {
  var data = ReactRelay.usePreloadedQuery(DeliveryPLPProductListQuery_graphql.node, queryRef);
  return RescriptRelay_Internal.internal_useConvertedValue(DeliveryPLPProductListQuery_graphql.Internal.convertResponse, data);
}

function retain(environment, variables) {
  var operationDescriptor = RelayRuntime.createOperationDescriptor(DeliveryPLPProductListQuery_graphql.node, DeliveryPLPProductListQuery_graphql.Internal.convertVariables(variables));
  return environment.retain(operationDescriptor);
}

var Query_displayCategoryProductsSort_decode = DeliveryPLPProductListQuery_graphql.Utils.displayCategoryProductsSort_decode;

var Query_displayCategoryProductsSort_fromString = DeliveryPLPProductListQuery_graphql.Utils.displayCategoryProductsSort_fromString;

var Query = {
  displayCategoryProductsSort_decode: Query_displayCategoryProductsSort_decode,
  displayCategoryProductsSort_fromString: Query_displayCategoryProductsSort_fromString,
  Operation: undefined,
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
  var match = ReactRelay.useRefetchableFragment(DeliveryPLPProductListFragment_graphql.node, fRef);
  var refetchFn = match[1];
  var data = RescriptRelay_Internal.internal_useConvertedValue(DeliveryPLPProductListFragment_graphql.Internal.convertFragment, match[0]);
  return [
          data,
          React.useMemo((function () {
                  return function (param, param$1, param$2, param$3) {
                    return Curry._2(refetchFn, RescriptRelay_Internal.internal_removeUndefinedAndConvertNullsRaw(DeliveryPLPProductListRefetchQuery_graphql.Internal.convertVariables(param)), internal_makeRefetchableFnOpts(param$1, param$2, undefined));
                  };
                }), [refetchFn])
        ];
}

function use$1(fRef) {
  var data = ReactRelay.useFragment(DeliveryPLPProductListFragment_graphql.node, fRef);
  return RescriptRelay_Internal.internal_useConvertedValue(DeliveryPLPProductListFragment_graphql.Internal.convertFragment, data);
}

function useOpt(opt_fRef) {
  var fr = opt_fRef !== undefined ? Caml_option.some(Caml_option.valFromOption(opt_fRef)) : undefined;
  var nullableFragmentData = ReactRelay.useFragment(DeliveryPLPProductListFragment_graphql.node, fr !== undefined ? Js_null_undefined.fromOption(Caml_option.some(Caml_option.valFromOption(fr))) : null);
  var data = (nullableFragmentData == null) ? undefined : Caml_option.some(nullableFragmentData);
  return RescriptRelay_Internal.internal_useConvertedValue((function (rawFragment) {
                if (rawFragment !== undefined) {
                  return DeliveryPLPProductListFragment_graphql.Internal.convertFragment(rawFragment);
                }
                
              }), data);
}

function usePagination(fr) {
  var p = ReactRelay.usePaginationFragment(DeliveryPLPProductListFragment_graphql.node, fr);
  var data = RescriptRelay_Internal.internal_useConvertedValue(DeliveryPLPProductListFragment_graphql.Internal.convertFragment, p.data);
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
                    return p.refetch(RescriptRelay_Internal.internal_cleanObjectFromUndefinedRaw(DeliveryPLPProductListRefetchQuery_graphql.Internal.convertVariables(param)), internal_makeRefetchableFnOpts(param$1, param$2, undefined));
                  };
                }), [p.refetch])
        };
}

function useBlockingPagination(fRef) {
  var p = ReactRelay.useBlockingPaginationFragment(DeliveryPLPProductListFragment_graphql.node, fRef);
  var data = RescriptRelay_Internal.internal_useConvertedValue(DeliveryPLPProductListFragment_graphql.Internal.convertFragment, p.data);
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
                    return p.refetch(RescriptRelay_Internal.internal_cleanObjectFromUndefinedRaw(DeliveryPLPProductListRefetchQuery_graphql.Internal.convertVariables(param)), internal_makeRefetchableFnOpts(param$1, param$2, undefined));
                  };
                }), [p.refetch])
        };
}

var makeRefetchVariables = DeliveryPLPProductListRefetchQuery_graphql.Types.makeRefetchVariables;

var Fragment_getConnectionNodes = DeliveryPLPProductListFragment_graphql.Utils.getConnectionNodes;

var Fragment_displayCategoryType_decode = DeliveryPLPProductListFragment_graphql.Utils.displayCategoryType_decode;

var Fragment_displayCategoryType_fromString = DeliveryPLPProductListFragment_graphql.Utils.displayCategoryType_fromString;

var Fragment = {
  getConnectionNodes: Fragment_getConnectionNodes,
  displayCategoryType_decode: Fragment_displayCategoryType_decode,
  displayCategoryType_fromString: Fragment_displayCategoryType_fromString,
  Types: undefined,
  internal_makeRefetchableFnOpts: internal_makeRefetchableFnOpts,
  useRefetchable: useRefetchable,
  Operation: undefined,
  use: use$1,
  useOpt: useOpt,
  usePagination: usePagination,
  useBlockingPagination: useBlockingPagination,
  makeRefetchVariables: makeRefetchVariables
};

function Delivery_PLP_ProductList$PC$Skeleton(Props) {
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
  make: Delivery_PLP_ProductList$PC$Skeleton
};

function Delivery_PLP_ProductList$PC$Empty(Props) {
  var subCategoryName = Props.subCategoryName;
  return React.createElement(React.Fragment, undefined, React.createElement("div", {
                  className: "w-[1280px] pt-20 pb-16 mx-auto min-h-full"
                }, React.createElement("div", {
                      className: "font-bold text-2xl text-gray-800"
                    }, "" + subCategoryName + " 상품"), React.createElement("div", {
                      className: "mt-20 flex flex-col items-center justify-center text-gray-800"
                    }, React.createElement("h1", {
                          className: "text-3xl"
                        }, "상품이 존재하지 않습니다"), React.createElement("span", {
                          className: "mt-7"
                        }, "해당 카테고리에 상품이 존재하지 않습니다."), React.createElement("span", undefined, "다른 카테고리를 선택해 주세요."))));
}

var Empty = {
  make: Delivery_PLP_ProductList$PC$Empty
};

function Delivery_PLP_ProductList$PC$View(Props) {
  var query = Props.query;
  var subCategoryName = Props.subCategoryName;
  var match = usePagination(query);
  var hasNext = match.hasNext;
  var loadNext = match.loadNext;
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
  return React.createElement("div", {
              className: "w-[1280px] pt-20 pb-16 mx-auto min-h-full"
            }, React.createElement("div", {
                  className: "flex justify-between"
                }, React.createElement("div", {
                      className: "font-bold text-2xl text-gray-800"
                    }, "" + subCategoryName + " 상품"), React.createElement("div", {
                      className: "mb-12 flex-1 flex items-center justify-end"
                    }, React.createElement(DeliverySortSelect.make, {}))), React.createElement("ol", {
                  className: "grid grid-cols-4 gap-x-10 gap-y-16"
                }, Belt_Array.map(match.data.products.edges, (function (param) {
                        return React.createElement(DeliveryProductListItem.PC.make, {
                                    query: param.node.fragmentRefs,
                                    key: param.cursor
                                  });
                      }))), React.createElement("div", {
                  ref: loadMoreRef,
                  className: "h-20 w-full"
                }));
}

var View = {
  make: Delivery_PLP_ProductList$PC$View
};

function Delivery_PLP_ProductList$PC$Container(Props) {
  var subCategoryName = Props.subCategoryName;
  var router = Router.useRouter();
  var sort = Belt_Option.getWithDefault(Belt_Option.flatMap(Js_dict.get(router.query, "sort"), DeliverySortSelect.decodeSort), "UPDATED_DESC");
  var categoryId = Belt_Option.getWithDefault(Js_dict.get(router.query, "category-id"), "");
  var subCategoryId = Js_dict.get(router.query, "sub-category-id");
  var match = use({
        count: 20,
        displayCategoryId: Belt_Option.getWithDefault(subCategoryId, categoryId),
        onlyBuyable: true,
        sort: sort
      }, /* StoreOrNetwork */1, undefined, undefined, undefined);
  var node = match.node;
  if (node !== undefined) {
    return React.createElement(Delivery_PLP_ProductList$PC$View, {
                query: node.fragmentRefs,
                subCategoryName: subCategoryName
              });
  } else {
    return React.createElement(Delivery_PLP_ProductList$PC$Empty, {
                subCategoryName: subCategoryName
              });
  }
}

var Container = {
  make: Delivery_PLP_ProductList$PC$Container
};

function Delivery_PLP_ProductList$PC(Props) {
  var subCategoryName = Props.subCategoryName;
  var match = React.useState(function () {
        return false;
      });
  var setIsCsr = match[1];
  React.useEffect((function () {
          setIsCsr(function (param) {
                return true;
              });
        }), []);
  return React.createElement(RescriptReactErrorBoundary.make, {
              children: React.createElement(React.Suspense, {
                    children: React.createElement(Delivery_PLP_ProductList$PC$Container, {
                          subCategoryName: subCategoryName
                        }),
                    fallback: React.createElement(Delivery_PLP_ProductList$PC$Skeleton, {})
                  }),
              fallback: (function (param) {
                  return React.createElement(Delivery_PLP_ProductList$PC$Skeleton, {});
                })
            });
}

var PC = {
  Skeleton: Skeleton,
  Empty: Empty,
  View: View,
  Container: Container,
  make: Delivery_PLP_ProductList$PC
};

function Delivery_PLP_ProductList$MO$Skeleton(Props) {
  return React.createElement("div", {
              className: "w-full py-4 px-5"
            }, React.createElement("div", {
                  className: "mb-4 w-full flex items-center justify-end"
                }, React.createElement("div", {
                      className: "w-12 h-5 bg-gray-150 rounded-lg animate-pulse"
                    })), React.createElement("ol", {
                  className: "grid grid-cols-2 gap-x-4 gap-y-8"
                }, Belt_Array.map(Belt_Array.range(1, 300), (function (num) {
                        return React.createElement(ShopProductListItem_Buyer.MO.Placeholder.make, {
                                    key: "list-item-skeleton-" + String(num) + ""
                                  });
                      }))));
}

var Skeleton$1 = {
  make: Delivery_PLP_ProductList$MO$Skeleton
};

function Delivery_PLP_ProductList$MO$Empty(Props) {
  return React.createElement(React.Fragment, undefined, React.createElement("div", {
                  className: "mt-[126px] flex flex-col items-center justify-center text-gray-800 px-5"
                }, React.createElement("h1", {
                      className: "text-xl"
                    }, "상품이 존재하지 않습니다"), React.createElement("span", {
                      className: "mt-2 text-sm text-gray-600 text-center"
                    }, "해당 카테고리에 상품이 존재하지 않습니다."), React.createElement("span", {
                      className: "mt-2 text-sm text-gray-600 text-center"
                    }, "다른 카테고리를 선택해 주세요.")));
}

var Empty$1 = {
  make: Delivery_PLP_ProductList$MO$Empty
};

function Delivery_PLP_ProductList$MO$View(Props) {
  var query = Props.query;
  var subCategoryName = Props.subCategoryName;
  var match = usePagination(query);
  var hasNext = match.hasNext;
  var loadNext = match.loadNext;
  var products = match.data.products;
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
    return React.createElement(Delivery_PLP_ProductList$MO$Empty, {});
  } else {
    return React.createElement("div", {
                className: "w-full pt-1 px-5"
              }, React.createElement("div", {
                    className: "mt-6 mb-4 w-full flex items-center justify-between text-gray-800"
                  }, React.createElement("span", {
                        className: "font-bold"
                      }, "" + subCategoryName + " 상품"), React.createElement(DeliverySortSelect.MO.make, {})), React.createElement("ol", {
                    className: "grid grid-cols-2 gap-x-4 gap-y-8"
                  }, Belt_Array.map(products.edges, (function (param) {
                          return React.createElement(DeliveryProductListItem.MO.make, {
                                      query: param.node.fragmentRefs,
                                      key: param.cursor
                                    });
                        }))), React.createElement("div", {
                    ref: loadMoreRef,
                    className: "h-20 w-full"
                  }));
  }
}

var View$1 = {
  make: Delivery_PLP_ProductList$MO$View
};

function Delivery_PLP_ProductList$MO$Container(Props) {
  var subCategoryName = Props.subCategoryName;
  var router = Router.useRouter();
  var sort = Belt_Option.getWithDefault(Belt_Option.flatMap(Js_dict.get(router.query, "sort"), DeliverySortSelect.decodeSort), "UPDATED_DESC");
  var categoryId = Belt_Option.getWithDefault(Js_dict.get(router.query, "category-id"), "");
  var subCategoryId = Js_dict.get(router.query, "sub-category-id");
  var match = use({
        count: 20,
        displayCategoryId: Belt_Option.getWithDefault(subCategoryId, categoryId),
        onlyBuyable: true,
        sort: sort
      }, /* StoreOrNetwork */1, undefined, undefined, undefined);
  var node = match.node;
  if (node !== undefined) {
    return React.createElement(Delivery_PLP_ProductList$MO$View, {
                query: node.fragmentRefs,
                subCategoryName: subCategoryName
              });
  } else {
    return React.createElement(Delivery_PLP_ProductList$MO$Empty, {});
  }
}

var Container$1 = {
  make: Delivery_PLP_ProductList$MO$Container
};

function Delivery_PLP_ProductList$MO(Props) {
  var subCategoryName = Props.subCategoryName;
  var match = React.useState(function () {
        return false;
      });
  var setIsCsr = match[1];
  React.useEffect((function () {
          setIsCsr(function (param) {
                return true;
              });
        }), []);
  return React.createElement(RescriptReactErrorBoundary.make, {
              children: React.createElement(React.Suspense, {
                    children: React.createElement(Delivery_PLP_ProductList$MO$Container, {
                          subCategoryName: subCategoryName
                        }),
                    fallback: React.createElement(Delivery_PLP_ProductList$MO$Skeleton, {})
                  }),
              fallback: (function (param) {
                  return React.createElement(Delivery_PLP_ProductList$MO$Skeleton, {});
                })
            });
}

var MO = {
  Skeleton: Skeleton$1,
  Empty: Empty$1,
  View: View$1,
  Container: Container$1,
  make: Delivery_PLP_ProductList$MO
};

export {
  Query ,
  Fragment ,
  PC ,
  MO ,
}
/* react Not a pure module */
