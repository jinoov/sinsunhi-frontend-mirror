// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Env from "../../../constants/Env.mjs";
import * as Curry from "rescript/lib/es6/curry.js";
import * as React from "react";
import * as RelayEnv from "../../../constants/RelayEnv.mjs";
import * as Js_promise from "rescript/lib/es6/js_promise.js";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as Router from "next/router";
import * as ReactRelay from "react-relay";
import * as DeviceDetect from "../../../bindings/DeviceDetect.mjs";
import * as Footer_Buyer from "../../../components/Footer_Buyer.mjs";
import * as Header_Buyer from "../../../components/Header_Buyer.mjs";
import * as Authorization from "../../../utils/Authorization.mjs";
import * as Bottom_Navbar from "../../../components/Bottom_Navbar.mjs";
import * as RescriptRelay from "rescript-relay/src/RescriptRelay.mjs";
import * as RelayRuntime from "relay-runtime";
import * as ServerSideHelper from "../../../utils/ServerSideHelper.mjs";
import * as FeatureFlagWrapper from "../pc/FeatureFlagWrapper.mjs";
import * as MyInfo_Profile_Buyer from "./components/MyInfo_Profile_Buyer.mjs";
import * as MyInfo_Skeleton_Buyer from "./components/MyInfo_Skeleton_Buyer.mjs";
import * as RescriptRelay_Internal from "rescript-relay/src/RescriptRelay_Internal.mjs";
import * as ProfileBuyer_Query_graphql from "../../../__generated__/ProfileBuyer_Query_graphql.mjs";
import * as RescriptReactErrorBoundary from "@rescript/react/src/RescriptReactErrorBoundary.mjs";

function use(variables, fetchPolicy, fetchKey, networkCacheConfig, param) {
  var data = ReactRelay.useLazyLoadQuery(ProfileBuyer_Query_graphql.node, RescriptRelay_Internal.internal_cleanObjectFromUndefinedRaw(ProfileBuyer_Query_graphql.Internal.convertVariables(variables)), {
        fetchKey: fetchKey,
        fetchPolicy: RescriptRelay.mapFetchPolicy(fetchPolicy),
        networkCacheConfig: networkCacheConfig
      });
  return RescriptRelay_Internal.internal_useConvertedValue(ProfileBuyer_Query_graphql.Internal.convertResponse, data);
}

function useLoader(param) {
  var match = ReactRelay.useQueryLoader(ProfileBuyer_Query_graphql.node);
  var loadQueryFn = match[1];
  var loadQuery = React.useMemo((function () {
          return function (param, param$1, param$2, param$3) {
            return Curry._2(loadQueryFn, ProfileBuyer_Query_graphql.Internal.convertVariables(param), {
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
  ReactRelay.fetchQuery(environment, ProfileBuyer_Query_graphql.node, ProfileBuyer_Query_graphql.Internal.convertVariables(variables), {
          networkCacheConfig: networkCacheConfig,
          fetchPolicy: RescriptRelay.mapFetchQueryFetchPolicy(fetchPolicy)
        }).subscribe({
        next: (function (res) {
            Curry._1(onResult, {
                  TAG: /* Ok */0,
                  _0: ProfileBuyer_Query_graphql.Internal.convertResponse(res)
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
  var __x = ReactRelay.fetchQuery(environment, ProfileBuyer_Query_graphql.node, ProfileBuyer_Query_graphql.Internal.convertVariables(variables), {
          networkCacheConfig: networkCacheConfig,
          fetchPolicy: RescriptRelay.mapFetchQueryFetchPolicy(fetchPolicy)
        }).toPromise();
  return Js_promise.then_((function (res) {
                return Promise.resolve(ProfileBuyer_Query_graphql.Internal.convertResponse(res));
              }), __x);
}

function usePreloaded(queryRef, param) {
  var data = ReactRelay.usePreloadedQuery(ProfileBuyer_Query_graphql.node, queryRef);
  return RescriptRelay_Internal.internal_useConvertedValue(ProfileBuyer_Query_graphql.Internal.convertResponse, data);
}

function retain(environment, variables) {
  var operationDescriptor = RelayRuntime.createOperationDescriptor(ProfileBuyer_Query_graphql.node, ProfileBuyer_Query_graphql.Internal.convertVariables(variables));
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

function Profile_Buyer$Content$PC(Props) {
  var queryData = use(undefined, undefined, undefined, undefined, undefined);
  var viewer = queryData.viewer;
  if (viewer !== undefined) {
    return React.createElement(MyInfo_Profile_Buyer.PC.make, {
                query: viewer.fragmentRefs
              });
  } else {
    return React.createElement("div", undefined, "계정정보를 가져오는데 실패했습니다");
  }
}

var PC = {
  make: Profile_Buyer$Content$PC
};

function Profile_Buyer$Content$Mobile(Props) {
  var queryData = use(undefined, undefined, undefined, undefined, undefined);
  var viewer = queryData.viewer;
  if (viewer !== undefined) {
    return React.createElement(React.Fragment, undefined, React.createElement(MyInfo_Profile_Buyer.Mobile.make, {
                    query: viewer.fragmentRefs
                  }));
  } else {
    return React.createElement("div", undefined, "계정정보를 가져오는데 실패했습니다");
  }
}

var Mobile = {
  make: Profile_Buyer$Content$Mobile
};

var Content = {
  PC: PC,
  Mobile: Mobile
};

function $$default(param) {
  var deviceType = param.deviceType;
  var router = Router.useRouter();
  var tmp;
  if (deviceType !== 1) {
    tmp = React.createElement("div", {
          className: "w-full min-h-screen"
        }, React.createElement(Header_Buyer.Mobile.make, {
              key: router.asPath
            }), React.createElement(RescriptReactErrorBoundary.make, {
              children: React.createElement(React.Suspense, {
                    children: React.createElement(Authorization.Buyer.make, {
                          children: React.createElement(Profile_Buyer$Content$Mobile, {}),
                          title: "신선하이"
                        }),
                    fallback: null
                  }),
              fallback: (function (param) {
                  return React.createElement("div", undefined, "계정정보를 가져오는데 실패했습니다");
                })
            }), React.createElement(Bottom_Navbar.make, {
              deviceType: deviceType
            }));
  } else {
    var oldUI = React.createElement("div", {
          className: "w-full min-h-screen"
        }, React.createElement(Header_Buyer.PC.make, {
              key: router.asPath
            }), React.createElement(Authorization.Buyer.make, {
              children: React.createElement(RescriptReactErrorBoundary.make, {
                    children: React.createElement(React.Suspense, {
                          children: React.createElement(Profile_Buyer$Content$PC, {}),
                          fallback: React.createElement(MyInfo_Skeleton_Buyer.PC.make, {})
                        }),
                    fallback: (function (param) {
                        return React.createElement("div", undefined, "계정정보를 가져오는데 실패했습니다");
                      })
                  }),
              ssrFallback: React.createElement(MyInfo_Skeleton_Buyer.PC.make, {})
            }), React.createElement(Footer_Buyer.PC.make, {}));
    tmp = React.createElement(FeatureFlagWrapper.make, {
          children: React.createElement("div", {
                className: "w-full min-h-screen bg-[#F0F2F5]"
              }, React.createElement(Header_Buyer.PC.make, {
                    key: router.asPath
                  }), React.createElement(Authorization.Buyer.make, {
                    children: React.createElement(RescriptReactErrorBoundary.make, {
                          children: React.createElement(React.Suspense, {
                                children: React.createElement(Profile_Buyer$Content$PC, {}),
                                fallback: React.createElement(MyInfo_Skeleton_Buyer.PC.make, {})
                              }),
                          fallback: (function (param) {
                              return React.createElement("div", undefined, "계정정보를 가져오는데 실패했습니다");
                            })
                        }),
                    ssrFallback: React.createElement(MyInfo_Skeleton_Buyer.PC.make, {})
                  }), React.createElement(Footer_Buyer.PC.make, {})),
          fallback: oldUI,
          featureFlag: "HOME_UI_UX"
        });
  }
  return React.createElement(React.Fragment, undefined, tmp);
}

function getServerSideProps(ctx) {
  var environment = RelayEnv.environment({
        TAG: /* SinsunMarket */0,
        _0: Env.graphqlApiUrl
      });
  var gnbAndCategoryQuery = ServerSideHelper.gnbAndCategory(environment);
  var deviceType = DeviceDetect.detectDeviceFromCtx2(ctx.req);
  return ServerSideHelper.makeResultWithQuery(gnbAndCategoryQuery, environment, {
              deviceType: deviceType
            });
}

export {
  Query ,
  Content ,
  $$default ,
  $$default as default,
  getServerSideProps ,
}
/* Env Not a pure module */
