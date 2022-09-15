// Generated by ReScript, PLEASE EDIT WITH CARE

import * as React from "react";
import * as Locale from "../../../../utils/Locale.mjs";
import * as IconArrow from "../../../../components/svgs/IconArrow.mjs";
import Link from "next/link";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as ReactRelay from "react-relay";
import * as Js_null_undefined from "rescript/lib/es6/js_null_undefined.js";
import * as RescriptRelay_Internal from "rescript-relay/src/RescriptRelay_Internal.mjs";
import * as MyInfoCashRemainBuyer_Fragment_graphql from "../../../../__generated__/MyInfoCashRemainBuyer_Fragment_graphql.mjs";

function use(fRef) {
  var data = ReactRelay.useFragment(MyInfoCashRemainBuyer_Fragment_graphql.node, fRef);
  return RescriptRelay_Internal.internal_useConvertedValue(MyInfoCashRemainBuyer_Fragment_graphql.Internal.convertFragment, data);
}

function useOpt(opt_fRef) {
  var fr = opt_fRef !== undefined ? Caml_option.some(Caml_option.valFromOption(opt_fRef)) : undefined;
  var nullableFragmentData = ReactRelay.useFragment(MyInfoCashRemainBuyer_Fragment_graphql.node, fr !== undefined ? Js_null_undefined.fromOption(Caml_option.some(Caml_option.valFromOption(fr))) : null);
  var data = (nullableFragmentData == null) ? undefined : Caml_option.some(nullableFragmentData);
  return RescriptRelay_Internal.internal_useConvertedValue((function (rawFragment) {
                if (rawFragment !== undefined) {
                  return MyInfoCashRemainBuyer_Fragment_graphql.Internal.convertFragment(rawFragment);
                }
                
              }), data);
}

var Fragment = {
  Types: undefined,
  Operation: undefined,
  use: use,
  useOpt: useOpt
};

function MyInfo_Cash_Remain_Buyer$PC(Props) {
  var query = Props.query;
  var match = use(query);
  return React.createElement("div", {
              className: "flex items-center justify-between p-7"
            }, React.createElement("span", {
                  className: "font-bold text-2xl"
                }, "신선캐시"), React.createElement("div", {
                  className: "flex items-center justify-between"
                }, React.createElement("span", {
                      className: "text-sm text-gray-600 mr-5"
                    }, "신선캐시 잔액"), React.createElement(Link, {
                      href: "/buyer/transactions",
                      children: React.createElement("a", {
                            className: "contents"
                          }, React.createElement("span", {
                                className: "font-bold mr-2"
                              }, "" + Locale.Float.show(undefined, match.sinsunCashDeposit, 0) + " 원"), React.createElement(IconArrow.make, {
                                height: "13",
                                width: "13",
                                fill: "#727272"
                              }))
                    })));
}

var PC = {
  make: MyInfo_Cash_Remain_Buyer$PC
};

function MyInfo_Cash_Remain_Buyer$Mobile(Props) {
  var query = Props.query;
  var match = use(query);
  return React.createElement("div", {
              className: "p-4 flex items-center justify-between bg-surface rounded"
            }, React.createElement("div", {
                  className: "text-gray-600"
                }, "신선캐시 잔액"), React.createElement(Link, {
                  href: "/buyer/transactions",
                  children: React.createElement("a", undefined, React.createElement("div", {
                            className: "flex items-center"
                          }, React.createElement("span", {
                                className: "font-bold mr-2"
                              }, "" + Locale.Float.show(undefined, match.sinsunCashDeposit, 0) + " 원"), React.createElement(IconArrow.make, {
                                height: "13",
                                width: "13",
                                fill: "#727272"
                              })))
                }));
}

var Mobile = {
  make: MyInfo_Cash_Remain_Buyer$Mobile
};

export {
  Fragment ,
  PC ,
  Mobile ,
}
/* react Not a pure module */
