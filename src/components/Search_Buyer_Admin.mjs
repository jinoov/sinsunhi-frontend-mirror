// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Curry from "rescript/lib/es6/curry.js";
import * as Input from "./common/Input.mjs";
import * as React from "react";
import * as Js_dict from "rescript/lib/es6/js_dict.js";
import * as Belt_Array from "rescript/lib/es6/belt_Array.js";
import * as ReactEvents from "../utils/ReactEvents.mjs";
import * as Router from "next/router";
import * as Garter_Array from "@greenlabs/garter/src/Garter_Array.mjs";
import * as ReForm__Helpers from "@rescriptbr/reform/src/ReForm__Helpers.mjs";
import * as Query_Buyer_Form_Admin from "./Query_Buyer_Form_Admin.mjs";

function Search_Buyer_Admin(Props) {
  var router = Router.useRouter();
  var onSubmit = function (param) {
    var state = param.state;
    var name = Query_Buyer_Form_Admin.FormFields.get(state.values, /* Name */0);
    var email = Query_Buyer_Form_Admin.FormFields.get(state.values, /* Email */1);
    router.query["name"] = name;
    router.query["email"] = email;
    router.query["offset"] = "0";
    router.push(router.pathname + "?" + new URLSearchParams(router.query).toString());
    
  };
  var form = Curry._7(Query_Buyer_Form_Admin.Form.use, Query_Buyer_Form_Admin.initialState, /* Schema */{
        _0: Belt_Array.concatMany([])
      }, onSubmit, undefined, undefined, /* OnChange */0, undefined);
  var handleOnSubmit = function (param) {
    return ReactEvents.interceptingHandler((function (param) {
                  return Curry._1(form.submit, undefined);
                }), param);
  };
  React.useEffect((function () {
          Curry._1(form.resetForm, undefined);
          Garter_Array.forEach(Js_dict.entries(router.query), (function (entry) {
                  var v = entry[1];
                  var k = entry[0];
                  if (k === "name") {
                    return Curry._4(form.setFieldValue, /* Name */0, v, false, undefined);
                  } else if (k === "email") {
                    return Curry._4(form.setFieldValue, /* Email */1, v, false, undefined);
                  } else {
                    return ;
                  }
                }));
          
        }), [router.query]);
  var handleOnReset = function (param) {
    return ReactEvents.interceptingHandler((function (param) {
                  Curry._4(form.setFieldValue, /* Name */0, "", false, undefined);
                  return Curry._4(form.setFieldValue, /* Email */1, "", false, undefined);
                }), param);
  };
  var partial_arg = Curry._1(form.handleChange, /* Name */0);
  var partial_arg$1 = Curry._1(form.handleChange, /* Email */1);
  return React.createElement("div", {
              className: "p-7 mt-4 bg-white rounded shadow-gl"
            }, React.createElement("form", {
                  onSubmit: handleOnSubmit
                }, React.createElement("div", {
                      className: "py-3 flex flex-col text-sm bg-gray-gl rounded-xl"
                    }, React.createElement("div", {
                          className: "flex"
                        }, React.createElement("div", {
                              className: "w-32 font-bold mt-2 pl-7 whitespace-nowrap"
                            }, "검색"), React.createElement("div", {
                              className: "flex-1"
                            }, React.createElement("div", {
                                  className: "flex"
                                }, React.createElement("div", {
                                      className: "flex-1 flex flex-col sm:flex-initial sm:w-64 sm:flex-row sm:items-center mr-16"
                                    }, React.createElement("label", {
                                          className: "whitespace-nowrap mr-2",
                                          htmlFor: "producer-name"
                                        }, "바이어명"), React.createElement(Input.make, {
                                          type_: "text",
                                          name: "name",
                                          placeholder: "바이어명 입력",
                                          value: Query_Buyer_Form_Admin.FormFields.get(form.values, /* Name */0),
                                          onChange: (function (param) {
                                              return ReForm__Helpers.handleChange(partial_arg, param);
                                            }),
                                          error: Curry._1(form.getFieldError, /* Field */{
                                                _0: /* Name */0
                                              }),
                                          tabIndex: 1
                                        })), React.createElement("div", {
                                      className: "min-w-1/2 flex items-center"
                                    }, React.createElement("label", {
                                          className: "whitespace-nowrap mr-2",
                                          htmlFor: "producer-code"
                                        }, "이메일"), React.createElement("span", {
                                          className: "flex-1"
                                        }, React.createElement(Input.make, {
                                              type_: "text",
                                              name: "email",
                                              placeholder: "이메일 입력",
                                              value: Query_Buyer_Form_Admin.FormFields.get(form.values, /* Email */1),
                                              onChange: (function (param) {
                                                  return ReForm__Helpers.handleChange(partial_arg$1, param);
                                                }),
                                              error: Curry._1(form.getFieldError, /* Field */{
                                                    _0: /* Email */1
                                                  }),
                                              tabIndex: 2
                                            }))))))), React.createElement("div", {
                      className: "flex justify-center mt-5"
                    }, React.createElement("input", {
                          className: "w-20 py-2 bg-gray-button-gl text-black-gl rounded-xl ml-2 hover:bg-gray-button-gl focus:outline-none focus:ring-2 focus:ring-offset-1 focus:ring-gray-gl focus:ring-opacity-100",
                          tabIndex: 5,
                          type: "button",
                          value: "초기화",
                          onClick: handleOnReset
                        }), React.createElement("input", {
                          className: "w-20 py-2 bg-green-gl text-white font-bold rounded-xl ml-2 hover:bg-green-gl-dark focus:outline-none focus:ring-2 focus:ring-offset-1 focus:ring-green-gl focus:ring-opacity-100",
                          tabIndex: 4,
                          type: "submit",
                          value: "검색"
                        }))));
}

var FormFields;

var Form;

var make = Search_Buyer_Admin;

export {
  FormFields ,
  Form ,
  make ,
  
}
/* Input Not a pure module */
