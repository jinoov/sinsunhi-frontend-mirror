// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Cn from "rescript-classnames/src/Cn.mjs";
import * as React from "react";
import * as Router from "next/router";

function make(id, name, kind) {
  return {
          name: name,
          id: id,
          kind: kind
        };
}

var Data = {
  make: make
};

function PLP_Scrollable_Tab_Item$PC$Skeleton(Props) {
  return React.createElement("div", {
              className: "skeleton-base w-20 mt-2 mb-3 rounded h-6"
            });
}

var Skeleton = {
  make: PLP_Scrollable_Tab_Item$PC$Skeleton
};

function PLP_Scrollable_Tab_Item$PC(Props) {
  var selected = Props.selected;
  var item = Props.item;
  var router = Router.useRouter();
  var selectedStyle = selected ? "border-gray-800 text-gray-800 font-bold" : "border-transparent text-gray-400";
  return React.createElement("li", {
              key: item.id,
              id: "category-" + item.id + "",
              onClick: (function (param) {
                  router.replace("/categories/" + item.id + "");
                })
            }, React.createElement("div", {
                  className: Cn.make([
                        selectedStyle,
                        "pt-2 pb-3 border-b-2 w-fit whitespace-nowrap cursor-pointer"
                      ])
                }, item.name));
}

var PC = {
  Skeleton: Skeleton,
  make: PLP_Scrollable_Tab_Item$PC
};

function PLP_Scrollable_Tab_Item$MO$Skeleton(Props) {
  return React.createElement("div", {
              className: "skeleton-base w-20 mt-2 mb-3 rounded h-6"
            });
}

var Skeleton$1 = {
  make: PLP_Scrollable_Tab_Item$MO$Skeleton
};

function PLP_Scrollable_Tab_Item$MO(Props) {
  var selected = Props.selected;
  var item = Props.item;
  var router = Router.useRouter();
  var selectedStyle = selected ? "border-gray-800 text-gray-800 font-bold" : "border-transparent text-gray-400";
  return React.createElement("li", {
              key: item.id,
              id: "category-" + item.id + "",
              onClick: (function (param) {
                  router.replace("/categories/" + item.id + "");
                })
            }, React.createElement("div", {
                  className: Cn.make([
                        selectedStyle,
                        "pt-2 pb-3 border-b-2 w-fit whitespace-nowrap"
                      ])
                }, item.name));
}

var MO = {
  Skeleton: Skeleton$1,
  make: PLP_Scrollable_Tab_Item$MO
};

export {
  Data ,
  PC ,
  MO ,
}
/* react Not a pure module */
