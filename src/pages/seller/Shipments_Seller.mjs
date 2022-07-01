// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Curry from "rescript/lib/es6/curry.js";
import * as React from "react";
import Uniqid from "uniqid";
import * as Js_dict from "rescript/lib/es6/js_dict.js";
import * as Constants from "../../constants/Constants.mjs";
import Head from "next/head";
import * as Belt_Array from "rescript/lib/es6/belt_Array.js";
import * as ErrorPanel from "../../components/common/ErrorPanel.mjs";
import * as Pagination from "../../components/common/Pagination.mjs";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as CustomHooks from "../../utils/CustomHooks.mjs";
import * as Router from "next/router";
import * as Shipment_Seller from "../../components/Shipment_Seller.mjs";
import * as Select_CountPerPage from "../../components/Select_CountPerPage.mjs";
import * as Tooltip_Shipment_Seller from "../../components/Tooltip_Shipment_Seller.mjs";
import * as Summary_Shimpment_Seller from "../../components/Summary_Shimpment_Seller.mjs";
import * as Excel_Download_Request_Button from "../../components/Excel_Download_Request_Button.mjs";

function Shipments_Seller$List(Props) {
  var shipments = Props.shipments;
  return React.createElement(React.Fragment, undefined, React.createElement("div", {
                  className: "w-full overflow-x-scroll"
                }, React.createElement("div", {
                      className: "text-sm lg:min-w-max"
                    }, React.createElement("div", {
                          className: "hidden lg:grid lg:grid-cols-8-seller bg-gray-100 text-gray-500 h-12"
                        }, React.createElement("div", {
                              className: "h-full px-4 flex items-center whitespace-nowrap"
                            }, "날짜", React.createElement(Tooltip_Shipment_Seller.$$Date.make, {})), React.createElement("div", {
                              className: "h-full px-4 flex items-center whitespace-nowrap"
                            }, "판로유형", React.createElement(Tooltip_Shipment_Seller.MarketType.make, {})), React.createElement("div", {
                              className: "h-full px-4 flex items-center whitespace-nowrap"
                            }, "작물·품종"), React.createElement("div", {
                              className: "h-full px-4 flex items-center whitespace-nowrap"
                            }, "거래중량단위·포장규격"), React.createElement("div", {
                              className: "h-full px-4 flex items-center whitespace-nowrap"
                            }, "등급"), React.createElement("div", {
                              className: "h-full px-4 flex items-center whitespace-nowrap"
                            }, "총 수량"), React.createElement("div", {
                              className: "h-full px-4 flex items-center whitespace-nowrap"
                            }, "총 금액"), React.createElement("div", {
                              className: "h-full px-4 flex items-center whitespace-nowrap"
                            }, "상세내역 조회")), React.createElement("ol", {
                          className: "divide-y divide-gray-300 lg:divide-gray-100 lg:list-height-seller lg:overflow-y-scroll"
                        }, Belt_Array.map(shipments.data, (function (shipment) {
                                return React.createElement(Shipment_Seller.make, {
                                            shipment: shipment,
                                            key: Uniqid("shipment")
                                          });
                              }))))), React.createElement("div", {
                  className: "flex justify-center py-5"
                }, React.createElement(Pagination.make, {
                      pageDisplySize: Constants.pageDisplySize,
                      itemPerPage: shipments.limit,
                      total: shipments.count
                    })));
}

var List = {
  make: Shipments_Seller$List
};

function Shipments_Seller$Shipments(Props) {
  var router = Router.useRouter();
  var queryParms = new URLSearchParams(router.query).toString();
  var status = CustomHooks.Shipments.use(queryParms);
  var dict = router.query;
  var bodyOption = Js_dict.fromArray([
        [
          "to",
          Belt_Option.getWithDefault(Js_dict.get(dict, "to"), "")
        ],
        [
          "from",
          Belt_Option.getWithDefault(Js_dict.get(dict, "from"), "")
        ],
        [
          "category-id",
          Belt_Option.getWithDefault(Js_dict.get(dict, "category-id"), "")
        ]
      ]);
  var tmp;
  if (typeof status === "number") {
    tmp = React.createElement("div", undefined, "로딩 중..");
  } else if (status.TAG === /* Loaded */0) {
    var shipments = CustomHooks.Shipments.shipments_decode(status._0);
    if (shipments.TAG === /* Ok */0) {
      var shipments$1 = shipments._0;
      tmp = React.createElement(React.Fragment, undefined, React.createElement("div", {
                className: "md:flex md:justify-between pb-4 text-base"
              }, React.createElement("div", {
                    className: "pt-10 px-5 lg:px-0 flex flex-col lg:flex-row sm:flex-auto sm:justify-between"
                  }, React.createElement("h3", {
                        className: "font-bold"
                      }, "내역", React.createElement("span", {
                            className: "ml-1 text-green-gl font-normal"
                          }, String(shipments$1.count) + "건")), React.createElement("div", {
                        className: "flex flex-col lg:flex-row mt-4 lg:mt-0"
                      }, React.createElement("div", {
                            className: "flex items-center"
                          }, React.createElement(Select_CountPerPage.make, {
                                className: "mr-2"
                              })), React.createElement("div", {
                            className: "flex mt-2 lg:mt-0"
                          }, React.createElement(Excel_Download_Request_Button.make, {
                                userType: /* Seller */0,
                                requestUrl: "/wholesale-market-order/excel",
                                bodyOption: bodyOption
                              }))))), React.createElement(Shipments_Seller$List, {
                shipments: shipments$1
              }));
    } else {
      console.log(shipments._0);
      tmp = null;
    }
  } else {
    tmp = React.createElement(ErrorPanel.make, {
          error: status._0
        });
  }
  return React.createElement(React.Fragment, undefined, React.createElement("div", {
                  className: "sm:px-10 md:px-20"
                }, React.createElement(Summary_Shimpment_Seller.make, {
                      defaults: Summary_Shimpment_Seller.getProps(router.query),
                      key: queryParms
                    }), React.createElement("div", {
                      className: "lg:px-7 mt-4 shadow-gl overflow-x-scroll"
                    }, tmp)));
}

var Shipments = {
  make: Shipments_Seller$Shipments
};

function Shipments_Seller(Props) {
  var user = Curry._1(CustomHooks.User.Seller.use, undefined);
  return React.createElement(React.Fragment, undefined, React.createElement(Head, {
                  children: React.createElement("title", undefined, "출하내역 조회 - 신선하이")
                }), typeof user === "number" ? React.createElement("div", undefined, "인증 확인 중 입니다.") : React.createElement(Shipments_Seller$Shipments, {}));
}

var make = Shipments_Seller;

export {
  List ,
  Shipments ,
  make ,
  
}
/* react Not a pure module */
