// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Cx from "rescript-classnames/src/Cx.mjs";
import * as React from "react";

function MyInfo_ProfilePicture_Buyer(Props) {
  var content = Props.content;
  var size = Props.size;
  var match;
  switch (size) {
    case /* Small */0 :
        match = [
          "min-w-[54px] h-[54px]",
          "text-2xl"
        ];
        break;
    case /* Large */1 :
        match = [
          "min-w-[72px] h-[72px]",
          "text-2xl"
        ];
        break;
    case /* XLarge */2 :
        match = [
          "min-w-[98px] h-[98px]",
          "text-4xl"
        ];
        break;
    
  }
  return React.createElement("div", {
              className: Cx.cx([
                    "bg-gray-50 rounded-full flex items-center justify-center",
                    match[0]
                  ])
            }, React.createElement("span", {
                  className: Cx.cx([
                        "text-2xl text-enabled-L4 block",
                        match[1]
                      ])
                }, content.charAt(0)));
}

var make = MyInfo_ProfilePicture_Buyer;

export {
  make ,
}
/* react Not a pure module */
