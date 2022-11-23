// Generated by ReScript, PLEASE EDIT WITH CARE

import * as React from "react";
import * as IconClose from "./svgs/IconClose.mjs";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as ReactDialog from "@radix-ui/react-dialog";

function displayRawMarket(rm) {
  if (rm === "AUCTION") {
    return "옥션";
  } else if (rm === "GSSHOP") {
    return "지에스숍";
  } else if (rm === "GMARKET") {
    return "지마켓";
  } else if (rm === "SSG") {
    return "SSG";
  } else if (rm === "NAVER") {
    return "네이버";
  } else if (rm === "COUPANG") {
    return "쿠팡";
  } else if (rm === "WEMAKEPRICE") {
    return "위메프";
  } else if (rm === "OTHER") {
    return "기타";
  } else if (rm === "ST11") {
    return "11번가";
  } else if (rm === "TMON") {
    return "티몬";
  } else if (rm === "INTERPARK") {
    return "인터파크";
  } else {
    return "기타";
  }
}

function BulkSale_Producer_RawOnlineMarketInfo_Button_Admin$Names(Props) {
  var market = Props.market;
  return React.createElement(React.Fragment, undefined, React.createElement("h3", {
                  className: "mt-4"
                }, "유통경로"), React.createElement("article", {
                  className: "mt-2"
                }, React.createElement("div", {
                      className: "bg-surface rounded-lg p-3"
                    }, React.createElement("p", {
                          className: "text-text-L2"
                        }, displayRawMarket(market)))));
}

var Names = {
  make: BulkSale_Producer_RawOnlineMarketInfo_Button_Admin$Names
};

function BulkSale_Producer_RawOnlineMarketInfo_Button_Admin$DeliveryCompany(Props) {
  var deliveryCompany = Props.deliveryCompany;
  return React.createElement(React.Fragment, undefined, React.createElement("h3", {
                  className: "mt-4"
                }, "계약된 택배사"), React.createElement("article", {
                  className: "mt-2"
                }, React.createElement("div", {
                      className: "bg-surface rounded-lg p-3"
                    }, React.createElement("p", {
                          className: "text-text-L2"
                        }, deliveryCompany.name))));
}

var DeliveryCompany = {
  make: BulkSale_Producer_RawOnlineMarketInfo_Button_Admin$DeliveryCompany
};

function BulkSale_Producer_RawOnlineMarketInfo_Button_Admin$Urls(Props) {
  var url = Props.url;
  return React.createElement(React.Fragment, undefined, React.createElement("h3", {
                  className: "mt-4"
                }, "판매했던 URL"), React.createElement("article", {
                  className: "mt-2"
                }, React.createElement("div", {
                      className: "bg-surface rounded-lg p-3"
                    }, React.createElement("p", {
                          className: "text-text-L2"
                        }, url === "" ? "(입력한 URL 없음)" : url))));
}

var Urls = {
  make: BulkSale_Producer_RawOnlineMarketInfo_Button_Admin$Urls
};

function BulkSale_Producer_RawOnlineMarketInfo_Button_Admin(Props) {
  var onlineMarkets = Props.onlineMarkets;
  var match = onlineMarkets.bulkSaleRawOnlineSale;
  return React.createElement(ReactDialog.Root, {
              children: null
            }, React.createElement(ReactDialog.Overlay, {
                  className: "dialog-overlay"
                }), match !== undefined ? React.createElement(ReactDialog.Trigger, {
                    children: "입력 내용 보기",
                    className: "underline text-text-L2 text-left"
                  }) : React.createElement("span", undefined, "아니오"), React.createElement(ReactDialog.Content, {
                  children: React.createElement("section", {
                        className: "p-5 text-text-L1"
                      }, React.createElement("article", {
                            className: "flex"
                          }, React.createElement("h2", {
                                className: "text-xl font-bold"
                              }, "온라인판매 정보"), React.createElement(ReactDialog.Close, {
                                children: React.createElement(IconClose.make, {
                                      height: "24",
                                      width: "24",
                                      fill: "#262626"
                                    }),
                                className: "inline-block p-1 focus:outline-none ml-auto"
                              })), Belt_Option.mapWithDefault(onlineMarkets.bulkSaleRawOnlineSale, null, (function (bulkSaleRawOnlineSale) {
                              var deliveryCompany = bulkSaleRawOnlineSale.deliveryCompany;
                              return React.createElement(React.Fragment, undefined, React.createElement(BulkSale_Producer_RawOnlineMarketInfo_Button_Admin$Names, {
                                              market: bulkSaleRawOnlineSale.market
                                            }), deliveryCompany !== undefined ? React.createElement(BulkSale_Producer_RawOnlineMarketInfo_Button_Admin$DeliveryCompany, {
                                                deliveryCompany: deliveryCompany
                                              }) : null, React.createElement(BulkSale_Producer_RawOnlineMarketInfo_Button_Admin$Urls, {
                                              url: bulkSaleRawOnlineSale.url
                                            }));
                            }))),
                  className: "dialog-content overflow-y-auto",
                  onOpenAutoFocus: (function (prim) {
                      prim.preventDefault();
                    })
                }));
}

var make = BulkSale_Producer_RawOnlineMarketInfo_Button_Admin;

export {
  displayRawMarket ,
  Names ,
  DeliveryCompany ,
  Urls ,
  make ,
}
/* react Not a pure module */
