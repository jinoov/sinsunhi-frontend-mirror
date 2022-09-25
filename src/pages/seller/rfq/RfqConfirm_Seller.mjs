// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Curry from "rescript/lib/es6/curry.js";
import * as React from "react";
import * as DS_None from "../../../components/common/container/DS_None.mjs";
import * as Js_promise from "rescript/lib/es6/js_promise.js";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as Router from "next/router";
import * as ReactRelay from "react-relay";
import * as Authorization from "../../../utils/Authorization.mjs";
import * as RescriptRelay from "rescript-relay/src/RescriptRelay.mjs";
import * as RelayRuntime from "relay-runtime";
import * as RescriptRelay_Internal from "rescript-relay/src/RescriptRelay_Internal.mjs";
import * as RfqConfirmSeller_RfqQuotatinoMeatNode_Query_graphql from "../../../__generated__/RfqConfirmSeller_RfqQuotatinoMeatNode_Query_graphql.mjs";

function use(variables, fetchPolicy, fetchKey, networkCacheConfig, param) {
  var data = ReactRelay.useLazyLoadQuery(RfqConfirmSeller_RfqQuotatinoMeatNode_Query_graphql.node, RescriptRelay_Internal.internal_cleanObjectFromUndefinedRaw(RfqConfirmSeller_RfqQuotatinoMeatNode_Query_graphql.Internal.convertVariables(variables)), {
        fetchKey: fetchKey,
        fetchPolicy: RescriptRelay.mapFetchPolicy(fetchPolicy),
        networkCacheConfig: networkCacheConfig
      });
  return RescriptRelay_Internal.internal_useConvertedValue(RfqConfirmSeller_RfqQuotatinoMeatNode_Query_graphql.Internal.convertResponse, data);
}

function useLoader(param) {
  var match = ReactRelay.useQueryLoader(RfqConfirmSeller_RfqQuotatinoMeatNode_Query_graphql.node);
  var loadQueryFn = match[1];
  var loadQuery = React.useMemo((function () {
          return function (param, param$1, param$2, param$3) {
            return Curry._2(loadQueryFn, RfqConfirmSeller_RfqQuotatinoMeatNode_Query_graphql.Internal.convertVariables(param), {
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
  ReactRelay.fetchQuery(environment, RfqConfirmSeller_RfqQuotatinoMeatNode_Query_graphql.node, RfqConfirmSeller_RfqQuotatinoMeatNode_Query_graphql.Internal.convertVariables(variables), {
          networkCacheConfig: networkCacheConfig,
          fetchPolicy: RescriptRelay.mapFetchQueryFetchPolicy(fetchPolicy)
        }).subscribe({
        next: (function (res) {
            Curry._1(onResult, {
                  TAG: /* Ok */0,
                  _0: RfqConfirmSeller_RfqQuotatinoMeatNode_Query_graphql.Internal.convertResponse(res)
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
  var __x = ReactRelay.fetchQuery(environment, RfqConfirmSeller_RfqQuotatinoMeatNode_Query_graphql.node, RfqConfirmSeller_RfqQuotatinoMeatNode_Query_graphql.Internal.convertVariables(variables), {
          networkCacheConfig: networkCacheConfig,
          fetchPolicy: RescriptRelay.mapFetchQueryFetchPolicy(fetchPolicy)
        }).toPromise();
  return Js_promise.then_((function (res) {
                return Promise.resolve(RfqConfirmSeller_RfqQuotatinoMeatNode_Query_graphql.Internal.convertResponse(res));
              }), __x);
}

function usePreloaded(queryRef, param) {
  var data = ReactRelay.usePreloadedQuery(RfqConfirmSeller_RfqQuotatinoMeatNode_Query_graphql.node, queryRef);
  return RescriptRelay_Internal.internal_useConvertedValue(RfqConfirmSeller_RfqQuotatinoMeatNode_Query_graphql.Internal.convertResponse, data);
}

function retain(environment, variables) {
  var operationDescriptor = RelayRuntime.createOperationDescriptor(RfqConfirmSeller_RfqQuotatinoMeatNode_Query_graphql.node, RfqConfirmSeller_RfqQuotatinoMeatNode_Query_graphql.Internal.convertVariables(variables));
  return environment.retain(operationDescriptor);
}

var Query = {
  Operation: undefined,
  Types: undefined,
  use: use,
  useLoader: useLoader,
  $$fetch: $$fetch,
  fetchPromised: fetchPromised,
  usePreloaded: usePreloaded,
  retain: retain
};

function RfqConfirm_Seller$ConfirmPageRouter(props) {
  var match = use({
        id: props.quotationId
      }, undefined, undefined, undefined, undefined);
  var node = match.node;
  var router = Router.useRouter();
  if (node !== undefined) {
    router.replace("/seller/rfq/request/" + node.requestItem.id + "");
    return null;
  } else {
    return React.createElement(DS_None.Default.make, {
                message: "견적서 정보가 없습니다."
              });
  }
}

var ConfirmPageRouter = {
  make: RfqConfirm_Seller$ConfirmPageRouter
};

function RfqConfirm_Seller(props) {
  var quotationId = props.quotationId;
  return React.createElement(Authorization.Seller.make, {
              children: React.createElement(React.Suspense, {
                    children: Caml_option.some(quotationId !== undefined ? React.createElement(RfqConfirm_Seller$ConfirmPageRouter, {
                                quotationId: quotationId
                              }) : React.createElement(DS_None.Default.make, {
                                message: "견적요청서 정보를 불러올 수 없습니다. 관리자에게 문의해주세요."
                              }))
                  }),
              title: "견적 확인",
              fallback: Caml_option.some(null)
            });
}

var make = RfqConfirm_Seller;

export {
  Query ,
  ConfirmPageRouter ,
  make ,
}
/* react Not a pure module */
