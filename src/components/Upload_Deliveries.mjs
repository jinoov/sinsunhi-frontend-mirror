// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Curry from "rescript/lib/es6/curry.js";
import * as React from "react";
import * as Dialog from "./common/Dialog.mjs";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as Garter_Array from "@greenlabs/garter/src/Garter_Array.mjs";
import * as IconCloseInput from "./svgs/IconCloseInput.mjs";
import * as UploadFileToS3PresignedUrl from "../utils/UploadFileToS3PresignedUrl.mjs";

function Upload_Deliveries(Props) {
  var onSuccess = Props.onSuccess;
  var onFailure = Props.onFailure;
  var match = React.useState(function () {
        
      });
  var setFiles = match[1];
  var file = Belt_Option.flatMap(match[0], Garter_Array.first);
  var match$1 = React.useState(function () {
        return /* Hide */1;
      });
  var setShowDelete = match$1[1];
  var match$2 = React.useState(function () {
        return /* Hide */1;
      });
  var setShowFileRequired = match$2[1];
  var handleOnChangeFiles = function (e) {
    var values = e.target.files;
    setFiles(function (param) {
          return values;
        });
  };
  var handleResetFile = function (param) {
    var inputFile = document.getElementById("input-file");
    Belt_Option.map((inputFile == null) ? undefined : Caml_option.some(inputFile), (function (inputFile$p) {
            inputFile$p.value = "";
          }));
    setFiles(function (param) {
          
        });
  };
  return React.createElement(React.Fragment, undefined, React.createElement("section", {
                  className: "py-5"
                }, React.createElement("div", {
                      className: "flex justify-between"
                    }, React.createElement("h4", {
                          className: "font-semibold"
                        }, "2. 송장번호 엑셀 파일 선택 ", React.createElement("span", {
                              className: "block text-gray-400 text-sm"
                            }, "*.xls, xlsx 확장자만 업로드 가능")), React.createElement("label", {
                          className: "p-3 w-28 text-white font-bold text-center whitespace-nowrap bg-green-gl rounded-xl cursor-pointer focus:outline-none hover:bg-green-gl-dark focus-within:bg-green-gl-dark focus-within:outline-none"
                        }, React.createElement("span", undefined, "파일 선택"), React.createElement("input", {
                              className: "sr-only",
                              id: "input-file",
                              accept: ".xls,.xlsx",
                              type: "file",
                              onChange: handleOnChangeFiles
                            }))), React.createElement("div", {
                      className: file !== undefined ? "p-3 relative w-full flex items-center rounded-xl mt-4 border border-gray-200 text-gray-400" : "p-3 relative w-full flex items-center rounded-xl mt-4 border border-gray-200 text-gray-400 bg-gray-100"
                    }, React.createElement("span", undefined, Belt_Option.getWithDefault(Belt_Option.map(file, (function (file$p) {
                                    return file$p.name;
                                  })), "파일명.xlsx")), Belt_Option.getWithDefault(Belt_Option.map(file, (function (param) {
                                return React.createElement("span", {
                                            className: "absolute p-2 right-0",
                                            onClick: (function (param) {
                                                setShowDelete(function (param) {
                                                      return /* Show */0;
                                                    });
                                              })
                                          }, React.createElement(IconCloseInput.make, {
                                                height: "28",
                                                width: "28",
                                                fill: "#B2B2B2"
                                              }));
                              })), null))), React.createElement("section", {
                  className: "py-5"
                }, React.createElement("div", {
                      className: "flex justify-between items-center"
                    }, React.createElement("div", {
                          className: "flex-1 flex justify-between"
                        }, React.createElement("h4", {
                              className: "font-semibold"
                            }, "3. 송장번호 파일 업로드"), React.createElement("button", {
                              className: Belt_Option.isSome(file) ? "text-white font-bold p-3 w-28 bg-green-gl rounded-xl focus:outline-none hover:bg-green-gl-dark" : "text-white font-bold p-3 w-28 bg-gray-300 rounded-xl focus:outline-none",
                              disabled: Belt_Option.isNone(file),
                              onClick: (function (param) {
                                  if (file !== undefined) {
                                    UploadFileToS3PresignedUrl.upload(undefined, /* Seller */0, Caml_option.valFromOption(file), (function (param) {
                                            handleResetFile(undefined);
                                            return Curry._1(onSuccess, undefined);
                                          }), (function (param) {
                                            return Curry._1(onFailure, undefined);
                                          }), undefined);
                                    return ;
                                  } else {
                                    return setShowFileRequired(function (param) {
                                                return /* Show */0;
                                              });
                                  }
                                })
                            }, "업로드")))), React.createElement(Dialog.make, {
                  isShow: match$2[0],
                  children: React.createElement("p", {
                        className: "text-gray-500 text-center whitespace-pre-wrap"
                      }, "파일을 선택해주세요."),
                  onConfirm: (function (param) {
                      setShowFileRequired(function (param) {
                            return /* Hide */1;
                          });
                    })
                }), React.createElement(Dialog.make, {
                  isShow: match$1[0],
                  children: React.createElement("p", {
                        className: "text-gray-500 text-center whitespace-pre-wrap"
                      }, "파일을 삭제하시겠어요?"),
                  onCancel: (function (param) {
                      setShowDelete(function (param) {
                            return /* Hide */1;
                          });
                    }),
                  onConfirm: (function (param) {
                      handleResetFile(undefined);
                      setShowDelete(function (param) {
                            return /* Hide */1;
                          });
                    }),
                  textOnCancel: "닫기",
                  textOnConfirm: "삭제"
                }));
}

var make = Upload_Deliveries;

export {
  make ,
}
/* react Not a pure module */
