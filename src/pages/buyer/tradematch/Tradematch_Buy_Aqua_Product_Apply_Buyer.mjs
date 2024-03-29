// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Curry from "rescript/lib/es6/curry.js";
import * as React from "react";
import * as DS_Toast from "../../../components/common/container/DS_Toast.mjs";
import * as DS_Button from "../../../components/common/element/DS_Button.mjs";
import * as DS_Dialog from "../../../components/common/container/DS_Dialog.mjs";
import * as IconError from "../../../components/svgs/IconError.mjs";
import * as Belt_Array from "rescript/lib/es6/belt_Array.js";
import * as Js_promise from "rescript/lib/es6/js_promise.js";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as CustomHooks from "../../../utils/CustomHooks.mjs";
import * as ReactRelay from "react-relay";
import * as Garter_Array from "@greenlabs/garter/src/Garter_Array.mjs";
import * as RescriptRelay from "rescript-relay/src/RescriptRelay.mjs";
import * as RelayRuntime from "relay-runtime";
import * as Js_null_undefined from "rescript/lib/es6/js_null_undefined.js";
import * as RescriptRelay_Internal from "rescript-relay/src/RescriptRelay_Internal.mjs";
import * as Tradematch_Header_Buyer from "./Tradematch_Header_Buyer.mjs";
import * as Tradematch_NotFound_Buyer from "./Tradematch_NotFound_Buyer.mjs";
import * as Tradematch_Skeleton_Buyer from "./Tradematch_Skeleton_Buyer.mjs";
import * as ReactToastNotifications from "react-toast-notifications";
import * as Tradematch_Buy_Aqua_Apply_Steps_Buyer from "../../../components/Tradematch_Buy_Aqua_Apply_Steps_Buyer.mjs";
import * as TradematchBuyAquaProductApplyBuyer_Query_graphql from "../../../__generated__/TradematchBuyAquaProductApplyBuyer_Query_graphql.mjs";
import * as TradematchBuyAquaProductApplyBuyerRefetchQuery_graphql from "../../../__generated__/TradematchBuyAquaProductApplyBuyerRefetchQuery_graphql.mjs";
import * as TradematchBuyAquaProductApplyBuyer_TradematchDemands_Query_graphql from "../../../__generated__/TradematchBuyAquaProductApplyBuyer_TradematchDemands_Query_graphql.mjs";
import * as TradematchBuyAquaProductApplyBuyer_TradematchDemands_Fragment_graphql from "../../../__generated__/TradematchBuyAquaProductApplyBuyer_TradematchDemands_Fragment_graphql.mjs";
import * as TradematchBuyAquaProductApplyBuyer_DeleteTradematchDemand_Mutation_graphql from "../../../__generated__/TradematchBuyAquaProductApplyBuyer_DeleteTradematchDemand_Mutation_graphql.mjs";

function use(variables, fetchPolicy, fetchKey, networkCacheConfig, param) {
  var data = ReactRelay.useLazyLoadQuery(TradematchBuyAquaProductApplyBuyer_Query_graphql.node, RescriptRelay_Internal.internal_cleanObjectFromUndefinedRaw(TradematchBuyAquaProductApplyBuyer_Query_graphql.Internal.convertVariables(variables)), {
        fetchKey: fetchKey,
        fetchPolicy: RescriptRelay.mapFetchPolicy(fetchPolicy),
        networkCacheConfig: networkCacheConfig
      });
  return RescriptRelay_Internal.internal_useConvertedValue(TradematchBuyAquaProductApplyBuyer_Query_graphql.Internal.convertResponse, data);
}

function useLoader(param) {
  var match = ReactRelay.useQueryLoader(TradematchBuyAquaProductApplyBuyer_Query_graphql.node);
  var loadQueryFn = match[1];
  var loadQuery = React.useMemo((function () {
          return function (param, param$1, param$2, param$3) {
            return Curry._2(loadQueryFn, TradematchBuyAquaProductApplyBuyer_Query_graphql.Internal.convertVariables(param), {
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
  ReactRelay.fetchQuery(environment, TradematchBuyAquaProductApplyBuyer_Query_graphql.node, TradematchBuyAquaProductApplyBuyer_Query_graphql.Internal.convertVariables(variables), {
          networkCacheConfig: networkCacheConfig,
          fetchPolicy: RescriptRelay.mapFetchQueryFetchPolicy(fetchPolicy)
        }).subscribe({
        next: (function (res) {
            Curry._1(onResult, {
                  TAG: /* Ok */0,
                  _0: TradematchBuyAquaProductApplyBuyer_Query_graphql.Internal.convertResponse(res)
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
  var __x = ReactRelay.fetchQuery(environment, TradematchBuyAquaProductApplyBuyer_Query_graphql.node, TradematchBuyAquaProductApplyBuyer_Query_graphql.Internal.convertVariables(variables), {
          networkCacheConfig: networkCacheConfig,
          fetchPolicy: RescriptRelay.mapFetchQueryFetchPolicy(fetchPolicy)
        }).toPromise();
  return Js_promise.then_((function (res) {
                return Promise.resolve(TradematchBuyAquaProductApplyBuyer_Query_graphql.Internal.convertResponse(res));
              }), __x);
}

function usePreloaded(queryRef, param) {
  var data = ReactRelay.usePreloadedQuery(TradematchBuyAquaProductApplyBuyer_Query_graphql.node, queryRef);
  return RescriptRelay_Internal.internal_useConvertedValue(TradematchBuyAquaProductApplyBuyer_Query_graphql.Internal.convertResponse, data);
}

function retain(environment, variables) {
  var operationDescriptor = RelayRuntime.createOperationDescriptor(TradematchBuyAquaProductApplyBuyer_Query_graphql.node, TradematchBuyAquaProductApplyBuyer_Query_graphql.Internal.convertVariables(variables));
  return environment.retain(operationDescriptor);
}

var Product = {
  Operation: undefined,
  Types: undefined,
  use: use,
  useLoader: useLoader,
  $$fetch: $$fetch,
  fetchPromised: fetchPromised,
  usePreloaded: usePreloaded,
  retain: retain
};

function use$1(variables, fetchPolicy, fetchKey, networkCacheConfig, param) {
  var data = ReactRelay.useLazyLoadQuery(TradematchBuyAquaProductApplyBuyer_TradematchDemands_Query_graphql.node, RescriptRelay_Internal.internal_cleanObjectFromUndefinedRaw(TradematchBuyAquaProductApplyBuyer_TradematchDemands_Query_graphql.Internal.convertVariables(variables)), {
        fetchKey: fetchKey,
        fetchPolicy: RescriptRelay.mapFetchPolicy(fetchPolicy),
        networkCacheConfig: networkCacheConfig
      });
  return RescriptRelay_Internal.internal_useConvertedValue(TradematchBuyAquaProductApplyBuyer_TradematchDemands_Query_graphql.Internal.convertResponse, data);
}

function useLoader$1(param) {
  var match = ReactRelay.useQueryLoader(TradematchBuyAquaProductApplyBuyer_TradematchDemands_Query_graphql.node);
  var loadQueryFn = match[1];
  var loadQuery = React.useMemo((function () {
          return function (param, param$1, param$2, param$3) {
            return Curry._2(loadQueryFn, TradematchBuyAquaProductApplyBuyer_TradematchDemands_Query_graphql.Internal.convertVariables(param), {
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

function $$fetch$1(environment, variables, onResult, networkCacheConfig, fetchPolicy, param) {
  ReactRelay.fetchQuery(environment, TradematchBuyAquaProductApplyBuyer_TradematchDemands_Query_graphql.node, TradematchBuyAquaProductApplyBuyer_TradematchDemands_Query_graphql.Internal.convertVariables(variables), {
          networkCacheConfig: networkCacheConfig,
          fetchPolicy: RescriptRelay.mapFetchQueryFetchPolicy(fetchPolicy)
        }).subscribe({
        next: (function (res) {
            Curry._1(onResult, {
                  TAG: /* Ok */0,
                  _0: TradematchBuyAquaProductApplyBuyer_TradematchDemands_Query_graphql.Internal.convertResponse(res)
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

function fetchPromised$1(environment, variables, networkCacheConfig, fetchPolicy, param) {
  var __x = ReactRelay.fetchQuery(environment, TradematchBuyAquaProductApplyBuyer_TradematchDemands_Query_graphql.node, TradematchBuyAquaProductApplyBuyer_TradematchDemands_Query_graphql.Internal.convertVariables(variables), {
          networkCacheConfig: networkCacheConfig,
          fetchPolicy: RescriptRelay.mapFetchQueryFetchPolicy(fetchPolicy)
        }).toPromise();
  return Js_promise.then_((function (res) {
                return Promise.resolve(TradematchBuyAquaProductApplyBuyer_TradematchDemands_Query_graphql.Internal.convertResponse(res));
              }), __x);
}

function usePreloaded$1(queryRef, param) {
  var data = ReactRelay.usePreloadedQuery(TradematchBuyAquaProductApplyBuyer_TradematchDemands_Query_graphql.node, queryRef);
  return RescriptRelay_Internal.internal_useConvertedValue(TradematchBuyAquaProductApplyBuyer_TradematchDemands_Query_graphql.Internal.convertResponse, data);
}

function retain$1(environment, variables) {
  var operationDescriptor = RelayRuntime.createOperationDescriptor(TradematchBuyAquaProductApplyBuyer_TradematchDemands_Query_graphql.node, TradematchBuyAquaProductApplyBuyer_TradematchDemands_Query_graphql.Internal.convertVariables(variables));
  return environment.retain(operationDescriptor);
}

var TradematchDemands_orderDirection_decode = TradematchBuyAquaProductApplyBuyer_TradematchDemands_Query_graphql.Utils.orderDirection_decode;

var TradematchDemands_orderDirection_fromString = TradematchBuyAquaProductApplyBuyer_TradematchDemands_Query_graphql.Utils.orderDirection_fromString;

var TradematchDemands_tradematchDemandOrderBy_decode = TradematchBuyAquaProductApplyBuyer_TradematchDemands_Query_graphql.Utils.tradematchDemandOrderBy_decode;

var TradematchDemands_tradematchDemandOrderBy_fromString = TradematchBuyAquaProductApplyBuyer_TradematchDemands_Query_graphql.Utils.tradematchDemandOrderBy_fromString;

var TradematchDemands_tradematchDemandStatus_decode = TradematchBuyAquaProductApplyBuyer_TradematchDemands_Query_graphql.Utils.tradematchDemandStatus_decode;

var TradematchDemands_tradematchDemandStatus_fromString = TradematchBuyAquaProductApplyBuyer_TradematchDemands_Query_graphql.Utils.tradematchDemandStatus_fromString;

var TradematchDemands_tradematchProductType_decode = TradematchBuyAquaProductApplyBuyer_TradematchDemands_Query_graphql.Utils.tradematchProductType_decode;

var TradematchDemands_tradematchProductType_fromString = TradematchBuyAquaProductApplyBuyer_TradematchDemands_Query_graphql.Utils.tradematchProductType_fromString;

var TradematchDemands = {
  orderDirection_decode: TradematchDemands_orderDirection_decode,
  orderDirection_fromString: TradematchDemands_orderDirection_fromString,
  tradematchDemandOrderBy_decode: TradematchDemands_tradematchDemandOrderBy_decode,
  tradematchDemandOrderBy_fromString: TradematchDemands_tradematchDemandOrderBy_fromString,
  tradematchDemandStatus_decode: TradematchDemands_tradematchDemandStatus_decode,
  tradematchDemandStatus_fromString: TradematchDemands_tradematchDemandStatus_fromString,
  tradematchProductType_decode: TradematchDemands_tradematchProductType_decode,
  tradematchProductType_fromString: TradematchDemands_tradematchProductType_fromString,
  Operation: undefined,
  Types: undefined,
  use: use$1,
  useLoader: useLoader$1,
  $$fetch: $$fetch$1,
  fetchPromised: fetchPromised$1,
  usePreloaded: usePreloaded$1,
  retain: retain$1
};

var Query = {
  Product: Product,
  TradematchDemands: TradematchDemands
};

var getConnectionNodes = TradematchBuyAquaProductApplyBuyer_TradematchDemands_Fragment_graphql.Utils.getConnectionNodes;

function internal_makeRefetchableFnOpts(fetchPolicy, onComplete, param) {
  var tmp = {};
  var tmp$1 = RescriptRelay.mapFetchPolicy(fetchPolicy);
  if (tmp$1 !== undefined) {
    tmp.fetchPolicy = Caml_option.valFromOption(tmp$1);
  }
  var tmp$2 = RescriptRelay_Internal.internal_nullableToOptionalExnHandler(onComplete);
  if (tmp$2 !== undefined) {
    tmp.onComplete = Caml_option.valFromOption(tmp$2);
  }
  return tmp;
}

function useRefetchable(fRef) {
  var match = ReactRelay.useRefetchableFragment(TradematchBuyAquaProductApplyBuyer_TradematchDemands_Fragment_graphql.node, fRef);
  var refetchFn = match[1];
  var data = RescriptRelay_Internal.internal_useConvertedValue(TradematchBuyAquaProductApplyBuyer_TradematchDemands_Fragment_graphql.Internal.convertFragment, match[0]);
  return [
          data,
          React.useMemo((function () {
                  return function (param, param$1, param$2, param$3) {
                    return Curry._2(refetchFn, RescriptRelay_Internal.internal_removeUndefinedAndConvertNullsRaw(TradematchBuyAquaProductApplyBuyerRefetchQuery_graphql.Internal.convertVariables(param)), internal_makeRefetchableFnOpts(param$1, param$2, undefined));
                  };
                }), [refetchFn])
        ];
}

function use$2(fRef) {
  var data = ReactRelay.useFragment(TradematchBuyAquaProductApplyBuyer_TradematchDemands_Fragment_graphql.node, fRef);
  return RescriptRelay_Internal.internal_useConvertedValue(TradematchBuyAquaProductApplyBuyer_TradematchDemands_Fragment_graphql.Internal.convertFragment, data);
}

function useOpt(opt_fRef) {
  var fr = opt_fRef !== undefined ? Caml_option.some(Caml_option.valFromOption(opt_fRef)) : undefined;
  var nullableFragmentData = ReactRelay.useFragment(TradematchBuyAquaProductApplyBuyer_TradematchDemands_Fragment_graphql.node, fr !== undefined ? Js_null_undefined.fromOption(Caml_option.some(Caml_option.valFromOption(fr))) : null);
  var data = (nullableFragmentData == null) ? undefined : Caml_option.some(nullableFragmentData);
  return RescriptRelay_Internal.internal_useConvertedValue((function (rawFragment) {
                if (rawFragment !== undefined) {
                  return TradematchBuyAquaProductApplyBuyer_TradematchDemands_Fragment_graphql.Internal.convertFragment(rawFragment);
                }
                
              }), data);
}

function usePagination(fr) {
  var p = ReactRelay.usePaginationFragment(TradematchBuyAquaProductApplyBuyer_TradematchDemands_Fragment_graphql.node, fr);
  var data = RescriptRelay_Internal.internal_useConvertedValue(TradematchBuyAquaProductApplyBuyer_TradematchDemands_Fragment_graphql.Internal.convertFragment, p.data);
  return {
          data: data,
          loadNext: React.useMemo((function () {
                  return function (param, param$1, param$2) {
                    return p.loadNext(param, {
                                onComplete: RescriptRelay_Internal.internal_nullableToOptionalExnHandler(param$1)
                              });
                  };
                }), [p.loadNext]),
          loadPrevious: React.useMemo((function () {
                  return function (param, param$1, param$2) {
                    return p.loadPrevious(param, {
                                onComplete: RescriptRelay_Internal.internal_nullableToOptionalExnHandler(param$1)
                              });
                  };
                }), [p.loadPrevious]),
          hasNext: p.hasNext,
          hasPrevious: p.hasPrevious,
          isLoadingNext: p.isLoadingNext,
          isLoadingPrevious: p.isLoadingPrevious,
          refetch: React.useMemo((function () {
                  return function (param, param$1, param$2, param$3) {
                    return p.refetch(RescriptRelay_Internal.internal_cleanObjectFromUndefinedRaw(TradematchBuyAquaProductApplyBuyerRefetchQuery_graphql.Internal.convertVariables(param)), internal_makeRefetchableFnOpts(param$1, param$2, undefined));
                  };
                }), [p.refetch])
        };
}

function useBlockingPagination(fRef) {
  var p = ReactRelay.useBlockingPaginationFragment(TradematchBuyAquaProductApplyBuyer_TradematchDemands_Fragment_graphql.node, fRef);
  var data = RescriptRelay_Internal.internal_useConvertedValue(TradematchBuyAquaProductApplyBuyer_TradematchDemands_Fragment_graphql.Internal.convertFragment, p.data);
  return {
          data: data,
          loadNext: React.useMemo((function () {
                  return function (param, param$1, param$2) {
                    return p.loadNext(param, {
                                onComplete: RescriptRelay_Internal.internal_nullableToOptionalExnHandler(param$1)
                              });
                  };
                }), [p.loadNext]),
          loadPrevious: React.useMemo((function () {
                  return function (param, param$1, param$2) {
                    return p.loadPrevious(param, {
                                onComplete: RescriptRelay_Internal.internal_nullableToOptionalExnHandler(param$1)
                              });
                  };
                }), [p.loadPrevious]),
          hasNext: p.hasNext,
          hasPrevious: p.hasPrevious,
          refetch: React.useMemo((function () {
                  return function (param, param$1, param$2, param$3) {
                    return p.refetch(RescriptRelay_Internal.internal_cleanObjectFromUndefinedRaw(TradematchBuyAquaProductApplyBuyerRefetchQuery_graphql.Internal.convertVariables(param)), internal_makeRefetchableFnOpts(param$1, param$2, undefined));
                  };
                }), [p.refetch])
        };
}

var makeRefetchVariables = TradematchBuyAquaProductApplyBuyerRefetchQuery_graphql.Types.makeRefetchVariables;

var TradematchDemands$1 = {
  getConnectionNodes: getConnectionNodes,
  Types: undefined,
  internal_makeRefetchableFnOpts: internal_makeRefetchableFnOpts,
  useRefetchable: useRefetchable,
  Operation: undefined,
  use: use$2,
  useOpt: useOpt,
  usePagination: usePagination,
  useBlockingPagination: useBlockingPagination,
  makeRefetchVariables: makeRefetchVariables
};

var Fragment = {
  TradematchDemands: TradematchDemands$1
};

function commitMutation(environment, variables, optimisticUpdater, optimisticResponse, updater, onCompleted, onError, uploadables, param) {
  return RelayRuntime.commitMutation(environment, {
              mutation: TradematchBuyAquaProductApplyBuyer_DeleteTradematchDemand_Mutation_graphql.node,
              variables: TradematchBuyAquaProductApplyBuyer_DeleteTradematchDemand_Mutation_graphql.Internal.convertVariables(variables),
              onCompleted: (function (res, err) {
                  if (onCompleted !== undefined) {
                    return Curry._2(onCompleted, TradematchBuyAquaProductApplyBuyer_DeleteTradematchDemand_Mutation_graphql.Internal.convertResponse(res), (err == null) ? undefined : Caml_option.some(err));
                  }
                  
                }),
              onError: (function (err) {
                  if (onError !== undefined) {
                    return Curry._1(onError, (err == null) ? undefined : Caml_option.some(err));
                  }
                  
                }),
              optimisticResponse: optimisticResponse !== undefined ? TradematchBuyAquaProductApplyBuyer_DeleteTradematchDemand_Mutation_graphql.Internal.convertWrapRawResponse(optimisticResponse) : undefined,
              optimisticUpdater: optimisticUpdater,
              updater: updater !== undefined ? (function (store, r) {
                    Curry._2(updater, store, TradematchBuyAquaProductApplyBuyer_DeleteTradematchDemand_Mutation_graphql.Internal.convertResponse(r));
                  }) : undefined,
              uploadables: uploadables
            });
}

function use$3(param) {
  var match = ReactRelay.useMutation(TradematchBuyAquaProductApplyBuyer_DeleteTradematchDemand_Mutation_graphql.node);
  var mutate = match[0];
  return [
          React.useMemo((function () {
                  return function (param, param$1, param$2, param$3, param$4, param$5, param$6, param$7, param$8) {
                    return Curry._1(mutate, {
                                onError: param,
                                onCompleted: param$1 !== undefined ? (function (r, errors) {
                                      Curry._2(param$1, TradematchBuyAquaProductApplyBuyer_DeleteTradematchDemand_Mutation_graphql.Internal.convertResponse(r), (errors == null) ? undefined : Caml_option.some(errors));
                                    }) : undefined,
                                onUnsubscribe: param$2,
                                optimisticResponse: param$3 !== undefined ? TradematchBuyAquaProductApplyBuyer_DeleteTradematchDemand_Mutation_graphql.Internal.convertWrapRawResponse(param$3) : undefined,
                                optimisticUpdater: param$4,
                                updater: param$5 !== undefined ? (function (store, r) {
                                      Curry._2(param$5, store, TradematchBuyAquaProductApplyBuyer_DeleteTradematchDemand_Mutation_graphql.Internal.convertResponse(r));
                                    }) : undefined,
                                variables: TradematchBuyAquaProductApplyBuyer_DeleteTradematchDemand_Mutation_graphql.Internal.convertVariables(param$6),
                                uploadables: param$7
                              });
                  };
                }), [mutate]),
          match[1]
        ];
}

var DeleteTradematchDemand = {
  Operation: undefined,
  Types: undefined,
  commitMutation: commitMutation,
  use: use$3
};

var Mutation = {
  DeleteTradematchDemand: DeleteTradematchDemand
};

function Tradematch_Buy_Aqua_Product_Apply_Buyer$ProgressBar(Props) {
  var match = CustomHooks.AquaTradematchStep.use(undefined);
  var percentage = (match.currentIndex + 1 | 0) / (match.length + 1 | 0) * 100;
  var style = {
    width: "" + String(percentage) + "%"
  };
  return React.createElement("div", {
              className: "max-w-3xl fixed h-1 w-full bg-surface z-[10]"
            }, React.createElement("div", {
                  className: "absolute left-0 top-0 bg-primary z-30 h-full transition-all",
                  style: style
                }));
}

var ProgressBar = {
  make: Tradematch_Buy_Aqua_Product_Apply_Buyer$ProgressBar
};

function getNextStep(demand) {
  var stringToOption = function (str) {
    if (str.length > 0) {
      return str;
    }
    
  };
  var match = stringToOption(demand.productOrigin);
  var match$1 = stringToOption(demand.productStorageMethod);
  var match$2 = stringToOption(demand.tradeCycle);
  var match$3 = Belt_Array.every([
        demand.productProcess,
        demand.productSize,
        demand.productRequirements
      ], (function (s) {
          return s.length > 0;
        }));
  if (match !== undefined) {
    if (demand.numberOfPackagesPerTrade !== undefined) {
      if (demand.wantedPricePerPackage !== undefined) {
        if (match$1 !== undefined) {
          if (match$2 !== undefined) {
            if (match$3) {
              return /* Shipping */6;
            } else {
              return /* Requirement */5;
            }
          } else {
            return /* Cycle */4;
          }
        } else {
          return /* StorageMethod */3;
        }
      } else {
        return /* Price */2;
      }
    } else {
      return /* Weight */1;
    }
  } else {
    return /* Origin */0;
  }
}

function Tradematch_Buy_Aqua_Product_Apply_Buyer$StatusChecker(Props) {
  var currentDemand = Props.currentDemand;
  var connectionId = Props.connectionId;
  var children = Props.children;
  var match = CustomHooks.AquaTradematchStep.use(undefined);
  var match$1 = match.router;
  var replace = match$1.replace;
  var toFirst = match$1.toFirst;
  var isFirst = match.isFirst;
  var match$2 = ReactToastNotifications.useToasts();
  var addToast = match$2.addToast;
  var nextStep = Belt_Option.map(currentDemand, getNextStep);
  var match$3 = React.useState(function () {
        return Belt_Option.isSome(nextStep);
      });
  var setContinueDraft = match$3[1];
  var showContinueDraft = match$3[0];
  var match$4 = use$3(undefined);
  var deleteMutate = match$4[0];
  React.useLayoutEffect((function () {
          if (isFirst || nextStep !== undefined) {
            
          } else {
            Curry._1(toFirst, undefined);
          }
        }), []);
  return React.createElement(React.Fragment, undefined, showContinueDraft ? React.createElement(React.Fragment, undefined, React.createElement(Tradematch_Header_Buyer.make, {}), React.createElement(Tradematch_Skeleton_Buyer.make, {})) : children, React.createElement(DS_Dialog.Popup.Root.make, {
                  children: React.createElement(DS_Dialog.Popup.Portal.make, {
                        children: null
                      }, React.createElement(DS_Dialog.Popup.Overlay.make, {}), React.createElement(DS_Dialog.Popup.Content.make, {
                            children: null
                          }, React.createElement(DS_Dialog.Popup.Title.make, {
                                children: "작성중인 견적서가 있습니다."
                              }), React.createElement(DS_Dialog.Popup.Description.make, {
                                children: "이어서 작성하시겠어요?"
                              }), React.createElement(DS_Dialog.Popup.Buttons.make, {
                                children: null
                              }, React.createElement(DS_Dialog.Popup.Close.make, {
                                    children: React.createElement(DS_Button.Normal.Large1.make, {
                                          label: "새로 작성하기",
                                          onClick: (function (param) {
                                              if (currentDemand !== undefined) {
                                                Curry.app(deleteMutate, [
                                                      (function (err) {
                                                          addToast(React.createElement("div", {
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
                                                          var deleteTradematchDemand = param.deleteTradematchDemand;
                                                          if (typeof deleteTradematchDemand === "object" && deleteTradematchDemand.NAME === "DeleteSuccess") {
                                                            setContinueDraft(function (param) {
                                                                  return false;
                                                                });
                                                            return Curry._1(toFirst, undefined);
                                                          } else {
                                                            return addToast(DS_Toast.getToastComponent("요청 중 오류가 발생했습니다. 잠시 후 다시 시도해주세요.", "error"), {
                                                                        appearance: "error"
                                                                      });
                                                          }
                                                        }),
                                                      undefined,
                                                      undefined,
                                                      undefined,
                                                      undefined,
                                                      {
                                                        connections: [connectionId],
                                                        id: currentDemand.id
                                                      },
                                                      undefined,
                                                      undefined
                                                    ]);
                                                return ;
                                              }
                                              
                                            }),
                                          buttonType: "white"
                                        }),
                                    asChild: true
                                  }), React.createElement(DS_Dialog.Popup.Close.make, {
                                    children: React.createElement(DS_Button.Normal.Large1.make, {
                                          label: "이어서 작성하기",
                                          onClick: (function (param) {
                                              setContinueDraft(function (param) {
                                                    return false;
                                                  });
                                              if (nextStep !== undefined) {
                                                return Curry._1(replace, nextStep);
                                              } else {
                                                return Curry._1(toFirst, undefined);
                                              }
                                            })
                                        }),
                                    asChild: true
                                  })))),
                  open: showContinueDraft
                }));
}

var StatusChecker = {
  getNextStep: getNextStep,
  make: Tradematch_Buy_Aqua_Product_Apply_Buyer$StatusChecker
};

function Tradematch_Buy_Aqua_Product_Apply_Buyer$Content(Props) {
  var pid = Props.pid;
  var match = CustomHooks.AquaTradematchStep.use(undefined);
  var match$1 = match.router;
  var toFirst = match$1.toFirst;
  var draftStatusTradematchDemands = use$1({
        first: 100,
        orderBy: "DRAFTED_AT",
        orderDirection: "DESC",
        productIds: [pid],
        productTypes: ["AQUATIC"],
        statuses: ["DRAFT"]
      }, /* NetworkOnly */3, undefined, undefined, undefined);
  var match$2 = usePagination(draftStatusTradematchDemands.fragmentRefs);
  var tradematchDemands = match$2.data.tradematchDemands;
  var currentDemand = Garter_Array.first(Curry._1(getConnectionNodes, tradematchDemands));
  var connectionId = tradematchDemands.__id;
  var match$3 = Belt_Option.map(currentDemand, (function (param) {
          return param.id;
        }));
  var tmp;
  switch (match.current) {
    case /* Origin */0 :
        var tmp$1 = {
          connectionId: connectionId,
          productId: pid
        };
        var tmp$2 = Belt_Option.map(currentDemand, (function (param) {
                return param.productOrigin;
              }));
        if (tmp$2 !== undefined) {
          tmp$1.defaultOrigin = Caml_option.valFromOption(tmp$2);
        }
        if (match$3 !== undefined) {
          tmp$1.demandId = Caml_option.valFromOption(match$3);
        }
        tmp = React.createElement(Tradematch_Buy_Aqua_Apply_Steps_Buyer.Origin.make, tmp$1);
        break;
    case /* Weight */1 :
        if (match$3 !== undefined) {
          var tmp$3 = {
            demandId: match$3
          };
          var tmp$4 = Belt_Option.map(Belt_Option.flatMap(currentDemand, (function (param) {
                      return param.numberOfPackagesPerTrade;
                    })), (function (prim) {
                  return String(prim);
                }));
          if (tmp$4 !== undefined) {
            tmp$3.defaultWeight = Caml_option.valFromOption(tmp$4);
          }
          tmp = React.createElement(Tradematch_Buy_Aqua_Apply_Steps_Buyer.Weight.make, tmp$3);
        } else {
          Curry._1(toFirst, undefined);
          tmp = null;
        }
        break;
    case /* Price */2 :
        if (match$3 !== undefined) {
          var weight$p = Belt_Option.flatMap(currentDemand, (function (param) {
                  return param.numberOfPackagesPerTrade;
                }));
          if (weight$p !== undefined) {
            var tmp$5 = {
              demandId: match$3,
              currentWeight: weight$p
            };
            var tmp$6 = Belt_Option.map(Belt_Option.flatMap(currentDemand, (function (param) {
                        return param.wantedPricePerPackage;
                      })), (function (prim) {
                    return String(prim);
                  }));
            if (tmp$6 !== undefined) {
              tmp$5.defaultPrice = Caml_option.valFromOption(tmp$6);
            }
            tmp = React.createElement(Tradematch_Buy_Aqua_Apply_Steps_Buyer.Price.make, tmp$5);
          } else {
            Curry._1(match$1.replace, /* Weight */1);
            tmp = null;
          }
        } else {
          Curry._1(toFirst, undefined);
          tmp = null;
        }
        break;
    case /* StorageMethod */3 :
        if (match$3 !== undefined) {
          var tmp$7 = {
            demandId: match$3
          };
          var tmp$8 = Belt_Option.flatMap(currentDemand, (function (param) {
                  return Tradematch_Buy_Aqua_Apply_Steps_Buyer.StorageMethod.fromString(param.productStorageMethod);
                }));
          if (tmp$8 !== undefined) {
            tmp$7.defaultStorageMethod = Caml_option.valFromOption(tmp$8);
          }
          tmp = React.createElement(Tradematch_Buy_Aqua_Apply_Steps_Buyer.StorageMethod.make, tmp$7);
        } else {
          Curry._1(toFirst, undefined);
          tmp = null;
        }
        break;
    case /* Cycle */4 :
        if (match$3 !== undefined) {
          var tmp$9 = {
            demandId: match$3
          };
          var tmp$10 = Belt_Option.flatMap(currentDemand, (function (param) {
                  return Tradematch_Buy_Aqua_Apply_Steps_Buyer.Cycle.fromString(param.tradeCycle);
                }));
          if (tmp$10 !== undefined) {
            tmp$9.defaultCycle = Caml_option.valFromOption(tmp$10);
          }
          tmp = React.createElement(Tradematch_Buy_Aqua_Apply_Steps_Buyer.Cycle.make, tmp$9);
        } else {
          Curry._1(toFirst, undefined);
          tmp = null;
        }
        break;
    case /* Requirement */5 :
        if (match$3 !== undefined) {
          var match$4 = Belt_Option.mapWithDefault(currentDemand, [
                undefined,
                undefined,
                undefined
              ], (function (param) {
                  return [
                          param.productSize,
                          param.productProcess,
                          param.productRequirements
                        ];
                }));
          var tmp$11 = {
            demandId: match$3
          };
          var tmp$12 = match$4[0];
          if (tmp$12 !== undefined) {
            tmp$11.defaultSize = Caml_option.valFromOption(tmp$12);
          }
          var tmp$13 = match$4[1];
          if (tmp$13 !== undefined) {
            tmp$11.defaultProcess = Caml_option.valFromOption(tmp$13);
          }
          var tmp$14 = match$4[2];
          if (tmp$14 !== undefined) {
            tmp$11.defaultRequirements = Caml_option.valFromOption(tmp$14);
          }
          tmp = React.createElement(Tradematch_Buy_Aqua_Apply_Steps_Buyer.Requirement.make, tmp$11);
        } else {
          Curry._1(toFirst, undefined);
          tmp = null;
        }
        break;
    case /* Shipping */6 :
        if (match$3 !== undefined) {
          tmp = React.createElement(Tradematch_Buy_Aqua_Apply_Steps_Buyer.Shipping.make, {
                demandId: match$3
              });
        } else {
          Curry._1(toFirst, undefined);
          tmp = null;
        }
        break;
    
  }
  return React.createElement(Tradematch_Buy_Aqua_Product_Apply_Buyer$StatusChecker, {
              currentDemand: currentDemand,
              connectionId: connectionId,
              children: null
            }, React.createElement(Tradematch_Buy_Aqua_Product_Apply_Buyer$ProgressBar, {}), tmp);
}

var Content = {
  make: Tradematch_Buy_Aqua_Product_Apply_Buyer$Content
};

function Tradematch_Buy_Aqua_Product_Apply_Buyer(Props) {
  var pNumber = Props.pNumber;
  var match = use({
        productNumber: pNumber
      }, undefined, undefined, undefined, undefined);
  var match$1 = Belt_Option.map(match.product, (function (param) {
          return [
                  param.category,
                  param.id
                ];
        }));
  if (match$1 !== undefined) {
    return React.createElement(React.Fragment, undefined, React.createElement(Tradematch_Header_Buyer.make, {
                    title: "" + match$1[0].name + " 견적신청"
                  }), React.createElement(Tradematch_Buy_Aqua_Product_Apply_Buyer$Content, {
                    pid: match$1[1]
                  }));
  } else {
    return React.createElement(React.Fragment, undefined, React.createElement(Tradematch_Header_Buyer.make, {
                    title: ""
                  }), React.createElement(Tradematch_Skeleton_Buyer.make, {}), React.createElement(Tradematch_NotFound_Buyer.make, {}));
  }
}

var make = Tradematch_Buy_Aqua_Product_Apply_Buyer;

export {
  Query ,
  Fragment ,
  Mutation ,
  ProgressBar ,
  StatusChecker ,
  Content ,
  make ,
}
/* react Not a pure module */
