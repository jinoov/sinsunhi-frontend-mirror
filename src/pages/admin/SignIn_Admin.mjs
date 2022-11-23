// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Env from "../../constants/Env.mjs";
import * as Curry from "rescript/lib/es6/curry.js";
import * as Input from "../../components/common/Input.mjs";
import * as React from "react";
import * as Dialog from "../../components/common/Dialog.mjs";
import * as Checkbox from "../../components/common/Checkbox.mjs";
import Head from "next/head";
import * as Belt_Array from "rescript/lib/es6/belt_Array.js";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as FetchHelper from "../../utils/FetchHelper.mjs";
import * as ReactEvents from "../../utils/ReactEvents.mjs";
import * as Router from "next/router";
import * as ReForm__Helpers from "@rescriptbr/reform/src/ReForm__Helpers.mjs";
import * as LocalStorageHooks from "../../utils/LocalStorageHooks.mjs";
import * as SignIn_Admin_Form from "../../components/SignIn_Admin_Form.mjs";

function SignIn_Admin(Props) {
  var router = Router.useRouter();
  var match = React.useState(function () {
        return true;
      });
  var setCheckedSaveEmail = match[1];
  var isCheckedSaveEmail = match[0];
  var match$1 = React.useState(function () {
        return /* Hide */1;
      });
  var setShowLoginError = match$1[1];
  var onSubmit = function (param) {
    var state = param.state;
    var email = SignIn_Admin_Form.FormFields.get(state.values, /* Email */0);
    var password = SignIn_Admin_Form.FormFields.get(state.values, /* Password */1);
    var prim0 = new URLSearchParams(router.query);
    var redirectUrl = Belt_Option.getWithDefault(Caml_option.nullable_to_opt(prim0.get("redirect")), "/admin");
    var urlSearchParams = new URLSearchParams([
            [
              "grant-type",
              "password"
            ],
            [
              "username",
              email
            ],
            [
              "password",
              password
            ]
          ]).toString();
    FetchHelper.postWithURLSearchParams("" + Env.restApiUrl + "/user/token", urlSearchParams, (function (res) {
            var result = FetchHelper.responseToken_decode(res);
            if (result.TAG !== /* Ok */0) {
              return setShowLoginError(function (param) {
                          return /* Show */0;
                        });
            }
            var res$1 = result._0;
            Curry._1(LocalStorageHooks.AccessToken.set, res$1.token);
            Curry._1(LocalStorageHooks.RefreshToken.set, res$1.refreshToken);
            router.push(redirectUrl);
          }), (function (param) {
            setShowLoginError(function (param) {
                  return /* Show */0;
                });
          }));
  };
  var form = Curry._7(SignIn_Admin_Form.Form.use, SignIn_Admin_Form.initialState, /* Schema */{
        _0: Belt_Array.concatMany([
              Curry._3(SignIn_Admin_Form.Form.ReSchema.Validation.email, "이메일을 입력해주세요.", undefined, /* Email */0),
              Curry._3(SignIn_Admin_Form.Form.ReSchema.Validation.nonEmpty, "비밀번호를 입력해주세요.", undefined, /* Password */1)
            ])
      }, onSubmit, undefined, undefined, /* OnChange */0, undefined);
  var handleOnSubmit = function (param) {
    return ReactEvents.interceptingHandler((function (param) {
                  var email = SignIn_Admin_Form.FormFields.get(form.values, /* Email */0);
                  if (isCheckedSaveEmail) {
                    Curry._1(LocalStorageHooks.EmailAdmin.set, email);
                  } else {
                    Curry._1(LocalStorageHooks.EmailAdmin.remove, undefined);
                  }
                  Curry._1(form.submit, undefined);
                }), param);
  };
  var handleOnCheckSaveEmail = function (e) {
    var checked = e.target.checked;
    setCheckedSaveEmail(function (param) {
          return checked;
        });
  };
  React.useEffect((function () {
          var email = Curry._1(LocalStorageHooks.EmailAdmin.get, undefined);
          setCheckedSaveEmail(function (param) {
                return true;
              });
          Curry._4(form.setFieldValue, /* Email */0, Belt_Option.getWithDefault(email, ""), true, undefined);
        }), []);
  var partial_arg = Curry._1(form.handleChange, /* Email */0);
  var partial_arg$1 = Curry._1(form.handleChange, /* Password */1);
  return React.createElement(React.Fragment, undefined, React.createElement(Head, {
                  children: React.createElement("title", undefined, "관리자 로그인 - 신선하이")
                }), React.createElement("div", {
                  className: "container mx-auto max-w-lg min-h-screen flex flex-col justify-center items-center relative"
                }, React.createElement("img", {
                      alt: "신선하이 로고",
                      height: "42",
                      src: "/assets/sinsunhi-logo.svg",
                      width: "164"
                    }), React.createElement("div", {
                      className: "text-gray-500 mt-2"
                    }, React.createElement("span", undefined, "농산물 바이어 전용"), React.createElement("span", {
                          className: "ml-1 font-semibold"
                        }, "소싱플랫폼")), React.createElement("div", {
                      className: "w-full px-5 sm:shadow-xl sm:rounded sm:border sm:border-gray-100 sm:py-12 sm:px-20 mt-6"
                    }, React.createElement("h2", {
                          className: "text-2xl font-bold text-center"
                        }, "관리자 로그인"), React.createElement("form", {
                          onSubmit: handleOnSubmit
                        }, React.createElement("label", {
                              className: "block mt-3",
                              htmlFor: "email"
                            }), React.createElement(Input.make, {
                              type_: "email",
                              name: "email",
                              placeholder: "이메일",
                              value: SignIn_Admin_Form.FormFields.get(form.values, /* Email */0),
                              onChange: (function (param) {
                                  return ReForm__Helpers.handleChange(partial_arg, param);
                                }),
                              size: /* Large */0,
                              error: Curry._1(form.getFieldError, /* Field */{
                                    _0: /* Email */0
                                  })
                            }), React.createElement("label", {
                              className: "block mt-3",
                              htmlFor: "password"
                            }), React.createElement(Input.make, {
                              type_: "password",
                              name: "password",
                              placeholder: "비밀번호",
                              onChange: (function (param) {
                                  return ReForm__Helpers.handleChange(partial_arg$1, param);
                                }),
                              size: /* Large */0,
                              error: Curry._1(form.getFieldError, /* Field */{
                                    _0: /* Password */1
                                  })
                            }), React.createElement("div", {
                              className: "flex items-center mt-4"
                            }, React.createElement(Checkbox.make, {
                                  id: "auto-login",
                                  checked: isCheckedSaveEmail,
                                  onChange: handleOnCheckSaveEmail
                                }), React.createElement("span", {
                                  className: "text-sm text-gray-700 ml-1"
                                }, "아이디 저장")), React.createElement("button", {
                              className: form.isSubmitting ? "w-full mt-12 py-3 bg-gray-300 rounded-xl text-white font-bold" : "w-full mt-12 py-3 bg-green-gl rounded-xl text-white font-bold focus:outline-none focus:ring-2 focus:ring-offset-1 focus:ring-green-gl focus:ring-opacity-100",
                              disabled: form.isSubmitting,
                              type: "submit"
                            }, "로그인"))), React.createElement("div", {
                      className: "absolute bottom-4 text-sm text-gray-400"
                    }, "ⓒ Copyright Greenlabs All Reserved. (주)그린랩스")), React.createElement(Dialog.make, {
                  isShow: match$1[0],
                  children: React.createElement("p", {
                        className: "text-gray-500 text-center whitespace-pre-wrap"
                      }, "로그인 정보가 일치하지 않거나 없는 계정입니다.\n다시  한번 입력해주세요."),
                  onConfirm: (function (param) {
                      setShowLoginError(function (param) {
                            return /* Hide */1;
                          });
                    })
                }));
}

var FormFields;

var Form;

var make = SignIn_Admin;

export {
  FormFields ,
  Form ,
  make ,
}
/* Env Not a pure module */
