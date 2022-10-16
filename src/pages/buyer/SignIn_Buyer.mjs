// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Env from "../../constants/Env.mjs";
import * as Curry from "rescript/lib/es6/curry.js";
import * as Input from "../../components/common/Input.mjs";
import * as Spice from "@greenlabs/ppx-spice/src/rescript/Spice.mjs";
import * as React from "react";
import * as Dialog from "../../components/common/Dialog.mjs";
import * as Global from "../../components/Global.mjs";
import * as DataGtm from "../../utils/DataGtm.mjs";
import * as Js_dict from "rescript/lib/es6/js_dict.js";
import * as Js_json from "rescript/lib/es6/js_json.js";
import * as Checkbox from "../../components/common/Checkbox.mjs";
import * as Redirect from "../../components/Redirect.mjs";
import * as IconCheck from "../../components/svgs/IconCheck.mjs";
import * as IconError from "../../components/svgs/IconError.mjs";
import * as ReactUtil from "../../utils/ReactUtil.mjs";
import Head from "next/head";
import Link from "next/link";
import * as Belt_Array from "rescript/lib/es6/belt_Array.js";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as CustomHooks from "../../utils/CustomHooks.mjs";
import * as FetchHelper from "../../utils/FetchHelper.mjs";
import * as ReactEvents from "../../utils/ReactEvents.mjs";
import * as Router from "next/router";
import * as ReForm__Helpers from "@rescriptbr/reform/src/ReForm__Helpers.mjs";
import * as ChannelTalkHelper from "../../utils/ChannelTalkHelper.mjs";
import * as LocalStorageHooks from "../../utils/LocalStorageHooks.mjs";
import * as SignIn_Buyer_Form from "../../components/SignIn_Buyer_Form.mjs";
import * as ReactSeparator from "@radix-ui/react-separator";
import * as SignIn_Buyer_Set_Password from "../../components/SignIn_Buyer_Set_Password.mjs";
import * as ReactToastNotifications from "react-toast-notifications";

function info_encode(v) {
  return Js_dict.fromArray([
              [
                "message",
                Spice.optionToJson(Spice.stringToJson, v.message)
              ],
              [
                "activation-method",
                Spice.optionToJson((function (param) {
                        return Spice.arrayToJson(Spice.stringToJson, param);
                      }), v.activationMethod)
              ],
              [
                "email",
                Spice.optionToJson(Spice.stringToJson, v.email)
              ]
            ]);
}

function info_decode(v) {
  var dict = Js_json.classify(v);
  if (typeof dict === "number") {
    return Spice.error(undefined, "Not an object", v);
  }
  if (dict.TAG !== /* JSONObject */2) {
    return Spice.error(undefined, "Not an object", v);
  }
  var dict$1 = dict._0;
  var message = Spice.optionFromJson(Spice.stringFromJson, Belt_Option.getWithDefault(Js_dict.get(dict$1, "message"), null));
  if (message.TAG === /* Ok */0) {
    var activationMethod = Spice.optionFromJson((function (param) {
            return Spice.arrayFromJson(Spice.stringFromJson, param);
          }), Belt_Option.getWithDefault(Js_dict.get(dict$1, "activation-method"), null));
    if (activationMethod.TAG === /* Ok */0) {
      var email = Spice.optionFromJson(Spice.stringFromJson, Belt_Option.getWithDefault(Js_dict.get(dict$1, "email"), null));
      if (email.TAG === /* Ok */0) {
        return {
                TAG: /* Ok */0,
                _0: {
                  message: message._0,
                  activationMethod: activationMethod._0,
                  email: email._0
                }
              };
      }
      var e = email._0;
      return {
              TAG: /* Error */1,
              _0: {
                path: ".email" + e.path,
                message: e.message,
                value: e.value
              }
            };
    }
    var e$1 = activationMethod._0;
    return {
            TAG: /* Error */1,
            _0: {
              path: "." + ("activation-method" + e$1.path),
              message: e$1.message,
              value: e$1.value
            }
          };
  }
  var e$2 = message._0;
  return {
          TAG: /* Error */1,
          _0: {
            path: ".message" + e$2.path,
            message: e$2.message,
            value: e$2.value
          }
        };
}

function $$default(props) {
  var match = ReactToastNotifications.useToasts();
  var addToast = match.addToast;
  var uid = Js_dict.get(props.query, "uid");
  var router = Router.useRouter();
  var match$1 = CustomHooks.useSetPassword(Js_dict.get(router.query, "token"));
  var match$2 = React.useState(function () {
        return /* Hide */1;
      });
  var setShowErrorSetPassword = match$2[1];
  var match$3 = React.useState(function () {
        return true;
      });
  var setCheckedSaveEmail = match$3[1];
  var isCheckedSaveEmail = match$3[0];
  var match$4 = React.useState(function () {
        return /* Hide */1;
      });
  var setShowForError = match$4[1];
  var match$5 = React.useState(function () {
        return /* Hide */1;
      });
  var setShowForExisted = match$5[1];
  var inputPasswordRef = React.useRef(null);
  var onSubmit = function (param) {
    var state = param.state;
    var email = SignIn_Buyer_Form.FormFields.get(state.values, /* Email */0);
    var password = SignIn_Buyer_Form.FormFields.get(state.values, /* Password */1);
    var prim0 = new URLSearchParams(router.query);
    var redirectUrl = Belt_Option.getWithDefault(Caml_option.nullable_to_opt(prim0.get("redirect")), "/");
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
              return setShowForError(function (param) {
                          return /* Show */0;
                        });
            }
            var res$1 = result._0;
            Curry._1(LocalStorageHooks.AccessToken.set, res$1.token);
            Curry._1(LocalStorageHooks.RefreshToken.set, res$1.refreshToken);
            ChannelTalkHelper.bootWithProfile(undefined);
            var user = CustomHooks.Auth.user_decode(CustomHooks.Auth.decodeJwt(res$1.token));
            if (user.TAG === /* Ok */0) {
              var user$1 = user._0;
              Curry._1(Global.$$Window.ReactNativeWebView.PostMessage.signIn, String(user$1.id));
              DataGtm.push({
                    event: "login",
                    user_id: user$1.id,
                    method: "normal"
                  });
            }
            setTimeout((function (param) {
                    Redirect.setHref(redirectUrl);
                  }), 1000);
          }), (function (err) {
            if (err.status !== 401) {
              if (err.status === 409) {
                setShowForExisted(function (param) {
                      return /* Show */0;
                    });
                ReactUtil.setValueElementByRef(inputPasswordRef, "");
                SignIn_Buyer_Form.FormFields.set(state.values, /* Password */1, "");
                return ;
              } else {
                return setShowForError(function (param) {
                            return /* Show */0;
                          });
              }
            }
            var info = info_decode(err.info);
            var tmp;
            tmp = info.TAG === /* Ok */0 ? Belt_Option.map(info._0.activationMethod, (function (method) {
                      return method.join(",");
                    })) : undefined;
            var mode = Belt_Option.map(tmp, (function (methods) {
                    return "mode=" + methods;
                  }));
            var info$1 = info_decode(err.info);
            var activationEmail;
            activationEmail = info$1.TAG === /* Ok */0 ? info$1._0.email : undefined;
            if (mode !== undefined) {
              if (activationEmail !== undefined) {
                router.push("/buyer/activate-user?" + mode + "&uid=" + email + "&email=" + activationEmail + "&role=buyer");
              } else {
                router.push("/buyer/activate-user?" + mode + "&uid=" + email + "&role=buyer");
              }
            } else {
              router.push("/buyer/activate-user?uid=" + email + "&role=buyer");
            }
          }));
  };
  var form = Curry._7(SignIn_Buyer_Form.Form.use, SignIn_Buyer_Form.initialState, /* Schema */{
        _0: Belt_Array.concatMany([
              Curry._3(SignIn_Buyer_Form.Form.ReSchema.Validation.email, "이메일을 입력해주세요.", undefined, /* Email */0),
              Curry._3(SignIn_Buyer_Form.Form.ReSchema.Validation.nonEmpty, "비밀번호를 입력해주세요.", undefined, /* Password */1)
            ])
      }, onSubmit, undefined, undefined, /* OnChange */0, undefined);
  var handleOnSubmit = function (param) {
    return ReactEvents.interceptingHandler((function (param) {
                  var email = SignIn_Buyer_Form.FormFields.get(form.values, /* Email */0);
                  if (isCheckedSaveEmail) {
                    Curry._1(LocalStorageHooks.BuyerEmail.set, email);
                  } else {
                    Curry._1(LocalStorageHooks.BuyerEmail.remove, undefined);
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
          var email = uid !== undefined ? uid : Curry._1(LocalStorageHooks.BuyerEmail.get, undefined);
          if (email !== "") {
            setCheckedSaveEmail(function (param) {
                  return true;
                });
            Curry._4(form.setFieldValue, /* Email */0, email, true, undefined);
            ReactUtil.focusElementByRef(inputPasswordRef);
          }
          
        }), [uid]);
  var isFormFilled = function (param) {
    var email = SignIn_Buyer_Form.FormFields.get(form.values, /* Email */0);
    var password = SignIn_Buyer_Form.FormFields.get(form.values, /* Password */1);
    if (email !== "") {
      return password !== "";
    } else {
      return false;
    }
  };
  var user = CustomHooks.Auth.use(undefined);
  React.useEffect((function () {
          if (typeof user !== "number") {
            var match = user._0.role;
            if (match !== 1) {
              if (match !== 0) {
                router.push("/admin");
              } else {
                router.push("/seller");
              }
            } else {
              router.push("/");
            }
          }
          
        }), [user]);
  React.useEffect((function () {
          var activationToken = Js_dict.get(router.query, "dormant_reset_token");
          var activate = function (token) {
            Belt_Option.map(JSON.stringify({
                      "dormant-reset-token": token
                    }), (function (body) {
                    return FetchHelper.post("" + Env.restApiUrl + "/user/dormant/reset-email", body, (function (param) {
                                  addToast(React.createElement("div", {
                                            className: "flex items-center"
                                          }, React.createElement(IconCheck.make, {
                                                height: "24",
                                                width: "24",
                                                fill: "#12B564",
                                                className: "mr-2"
                                              }), "휴면 계정이 해제되었어요!"), {
                                        appearance: "success"
                                      });
                                }), (function (err) {
                                  addToast(React.createElement("div", {
                                            className: "flex items-center"
                                          }, React.createElement(IconError.make, {
                                                width: "24",
                                                height: "24",
                                                className: "mr-2"
                                              }), "휴면 계정 해제에 실패했어요"), {
                                        appearance: "error"
                                      });
                                }));
                  }));
          };
          if (activationToken !== undefined) {
            activate(activationToken);
          }
          
        }), [router.query]);
  ChannelTalkHelper.Hook.use(undefined, undefined, undefined);
  var partial_arg = Curry._1(form.handleChange, /* Email */0);
  var partial_arg$1 = Curry._1(form.handleChange, /* Password */1);
  return React.createElement(React.Fragment, undefined, React.createElement(Head, {
                  children: React.createElement("title", undefined, "바이어 로그인 - 신선하이")
                }), React.createElement("div", {
                  className: "container mx-auto max-w-lg min-h-buyer relative flex flex-col justify-center pb-20"
                }, React.createElement("div", {
                      className: "flex-auto flex flex-col xl:justify-center items-center"
                    }, React.createElement("div", {
                          className: "w-full px-5 xl:py-12 sm:px-20"
                        }, React.createElement("h2", {
                              className: "hidden text-[26px] font-bold text-center xl:block"
                            }, "신선하이 로그인"), React.createElement("form", {
                              onSubmit: handleOnSubmit
                            }, React.createElement(Input.make, {
                                  type_: "email",
                                  name: "email",
                                  placeholder: "이메일",
                                  className: "block mt-[60px]",
                                  value: SignIn_Buyer_Form.FormFields.get(form.values, /* Email */0),
                                  onChange: (function (param) {
                                      return ReForm__Helpers.handleChange(partial_arg, param);
                                    }),
                                  size: /* Large */0,
                                  error: Curry._1(form.getFieldError, /* Field */{
                                        _0: /* Email */0
                                      })
                                }), React.createElement(Input.make, {
                                  id: "input-password",
                                  type_: "password",
                                  name: "password",
                                  placeholder: "비밀번호",
                                  className: "block mt-3",
                                  onChange: (function (param) {
                                      return ReForm__Helpers.handleChange(partial_arg$1, param);
                                    }),
                                  size: /* Large */0,
                                  error: Curry._1(form.getFieldError, /* Field */{
                                        _0: /* Password */1
                                      }),
                                  inputRef: inputPasswordRef
                                }), React.createElement("div", {
                                  className: "flex justify-between items-center mt-4"
                                }, React.createElement("span", {
                                      className: "flex flex-1"
                                    }, React.createElement(Checkbox.make, {
                                          id: "auto-login",
                                          checked: isCheckedSaveEmail,
                                          onChange: handleOnCheckSaveEmail
                                        }), React.createElement("span", {
                                          className: "text-sm text-gray-700 ml-1"
                                        }, "아이디 저장")), React.createElement("span", {
                                      className: "divide-x"
                                    }, React.createElement(Link, {
                                          href: "/buyer/signin/find-id-password?mode=find-id",
                                          children: React.createElement("span", {
                                                className: "text-sm text-gray-700 p-1 m-1 cursor-pointer"
                                              }, "아이디 찾기")
                                        }), React.createElement(Link, {
                                          href: "/buyer/signin/find-id-password?mode=reset-password",
                                          children: React.createElement("span", {
                                                className: "text-sm text-gray-700 pl-2 mr-1 mt-1 mb-1 cursor-pointer"
                                              }, "비밀번호 재설정")
                                        }))), React.createElement("div", undefined, React.createElement("button", {
                                      className: form.isSubmitting || !isFormFilled(undefined) ? "w-full mt-12 h-14 flex justify-center items-center bg-gray-300 rounded-xl text-white font-bold" : "w-full mt-12 h-14 flex justify-center items-center bg-black-gl rounded-xl text-white font-bold focus:outline-none focus:ring-2 focus:ring-offset-1 focus:ring-black",
                                      disabled: form.isSubmitting || !isFormFilled(undefined),
                                      type: "submit"
                                    }, "로그인"))), React.createElement(ReactSeparator.Root, {
                              className: "h-px bg-div-border-L2 my-7"
                            }), React.createElement("div", undefined, React.createElement("button", {
                                  className: "w-full h-14 flex justify-center items-center rounded-xl border-[1px] border-green-500",
                                  onClick: (function (param) {
                                      router.push("/buyer/signup");
                                    })
                                }, React.createElement("span", {
                                      className: "text-green-500 font-bold"
                                    }, "바이어 회원가입")))))), React.createElement(Dialog.make, {
                  isShow: match$1[0],
                  children: React.createElement(SignIn_Buyer_Set_Password.make, {
                        onSuccess: match$1[1],
                        onError: setShowErrorSetPassword
                      }),
                  boxStyle: "overflow-auto"
                }), React.createElement(Dialog.make, {
                  isShow: match$4[0],
                  children: React.createElement("p", {
                        className: "text-gray-500 text-center whitespace-pre-wrap"
                      }, "로그인 정보가 일치하지 않거나 없는 계정입니다. 다시 한번 입력해주세요."),
                  onConfirm: (function (param) {
                      setShowForError(function (param) {
                            return /* Hide */1;
                          });
                    }),
                  confirmBg: "#ECECEC",
                  confirmTextColor: "#262626"
                }), React.createElement(Dialog.make, {
                  isShow: match$2[0],
                  children: React.createElement("p", {
                        className: "text-gray-500 text-center whitespace-pre-wrap"
                      }, "비밀번호 재설정에 실패하였습니다.\n다시 시도해주세요."),
                  onConfirm: (function (param) {
                      setShowErrorSetPassword(function (param) {
                            return /* Hide */1;
                          });
                    })
                }), React.createElement(Dialog.make, {
                  isShow: match$5[0],
                  children: React.createElement("p", {
                        className: "text-gray-500 text-center whitespace-pre-wrap"
                      }, "신선하이를 이용하시려면 비밀번호 재설정이 필요합니다. 이메일로 재설정 메일을 보내드렸습니다. 메일함을 확인해주세요."),
                  onConfirm: (function (param) {
                      setShowForExisted(function (param) {
                            return /* Hide */1;
                          });
                    })
                }));
}

function getServerSideProps(param) {
  return Promise.resolve({
              props: {
                query: param.query
              }
            });
}

var FormFields;

var Form;

var SetPassword;

var useSetPassword = CustomHooks.useSetPassword;

export {
  FormFields ,
  Form ,
  SetPassword ,
  useSetPassword ,
  info_encode ,
  info_decode ,
  $$default ,
  $$default as default,
  getServerSideProps ,
}
/* Env Not a pure module */
