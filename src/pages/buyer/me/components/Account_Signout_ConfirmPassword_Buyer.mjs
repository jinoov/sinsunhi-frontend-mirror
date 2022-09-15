// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Cx from "rescript-classnames/src/Cx.mjs";
import * as Env from "../../../../constants/Env.mjs";
import * as Curry from "rescript/lib/es6/curry.js";
import * as Input from "../../../../components/common/Input.mjs";
import * as React from "react";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as FetchHelper from "../../../../utils/FetchHelper.mjs";
import * as ReactEvents from "../../../../utils/ReactEvents.mjs";

function checkPasswordRequest(successFn, failedFn, password) {
  Belt_Option.map(JSON.stringify({
            password: password
          }), (function (body) {
          return FetchHelper.requestWithRetry(FetchHelper.postWithToken, "" + Env.restApiUrl + "/user/password/check", body, 2, (function (param) {
                        return Curry._1(successFn, undefined);
                      }), (function (param) {
                        return Curry._1(failedFn, undefined);
                      }));
        }));
}

function Account_Signout_ConfirmPassword_Buyer$PC(Props) {
  var email = Props.email;
  var nextStep = Props.nextStep;
  var password = Props.password;
  var setPassword = Props.setPassword;
  var match = React.useState(function () {
        return false;
      });
  var setLoading = match[1];
  var loading = match[0];
  var match$1 = React.useState(function () {
        
      });
  var setErrorMessage = match$1[1];
  var successFn = function (param) {
    Curry._1(nextStep, undefined);
    setLoading(function (param) {
          return false;
        });
    setErrorMessage(function (param) {
          
        });
  };
  var failedFn = function (param) {
    setErrorMessage(function (param) {
          return "비밀번호가 유효하지 않습니다.";
        });
    setLoading(function (param) {
          return false;
        });
  };
  var handleNext = function (param) {
    return ReactEvents.interceptingHandler((function (param) {
                  setLoading(function (param) {
                        return true;
                      });
                  checkPasswordRequest(successFn, failedFn, password);
                }), param);
  };
  var disabled = loading || password === "";
  return React.createElement("div", {
              className: "pt-10 pb-[110px]"
            }, React.createElement("p", {
                  className: "text-center text-text-L1"
                }, "소중한 정보 보호를 위해,", React.createElement("br", undefined), "사용중인 계정의 비밀번호를 확인해주세요."), React.createElement("div", {
                  className: "mt-7"
                }, React.createElement("div", {
                      className: "flex flex-col mb-5"
                    }, React.createElement("div", {
                          className: "mb-2"
                        }, React.createElement("span", {
                              className: "font-bold"
                            }, "이메일")), React.createElement("div", {
                          className: "border border-border-default-L1 bg-disabled-L3 rounded-xl p-3"
                        }, email)), React.createElement("form", {
                      onSubmit: handleNext
                    }, React.createElement("div", {
                          className: "flex flex-col mb-10"
                        }, React.createElement("div", {
                              className: "mb-2"
                            }, React.createElement("span", {
                                  className: "font-bold"
                                }, "비밀번호")), React.createElement(Input.make, {
                              type_: "password",
                              name: "validate-password",
                              placeholder: "비밀번호를 입력해주세요",
                              className: "w-full border border-border-default-L1 p-3 rounded-xl",
                              value: password,
                              onChange: (function (e) {
                                  var value = e.target.value;
                                  setPassword(function (param) {
                                        return value;
                                      });
                                  setErrorMessage(function (param) {
                                        
                                      });
                                }),
                              size: /* Large */0,
                              error: match$1[0],
                              disabled: loading
                            })), React.createElement("button", {
                          className: Cx.cx([
                                "rounded-xl w-full py-4",
                                disabled ? "bg-disabled-L2" : "bg-green-500"
                              ]),
                          disabled: disabled,
                          type: "submit"
                        }, React.createElement("span", {
                              className: "text-white"
                            }, "다음")))));
}

var PC = {
  make: Account_Signout_ConfirmPassword_Buyer$PC
};

function Account_Signout_ConfirmPassword_Buyer$Mobile(Props) {
  var email = Props.email;
  var nextStep = Props.nextStep;
  var password = Props.password;
  var setPassword = Props.setPassword;
  var match = React.useState(function () {
        return false;
      });
  var setLoading = match[1];
  var loading = match[0];
  var match$1 = React.useState(function () {
        
      });
  var setErrorMessage = match$1[1];
  var successFn = function (param) {
    Curry._1(nextStep, undefined);
    setLoading(function (param) {
          return false;
        });
    setErrorMessage(function (param) {
          
        });
  };
  var failedFn = function (param) {
    setErrorMessage(function (param) {
          return "비밀번호가 유효하지 않습니다.";
        });
    setLoading(function (param) {
          return false;
        });
  };
  var handleNext = function (param) {
    return ReactEvents.interceptingHandler((function (param) {
                  setLoading(function (param) {
                        return true;
                      });
                  checkPasswordRequest(successFn, failedFn, password);
                }), param);
  };
  var disabled = loading || password === "";
  return React.createElement("section", {
              className: "my-6 px-4 xl:mt-0 xl:mb-6 max-h-[calc(100vh-70px)] overflow-y-auto"
            }, React.createElement("form", {
                  onSubmit: handleNext
                }, React.createElement("div", {
                      className: "flex flex-col"
                    }, React.createElement("div", {
                          className: "mb-5"
                        }, React.createElement("p", {
                              className: "text-text-L1 xl:font-bold xl:text-2xl"
                            }, "소중한 정보 보호를 위해,", React.createElement("br", undefined), "사용중인 계정의 비밀번호를 확인해주세요.")), React.createElement("div", {
                          className: "flex flex-col mb-5"
                        }, React.createElement("div", {
                              className: "mb-2"
                            }, React.createElement("span", {
                                  className: "font-bold"
                                }, "이메일")), React.createElement("div", {
                              className: "border border-border-default-L1 bg-disabled-L3 rounded-xl p-3"
                            }, email)), React.createElement("div", {
                          className: "flex flex-col mb-10"
                        }, React.createElement("div", {
                              className: "mb-2"
                            }, React.createElement("span", {
                                  className: "font-bold"
                                }, "비밀번호")), React.createElement(Input.make, {
                              type_: "password",
                              name: "validate-password",
                              placeholder: "비밀번호를 입력해주세요",
                              className: "w-full border border-border-default-L1 p-3 rounded-xl",
                              value: password,
                              onChange: (function (e) {
                                  var value = e.target.value;
                                  setPassword(function (param) {
                                        return value;
                                      });
                                  setErrorMessage(function (param) {
                                        
                                      });
                                }),
                              size: /* Large */0,
                              error: match$1[0],
                              disabled: loading
                            })), React.createElement("button", {
                          className: Cx.cx([
                                "rounded-xl w-full py-4",
                                disabled ? "bg-disabled-L2" : "bg-green-500"
                              ]),
                          disabled: disabled,
                          type: "submit"
                        }, React.createElement("span", {
                              className: "text-white"
                            }, "다음")))));
}

var Mobile = {
  make: Account_Signout_ConfirmPassword_Buyer$Mobile
};

export {
  checkPasswordRequest ,
  PC ,
  Mobile ,
}
/* Env Not a pure module */