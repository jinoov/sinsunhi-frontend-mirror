// Generated by ReScript, PLEASE EDIT WITH CARE

import * as React from "react";
import * as Js_dict from "rescript/lib/es6/js_dict.js";
import * as IconArrow from "./svgs/IconArrow.mjs";
import * as Belt_Array from "rescript/lib/es6/belt_Array.js";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as ReactEvents from "../utils/ReactEvents.mjs";
import * as Router from "next/router";
import * as Js_null_undefined from "rescript/lib/es6/js_null_undefined.js";
import * as Hooks from "react-relay/hooks";
import * as RescriptRelay_Internal from "rescript-relay/src/RescriptRelay_Internal.mjs";
import * as ShopProductListItem_Buyer from "./ShopProductListItem_Buyer.mjs";
import * as ShopMainSpecialShowcaseListBuyerFragment_graphql from "../__generated__/ShopMainSpecialShowcaseListBuyerFragment_graphql.mjs";

function use(fRef) {
  var data = Hooks.useFragment(ShopMainSpecialShowcaseListBuyerFragment_graphql.node, fRef);
  return RescriptRelay_Internal.internal_useConvertedValue(ShopMainSpecialShowcaseListBuyerFragment_graphql.Internal.convertFragment, data);
}

function useOpt(opt_fRef) {
  var fr = opt_fRef !== undefined ? Caml_option.some(Caml_option.valFromOption(opt_fRef)) : undefined;
  var nullableFragmentData = Hooks.useFragment(ShopMainSpecialShowcaseListBuyerFragment_graphql.node, fr !== undefined ? Js_null_undefined.fromOption(Caml_option.some(Caml_option.valFromOption(fr))) : null);
  var data = (nullableFragmentData == null) ? undefined : Caml_option.some(nullableFragmentData);
  return RescriptRelay_Internal.internal_useConvertedValue((function (rawFragment) {
                if (rawFragment !== undefined) {
                  return ShopMainSpecialShowcaseListBuyerFragment_graphql.Internal.convertFragment(rawFragment);
                }
                
              }), data);
}

var Fragment = {
  Types: undefined,
  use: use,
  useOpt: useOpt
};

function ShopMainSpecialShowcaseList_Buyer$PC$Placeholder(Props) {
  return React.createElement("div", undefined, Belt_Array.map(Belt_Array.range(1, 10), (function (categoryIdx) {
                    var containerStyle = categoryIdx === 1 ? "w-full bg-[#F9F9F9] py-16" : "w-full bg-white py-16";
                    return React.createElement("section", {
                                key: "showcase-skeleton-" + String(categoryIdx),
                                className: containerStyle
                              }, React.createElement("div", {
                                    className: "w-[1280px] mx-auto"
                                  }, React.createElement("div", {
                                        className: "w-[155px] h-[38px] animate-pulse bg-gray-150 rounded-lg"
                                      }), React.createElement("ol", {
                                        className: "mt-12 grid grid-cols-4 gap-x-10 gap-y-16"
                                      }, Belt_Array.map(Belt_Array.range(1, 8), (function (idx) {
                                              return React.createElement(ShopProductListItem_Buyer.PC.Placeholder.make, {
                                                          key: "category-" + String(categoryIdx) + "-product-skeleton-" + String(idx)
                                                        });
                                            })))));
                  })));
}

var Placeholder = {
  make: ShopMainSpecialShowcaseList_Buyer$PC$Placeholder
};

function ShopMainSpecialShowcaseList_Buyer$PC(Props) {
  var query = Props.query;
  var router = Router.useRouter();
  var match = use(query);
  var makeOnClick = function (id, name) {
    return function (param) {
      return ReactEvents.interceptingHandler((function (param) {
                    var prim1_query = Js_dict.fromArray([
                          [
                            "category-id",
                            id
                          ],
                          [
                            "category-name",
                            encodeURIComponent(name)
                          ]
                        ]);
                    var prim1 = {
                      pathname: "/buyer/products",
                      query: prim1_query
                    };
                    router.push(prim1);
                    
                  }), param);
    };
  };
  return Belt_Array.mapWithIndex(match.specialDisplayCategories, (function (idx, param) {
                var match = param.products;
                var edges = match.edges;
                var name = param.name;
                var id = param.id;
                var containerStyle = idx === 0 ? "w-full bg-[#F9F9F9] py-16 mb-[144px] text-gray-800" : "w-full mb-[144px] bg-white text-gray-800";
                if (edges.length !== 0) {
                  return React.createElement("section", {
                              key: "main-special-category-" + id + "-pc",
                              className: containerStyle
                            }, React.createElement("div", {
                                  className: "w-[1280px] mx-auto"
                                }, React.createElement("h1", {
                                      className: "text-2xl font-bold"
                                    }, name), React.createElement("ol", {
                                      className: "mt-12 grid grid-cols-4 gap-x-10 gap-y-16"
                                    }, Belt_Array.map(edges, (function (param) {
                                            return React.createElement(React.Suspense, {
                                                        children: React.createElement(ShopProductListItem_Buyer.PC.make, {
                                                              query: param.node.fragmentRefs
                                                            }),
                                                        fallback: React.createElement(ShopProductListItem_Buyer.PC.Placeholder.make, {}),
                                                        key: "main-special-category-" + id + "-list-item-" + param.cursor + "-pc"
                                                      });
                                          }))), match.pageInfo.hasNextPage ? React.createElement("div", {
                                        className: "mt-12 flex items-center justify-center"
                                      }, React.createElement("button", {
                                            className: "px-6 py-3 bg-gray-100 rounded-full text-sm flex items-center",
                                            onClick: makeOnClick(id, name)
                                          }, "전체보기", React.createElement(IconArrow.make, {
                                                height: "16",
                                                width: "16",
                                                fill: "#262626",
                                                className: "ml-1"
                                              }))) : null));
                } else {
                  return null;
                }
              }));
}

var PC = {
  Placeholder: Placeholder,
  make: ShopMainSpecialShowcaseList_Buyer$PC
};

function ShopMainSpecialShowcaseList_Buyer$MO$Placeholder(Props) {
  return React.createElement("div", undefined, Belt_Array.map(Belt_Array.range(1, 10), (function (categoryIdx) {
                    return React.createElement("section", {
                                key: "showcase-skeleton-" + String(categoryIdx),
                                className: "w-full px-5 mt-12"
                              }, React.createElement("div", {
                                    className: "w-full"
                                  }, React.createElement("div", {
                                        className: "w-[107px] h-[26px] animate-pulse bg-gray-150 rounded-lg"
                                      }), React.createElement("ol", {
                                        className: "mt-4 grid grid-cols-2 gap-x-4 gap-y-8"
                                      }, Belt_Array.map(Belt_Array.range(1, 6), (function (idx) {
                                              return React.createElement(ShopProductListItem_Buyer.MO.Placeholder.make, {
                                                          key: "category-" + String(categoryIdx) + "-product-skeleton-" + String(idx)
                                                        });
                                            })))));
                  })));
}

var Placeholder$1 = {
  make: ShopMainSpecialShowcaseList_Buyer$MO$Placeholder
};

function ShopMainSpecialShowcaseList_Buyer$MO(Props) {
  var query = Props.query;
  var router = Router.useRouter();
  var match = use(query);
  var makeOnClick = function (id, name) {
    return function (param) {
      return ReactEvents.interceptingHandler((function (param) {
                    var prim1_query = Js_dict.fromArray([
                          [
                            "category-id",
                            id
                          ],
                          [
                            "category-name",
                            encodeURIComponent(name)
                          ]
                        ]);
                    var prim1 = {
                      pathname: "/buyer/products",
                      query: prim1_query
                    };
                    router.push(prim1);
                    
                  }), param);
    };
  };
  return Belt_Array.map(match.specialDisplayCategories, (function (param) {
                var match = param.products;
                var edges = match.edges;
                var name = param.name;
                var id = param.id;
                if (edges.length !== 0) {
                  return React.createElement("section", {
                              key: "main-special-category-" + id + "-mobile",
                              className: "w-full px-5 mt-12"
                            }, React.createElement("div", {
                                  className: "w-full"
                                }, React.createElement("h1", {
                                      className: "text-lg font-bold"
                                    }, name), React.createElement("ol", {
                                      className: "mt-4 grid grid-cols-2 gap-x-4 gap-y-8"
                                    }, Belt_Array.map(edges, (function (param) {
                                            return React.createElement(React.Suspense, {
                                                        children: React.createElement(ShopProductListItem_Buyer.MO.make, {
                                                              query: param.node.fragmentRefs
                                                            }),
                                                        fallback: React.createElement(ShopProductListItem_Buyer.MO.Placeholder.make, {}),
                                                        key: "main-special-category-" + id + "-list-item-" + param.cursor + "-mobile"
                                                      });
                                          }))), match.pageInfo.hasNextPage ? React.createElement("div", {
                                        className: "mt-8 flex items-center justify-center"
                                      }, React.createElement("button", {
                                            className: "px-[18px] py-[10px] bg-gray-100 rounded-full text-sm flex items-center",
                                            onClick: makeOnClick(id, name)
                                          }, "전체보기", React.createElement(IconArrow.make, {
                                                height: "16",
                                                width: "16",
                                                fill: "#262626",
                                                className: "ml-1"
                                              }))) : null));
                } else {
                  return null;
                }
              }));
}

var MO = {
  Placeholder: Placeholder$1,
  make: ShopMainSpecialShowcaseList_Buyer$MO
};

export {
  Fragment ,
  PC ,
  MO ,
  
}
/* react Not a pure module */
