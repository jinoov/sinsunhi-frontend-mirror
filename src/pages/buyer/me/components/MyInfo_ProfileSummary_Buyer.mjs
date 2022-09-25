// Generated by ReScript, PLEASE EDIT WITH CARE

import * as React from "react";
import * as IconArrow from "../../../../components/svgs/IconArrow.mjs";
import Link from "next/link";
import * as Belt_Array from "rescript/lib/es6/belt_Array.js";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as ReactRelay from "react-relay";
import * as Js_null_undefined from "rescript/lib/es6/js_null_undefined.js";
import * as RescriptRelay_Internal from "rescript-relay/src/RescriptRelay_Internal.mjs";
import * as MyInfo_ProfileTitle_Buyer from "./MyInfo_ProfileTitle_Buyer.mjs";
import * as MyInfo_ProfilePicture_Buyer from "./MyInfo_ProfilePicture_Buyer.mjs";
import * as MyInfoProfileSummaryBuyer_Fragment_graphql from "../../../../__generated__/MyInfoProfileSummaryBuyer_Fragment_graphql.mjs";

function use(fRef) {
  var data = ReactRelay.useFragment(MyInfoProfileSummaryBuyer_Fragment_graphql.node, fRef);
  return RescriptRelay_Internal.internal_useConvertedValue(MyInfoProfileSummaryBuyer_Fragment_graphql.Internal.convertFragment, data);
}

function useOpt(opt_fRef) {
  var fr = opt_fRef !== undefined ? Caml_option.some(Caml_option.valFromOption(opt_fRef)) : undefined;
  var nullableFragmentData = ReactRelay.useFragment(MyInfoProfileSummaryBuyer_Fragment_graphql.node, fr !== undefined ? Js_null_undefined.fromOption(Caml_option.some(Caml_option.valFromOption(fr))) : null);
  var data = (nullableFragmentData == null) ? undefined : Caml_option.some(nullableFragmentData);
  return RescriptRelay_Internal.internal_useConvertedValue((function (rawFragment) {
                if (rawFragment !== undefined) {
                  return MyInfoProfileSummaryBuyer_Fragment_graphql.Internal.convertFragment(rawFragment);
                }
                
              }), data);
}

var Fragment = {
  Types: undefined,
  Operation: undefined,
  use: use,
  useOpt: useOpt
};

function MyInfo_ProfileSummary_Buyer$PC(props) {
  var match = use(props.query);
  var company = match.name;
  return React.createElement("div", {
              className: "pb-5 flex items-center justify-between"
            }, React.createElement("div", {
                  className: "flex"
                }, React.createElement(MyInfo_ProfilePicture_Buyer.make, {
                      content: company,
                      size: /* Large */1
                    }), React.createElement("div", {
                      className: "ml-3"
                    }, React.createElement(MyInfo_ProfileTitle_Buyer.make, {
                          name: Belt_Option.getWithDefault(match.manager, ""),
                          company: company,
                          email: match.uid,
                          isValid: Belt_Option.mapWithDefault(match.verifications, false, (function (d) {
                                  return d.isValidBusinessRegistrationNumberByViewer;
                                })),
                          sectors: Belt_Option.mapWithDefault(match.selfReportedBusinessSectors, [], (function (d) {
                                  return Belt_Array.map(d, (function (param) {
                                                return param.label;
                                              }));
                                }))
                        }))));
}

var PC = {
  make: MyInfo_ProfileSummary_Buyer$PC
};

function MyInfo_ProfileSummary_Buyer$Mobile(props) {
  var match = use(props.query);
  var company = match.name;
  return React.createElement(Link, {
              href: "/buyer/me/profile",
              children: React.createElement("a", undefined, React.createElement("div", {
                        className: "flex justify-between"
                      }, React.createElement("div", {
                            className: "flex items-center"
                          }, React.createElement(MyInfo_ProfilePicture_Buyer.make, {
                                content: company,
                                size: /* Small */0
                              }), React.createElement("div", {
                                className: "ml-3"
                              }, React.createElement(MyInfo_ProfileTitle_Buyer.make, {
                                    name: Belt_Option.getWithDefault(match.manager, ""),
                                    company: company,
                                    email: match.uid,
                                    isValid: Belt_Option.mapWithDefault(match.verifications, false, (function (d) {
                                            return d.isValidBusinessRegistrationNumberByViewer;
                                          })),
                                    sectors: Belt_Option.mapWithDefault(match.selfReportedBusinessSectors, [], (function (d) {
                                            return Belt_Array.map(d, (function (param) {
                                                          return param.label;
                                                        }));
                                          }))
                                  }))), React.createElement(IconArrow.make, {
                            height: "24",
                            width: "24",
                            fill: "#B2B2B2"
                          })))
            });
}

var Mobile = {
  make: MyInfo_ProfileSummary_Buyer$Mobile
};

export {
  Fragment ,
  PC ,
  Mobile ,
}
/* react Not a pure module */
