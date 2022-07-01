// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Curry from "rescript/lib/es6/curry.js";
import * as Spice from "@greenlabs/ppx-spice/src/rescript/Spice.mjs";
import * as React from "react";
import * as Js_dict from "rescript/lib/es6/js_dict.js";
import * as Js_json from "rescript/lib/es6/js_json.js";
import * as Belt_Array from "rescript/lib/es6/belt_Array.js";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as Belt_Result from "rescript/lib/es6/belt_Result.js";
import * as Caml_module from "rescript/lib/es6/caml_module.js";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as ReactSelect from "./common/ReactSelect.mjs";
import * as Garter_Array from "@greenlabs/garter/src/Garter_Array.mjs";
import ReactSelect$1 from "react-select";
import * as ReactHookForm from "../bindings/ReactHookForm/ReactHookForm.mjs";
import * as RescriptRelay from "rescript-relay/src/RescriptRelay.mjs";
import * as RelayRuntime from "relay-runtime";
import * as ReactHookForm$1 from "react-hook-form";
import * as Hooks from "react-relay/hooks";
import * as RescriptRelay_Internal from "rescript-relay/src/RescriptRelay_Internal.mjs";
import * as SelectProductCategoryQuery_graphql from "../__generated__/SelectProductCategoryQuery_graphql.mjs";

function use(variables, fetchPolicy, fetchKey, networkCacheConfig, param) {
  var data = Hooks.useLazyLoadQuery(SelectProductCategoryQuery_graphql.node, RescriptRelay_Internal.internal_cleanObjectFromUndefinedRaw(SelectProductCategoryQuery_graphql.Internal.convertVariables(variables)), {
        fetchKey: fetchKey,
        fetchPolicy: RescriptRelay.mapFetchPolicy(fetchPolicy),
        networkCacheConfig: networkCacheConfig
      });
  return RescriptRelay_Internal.internal_useConvertedValue(SelectProductCategoryQuery_graphql.Internal.convertResponse, data);
}

function useLoader(param) {
  var match = Hooks.useQueryLoader(SelectProductCategoryQuery_graphql.node);
  var loadQueryFn = match[1];
  var loadQuery = React.useMemo((function () {
          return function (param, param$1, param$2, param$3) {
            return Curry._2(loadQueryFn, SelectProductCategoryQuery_graphql.Internal.convertVariables(param), {
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
  Hooks.fetchQuery(environment, SelectProductCategoryQuery_graphql.node, SelectProductCategoryQuery_graphql.Internal.convertVariables(variables), {
          networkCacheConfig: networkCacheConfig,
          fetchPolicy: RescriptRelay.mapFetchQueryFetchPolicy(fetchPolicy)
        }).subscribe({
        next: (function (res) {
            return Curry._1(onResult, {
                        TAG: /* Ok */0,
                        _0: SelectProductCategoryQuery_graphql.Internal.convertResponse(res)
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
  var __x = Hooks.fetchQuery(environment, SelectProductCategoryQuery_graphql.node, SelectProductCategoryQuery_graphql.Internal.convertVariables(variables), {
          networkCacheConfig: networkCacheConfig,
          fetchPolicy: RescriptRelay.mapFetchQueryFetchPolicy(fetchPolicy)
        }).toPromise();
  return __x.then(function (res) {
              return Promise.resolve(SelectProductCategoryQuery_graphql.Internal.convertResponse(res));
            });
}

function usePreloaded(queryRef, param) {
  var data = Hooks.usePreloadedQuery(SelectProductCategoryQuery_graphql.node, queryRef);
  return RescriptRelay_Internal.internal_useConvertedValue(SelectProductCategoryQuery_graphql.Internal.convertResponse, data);
}

function retain(environment, variables) {
  var operationDescriptor = RelayRuntime.createOperationDescriptor(SelectProductCategoryQuery_graphql.node, SelectProductCategoryQuery_graphql.Internal.convertVariables(variables));
  return environment.retain(operationDescriptor);
}

var Query_makeVariables = SelectProductCategoryQuery_graphql.Utils.makeVariables;

var Query = {
  makeVariables: Query_makeVariables,
  Types: undefined,
  use: use,
  useLoader: useLoader,
  $$fetch: $$fetch,
  fetchPromised: fetchPromised,
  usePreloaded: usePreloaded,
  retain: retain
};

function submit_encode(v) {
  return Js_dict.fromArray([
              [
                "c1",
                Curry._1(ReactSelect.codecSelectOption[0], v.c1)
              ],
              [
                "c2",
                Curry._1(ReactSelect.codecSelectOption[0], v.c2)
              ],
              [
                "c3",
                Curry._1(ReactSelect.codecSelectOption[0], v.c3)
              ],
              [
                "c4",
                Curry._1(ReactSelect.codecSelectOption[0], v.c4)
              ],
              [
                "c5",
                Curry._1(ReactSelect.codecSelectOption[0], v.c5)
              ]
            ]);
}

function submit_decode(v) {
  var dict = Js_json.classify(v);
  if (typeof dict === "number") {
    return Spice.error(undefined, "Not an object", v);
  }
  if (dict.TAG !== /* JSONObject */2) {
    return Spice.error(undefined, "Not an object", v);
  }
  var dict$1 = dict._0;
  var c1 = Curry._1(ReactSelect.codecSelectOption[1], Belt_Option.getWithDefault(Js_dict.get(dict$1, "c1"), null));
  if (c1.TAG === /* Ok */0) {
    var c2 = Curry._1(ReactSelect.codecSelectOption[1], Belt_Option.getWithDefault(Js_dict.get(dict$1, "c2"), null));
    if (c2.TAG === /* Ok */0) {
      var c3 = Curry._1(ReactSelect.codecSelectOption[1], Belt_Option.getWithDefault(Js_dict.get(dict$1, "c3"), null));
      if (c3.TAG === /* Ok */0) {
        var c4 = Curry._1(ReactSelect.codecSelectOption[1], Belt_Option.getWithDefault(Js_dict.get(dict$1, "c4"), null));
        if (c4.TAG === /* Ok */0) {
          var c5 = Curry._1(ReactSelect.codecSelectOption[1], Belt_Option.getWithDefault(Js_dict.get(dict$1, "c5"), null));
          if (c5.TAG === /* Ok */0) {
            return {
                    TAG: /* Ok */0,
                    _0: {
                      c1: c1._0,
                      c2: c2._0,
                      c3: c3._0,
                      c4: c4._0,
                      c5: c5._0
                    }
                  };
          }
          var e = c5._0;
          return {
                  TAG: /* Error */1,
                  _0: {
                    path: ".c5" + e.path,
                    message: e.message,
                    value: e.value
                  }
                };
        }
        var e$1 = c4._0;
        return {
                TAG: /* Error */1,
                _0: {
                  path: ".c4" + e$1.path,
                  message: e$1.message,
                  value: e$1.value
                }
              };
      }
      var e$2 = c3._0;
      return {
              TAG: /* Error */1,
              _0: {
                path: ".c3" + e$2.path,
                message: e$2.message,
                value: e$2.value
              }
            };
    }
    var e$3 = c2._0;
    return {
            TAG: /* Error */1,
            _0: {
              path: ".c2" + e$3.path,
              message: e$3.message,
              value: e$3.value
            }
          };
  }
  var e$4 = c1._0;
  return {
          TAG: /* Error */1,
          _0: {
            path: ".c1" + e$4.path,
            message: e$4.message,
            value: e$4.value
          }
        };
}

var Form = {
  submit_encode: submit_encode,
  submit_decode: submit_decode
};

function encodeQualifiedNameValue(query) {
  return {
          c1: Belt_Option.mapWithDefault(Belt_Array.get(query, 0), /* NotSelected */0, (function (d) {
                  return /* Selected */{
                          value: d.id,
                          label: d.name
                        };
                })),
          c2: Belt_Option.mapWithDefault(Belt_Array.get(query, 1), /* NotSelected */0, (function (d) {
                  return /* Selected */{
                          value: d.id,
                          label: d.name
                        };
                })),
          c3: Belt_Option.mapWithDefault(Belt_Array.get(query, 2), /* NotSelected */0, (function (d) {
                  return /* Selected */{
                          value: d.id,
                          label: d.name
                        };
                })),
          c4: Belt_Option.mapWithDefault(Belt_Array.get(query, 3), /* NotSelected */0, (function (d) {
                  return /* Selected */{
                          value: d.id,
                          label: d.name
                        };
                })),
          c5: Belt_Option.mapWithDefault(Belt_Array.get(query, 4), /* NotSelected */0, (function (d) {
                  return /* Selected */{
                          value: d.id,
                          label: d.name
                        };
                }))
        };
}

var Skeleton = Caml_module.init_mod([
      "Select_Product_Category.res",
      62,
      32
    ], {
      TAG: /* Module */0,
      _0: [[
          /* Function */0,
          "make"
        ]]
    });

function Select_Product_Category$Skeleton(Props) {
  var placeholders = Props.placeholders;
  var placeholder$p = Garter_Array.first(placeholders);
  if (placeholder$p !== undefined) {
    return React.createElement(React.Fragment, undefined, React.createElement("div", {
                    className: "relative w-48"
                  }, React.createElement("div", {
                        className: "absolute w-full"
                      }, React.createElement(ReactSelect$1, {
                            value: /* NotSelected */0,
                            options: [],
                            onChange: (function (param) {
                                
                              }),
                            placeholder: placeholder$p,
                            noOptionsMessage: (function (param) {
                                return "검색 결과가 없습니다.";
                              }),
                            isDisabled: true,
                            styles: {
                              control: (function (provide, param) {
                                  return Object.assign(Object.assign({}, provide), {
                                              minHeight: "unset",
                                              height: "2.25rem"
                                            });
                                })
                            }
                          }))), React.createElement(Skeleton.make, {
                    placeholders: Garter_Array.sliceToEnd(placeholders, 1)
                  }));
  } else {
    return null;
  }
}

Caml_module.update_mod({
      TAG: /* Module */0,
      _0: [[
          /* Function */0,
          "make"
        ]]
    }, Skeleton, {
      make: Select_Product_Category$Skeleton
    });

var Category = Caml_module.init_mod([
      "Select_Product_Category.res",
      121,
      32
    ], {
      TAG: /* Module */0,
      _0: [[
          /* Function */0,
          "make"
        ]]
    });

var $$Selection = Caml_module.init_mod([
      "Select_Product_Category.res",
      155,
      27
    ], {
      TAG: /* Module */0,
      _0: [[
          /* Function */0,
          "make"
        ]]
    });

function Select_Product_Category$Category(Props) {
  var parentId = Props.parentId;
  var control = Props.control;
  var name = Props.name;
  var categoryNamePrefixes = Props.categoryNamePrefixes;
  var placeholders = Props.placeholders;
  var disabled = Props.disabled;
  var required = Props.required;
  var prefix = Garter_Array.first(categoryNamePrefixes);
  var placeholder = Garter_Array.first(placeholders);
  if (prefix !== undefined && placeholder !== undefined) {
    return React.createElement(React.Suspense, {
                children: React.createElement($$Selection.make, {
                      parentId: parentId,
                      control: control,
                      name: name,
                      prefix: prefix,
                      placeholder: placeholder,
                      categoryNamePrefixes: categoryNamePrefixes,
                      placeholders: placeholders,
                      disabled: disabled,
                      required: required
                    }),
                fallback: React.createElement(Skeleton.make, {
                      placeholders: placeholders
                    })
              });
  } else {
    return null;
  }
}

Caml_module.update_mod({
      TAG: /* Module */0,
      _0: [[
          /* Function */0,
          "make"
        ]]
    }, Category, {
      make: Select_Product_Category$Category
    });

function Select_Product_Category$Selection(Props) {
  var parentId = Props.parentId;
  var control = Props.control;
  var name = Props.name;
  var prefix = Props.prefix;
  var placeholder = Props.placeholder;
  var categoryNamePrefixes = Props.categoryNamePrefixes;
  var placeholders = Props.placeholders;
  var disabled = Props.disabled;
  var required = Props.required;
  var match = use({
        parentId: parentId
      }, undefined, undefined, undefined, undefined);
  var categories = match.categories;
  var selectedId = ReactHookForm$1.useWatch({
        name: name + "." + prefix + ".value",
        control: control
      });
  var match$1 = ReactHookForm$1.useFormContext({
        mode: "onChange"
      }, undefined);
  var setValue = match$1.setValue;
  React.useEffect((function () {
          var isStillSameCategory = Belt_Option.flatMap(selectedId, (function (selectedIdNull) {
                  return Belt_Option.map((selectedIdNull == null) ? undefined : Caml_option.some(selectedIdNull), (function (selectedId$p) {
                                return Belt_Array.some(categories, (function (d) {
                                              return d.id === selectedId$p;
                                            }));
                              }));
                }));
          var exit = 0;
          if (!(isStillSameCategory !== undefined && isStillSameCategory)) {
            exit = 1;
          }
          if (exit === 1) {
            setValue(name + "." + prefix, ReactSelect.encoderRule(/* NotSelected */0));
          }
          
        }), [parentId]);
  if (categories.length !== 0) {
    return React.createElement(React.Fragment, undefined, React.createElement("div", {
                    className: "relative w-48"
                  }, React.createElement("div", {
                        className: "absolute w-full"
                      }, React.createElement(ReactHookForm$1.Controller, {
                            name: name + "." + prefix,
                            control: control,
                            render: (function (param) {
                                var match = param.field;
                                var onChange = match.onChange;
                                return React.createElement(ReactSelect$1, {
                                            value: Belt_Result.getWithDefault(ReactSelect.decoderRule(match.value), /* NotSelected */0),
                                            options: Belt_Array.map(categories, (function (o) {
                                                    return /* Selected */{
                                                            value: o.id,
                                                            label: o.name
                                                          };
                                                  })),
                                            onChange: (function (param) {
                                                return Curry._1(onChange, Curry._1(ReactHookForm.Controller.OnChangeArg.value, ReactSelect.encoderRule(param)));
                                              }),
                                            placeholder: placeholder,
                                            noOptionsMessage: (function (param) {
                                                return "검색 결과가 없습니다.";
                                              }),
                                            isDisabled: disabled || prefix !== "c1" && Belt_Option.isNone(parentId),
                                            styles: {
                                              control: (function (provide, param) {
                                                  return Object.assign(Object.assign({}, provide), {
                                                              minHeight: "unset",
                                                              height: "2.25rem"
                                                            });
                                                })
                                            },
                                            ref: match.ref
                                          });
                              }),
                            defaultValue: ReactSelect.encoderRule(/* NotSelected */0),
                            rules: ReactHookForm.Rules.make(required, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined),
                            shouldUnregister: true
                          }))), React.createElement(Category.make, {
                    parentId: Belt_Option.flatMap(selectedId, (function (prim) {
                            if (prim == null) {
                              return ;
                            } else {
                              return Caml_option.some(prim);
                            }
                          })),
                    control: control,
                    name: name,
                    categoryNamePrefixes: Garter_Array.sliceToEnd(categoryNamePrefixes, 1),
                    placeholders: Garter_Array.sliceToEnd(placeholders, 1),
                    disabled: disabled,
                    required: required
                  }));
  } else {
    return null;
  }
}

Caml_module.update_mod({
      TAG: /* Module */0,
      _0: [[
          /* Function */0,
          "make"
        ]]
    }, $$Selection, {
      make: Select_Product_Category$Selection
    });

function Select_Product_Category(Props) {
  var control = Props.control;
  var name = Props.name;
  var disabledOpt = Props.disabled;
  var requiredOpt = Props.required;
  var disabled = disabledOpt !== undefined ? disabledOpt : false;
  var required = requiredOpt !== undefined ? requiredOpt : true;
  var categoryNamePrefixes = [
    "c1",
    "c2",
    "c3",
    "c4",
    "c5"
  ];
  var placeholders = [
    "카테고리 선택",
    "대분류선택",
    "부류선택",
    "작물선택",
    "품종선택"
  ];
  return React.createElement(Category.make, {
              parentId: undefined,
              control: control,
              name: name,
              categoryNamePrefixes: categoryNamePrefixes,
              placeholders: placeholders,
              disabled: disabled,
              required: required
            });
}

var make = Select_Product_Category;

export {
  Query ,
  Form ,
  encodeQualifiedNameValue ,
  Skeleton ,
  Category ,
  $$Selection ,
  make ,
  
}
/* Skeleton Not a pure module */