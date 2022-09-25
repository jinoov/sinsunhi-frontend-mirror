// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Curry from "rescript/lib/es6/curry.js";
import * as Input from "./common/Input.mjs";
import * as React from "react";
import * as Js_dict from "rescript/lib/es6/js_dict.js";
import * as Textarea from "./common/Textarea.mjs";
import * as Belt_Array from "rescript/lib/es6/belt_Array.js";
import * as ReactEvents from "../utils/ReactEvents.mjs";
import * as Router from "next/router";
import * as Garter_Array from "@greenlabs/garter/src/Garter_Array.mjs";
import * as IconArrowSelect from "./svgs/IconArrowSelect.mjs";
import * as ReForm__Helpers from "@rescriptbr/reform/src/ReForm__Helpers.mjs";
import * as Query_Cost_Form_Admin from "./Query_Cost_Form_Admin.mjs";

function parseProductIdentifier(value) {
  if (value === "product-ids") {
    return /* ProductIds */0;
  } else if (value === "product-sku") {
    return /* ProductSkus */1;
  } else {
    return ;
  }
}

function stringifyProductIdentifier(productIdentifier) {
  if (productIdentifier) {
    return "단품번호";
  } else {
    return "상품번호";
  }
}

function Summary_Cost_Admin(props) {
  var router = Router.useRouter();
  var match = React.useState(function () {
        return /* ProductIds */0;
      });
  var setProductIdentifier = match[1];
  var productIdentifier = match[0];
  var onSubmit = function (param) {
    var state = param.state;
    var producerName = Query_Cost_Form_Admin.FormFields.get(state.values, /* ProducerName */0);
    var productName = Query_Cost_Form_Admin.FormFields.get(state.values, /* ProductName */1);
    var productIdsOrSkus = Query_Cost_Form_Admin.FormFields.get(state.values, /* ProductIdsOrSkus */2);
    Js_dict.unsafeDeleteKey(router.query, "product-ids");
    Js_dict.unsafeDeleteKey(router.query, "skus");
    router.query["producer-name"] = producerName;
    router.query["product-name"] = productName;
    if (productIdentifier) {
      router.query["skus"] = productIdsOrSkus;
    } else {
      router.query["product-ids"] = productIdsOrSkus;
    }
    router.push("" + router.pathname + "?" + new URLSearchParams(router.query).toString() + "");
  };
  var form = Curry._7(Query_Cost_Form_Admin.Form.use, Query_Cost_Form_Admin.initialState, /* Schema */{
        _0: Belt_Array.concatMany([Curry._4(Query_Cost_Form_Admin.Form.ReSchema.Validation.regExp, "숫자(Enter 또는 \",\"로 구분 가능)만 입력해주세요", "^([0-9]+([,\n\\s]+)?)*$", undefined, /* ProductIdsOrSkus */2)])
      }, onSubmit, undefined, undefined, /* OnChange */0, undefined);
  var handleOnSubmit = function (param) {
    return ReactEvents.interceptingHandler((function (param) {
                  Curry._1(form.submit, undefined);
                }), param);
  };
  React.useEffect((function () {
          Garter_Array.forEach(Js_dict.entries(router.query), (function (entry) {
                  var v = entry[1];
                  var k = entry[0];
                  if (k === "producer-name") {
                    return Curry._4(form.setFieldValue, /* ProducerName */0, v, true, undefined);
                  } else if (k === "product-name") {
                    return Curry._4(form.setFieldValue, /* ProductName */1, v, true, undefined);
                  } else if (k === "product-ids") {
                    setProductIdentifier(function (param) {
                          return /* ProductIds */0;
                        });
                    return Curry._4(form.setFieldValue, /* ProductIdsOrSkus */2, v, true, undefined);
                  } else if (k === "skus") {
                    setProductIdentifier(function (param) {
                          return /* ProductSkus */1;
                        });
                    return Curry._4(form.setFieldValue, /* ProductIdsOrSkus */2, v, true, undefined);
                  } else {
                    return ;
                  }
                }));
        }), [router.query]);
  var handleOnReset = function (param) {
    return ReactEvents.interceptingHandler((function (param) {
                  Curry._4(form.setFieldValue, /* ProducerName */0, "", true, undefined);
                  Curry._4(form.setFieldValue, /* ProductName */1, "", true, undefined);
                  Curry._4(form.setFieldValue, /* ProductIdsOrSkus */2, "", true, undefined);
                }), param);
  };
  var handleKeyDownEnter = function (e) {
    if (e.keyCode === 13 && e.shiftKey === false) {
      e.preventDefault();
      return Curry._1(form.submit, undefined);
    }
    
  };
  var partial_arg = Curry._1(form.handleChange, /* ProducerName */0);
  var partial_arg$1 = Curry._1(form.handleChange, /* ProductName */1);
  var partial_arg$2 = Curry._1(form.handleChange, /* ProductIdsOrSkus */2);
  return React.createElement("div", {
              className: "p-7 m-4 bg-white shadow-gl rounded"
            }, React.createElement("form", {
                  onSubmit: handleOnSubmit
                }, React.createElement("h2", {
                      className: "text-text-L1 text-lg font-bold mb-5"
                    }, "상품 검색"), React.createElement("div", {
                      className: "py-6 flex flex-col text-sm bg-gray-gl rounded-xl"
                    }, React.createElement("div", {
                          className: "flex"
                        }, React.createElement("div", {
                              className: "w-32 font-bold mt-2 pl-7 whitespace-nowrap"
                            }, "검색"), React.createElement("div", {
                              className: "flex-1"
                            }, React.createElement("div", {
                                  className: "flex"
                                }, React.createElement("div", {
                                      className: "flex w-64 items-center mr-14"
                                    }, React.createElement("label", {
                                          className: "block whitespace-nowrap w-20 mr-2",
                                          htmlFor: "seller-name"
                                        }, "생산자명"), React.createElement(Input.make, {
                                          type_: "text",
                                          name: "seller-name",
                                          placeholder: "생산자명",
                                          className: "flex-1",
                                          value: Query_Cost_Form_Admin.FormFields.get(form.values, /* ProducerName */0),
                                          onChange: (function (param) {
                                              return ReForm__Helpers.handleChange(partial_arg, param);
                                            }),
                                          tabIndex: 1
                                        })), React.createElement("div", {
                                      className: "flex w-64 items-center"
                                    }, React.createElement("label", {
                                          className: "whitespace-nowrap w-16",
                                          htmlFor: "product-name"
                                        }, "상품명"), React.createElement(Input.make, {
                                          type_: "text",
                                          name: "product-name",
                                          placeholder: "상품명",
                                          value: Query_Cost_Form_Admin.FormFields.get(form.values, /* ProductName */1),
                                          onChange: (function (param) {
                                              return ReForm__Helpers.handleChange(partial_arg$1, param);
                                            }),
                                          tabIndex: 2
                                        }))), React.createElement("div", {
                                  className: "flex mt-3"
                                }, React.createElement("div", {
                                      className: "w-64 flex items-center mr-2"
                                    }, React.createElement("label", {
                                          className: "block whitespace-nowrap w-16",
                                          htmlFor: "product-identifier"
                                        }, "범위"), React.createElement("div", {
                                          className: "flex-1 block relative"
                                        }, React.createElement("span", {
                                              className: "flex items-center border border-border-default-L1 rounded-lg py-2 px-3 text-enabled-L1 bg-white leading-4.5"
                                            }, productIdentifier ? "단품번호" : "상품번호"), React.createElement("span", {
                                              className: "absolute top-1.5 right-2"
                                            }, React.createElement(IconArrowSelect.make, {
                                                  height: "24",
                                                  width: "24",
                                                  fill: "#121212"
                                                })), React.createElement("select", {
                                              className: "block w-full h-full absolute top-0 opacity-0",
                                              id: "product-identifier",
                                              value: productIdentifier ? "단품번호" : "상품번호",
                                              onChange: (function (param) {
                                                  var value = param.target.value;
                                                  if (value === "상품번호") {
                                                    return setProductIdentifier(function (param) {
                                                                return /* ProductIds */0;
                                                              });
                                                  } else if (value === "단품번호") {
                                                    return setProductIdentifier(function (param) {
                                                                return /* ProductSkus */1;
                                                              });
                                                  } else {
                                                    return setProductIdentifier(function (param) {
                                                                return /* ProductIds */0;
                                                              });
                                                  }
                                                })
                                            }, React.createElement("option", {
                                                  value: "상품번호"
                                                }, "상품번호"), React.createElement("option", {
                                                  value: "단품번호"
                                                }, "단품번호")))), React.createElement("div", {
                                      className: "min-w-1/2 flex items-center"
                                    }, React.createElement(Textarea.make, {
                                          type_: "text",
                                          name: "product-identifiers",
                                          placeholder: "상품번호 입력(Enter 또는 “,”로 구분 가능, 최대 100개 입력 가능)",
                                          className: "flex-1",
                                          value: Query_Cost_Form_Admin.FormFields.get(form.values, /* ProductIdsOrSkus */2),
                                          onChange: (function (param) {
                                              return ReForm__Helpers.handleChange(partial_arg$2, param);
                                            }),
                                          error: Curry._1(form.getFieldError, /* Field */{
                                                _0: /* ProductIdsOrSkus */2
                                              }),
                                          tabIndex: 5,
                                          rows: 1,
                                          onKeyDown: handleKeyDownEnter
                                        })))))), React.createElement("div", {
                      className: "flex justify-center mt-5"
                    }, React.createElement("span", {
                          className: "w-20 h-11 flex mr-2"
                        }, React.createElement("input", {
                              className: "btn-level6",
                              tabIndex: 7,
                              type: "button",
                              value: "초기화",
                              onClick: handleOnReset
                            })), React.createElement("span", {
                          className: "w-20 h-11 flex"
                        }, React.createElement("input", {
                              className: "btn-level1",
                              tabIndex: 6,
                              type: "submit",
                              value: "검색"
                            })))));
}

var FormFields;

var Form;

var make = Summary_Cost_Admin;

export {
  FormFields ,
  Form ,
  parseProductIdentifier ,
  stringifyProductIdentifier ,
  make ,
}
/* Input Not a pure module */
