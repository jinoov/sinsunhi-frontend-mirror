// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Env from "../../constants/Env.mjs";
import * as Swr from "swr";
import * as React from "react";
import * as Dialog from "../../components/common/Dialog.mjs";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as CustomHooks from "../../utils/CustomHooks.mjs";
import * as Authorization from "../../utils/Authorization.mjs";
import Format from "date-fns/format";
import * as ChannelTalkHelper from "../../utils/ChannelTalkHelper.mjs";
import * as Upload_Deliveries from "../../components/Upload_Deliveries.mjs";
import * as Guide_Upload_Seller from "../../components/Guide_Upload_Seller.mjs";
import * as UploadStatus_Seller from "../../components/UploadStatus_Seller.mjs";
import * as Excel_Download_Request_Button_Seller from "../../components/Excel_Download_Request_Button_Seller.mjs";

function Upload_Seller$Upload(Props) {
  var match = Swr.useSWRConfig();
  var mutate = match.mutate;
  var match$1 = React.useState(function () {
        return /* Hide */1;
      });
  var setShowDownloadError = match$1[1];
  var match$2 = React.useState(function () {
        return /* Hide */1;
      });
  var setShowNothingToDownload = match$2[1];
  var match$3 = React.useState(function () {
        return /* Hide */1;
      });
  var setShowSuccess = match$3[1];
  var match$4 = React.useState(function () {
        return /* Hide */1;
      });
  var setShowError = match$4[1];
  ChannelTalkHelper.Hook.use(undefined, undefined, undefined);
  var payload = Belt_Option.map(CustomHooks.Auth.toOption(CustomHooks.Auth.use(undefined)), (function (user$p) {
          return {
                  "farmer-id": user$p.uid,
                  status: "PACKING",
                  from: "20210101",
                  to: Format(new Date(), "yyyyMMdd")
                };
        }));
  return React.createElement(React.Fragment, undefined, React.createElement("div", {
                  className: "container pt-4 sm:pt-0 sm:px-0 max-w-lg mx-auto sm:shadow-gl sm:mt-4 rounded-lg"
                }, React.createElement("div", {
                      className: "p-5 sm:p-7 md:shadow-gl"
                    }, React.createElement("h3", {
                          className: "font-bold text-lg"
                        }, "송장번호 일괄등록"), React.createElement("div", {
                          className: "divide-y"
                        }, React.createElement("section", {
                              className: "flex justify-between py-5"
                            }, React.createElement("h4", {
                                  className: "font-semibold"
                                }, "1. 상품준비중인 주문 다운로드"), React.createElement(Excel_Download_Request_Button_Seller.make, {
                                  userType: /* Seller */0,
                                  requestUrl: "/order/request-excel/farmer",
                                  bodyOption: payload
                                })), React.createElement(Upload_Deliveries.make, {
                              onSuccess: (function (param) {
                                  setShowSuccess(function (param) {
                                        return /* Show */0;
                                      });
                                  return mutate(Env.restApiUrl + "/order/recent-uploads?upload-type=invoice", undefined, undefined);
                                }),
                              onFailure: (function (param) {
                                  return setShowError(function (param) {
                                              return /* Show */0;
                                            });
                                })
                            }))), React.createElement("div", {
                      className: "p-5 sm:p-7 mt-4 md:shadow-gl"
                    }, React.createElement("h4", {
                          className: "font-semibold"
                        }, "4. 파일 업로드 결과 확인"), React.createElement(UploadStatus_Seller.make, {
                          kind: /* Seller */0
                        })), React.createElement(Guide_Upload_Seller.make, {})), React.createElement(Dialog.make, {
                  isShow: match$1[0],
                  children: React.createElement("p", {
                        className: "text-gray-500 text-center whitespace-pre-wrap"
                      }, "다운로드에 실패하였습니다.\n다시 시도하시기 바랍니다."),
                  onConfirm: (function (param) {
                      return setShowDownloadError(function (param) {
                                  return /* Hide */1;
                                });
                    })
                }), React.createElement(Dialog.make, {
                  isShow: match$2[0],
                  children: React.createElement("p", {
                        className: "text-gray-500 text-center whitespace-pre-wrap"
                      }, "다운로드할 주문이 없습니다."),
                  onCancel: (function (param) {
                      return setShowNothingToDownload(function (param) {
                                  return /* Hide */1;
                                });
                    }),
                  textOnCancel: "확인"
                }), React.createElement(Dialog.make, {
                  isShow: match$3[0],
                  children: React.createElement("p", {
                        className: "text-gray-500 text-center whitespace-pre-wrap"
                      }, "파일 업로드가 시작되었습니다."),
                  onConfirm: (function (param) {
                      return setShowSuccess(function (param) {
                                  return /* Hide */1;
                                });
                    })
                }), React.createElement(Dialog.make, {
                  isShow: match$4[0],
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

var Upload = {
  make: Upload_Seller$Upload
};

function Upload_Seller(Props) {
  return React.createElement(Authorization.Seller.make, {
              children: React.createElement(Upload_Seller$Upload, {}),
              title: "송장번호 대량 등록"
            });
}

var UploadFile;

var make = Upload_Seller;

export {
  UploadFile ,
  Upload ,
  make ,
  
}
/* Env Not a pure module */