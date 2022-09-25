// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Curry from "rescript/lib/es6/curry.js";
import * as Input from "./common/Input.mjs";
import * as React from "react";
import * as Js_dict from "rescript/lib/es6/js_dict.js";
import * as Belt_Array from "rescript/lib/es6/belt_Array.js";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as ReactEvents from "../utils/ReactEvents.mjs";
import * as Router from "next/router";
import * as Garter_Array from "@greenlabs/garter/src/Garter_Array.mjs";
import * as ReForm__Helpers from "@rescriptbr/reform/src/ReForm__Helpers.mjs";
import * as Select_Product_Status from "./Select_Product_Status.mjs";
import * as Query_Product_Form_Buyer from "./Query_Product_Form_Buyer.mjs";

function Search_Product_Buyer(props) {
  var router = Router.useRouter();
  var match = React.useState(function () {
        return Select_Product_Status.parseStatus(router.query);
      });
  var setStatus = match[1];
  var status = match[0];
  var handleOnChageStatus = function (e) {
    var newStatus = e.target.value;
    setStatus(function (param) {
          return Belt_Option.getWithDefault(Select_Product_Status.decodeStatus(newStatus), /* ALL */0);
        });
  };
  var onSubmit = function (param) {
    var productName = Query_Product_Form_Buyer.FormFields.get(param.state.values, /* ProductName */0);
    router.query["product-name"] = productName;
    router.query["status"] = Select_Product_Status.encodeStatus(status);
    router.query["offset"] = "0";
    router.push("" + router.pathname + "?" + new URLSearchParams(router.query).toString() + "");
  };
  var form = Curry._7(Query_Product_Form_Buyer.Form.use, Query_Product_Form_Buyer.initialState, /* Schema */{
        _0: Belt_Array.concatMany([])
      }, onSubmit, undefined, undefined, /* OnChange */0, undefined);
  var handleOnSubmit = function (param) {
    return ReactEvents.interceptingHandler((function (param) {
                  Curry._1(form.submit, undefined);
                }), param);
  };
  React.useEffect((function () {
          Curry._1(form.resetForm, undefined);
          Garter_Array.forEach(Js_dict.entries(router.query), (function (entry) {
                  var v = entry[1];
                  var k = entry[0];
                  if (k === "product-name") {
                    return Curry._4(form.setFieldValue, /* ProductName */0, v, false, undefined);
                  } else if (k === "status") {
                    return setStatus(function (param) {
                                return Belt_Option.getWithDefault(Select_Product_Status.decodeStatus(v), /* ALL */0);
                              });
                  } else {
                    return ;
                  }
                }));
        }), [router.query]);
  var handleOnReset = function (param) {
    return ReactEvents.interceptingHandler((function (param) {
                  Curry._4(form.setFieldValue, /* ProductName */0, "", false, undefined);
                }), param);
  };
  var partial_arg = Curry._1(form.handleChange, /* ProductName */0);
  return React.createElement("div", {
              className: "py-7 px-4 shadow-gl sm:mt-4"
            }, React.createElement("form", {
                  className: "lg:px-4",
                  onSubmit: handleOnSubmit
                }, React.createElement("div", {
                      className: "py-3 flex flex-col text-sm bg-gray-gl rounded-xl"
                    }, React.createElement("div", {
                          className: "flex flex-col lg:flex-row"
                        }, React.createElement("div", {
                              className: "w-32 font-bold pl-3 whitespace-nowrap lg:pl-7 lg:pt-3"
                            }, "검색"), React.createElement("div", {
                              className: "flex-1 px-3 lg:px-0"
                            }, React.createElement("div", {
                                  className: "flex mt-2 flex-col sm:flex-row"
                                }, React.createElement("div", {
                                      className: "flex-1 flex flex-col mr-2 mb-2 sm:w-64 sm:flex-initial sm:flex-row sm:items-center sm:mr-16 sm:mb-0"
                                    }, React.createElement("label", {
                                          className: "whitespace-nowrap mr-2 mb-1 sm:mb-0",
                                          htmlFor: "product-status"
                                        }, "판매상태"), React.createElement(Select_Product_Status.make, {
                                          status: status,
                                          onChange: handleOnChageStatus
                                        })), React.createElement("div", {
                                      className: "min-w-1/2 flex flex-col sm:flex-initial sm:flex-row sm:items-center sm:mt-0"
                                    }, React.createElement("label", {
                                          className: "whitespace-nowrap mr-2 mb-1 sm:mb-0",
                                          htmlFor: "product-name"
                                        }, "상품명"), React.createElement("span", {
                                          className: "flex-1"
                                        }, React.createElement(Input.make, {
                                              type_: "text",
                                              name: "product-name",
                                              placeholder: "상품명 입력",
                                              value: Query_Product_Form_Buyer.FormFields.get(form.values, /* ProductName */0),
                                              onChange: (function (param) {
                                                  return ReForm__Helpers.handleChange(partial_arg, param);
                                                }),
                                              error: Curry._1(form.getFieldError, /* Field */{
                                                    _0: /* ProductName */0
                                                  }),
                                              tabIndex: 2
                                            }))))))), React.createElement("div", {
                      className: "flex justify-center mt-5"
                    }, React.createElement("input", {
                          className: "w-20 py-2 bg-gray-button-gl text-black-gl rounded-xl ml-2 hover:bg-gray-button-gl focus:outline-none focus:ring-2 focus:ring-offset-1 focus:ring-gray-gl focus:ring-opacity-100",
                          tabIndex: 4,
                          type: "button",
                          value: "초기화",
                          onClick: handleOnReset
                        }), React.createElement("input", {
                          className: "w-20 py-2 bg-green-gl text-white font-bold rounded-xl ml-2 hover:bg-green-gl-dark focus:outline-none focus:ring-2 focus:ring-offset-1 focus:ring-green-gl focus:ring-opacity-100",
                          tabIndex: 3,
                          type: "submit",
                          value: "검색"
                        }))));
}

var FormFields;

var Form;

var Select;

var make = Search_Product_Buyer;

export {
  FormFields ,
  Form ,
  Select ,
  make ,
}
/* Input Not a pure module */
