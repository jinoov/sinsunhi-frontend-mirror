// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Curry from "rescript/lib/es6/curry.js";
import * as React from "react";
import * as Js_dict from "rescript/lib/es6/js_dict.js";
import * as Belt_Int from "rescript/lib/es6/belt_Int.js";
import * as Garter_Fn from "@greenlabs/garter/src/Garter_Fn.mjs";
import * as Belt_Array from "rescript/lib/es6/belt_Array.js";
import * as Js_promise from "rescript/lib/es6/js_promise.js";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as CustomHooks from "../../utils/CustomHooks.mjs";
import * as Router from "next/router";
import * as ReactRelay from "react-relay";
import * as Authorization from "../../utils/Authorization.mjs";
import * as RescriptRelay from "rescript-relay/src/RescriptRelay.mjs";
import * as RelayRuntime from "relay-runtime";
import * as Products_List_Admin from "../../components/Products_List_Admin.mjs";
import * as Select_CountPerPage from "../../components/Select_CountPerPage.mjs";
import * as Select_Product_Type from "../../components/Select_Product_Type.mjs";
import * as Search_Product_Admin from "../../components/Search_Product_Admin.mjs";
import * as RescriptRelay_Internal from "rescript-relay/src/RescriptRelay_Internal.mjs";
import * as ProductsAdminQuery_graphql from "../../__generated__/ProductsAdminQuery_graphql.mjs";
import * as RescriptReactErrorBoundary from "@rescript/react/src/RescriptReactErrorBoundary.mjs";
import * as Select_Product_Operation_Status from "../../components/Select_Product_Operation_Status.mjs";
import * as ExcelRequest_Button_Products_Admin from "../../components/ExcelRequest_Button_Products_Admin.mjs";
import * as ProductsAdminCategoriesQuery_graphql from "../../__generated__/ProductsAdminCategoriesQuery_graphql.mjs";

function use(variables, fetchPolicy, fetchKey, networkCacheConfig, param) {
  var data = ReactRelay.useLazyLoadQuery(ProductsAdminQuery_graphql.node, RescriptRelay_Internal.internal_cleanObjectFromUndefinedRaw(ProductsAdminQuery_graphql.Internal.convertVariables(variables)), {
        fetchKey: fetchKey,
        fetchPolicy: RescriptRelay.mapFetchPolicy(fetchPolicy),
        networkCacheConfig: networkCacheConfig
      });
  return RescriptRelay_Internal.internal_useConvertedValue(ProductsAdminQuery_graphql.Internal.convertResponse, data);
}

function useLoader(param) {
  var match = ReactRelay.useQueryLoader(ProductsAdminQuery_graphql.node);
  var loadQueryFn = match[1];
  var loadQuery = React.useMemo((function () {
          return function (param, param$1, param$2, param$3) {
            return Curry._2(loadQueryFn, ProductsAdminQuery_graphql.Internal.convertVariables(param), {
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
  ReactRelay.fetchQuery(environment, ProductsAdminQuery_graphql.node, ProductsAdminQuery_graphql.Internal.convertVariables(variables), {
          networkCacheConfig: networkCacheConfig,
          fetchPolicy: RescriptRelay.mapFetchQueryFetchPolicy(fetchPolicy)
        }).subscribe({
        next: (function (res) {
            Curry._1(onResult, {
                  TAG: /* Ok */0,
                  _0: ProductsAdminQuery_graphql.Internal.convertResponse(res)
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
  var __x = ReactRelay.fetchQuery(environment, ProductsAdminQuery_graphql.node, ProductsAdminQuery_graphql.Internal.convertVariables(variables), {
          networkCacheConfig: networkCacheConfig,
          fetchPolicy: RescriptRelay.mapFetchQueryFetchPolicy(fetchPolicy)
        }).toPromise();
  return Js_promise.then_((function (res) {
                return Promise.resolve(ProductsAdminQuery_graphql.Internal.convertResponse(res));
              }), __x);
}

function usePreloaded(queryRef, param) {
  var data = ReactRelay.usePreloadedQuery(ProductsAdminQuery_graphql.node, queryRef);
  return RescriptRelay_Internal.internal_useConvertedValue(ProductsAdminQuery_graphql.Internal.convertResponse, data);
}

function retain(environment, variables) {
  var operationDescriptor = RelayRuntime.createOperationDescriptor(ProductsAdminQuery_graphql.node, ProductsAdminQuery_graphql.Internal.convertVariables(variables));
  return environment.retain(operationDescriptor);
}

var Query_productStatus_decode = ProductsAdminQuery_graphql.Utils.productStatus_decode;

var Query_productStatus_fromString = ProductsAdminQuery_graphql.Utils.productStatus_fromString;

var Query_productType_decode = ProductsAdminQuery_graphql.Utils.productType_decode;

var Query_productType_fromString = ProductsAdminQuery_graphql.Utils.productType_fromString;

var Query = {
  productStatus_decode: Query_productStatus_decode,
  productStatus_fromString: Query_productStatus_fromString,
  productType_decode: Query_productType_decode,
  productType_fromString: Query_productType_fromString,
  Operation: undefined,
  Types: undefined,
  use: use,
  useLoader: useLoader,
  $$fetch: $$fetch,
  fetchPromised: fetchPromised,
  usePreloaded: usePreloaded,
  retain: retain
};

function use$1(variables, fetchPolicy, fetchKey, networkCacheConfig, param) {
  var data = ReactRelay.useLazyLoadQuery(ProductsAdminCategoriesQuery_graphql.node, RescriptRelay_Internal.internal_cleanObjectFromUndefinedRaw(ProductsAdminCategoriesQuery_graphql.Internal.convertVariables(variables)), {
        fetchKey: fetchKey,
        fetchPolicy: RescriptRelay.mapFetchPolicy(fetchPolicy),
        networkCacheConfig: networkCacheConfig
      });
  return RescriptRelay_Internal.internal_useConvertedValue(ProductsAdminCategoriesQuery_graphql.Internal.convertResponse, data);
}

function useLoader$1(param) {
  var match = ReactRelay.useQueryLoader(ProductsAdminCategoriesQuery_graphql.node);
  var loadQueryFn = match[1];
  var loadQuery = React.useMemo((function () {
          return function (param, param$1, param$2, param$3) {
            return Curry._2(loadQueryFn, ProductsAdminCategoriesQuery_graphql.Internal.convertVariables(param), {
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

function $$fetch$1(environment, variables, onResult, networkCacheConfig, fetchPolicy, param) {
  ReactRelay.fetchQuery(environment, ProductsAdminCategoriesQuery_graphql.node, ProductsAdminCategoriesQuery_graphql.Internal.convertVariables(variables), {
          networkCacheConfig: networkCacheConfig,
          fetchPolicy: RescriptRelay.mapFetchQueryFetchPolicy(fetchPolicy)
        }).subscribe({
        next: (function (res) {
            Curry._1(onResult, {
                  TAG: /* Ok */0,
                  _0: ProductsAdminCategoriesQuery_graphql.Internal.convertResponse(res)
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

function fetchPromised$1(environment, variables, networkCacheConfig, fetchPolicy, param) {
  var __x = ReactRelay.fetchQuery(environment, ProductsAdminCategoriesQuery_graphql.node, ProductsAdminCategoriesQuery_graphql.Internal.convertVariables(variables), {
          networkCacheConfig: networkCacheConfig,
          fetchPolicy: RescriptRelay.mapFetchQueryFetchPolicy(fetchPolicy)
        }).toPromise();
  return Js_promise.then_((function (res) {
                return Promise.resolve(ProductsAdminCategoriesQuery_graphql.Internal.convertResponse(res));
              }), __x);
}

function usePreloaded$1(queryRef, param) {
  var data = ReactRelay.usePreloadedQuery(ProductsAdminCategoriesQuery_graphql.node, queryRef);
  return RescriptRelay_Internal.internal_useConvertedValue(ProductsAdminCategoriesQuery_graphql.Internal.convertResponse, data);
}

function retain$1(environment, variables) {
  var operationDescriptor = RelayRuntime.createOperationDescriptor(ProductsAdminCategoriesQuery_graphql.node, ProductsAdminCategoriesQuery_graphql.Internal.convertVariables(variables));
  return environment.retain(operationDescriptor);
}

var QueryCategories = {
  Operation: undefined,
  Types: undefined,
  use: use$1,
  useLoader: useLoader$1,
  $$fetch: $$fetch$1,
  fetchPromised: fetchPromised$1,
  usePreloaded: usePreloaded$1,
  retain: retain$1
};

function Products_Admin$Skeleton(Props) {
  return React.createElement("div", {
              className: "max-w-gnb-panel overflow-auto overflow-x-scroll bg-div-shape-L1 min-h-gnb-admin"
            }, React.createElement("header", {
                  className: "flex items-baseline p-7 pb-0"
                }, React.createElement("h1", {
                      className: "text-text-L1 text-xl font-bold"
                    }, "상품 조회")), React.createElement("div", {
                  className: "p-7 mt-4 mx-4 bg-white rounded shadow-gl"
                }, React.createElement("div", {
                      className: "py-6 px-7 flex flex-col text-sm bg-gray-gl rounded-xl"
                    })), React.createElement("div", {
                  className: "p-7 m-4 shadow-gl overflow-auto overflow-x-scroll bg-white rounded"
                }));
}

var Skeleton = {
  make: Products_Admin$Skeleton
};

function useSearchDefaultValue(param) {
  var match = Router.useRouter();
  return Search_Product_Admin.getDefault(match.query);
}

function useCategorySearchInput(param) {
  var match = Router.useRouter();
  var query = match.query;
  return {
          displayCategoryId: Belt_Option.getWithDefault(Js_dict.get(query, "display-category-id"), ""),
          productCategoryId: Belt_Option.getWithDefault(Js_dict.get(query, "category-id"), "")
        };
}

function Products_Admin$Search(Props) {
  var defaultValue = useSearchDefaultValue(undefined);
  var categorySearchInput = useCategorySearchInput(undefined);
  var categoryQueryData = use$1(categorySearchInput, undefined, undefined, undefined, undefined);
  return React.createElement(Search_Product_Admin.make, {
              defaultValue: defaultValue,
              defaultCategoryQuery: categoryQueryData.fragmentRefs
            });
}

var Search = {
  useSearchDefaultValue: useSearchDefaultValue,
  useCategorySearchInput: useCategorySearchInput,
  make: Products_Admin$Search
};

function useSearchInput(param) {
  var match = Router.useRouter();
  var query = match.query;
  var match$1 = Js_dict.get(query, "delivery");
  var tmp;
  if (match$1 !== undefined) {
    switch (match$1) {
      case "available" :
          tmp = true;
          break;
      case "unavailable" :
          tmp = false;
          break;
      default:
        tmp = undefined;
    }
  } else {
    tmp = undefined;
  }
  var match$2 = Belt_Option.map(Js_dict.get(query, "type"), (function (str) {
          return Select_Product_Type.Search.status_decode(str);
        }));
  var tmp$1;
  if (match$2 !== undefined) {
    if (match$2.TAG === /* Ok */0) {
      switch (match$2._0) {
        case /* ALL */0 :
            tmp$1 = [];
            break;
        case /* NORMAL */1 :
            tmp$1 = ["NORMAL"];
            break;
        case /* QUOTED */2 :
            tmp$1 = ["QUOTED"];
            break;
        case /* QUOTABLE */3 :
            tmp$1 = ["QUOTABLE"];
            break;
        case /* MATCHING */4 :
            tmp$1 = ["MATCHING"];
            break;
        
      }
    } else {
      tmp$1 = [];
    }
  } else {
    tmp$1 = [];
  }
  var match$3 = Belt_Option.map(Js_dict.get(query, "status"), (function (str) {
          return Select_Product_Operation_Status.Base.status_decode(str);
        }));
  var tmp$2;
  var exit = 0;
  if (match$3 !== undefined && match$3.TAG === /* Ok */0) {
    switch (match$3._0) {
      case /* SALE */0 :
          tmp$2 = ["SALE"];
          break;
      case /* SOLDOUT */1 :
          tmp$2 = ["SOLDOUT"];
          break;
      case /* NOSALE */2 :
          tmp$2 = ["NOSALE"];
          break;
      case /* RETIRE */3 :
          tmp$2 = ["RETIRE"];
          break;
      case /* HIDDEN_SALE */4 :
          tmp$2 = ["HIDDEN_SALE"];
          break;
      
    }
  } else {
    exit = 1;
  }
  if (exit === 1) {
    tmp$2 = [
      "SALE",
      "SOLDOUT",
      "NOSALE",
      "RETIRE",
      "HIDDEN_SALE"
    ];
  }
  return {
          displayCategoryId: Belt_Option.getWithDefault(Js_dict.get(query, "display-category-id"), ""),
          isDelivery: tmp,
          limit: Belt_Option.getWithDefault(Belt_Option.flatMap(Js_dict.get(query, "limit"), Belt_Int.fromString), 25),
          name: Belt_Option.keep(Js_dict.get(query, "product-name"), (function (str) {
                  return str !== "";
                })),
          offset: Belt_Option.flatMap(Js_dict.get(query, "offset"), Belt_Int.fromString),
          producerCodes: Belt_Option.map(Belt_Option.map(Belt_Option.keep(Js_dict.get(query, "producer-codes"), (function (a) {
                          return a !== "";
                        })), (function (str) {
                      return str.split(new RegExp("\\s*[,\n\\s]\\s*"));
                    })), (function (a) {
                  return Belt_Array.keep(Belt_Array.keepMap(a, Garter_Fn.identity), (function (str) {
                                return str !== "";
                              }));
                })),
          producerName: Belt_Option.keep(Js_dict.get(query, "producer-name"), (function (str) {
                  return str !== "";
                })),
          productCategoryId: Belt_Option.getWithDefault(Js_dict.get(query, "category-id"), ""),
          productNos: Belt_Option.map(Belt_Option.map(Belt_Option.keep(Js_dict.get(query, "product-nos"), (function (a) {
                          return a !== "";
                        })), (function (str) {
                      return str.split(new RegExp("\\s*[,\n\\s]\s*"));
                    })), (function (a) {
                  return Belt_Array.keepMap(Belt_Array.keepMap(a, Garter_Fn.identity), Belt_Int.fromString);
                })),
          productType: tmp$1,
          statuses: tmp$2
        };
}

function Products_Admin$List(Props) {
  var user = CustomHooks.Auth.use(undefined);
  var searchInput = useSearchInput(undefined);
  var match = use(searchInput, /* NetworkOnly */3, undefined, undefined, undefined);
  return React.createElement(React.Fragment, undefined, React.createElement("div", {
                  className: "md:flex md:justify-between pb-4"
                }, React.createElement("div", {
                      className: "flex flex-auto justify-between"
                    }, React.createElement("h3", {
                          className: "font-bold"
                        }, "내역", React.createElement("span", {
                              className: "ml-1 text-green-gl font-normal"
                            }, "" + String(match.products.totalCount) + "건")), React.createElement("div", {
                          className: "flex"
                        }, React.createElement(Select_CountPerPage.make, {
                              className: "mr-2"
                            }), typeof user === "number" || user._0.role !== 2 ? null : React.createElement(ExcelRequest_Button_Products_Admin.make, {})))), React.createElement(Products_List_Admin.make, {
                  query: match.fragmentRefs
                }));
}

var List = {
  useSearchInput: useSearchInput,
  make: Products_Admin$List
};

function Products_Admin$Products(Props) {
  return React.createElement("div", {
              className: "max-w-gnb-panel overflow-auto overflow-x-scroll bg-div-shape-L1 min-h-screen"
            }, React.createElement("header", {
                  className: "flex items-baseline p-7 pb-0"
                }, React.createElement("h1", {
                      className: "text-text-L1 text-xl font-bold"
                    }, "상품 조회")), React.createElement(React.Suspense, {
                  children: React.createElement(Products_Admin$Search, {}),
                  fallback: React.createElement("div", undefined)
                }), React.createElement("div", {
                  className: "p-7 m-4 overflow-auto overflow-x-scroll bg-white rounded shadow-gl"
                }, React.createElement(React.Suspense, {
                      children: React.createElement(Products_Admin$List, {}),
                      fallback: React.createElement(Products_List_Admin.Skeleton.make, {})
                    })));
}

var Products = {
  make: Products_Admin$Products
};

function Products_Admin(Props) {
  return React.createElement(Authorization.Admin.make, {
              children: React.createElement(RescriptReactErrorBoundary.make, {
                    children: React.createElement(React.Suspense, {
                          children: React.createElement(Products_Admin$Products, {}),
                          fallback: React.createElement(Products_Admin$Skeleton, {})
                        }),
                    fallback: (function (param) {
                        return React.createElement("div", undefined, "에러 발생");
                      })
                  }),
              title: "관리자 상품 조회"
            });
}

var make = Products_Admin;

export {
  Query ,
  QueryCategories ,
  Skeleton ,
  Search ,
  List ,
  Products ,
  make ,
}
/* react Not a pure module */
