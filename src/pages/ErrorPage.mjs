// Generated by ReScript, PLEASE EDIT WITH CARE

import * as React from "react";
import Head from "next/head";
import * as IconNotFound from "../components/svgs/IconNotFound.mjs";

function ErrorPage(Props) {
  return React.createElement(React.Fragment, undefined, React.createElement(Head, {
                  children: React.createElement("title", undefined, "신선하이")
                }), React.createElement("div", {
                  className: "w-screen h-screen flex items-center justify-center"
                }, React.createElement("div", {
                      className: "flex flex-col items-center justify-center"
                    }, React.createElement(IconNotFound.make, {
                          width: "160",
                          height: "160"
                        }), React.createElement("h1", {
                          className: "mt-7 text-2xl text-gray-800 font-bold"
                        }, "처리중 오류가 발생하였습니다."), React.createElement("span", {
                          className: "mt-4 text-gray-800"
                        }, "페이지를 불러오는 중에 문제가 발생하였습니다."), React.createElement("span", {
                          className: "text-gray-800"
                        }, "잠시 후 재시도해 주세요."))));
}

var make = ErrorPage;

export {
  make ,
}
/* react Not a pure module */
