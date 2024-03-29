// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Cx from "rescript-classnames/src/Cx.mjs";
import * as Curry from "rescript/lib/es6/curry.js";
import * as React from "react";
import * as IconError from "./svgs/IconError.mjs";
import * as Belt_Array from "rescript/lib/es6/belt_Array.js";
import * as Js_promise from "rescript/lib/es6/js_promise.js";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as ReactRelay from "react-relay";
import * as Garter_Array from "@greenlabs/garter/src/Garter_Array.mjs";
import * as RescriptRelay from "rescript-relay/src/RescriptRelay.mjs";
import * as RelayRuntime from "relay-runtime";
import * as IconArrowSelect from "./svgs/IconArrowSelect.mjs";
import * as RescriptRelay_Internal from "rescript-relay/src/RescriptRelay_Internal.mjs";
import * as SelectDeliveryCompanyQuery_graphql from "../__generated__/SelectDeliveryCompanyQuery_graphql.mjs";

function use(variables, fetchPolicy, fetchKey, networkCacheConfig, param) {
  var data = ReactRelay.useLazyLoadQuery(SelectDeliveryCompanyQuery_graphql.node, RescriptRelay_Internal.internal_cleanObjectFromUndefinedRaw(SelectDeliveryCompanyQuery_graphql.Internal.convertVariables(variables)), {
        fetchKey: fetchKey,
        fetchPolicy: RescriptRelay.mapFetchPolicy(fetchPolicy),
        networkCacheConfig: networkCacheConfig
      });
  return RescriptRelay_Internal.internal_useConvertedValue(SelectDeliveryCompanyQuery_graphql.Internal.convertResponse, data);
}

function useLoader(param) {
  var match = ReactRelay.useQueryLoader(SelectDeliveryCompanyQuery_graphql.node);
  var loadQueryFn = match[1];
  var loadQuery = React.useMemo((function () {
          return function (param, param$1, param$2, param$3) {
            return Curry._2(loadQueryFn, SelectDeliveryCompanyQuery_graphql.Internal.convertVariables(param), {
                        fetchPolicy: param$1,
                        networkCacheConfig: param$2
                      });
          };
        }), [loadQueryFn]);
  return [
          Caml_option.nullable_to_opt(match[0]),
          loadQuery,
          match[2]
        ];
}

function $$fetch(environment, variables, onResult, networkCacheConfig, fetchPolicy, param) {
  ReactRelay.fetchQuery(environment, SelectDeliveryCompanyQuery_graphql.node, SelectDeliveryCompanyQuery_graphql.Internal.convertVariables(variables), {
          networkCacheConfig: networkCacheConfig,
          fetchPolicy: RescriptRelay.mapFetchQueryFetchPolicy(fetchPolicy)
        }).subscribe({
        next: (function (res) {
            Curry._1(onResult, {
                  TAG: /* Ok */0,
                  _0: SelectDeliveryCompanyQuery_graphql.Internal.convertResponse(res)
                });
          }),
        error: (function (err) {
            Curry._1(onResult, {
                  TAG: /* Error */1,
                  _0: err
                });
          })
      });
}

function fetchPromised(environment, variables, networkCacheConfig, fetchPolicy, param) {
  var __x = ReactRelay.fetchQuery(environment, SelectDeliveryCompanyQuery_graphql.node, SelectDeliveryCompanyQuery_graphql.Internal.convertVariables(variables), {
          networkCacheConfig: networkCacheConfig,
          fetchPolicy: RescriptRelay.mapFetchQueryFetchPolicy(fetchPolicy)
        }).toPromise();
  return Js_promise.then_((function (res) {
                return Promise.resolve(SelectDeliveryCompanyQuery_graphql.Internal.convertResponse(res));
              }), __x);
}

function usePreloaded(queryRef, param) {
  var data = ReactRelay.usePreloadedQuery(SelectDeliveryCompanyQuery_graphql.node, queryRef);
  return RescriptRelay_Internal.internal_useConvertedValue(SelectDeliveryCompanyQuery_graphql.Internal.convertResponse, data);
}

function retain(environment, variables) {
  var operationDescriptor = RelayRuntime.createOperationDescriptor(SelectDeliveryCompanyQuery_graphql.node, SelectDeliveryCompanyQuery_graphql.Internal.convertVariables(variables));
  return environment.retain(operationDescriptor);
}

var Query_deliveryCompanyOrderBy_decode = SelectDeliveryCompanyQuery_graphql.Utils.deliveryCompanyOrderBy_decode;

var Query_deliveryCompanyOrderBy_fromString = SelectDeliveryCompanyQuery_graphql.Utils.deliveryCompanyOrderBy_fromString;

var Query_orderDirection_decode = SelectDeliveryCompanyQuery_graphql.Utils.orderDirection_decode;

var Query_orderDirection_fromString = SelectDeliveryCompanyQuery_graphql.Utils.orderDirection_fromString;

var Query = {
  deliveryCompanyOrderBy_decode: Query_deliveryCompanyOrderBy_decode,
  deliveryCompanyOrderBy_fromString: Query_deliveryCompanyOrderBy_fromString,
  orderDirection_decode: Query_orderDirection_decode,
  orderDirection_fromString: Query_orderDirection_fromString,
  Operation: undefined,
  Types: undefined,
  use: use,
  useLoader: useLoader,
  $$fetch: $$fetch,
  fetchPromised: fetchPromised,
  usePreloaded: usePreloaded,
  retain: retain
};

var normalStyle = "flex items-center border border-border-default-L1 rounded-lg h-9 px-3 text-enabled-L1";

var errorStyle = "flex items-center border border-border-default-L1 rounded-lg h-9 px-3 text-enabled-L1 outline-none ring-2 ring-opacity-100 ring-notice remove-spin-button";

var disabledStyle = "flex items-center border border-border-default-L1 rounded-lg h-9 px-3 text-enabled-L1 outline-none ring-2 ring-opacity-100 ring-notice remove-spin-button";

function style(error, disabled) {
  if (disabled !== undefined) {
    if (disabled) {
      return disabledStyle;
    } else if (error !== undefined) {
      return errorStyle;
    } else {
      return normalStyle;
    }
  } else if (error !== undefined) {
    return errorStyle;
  } else {
    return normalStyle;
  }
}

function Select_Delivery_Company(Props) {
  var label = Props.label;
  var deliveryCompanyId = Props.deliveryCompanyId;
  var onChange = Props.onChange;
  var className = Props.className;
  var error = Props.error;
  var disabled = Props.disabled;
  var queryData = use({
        first: 100,
        orderBy: "NAME",
        orderDirection: "ASC"
      }, undefined, undefined, undefined, undefined);
  var tmp = {
    className: "block w-full h-full absolute top-0 opacity-0",
    value: Belt_Option.getWithDefault(deliveryCompanyId, ""),
    onChange: onChange
  };
  if (disabled !== undefined) {
    tmp.disabled = Caml_option.valFromOption(disabled);
  }
  return React.createElement("article", {
              className: "mt-7 px-5 max-w-sm"
            }, React.createElement("h3", {
                  className: "text-sm"
                }, label), React.createElement("label", {
                  className: "block relative mt-2"
                }, React.createElement("span", {
                      className: Belt_Option.mapWithDefault(className, style(error, disabled), (function (className$p) {
                              return Cx.cx([
                                          style(error, disabled),
                                          className$p
                                        ]);
                            }))
                    }, Belt_Option.getWithDefault(Belt_Option.flatMap(deliveryCompanyId, (function (id) {
                                return Garter_Array.first(Belt_Array.map(Belt_Array.keep(queryData.deliveryCompanies.edges, (function (edge) {
                                                      return edge.node.id === id;
                                                    })), (function (edge) {
                                                  return edge.node.name;
                                                })));
                              })), "택배사 선택")), React.createElement("span", {
                      className: "absolute top-1.5 right-2"
                    }, React.createElement(IconArrowSelect.make, {
                          height: "24",
                          width: "24",
                          fill: "#121212"
                        })), React.createElement("select", tmp, React.createElement("option", {
                          value: ""
                        }, "택배사 선택"), Belt_Array.map(queryData.deliveryCompanies.edges, (function (edge) {
                            return React.createElement("option", {
                                        key: edge.node.id,
                                        value: edge.node.id
                                      }, edge.node.name);
                          })))), Belt_Option.getWithDefault(Belt_Option.map(error, (function (err) {
                        return React.createElement("span", {
                                    className: "flex mt-2"
                                  }, React.createElement(IconError.make, {
                                        width: "20",
                                        height: "20"
                                      }), React.createElement("span", {
                                        className: "text-sm text-notice ml-1"
                                      }, err));
                      })), null));
}

var make = Select_Delivery_Company;

export {
  Query ,
  normalStyle ,
  errorStyle ,
  disabledStyle ,
  style ,
  make ,
}
/* react Not a pure module */
