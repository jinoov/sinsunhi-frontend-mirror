// Generated by ReScript, PLEASE EDIT WITH CARE

import * as React from "react";
import * as IconClose from "./svgs/IconClose.mjs";
import * as Belt_Array from "rescript/lib/es6/belt_Array.js";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as ReactRelay from "react-relay";
import * as Js_null_undefined from "rescript/lib/es6/js_null_undefined.js";
import * as ReactDialog from "@radix-ui/react-dialog";
import * as RescriptRelay_Internal from "rescript-relay/src/RescriptRelay_Internal.mjs";
import * as BulkSaleMarketSalesInfoButtonAdminFragment_graphql from "../__generated__/BulkSaleMarketSalesInfoButtonAdminFragment_graphql.mjs";

function use(fRef) {
  var data = ReactRelay.useFragment(BulkSaleMarketSalesInfoButtonAdminFragment_graphql.node, fRef);
  return RescriptRelay_Internal.internal_useConvertedValue(BulkSaleMarketSalesInfoButtonAdminFragment_graphql.Internal.convertFragment, data);
}

function useOpt(opt_fRef) {
  var fr = opt_fRef !== undefined ? Caml_option.some(Caml_option.valFromOption(opt_fRef)) : undefined;
  var nullableFragmentData = ReactRelay.useFragment(BulkSaleMarketSalesInfoButtonAdminFragment_graphql.node, fr !== undefined ? Js_null_undefined.fromOption(Caml_option.some(Caml_option.valFromOption(fr))) : null);
  var data = (nullableFragmentData == null) ? undefined : Caml_option.some(nullableFragmentData);
  return RescriptRelay_Internal.internal_useConvertedValue((function (rawFragment) {
                if (rawFragment !== undefined) {
                  return BulkSaleMarketSalesInfoButtonAdminFragment_graphql.Internal.convertFragment(rawFragment);
                }
                
              }), data);
}

var Fragment = {
  Types: undefined,
  Operation: undefined,
  use: use,
  useOpt: useOpt
};

function BulkSale_MarketSalesInfo_Button_Admin(Props) {
  var query = Props.query;
  var detail = use(query);
  var edges = Belt_Option.mapWithDefault(detail.bulkSaleProducerDetail, [], (function (d) {
          return d.experiencedMarkets.edges;
        }));
  return React.createElement(ReactDialog.Root, {
              children: null
            }, React.createElement(ReactDialog.Overlay, {
                  className: "dialog-overlay"
                }), edges.length !== 0 ? React.createElement(ReactDialog.Trigger, {
                    children: "입력 내용 보기",
                    className: "underline text-text-L2 text-left"
                  }) : React.createElement("span", undefined, "없음"), React.createElement(ReactDialog.Content, {
                  children: React.createElement("section", {
                        className: "p-5 text-text-L1"
                      }, React.createElement("article", {
                            className: "flex"
                          }, React.createElement("h2", {
                                className: "text-xl font-bold"
                              }, "출하 시장 정보"), React.createElement(ReactDialog.Close, {
                                children: React.createElement(IconClose.make, {
                                      height: "24",
                                      width: "24",
                                      fill: "#262626"
                                    }),
                                className: "inline-block p-1 focus:outline-none ml-auto"
                              })), React.createElement("h3", {
                            className: "mt-4"
                          }, "시장명"), React.createElement("article", {
                            className: "mt-2"
                          }, React.createElement("div", {
                                className: "bg-surface rounded-lg p-3"
                              }, Belt_Array.map(edges, (function (edge) {
                                      return React.createElement("p", {
                                                  key: edge.cursor,
                                                  className: "text-text-L2"
                                                }, edge.node.name);
                                    }))))),
                  className: "dialog-content overflow-y-auto",
                  onOpenAutoFocus: (function (prim) {
                      prim.preventDefault();
                    })
                }));
}

var make = BulkSale_MarketSalesInfo_Button_Admin;

export {
  Fragment ,
  make ,
}
/* react Not a pure module */
