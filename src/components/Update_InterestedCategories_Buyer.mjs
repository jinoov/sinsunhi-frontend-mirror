// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Curry from "rescript/lib/es6/curry.js";
import * as React from "react";
import * as IconClose from "./svgs/IconClose.mjs";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as ReactDialog from "@radix-ui/react-dialog";
import * as BuyerInformation_Buyer from "./BuyerInformation_Buyer.mjs";

function Update_InterestedCategories_Buyer(Props) {
  var isOpen = Props.isOpen;
  var onClose = Props.onClose;
  var queryData = BuyerInformation_Buyer.Query.use(undefined, undefined, undefined, undefined, undefined);
  return React.createElement(ReactDialog.Root, {
              children: null,
              open: isOpen
            }, React.createElement(ReactDialog.Overlay, {
                  className: "dialog-overlay"
                }), React.createElement(ReactDialog.Content, {
                  children: React.createElement("section", {
                        className: "text-text-L1"
                      }, React.createElement("article", {
                            className: "flex"
                          }, React.createElement(ReactDialog.Close, {
                                onClick: (function (param) {
                                    Curry._1(onClose, undefined);
                                  }),
                                children: React.createElement(IconClose.make, {
                                      height: "24",
                                      width: "24",
                                      fill: "#262626"
                                    }),
                                className: "p-2 m-3 mb-0 focus:outline-none ml-auto"
                              })), React.createElement(BuyerInformation_Buyer.InterestedCategories.make, {
                            selected: Belt_Option.flatMap(queryData.viewer, (function (v) {
                                    return v.interestedItemCategories;
                                  })),
                            close: onClose
                          })),
                  className: "dialog-content-full overflow-y-auto sm:rounded-2xl",
                  onOpenAutoFocus: (function (prim) {
                      prim.preventDefault();
                    })
                }));
}

var make = Update_InterestedCategories_Buyer;

export {
  make ,
}
/* react Not a pure module */
