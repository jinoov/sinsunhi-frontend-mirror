// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Curry from "rescript/lib/es6/curry.js";
import * as $$Image from "../../../components/common/Image.mjs";
import * as React from "react";
import Link from "next/link";
import * as Belt_Array from "rescript/lib/es6/belt_Array.js";
import * as Js_promise from "rescript/lib/es6/js_promise.js";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as ReactRelay from "react-relay";
import * as RescriptRelay from "rescript-relay/src/RescriptRelay.mjs";
import * as RelayRuntime from "relay-runtime";
import * as RescriptRelay_Internal from "rescript-relay/src/RescriptRelay_Internal.mjs";
import * as MatchingMainCategoryQuery_graphql from "../../../__generated__/MatchingMainCategoryQuery_graphql.mjs";

function use(variables, fetchPolicy, fetchKey, networkCacheConfig, param) {
  var data = ReactRelay.useLazyLoadQuery(MatchingMainCategoryQuery_graphql.node, RescriptRelay_Internal.internal_cleanObjectFromUndefinedRaw(MatchingMainCategoryQuery_graphql.Internal.convertVariables(variables)), {
        fetchKey: fetchKey,
        fetchPolicy: RescriptRelay.mapFetchPolicy(fetchPolicy),
        networkCacheConfig: networkCacheConfig
      });
  return RescriptRelay_Internal.internal_useConvertedValue(MatchingMainCategoryQuery_graphql.Internal.convertResponse, data);
}

function useLoader(param) {
  var match = ReactRelay.useQueryLoader(MatchingMainCategoryQuery_graphql.node);
  var loadQueryFn = match[1];
  var loadQuery = React.useMemo((function () {
          return function (param, param$1, param$2, param$3) {
            return Curry._2(loadQueryFn, MatchingMainCategoryQuery_graphql.Internal.convertVariables(param), {
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
  ReactRelay.fetchQuery(environment, MatchingMainCategoryQuery_graphql.node, MatchingMainCategoryQuery_graphql.Internal.convertVariables(variables), {
          networkCacheConfig: networkCacheConfig,
          fetchPolicy: RescriptRelay.mapFetchQueryFetchPolicy(fetchPolicy)
        }).subscribe({
        next: (function (res) {
            Curry._1(onResult, {
                  TAG: /* Ok */0,
                  _0: MatchingMainCategoryQuery_graphql.Internal.convertResponse(res)
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
  var __x = ReactRelay.fetchQuery(environment, MatchingMainCategoryQuery_graphql.node, MatchingMainCategoryQuery_graphql.Internal.convertVariables(variables), {
          networkCacheConfig: networkCacheConfig,
          fetchPolicy: RescriptRelay.mapFetchQueryFetchPolicy(fetchPolicy)
        }).toPromise();
  return Js_promise.then_((function (res) {
                return Promise.resolve(MatchingMainCategoryQuery_graphql.Internal.convertResponse(res));
              }), __x);
}

function usePreloaded(queryRef, param) {
  var data = ReactRelay.usePreloadedQuery(MatchingMainCategoryQuery_graphql.node, queryRef);
  return RescriptRelay_Internal.internal_useConvertedValue(MatchingMainCategoryQuery_graphql.Internal.convertResponse, data);
}

function retain(environment, variables) {
  var operationDescriptor = RelayRuntime.createOperationDescriptor(MatchingMainCategoryQuery_graphql.node, MatchingMainCategoryQuery_graphql.Internal.convertVariables(variables));
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

function fromQueryData(id, src, name) {
  return {
          id: id,
          src: src,
          name: name
        };
}

function Matching_Main_Category$ListItem$PC$Skeleton(Props) {
  return React.createElement("li", {
              className: "mx-6 w-[112px]"
            }, React.createElement("div", {
                  className: "w-28 aspect-square rounded-lg overflow-hidden animate-pulse bg-gray-150"
                }), React.createElement("div", {
                  className: "text-gray-800 font-bold text-center h-7 flex justify-center items-center"
                }, React.createElement("div", {
                      className: "w-14 h-6 rounded-lg animate-pulse bg-gray-150"
                    })));
}

var Skeleton = {
  make: Matching_Main_Category$ListItem$PC$Skeleton
};

function Matching_Main_Category$ListItem$PC(Props) {
  var id = Props.id;
  var src = Props.src;
  var name = Props.name;
  var queryStr = new URLSearchParams([[
            "category-id",
            id
          ]]).toString();
  return React.createElement("li", {
              className: "cursor-pointer"
            }, React.createElement(Link, {
                  href: "/matching/products?" + queryStr + "",
                  children: React.createElement("a", {
                        className: "w-28 flex flex-col items-center gap-[18px]"
                      }, React.createElement("div", {
                            className: "w-28 aspect-square rounded-lg overflow-hidden"
                          }, React.createElement($$Image.make, {
                                src: src,
                                placeholder: /* Sm */0,
                                alt: id,
                                className: "w-full h-full object-cover"
                              })), React.createElement("div", {
                            className: "h-[22px] flex items-center justify-center overflow-hidden"
                          }, React.createElement("div", {
                                className: "w-28 h-7 overflow-hidden text-gray-800 font-bold text-center items-center whitespace-nowrap text-ellipsis block"
                              }, name)))
                }));
}

var PC = {
  Skeleton: Skeleton,
  make: Matching_Main_Category$ListItem$PC
};

function Matching_Main_Category$ListItem$MO$Skeleton(Props) {
  return React.createElement("li", undefined, React.createElement("div", {
                  className: "flex flex-col items-center w-[75px] gap-[9px]"
                }, React.createElement("div", {
                      className: "w-14 aspect-square rounded-lg overflow-hidden bg-gray-150 animate-pulse"
                    }), React.createElement("div", {
                      className: "h-[22px] flex items-center justify-center"
                    }, React.createElement("div", {
                          className: "w-8 h-3 text-gray-800 text-sm text-center leading-[22px] animate-pulse rounded-lg bg-gray-150"
                        }))));
}

var Skeleton$1 = {
  make: Matching_Main_Category$ListItem$MO$Skeleton
};

function Matching_Main_Category$ListItem$MO(Props) {
  var id = Props.id;
  var src = Props.src;
  var name = Props.name;
  var queryStr = new URLSearchParams([[
            "category-id",
            id
          ]]).toString();
  return React.createElement("li", undefined, React.createElement(Link, {
                  href: "/matching/products?" + queryStr + "",
                  children: React.createElement("a", {
                        className: "w-[75px] flex flex-col items-center gap-[9px]"
                      }, React.createElement("div", {
                            className: "w-14 aspect-square rounded-lg overflow-hidden"
                          }, React.createElement($$Image.make, {
                                src: src,
                                placeholder: /* Sm */0,
                                alt: id,
                                className: "w-full h-full object-cover"
                              })), React.createElement("div", {
                            className: "w-[75px] overflow-hidden text-gray-800 text-sm text-center leading-[22px] whitespace-nowrap text-ellipsis"
                          }, name))
                }));
}

var MO = {
  Skeleton: Skeleton$1,
  make: Matching_Main_Category$ListItem$MO
};

var ListItem = {
  fromQueryData: fromQueryData,
  PC: PC,
  MO: MO
};

function Matching_Main_Category$PC$View(Props) {
  var title = Props.title;
  var items = Props.items;
  return React.createElement("div", {
              className: "w-[1280px] mx-auto mt-20"
            }, React.createElement("div", {
                  className: "text-2xl text-gray-800 font-bold mb-6"
                }, React.createElement("span", undefined, title)), React.createElement("ol", {
                  className: "w-full flex overflow-hidden gap-[78px] overflow-x-scroll scrollbar-hide"
                }, Belt_Array.map(items, (function (param) {
                        var id = param.id;
                        return React.createElement(Matching_Main_Category$ListItem$PC, {
                                    id: id,
                                    src: param.src,
                                    name: param.name,
                                    key: "display-category-" + id + "-pc"
                                  });
                      }))));
}

var View = {
  make: Matching_Main_Category$PC$View
};

function Matching_Main_Category$PC$Skeleton(Props) {
  return React.createElement("div", {
              className: "w-[1280px] mx-auto mt-20 overflow-hidden overflow-x-scroll scrollbar-hide"
            }, React.createElement("div", {
                  className: "mb-6"
                }, React.createElement("div", {
                      className: "w-40 h-8 animate-pulse rounded-lg bg-gray-150"
                    })), React.createElement("ol", {
                  className: "w-full flex items-center "
                }, Belt_Array.map([
                      0,
                      1,
                      2,
                      3,
                      4,
                      5,
                      6,
                      7,
                      8,
                      9,
                      10,
                      11,
                      12,
                      13,
                      14,
                      15
                    ], (function (index) {
                        var key = "matching-main-category-placeholder-" + String(index) + "";
                        return React.createElement(Matching_Main_Category$ListItem$PC$Skeleton, {
                                    key: key
                                  });
                      }))));
}

var Skeleton$2 = {
  make: Matching_Main_Category$PC$Skeleton
};

function Matching_Main_Category$PC(Props) {
  var query = use(undefined, undefined, undefined, undefined, undefined);
  var items = Belt_Option.getWithDefault(Belt_Option.map(query.section, (function (section) {
              return Belt_Array.map(section.featuredDisplayCategories, (function (param) {
                            var image = Belt_Option.mapWithDefault(param.image, "", (function (image) {
                                    return image.original;
                                  }));
                            return {
                                    id: param.id,
                                    src: image,
                                    name: param.name
                                  };
                          }));
            })), []);
  return React.createElement(Matching_Main_Category$PC$View, {
              title: "카테고리",
              items: items
            });
}

var PC$1 = {
  View: View,
  Skeleton: Skeleton$2,
  make: Matching_Main_Category$PC
};

function Matching_Main_Category$MO$View(Props) {
  var title = Props.title;
  var items = Props.items;
  return React.createElement("div", {
              className: "w-full flex flex-col mb-5"
            }, React.createElement("div", {
                  className: "h-[50px] flex items-end  text-gray-800 font-bold ml-5 mb-6"
                }, title), React.createElement("ol", {
                  className: "w-full flex gap-2 overflow-x-scroll  scrollbar-hide"
                }, Belt_Array.map(items, (function (param) {
                        var id = param.id;
                        return React.createElement(Matching_Main_Category$ListItem$MO, {
                                    id: id,
                                    src: param.src,
                                    name: param.name,
                                    key: "display-category-" + id + "-mo"
                                  });
                      }))));
}

var View$1 = {
  make: Matching_Main_Category$MO$View
};

function Matching_Main_Category$MO$Skeleton(Props) {
  return React.createElement("div", {
              className: "w-full flex flex-col mb-5"
            }, React.createElement("div", {
                  className: "h-[50px] flex items-end  text-gray-800 font-bold ml-5"
                }, React.createElement("div", {
                      className: "w-20 h-7 rounded-lg animate-pulse bg-gray-150"
                    })), React.createElement("ol", {
                  className: "mt-6 w-full flex gap-2 overflow-x-scroll scrollbar-hide"
                }, Belt_Array.map([
                      0,
                      1,
                      2,
                      3,
                      4,
                      5,
                      6,
                      7
                    ], (function (index) {
                        var key = "matching-main-category-placeholder-" + String(index) + "";
                        return React.createElement(Matching_Main_Category$ListItem$MO$Skeleton, {
                                    key: key
                                  });
                      }))));
}

var Skeleton$3 = {
  make: Matching_Main_Category$MO$Skeleton
};

function Matching_Main_Category$MO(Props) {
  var query = use(undefined, undefined, undefined, undefined, undefined);
  var items = Belt_Option.getWithDefault(Belt_Option.map(query.section, (function (section) {
              return Belt_Array.map(section.featuredDisplayCategories, (function (param) {
                            var image = Belt_Option.mapWithDefault(param.image, "", (function (image) {
                                    return image.original;
                                  }));
                            return {
                                    id: param.id,
                                    src: image,
                                    name: param.name
                                  };
                          }));
            })), []);
  return React.createElement(Matching_Main_Category$MO$View, {
              title: "카테고리",
              items: items
            });
}

var MO$1 = {
  View: View$1,
  Skeleton: Skeleton$3,
  make: Matching_Main_Category$MO
};

export {
  Query ,
  ListItem ,
  PC$1 as PC,
  MO$1 as MO,
}
/* Image Not a pure module */
