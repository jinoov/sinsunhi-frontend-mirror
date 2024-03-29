// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Env from "../constants/Env.mjs";
import * as Curry from "rescript/lib/es6/curry.js";
import * as Input from "./common/Input.mjs";
import * as Timer from "./common/Timer.mjs";
import * as React from "react";
import * as Dialog from "./common/Dialog.mjs";
import * as ReForm from "@rescriptbr/reform/src/ReForm.mjs";
import * as ReactUtil from "../utils/ReactUtil.mjs";
import * as Belt_Array from "rescript/lib/es6/belt_Array.js";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as FetchHelper from "../utils/FetchHelper.mjs";
import * as ReactEvents from "../utils/ReactEvents.mjs";
import * as Router from "next/router";
import * as ReForm__Helpers from "@rescriptbr/reform/src/ReForm__Helpers.mjs";

function get(values, field) {
  return values.phoneNumber;
}

function set(values, field, value) {
  return {
          phoneNumber: value
        };
}

var VerifyPhoneNumberFormFields = {
  get: get,
  set: set
};

function get$1(values, field) {
  return values.verificationCode;
}

function set$1(values, field, value) {
  return {
          verificationCode: value
        };
}

var VerificationCodeFormFields = {
  get: get$1,
  set: set$1
};

var VerifyPhoneNumberForm = ReForm.Make({
      set: set,
      get: get
    });

var VerificationCodeForm = ReForm.Make({
      set: set$1,
      get: get$1
    });

var initialStateVerifyPhoneNumber = {
  phoneNumber: ""
};

var initialStateVerificationCode = {
  verificationCode: ""
};

var sendBtnStyle = "w-full bg-blue-gray-700 rounded-xl text-white font-bold whitespace-nowrap focus:outline-none focus:ring-2 focus:ring-gray-700 focus:ring-offset-1";

var resendBtnStyle = "w-full bg-gray-50 rounded-xl whitespace-nowrap focus:outline-none focus:ring-2 focus:ring-gray-300 focus:ring-offset-1";

function VerifyBuyerPhoneNumber(Props) {
  var onVerified = Props.onVerified;
  var router = Router.useRouter();
  var match = React.useState(function () {
        return /* BeforeSendSMS */0;
      });
  var setSMS = match[1];
  var sms = match[0];
  var match$1 = React.useState(function () {
        return /* BeforeSendVerificationCode */0;
      });
  var setVerificationCode = match$1[1];
  var verificationCode = match$1[0];
  var match$2 = React.useState(function () {
        return /* Hide */1;
      });
  var setShowDuplicated = match$2[1];
  var match$3 = React.useState(function () {
        return /* Hide */1;
      });
  var setShowVerifyError = match$3[1];
  var inputVerificationCodeRef = React.useRef(null);
  var onSubmitVerifyPhoneNumber = function (param) {
    setSMS(function (param) {
          return /* SendingSMS */1;
        });
    var phoneNumber = param.state.values.phoneNumber.replace(new RegExp("\\-", "g"), "");
    Belt_Option.map(JSON.stringify({
              "recipient-no": phoneNumber
            }), (function (body) {
            return FetchHelper.post("" + Env.restApiUrl + "/user/sms", body, (function (param) {
                          setSMS(function (param) {
                                return /* SuccessToSendSMS */2;
                              });
                          ReactUtil.focusElementByRef(inputVerificationCodeRef);
                        }), (function (err) {
                          setSMS(function (param) {
                                return /* FailureToSendSMS */3;
                              });
                        }));
          }));
  };
  var verifyPhoneNumberForm = Curry._7(VerifyPhoneNumberForm.use, initialStateVerifyPhoneNumber, /* Schema */{
        _0: Belt_Array.concatMany([Curry._4(VerifyPhoneNumberForm.ReSchema.Validation.regExp, "휴대전화 번호를 다시 확인해주세요.", "^\\d{3}-\\d{3,4}-\\d{4}$", undefined, /* PhoneNumber */0)])
      }, onSubmitVerifyPhoneNumber, undefined, undefined, /* OnChange */0, undefined);
  var onSubmitVerificationCode = function (param) {
    setVerificationCode(function (param) {
          return /* SendingVerificationCode */1;
        });
    var phoneNumber = verifyPhoneNumberForm.values.phoneNumber.replace(new RegExp("\\-", "g"), "");
    var code = param.state.values.verificationCode;
    Belt_Option.map(JSON.stringify({
              "recipient-no": phoneNumber,
              "confirmed-no": code,
              role: "buyer"
            }), (function (body) {
            return FetchHelper.post("" + Env.restApiUrl + "/user/sms/check-duplicated-member", body, (function (param) {
                          setVerificationCode(function (param) {
                                return /* SuccessToVerifyCode */2;
                              });
                          Curry._3(onVerified, phoneNumber, /* SuccessToVerifyCode */2, /* NotExisted */1);
                        }), (function (err) {
                          if (err.status === 409) {
                            setVerificationCode(function (param) {
                                  return /* SuccessToVerifyCode */2;
                                });
                            setShowDuplicated(function (param) {
                                  return /* Show */0;
                                });
                            return Curry._3(onVerified, phoneNumber, /* SuccessToVerifyCode */2, /* Existed */0);
                          } else {
                            setVerificationCode(function (param) {
                                  return /* FailureToVerifyCode */3;
                                });
                            setShowVerifyError(function (param) {
                                  return /* Show */0;
                                });
                            return Curry._3(onVerified, phoneNumber, /* FailureToVerifyCode */3, undefined);
                          }
                        }));
          }));
  };
  var verificationCodeForm = Curry._7(VerificationCodeForm.use, initialStateVerificationCode, /* Schema */{
        _0: Belt_Array.concatMany([Curry._3(VerificationCodeForm.ReSchema.Validation.nonEmpty, "인증번호를 입력해주세요.", undefined, /* VerificationCode */0)])
      }, onSubmitVerificationCode, undefined, undefined, /* OnChange */0, undefined);
  var handleOnSubmitPhoneNumber = function (param) {
    return ReactEvents.interceptingHandler((function (param) {
                  if (sms === 0) {
                    return Curry._1(verifyPhoneNumberForm.submit, undefined);
                  }
                  switch (sms) {
                    case /* SendingSMS */1 :
                        return ;
                    case /* SuccessToSendSMS */2 :
                        setSMS(function (param) {
                              return /* BeforeSendSMS */0;
                            });
                        setVerificationCode(function (param) {
                              return /* BeforeSendVerificationCode */0;
                            });
                        Curry._4(verifyPhoneNumberForm.setFieldValue, /* PhoneNumber */0, "", false, undefined);
                        Curry._4(verificationCodeForm.setFieldValue, /* VerificationCode */0, "", false, undefined);
                        return Curry._3(onVerified, "", /* BeforeSendVerificationCode */0, undefined);
                    case /* FailureToSendSMS */3 :
                        return Curry._1(verifyPhoneNumberForm.submit, undefined);
                    
                  }
                }), param);
  };
  var handleOnChangePhoneNumber = function (e) {
    var newValue = e.currentTarget.value.replace(/[^0-9]/g, "").replace(/(^1[0-9]{3}|^0[0-9]{2})([0-9]+)?([0-9]{4})$/, "$1-$2-$3").replace("--", "-");
    Curry._4(verifyPhoneNumberForm.setFieldValue, /* PhoneNumber */0, newValue, true, undefined);
  };
  var handleOnSubmitVerificationCode = function (param) {
    return ReactEvents.interceptingHandler((function (param) {
                  Curry._1(verificationCodeForm.submit, undefined);
                }), param);
  };
  var isDisabledVerifyPhoneNumberForm = sms === 2 || sms === 1;
  var isDisabledVerifyPhoneNumberButton = sms === 1;
  var isDisabledVerifyCodeForm;
  if (sms !== 0) {
    switch (sms) {
      case /* SendingSMS */1 :
          isDisabledVerifyCodeForm = false;
          break;
      case /* SuccessToSendSMS */2 :
          isDisabledVerifyCodeForm = verificationCode === 2 || verificationCode === 1;
          break;
      case /* FailureToSendSMS */3 :
          isDisabledVerifyCodeForm = true;
          break;
      
    }
  } else {
    isDisabledVerifyCodeForm = true;
  }
  var timerStatus;
  if (sms !== 2) {
    timerStatus = /* Stop */3;
  } else {
    switch (verificationCode) {
      case /* BeforeSendVerificationCode */0 :
          timerStatus = /* Start */0;
          break;
      case /* SendingVerificationCode */1 :
          timerStatus = /* Pause */1;
          break;
      case /* SuccessToVerifyCode */2 :
          timerStatus = /* Stop */3;
          break;
      case /* FailureToVerifyCode */3 :
          timerStatus = /* Resume */2;
          break;
      
    }
  }
  var onChangeStatus = function (status) {
    if (status >= 3 && sms === 2) {
      setSMS(function (param) {
            return /* BeforeSendSMS */0;
          });
      return setVerificationCode(function (param) {
                  return /* BeforeSendVerificationCode */0;
                });
    }
    
  };
  var partial_arg = Curry._1(verificationCodeForm.handleChange, /* VerificationCode */0);
  var tmp;
  switch (sms) {
    case /* SuccessToSendSMS */2 :
        switch (verificationCode) {
          case /* SendingVerificationCode */1 :
          case /* SuccessToVerifyCode */2 :
              tmp = "btn-level1-disabled";
              break;
          case /* BeforeSendVerificationCode */0 :
          case /* FailureToVerifyCode */3 :
              tmp = "btn-level1";
              break;
          
        }
        break;
    case /* BeforeSendSMS */0 :
    case /* SendingSMS */1 :
    case /* FailureToSendSMS */3 :
        tmp = "btn-level1-disabled";
        break;
    
  }
  return React.createElement(React.Fragment, undefined, React.createElement("div", {
                  className: "py-2"
                }, React.createElement("div", {
                      className: "flex"
                    }, React.createElement(Input.make, {
                          type_: "text",
                          name: "phone-number",
                          placeholder: "휴대전화번호",
                          className: "flex-1",
                          value: verifyPhoneNumberForm.values.phoneNumber,
                          onChange: handleOnChangePhoneNumber,
                          size: /* Large */0,
                          error: Curry._1(verifyPhoneNumberForm.getFieldError, /* Field */{
                                _0: /* PhoneNumber */0
                              }),
                          disabled: isDisabledVerifyPhoneNumberForm
                        }), React.createElement("span", {
                          className: "flex ml-2 w-24 h-13"
                        }, React.createElement("button", {
                              className: sms === 2 || sms === 1 ? resendBtnStyle : sendBtnStyle,
                              disabled: isDisabledVerifyPhoneNumberButton,
                              type: "button",
                              onClick: handleOnSubmitPhoneNumber
                            }, sms !== 2 ? "보내기" : "재전송"))), React.createElement("label", {
                      className: "block mt-3",
                      htmlFor: "verify-number"
                    }), React.createElement("div", {
                      className: "relative"
                    }, React.createElement(Input.make, {
                          type_: "number",
                          name: "verify-number",
                          placeholder: "인증번호",
                          value: verificationCodeForm.values.verificationCode,
                          onChange: (function (param) {
                              return ReForm__Helpers.handleChange(partial_arg, param);
                            }),
                          size: /* Large */0,
                          error: Curry._1(verificationCodeForm.getFieldError, /* Field */{
                                _0: /* VerificationCode */0
                              }),
                          disabled: isDisabledVerifyCodeForm,
                          inputRef: inputVerificationCodeRef
                        }), sms !== 2 ? null : (
                        verificationCode !== 2 ? React.createElement(Timer.make, {
                                status: timerStatus,
                                onChangeStatus: onChangeStatus,
                                startTimeInSec: 180,
                                className: "absolute top-3 right-4 text-red-gl"
                              }) : React.createElement("div", {
                                className: "absolute top-3.5 right-4 text-green-gl"
                              }, "인증됨")
                      )), React.createElement("span", {
                      className: "flex h-13 mt-3"
                    }, React.createElement("button", {
                          className: tmp,
                          disabled: isDisabledVerifyCodeForm,
                          onClick: handleOnSubmitVerificationCode
                        }, "인증"))), React.createElement(Dialog.make, {
                  isShow: match$2[0],
                  children: React.createElement("p", {
                        className: "text-gray-500 text-center whitespace-pre-wrap"
                      }, "이미 가입된 회원입니다.\n아이디 찾기를 진행하시겠어요?"),
                  onCancel: (function (param) {
                      setShowDuplicated(function (param) {
                            return /* Hide */1;
                          });
                    }),
                  onConfirm: (function (param) {
                      router.push("/buyer/signin/find-id-password?mode=find-id&phone-number=" + verifyPhoneNumberForm.values.phoneNumber + "");
                    }),
                  textOnCancel: "아니오",
                  textOnConfirm: "아이디 찾기"
                }), React.createElement(Dialog.make, {
                  isShow: match$3[0],
                  children: React.createElement("p", {
                        className: "text-gray-500 text-center whitespace-pre-wrap"
                      }, "인증번호가 일치하지 않습니다."),
                  onConfirm: (function (param) {
                      setShowVerifyError(function (param) {
                            return /* Hide */1;
                          });
                    }),
                  textOnConfirm: "확인"
                }));
}

var make = VerifyBuyerPhoneNumber;

export {
  VerifyPhoneNumberFormFields ,
  VerificationCodeFormFields ,
  VerifyPhoneNumberForm ,
  VerificationCodeForm ,
  initialStateVerifyPhoneNumber ,
  initialStateVerificationCode ,
  sendBtnStyle ,
  resendBtnStyle ,
  make ,
}
/* VerifyPhoneNumberForm Not a pure module */
