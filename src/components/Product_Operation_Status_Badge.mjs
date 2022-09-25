// Generated by ReScript, PLEASE EDIT WITH CARE

import * as React from "react";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as ReactRelay from "react-relay";
import * as Js_null_undefined from "rescript/lib/es6/js_null_undefined.js";
import * as RescriptRelay_Internal from "rescript-relay/src/RescriptRelay_Internal.mjs";
import * as ProductOperationStatusBadge_graphql from "../__generated__/ProductOperationStatusBadge_graphql.mjs";

function use(fRef) {
  var data = ReactRelay.useFragment(ProductOperationStatusBadge_graphql.node, fRef);
  return RescriptRelay_Internal.internal_useConvertedValue(ProductOperationStatusBadge_graphql.Internal.convertFragment, data);
}

function useOpt(opt_fRef) {
  var fr = opt_fRef !== undefined ? Caml_option.some(Caml_option.valFromOption(opt_fRef)) : undefined;
  var nullableFragmentData = ReactRelay.useFragment(ProductOperationStatusBadge_graphql.node, fr !== undefined ? Js_null_undefined.fromOption(Caml_option.some(Caml_option.valFromOption(fr))) : null);
  var data = (nullableFragmentData == null) ? undefined : Caml_option.some(nullableFragmentData);
  return RescriptRelay_Internal.internal_useConvertedValue((function (rawFragment) {
                if (rawFragment !== undefined) {
                  return ProductOperationStatusBadge_graphql.Internal.convertFragment(rawFragment);
                }
                
              }), data);
}

var Fragment_productStatus_decode = ProductOperationStatusBadge_graphql.Utils.productStatus_decode;

var Fragment_productStatus_fromString = ProductOperationStatusBadge_graphql.Utils.productStatus_fromString;

var Fragment = {
  productStatus_decode: Fragment_productStatus_decode,
  productStatus_fromString: Fragment_productStatus_fromString,
  Types: undefined,
  Operation: undefined,
  use: use,
  useOpt: useOpt
};

function Product_Operation_Status_Badge(props) {
  var match = use(props.query);
  var status = match.status;
  var displayStyle = status === "RETIRE" || status === "HIDDEN_SALE" || status === "SOLDOUT" || status === "NOSALE" || status !== "SALE" ? "max-w-min bg-gray-gl py-0.5 px-2 text-gray-gl rounded mr-2 whitespace-nowrap" : "max-w-min bg-green-gl-light py-0.5 px-2 text-green-gl rounded mr-2 whitespace-nowrap";
  var displayText = status === "NOSALE" ? "숨김" : (
      status === "SOLDOUT" ? "품절" : (
          status === "HIDDEN_SALE" ? "전시판매숨김" : (
              status === "SALE" ? "판매중" : (
                  status === "RETIRE" ? "영구판매중지" : "상태를 표시할 수 없습니다."
                )
            )
        )
    );
  return React.createElement("span", {
              className: displayStyle
            }, displayText);
}

var make = Product_Operation_Status_Badge;

export {
  Fragment ,
  make ,
}
/* react Not a pure module */
