// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Curry from "rescript/lib/es6/curry.js";
import * as React from "react";
import * as Caml_obj from "rescript/lib/es6/caml_obj.js";
import * as IconClose from "./svgs/IconClose.mjs";
import * as Belt_Array from "rescript/lib/es6/belt_Array.js";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as Garter_Array from "@greenlabs/garter/src/Garter_Array.mjs";
import * as ReactDialog from "@radix-ui/react-dialog";
import * as IconCheckOnlineMarketInfo from "./svgs/IconCheckOnlineMarketInfo.mjs";
import * as BulkSale_Producer_OnlineMarketInfo_Button_Util from "./BulkSale_Producer_OnlineMarketInfo_Button_Util.mjs";
import * as BulkSale_Producer_OnlineMarketInfo_Button_Create_Admin from "./BulkSale_Producer_OnlineMarketInfo_Button_Create_Admin.mjs";
import * as BulkSale_Producer_OnlineMarketInfo_Button_Update_Admin from "./BulkSale_Producer_OnlineMarketInfo_Button_Update_Admin.mjs";

function BulkSale_Producer_OnlineMarketInfo_Button_Admin$OnlineMarket(Props) {
  var market = Props.market;
  var selectedMarket = Props.selectedMarket;
  var markets = Props.markets;
  var onClick = Props.onClick;
  var hasInfo = Belt_Array.some(markets.bulkSaleOnlineSalesInfo.edges, (function (info) {
          return Caml_obj.equal(info.node.market, market);
        }));
  var style = selectedMarket !== undefined ? (
      Caml_obj.equal(market, selectedMarket) ? "relative font-bold text-primary bg-primary-light border border-primary py-2 flex justify-center items-center rounded-lg" : (
          hasInfo ? "relative font-bold border border-bg-pressed-L2 py-2 flex justify-center items-center rounded-lg text-text-L1" : "relative border border-bg-pressed-L2 py-2 flex justify-center items-center rounded-lg text-text-L1"
        )
    ) : (
      hasInfo ? "relative font-bold border border-bg-pressed-L2 py-2 flex justify-center items-center rounded-lg text-text-L1" : "relative border border-bg-pressed-L2 py-2 flex justify-center items-center rounded-lg text-text-L1"
    );
  var svgFill = selectedMarket !== undefined ? (
      hasInfo ? (
          Caml_obj.equal(market, selectedMarket) ? "#12b564" : (
              hasInfo ? "#999999" : ""
            )
        ) : ""
    ) : (
      hasInfo ? "#999999" : ""
    );
  return React.createElement("li", {
              className: style,
              onClick: (function (param) {
                  Curry._1(onClick, market);
                })
            }, BulkSale_Producer_OnlineMarketInfo_Button_Util.displayMarket(market), React.createElement(IconCheckOnlineMarketInfo.make, {
                  height: "20",
                  width: "20",
                  fill: svgFill,
                  className: "absolute right-3"
                }));
}

var OnlineMarket = {
  make: BulkSale_Producer_OnlineMarketInfo_Button_Admin$OnlineMarket
};

function BulkSale_Producer_OnlineMarketInfo_Button_Admin$OnlineMarkets(Props) {
  var selectedMarket = Props.selectedMarket;
  var markets = Props.markets;
  var onClick = Props.onClick;
  return React.createElement("ul", {
              className: "px-5 grid grid-cols-4 gap-2"
            }, Belt_Array.map([
                  "NAVER",
                  "COUPANG",
                  "GMARKET",
                  "ST11",
                  "WEMAKEPRICE",
                  "TMON",
                  "AUCTION",
                  "SSG",
                  "INTERPARK",
                  "GSSHOP",
                  "OTHER"
                ], (function (market) {
                    return React.createElement(BulkSale_Producer_OnlineMarketInfo_Button_Admin$OnlineMarket, {
                                market: market,
                                selectedMarket: selectedMarket,
                                markets: markets,
                                onClick: onClick,
                                key: BulkSale_Producer_OnlineMarketInfo_Button_Util.stringifyMarket(market)
                              });
                  })));
}

var OnlineMarkets = {
  make: BulkSale_Producer_OnlineMarketInfo_Button_Admin$OnlineMarkets
};

function BulkSale_Producer_OnlineMarketInfo_Button_Admin$Form(Props) {
  var markets = Props.markets;
  var applicationId = Props.applicationId;
  var connectionId = markets.bulkSaleOnlineSalesInfo.__id;
  var match = React.useState(function () {
        var markets$1 = Garter_Array.first(markets.bulkSaleOnlineSalesInfo.edges);
        if (markets$1 !== undefined) {
          return markets$1.node.market;
        } else {
          return "NAVER";
        }
      });
  var setSelectedMarket = match[1];
  var selectedMarket = match[0];
  var market = Belt_Option.flatMap(selectedMarket, (function (selectedMarket$p) {
          return Garter_Array.first(Belt_Array.keep(markets.bulkSaleOnlineSalesInfo.edges, (function (m) {
                            return Caml_obj.equal(m.node.market, selectedMarket$p);
                          })));
        }));
  return React.createElement(React.Fragment, undefined, React.createElement(BulkSale_Producer_OnlineMarketInfo_Button_Admin$OnlineMarkets, {
                  selectedMarket: selectedMarket,
                  markets: markets,
                  onClick: (function (param) {
                      return setSelectedMarket(function (param$1) {
                                  return Caml_option.some(param);
                                });
                    })
                }), market !== undefined ? React.createElement(BulkSale_Producer_OnlineMarketInfo_Button_Update_Admin.Form.make, {
                    connectionId: connectionId,
                    selectedMarket: selectedMarket,
                    market: market
                  }) : React.createElement(BulkSale_Producer_OnlineMarketInfo_Button_Create_Admin.Form.make, {
                    connectionId: connectionId,
                    selectedMarket: selectedMarket,
                    applicationId: applicationId
                  }));
}

var Form = {
  make: BulkSale_Producer_OnlineMarketInfo_Button_Admin$Form
};

function BulkSale_Producer_OnlineMarketInfo_Button_Admin(Props) {
  var onlineMarkets = Props.onlineMarkets;
  var applicationId = Props.applicationId;
  return React.createElement(ReactDialog.Root, {
              children: null
            }, React.createElement(ReactDialog.Overlay, {
                  className: "dialog-overlay"
                }), React.createElement(ReactDialog.Trigger, {
                  children: React.createElement("span", {
                        className: "inline-block bg-primary-light text-primary py-1 px-2 rounded-lg mt-2"
                      }, "유통 정보 입력"),
                  className: "text-left"
                }), React.createElement(ReactDialog.Content, {
                  children: null,
                  className: "dialog-content-detail overflow-y-auto",
                  onOpenAutoFocus: (function (prim) {
                      prim.preventDefault();
                    })
                }, React.createElement("section", {
                      className: "p-5 text-text-L1"
                    }, React.createElement("article", {
                          className: "flex"
                        }, React.createElement("h2", {
                              className: "text-xl font-bold"
                            }, "온라인 유통 정보"), React.createElement(ReactDialog.Close, {
                              children: React.createElement(IconClose.make, {
                                    height: "24",
                                    width: "24",
                                    fill: "#262626"
                                  }),
                              className: "inline-block p-1 focus:outline-none ml-auto"
                            }))), React.createElement("section", undefined, React.createElement(React.Suspense, {
                          children: React.createElement(BulkSale_Producer_OnlineMarketInfo_Button_Admin$Form, {
                                markets: onlineMarkets,
                                applicationId: applicationId
                              }),
                          fallback: React.createElement("div", undefined, "로딩 중")
                        }))));
}

var Util;

var FormCreate;

var FormUpdate;

var make = BulkSale_Producer_OnlineMarketInfo_Button_Admin;

export {
  Util ,
  FormCreate ,
  FormUpdate ,
  OnlineMarket ,
  OnlineMarkets ,
  Form ,
  make ,
}
/* react Not a pure module */
