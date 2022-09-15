// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Cx from "rescript-classnames/src/Cx.mjs";
import * as Env from "../constants/Env.mjs";
import * as Curry from "rescript/lib/es6/curry.js";
import * as Input from "./common/Input.mjs";
import * as React from "react";
import * as Dialog from "./common/Dialog.mjs";
import * as Checkbox from "./common/Checkbox.mjs";
import * as IconCheck from "./svgs/IconCheck.mjs";
import * as IconClose from "./svgs/IconClose.mjs";
import * as IconError from "./svgs/IconError.mjs";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as FetchHelper from "../utils/FetchHelper.mjs";
import * as ReactEvents from "../utils/ReactEvents.mjs";
import * as ReactRelay from "react-relay";
import * as RelayRuntime from "relay-runtime";
import * as ValidatedState from "../utils/ValidatedState.mjs";
import * as ReactDialog from "@radix-ui/react-dialog";
import * as ReactToastNotifications from "react-toast-notifications";
import * as UpdatePasswordBuyer_Mutation_graphql from "../__generated__/UpdatePasswordBuyer_Mutation_graphql.mjs";

function commitMutation(environment, variables, optimisticUpdater, optimisticResponse, updater, onCompleted, onError, uploadables, param) {
  return RelayRuntime.commitMutation(environment, {
              mutation: UpdatePasswordBuyer_Mutation_graphql.node,
              variables: UpdatePasswordBuyer_Mutation_graphql.Internal.convertVariables(variables),
              onCompleted: (function (res, err) {
                  if (onCompleted !== undefined) {
                    return Curry._2(onCompleted, UpdatePasswordBuyer_Mutation_graphql.Internal.convertResponse(res), (err == null) ? undefined : Caml_option.some(err));
                  }
                  
                }),
              onError: (function (err) {
                  if (onError !== undefined) {
                    return Curry._1(onError, (err == null) ? undefined : Caml_option.some(err));
                  }
                  
                }),
              optimisticResponse: optimisticResponse !== undefined ? UpdatePasswordBuyer_Mutation_graphql.Internal.convertWrapRawResponse(optimisticResponse) : undefined,
              optimisticUpdater: optimisticUpdater,
              updater: updater !== undefined ? (function (store, r) {
                    Curry._2(updater, store, UpdatePasswordBuyer_Mutation_graphql.Internal.convertResponse(r));
                  }) : undefined,
              uploadables: uploadables
            });
}

function use(param) {
  var match = ReactRelay.useMutation(UpdatePasswordBuyer_Mutation_graphql.node);
  var mutate = match[0];
  return [
          React.useMemo((function () {
                  return function (param, param$1, param$2, param$3, param$4, param$5, param$6, param$7, param$8) {
                    return Curry._1(mutate, {
                                onError: param,
                                onCompleted: param$1 !== undefined ? (function (r, errors) {
                                      Curry._2(param$1, UpdatePasswordBuyer_Mutation_graphql.Internal.convertResponse(r), (errors == null) ? undefined : Caml_option.some(errors));
                                    }) : undefined,
                                onUnsubscribe: param$2,
                                optimisticResponse: param$3 !== undefined ? UpdatePasswordBuyer_Mutation_graphql.Internal.convertWrapRawResponse(param$3) : undefined,
                                optimisticUpdater: param$4,
                                updater: param$5 !== undefined ? (function (store, r) {
                                      Curry._2(param$5, store, UpdatePasswordBuyer_Mutation_graphql.Internal.convertResponse(r));
                                    }) : undefined,
                                variables: UpdatePasswordBuyer_Mutation_graphql.Internal.convertVariables(param$6),
                                uploadables: param$7
                              });
                  };
                }), [mutate]),
          match[1]
        ];
}

var Mutation = {
  Operation: undefined,
  Types: undefined,
  commitMutation: commitMutation,
  use: use
};

function Update_Password_Buyer$ConfirmView(Props) {
  var email = Props.email;
  var handleCloseButton = Props.handleCloseButton;
  var nextStep = Props.nextStep;
  var match = React.useState(function () {
        return "";
      });
  var setPassword = match[1];
  var password = match[0];
  var match$1 = React.useState(function () {
        
      });
  var setErrorMessage = match$1[1];
  var match$2 = React.useState(function () {
        return false;
      });
  var setLoading = match$2[1];
  var loading = match$2[0];
  var handleNext = function (param) {
    return ReactEvents.interceptingHandler((function (param) {
                  setLoading(function (param) {
                        return true;
                      });
                  Belt_Option.map(JSON.stringify({
                            password: password
                          }), (function (body) {
                          return FetchHelper.requestWithRetry(FetchHelper.postWithToken, "" + Env.restApiUrl + "/user/password/check", body, 3, (function (param) {
                                        Curry._1(nextStep, undefined);
                                        setLoading(function (param) {
                                              return false;
                                            });
                                        setErrorMessage(function (param) {
                                              
                                            });
                                      }), (function (param) {
                                        setErrorMessage(function (param) {
                                              return "비밀번호가 유효하지 않습니다.";
                                            });
                                        setLoading(function (param) {
                                              return false;
                                            });
                                      }));
                        }));
                }), param);
  };
  return React.createElement("form", {
              onSubmit: handleNext
            }, React.createElement("section", {
                  className: "h-14 w-full xl:h-auto xl:w-auto xl:mt-10"
                }, React.createElement("div", {
                      className: "flex items-center justify-between px-5 w-full py-4 xl:h-14 xl:w-full xl:pb-10"
                    }, React.createElement("div", {
                          className: "w-6"
                        }), React.createElement("div", {
                          className: "xl:hidden"
                        }, React.createElement("span", {
                              className: "font-bold"
                            }, "비밀번호 재설정")), React.createElement("button", {
                          className: "focus:outline-none",
                          type: "button",
                          onClick: handleCloseButton
                        }, React.createElement(IconClose.make, {
                              height: "24",
                              width: "24",
                              fill: "#262626"
                            })))), React.createElement("section", {
                  className: "my-6 px-4 xl:mt-0 xl:mb-6"
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
                                loading || password === "" ? "bg-disabled-L2" : "bg-green-500"
                              ]),
                          disabled: password === "",
                          type: "submit"
                        }, React.createElement("span", {
                              className: "text-white"
                            }, "다음")))));
}

var ConfirmView = {
  make: Update_Password_Buyer$ConfirmView
};

function formatValidator(password) {
  var exp = new RegExp("^(?=.*\\d)(?=.*[a-zA-Z]).{6,15}$");
  if (exp.test(password)) {
    return {
            TAG: /* Ok */0,
            _0: password
          };
  } else {
    return {
            TAG: /* Error */1,
            _0: {
              type_: "format",
              message: "영문, 숫자 조합 6~15자로 입력해 주세요."
            }
          };
  }
}

function Update_Password_Buyer$UpdateView(Props) {
  var handleCloseButton = Props.handleCloseButton;
  var close = Props.close;
  var match = ReactToastNotifications.useToasts();
  var addToast = match.addToast;
  var match$1 = React.useState(function () {
        return false;
      });
  var setShowPassword = match$1[1];
  var showPassword = match$1[0];
  var match$2 = ValidatedState.use(/* String */0, "", [formatValidator]);
  var state = match$2[2];
  var setPassword = match$2[1];
  var password = match$2[0];
  var match$3 = use(undefined);
  var mutating = match$3[1];
  var mutate = match$3[0];
  var handlePasswordChange = function (e) {
    var newPassword = e.target.value;
    Curry._3(setPassword, newPassword, true, undefined);
  };
  var handleOnSubmit = function (param) {
    return ReactEvents.interceptingHandler((function (param) {
                  Curry.app(mutate, [
                        (function (err) {
                            addToast(React.createElement("div", {
                                      className: "flex items-center"
                                    }, React.createElement(IconError.make, {
                                          width: "24",
                                          height: "24",
                                          className: "mr-2"
                                        }), "오류가 발생하였습니다. 비밀번호를 확인하세요.", err.message), {
                                  appearance: "error"
                                });
                          }),
                        (function (param, param$1) {
                            var updateUser = param.updateUser;
                            var variant = updateUser.NAME;
                            if (variant === "UnselectedUnionMember") {
                              return addToast(React.createElement("div", {
                                              className: "flex items-center"
                                            }, React.createElement(IconError.make, {
                                                  width: "24",
                                                  height: "24",
                                                  className: "mr-2"
                                                }), "오류가 발생하였습니다. 비밀번호를 확인하세요."), {
                                          appearance: "error"
                                        });
                            } else if (variant === "User") {
                              addToast(React.createElement("div", {
                                        className: "flex items-center"
                                      }, React.createElement(IconCheck.make, {
                                            height: "24",
                                            width: "24",
                                            fill: "#12B564",
                                            className: "mr-2"
                                          }), "비밀번호가 재설정 되었습니다."), {
                                    appearance: "success"
                                  });
                              return Curry._1(close, undefined);
                            } else {
                              return addToast(React.createElement("div", {
                                              className: "flex items-center"
                                            }, React.createElement(IconError.make, {
                                                  width: "24",
                                                  height: "24",
                                                  className: "mr-2"
                                                }), "오류가 발생하였습니다. 비밀번호를 확인하세요.", Belt_Option.getWithDefault(updateUser.VAL.message, "")), {
                                          appearance: "error"
                                        });
                            }
                          }),
                        undefined,
                        undefined,
                        undefined,
                        undefined,
                        {
                          input: {
                            password: password
                          }
                        },
                        undefined,
                        undefined
                      ]);
                }), param);
  };
  return React.createElement("form", {
              onSubmit: handleOnSubmit
            }, React.createElement("section", {
                  className: "h-14 w-full xl:h-auto xl:w-auto xl:mt-10"
                }, React.createElement("div", {
                      className: "flex items-center justify-between px-5 w-full py-4 xl:h-14 xl:w-full xl:pb-10"
                    }, React.createElement("div", {
                          className: "w-6 xl:hidden"
                        }), React.createElement("div", undefined, React.createElement("span", {
                              className: "font-bold xl:text-2xl"
                            }, "비밀번호 재설정")), React.createElement("button", {
                          className: "focus:outline-none",
                          type: "button",
                          onClick: handleCloseButton
                        }, React.createElement(IconClose.make, {
                              height: "24",
                              width: "24",
                              fill: "#262626"
                            })))), React.createElement("section", {
                  className: "pt-12 xl:pt-3 mb-6 px-4"
                }, React.createElement("div", {
                      className: "flex flex-col"
                    }, React.createElement("div", {
                          className: "flex flex-col mb-5"
                        }, React.createElement("div", {
                              className: "mb-2"
                            }, React.createElement("span", {
                                  className: "font-bold"
                                }, "새로운 비밀번호 입력")), React.createElement(Input.make, {
                              type_: showPassword ? "text" : "password",
                              name: "new-password",
                              placeholder: "새로운 비밀번호(영문, 숫자 조합 6-15자리)",
                              className: "w-full border border-border-default-L1 p-3 rounded-xl focus:outline-none",
                              value: password,
                              onChange: handlePasswordChange,
                              size: /* Large */0,
                              error: Belt_Option.map(state.error, (function (param) {
                                      return param.message;
                                    })),
                              disabled: mutating
                            })), React.createElement("div", {
                          className: "flex mb-10 items-center"
                        }, React.createElement(Checkbox.make, {
                              id: "password-reveal",
                              name: "password-reveal",
                              checked: showPassword,
                              onChange: (function (param) {
                                  setShowPassword(function (param) {
                                        return !showPassword;
                                      });
                                })
                            }), React.createElement("label", {
                              className: "ml-2 text-text-L1",
                              htmlFor: "password-reveal"
                            }, "비밀번호 표시"))), React.createElement("button", {
                      className: "bg-green-500 rounded-xl w-full py-4",
                      disabled: mutating || Belt_Option.isSome(state.error),
                      type: "submit"
                    }, React.createElement("span", {
                          className: "text-white"
                        }, "재설정"))));
}

var UpdateView = {
  formatValidator: formatValidator,
  make: Update_Password_Buyer$UpdateView
};

function Update_Password_Buyer(Props) {
  var isOpen = Props.isOpen;
  var onClose = Props.onClose;
  var email = Props.email;
  var match = React.useState(function () {
        return /* Confirm */0;
      });
  var setStep = match[1];
  var match$1 = React.useState(function () {
        return /* Hide */1;
      });
  var setShowNotice = match$1[1];
  var handleCloseButton = function (param) {
    setShowNotice(function (param) {
          return /* Show */0;
        });
  };
  return React.createElement(React.Fragment, undefined, React.createElement(ReactDialog.Root, {
                  children: null,
                  open: isOpen
                }, React.createElement(ReactDialog.Overlay, {
                      className: "dialog-overlay"
                    }), React.createElement(ReactDialog.Content, {
                      children: React.createElement("div", {
                            className: "fixed top-0 left-0 h-full xl:static bg-white w-full max-w-3xl xl:min-h-fit xl:min-w-min xl:w-[90vh] xl:max-w-[480px] xl:max-h-[85vh] "
                          }, match[0] ? React.createElement(Update_Password_Buyer$UpdateView, {
                                  handleCloseButton: handleCloseButton,
                                  close: (function (param) {
                                      setStep(function (param) {
                                            return /* Confirm */0;
                                          });
                                      Curry._1(onClose, undefined);
                                    })
                                }) : React.createElement(Update_Password_Buyer$ConfirmView, {
                                  email: email,
                                  handleCloseButton: handleCloseButton,
                                  nextStep: (function (param) {
                                      setStep(function (param) {
                                            return /* Update */1;
                                          });
                                    })
                                })),
                      className: "dialog-content-plain bottom-0 left-0 xl:bottom-auto xl:left-auto xl:rounded-2xl xl:state-open:top-1/2 xl:state-open:left-1/2 xl:state-open:-translate-x-1/2 xl:state-open:-translate-y-1/2 dialog-content-z-15"
                    })), React.createElement(Dialog.make, {
                  isShow: match$1[0],
                  children: React.createElement("div", {
                        className: "text-center"
                      }, "비밀번호 재설정이 진행중입니다.", React.createElement("br", undefined), "진행을 취소하시겠어요?"),
                  onCancel: (function (param) {
                      setShowNotice(function (param) {
                            return /* Hide */1;
                          });
                    }),
                  onConfirm: (function (param) {
                      setShowNotice(function (param) {
                            return /* Hide */1;
                          });
                      setStep(function (param) {
                            return /* Confirm */0;
                          });
                      Curry._1(onClose, undefined);
                    }),
                  textOnCancel: "아니요",
                  textOnConfirm: "네",
                  kindOfConfirm: /* Negative */1,
                  boxStyle: "border rounded-xl"
                }));
}

var DialogCmp;

var make = Update_Password_Buyer;

export {
  DialogCmp ,
  Mutation ,
  ConfirmView ,
  UpdateView ,
  make ,
}
/* Env Not a pure module */