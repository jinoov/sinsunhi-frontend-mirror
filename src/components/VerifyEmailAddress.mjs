// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Env from "../constants/Env.mjs";
import * as Curry from "rescript/lib/es6/curry.js";
import * as Input from "./common/Input.mjs";
import * as Spice from "@greenlabs/ppx-spice/src/rescript/Spice.mjs";
import * as React from "react";
import * as Dialog from "./common/Dialog.mjs";
import * as ReForm from "@rescriptbr/reform/src/ReForm.mjs";
import * as Js_dict from "rescript/lib/es6/js_dict.js";
import * as Js_json from "rescript/lib/es6/js_json.js";
import * as Belt_Array from "rescript/lib/es6/belt_Array.js";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as FetchHelper from "../utils/FetchHelper.mjs";
import * as ReactEvents from "../utils/ReactEvents.mjs";
import * as Router from "next/router";
import * as ReForm__Helpers from "@rescriptbr/reform/src/ReForm__Helpers.mjs";

function response_encode(v) {
  return Js_dict.fromArray([
              [
                "data",
                Spice.boolToJson(v.data)
              ],
              [
                "message",
                Spice.stringToJson(v.message)
              ]
            ]);
}

function response_decode(v) {
  var dict = Js_json.classify(v);
  if (typeof dict === "number") {
    return Spice.error(undefined, "Not an object", v);
  }
  if (dict.TAG !== /* JSONObject */2) {
    return Spice.error(undefined, "Not an object", v);
  }
  var dict$1 = dict._0;
  var data = Spice.boolFromJson(Belt_Option.getWithDefault(Js_dict.get(dict$1, "data"), null));
  if (data.TAG === /* Ok */0) {
    var message = Spice.stringFromJson(Belt_Option.getWithDefault(Js_dict.get(dict$1, "message"), null));
    if (message.TAG === /* Ok */0) {
      return {
              TAG: /* Ok */0,
              _0: {
                data: data._0,
                message: message._0
              }
            };
    }
    var e = message._0;
    return {
            TAG: /* Error */1,
            _0: {
              path: ".message" + e.path,
              message: e.message,
              value: e.value
            }
          };
  }
  var e$1 = data._0;
  return {
          TAG: /* Error */1,
          _0: {
            path: ".data" + e$1.path,
            message: e$1.message,
            value: e$1.value
          }
        };
}

function get(values, field) {
  return values.email;
}

function set(values, field, value) {
  return {
          email: value
        };
}

var FormFields = {
  get: get,
  set: set
};

var Form = ReForm.Make({
      set: set,
      get: get
    });

var initialState = {
  email: ""
};

var btnStyle = "w-full bg-enabled-L5 rounded-xl text-text-L1 whitespace-nowrap focus:outline-none focus:ring-2 focus:ring-gray-500 focus:ring-offset-1";

var btnStyleDisabled = "w-full bg-enabled-L4 rounded-xl whitespace-nowrap focus:outline-none focus:ring-2 focus:ring-gray-300 focus:ring-offset-1";

function VerifyEmailAddress(props) {
  var onEmailChange = props.onEmailChange;
  var emailExisted = props.emailExisted;
  var router = Router.useRouter();
  var match = React.useState(function () {
        return false;
      });
  var setLoading = match[1];
  var isLoading = match[0];
  var match$1 = React.useState(function () {
        return /* Hide */1;
      });
  var setShowEmailExisted = match$1[1];
  var submit = function (param) {
    setLoading(function (param) {
          return true;
        });
    var email = param.state.values.email;
    FetchHelper.get("" + Env.restApiUrl + "/user/check-duplicate-email?email=" + email + "", (function (json) {
            var json$p = response_decode(json);
            if (json$p.TAG === /* Ok */0) {
              if (json$p._0.data) {
                setShowEmailExisted(function (param) {
                      return /* Show */0;
                    });
                Curry._2(onEmailChange, undefined, /* Existed */0);
              } else {
                Curry._2(onEmailChange, email, /* NotExisted */1);
              }
            } else {
              Curry._2(onEmailChange, email, undefined);
            }
            setLoading(function (param) {
                  return false;
                });
          }), (function (param) {
            Curry._2(onEmailChange, email, undefined);
            setLoading(function (param) {
                  return false;
                });
          }));
  };
  var form = Curry._7(Form.use, initialState, /* Schema */{
        _0: Belt_Array.concatMany([Curry._3(Form.ReSchema.Validation.email, "이메일을 확인해주세요.", undefined, /* Email */0)])
      }, submit, undefined, undefined, /* OnChange */0, undefined);
  var partial_arg = Curry._1(form.handleChange, /* Email */0);
  return React.createElement("div", {
              className: "w-full"
            }, React.createElement("span", {
                  className: "text-base font-bold"
                }, "이메일", React.createElement("span", {
                      className: "ml-0.5 text-notice"
                    }, "*")), React.createElement("div", {
                  className: "flex w-full mt-2"
                }, React.createElement("div", {
                      className: "flex flex-1 relative"
                    }, React.createElement(Input.make, {
                          type_: "email",
                          name: "email",
                          placeholder: "이메일 입력",
                          className: "pr-[68px]",
                          onChange: (function (param) {
                              return ReForm__Helpers.handleChange(partial_arg, param);
                            }),
                          size: /* Large */0,
                          error: Curry._1(form.getFieldError, /* Field */{
                                _0: /* Email */0
                              })
                        }), emailExisted !== undefined && emailExisted ? React.createElement("span", {
                            className: "absolute top-3.5 right-2 sm:right-4 text-green-gl"
                          }, "사용가능") : null), React.createElement("span", {
                      className: "flex ml-2 w-24 h-13"
                    }, React.createElement("button", {
                          className: isLoading || form.isSubmitting ? btnStyleDisabled : btnStyle,
                          disabled: isLoading || form.isSubmitting,
                          type: "submit",
                          onClick: (function (param) {
                              return ReactEvents.interceptingHandler((function (param) {
                                            Curry._1(form.submit, undefined);
                                          }), param);
                            })
                        }, "중복확인"))), React.createElement(Dialog.make, {
                  isShow: match$1[0],
                  children: React.createElement("p", {
                        className: "text-text-L1 text-center whitespace-pre-wrap"
                      }, "이미 가입한 계정입니다.\n로그인하시거나 비밀번호 찾기를 해주세요."),
                  onCancel: (function (param) {
                      Curry._4(form.setFieldValue, /* Email */0, "", true, undefined);
                      setShowEmailExisted(function (param) {
                            return /* Hide */1;
                          });
                    }),
                  onConfirm: (function (param) {
                      router.push("/buyer/signin/find-id-password?mode=reset-password&uid=" + form.values.email + "");
                    }),
                  textOnCancel: "닫기",
                  textOnConfirm: "비밀번호 찾기",
                  boxStyle: "rounded-xl"
                }));
}

var make = VerifyEmailAddress;

export {
  response_encode ,
  response_decode ,
  FormFields ,
  Form ,
  initialState ,
  btnStyle ,
  btnStyleDisabled ,
  make ,
}
/* Form Not a pure module */
