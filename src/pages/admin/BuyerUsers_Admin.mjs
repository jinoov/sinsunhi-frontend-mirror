// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Curry from "rescript/lib/es6/curry.js";
import * as React from "react";
import * as CustomHooks from "../../utils/CustomHooks.mjs";
import * as Router from "next/router";
import * as Authorization from "../../utils/Authorization.mjs";
import * as Search_Buyer_Admin from "../../components/Search_Buyer_Admin.mjs";
import * as Select_CountPerPage from "../../components/Select_CountPerPage.mjs";
import * as User_List_Admin_Buyer from "../../components/User_List_Admin_Buyer.mjs";
import * as Excel_Download_Request_Button from "../../components/Excel_Download_Request_Button.mjs";

function BuyerUsers_Admin$Users(Props) {
  var router = Router.useRouter();
  var rq = router.query;
  var status = Curry._1(CustomHooks.QueryUser.Buyer.use, (rq["role"] = "buyer", new URLSearchParams(rq).toString()));
  return React.createElement("div", {
              className: "py-8 px-4 max-w-gnb-panel overflow-auto bg-div-shape-L1 min-h-screen"
            }, React.createElement("header", {
                  className: "flex items-baseline pb-0"
                }, React.createElement("h1", {
                      className: "font-bold text-xl"
                    }, "바이어 사용자 조회")), React.createElement(Search_Buyer_Admin.make, {}), React.createElement("div", {
                  className: "p-7 mt-4 shadow-gl overflow-auto overflow-x-scroll bg-white rounded"
                }, React.createElement("div", {
                      className: "md:flex md:justify-between pb-4"
                    }, React.createElement("div", {
                          className: "flex flex-auto justify-between"
                        }, React.createElement("h3", {
                              className: "font-bold text-xl"
                            }, "내역"), React.createElement("div", {
                              className: "flex items-center"
                            }, React.createElement(Select_CountPerPage.make, {
                                  className: "mx-2"
                                }), React.createElement(Excel_Download_Request_Button.make, {
                                  userType: /* Admin */2,
                                  requestUrl: "/user/request-excel/buyer"
                                })))), React.createElement(User_List_Admin_Buyer.make, {
                      status: status
                    })));
}

var Users = {
  make: BuyerUsers_Admin$Users
};

function BuyerUsers_Admin(Props) {
  return React.createElement(Authorization.Admin.make, {
              children: React.createElement(BuyerUsers_Admin$Users, {}),
              title: "관리자 바이어 사용자 조회"
            });
}

var List;

var make = BuyerUsers_Admin;

export {
  List ,
  Users ,
  make ,
}
/* react Not a pure module */
