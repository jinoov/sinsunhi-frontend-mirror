// Generated by ReScript, PLEASE EDIT WITH CARE

import * as React from "react";
import * as IconArrow from "./svgs/IconArrow.mjs";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as ReactRelay from "react-relay";
import * as Js_null_undefined from "rescript/lib/es6/js_null_undefined.js";
import * as Select_Product_Type from "./Select_Product_Type.mjs";
import * as RescriptRelay_Internal from "rescript-relay/src/RescriptRelay_Internal.mjs";
import * as Update_Normal_Product_Form_Admin from "./Update_Normal_Product_Form_Admin.mjs";
import * as Update_Quoted_Product_Form_Admin from "./Update_Quoted_Product_Form_Admin.mjs";
import * as Update_Matching_Product_Form_Admin from "./Update_Matching_Product_Form_Admin.mjs";
import * as UpdateProductDetailAdminFragment_graphql from "../__generated__/UpdateProductDetailAdminFragment_graphql.mjs";

function use(fRef) {
  var data = ReactRelay.useFragment(UpdateProductDetailAdminFragment_graphql.node, fRef);
  return RescriptRelay_Internal.internal_useConvertedValue(UpdateProductDetailAdminFragment_graphql.Internal.convertFragment, data);
}

function useOpt(opt_fRef) {
  var fr = opt_fRef !== undefined ? Caml_option.some(Caml_option.valFromOption(opt_fRef)) : undefined;
  var nullableFragmentData = ReactRelay.useFragment(UpdateProductDetailAdminFragment_graphql.node, fr !== undefined ? Js_null_undefined.fromOption(Caml_option.some(Caml_option.valFromOption(fr))) : null);
  var data = (nullableFragmentData == null) ? undefined : Caml_option.some(nullableFragmentData);
  return RescriptRelay_Internal.internal_useConvertedValue((function (rawFragment) {
                if (rawFragment !== undefined) {
                  return UpdateProductDetailAdminFragment_graphql.Internal.convertFragment(rawFragment);
                }
                
              }), data);
}

var Fragment = {
  Types: undefined,
  Operation: undefined,
  use: use,
  useOpt: useOpt
};

function UpdateProduct_Detail_Admin(props) {
  var productType = props.productType;
  var product = use(props.query);
  var productSelectType = productType !== 2 ? (
      productType >= 3 ? /* MATCHING */2 : /* NORMAL */0
    ) : /* QUOTED */1;
  var tmp;
  switch (productSelectType) {
    case /* NORMAL */0 :
        tmp = React.createElement(Update_Normal_Product_Form_Admin.make, {
              query: product.fragmentRefs,
              isQuotable: productType === /* Quotable */1
            });
        break;
    case /* QUOTED */1 :
        tmp = React.createElement(Update_Quoted_Product_Form_Admin.make, {
              query: product.fragmentRefs
            });
        break;
    case /* MATCHING */2 :
        tmp = React.createElement(Update_Matching_Product_Form_Admin.make, {
              query: product.fragmentRefs
            });
        break;
    
  }
  return React.createElement("div", {
              className: "max-w-gnb-panel overflow-auto bg-div-shape-L1 min-h-screen mb-16"
            }, React.createElement("header", {
                  className: "flex flex-col items-baseline p-7 pb-0 gap-1"
                }, React.createElement("div", {
                      className: "flex justify-center items-center gap-2 text-sm"
                    }, React.createElement("span", {
                          className: "font-bold"
                        }, "상품 조회·수정"), React.createElement(IconArrow.make, {
                          height: "16",
                          width: "16",
                          stroke: "#262626"
                        }), React.createElement("span", undefined, "상품 수정")), React.createElement("h1", {
                      className: "text-text-L1 text-xl font-bold"
                    }, "" + product.name + " 수정")), React.createElement("div", undefined, React.createElement("div", {
                      className: "px-7 pt-7 mt-4 mx-4 bg-white rounded-t-md shadow-gl"
                    }, React.createElement("h2", {
                          className: "text-text-L1 text-lg font-bold"
                        }, "상품유형"), React.createElement("div", {
                          className: "py-6 w-96"
                        }, React.createElement(Select_Product_Type.make, {
                              status: productSelectType,
                              onChange: (function (param) {
                                  
                                })
                            })))), tmp);
}

var make = UpdateProduct_Detail_Admin;

export {
  Fragment ,
  make ,
}
/* react Not a pure module */
