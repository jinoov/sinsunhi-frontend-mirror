// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Cx from "rescript-classnames/src/Cx.mjs";
import * as React from "react";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";

function DS_Tab$LeftTab$Root(Props) {
  var children = Props.children;
  var className = Props.className;
  var defaultStyle = "DS_tab_leftTab flex flex-row items-center gap-5 whitespace-nowrap overflow-x-auto h-11 px-5 text-lg text-gray-300 tab-highlight-color bg-white";
  return React.createElement("div", {
              className: Belt_Option.mapWithDefault(className, defaultStyle, (function (className$p) {
                      return Cx.cx([
                                  defaultStyle,
                                  className$p
                                ]);
                    }))
            }, children);
}

var Root = {
  make: DS_Tab$LeftTab$Root
};

function DS_Tab$LeftTab$Item(Props) {
  var children = Props.children;
  var className = Props.className;
  var defaultStyle = "";
  return React.createElement("div", {
              className: Belt_Option.mapWithDefault(className, defaultStyle, (function (className$p) {
                      return Cx.cx([
                                  defaultStyle,
                                  className$p
                                ]);
                    }))
            }, children);
}

var Item = {
  make: DS_Tab$LeftTab$Item
};

var LeftTab = {
  Root: Root,
  Item: Item
};

export {
  LeftTab ,
  
}
/* react Not a pure module */
