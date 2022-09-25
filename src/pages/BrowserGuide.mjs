// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Env from "../constants/Env.mjs";
import * as React from "react";
import * as ReactUtil from "../utils/ReactUtil.mjs";
import Clipboard from "clipboard";
import Head from "next/head";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import ChromeSvg from "../../public/assets/chrome.svg";

var chromeIcon = ChromeSvg;

function BrowserGuide(props) {
  React.useEffect((function () {
          new Clipboard(".btn-link");
        }), []);
  var showAlertCopyToClipboard = function (param) {
    Belt_Option.map(Caml_option.undefined_to_opt(typeof window === "undefined" ? undefined : window), (function (param) {
            window.alert("클립보드에 복사되었습니다.");
          }));
  };
  var locationOrigin = Belt_Option.mapWithDefault(Caml_option.undefined_to_opt(typeof window === "undefined" ? undefined : window), Env.originProd, (function (param) {
          return window.location.origin;
        }));
  return React.createElement(React.Fragment, undefined, React.createElement(Head, {
                  children: React.createElement("title", undefined, "IE 접속 가이드 - 신선하이")
                }), React.createElement("div", {
                  className: "flex flex-col h-screen justify-center items-center text-black-gl"
                }, React.createElement("img", {
                      alt: "신선하이 로고",
                      height: "42",
                      src: "/assets/sinsunhi-logo.svg",
                      width: "164"
                    }), React.createElement("div", {
                      className: "text-center text-lg whitespace-pre font-bold mt-14"
                    }, "지금 사용중인 브라우저에서는 \n신선하이를 이용하실 수 없습니다."), React.createElement("div", {
                      className: "text-center whitespace-pre mt-5 text-gray-400"
                    }, "안전한 업로드 환경 지원을 위한 조치로 많은 양해 부탁드립니다.\nChrome 브라우저에서 쾌적하게 작동합니다."), React.createElement("a", {
                      href: Env.downloadChromeUrl,
                      target: "_blank"
                    }, React.createElement("div", {
                          className: "flex justify-center items-center py-3 w-80 border border-gray-200 rounded-xl font-bold mt-14"
                        }, React.createElement("img", {
                              src: chromeIcon
                            }), React.createElement("span", {
                              className: "ml-1"
                            }, "크롬 다운로드"))), React.createElement("div", {
                      className: "flex mt-8 w-80 text-gray-600"
                    }, React.createElement(ReactUtil.SpreadProps.make, {
                          children: React.createElement("div", {
                                className: "flex-1 btn-link",
                                onClick: showAlertCopyToClipboard
                              }, React.createElement("div", {
                                    className: "flex justify-center items-center py-3 bg-gray-100 rounded-xl mr-2"
                                  }, "바이어 마켓 주소 복사")),
                          props: {
                            "data-clipboard-text": "" + locationOrigin + "/buyer/signin"
                          }
                        }), React.createElement(ReactUtil.SpreadProps.make, {
                          children: React.createElement("div", {
                                className: "flex-1 btn-link",
                                onClick: showAlertCopyToClipboard
                              }, React.createElement("div", {
                                    className: "flex-1 flex justify-center items-center py-3 bg-gray-100 rounded-xl"
                                  }, "생산자 마켓 주소 복사")),
                          props: {
                            "data-clipboard-text": "" + locationOrigin + "/seller/signin"
                          }
                        }))));
}

var make = BrowserGuide;

export {
  chromeIcon ,
  make ,
}
/* chromeIcon Not a pure module */
