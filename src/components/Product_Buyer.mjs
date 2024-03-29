// Generated by ReScript, PLEASE EDIT WITH CARE

import * as React from "react";
import * as Locale from "../utils/Locale.mjs";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as Product_Badge from "./Product_Badge.mjs";
import * as ReactSeparator from "@radix-ui/react-separator";

function formatDate(d) {
  return Locale.DateTime.formatFromUTC(new Date(d), "yyyy/MM/dd HH:mm");
}

function Product_Buyer$Item$AdhocText(Props) {
  var salesStatus = Props.salesStatus;
  var adhocStockIsLimited = Props.adhocStockIsLimited;
  var adhocStockNumRemaining = Props.adhocStockNumRemaining;
  var match = salesStatus === /* SOLDOUT */1;
  var adhocRemaningText = match ? "품절" : (
      adhocStockIsLimited && adhocStockNumRemaining !== undefined ? "" + Locale.Float.show(undefined, adhocStockNumRemaining, 0) + "개 남음" : "수량 제한 없음"
    );
  return React.createElement(React.Fragment, undefined, adhocRemaningText);
}

var AdhocText = {
  make: Product_Buyer$Item$AdhocText
};

function Product_Buyer$Item$Table(Props) {
  var product = Props.product;
  return React.createElement(React.Fragment, undefined, React.createElement("li", {
                  className: "hidden lg:grid lg:grid-cols-8-buyer-product text-gray-700"
                }, React.createElement("div", {
                      className: "h-full flex flex-col px-4 py-2"
                    }, React.createElement(Product_Badge.make, {
                          status: product.salesStatus
                        })), React.createElement("div", {
                      className: "h-full flex flex-col px-4 py-2"
                    }, React.createElement("span", {
                          className: "block"
                        }, String(product.productId)), React.createElement("span", {
                          className: "block text-gray-500"
                        }, product.productSku)), React.createElement("div", {
                      className: "h-full flex flex-col px-4 py-2"
                    }, React.createElement("span", {
                          className: "block"
                        }, product.productName), React.createElement("span", {
                          className: "block text-gray-500"
                        }, Belt_Option.getWithDefault(product.productOptionName, ""))), React.createElement("div", {
                      className: "h-full flex flex-col px-4 py-2"
                    }, React.createElement("span", {
                          className: "whitespace-nowrap"
                        }, "" + Locale.Float.show(undefined, product.price, 0) + "원")), React.createElement("div", {
                      className: "h-full flex flex-col px-4 py-2"
                    }, React.createElement("span", {
                          className: "whitespace-nowrap"
                        }, React.createElement(Product_Buyer$Item$AdhocText, {
                              salesStatus: product.salesStatus,
                              adhocStockIsLimited: product.adhocStockIsLimited,
                              adhocStockNumRemaining: product.adhocStockNumRemaining
                            }))), React.createElement("div", {
                      className: "h-full flex flex-col px-4 py-2"
                    }, React.createElement("span", {
                          className: "block"
                        }, Belt_Option.getWithDefault(product.cutOffTime, ""))), React.createElement("div", {
                      className: "h-full flex flex-col px-4 py-2"
                    }, React.createElement("span", {
                          className: "block"
                        }, Belt_Option.getWithDefault(product.memo, "")))));
}

var Table = {
  make: Product_Buyer$Item$Table
};

function Product_Buyer$Item$Card(Props) {
  var product = Props.product;
  return React.createElement(React.Fragment, undefined, React.createElement("li", {
                  className: "py-7 px-5 lg:mb-4 lg:hidden text-black-gl"
                }, React.createElement("section", {
                      className: "flex justify-between items-start"
                    }, React.createElement("div", {
                          className: "flex"
                        }, React.createElement("span", {
                              className: "w-20 text-gray-gl"
                            }, "상품"), React.createElement("div", {
                              className: "ml-2"
                            }, React.createElement("span", {
                                  className: "block"
                                }, String(product.productId)), React.createElement("span", {
                                  className: "block mt-1"
                                }, product.productName))), React.createElement(Product_Badge.make, {
                          status: product.salesStatus
                        })), React.createElement("section", {
                      className: "py-3"
                    }, React.createElement("div", {
                          className: "flex"
                        }, React.createElement("span", {
                              className: "w-20 text-gray-gl"
                            }, "품목"), React.createElement("div", {
                              className: "ml-2"
                            }, React.createElement("span", {
                                  className: "block"
                                }, product.productSku), React.createElement("span", {
                                  className: "block mt-1"
                                }, Belt_Option.getWithDefault(product.productOptionName, "품목명 없음")))), React.createElement("div", {
                          className: "flex mt-3"
                        }, React.createElement("span", {
                              className: "w-20 text-gray-gl"
                            }, "현재 판매가"), React.createElement("span", {
                              className: "ml-2"
                            }, "" + Locale.Float.show(undefined, product.price, 0) + "원")), React.createElement("div", {
                          className: "flex mt-3"
                        }, React.createElement("span", {
                              className: "w-20 text-gray-gl"
                            }, "구매 가능 수량"), React.createElement("span", {
                              className: "ml-2"
                            }, React.createElement(Product_Buyer$Item$AdhocText, {
                                  salesStatus: product.salesStatus,
                                  adhocStockIsLimited: product.adhocStockIsLimited,
                                  adhocStockNumRemaining: product.adhocStockNumRemaining
                                }))), React.createElement(ReactSeparator.Root, {
                          className: "separator my-5"
                        }), React.createElement("div", {
                          className: "flex mt-3"
                        }, React.createElement("span", {
                              className: "w-20 text-gray-gl"
                            }, "출고기준시간"), React.createElement("span", {
                              className: "ml-2"
                            }, Belt_Option.getWithDefault(product.cutOffTime, ""))), React.createElement("div", {
                          className: "flex mt-3"
                        }, React.createElement("span", {
                              className: "w-20 text-gray-gl"
                            }, "메모"), React.createElement("span", {
                              className: "ml-2"
                            }, Belt_Option.getWithDefault(product.memo, ""))))));
}

var Card = {
  make: Product_Buyer$Item$Card
};

var Item = {
  AdhocText: AdhocText,
  Table: Table,
  Card: Card
};

function Product_Buyer(Props) {
  var product = Props.product;
  return React.createElement(React.Fragment, undefined, React.createElement(Product_Buyer$Item$Table, {
                  product: product
                }), React.createElement(Product_Buyer$Item$Card, {
                  product: product
                }));
}

var make = Product_Buyer;

export {
  formatDate ,
  Item ,
  make ,
}
/* react Not a pure module */
