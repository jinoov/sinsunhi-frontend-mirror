// Generated by ReScript, PLEASE EDIT WITH CARE

import * as React from "react";
import * as Helper from "../utils/Helper.mjs";
import * as Locale from "../utils/Locale.mjs";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as User_Update_Button_Admin_Farmer from "./User_Update_Button_Admin_Farmer.mjs";
import * as User_MD_Update_Button_Admin_Farmer from "./User_MD_Update_Button_Admin_Farmer.mjs";

function formatDate(d) {
  return Locale.DateTime.formatFromUTC(new Date(d), "yyyy/MM/dd HH:mm:ss");
}

function User_Admin_Farmer$Item$Table(Props) {
  var user = Props.user;
  return React.createElement("li", {
              className: "grid grid-cols-13-gl-admin-seller text-gray-700"
            }, React.createElement("div", {
                  className: "px-4 py-2"
                }, Belt_Option.getWithDefault(user.producerCode, "")), React.createElement("div", {
                  className: "px-4 py-2"
                }, user.name), React.createElement("div", {
                  className: "px-4 py-2"
                }, Belt_Option.getWithDefault(Belt_Option.flatMap(Helper.PhoneNumber.parse(user.phone), Helper.PhoneNumber.format), user.phone)), React.createElement("div", {
                  className: "px-4 py-2"
                }, Belt_Option.getWithDefault(user.email, "")), React.createElement("div", {
                  className: "px-4 py-2"
                }, Belt_Option.getWithDefault(user.address, "")), React.createElement("div", {
                  className: "px-4 py-2"
                }, Belt_Option.getWithDefault(user.producerTypeDescription, "")), React.createElement("div", {
                  className: "px-4 py-2"
                }, Belt_Option.getWithDefault(user.businessRegistrationNumber, "")), React.createElement("div", {
                  className: "px-4 py-2"
                }, Belt_Option.getWithDefault(user.rep, "")), React.createElement("div", {
                  className: "px-4 py-2 text-left"
                }, React.createElement("div", undefined, Belt_Option.getWithDefault(user.manager, "")), React.createElement("div", undefined, Belt_Option.getWithDefault(user.managerPhone, ""))), React.createElement("div", {
                  className: "px-4 py-2 text-left"
                }, React.createElement("p", {
                      className: "line-clamp-2"
                    }, Belt_Option.getWithDefault(user.etc, "-"))), React.createElement("div", {
                  className: "py-2 flex justify-center"
                }, React.createElement(User_Update_Button_Admin_Farmer.make, {
                      user: user
                    })), React.createElement("div", {
                  className: "px-4 py-2"
                }, Belt_Option.getWithDefault(user.mdName, "")), React.createElement("div", {
                  className: "py-2 flex justify-center"
                }, React.createElement(User_MD_Update_Button_Admin_Farmer.make, {
                      user: user
                    })));
}

var Table = {
  make: User_Admin_Farmer$Item$Table
};

var Item = {
  Table: Table
};

function User_Admin_Farmer(Props) {
  var user = Props.user;
  return React.createElement(User_Admin_Farmer$Item$Table, {
              user: user
            });
}

var make = User_Admin_Farmer;

export {
  formatDate ,
  Item ,
  make ,
  
}
/* react Not a pure module */