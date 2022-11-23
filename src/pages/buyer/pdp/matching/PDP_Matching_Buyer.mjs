// Generated by ReScript, PLEASE EDIT WITH CARE

import * as React from "react";
import * as ReactUtil from "../../../../utils/ReactUtil.mjs";
import * as Js_promise from "rescript/lib/es6/js_promise.js";
import Dynamic from "next/dynamic";

var dynamicMo = Dynamic((function (param) {
        return Js_promise.then_((function (mod) {
                      return mod.make;
                    }), import("src/pages/buyer/pdp/matching/PDP_Matching_Buyer_MO.mjs"));
      }), {
      ssr: true
    });

function PDP_Matching_Buyer(Props) {
  var deviceType = Props.deviceType;
  var query = Props.query;
  if (deviceType !== 0) {
    return React.createElement(ReactUtil.Component.make, {
                as_: dynamicMo,
                props: {
                  query: query
                }
              });
  } else {
    return null;
  }
}

var make = PDP_Matching_Buyer;

export {
  dynamicMo ,
  make ,
}
/* dynamicMo Not a pure module */
