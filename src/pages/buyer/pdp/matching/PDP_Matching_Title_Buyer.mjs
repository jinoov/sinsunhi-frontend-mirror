// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Curry from "rescript/lib/es6/curry.js";
import * as React from "react";
import * as Locale from "../../../../utils/Locale.mjs";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as CustomHooks from "../../../../utils/CustomHooks.mjs";
import * as ReactRelay from "react-relay";
import * as Js_null_undefined from "rescript/lib/es6/js_null_undefined.js";
import * as RescriptRelay_Internal from "rescript-relay/src/RescriptRelay_Internal.mjs";
import * as PDPMatchingTitleBuyer_fragment_graphql from "../../../../__generated__/PDPMatchingTitleBuyer_fragment_graphql.mjs";

function use(fRef) {
  var data = ReactRelay.useFragment(PDPMatchingTitleBuyer_fragment_graphql.node, fRef);
  return RescriptRelay_Internal.internal_useConvertedValue(PDPMatchingTitleBuyer_fragment_graphql.Internal.convertFragment, data);
}

function useOpt(opt_fRef) {
  var fr = opt_fRef !== undefined ? Caml_option.some(Caml_option.valFromOption(opt_fRef)) : undefined;
  var nullableFragmentData = ReactRelay.useFragment(PDPMatchingTitleBuyer_fragment_graphql.node, fr !== undefined ? Js_null_undefined.fromOption(Caml_option.some(Caml_option.valFromOption(fr))) : null);
  var data = (nullableFragmentData == null) ? undefined : Caml_option.some(nullableFragmentData);
  return RescriptRelay_Internal.internal_useConvertedValue((function (rawFragment) {
                if (rawFragment !== undefined) {
                  return PDPMatchingTitleBuyer_fragment_graphql.Internal.convertFragment(rawFragment);
                }
                
              }), data);
}

var Fragment = {
  Types: undefined,
  Operation: undefined,
  use: use,
  useOpt: useOpt
};

function PDP_Matching_Title_Buyer$MO(Props) {
  var query = Props.query;
  var selectedGroup = Props.selectedGroup;
  var match = use(query);
  var representativeWeight = match.representativeWeight;
  var priceLabel = Belt_Option.mapWithDefault(match.recentMarketPrice, "", (function (param) {
          var price;
          switch (selectedGroup) {
            case "high" :
                price = Belt_Option.map(param.high.mean, (function (mean$p) {
                        return mean$p * representativeWeight;
                      }));
                break;
            case "low" :
                price = Belt_Option.map(param.low.mean, (function (mean$p) {
                        return mean$p * representativeWeight;
                      }));
                break;
            case "medium" :
                price = Belt_Option.map(param.medium.mean, (function (mean$p) {
                        return mean$p * representativeWeight;
                      }));
                break;
            default:
              price = undefined;
          }
          return Belt_Option.mapWithDefault(price, "", (function (price$p) {
                        return "" + Locale.Float.show(undefined, price$p, 0) + "원";
                      }));
        }));
  var user = Curry._1(CustomHooks.User.Buyer.use2, undefined);
  return React.createElement("div", {
              className: "w-full py-6 flex justify-between"
            }, React.createElement("div", undefined, React.createElement("h1", {
                      className: "text-lg text-black font-bold"
                    }, match.displayName), React.createElement("span", {
                      className: "mt-1 text-xs text-gray-600"
                    }, "" + String(representativeWeight) + "kg당 예상 거래가")), typeof user === "number" ? (
                user !== 0 ? React.createElement("h1", {
                        className: "text-[22px] text-black font-bold"
                      }, "예상가 회원공개") : null
              ) : React.createElement("h1", {
                    className: "text-[22px] text-black font-bold"
                  }, priceLabel));
}

var MO = {
  make: PDP_Matching_Title_Buyer$MO
};

export {
  Fragment ,
  MO ,
}
/* react Not a pure module */
