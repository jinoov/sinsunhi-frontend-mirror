// Generated by ReScript, PLEASE EDIT WITH CARE

import * as React from "react";
import * as Converter from "../utils/Converter.mjs";

function Badge_User_Transaction_Admin(Props) {
  var status = Props.status;
  var displayStyle = status ? "max-w-min bg-enabled-L5 py-0.5 px-2 text-enabled-L1 rounded mr-2 whitespace-nowrap" : "max-w-min bg-primary-light py-0.5 px-2 text-primary rounded mr-2 whitespace-nowrap";
  var displayText = Converter.displayUserBuyerStatus(status);
  return React.createElement("span", {
              className: displayStyle
            }, displayText);
}

var make = Badge_User_Transaction_Admin;

export {
  make ,
  
}
/* react Not a pure module */
