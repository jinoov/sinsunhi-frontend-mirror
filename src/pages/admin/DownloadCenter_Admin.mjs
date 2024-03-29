// Generated by ReScript, PLEASE EDIT WITH CARE

import * as React from "react";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as Authorization from "../../utils/Authorization.mjs";
import * as DownloadCenter_Render from "../../components/DownloadCenter_Render.mjs";

function DownloadCenter_Admin$Layout(Props) {
  var children = Props.children;
  return React.createElement("div", {
              className: "pl-5 pr-20 py-10"
            }, React.createElement("strong", {
                  className: "text-xl"
                }, "다운로드 센터"), Belt_Option.getWithDefault(children, null));
}

var Layout = {
  make: DownloadCenter_Admin$Layout
};

function DownloadCenter_Admin(Props) {
  return React.createElement(Authorization.Admin.make, {
              children: React.createElement(DownloadCenter_Render.make, {
                    children: React.createElement(DownloadCenter_Admin$Layout, {})
                  }),
              title: "관리자 다운로드 센터"
            });
}

var make = DownloadCenter_Admin;

export {
  Layout ,
  make ,
}
/* react Not a pure module */
