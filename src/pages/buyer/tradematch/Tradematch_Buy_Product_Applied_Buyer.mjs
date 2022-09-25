// Generated by ReScript, PLEASE EDIT WITH CARE

import * as React from "react";
import * as Js_dict from "rescript/lib/es6/js_dict.js";
import * as Belt_Int from "rescript/lib/es6/belt_Int.js";
import * as Router from "next/router";
import * as Authorization from "../../../utils/Authorization.mjs";
import * as Tradematch_Header_Buyer from "./Tradematch_Header_Buyer.mjs";
import * as Tradematch_NotFound_Buyer from "./Tradematch_NotFound_Buyer.mjs";
import * as Tradematch_Skeleton_Buyer from "./Tradematch_Skeleton_Buyer.mjs";
import * as Tradematch_Buy_Aqua_Product_Applied_Buyer from "./Tradematch_Buy_Aqua_Product_Applied_Buyer.mjs";
import * as Tradematch_Buy_Farm_Product_Applied_Buyer from "./Tradematch_Buy_Farm_Product_Applied_Buyer.mjs";

function Tradematch_Buy_Product_Applied_Buyer(props) {
  var router = Router.useRouter();
  var productType = Js_dict.get(router.query, "type");
  console.log(router);
  var match = Belt_Int.fromString(props.pid);
  var tmp;
  var exit = 0;
  if (match !== undefined && productType !== undefined) {
    if (productType === "farm") {
      tmp = React.createElement(Tradematch_Buy_Farm_Product_Applied_Buyer.make, {});
    } else if (productType === "aqua") {
      tmp = React.createElement(Tradematch_Buy_Aqua_Product_Applied_Buyer.make, {});
    } else {
      exit = 1;
    }
  } else {
    exit = 1;
  }
  if (exit === 1) {
    tmp = React.createElement(React.Fragment, undefined, React.createElement(Tradematch_Header_Buyer.make, {}), React.createElement(Tradematch_Skeleton_Buyer.make, {}), React.createElement(Tradematch_NotFound_Buyer.make, {}));
  }
  return React.createElement(Authorization.Buyer.make, {
              children: React.createElement("div", {
                    className: "bg-gray-100"
                  }, React.createElement("div", {
                        className: "relative container bg-white max-w-3xl mx-auto min-h-screen"
                      }, React.createElement("div", {
                            className: "w-full fixed top-0 left-0 z-10"
                          }, React.createElement("header", {
                                className: "w-full max-w-3xl mx-auto h-14 bg-white"
                              }, React.createElement("div", {
                                    className: "px-5 py-4 flex justify-between"
                                  }))), React.createElement("div", {
                            className: "w-full h-14"
                          }), tmp)),
              title: "신청 완료"
            });
}

var make = Tradematch_Buy_Product_Applied_Buyer;

export {
  make ,
}
/* react Not a pure module */
