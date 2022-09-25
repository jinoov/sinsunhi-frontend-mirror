// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Cx from "rescript-classnames/src/Cx.mjs";
import * as Curry from "rescript/lib/es6/curry.js";
import * as React from "react";
import * as DataGtm from "../../utils/DataGtm.mjs";
import Link from "next/link";
import * as Belt_Array from "rescript/lib/es6/belt_Array.js";
import * as Js_promise from "rescript/lib/es6/js_promise.js";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as CustomHooks from "../../utils/CustomHooks.mjs";
import * as ReactEvents from "../../utils/ReactEvents.mjs";
import * as Router from "next/router";
import * as ReactRelay from "react-relay";
import * as Garter_Array from "@greenlabs/garter/src/Garter_Array.mjs";
import * as RescriptRelay from "rescript-relay/src/RescriptRelay.mjs";
import * as RelayRuntime from "relay-runtime";
import * as ReactDialog from "@radix-ui/react-dialog";
import * as RescriptRelay_Internal from "rescript-relay/src/RescriptRelay_Internal.mjs";
import * as CartLinkIconQuery_graphql from "../../__generated__/CartLinkIconQuery_graphql.mjs";
import Icon_cartSvg from "../../../public/assets/icon_cart.svg";

function use(variables, fetchPolicy, fetchKey, networkCacheConfig, param) {
  var data = ReactRelay.useLazyLoadQuery(CartLinkIconQuery_graphql.node, RescriptRelay_Internal.internal_cleanObjectFromUndefinedRaw(CartLinkIconQuery_graphql.Internal.convertVariables(variables)), {
        fetchKey: fetchKey,
        fetchPolicy: RescriptRelay.mapFetchPolicy(fetchPolicy),
        networkCacheConfig: networkCacheConfig
      });
  return RescriptRelay_Internal.internal_useConvertedValue(CartLinkIconQuery_graphql.Internal.convertResponse, data);
}

function useLoader(param) {
  var match = ReactRelay.useQueryLoader(CartLinkIconQuery_graphql.node);
  var loadQueryFn = match[1];
  var loadQuery = React.useMemo((function () {
          return function (param, param$1, param$2, param$3) {
            return Curry._2(loadQueryFn, CartLinkIconQuery_graphql.Internal.convertVariables(param), {
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
  ReactRelay.fetchQuery(environment, CartLinkIconQuery_graphql.node, CartLinkIconQuery_graphql.Internal.convertVariables(variables), {
          networkCacheConfig: networkCacheConfig,
          fetchPolicy: RescriptRelay.mapFetchQueryFetchPolicy(fetchPolicy)
        }).subscribe({
        next: (function (res) {
            Curry._1(onResult, {
                  TAG: /* Ok */0,
                  _0: CartLinkIconQuery_graphql.Internal.convertResponse(res)
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
  var __x = ReactRelay.fetchQuery(environment, CartLinkIconQuery_graphql.node, CartLinkIconQuery_graphql.Internal.convertVariables(variables), {
          networkCacheConfig: networkCacheConfig,
          fetchPolicy: RescriptRelay.mapFetchQueryFetchPolicy(fetchPolicy)
        }).toPromise();
  return Js_promise.then_((function (res) {
                return Promise.resolve(CartLinkIconQuery_graphql.Internal.convertResponse(res));
              }), __x);
}

function usePreloaded(queryRef, param) {
  var data = ReactRelay.usePreloadedQuery(CartLinkIconQuery_graphql.node, queryRef);
  return RescriptRelay_Internal.internal_useConvertedValue(CartLinkIconQuery_graphql.Internal.convertResponse, data);
}

function retain(environment, variables) {
  var operationDescriptor = RelayRuntime.createOperationDescriptor(CartLinkIconQuery_graphql.node, CartLinkIconQuery_graphql.Internal.convertVariables(variables));
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

var cartIcon = Icon_cartSvg;

function CartLinkIcon$PlaceHolder(props) {
  return React.createElement(Link, {
              href: "/buyer/cart",
              children: React.createElement("a", undefined, React.createElement("img", {
                        className: "w-6 h-6 min-w-[24px] min-h-[24px] place-self-center",
                        alt: "cart-icon",
                        src: cartIcon
                      }))
            });
}

var PlaceHolder = {
  make: CartLinkIcon$PlaceHolder
};

function CartLinkIcon$NotLoggedIn(props) {
  var match = React.useState(function () {
        return false;
      });
  var setShowLogin = match[1];
  var router = Router.useRouter();
  var isSignInPage = Belt_Option.mapWithDefault(Garter_Array.get(Belt_Array.keep(router.pathname.split("/"), (function (x) {
                  return x !== "";
                })), 1), false, (function (path) {
          return path === "signin";
        }));
  return React.createElement(React.Fragment, undefined, React.createElement(ReactDialog.Root, {
                  children: React.createElement(ReactDialog.Portal, {
                        children: null
                      }, React.createElement(ReactDialog.Overlay, {
                            className: "dialog-overlay"
                          }), React.createElement(ReactDialog.Content, {
                            children: null,
                            className: "dialog-content p-7 bg-white rounded-xl w-[480px] flex flex-col gap-7 items-center justify-center"
                          }, React.createElement("span", {
                                className: "whitespace-pre text-center text-text-L1 pt-3"
                              }, "로그인 후에\n확인하실 수 있습니다"), React.createElement("div", {
                                className: "flex w-full justify-center items-center gap-2"
                              }, React.createElement("button", {
                                    className: "w-1/2 h-13 rounded-xl flex items-center justify-center bg-enabled-L5",
                                    onClick: (function (param) {
                                        return ReactEvents.interceptingHandler((function (param) {
                                                      setShowLogin(function (param) {
                                                            return false;
                                                          });
                                                    }), param);
                                      })
                                  }, "닫기"), React.createElement("button", {
                                    className: "w-1/2 h-13 rounded-xl flex items-center justify-center bg-primary hover:bg-primary-variant text-white font-bold",
                                    onClick: (function (param) {
                                        return ReactEvents.interceptingHandler((function (param) {
                                                      setShowLogin(function (param) {
                                                            return false;
                                                          });
                                                      if (isSignInPage) {
                                                        return ;
                                                      } else {
                                                        router.push("/buyer/signin?redirect=/buyer/cart");
                                                        return ;
                                                      }
                                                    }), param);
                                      })
                                  }, "로그인")))),
                  _open: match[0]
                }), React.createElement("button", {
                  type: "button",
                  onClick: (function (param) {
                      setShowLogin(function (param) {
                            return true;
                          });
                    })
                }, React.createElement("img", {
                      className: "w-6 h-6 min-w-[24px] min-h-[24px]",
                      alt: "cart-icon",
                      src: cartIcon
                    })));
}

var NotLoggedIn = {
  make: CartLinkIcon$NotLoggedIn
};

function CartLinkIcon$Container(props) {
  var queryData = use(undefined, /* StoreAndNetwork */2, undefined, undefined, undefined);
  var router = Router.useRouter();
  var count = queryData.cartItemCount;
  return React.createElement(React.Suspense, {
              children: Caml_option.some(React.createElement(DataGtm.make, {
                        children: React.createElement("button", {
                              className: "relative w-6 h-6 min-w-[24px] min-h-[24px] place-self-center",
                              type: "button",
                              onClick: (function (param) {
                                  router.push("/buyer/cart");
                                })
                            }, count !== 0 ? React.createElement("div", {
                                    className: Cx.cx([
                                          "flex justify-center items-center rounded-[10px] bg-emphasis h-4 text-white text-xs absolute font-bold -top-1 leading-[14.4px]",
                                          count >= 10 ? "-right-2 w-[23px]" : "-right-1 w-4"
                                        ])
                                  }, String(count)) : null, React.createElement("img", {
                                  className: "w-6 h-6 min-w-[24px] min-h-[24px] place-self-center",
                                  alt: "cart-icon",
                                  src: cartIcon
                                })),
                        dataGtm: "click_cart"
                      })),
              fallback: Caml_option.some(React.createElement(CartLinkIcon$PlaceHolder, {}))
            });
}

var Container = {
  make: CartLinkIcon$Container
};

function CartLinkIcon(props) {
  var user = CustomHooks.Auth.use(undefined);
  var isLoggedIn;
  if (typeof user === "number") {
    isLoggedIn = false;
  } else {
    var match = user._0.role;
    isLoggedIn = match === 1;
  }
  if (isLoggedIn) {
    return React.createElement(CartLinkIcon$Container, {});
  } else {
    return React.createElement(CartLinkIcon$NotLoggedIn, {});
  }
}

var make = CartLinkIcon;

export {
  Query ,
  cartIcon ,
  PlaceHolder ,
  NotLoggedIn ,
  Container ,
  make ,
}
/* cartIcon Not a pure module */
