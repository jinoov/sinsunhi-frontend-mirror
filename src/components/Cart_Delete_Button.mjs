// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Curry from "rescript/lib/es6/curry.js";
import * as React from "react";
import * as IconCheck from "./svgs/IconCheck.mjs";
import * as IconClose from "./svgs/IconClose.mjs";
import * as IconError from "./svgs/IconError.mjs";
import * as Belt_Array from "rescript/lib/es6/belt_Array.js";
import * as Js_promise from "rescript/lib/es6/js_promise.js";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as ReactEvents from "../utils/ReactEvents.mjs";
import * as ReactRelay from "react-relay";
import * as RescriptRelay from "rescript-relay/src/RescriptRelay.mjs";
import * as RelayRuntime from "relay-runtime";
import * as ReactDialog from "@radix-ui/react-dialog";
import * as RescriptRelay_Internal from "rescript-relay/src/RescriptRelay_Internal.mjs";
import * as ReactToastNotifications from "react-toast-notifications";
import * as CartDeleteButtonMutation_graphql from "../__generated__/CartDeleteButtonMutation_graphql.mjs";
import * as CartDeleteButtonCartQuery_graphql from "../__generated__/CartDeleteButtonCartQuery_graphql.mjs";

function commitMutation(environment, variables, optimisticUpdater, optimisticResponse, updater, onCompleted, onError, uploadables, param) {
  return RelayRuntime.commitMutation(environment, {
              mutation: CartDeleteButtonMutation_graphql.node,
              variables: CartDeleteButtonMutation_graphql.Internal.convertVariables(variables),
              onCompleted: (function (res, err) {
                  if (onCompleted !== undefined) {
                    return Curry._2(onCompleted, CartDeleteButtonMutation_graphql.Internal.convertResponse(res), (err == null) ? undefined : Caml_option.some(err));
                  }
                  
                }),
              onError: (function (err) {
                  if (onError !== undefined) {
                    return Curry._1(onError, (err == null) ? undefined : Caml_option.some(err));
                  }
                  
                }),
              optimisticResponse: optimisticResponse !== undefined ? CartDeleteButtonMutation_graphql.Internal.convertWrapRawResponse(optimisticResponse) : undefined,
              optimisticUpdater: optimisticUpdater,
              updater: updater !== undefined ? (function (store, r) {
                    Curry._2(updater, store, CartDeleteButtonMutation_graphql.Internal.convertResponse(r));
                  }) : undefined,
              uploadables: uploadables
            });
}

function use(param) {
  var match = ReactRelay.useMutation(CartDeleteButtonMutation_graphql.node);
  var mutate = match[0];
  return [
          React.useMemo((function () {
                  return function (param, param$1, param$2, param$3, param$4, param$5, param$6, param$7, param$8) {
                    return Curry._1(mutate, {
                                onError: param,
                                onCompleted: param$1 !== undefined ? (function (r, errors) {
                                      Curry._2(param$1, CartDeleteButtonMutation_graphql.Internal.convertResponse(r), (errors == null) ? undefined : Caml_option.some(errors));
                                    }) : undefined,
                                onUnsubscribe: param$2,
                                optimisticResponse: param$3 !== undefined ? CartDeleteButtonMutation_graphql.Internal.convertWrapRawResponse(param$3) : undefined,
                                optimisticUpdater: param$4,
                                updater: param$5 !== undefined ? (function (store, r) {
                                      Curry._2(param$5, store, CartDeleteButtonMutation_graphql.Internal.convertResponse(r));
                                    }) : undefined,
                                variables: CartDeleteButtonMutation_graphql.Internal.convertVariables(param$6),
                                uploadables: param$7
                              });
                  };
                }), [mutate]),
          match[1]
        ];
}

var Mutation = {
  Operation: undefined,
  Types: undefined,
  commitMutation: commitMutation,
  use: use
};

function use$1(variables, fetchPolicy, fetchKey, networkCacheConfig, param) {
  var data = ReactRelay.useLazyLoadQuery(CartDeleteButtonCartQuery_graphql.node, RescriptRelay_Internal.internal_cleanObjectFromUndefinedRaw(CartDeleteButtonCartQuery_graphql.Internal.convertVariables(variables)), {
        fetchKey: fetchKey,
        fetchPolicy: RescriptRelay.mapFetchPolicy(fetchPolicy),
        networkCacheConfig: networkCacheConfig
      });
  return RescriptRelay_Internal.internal_useConvertedValue(CartDeleteButtonCartQuery_graphql.Internal.convertResponse, data);
}

function useLoader(param) {
  var match = ReactRelay.useQueryLoader(CartDeleteButtonCartQuery_graphql.node);
  var loadQueryFn = match[1];
  var loadQuery = React.useMemo((function () {
          return function (param, param$1, param$2, param$3) {
            return Curry._2(loadQueryFn, CartDeleteButtonCartQuery_graphql.Internal.convertVariables(param), {
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
  ReactRelay.fetchQuery(environment, CartDeleteButtonCartQuery_graphql.node, CartDeleteButtonCartQuery_graphql.Internal.convertVariables(variables), {
          networkCacheConfig: networkCacheConfig,
          fetchPolicy: RescriptRelay.mapFetchQueryFetchPolicy(fetchPolicy)
        }).subscribe({
        next: (function (res) {
            Curry._1(onResult, {
                  TAG: /* Ok */0,
                  _0: CartDeleteButtonCartQuery_graphql.Internal.convertResponse(res)
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
  var __x = ReactRelay.fetchQuery(environment, CartDeleteButtonCartQuery_graphql.node, CartDeleteButtonCartQuery_graphql.Internal.convertVariables(variables), {
          networkCacheConfig: networkCacheConfig,
          fetchPolicy: RescriptRelay.mapFetchQueryFetchPolicy(fetchPolicy)
        }).toPromise();
  return Js_promise.then_((function (res) {
                return Promise.resolve(CartDeleteButtonCartQuery_graphql.Internal.convertResponse(res));
              }), __x);
}

function usePreloaded(queryRef, param) {
  var data = ReactRelay.usePreloadedQuery(CartDeleteButtonCartQuery_graphql.node, queryRef);
  return RescriptRelay_Internal.internal_useConvertedValue(CartDeleteButtonCartQuery_graphql.Internal.convertResponse, data);
}

function retain(environment, variables) {
  var operationDescriptor = RelayRuntime.createOperationDescriptor(CartDeleteButtonCartQuery_graphql.node, CartDeleteButtonCartQuery_graphql.Internal.convertVariables(variables));
  return environment.retain(operationDescriptor);
}

var CartQuery = {
  Operation: undefined,
  Types: undefined,
  use: use$1,
  useLoader: useLoader,
  $$fetch: $$fetch,
  fetchPromised: fetchPromised,
  usePreloaded: usePreloaded,
  retain: retain
};

function Cart_Delete_Button$Dialog(Props) {
  var show = Props.show;
  var setShow = Props.setShow;
  var n = Props.n;
  var confirmFnOpt = Props.confirmFn;
  var cancelFnOpt = Props.cancelFn;
  var confirmFn = confirmFnOpt !== undefined ? confirmFnOpt : (function (prim) {
        
      });
  var cancelFn = cancelFnOpt !== undefined ? cancelFnOpt : (function (prim) {
        
      });
  return React.createElement(ReactDialog.Root, {
              children: React.createElement(ReactDialog.Portal, {
                    children: null
                  }, React.createElement(ReactDialog.Overlay, {
                        className: "dialog-overlay"
                      }), React.createElement(ReactDialog.Content, {
                        children: null,
                        className: "dialog-content p-7 bg-white rounded-xl w-[480px] flex flex-col gap-7 items-center justify-center",
                        onOpenAutoFocus: (function (prim) {
                            prim.preventDefault();
                          })
                      }, React.createElement("span", {
                            className: "whitespace-pre text-center text-text-L1 pt-3"
                          }, "선택하신 상품 " + String(n) + "개를\n장바구니에서 삭제하시겠어요?"), React.createElement("div", {
                            className: "flex w-full justify-center items-center gap-2"
                          }, React.createElement("button", {
                                className: "w-1/2 rounded-xl h-13 bg-enabled-L5",
                                onClick: (function (param) {
                                    return ReactEvents.interceptingHandler((function (param) {
                                                  setShow(function (param) {
                                                        return false;
                                                      });
                                                  Curry._1(cancelFn, undefined);
                                                }), param);
                                  })
                              }, "취소"), React.createElement("button", {
                                className: "w-1/2 rounded-xl h-13 bg-red-100 text-notice font-bold",
                                onClick: (function (param) {
                                    return ReactEvents.interceptingHandler((function (param) {
                                                  Curry._1(confirmFn, undefined);
                                                  setShow(function (param) {
                                                        return false;
                                                      });
                                                }), param);
                                  })
                              }, "삭제")))),
              open: show
            });
}

var Dialog = {
  make: Cart_Delete_Button$Dialog
};

function Cart_Delete_Button$NoSelectDialog(Props) {
  var show = Props.show;
  var setShow = Props.setShow;
  return React.createElement(ReactDialog.Root, {
              children: React.createElement(ReactDialog.Portal, {
                    children: null
                  }, React.createElement(ReactDialog.Overlay, {
                        className: "dialog-overlay"
                      }), React.createElement(ReactDialog.Content, {
                        children: null,
                        className: "dialog-content p-7 bg-white rounded-xl w-[480px] flex flex-col gap-7 items-center justify-center",
                        onOpenAutoFocus: (function (prim) {
                            prim.preventDefault();
                          })
                      }, React.createElement("span", {
                            className: "whitespace-pre text-center text-text-L1 pt-3"
                          }, "삭제하실 상품을 선택해주세요"), React.createElement("div", {
                            className: "flex w-full justify-center items-center gap-2"
                          }, React.createElement("button", {
                                className: "w-1/2 rounded-xl h-13 bg-enabled-L5",
                                onClick: (function (param) {
                                    return ReactEvents.interceptingHandler((function (param) {
                                                  setShow(function (param) {
                                                        return false;
                                                      });
                                                }), param);
                                  })
                              }, "확인")))),
              open: show
            });
}

var NoSelectDialog = {
  make: Cart_Delete_Button$NoSelectDialog
};

function Cart_Delete_Button(Props) {
  var productOptions = Props.productOptions;
  var refetchCart = Props.refetchCart;
  var widthOpt = Props.width;
  var heightOpt = Props.height;
  var fillOpt = Props.fill;
  var childrenOpt = Props.children;
  var isIconOpt = Props.isIcon;
  var width = widthOpt !== undefined ? widthOpt : "1rem";
  var height = heightOpt !== undefined ? heightOpt : "1rem";
  var fill = fillOpt !== undefined ? fillOpt : "#727272";
  var children = childrenOpt !== undefined ? Caml_option.valFromOption(childrenOpt) : null;
  var isIcon = isIconOpt !== undefined ? isIconOpt : true;
  var match = ReactToastNotifications.useToasts();
  var addToast = match.addToast;
  var match$1 = React.useState(function () {
        return false;
      });
  var setShow = match$1[1];
  var match$2 = React.useState(function () {
        return false;
      });
  var setShowNoSelect = match$2[1];
  var handleError = function (message, param) {
    addToast(React.createElement("div", {
              className: "flex items-center w-full whitespace-pre-wrap"
            }, React.createElement(IconError.make, {
                  width: "24",
                  height: "24",
                  className: "mr-2"
                }), "상품 삭제에 실패하였습니다. " + Belt_Option.getWithDefault(message, "") + ""), {
          appearance: "error"
        });
  };
  var match$3 = use(undefined);
  var mutate = match$3[0];
  var match$4 = useLoader(undefined);
  var refreshCount = match$4[1];
  var confirmFn = function (param) {
    if (productOptions.length !== 0) {
      Curry.app(mutate, [
            (function (err) {
                handleError(err.message, undefined);
              }),
            (function (param, param$1) {
                var deleteCartItems = param.deleteCartItems;
                if (typeof deleteCartItems !== "object") {
                  return handleError(undefined, undefined);
                }
                var variant = deleteCartItems.NAME;
                if (variant === "DeleteCartItemsSuccess") {
                  addToast(React.createElement("div", {
                            className: "flex items-center"
                          }, React.createElement(IconCheck.make, {
                                height: "24",
                                width: "24",
                                fill: "#12B564",
                                className: "mr-2"
                              }), "" + String(deleteCartItems.VAL.count) + "개의 상품이 장바구니에서 삭제되었습니다."), {
                        appearance: "success"
                      });
                  Curry._4(refreshCount, undefined, /* StoreAndNetwork */2, undefined, undefined);
                  return Curry._1(refetchCart, undefined);
                } else if (variant === "Error") {
                  return handleError(Belt_Option.getWithDefault(deleteCartItems.VAL.message, ""), undefined);
                } else {
                  return handleError(undefined, undefined);
                }
              }),
            undefined,
            undefined,
            undefined,
            undefined,
            {
              optionIds: Belt_Array.map(productOptions, (function (option) {
                      return option.productOptionId;
                    }))
            },
            undefined,
            undefined
          ]);
      return ;
    } else {
      return handleError("삭제할 상품을 선택해주세요.", undefined);
    }
  };
  return React.createElement(React.Fragment, undefined, React.createElement(Cart_Delete_Button$Dialog, {
                  show: match$1[0],
                  setShow: setShow,
                  n: productOptions.length,
                  confirmFn: confirmFn
                }), React.createElement(Cart_Delete_Button$NoSelectDialog, {
                  show: match$2[0],
                  setShow: setShowNoSelect
                }), React.createElement("button", {
                  className: "self-baseline mt-1",
                  onClick: (function (param) {
                      return ReactEvents.interceptingHandler((function (param) {
                                    if (productOptions.length !== 0) {
                                      return setShow(function (param) {
                                                  return true;
                                                });
                                    } else {
                                      return setShowNoSelect(function (param) {
                                                  return true;
                                                });
                                    }
                                  }), param);
                    })
                }, isIcon ? React.createElement(IconClose.make, {
                        height: height,
                        width: width,
                        fill: fill
                      }) : children));
}

var Form;

var make = Cart_Delete_Button;

export {
  Form ,
  Mutation ,
  CartQuery ,
  Dialog ,
  NoSelectDialog ,
  make ,
}
/* react Not a pure module */
