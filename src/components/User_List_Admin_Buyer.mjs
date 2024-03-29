// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Curry from "rescript/lib/es6/curry.js";
import * as React from "react";
import * as Constants from "../constants/Constants.mjs";
import * as ErrorPanel from "./common/ErrorPanel.mjs";
import * as Pagination from "./common/Pagination.mjs";
import * as CustomHooks from "../utils/CustomHooks.mjs";
import * as Garter_Array from "@greenlabs/garter/src/Garter_Array.mjs";
import * as User_Admin_Buyer from "./User_Admin_Buyer.mjs";

function User_List_Admin_Buyer(Props) {
  var status = Props.status;
  if (typeof status === "number") {
    if (status === /* Waiting */0) {
      return null;
    } else {
      return React.createElement("div", undefined, "로딩 중..");
    }
  }
  if (status.TAG !== /* Loaded */0) {
    return React.createElement(ErrorPanel.make, {
                error: status._0
              });
  }
  var users$p = Curry._1(CustomHooks.QueryUser.Buyer.users_decode, status._0);
  var tmp;
  if (users$p.TAG === /* Ok */0) {
    tmp = Garter_Array.map(users$p._0.data, (function (user) {
            return React.createElement(User_Admin_Buyer.make, {
                        user: user,
                        key: String(user.id)
                      });
          }));
  } else {
    console.log(users$p._0);
    tmp = null;
  }
  var tmp$1;
  if (typeof status === "number" || status.TAG !== /* Loaded */0) {
    tmp$1 = null;
  } else {
    var users$p$1 = Curry._1(CustomHooks.QueryUser.Buyer.users_decode, status._0);
    if (users$p$1.TAG === /* Ok */0) {
      var users$p$2 = users$p$1._0;
      tmp$1 = React.createElement("div", {
            className: "flex justify-center py-10"
          }, React.createElement(Pagination.make, {
                pageDisplySize: Constants.pageDisplySize,
                itemPerPage: users$p$2.limit,
                total: users$p$2.count
              }));
    } else {
      tmp$1 = null;
    }
  }
  return React.createElement(React.Fragment, undefined, React.createElement("div", {
                  className: "w-full min-w-max text-sm divide-y divide-gray-100 pr-7"
                }, React.createElement("div", {
                      className: "grid grid-cols-11-admin-users-buyer bg-gray-100 text-gray-500 h-12"
                    }, React.createElement("div", {
                          className: "flex items-center px-4 whitespace-nowrap"
                        }, "바이어명"), React.createElement("div", {
                          className: "flex items-center px-4 whitespace-nowrap"
                        }, "이메일·연락처"), React.createElement("div", {
                          className: "flex items-center px-4 whitespace-nowrap"
                        }, "상태"), React.createElement("div", {
                          className: "flex items-center justify-end px-4 whitespace-nowrap"
                        }, "주문가능잔액"), React.createElement("div", {
                          className: "flex items-center justify-center px-4 whitespace-nowrap"
                        }, "거래내역"), React.createElement("div", {
                          className: "flex items-center px-4 whitespace-nowrap"
                        }, "사업장주소·사업자번호"), React.createElement("div", {
                          className: "flex items-center px-4 whitespace-nowrap"
                        }, "업종"), React.createElement("div", {
                          className: "flex items-center justify-center px-4 whitespace-nowrap"
                        }, "연매출"), React.createElement("div", {
                          className: "flex items-center justify-center px-4 whitespace-nowrap"
                        }, "관심품목"), React.createElement("div", {
                          className: "flex items-center px-4 whitespace-nowrap"
                        }, "담당자"), React.createElement("div", {
                          className: "flex items-center px-4 whitespace-nowrap"
                        }, "판매URL")), React.createElement("ol", {
                      className: "divide-y"
                    }, tmp)), tmp$1);
}

var make = User_List_Admin_Buyer;

export {
  make ,
}
/* react Not a pure module */
