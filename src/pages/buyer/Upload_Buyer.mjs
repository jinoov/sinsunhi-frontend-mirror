// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Env from "../../constants/Env.mjs";
import * as Swr from "swr";
import * as React from "react";
import * as Dialog from "../../components/common/Dialog.mjs";
import * as Locale from "../../utils/Locale.mjs";
import * as Skeleton from "../../components/Skeleton.mjs";
import * as IconArrow from "../../components/svgs/IconArrow.mjs";
import Link from "next/link";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as CustomHooks from "../../utils/CustomHooks.mjs";
import * as Router from "next/router";
import * as Authorization from "../../utils/Authorization.mjs";
import * as Upload_Orders from "../../components/Upload_Orders.mjs";
import * as ChannelTalkHelper from "../../utils/ChannelTalkHelper.mjs";
import * as Guide_Upload_Buyer from "../../components/Guide_Upload_Buyer.mjs";
import * as UploadStatus_Buyer from "../../components/UploadStatus_Buyer.mjs";

function Upload_Buyer$UserDeposit(Props) {
  var router = Router.useRouter();
  var status = CustomHooks.UserDeposit.use(new URLSearchParams(router.query).toString());
  var tmp;
  if (typeof status === "number") {
    tmp = React.createElement(Skeleton.Box.make, {
          className: "w-40"
        });
  } else if (status.TAG === /* Loaded */0) {
    var deposit$p = CustomHooks.UserDeposit.response_decode(status._0);
    tmp = deposit$p.TAG === /* Ok */0 ? Locale.Float.show(undefined, deposit$p._0.data.deposit, 0) + "원" : React.createElement(Skeleton.Box.make, {
            className: "w-40"
          });
  } else {
    console.log(status._0);
    tmp = React.createElement(Skeleton.Box.make, {
          className: "w-40"
        });
  }
  return React.createElement("div", {
              className: "container max-w-lg mx-auto px-5 sm:p-7 sm:shadow-gl"
            }, React.createElement(Link, {
                  href: "/buyer/transactions",
                  passHref: true,
                  children: React.createElement("a", {
                        className: "w-full h-auto flex items-center p-5 sm:p-0 shadow-gl sm:shadow-none rounded-lg"
                      }, React.createElement("div", undefined, React.createElement("span", {
                                className: "block text-sm"
                              }, "총 주문 가능 금액"), React.createElement("span", {
                                className: "block text-primary text-lg font-bold"
                              }, tmp)), React.createElement(IconArrow.make, {
                            height: "24",
                            width: "24",
                            fill: "#262626",
                            className: "ml-auto"
                          }))
                }));
}

var UserDeposit = {
  make: Upload_Buyer$UserDeposit
};

function Upload_Buyer$Tab$Selected(Props) {
  var children = Props.children;
  return React.createElement("div", {
              className: "pb-4 border-b border-gray-800 h-full"
            }, children);
}

var Selected = {
  make: Upload_Buyer$Tab$Selected
};

function Upload_Buyer$Tab$Unselected(Props) {
  var href = Props.href;
  var children = Props.children;
  return React.createElement("div", {
              className: "pb-4 text-gray-600"
            }, React.createElement(Link, {
                  href: href,
                  children: children
                }));
}

var Unselected = {
  make: Upload_Buyer$Tab$Unselected
};

function Upload_Buyer$Tab$Container(Props) {
  var children = Props.children;
  return React.createElement("div", {
              className: "container max-w-lg mx-auto p-7 pb-0 sm:shadow-gl sm:mt-4 border-b flex gap-5 text-lg font-bold"
            }, children);
}

var Container = {
  make: Upload_Buyer$Tab$Container
};

function Upload_Buyer$Tab$Prepaid(Props) {
  var buyer = CustomHooks.AfterPayCredit.use(undefined);
  if (typeof buyer === "number" || !(buyer.TAG === /* Loaded */0 && buyer._0.credit.isAfterPayEnabled)) {
    return null;
  } else {
    return React.createElement(Upload_Buyer$Tab$Container, {
                children: null
              }, React.createElement(Upload_Buyer$Tab$Selected, {
                    children: "선결제 주문"
                  }), React.createElement(Upload_Buyer$Tab$Unselected, {
                    href: "/buyer/after-pay/upload",
                    children: "나중결제 주문"
                  }));
  }
}

var Prepaid = {
  make: Upload_Buyer$Tab$Prepaid
};

function Upload_Buyer$Tab$AfterPay(Props) {
  return React.createElement(Upload_Buyer$Tab$Container, {
              children: null
            }, React.createElement(Upload_Buyer$Tab$Unselected, {
                  href: "/buyer/upload",
                  children: "선결제 주문"
                }), React.createElement(Upload_Buyer$Tab$Selected, {
                  children: "나중결제 주문"
                }));
}

var AfterPay = {
  make: Upload_Buyer$Tab$AfterPay
};

var Tab = {
  Selected: Selected,
  Unselected: Unselected,
  Container: Container,
  Prepaid: Prepaid,
  AfterPay: AfterPay
};

function Upload_Buyer(Props) {
  var router = Router.useRouter();
  var match = Swr.useSWRConfig();
  var mutate = match.mutate;
  var match$1 = React.useState(function () {
        return /* Hide */1;
      });
  var setShowSuccess = match$1[1];
  var match$2 = React.useState(function () {
        return /* Hide */1;
      });
  var setShowError = match$2[1];
  ChannelTalkHelper.Hook.use(undefined, undefined, undefined);
  return React.createElement(Authorization.Buyer.make, {
              children: null,
              title: "주문서 업로드"
            }, React.createElement(Upload_Buyer$Tab$Prepaid, {}), React.createElement(Upload_Buyer$UserDeposit, {}), React.createElement("div", {
                  className: "max-w-lg mt-4 mx-5 sm:mx-auto sm:shadow-gl rounded-lg border border-red-150"
                }, React.createElement("div", {
                      className: "py-4 px-5 bg-red-gl rounded-lg text-red-500"
                    }, React.createElement("span", {
                          className: "block font-bold"
                        }, "[필독사항]"), React.createElement("div", {
                          className: "flex gap-1.5"
                        }, React.createElement("span", undefined, "1."), React.createElement("div", undefined, "가이드를 참고하여 주문서를 작성해주셔야 합니다.", React.createElement("a", {
                                  id: "link-of-upload-guide",
                                  href: Env.buyerUploadGuideUri,
                                  target: "_blank"
                                }, React.createElement("p", {
                                      className: "inline mx-1 min-w-max cursor-pointer hover:underline"
                                    }, "[가이드]")), React.createElement("span", {
                                  className: "block sm:whitespace-pre-wrap"
                                }, "잘못 작성된 주문서를 등록하시면 주문이 실패됩니다.\n※ 현금영수증 관련 내용(P열~Q열)이 자주 누락됩니다.\n꼭 확인해 주세요!"))), React.createElement("div", {
                          className: "flex gap-1"
                        }, React.createElement("span", undefined, "2."), React.createElement("div", undefined, React.createElement("span", {
                                  className: "sm:whitespace-pre-wrap"
                                }, "먼저 주문가능금액(신선캐시) 충전이 필요합니다.\n주문가능금액이 발주할 총 금액보다 많아야 하니 부족할 경우\n"), React.createElement("a", {
                                  id: "link-of-upload-guide",
                                  href: "/buyer/transactions",
                                  target: "_blank"
                                }, React.createElement("p", {
                                      className: "inline mr-0.5 min-w-max cursor-pointer hover:underline"
                                    }, "[결제내역]")), "탭에서 신선캐시를 충전해주세요.")))), React.createElement("div", {
                  className: "container max-w-lg mx-auto p-7 sm:shadow-gl sm:mt-4"
                }, React.createElement("h3", {
                      className: "font-bold text-lg w-full sm:w-9/12"
                    }, "주문서 양식에 맞는 주문서를 선택하신 후 업로드를 진행해보세요."), React.createElement("div", {
                      className: "divide-y"
                    }, React.createElement(Upload_Orders.make, {
                          onSuccess: (function (param) {
                              setShowSuccess(function (param) {
                                    return /* Show */0;
                                  });
                              mutate(Env.restApiUrl + "/order/recent-uploads?upload-type=order&pay-type=PAID", undefined, undefined);
                              var target = "upload-status";
                              var el = document.getElementById(target);
                              return Belt_Option.mapWithDefault((el == null) ? undefined : Caml_option.some(el), undefined, (function (el$p) {
                                            el$p.scrollIntoView({
                                                  behavior: "smooth",
                                                  block: "start"
                                                });
                                            
                                          }));
                            }),
                          onFailure: (function (param) {
                              return setShowError(function (param) {
                                          return /* Show */0;
                                        });
                            }),
                          startIndex: 1
                        }), React.createElement("section", {
                          className: "py-5"
                        }, React.createElement("div", {
                              className: "flex justify-between"
                            }, React.createElement("h4", {
                                  className: "font-semibold"
                                }, "주문서 양식", React.createElement("span", {
                                      className: "block text-gray-400 text-sm"
                                    }, "*이 양식으로 작성된 주문서만 업로드 가능")), React.createElement("a", {
                                  href: Env.buyerOrderExcelFormUri
                                }, React.createElement("span", {
                                      className: "inline-block text-center text-green-gl font-bold py-2 w-28 border border-green-gl rounded-xl focus:outline-none hover:text-green-gl-dark hover:border-green-gl-dark"
                                    }, "양식 다운로드")))))), React.createElement("div", {
                  className: "container max-w-lg mx-auto p-7 sm:shadow-gl sm:mt-4",
                  id: "upload-status"
                }, React.createElement("section", {
                      className: "py-5"
                    }, React.createElement("h4", {
                          className: "font-semibold"
                        }, "주문서 업로드 결과"), React.createElement("p", {
                          className: "mt-1 text-gray-400 text-sm"
                        }, "*가장 최근 요청한 3가지 등록건만 노출됩니다.")), React.createElement(UploadStatus_Buyer.make, {
                      kind: /* Buyer */1,
                      onChangeLatestUpload: (function (param) {
                          return mutate(Env.restApiUrl + "/user/deposit?" + new URLSearchParams(router.query).toString(), undefined, true);
                        }),
                      uploadType: /* Order */0
                    }), React.createElement("p", {
                      className: "mt-5 text-sm text-gray-400"
                    }, "주의: 주문서 업로드가 완료되기 전까지 일부 기능을 사용하실 수 없습니다. 주문서에 기재하신 내용에 따라 정상적으로 처리되지 않을 수 있습니다. 처리 결과를 반드시 확인해 주시기 바랍니다. 주문서 업로드는 상황에 따라 5분까지 소요될 수 있습니다.")), React.createElement(Guide_Upload_Buyer.make, {}), React.createElement(Dialog.make, {
                  isShow: match$1[0],
                  children: React.createElement("p", {
                        className: "text-gray-500 text-center whitespace-pre-wrap"
                      }, "주문서 업로드가 실행되었습니다. 성공여부를 꼭 주문서 업로드 결과에서 확인해주세요."),
                  onConfirm: (function (param) {
                      return setShowSuccess(function (param) {
                                  return /* Hide */1;
                                });
                    })
                }), React.createElement(Dialog.make, {
                  isShow: match$2[0],
                  children: React.createElement("p", {
                        className: "text-gray-500 text-center whitespace-pre-wrap"
                      }, "파일 업로드에 실패하였습니다."),
                  onConfirm: (function (param) {
                      return setShowError(function (param) {
                                  return /* Hide */1;
                                });
                    })
                }));
}

var UploadFile;

var make = Upload_Buyer;

export {
  UploadFile ,
  UserDeposit ,
  Tab ,
  make ,
  
}
/* Env Not a pure module */
