// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Cn from "rescript-classnames/src/Cn.mjs";
import * as Curry from "rescript/lib/es6/curry.js";
import * as React from "react";
import * as Divider from "../../../components/common/Divider.mjs";
import * as Js_dict from "rescript/lib/es6/js_dict.js";
import * as Belt_Array from "rescript/lib/es6/belt_Array.js";
import * as Js_promise from "rescript/lib/es6/js_promise.js";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as Router from "next/router";
import * as ReactRelay from "react-relay";
import * as RescriptRelay from "rescript-relay/src/RescriptRelay.mjs";
import * as RelayRuntime from "relay-runtime";
import * as Webapi__Dom__Element from "rescript-webapi/src/Webapi/Dom/Webapi__Dom__Element.mjs";
import * as RescriptRelay_Internal from "rescript-relay/src/RescriptRelay_Internal.mjs";
import * as PLP_Scrollable_Tab_Item from "./PLP_Scrollable_Tab_Item.mjs";
import * as PLPScrollableHeaderQuery_graphql from "../../../__generated__/PLPScrollableHeaderQuery_graphql.mjs";

function use(variables, fetchPolicy, fetchKey, networkCacheConfig, param) {
  var data = ReactRelay.useLazyLoadQuery(PLPScrollableHeaderQuery_graphql.node, RescriptRelay_Internal.internal_cleanObjectFromUndefinedRaw(PLPScrollableHeaderQuery_graphql.Internal.convertVariables(variables)), {
        fetchKey: fetchKey,
        fetchPolicy: RescriptRelay.mapFetchPolicy(fetchPolicy),
        networkCacheConfig: networkCacheConfig
      });
  return RescriptRelay_Internal.internal_useConvertedValue(PLPScrollableHeaderQuery_graphql.Internal.convertResponse, data);
}

function useLoader(param) {
  var match = ReactRelay.useQueryLoader(PLPScrollableHeaderQuery_graphql.node);
  var loadQueryFn = match[1];
  var loadQuery = React.useMemo((function () {
          return function (param, param$1, param$2, param$3) {
            return Curry._2(loadQueryFn, PLPScrollableHeaderQuery_graphql.Internal.convertVariables(param), {
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
  ReactRelay.fetchQuery(environment, PLPScrollableHeaderQuery_graphql.node, PLPScrollableHeaderQuery_graphql.Internal.convertVariables(variables), {
          networkCacheConfig: networkCacheConfig,
          fetchPolicy: RescriptRelay.mapFetchQueryFetchPolicy(fetchPolicy)
        }).subscribe({
        next: (function (res) {
            Curry._1(onResult, {
                  TAG: /* Ok */0,
                  _0: PLPScrollableHeaderQuery_graphql.Internal.convertResponse(res)
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
  var __x = ReactRelay.fetchQuery(environment, PLPScrollableHeaderQuery_graphql.node, PLPScrollableHeaderQuery_graphql.Internal.convertVariables(variables), {
          networkCacheConfig: networkCacheConfig,
          fetchPolicy: RescriptRelay.mapFetchQueryFetchPolicy(fetchPolicy)
        }).toPromise();
  return Js_promise.then_((function (res) {
                return Promise.resolve(PLPScrollableHeaderQuery_graphql.Internal.convertResponse(res));
              }), __x);
}

function usePreloaded(queryRef, param) {
  var data = ReactRelay.usePreloadedQuery(PLPScrollableHeaderQuery_graphql.node, queryRef);
  return RescriptRelay_Internal.internal_useConvertedValue(PLPScrollableHeaderQuery_graphql.Internal.convertResponse, data);
}

function retain(environment, variables) {
  var operationDescriptor = RelayRuntime.createOperationDescriptor(PLPScrollableHeaderQuery_graphql.node, PLPScrollableHeaderQuery_graphql.Internal.convertVariables(variables));
  return environment.retain(operationDescriptor);
}

var Query_displayCategoryType_decode = PLPScrollableHeaderQuery_graphql.Utils.displayCategoryType_decode;

var Query_displayCategoryType_fromString = PLPScrollableHeaderQuery_graphql.Utils.displayCategoryType_fromString;

var Query = {
  displayCategoryType_decode: Query_displayCategoryType_decode,
  displayCategoryType_fromString: Query_displayCategoryType_fromString,
  Operation: undefined,
  Types: undefined,
  use: use,
  useLoader: useLoader,
  $$fetch: $$fetch,
  fetchPromised: fetchPromised,
  usePreloaded: usePreloaded,
  retain: retain
};

function PLP_Scrollable_Header$PC$ScrollTab(Props) {
  var items = Props.items;
  var router = Router.useRouter();
  var cid = Js_dict.get(router.query, "cid");
  var categoryId = cid !== undefined ? cid : Js_dict.get(router.query, "category-id");
  React.useEffect((function () {
          var windowWidth = window.innerWidth;
          var container = document.getElementById("horizontal-scroll-container");
          var target = document.getElementById("category-" + Belt_Option.getWithDefault(categoryId, "") + "");
          if (!(container == null) && !(target == null)) {
            var targetWidth = target.clientWidth;
            var target$p$p = Webapi__Dom__Element.asHtmlElement(target);
            var targetLeft = target$p$p !== undefined ? Caml_option.valFromOption(target$p$p).offsetLeft : undefined;
            Belt_Option.map(targetLeft, (function (targetLeft$p) {
                    container.scrollLeft = (targetLeft$p - (windowWidth / 2 | 0) | 0) + (targetWidth / 2 | 0) | 0;
                  }));
          }
          
        }), [categoryId]);
  return React.createElement("section", {
              className: "w-full mx-auto bg-white border-b border-gray-50 "
            }, React.createElement("ol", {
                  className: "overflow-x-scroll scrollbar-hide flex items-center px-2 gap-4",
                  id: "horizontal-scroll-container"
                }, Belt_Array.map(items, (function (item) {
                        return React.createElement(PLP_Scrollable_Tab_Item.PC.make, {
                                    selected: item.id === Belt_Option.getWithDefault(categoryId, ""),
                                    item: item,
                                    key: item.id
                                  });
                      }))));
}

var ScrollTab = {
  make: PLP_Scrollable_Header$PC$ScrollTab
};

function PLP_Scrollable_Header$PC$Skeleton(Props) {
  return React.createElement(React.Fragment, undefined, React.createElement("div", {
                  className: "inline-flex flex-col w-full"
                }, React.createElement("div", {
                      className: "w-[160px] h-6 rounded-lg animate-pulse bg-gray-150 mb-9"
                    }), React.createElement("div", {
                      className: "h-12 px-5 scrollbar-hide border-b border-gray-50"
                    }, React.createElement("div", {
                          className: "flex gap-4 h-full"
                        }, Belt_Array.map(Belt_Array.range(0, 10), (function (idx) {
                                return React.createElement(PLP_Scrollable_Tab_Item.PC.Skeleton.make, {
                                            key: String(idx)
                                          });
                              }))))));
}

var Skeleton = {
  make: PLP_Scrollable_Header$PC$Skeleton
};

function PLP_Scrollable_Header$PC(Props) {
  var parentId = Props.parentId;
  var match = use({
        parentId: parentId
      }, undefined, undefined, undefined, undefined);
  var node = match.node;
  if (node === undefined) {
    return React.createElement(PLP_Scrollable_Header$PC$Skeleton, {});
  }
  var match$1 = node.type_;
  var match$2 = node.children;
  var match$3;
  var exit = 0;
  if (match$1 === "NORMAL") {
    if (match$2.length !== 0) {
      exit = 1;
    } else {
      var parentNode = node.parent;
      var id = Belt_Option.mapWithDefault(parentNode, "", (function (parentNode$p) {
              return parentNode$p.id;
            }));
      var name = Belt_Option.mapWithDefault(parentNode, "", (function (parentNode$p) {
              return parentNode$p.name;
            }));
      var restItem = Belt_Array.map(Belt_Option.mapWithDefault(parentNode, [], (function (parentNode$p) {
                  return parentNode$p.children;
                })), (function (item) {
              return PLP_Scrollable_Tab_Item.Data.make(item.id, item.name, /* Specific */1);
            }));
      match$3 = [
        id,
        restItem,
        name,
        true
      ];
    }
  } else if (match$1 === "SHOWCASE" && match$2.length === 0) {
    var parentNode$1 = node.parent;
    var id$1 = Belt_Option.mapWithDefault(parentNode$1, "", (function (parentNode$p) {
            return parentNode$p.id;
          }));
    var name$1 = node.name;
    var restItem$1 = Belt_Array.map(Belt_Option.mapWithDefault(parentNode$1, [], (function (parentNode$p) {
                return parentNode$p.children;
              })), (function (item) {
            return PLP_Scrollable_Tab_Item.Data.make(item.id, item.name, /* Specific */1);
          }));
    match$3 = [
      id$1,
      restItem$1,
      name$1,
      false
    ];
  } else {
    exit = 1;
  }
  if (exit === 1) {
    var id$2 = node.id;
    var name$2 = node.name;
    var restItem$2 = Belt_Array.map(match$2, (function (item) {
            return PLP_Scrollable_Tab_Item.Data.make(item.id, item.name, /* Specific */1);
          }));
    match$3 = [
      id$2,
      restItem$2,
      name$2,
      true
    ];
  }
  var title = match$3[2];
  var firstItem = PLP_Scrollable_Tab_Item.Data.make(match$3[0], "" + title + " 전체", /* All */0);
  var items = Belt_Array.concat([firstItem], Belt_Array.map(match$3[1], (function (item) {
              return PLP_Scrollable_Tab_Item.Data.make(item.id, item.name, /* Specific */1);
            })));
  return React.createElement(React.Suspense, {
              children: React.createElement("div", {
                    className: "inline-flex flex-col w-full"
                  }, React.createElement("div", {
                        className: "font-bold text-3xl text-gray-800 mb-[29px]"
                      }, title), match$3[3] ? React.createElement(PLP_Scrollable_Header$PC$ScrollTab, {
                          items: items
                        }) : null),
              fallback: React.createElement(PLP_Scrollable_Header$PC$Skeleton, {})
            });
}

var PC = {
  ScrollTab: ScrollTab,
  Skeleton: Skeleton,
  make: PLP_Scrollable_Header$PC
};

function PLP_Scrollable_Header$MO$View(Props) {
  var items = Props.items;
  var router = Router.useRouter();
  var cid = Js_dict.get(router.query, "cid");
  var categoryId = cid !== undefined ? cid : Js_dict.get(router.query, "category-id");
  React.useEffect((function () {
          var windowWidth = window.innerWidth;
          var container = document.getElementById("horizontal-scroll-container");
          var target = document.getElementById("category-" + Belt_Option.getWithDefault(categoryId, "") + "");
          if (!(container == null) && !(target == null)) {
            var targetWidth = target.clientWidth;
            var target$p$p = Webapi__Dom__Element.asHtmlElement(target);
            var targetLeft = target$p$p !== undefined ? Caml_option.valFromOption(target$p$p).offsetLeft : undefined;
            Belt_Option.map(targetLeft, (function (targetLeft$p) {
                    container.scrollLeft = (targetLeft$p - (windowWidth / 2 | 0) | 0) + (targetWidth / 2 | 0) | 0;
                  }));
          }
          
        }), [categoryId]);
  return React.createElement("div", {
              className: Cn.make(["w-full z-[5] bg-white left-0"])
            }, React.createElement("section", {
                  className: "w-full max-w-3xl mx-auto bg-white border-b border-gray-50"
                }, React.createElement("ol", {
                      className: "overflow-x-scroll scrollbar-hide flex items-center px-4 gap-4",
                      id: "horizontal-scroll-container"
                    }, Belt_Array.map(items, (function (item) {
                            return React.createElement(PLP_Scrollable_Tab_Item.MO.make, {
                                        selected: item.id === Belt_Option.getWithDefault(categoryId, ""),
                                        item: item,
                                        key: item.id
                                      });
                          })))));
}

var View = {
  make: PLP_Scrollable_Header$MO$View
};

function PLP_Scrollable_Header$MO$Skeleton(Props) {
  return React.createElement(React.Fragment, undefined, React.createElement("section", {
                  className: "h-11 px-2 scrollbar-hide w-full overflow-x-scroll"
                }, React.createElement("ol", {
                      className: "w-fit flex items-center gap-2"
                    }, Belt_Array.map(Belt_Array.range(0, 8), (function (idx) {
                            return React.createElement(PLP_Scrollable_Tab_Item.MO.Skeleton.make, {
                                        key: String(idx)
                                      });
                          })))), React.createElement(Divider.make, {
                  className: "mt-0 bg-gray-50"
                }));
}

var Skeleton$1 = {
  make: PLP_Scrollable_Header$MO$Skeleton
};

function PLP_Scrollable_Header$MO(Props) {
  var parentId = Props.parentId;
  var match = use({
        parentId: parentId
      }, undefined, undefined, undefined, undefined);
  var node = match.node;
  var children = Belt_Option.mapWithDefault(node, [], (function (node) {
          return node.children;
        }));
  var match$1;
  if (children.length !== 0) {
    var id = Belt_Option.mapWithDefault(node, "", (function (node$p) {
            return node$p.id;
          }));
    var name = Belt_Option.mapWithDefault(node, "", (function (node$p) {
            return node$p.name;
          }));
    var firstItem = PLP_Scrollable_Tab_Item.Data.make(id, "" + name + " 전체", /* All */0);
    var restItem = Belt_Array.map(children, (function (item) {
            return PLP_Scrollable_Tab_Item.Data.make(item.id, item.name, /* Specific */1);
          }));
    match$1 = [
      firstItem,
      restItem
    ];
  } else {
    var parentNode = Belt_Option.flatMap(node, (function (node$p) {
            return node$p.parent;
          }));
    var id$1 = Belt_Option.mapWithDefault(parentNode, "", (function (parentNode$p) {
            return parentNode$p.id;
          }));
    var name$1 = Belt_Option.mapWithDefault(parentNode, "", (function (parentNode$p) {
            return parentNode$p.name;
          }));
    var firstItem$1 = PLP_Scrollable_Tab_Item.Data.make(id$1, "" + name$1 + " 전체", /* All */0);
    var restItem$1 = Belt_Array.map(Belt_Option.mapWithDefault(parentNode, [], (function (node) {
                return node.children;
              })), (function (item) {
            return PLP_Scrollable_Tab_Item.Data.make(item.id, item.name, /* Specific */1);
          }));
    match$1 = [
      firstItem$1,
      restItem$1
    ];
  }
  var items = Belt_Array.concat([match$1[0]], Belt_Array.map(match$1[1], (function (item) {
              return PLP_Scrollable_Tab_Item.Data.make(item.id, item.name, /* Specific */1);
            })));
  return React.createElement(React.Suspense, {
              children: React.createElement(PLP_Scrollable_Header$MO$View, {
                    items: items
                  }),
              fallback: React.createElement(PLP_Scrollable_Header$MO$Skeleton, {})
            });
}

var MO = {
  View: View,
  Skeleton: Skeleton$1,
  make: PLP_Scrollable_Header$MO
};

export {
  Query ,
  PC ,
  MO ,
}
/* react Not a pure module */