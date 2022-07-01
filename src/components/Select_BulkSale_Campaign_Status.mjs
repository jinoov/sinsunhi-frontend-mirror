// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Curry from "rescript/lib/es6/curry.js";
import * as React from "react";
import * as IconCheck from "./svgs/IconCheck.mjs";
import * as IconError from "./svgs/IconError.mjs";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as Garter_Array from "@greenlabs/garter/src/Garter_Array.mjs";
import * as RelayRuntime from "relay-runtime";
import * as IconArrowSelect from "./svgs/IconArrowSelect.mjs";
import * as Hooks from "react-relay/hooks";
import * as ReactToastNotifications from "react-toast-notifications";
import * as SelectBulkSaleCampaignStatusMutation_graphql from "../__generated__/SelectBulkSaleCampaignStatusMutation_graphql.mjs";

var make_bulkSaleCampaignUpdateInput = SelectBulkSaleCampaignStatusMutation_graphql.Utils.make_bulkSaleCampaignUpdateInput;

var makeVariables = SelectBulkSaleCampaignStatusMutation_graphql.Utils.makeVariables;

function commitMutation(environment, variables, optimisticUpdater, optimisticResponse, updater, onCompleted, onError, uploadables, param) {
  return RelayRuntime.commitMutation(environment, {
              mutation: SelectBulkSaleCampaignStatusMutation_graphql.node,
              variables: SelectBulkSaleCampaignStatusMutation_graphql.Internal.convertVariables(variables),
              onCompleted: (function (res, err) {
                  if (onCompleted !== undefined) {
                    return Curry._2(onCompleted, SelectBulkSaleCampaignStatusMutation_graphql.Internal.convertResponse(res), (err == null) ? undefined : Caml_option.some(err));
                  }
                  
                }),
              onError: (function (err) {
                  if (onError !== undefined) {
                    return Curry._1(onError, (err == null) ? undefined : Caml_option.some(err));
                  }
                  
                }),
              optimisticResponse: optimisticResponse !== undefined ? SelectBulkSaleCampaignStatusMutation_graphql.Internal.convertWrapRawResponse(optimisticResponse) : undefined,
              optimisticUpdater: optimisticUpdater,
              updater: updater !== undefined ? (function (store, r) {
                    return Curry._2(updater, store, SelectBulkSaleCampaignStatusMutation_graphql.Internal.convertResponse(r));
                  }) : undefined,
              uploadables: uploadables
            });
}

function use(param) {
  var match = Hooks.useMutation(SelectBulkSaleCampaignStatusMutation_graphql.node);
  var mutate = match[0];
  return [
          React.useMemo((function () {
                  return function (param, param$1, param$2, param$3, param$4, param$5, param$6, param$7, param$8) {
                    return Curry._1(mutate, {
                                onError: param,
                                onCompleted: param$1 !== undefined ? (function (r, errors) {
                                      return Curry._2(param$1, SelectBulkSaleCampaignStatusMutation_graphql.Internal.convertResponse(r), (errors == null) ? undefined : Caml_option.some(errors));
                                    }) : undefined,
                                onUnsubscribe: param$2,
                                optimisticResponse: param$3 !== undefined ? SelectBulkSaleCampaignStatusMutation_graphql.Internal.convertWrapRawResponse(param$3) : undefined,
                                optimisticUpdater: param$4,
                                updater: param$5 !== undefined ? (function (store, r) {
                                      return Curry._2(param$5, store, SelectBulkSaleCampaignStatusMutation_graphql.Internal.convertResponse(r));
                                    }) : undefined,
                                variables: SelectBulkSaleCampaignStatusMutation_graphql.Internal.convertVariables(param$6),
                                uploadables: param$7
                              });
                  };
                }), [mutate]),
          match[1]
        ];
}

var Mutation_productPackageMassUnit_decode = SelectBulkSaleCampaignStatusMutation_graphql.Utils.productPackageMassUnit_decode;

var Mutation_productPackageMassUnit_fromString = SelectBulkSaleCampaignStatusMutation_graphql.Utils.productPackageMassUnit_fromString;

var Mutation_make_productPackageMassInput = SelectBulkSaleCampaignStatusMutation_graphql.Utils.make_productPackageMassInput;

var Mutation = {
  productPackageMassUnit_decode: Mutation_productPackageMassUnit_decode,
  productPackageMassUnit_fromString: Mutation_productPackageMassUnit_fromString,
  make_bulkSaleCampaignUpdateInput: make_bulkSaleCampaignUpdateInput,
  make_productPackageMassInput: Mutation_make_productPackageMassInput,
  makeVariables: makeVariables,
  Types: undefined,
  commitMutation: commitMutation,
  use: use
};

function stringifyStatus(s) {
  if (s) {
    return "open";
  } else {
    return "end";
  }
}

function displayStatus(s) {
  if (s) {
    return "모집중";
  } else {
    return "모집완료";
  }
}

function Select_BulkSale_Campaign_Status(Props) {
  var product = Props.product;
  var refetchSummary = Props.refetchSummary;
  var match = ReactToastNotifications.useToasts();
  var addToast = match.addToast;
  var match$1 = use(undefined);
  var mutate = match$1[0];
  var handleOnChange = function (e) {
    var value = e.target.value;
    Curry.app(mutate, [
          (function (err) {
              return addToast(React.createElement("div", {
                              className: "flex items-center"
                            }, React.createElement(IconError.make, {
                                  width: "24",
                                  height: "24",
                                  className: "mr-2"
                                }), err.message), {
                          appearance: "error"
                        });
            }),
          (function (param, param$1) {
              addToast(React.createElement("div", {
                        className: "flex items-center"
                      }, React.createElement(IconCheck.make, {
                            height: "24",
                            width: "24",
                            fill: "#12B564",
                            className: "mr-2"
                          }), "수정 요청에 성공하였습니다."), {
                    appearance: "success"
                  });
              return Curry._1(refetchSummary, undefined);
            }),
          undefined,
          undefined,
          undefined,
          undefined,
          Curry._2(makeVariables, product.id, Curry._8(make_bulkSaleCampaignUpdateInput, undefined, undefined, undefined, undefined, value === "open", undefined, undefined, undefined)),
          undefined,
          undefined
        ]);
    
  };
  return React.createElement("label", {
              className: "block relative"
            }, React.createElement("span", {
                  className: "flex items-center border border-border-default-L1 rounded-md h-9 px-3 text-enabled-L1"
                }, product.isOpen ? "모집중" : "모집완료"), React.createElement("span", {
                  className: "absolute top-1.5 right-2"
                }, React.createElement(IconArrowSelect.make, {
                      height: "24",
                      width: "24",
                      fill: "#121212"
                    })), React.createElement("select", {
                  className: "block w-full h-full absolute top-0 opacity-0",
                  disabled: match$1[1],
                  value: product.isOpen ? "open" : "end",
                  onChange: handleOnChange
                }, Garter_Array.map([
                      true,
                      false
                    ], (function (s) {
                        return React.createElement("option", {
                                    key: s ? "open" : "end",
                                    value: s ? "open" : "end"
                                  }, s ? "모집중" : "모집완료");
                      }))));
}

var make = Select_BulkSale_Campaign_Status;

export {
  Mutation ,
  stringifyStatus ,
  displayStatus ,
  make ,
  
}
/* react Not a pure module */