// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Curry from "rescript/lib/es6/curry.js";
import * as Spice from "@greenlabs/ppx-spice/src/rescript/Spice.mjs";
import * as React from "react";
import * as Js_dict from "rescript/lib/es6/js_dict.js";
import * as Js_json from "rescript/lib/es6/js_json.js";
import * as IconError from "./svgs/IconError.mjs";
import * as Belt_Array from "rescript/lib/es6/belt_Array.js";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as Router from "next/router";
import * as ReactRelay from "react-relay";
import * as Garter_Array from "@greenlabs/garter/src/Garter_Array.mjs";
import * as ReactHookForm from "../bindings/ReactHookForm/ReactHookForm.mjs";
import * as ReactHookForm$1 from "react-hook-form";
import * as Js_null_undefined from "rescript/lib/es6/js_null_undefined.js";
import * as Select_Product_Type from "./Select_Product_Type.mjs";
import * as RescriptRelay_Internal from "rescript-relay/src/RescriptRelay_Internal.mjs";
import * as ErrorMessage from "@hookform/error-message";
import * as Search_Display_Category from "./Search_Display_Category.mjs";
import * as Search_Product_Category from "./Search_Product_Category.mjs";
import * as Select_Delivery_Available from "./Select_Delivery_Available.mjs";
import * as Select_Product_Operation_Status from "./Select_Product_Operation_Status.mjs";
import * as SearchProductAdminCategoriesFragment_graphql from "../__generated__/SearchProductAdminCategoriesFragment_graphql.mjs";

function use(fRef) {
  var data = ReactRelay.useFragment(SearchProductAdminCategoriesFragment_graphql.node, fRef);
  return RescriptRelay_Internal.internal_useConvertedValue(SearchProductAdminCategoriesFragment_graphql.Internal.convertFragment, data);
}

function useOpt(opt_fRef) {
  var fr = opt_fRef !== undefined ? Caml_option.some(Caml_option.valFromOption(opt_fRef)) : undefined;
  var nullableFragmentData = ReactRelay.useFragment(SearchProductAdminCategoriesFragment_graphql.node, fr !== undefined ? Js_null_undefined.fromOption(Caml_option.some(Caml_option.valFromOption(fr))) : null);
  var data = (nullableFragmentData == null) ? undefined : Caml_option.some(nullableFragmentData);
  return RescriptRelay_Internal.internal_useConvertedValue((function (rawFragment) {
                if (rawFragment !== undefined) {
                  return SearchProductAdminCategoriesFragment_graphql.Internal.convertFragment(rawFragment);
                }
                
              }), data);
}

var Categories_displayCategoryType_decode = SearchProductAdminCategoriesFragment_graphql.Utils.displayCategoryType_decode;

var Categories_displayCategoryType_fromString = SearchProductAdminCategoriesFragment_graphql.Utils.displayCategoryType_fromString;

var Categories = {
  displayCategoryType_decode: Categories_displayCategoryType_decode,
  displayCategoryType_fromString: Categories_displayCategoryType_fromString,
  Types: undefined,
  Operation: undefined,
  use: use,
  useOpt: useOpt
};

var Fragment = {
  Categories: Categories
};

function submit_encode(v) {
  return Js_dict.fromArray([
              [
                "producer-name",
                Spice.stringToJson(v.producerName)
              ],
              [
                "producer-codes",
                Spice.stringToJson(v.producerCodes)
              ],
              [
                "product-name",
                Spice.stringToJson(v.productName)
              ],
              [
                "product-nos",
                Spice.stringToJson(v.productNos)
              ],
              [
                "product-category",
                Search_Product_Category.Form.submit_encode(v.productCategory)
              ],
              [
                "display-category",
                Search_Display_Category.Form.submit_encode(v.displayCategory)
              ],
              [
                "status",
                Spice.stringToJson(v.status)
              ],
              [
                "delivery",
                Spice.stringToJson(v.delivery)
              ],
              [
                "product-type",
                Spice.stringToJson(v.productType)
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
  var producerName = Spice.stringFromJson(Belt_Option.getWithDefault(Js_dict.get(dict$1, "producer-name"), null));
  if (producerName.TAG === /* Ok */0) {
    var producerCodes = Spice.stringFromJson(Belt_Option.getWithDefault(Js_dict.get(dict$1, "producer-codes"), null));
    if (producerCodes.TAG === /* Ok */0) {
      var productName = Spice.stringFromJson(Belt_Option.getWithDefault(Js_dict.get(dict$1, "product-name"), null));
      if (productName.TAG === /* Ok */0) {
        var productNos = Spice.stringFromJson(Belt_Option.getWithDefault(Js_dict.get(dict$1, "product-nos"), null));
        if (productNos.TAG === /* Ok */0) {
          var productCategory = Search_Product_Category.Form.submit_decode(Belt_Option.getWithDefault(Js_dict.get(dict$1, "product-category"), null));
          if (productCategory.TAG === /* Ok */0) {
            var displayCategory = Search_Display_Category.Form.submit_decode(Belt_Option.getWithDefault(Js_dict.get(dict$1, "display-category"), null));
            if (displayCategory.TAG === /* Ok */0) {
              var status = Spice.stringFromJson(Belt_Option.getWithDefault(Js_dict.get(dict$1, "status"), null));
              if (status.TAG === /* Ok */0) {
                var delivery = Spice.stringFromJson(Belt_Option.getWithDefault(Js_dict.get(dict$1, "delivery"), null));
                if (delivery.TAG === /* Ok */0) {
                  var productType = Spice.stringFromJson(Belt_Option.getWithDefault(Js_dict.get(dict$1, "product-type"), null));
                  if (productType.TAG === /* Ok */0) {
                    return {
                            TAG: /* Ok */0,
                            _0: {
                              producerName: producerName._0,
                              producerCodes: producerCodes._0,
                              productName: productName._0,
                              productNos: productNos._0,
                              productCategory: productCategory._0,
                              displayCategory: displayCategory._0,
                              status: status._0,
                              delivery: delivery._0,
                              productType: productType._0
                            }
                          };
                  }
                  var e = productType._0;
                  return {
                          TAG: /* Error */1,
                          _0: {
                            path: "." + ("product-type" + e.path),
                            message: e.message,
                            value: e.value
                          }
                        };
                }
                var e$1 = delivery._0;
                return {
                        TAG: /* Error */1,
                        _0: {
                          path: "." + ("delivery" + e$1.path),
                          message: e$1.message,
                          value: e$1.value
                        }
                      };
              }
              var e$2 = status._0;
              return {
                      TAG: /* Error */1,
                      _0: {
                        path: "." + ("status" + e$2.path),
                        message: e$2.message,
                        value: e$2.value
                      }
                    };
            }
            var e$3 = displayCategory._0;
            return {
                    TAG: /* Error */1,
                    _0: {
                      path: "." + ("display-category" + e$3.path),
                      message: e$3.message,
                      value: e$3.value
                    }
                  };
          }
          var e$4 = productCategory._0;
          return {
                  TAG: /* Error */1,
                  _0: {
                    path: "." + ("product-category" + e$4.path),
                    message: e$4.message,
                    value: e$4.value
                  }
                };
        }
        var e$5 = productNos._0;
        return {
                TAG: /* Error */1,
                _0: {
                  path: "." + ("product-nos" + e$5.path),
                  message: e$5.message,
                  value: e$5.value
                }
              };
      }
      var e$6 = productName._0;
      return {
              TAG: /* Error */1,
              _0: {
                path: "." + ("product-name" + e$6.path),
                message: e$6.message,
                value: e$6.value
              }
            };
    }
    var e$7 = producerCodes._0;
    return {
            TAG: /* Error */1,
            _0: {
              path: "." + ("producer-codes" + e$7.path),
              message: e$7.message,
              value: e$7.value
            }
          };
  }
  var e$8 = producerName._0;
  return {
          TAG: /* Error */1,
          _0: {
            path: "." + ("producer-name" + e$8.path),
            message: e$8.message,
            value: e$8.value
          }
        };
}

var Form_formName = {
  producerName: "producer-name",
  producerCodes: "producer-codes",
  productName: "product-name",
  productNos: "product-nos",
  productCategory: "product-category",
  displayCategory: "display-category",
  status: "status",
  delivery: "delivery",
  productType: "product-type"
};

var Form = {
  formName: Form_formName,
  submit_encode: submit_encode,
  submit_decode: submit_decode
};

function getDefault(dict) {
  return {
          producerName: Js_dict.get(dict, "producer-name"),
          producerCodes: Js_dict.get(dict, "producer-codes"),
          productName: Js_dict.get(dict, "name"),
          productNos: Js_dict.get(dict, "product-nos"),
          status: Js_dict.get(dict, "status"),
          delivery: Js_dict.get(dict, "delivery"),
          productType: Js_dict.get(dict, "type")
        };
}

function Search_Product_Admin(props) {
  var defaultValue = props.defaultValue;
  var router = Router.useRouter();
  var categoriesQueryData = use(props.defaultCategoryQuery);
  var methods = ReactHookForm$1.useForm({
        mode: "all",
        defaultValues: Js_dict.fromArray([
              [
                "display-category",
                Belt_Option.getWithDefault(Belt_Option.map(Belt_Option.flatMap(categoriesQueryData.displayCategoryNode, (function (node) {
                                if (typeof node === "object" && node.NAME === "DisplayCategory") {
                                  return Search_Display_Category.encodeQualifiedNameValue(node.VAL.fullyQualifiedName);
                                }
                                
                              })), Search_Display_Category.Form.submit_encode), Search_Display_Category.Form.defaultDisplayCategory(/* Normal */0))
              ],
              [
                "product-category",
                Belt_Option.getWithDefault(Belt_Option.map(Belt_Option.flatMap(categoriesQueryData.productCategoryNode, (function (node) {
                                if (typeof node === "object" && node.NAME === "Category") {
                                  return Search_Product_Category.encodeQualifiedNameValue(node.VAL.fullyQualifiedName);
                                }
                                
                              })), Search_Product_Category.Form.submit_encode), Search_Product_Category.Form.defaultProductCategory)
              ],
              [
                "producer-name",
                Belt_Option.getWithDefault(defaultValue.producerName, "")
              ],
              [
                "producer-codes",
                Belt_Option.getWithDefault(defaultValue.producerCodes, "")
              ],
              [
                "product-name",
                Belt_Option.getWithDefault(defaultValue.productName, "")
              ],
              [
                "product-nos",
                Belt_Option.getWithDefault(defaultValue.productNos, "")
              ],
              [
                "status",
                Belt_Option.getWithDefault(defaultValue.status, "ALL")
              ],
              [
                "delivery",
                Belt_Option.getWithDefault(defaultValue.delivery, "")
              ],
              [
                "product-type",
                Belt_Option.getWithDefault(defaultValue.productType, "ALL")
              ]
            ])
      }, undefined);
  var onSubmit = function (data, param) {
    var getSelectValue = function (select) {
      if (select) {
        return select.value;
      }
      
    };
    var data$p = submit_decode(data);
    if (data$p.TAG === /* Ok */0) {
      var data$p$1 = data$p._0;
      router.query["producer-name"] = data$p$1.producerName;
      router.query["producer-codes"] = data$p$1.producerCodes;
      router.query["name"] = data$p$1.productName;
      router.query["product-nos"] = data$p$1.productNos;
      router.query["status"] = data$p$1.status;
      router.query["delivery"] = data$p$1.delivery;
      router.query["type"] = data$p$1.productType;
      var param$1 = data$p$1.productCategory;
      router.query["category-id"] = Belt_Option.getWithDefault(Garter_Array.last(Belt_Array.keepMap([
                    param$1.c1,
                    param$1.c2,
                    param$1.c3,
                    param$1.c4,
                    param$1.c5
                  ], getSelectValue)), "");
      var param$2 = data$p$1.displayCategory;
      router.query["display-category-id"] = Belt_Option.getWithDefault(Garter_Array.last(Belt_Array.keepMap([
                    param$2.c1,
                    param$2.c2,
                    param$2.c3,
                    param$2.c4,
                    param$2.c5
                  ], getSelectValue)), "");
      router.query["offset"] = "0";
      router.push("" + router.pathname + "?" + new URLSearchParams(router.query).toString() + "");
      return ;
    }
    console.log(data$p._0);
  };
  var register = methods.register;
  var reset = methods.reset;
  var control = methods.control;
  var producerName = register("producer-name", undefined);
  var producerCodes = register("producer-codes", undefined);
  var productName = register("product-name", undefined);
  var productNos = register("product-nos", {
        pattern: /^([0-9]+([,\s]+)?)*$/g
      });
  return React.createElement("div", {
              className: "p-7 mt-4 mx-4 bg-white rounded shadow-gl"
            }, React.createElement(ReactHookForm.Provider.make, {
                  children: React.createElement("form", {
                        onSubmit: methods.handleSubmit(onSubmit)
                      }, React.createElement("div", {
                            className: "py-6 px-7 flex flex-col text-sm bg-gray-gl rounded-xl"
                          }, React.createElement("div", {
                                className: "flex"
                              }, React.createElement("div", {
                                    className: "w-32 font-bold mt-2 whitespace-nowrap"
                                  }, "검색"), React.createElement("div", {
                                    className: "divide-y border-div-border-L1 w-full"
                                  }, React.createElement("div", undefined, React.createElement("div", {
                                            className: "flex items-center gap-2"
                                          }, React.createElement("div", undefined, "표준카테고리"), React.createElement("div", {
                                                className: "flex h-9 gap-2"
                                              }, React.createElement(Search_Product_Category.make, {
                                                    control: control,
                                                    name: "product-category"
                                                  }))), React.createElement("div", {
                                            className: "flex items-center gap-2 mt-2 mb-3"
                                          }, React.createElement("div", undefined, "전시카테고리"), React.createElement(Search_Display_Category.make, {
                                                control: control,
                                                name: "display-category"
                                              }))), React.createElement("div", {
                                        className: "flex flex-col gap-y-2"
                                      }, React.createElement("div", {
                                            className: "flex gap-12 mt-3"
                                          }, React.createElement("div", {
                                                className: "flex items-center grow-0"
                                              }, React.createElement("label", {
                                                    htmlFor: "producer-name"
                                                  }, React.createElement("span", {
                                                        className: "mr-2"
                                                      }, "생산자명")), React.createElement("div", {
                                                    className: "h-9 w-80"
                                                  }, React.createElement("input", {
                                                        ref: producerName.ref,
                                                        className: "w-44 py-2 px-3 border border-border-default-L1 bg-white rounded-md h-9 focus:outline-none",
                                                        id: producerName.name,
                                                        name: producerName.name,
                                                        placeholder: "생산자명 입력",
                                                        onBlur: producerName.onBlur,
                                                        onChange: producerName.onChange
                                                      }))), React.createElement("div", {
                                                className: "flex items-center grow-[0.5]"
                                              }, React.createElement("label", {
                                                    htmlFor: "producer-ids"
                                                  }, React.createElement("span", {
                                                        className: "mr-2"
                                                      }, "생산자번호")), React.createElement("input", {
                                                    ref: producerCodes.ref,
                                                    className: "w-auto py-2 px-3 border border-border-default-L1 bg-white rounded-md h-9 focus:outline-none grow",
                                                    id: producerCodes.name,
                                                    name: producerCodes.name,
                                                    placeholder: "생산자번호 입력(“,”로 구분 가능, 최대 100개 입력 가능)",
                                                    onBlur: producerCodes.onBlur,
                                                    onChange: producerCodes.onChange
                                                  }))), React.createElement("div", {
                                            className: "flex items-center"
                                          }, React.createElement("label", {
                                                htmlFor: "product-name"
                                              }, React.createElement("span", {
                                                    className: "mr-5"
                                                  }, "상품명")), React.createElement("input", {
                                                ref: productName.ref,
                                                className: "w-auto py-2 px-3 border border-border-default-L1 bg-white rounded-md h-9 focus:outline-none grow-[0.25]",
                                                id: productName.name,
                                                name: productName.name,
                                                placeholder: "상품명 입력",
                                                onBlur: productName.onBlur,
                                                onChange: productName.onChange
                                              })), React.createElement("div", {
                                            className: "flex items-center gap-2"
                                          }, React.createElement("label", {
                                                htmlFor: "product-nos"
                                              }, React.createElement("span", {
                                                    className: ""
                                                  }, "상품번호")), React.createElement("input", {
                                                ref: productNos.ref,
                                                className: "grow-[0.25] w-auto py-2 px-3 border border-border-default-L1 bg-white rounded-md h-9 focus:outline-none ",
                                                id: productNos.name,
                                                name: productNos.name,
                                                placeholder: "상품번호 입력(“,”로 구분 가능, 최대 100개 입력 가능)",
                                                onBlur: productNos.onBlur,
                                                onChange: productNos.onChange
                                              }), React.createElement(ErrorMessage.ErrorMessage, {
                                                name: productNos.name,
                                                errors: methods.formState.errors,
                                                render: (function (param) {
                                                    return React.createElement("span", {
                                                                className: "flex"
                                                              }, React.createElement(IconError.make, {
                                                                    width: "20",
                                                                    height: "20"
                                                                  }), React.createElement("span", {
                                                                    className: "text-sm text-notice ml-1"
                                                                  }, "숫자(Enter 또는 \",\"로 구분 가능)만 입력해주세요"));
                                                  })
                                              })), React.createElement("div", {
                                            className: "flex gap-12"
                                          }, React.createElement("div", {
                                                className: "flex items-center"
                                              }, React.createElement("label", {
                                                    htmlFor: "status"
                                                  }, React.createElement("span", {
                                                        className: "mr-2"
                                                      }, "판매상태")), React.createElement("div", {
                                                    className: "bg-white w-44"
                                                  }, React.createElement(ReactHookForm$1.Controller, {
                                                        name: "status",
                                                        control: Caml_option.some(control),
                                                        render: (function (param) {
                                                            var match = param.field;
                                                            var onChange = match.onChange;
                                                            var status = Select_Product_Operation_Status.Search.status_decode(match.value);
                                                            var tmp;
                                                            tmp = status.TAG === /* Ok */0 ? status._0 : /* ALL */0;
                                                            return React.createElement(Select_Product_Operation_Status.Search.make, {
                                                                        status: tmp,
                                                                        onChange: (function (status) {
                                                                            Curry._1(onChange, Curry._1(ReactHookForm.Controller.OnChangeArg.value, Select_Product_Operation_Status.Search.status_encode(status)));
                                                                          }),
                                                                        forwardRef: match.ref
                                                                      });
                                                          }),
                                                        defaultValue: Caml_option.some(Select_Product_Operation_Status.Search.status_encode(/* ALL */0))
                                                      }))), React.createElement("div", {
                                                className: "flex items-center"
                                              }, React.createElement("label", {
                                                    htmlFor: "status"
                                                  }, React.createElement("span", {
                                                        className: "mr-2"
                                                      }, "상품유형")), React.createElement("div", {
                                                    className: "bg-white w-44"
                                                  }, React.createElement(ReactHookForm$1.Controller, {
                                                        name: "product-type",
                                                        control: Caml_option.some(control),
                                                        render: (function (param) {
                                                            var match = param.field;
                                                            var onChange = match.onChange;
                                                            var status = Select_Product_Type.Search.status_decode(match.value);
                                                            var tmp;
                                                            tmp = status.TAG === /* Ok */0 ? status._0 : /* ALL */0;
                                                            return React.createElement(Select_Product_Type.Search.make, {
                                                                        status: tmp,
                                                                        onChange: (function (status) {
                                                                            Curry._1(onChange, Curry._1(ReactHookForm.Controller.OnChangeArg.value, Select_Product_Type.Search.status_encode(status)));
                                                                          })
                                                                      });
                                                          }),
                                                        defaultValue: Caml_option.some(Select_Product_Type.Search.status_encode(/* ALL */0))
                                                      }))), React.createElement("div", {
                                                className: "flex items-center gap-6"
                                              }, React.createElement("div", undefined, "택배가능여부"), React.createElement(ReactHookForm$1.Controller, {
                                                    name: "delivery",
                                                    control: Caml_option.some(control),
                                                    render: (function (param) {
                                                        var match = param.field;
                                                        var onChange = match.onChange;
                                                        var result = Select_Delivery_Available.status_decode(match.value);
                                                        var tmp;
                                                        tmp = result.TAG === /* Ok */0 ? result._0 : /* ALL */0;
                                                        return React.createElement(Select_Delivery_Available.make, {
                                                                    value: tmp,
                                                                    onChange: (function (str) {
                                                                        Curry._1(onChange, Curry._1(ReactHookForm.Controller.OnChangeArg.value, str));
                                                                      }),
                                                                    name: match.name
                                                                  });
                                                      }),
                                                    defaultValue: Caml_option.some(Select_Delivery_Available.status_encode(/* ALL */0))
                                                  }))))), React.createElement("div", {
                                    className: "flex-1"
                                  }))), React.createElement("div", {
                            className: "flex justify-center mt-5"
                          }, React.createElement("input", {
                                className: "w-20 py-2 bg-gray-button-gl text-black-gl rounded-xl ml-2 hover:bg-gray-button-gl focus:outline-none focus:ring-2 focus:ring-offset-1 focus:ring-gray-gl focus:ring-opacity-100 outline-none",
                                tabIndex: 5,
                                type: "button",
                                value: "초기화",
                                onClick: (function (param) {
                                    reset(Caml_option.some(Js_dict.fromArray([
                                                  [
                                                    "product-category",
                                                    Search_Product_Category.Form.defaultProductCategory
                                                  ],
                                                  [
                                                    "display-category",
                                                    Search_Display_Category.Form.defaultDisplayCategory(/* Normal */0)
                                                  ],
                                                  [
                                                    "producer-name",
                                                    ""
                                                  ],
                                                  [
                                                    "producer-codes",
                                                    ""
                                                  ],
                                                  [
                                                    "product-name",
                                                    ""
                                                  ],
                                                  [
                                                    "product-nos",
                                                    ""
                                                  ],
                                                  [
                                                    "status",
                                                    Select_Product_Operation_Status.Search.status_encode(/* ALL */0)
                                                  ],
                                                  [
                                                    "delivery",
                                                    ""
                                                  ],
                                                  [
                                                    "product-type",
                                                    Select_Product_Type.Search.status_encode(/* ALL */0)
                                                  ]
                                                ])));
                                  })
                              }), React.createElement("input", {
                                className: "w-20 py-2 bg-green-gl text-white font-bold rounded-xl ml-2 hover:bg-green-gl-dark focus:outline-none focus:ring-2 focus:ring-offset-1 focus:ring-green-gl focus:ring-opacity-100",
                                tabIndex: 4,
                                type: "submit",
                                value: "검색"
                              }))),
                  methods: methods
                }));
}

var make = Search_Product_Admin;

export {
  Fragment ,
  Form ,
  getDefault ,
  make ,
}
/* react Not a pure module */
