// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Curry from "rescript/lib/es6/curry.js";
import * as React from "react";
import * as Js_promise from "rescript/lib/es6/js_promise.js";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as Router from "next/router";
import * as ReactRelay from "react-relay";
import * as RescriptRelay from "rescript-relay/src/RescriptRelay.mjs";
import * as RelayRuntime from "relay-runtime";
import * as RescriptRelay_Internal from "rescript-relay/src/RescriptRelay_Internal.mjs";
import * as RfqCommon_RfqRequest_Query_graphql from "../../../../__generated__/RfqCommon_RfqRequest_Query_graphql.mjs";

function use(variables, fetchPolicy, fetchKey, networkCacheConfig, param) {
  var data = ReactRelay.useLazyLoadQuery(RfqCommon_RfqRequest_Query_graphql.node, RescriptRelay_Internal.internal_cleanObjectFromUndefinedRaw(RfqCommon_RfqRequest_Query_graphql.Internal.convertVariables(variables)), {
        fetchKey: fetchKey,
        fetchPolicy: RescriptRelay.mapFetchPolicy(fetchPolicy),
        networkCacheConfig: networkCacheConfig
      });
  return RescriptRelay_Internal.internal_useConvertedValue(RfqCommon_RfqRequest_Query_graphql.Internal.convertResponse, data);
}

function useLoader(param) {
  var match = ReactRelay.useQueryLoader(RfqCommon_RfqRequest_Query_graphql.node);
  var loadQueryFn = match[1];
  var loadQuery = React.useMemo((function () {
          return function (param, param$1, param$2, param$3) {
            return Curry._2(loadQueryFn, RfqCommon_RfqRequest_Query_graphql.Internal.convertVariables(param), {
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
  ReactRelay.fetchQuery(environment, RfqCommon_RfqRequest_Query_graphql.node, RfqCommon_RfqRequest_Query_graphql.Internal.convertVariables(variables), {
          networkCacheConfig: networkCacheConfig,
          fetchPolicy: RescriptRelay.mapFetchQueryFetchPolicy(fetchPolicy)
        }).subscribe({
        next: (function (res) {
            Curry._1(onResult, {
                  TAG: /* Ok */0,
                  _0: RfqCommon_RfqRequest_Query_graphql.Internal.convertResponse(res)
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
  var __x = ReactRelay.fetchQuery(environment, RfqCommon_RfqRequest_Query_graphql.node, RfqCommon_RfqRequest_Query_graphql.Internal.convertVariables(variables), {
          networkCacheConfig: networkCacheConfig,
          fetchPolicy: RescriptRelay.mapFetchQueryFetchPolicy(fetchPolicy)
        }).toPromise();
  return Js_promise.then_((function (res) {
                return Promise.resolve(RfqCommon_RfqRequest_Query_graphql.Internal.convertResponse(res));
              }), __x);
}

function usePreloaded(queryRef, param) {
  var data = ReactRelay.usePreloadedQuery(RfqCommon_RfqRequest_Query_graphql.node, queryRef);
  return RescriptRelay_Internal.internal_useConvertedValue(RfqCommon_RfqRequest_Query_graphql.Internal.convertResponse, data);
}

function retain(environment, variables) {
  var operationDescriptor = RelayRuntime.createOperationDescriptor(RfqCommon_RfqRequest_Query_graphql.node, RfqCommon_RfqRequest_Query_graphql.Internal.convertVariables(variables));
  return environment.retain(operationDescriptor);
}

var Query_rfqRequestStatus_decode = RfqCommon_RfqRequest_Query_graphql.Utils.rfqRequestStatus_decode;

var Query_rfqRequestStatus_fromString = RfqCommon_RfqRequest_Query_graphql.Utils.rfqRequestStatus_fromString;

var Query = {
  rfqRequestStatus_decode: Query_rfqRequestStatus_decode,
  rfqRequestStatus_fromString: Query_rfqRequestStatus_fromString,
  Operation: undefined,
  Types: undefined,
  use: use,
  useLoader: useLoader,
  $$fetch: $$fetch,
  fetchPromised: fetchPromised,
  usePreloaded: usePreloaded,
  retain: retain
};

function use$1(id) {
  var match = use({
        id: id
      }, undefined, undefined, undefined, undefined);
  var node = match.node;
  if (node !== undefined) {
    return /* RequestStatus */{
            _0: node.status
          };
  } else {
    return /* Unknown */0;
  }
}

function RfqCommon$CheckBuyerRequestStatus(Props) {
  var children = Props.children;
  var requestId = Props.requestId;
  var router = Router.useRouter();
  var result = use$1(requestId);
  React.useEffect((function () {
          if (result && result._0 === "DRAFT") {
            
          } else {
            router.push("/buyer/rfq");
          }
        }), []);
  if (result && result._0 === "DRAFT") {
    return children;
  } else {
    return null;
  }
}

var CheckBuyerRequestStatus = {
  Query: Query,
  use: use$1,
  make: RfqCommon$CheckBuyerRequestStatus
};

export {
  CheckBuyerRequestStatus ,
}
/* react Not a pure module */
