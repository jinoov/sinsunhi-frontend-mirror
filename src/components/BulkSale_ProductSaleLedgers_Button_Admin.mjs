// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Curry from "rescript/lib/es6/curry.js";
import * as React from "react";
import * as IconPlus from "./svgs/IconPlus.mjs";
import * as IconCheck from "./svgs/IconCheck.mjs";
import * as IconClose from "./svgs/IconClose.mjs";
import * as IconError from "./svgs/IconError.mjs";
import * as Belt_Array from "rescript/lib/es6/belt_Array.js";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as Garter_Array from "@greenlabs/garter/src/Garter_Array.mjs";
import * as RescriptRelay from "rescript-relay/src/RescriptRelay.mjs";
import * as RelayRuntime from "relay-runtime";
import GetTime from "date-fns/getTime";
import * as Js_null_undefined from "rescript/lib/es6/js_null_undefined.js";
import * as Hooks from "react-relay/hooks";
import * as ReactDialog from "@radix-ui/react-dialog";
import * as RescriptRelay_Internal from "rescript-relay/src/RescriptRelay_Internal.mjs";
import * as ReactToastNotifications from "react-toast-notifications";
import * as BulkSale_ProductSaleLedgers_Button_Create_Admin from "./BulkSale_ProductSaleLedgers_Button_Create_Admin.mjs";
import * as BulkSale_ProductSaleLedgers_Button_Update_Admin from "./BulkSale_ProductSaleLedgers_Button_Update_Admin.mjs";
import * as BulkSaleProductSaleLedgersButtonAdminFragment_graphql from "../__generated__/BulkSaleProductSaleLedgersButtonAdminFragment_graphql.mjs";
import * as BulkSaleProductSaleLedgersButtonAdminRefetchQuery_graphql from "../__generated__/BulkSaleProductSaleLedgersButtonAdminRefetchQuery_graphql.mjs";
import * as BulkSaleProductSaleLedgersButtonAdminDeleteMutation_graphql from "../__generated__/BulkSaleProductSaleLedgersButtonAdminDeleteMutation_graphql.mjs";

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
  var match = Hooks.useRefetchableFragment(BulkSaleProductSaleLedgersButtonAdminFragment_graphql.node, fRef);
  var refetchFn = match[1];
  var data = RescriptRelay_Internal.internal_useConvertedValue(BulkSaleProductSaleLedgersButtonAdminFragment_graphql.Internal.convertFragment, match[0]);
  return [
          data,
          React.useMemo((function () {
                  return function (param, param$1, param$2, param$3) {
                    return Curry._2(refetchFn, RescriptRelay_Internal.internal_cleanObjectFromUndefinedRaw(BulkSaleProductSaleLedgersButtonAdminRefetchQuery_graphql.Internal.convertVariables(param)), internal_makeRefetchableFnOpts(param$1, param$2, undefined));
                  };
                }), [refetchFn])
        ];
}

function use(fRef) {
  var data = Hooks.useFragment(BulkSaleProductSaleLedgersButtonAdminFragment_graphql.node, fRef);
  return RescriptRelay_Internal.internal_useConvertedValue(BulkSaleProductSaleLedgersButtonAdminFragment_graphql.Internal.convertFragment, data);
}

function useOpt(opt_fRef) {
  var fr = opt_fRef !== undefined ? Caml_option.some(Caml_option.valFromOption(opt_fRef)) : undefined;
  var nullableFragmentData = Hooks.useFragment(BulkSaleProductSaleLedgersButtonAdminFragment_graphql.node, fr !== undefined ? Js_null_undefined.fromOption(Caml_option.some(Caml_option.valFromOption(fr))) : null);
  var data = (nullableFragmentData == null) ? undefined : Caml_option.some(nullableFragmentData);
  return RescriptRelay_Internal.internal_useConvertedValue((function (rawFragment) {
                if (rawFragment !== undefined) {
                  return BulkSaleProductSaleLedgersButtonAdminFragment_graphql.Internal.convertFragment(rawFragment);
                }
                
              }), data);
}

function usePagination(fr) {
  var p = Hooks.usePaginationFragment(BulkSaleProductSaleLedgersButtonAdminFragment_graphql.node, fr);
  var data = RescriptRelay_Internal.internal_useConvertedValue(BulkSaleProductSaleLedgersButtonAdminFragment_graphql.Internal.convertFragment, p.data);
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
                    return p.refetch(RescriptRelay_Internal.internal_cleanObjectFromUndefinedRaw(BulkSaleProductSaleLedgersButtonAdminRefetchQuery_graphql.Internal.convertVariables(param)), internal_makeRefetchableFnOpts(param$1, param$2, undefined));
                  };
                }), [p.refetch])
        };
}

function useBlockingPagination(fRef) {
  var p = Hooks.useBlockingPaginationFragment(BulkSaleProductSaleLedgersButtonAdminFragment_graphql.node, fRef);
  var data = RescriptRelay_Internal.internal_useConvertedValue(BulkSaleProductSaleLedgersButtonAdminFragment_graphql.Internal.convertFragment, p.data);
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
                    return p.refetch(RescriptRelay_Internal.internal_cleanObjectFromUndefinedRaw(BulkSaleProductSaleLedgersButtonAdminRefetchQuery_graphql.Internal.convertVariables(param)), internal_makeRefetchableFnOpts(param$1, param$2, undefined));
                  };
                }), [p.refetch])
        };
}

var makeRefetchVariables = BulkSaleProductSaleLedgersButtonAdminRefetchQuery_graphql.Types.makeRefetchVariables;

var Fragment_productPackageMassUnit_decode = BulkSaleProductSaleLedgersButtonAdminFragment_graphql.Utils.productPackageMassUnit_decode;

var Fragment_productPackageMassUnit_fromString = BulkSaleProductSaleLedgersButtonAdminFragment_graphql.Utils.productPackageMassUnit_fromString;

var Fragment_getConnectionNodes = BulkSaleProductSaleLedgersButtonAdminFragment_graphql.Utils.getConnectionNodes;

var Fragment = {
  productPackageMassUnit_decode: Fragment_productPackageMassUnit_decode,
  productPackageMassUnit_fromString: Fragment_productPackageMassUnit_fromString,
  getConnectionNodes: Fragment_getConnectionNodes,
  Types: undefined,
  internal_makeRefetchableFnOpts: internal_makeRefetchableFnOpts,
  useRefetchable: useRefetchable,
  use: use,
  useOpt: useOpt,
  usePagination: usePagination,
  useBlockingPagination: useBlockingPagination,
  makeRefetchVariables: makeRefetchVariables
};

function commitMutation(environment, variables, optimisticUpdater, optimisticResponse, updater, onCompleted, onError, uploadables, param) {
  return RelayRuntime.commitMutation(environment, {
              mutation: BulkSaleProductSaleLedgersButtonAdminDeleteMutation_graphql.node,
              variables: BulkSaleProductSaleLedgersButtonAdminDeleteMutation_graphql.Internal.convertVariables(variables),
              onCompleted: (function (res, err) {
                  if (onCompleted !== undefined) {
                    return Curry._2(onCompleted, BulkSaleProductSaleLedgersButtonAdminDeleteMutation_graphql.Internal.convertResponse(res), (err == null) ? undefined : Caml_option.some(err));
                  }
                  
                }),
              onError: (function (err) {
                  if (onError !== undefined) {
                    return Curry._1(onError, (err == null) ? undefined : Caml_option.some(err));
                  }
                  
                }),
              optimisticResponse: optimisticResponse !== undefined ? BulkSaleProductSaleLedgersButtonAdminDeleteMutation_graphql.Internal.convertWrapRawResponse(optimisticResponse) : undefined,
              optimisticUpdater: optimisticUpdater,
              updater: updater !== undefined ? (function (store, r) {
                    return Curry._2(updater, store, BulkSaleProductSaleLedgersButtonAdminDeleteMutation_graphql.Internal.convertResponse(r));
                  }) : undefined,
              uploadables: uploadables
            });
}

function use$1(param) {
  var match = Hooks.useMutation(BulkSaleProductSaleLedgersButtonAdminDeleteMutation_graphql.node);
  var mutate = match[0];
  return [
          React.useMemo((function () {
                  return function (param, param$1, param$2, param$3, param$4, param$5, param$6, param$7, param$8) {
                    return Curry._1(mutate, {
                                onError: param,
                                onCompleted: param$1 !== undefined ? (function (r, errors) {
                                      return Curry._2(param$1, BulkSaleProductSaleLedgersButtonAdminDeleteMutation_graphql.Internal.convertResponse(r), (errors == null) ? undefined : Caml_option.some(errors));
                                    }) : undefined,
                                onUnsubscribe: param$2,
                                optimisticResponse: param$3 !== undefined ? BulkSaleProductSaleLedgersButtonAdminDeleteMutation_graphql.Internal.convertWrapRawResponse(param$3) : undefined,
                                optimisticUpdater: param$4,
                                updater: param$5 !== undefined ? (function (store, r) {
                                      return Curry._2(param$5, store, BulkSaleProductSaleLedgersButtonAdminDeleteMutation_graphql.Internal.convertResponse(r));
                                    }) : undefined,
                                variables: BulkSaleProductSaleLedgersButtonAdminDeleteMutation_graphql.Internal.convertVariables(param$6),
                                uploadables: param$7
                              });
                  };
                }), [mutate]),
          match[1]
        ];
}

var MutationDelete_makeVariables = BulkSaleProductSaleLedgersButtonAdminDeleteMutation_graphql.Utils.makeVariables;

var MutationDelete = {
  makeVariables: MutationDelete_makeVariables,
  Types: undefined,
  commitMutation: commitMutation,
  use: use$1
};

function BulkSale_ProductSaleLedgers_Button_Admin$LedgerCapsule(Props) {
  var idx = Props.idx;
  var selectedLedgerId = Props.selectedLedgerId;
  var setSelectedLedgerId = Props.setSelectedLedgerId;
  var ledger = Props.ledger;
  var refetchLedgers = Props.refetchLedgers;
  var match = ReactToastNotifications.useToasts();
  var addToast = match.addToast;
  var match$1 = use$1(undefined);
  var isMutating = match$1[1];
  var mutate = match$1[0];
  var isSelected = Belt_Option.mapWithDefault(selectedLedgerId, false, (function (id) {
          return id === ledger.node.id;
        }));
  var style = isSelected ? "flex justify-center items-center text-primary border border-primary bg-primary-light p-2 hover:bg-primary-light-variant rounded-lg cursor-pointer" : "flex justify-center items-center text-text-L2 border border-gray-200 p-2 hover:bg-surface rounded-lg cursor-pointer";
  return React.createElement("span", {
              className: style,
              onClick: (function (param) {
                  return setSelectedLedgerId(function (param) {
                              return ledger.node.id;
                            });
                })
            }, React.createElement("span", undefined, "판매원표" + String(idx + 1 | 0)), React.createElement("span", {
                  className: "ml-1",
                  onClick: (function (param) {
                      if (!isMutating && selectedLedgerId !== undefined) {
                        Curry.app(mutate, [
                              (function (err) {
                                  console.log(err);
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
                                              }), "삭제 요청에 성공하였습니다."), {
                                        appearance: "success"
                                      });
                                  return Curry._1(refetchLedgers, undefined);
                                }),
                              undefined,
                              undefined,
                              undefined,
                              undefined,
                              {
                                id: selectedLedgerId
                              },
                              undefined,
                              undefined
                            ]);
                        return ;
                      }
                      
                    })
                }, React.createElement(IconClose.make, {
                      height: "20",
                      width: "20",
                      fill: isSelected ? "#12b564" : "#b2b2b2"
                    })));
}

var LedgerCapsule = {
  make: BulkSale_ProductSaleLedgers_Button_Admin$LedgerCapsule
};

function BulkSale_ProductSaleLedgers_Button_Admin$LedgerAddButton(Props) {
  var selectedLedgerId = Props.selectedLedgerId;
  var addLedger = Props.addLedger;
  var isSelected = Belt_Option.isNone(selectedLedgerId);
  var style = isSelected ? "flex justify-center items-center text-primary border border-primary bg-primary-light p-2 hover:bg-primary-light-variant rounded-lg cursor-pointer" : "flex justify-center items-center text-text-L2 border border-gray-200 rounded-lg p-2 hover:bg-gray-150";
  return React.createElement("button", {
              className: style,
              onClick: (function (param) {
                  return Curry._1(addLedger, undefined);
                })
            }, React.createElement(IconPlus.make, {
                  height: "16",
                  width: "16",
                  fill: isSelected ? "#12b564" : "#b2b2b2",
                  className: "mr-1"
                }), "추가");
}

var LedgerAddButton = {
  make: BulkSale_ProductSaleLedgers_Button_Admin$LedgerAddButton
};

function BulkSale_ProductSaleLedgers_Button_Admin$Content(Props) {
  var farmmorningUserId = Props.farmmorningUserId;
  var applicationId = Props.applicationId;
  var query = Props.query;
  var match = useRefetchable(query);
  var refetch = match[1];
  var queryData = match[0];
  var match$1 = React.useState(function () {
        return Belt_Option.map(Garter_Array.first(queryData.bulkSaleProductSaleLedgers.edges), (function (edge) {
                      return edge.node.id;
                    }));
      });
  var setSelectedLedgerId = match$1[1];
  var selectedLedgerId = match$1[0];
  var addLedger = function (param) {
    return setSelectedLedgerId(function (param) {
                
              });
  };
  var refetchLedgers = function (param) {
    Curry._4(refetch, Curry._4(makeRefetchVariables, undefined, undefined, undefined, undefined), /* StoreAndNetwork */2, undefined, undefined);
    
  };
  var tmp;
  if (selectedLedgerId !== undefined) {
    var ledger = Garter_Array.first(Belt_Array.keep(Belt_Array.map(queryData.bulkSaleProductSaleLedgers.edges, (function (edge) {
                    return edge.node;
                  })), (function (node) {
                return node.id === selectedLedgerId;
              })));
    tmp = ledger !== undefined ? React.createElement(BulkSale_ProductSaleLedgers_Button_Update_Admin.make, {
            farmmorningUserId: farmmorningUserId,
            ledger: ledger,
            key: selectedLedgerId
          }) : React.createElement(BulkSale_ProductSaleLedgers_Button_Create_Admin.make, {
            connectionId: queryData.bulkSaleProductSaleLedgers.__id,
            farmmorningUserId: farmmorningUserId,
            applicationId: applicationId,
            key: Belt_Option.getWithDefault(selectedLedgerId, String(GetTime(new Date())))
          });
  } else {
    tmp = React.createElement(BulkSale_ProductSaleLedgers_Button_Create_Admin.make, {
          connectionId: queryData.bulkSaleProductSaleLedgers.__id,
          farmmorningUserId: farmmorningUserId,
          applicationId: applicationId,
          key: Belt_Option.getWithDefault(selectedLedgerId, String(GetTime(new Date())))
        });
  }
  return React.createElement("section", {
              className: "p-5 text-text-L1"
            }, React.createElement("article", {
                  className: "flex"
                }, React.createElement("h2", {
                      className: "text-xl font-bold"
                    }, "판매 원표"), React.createElement(ReactDialog.Close, {
                      children: React.createElement(IconClose.make, {
                            height: "24",
                            width: "24",
                            fill: "#262626"
                          }),
                      className: "inline-block p-1 focus:outline-none ml-auto"
                    })), React.createElement("article", {
                  className: "bg-red-50 text-emphasis p-4 rounded-lg mt-7 mb-5"
                }, "선택된 한 개의 원표만 저장 /수정 가능합니다. (빈칸 제출 가능)"), React.createElement("article", {
                  className: "flex gap-2 mb-5"
                }, Belt_Array.mapWithIndex(queryData.bulkSaleProductSaleLedgers.edges, (function (idx, ledger) {
                        return React.createElement(BulkSale_ProductSaleLedgers_Button_Admin$LedgerCapsule, {
                                    idx: idx,
                                    selectedLedgerId: selectedLedgerId,
                                    setSelectedLedgerId: setSelectedLedgerId,
                                    ledger: ledger,
                                    refetchLedgers: refetchLedgers
                                  });
                      })), React.createElement(BulkSale_ProductSaleLedgers_Button_Admin$LedgerAddButton, {
                      selectedLedgerId: selectedLedgerId,
                      addLedger: addLedger
                    })), tmp);
}

var Content = {
  make: BulkSale_ProductSaleLedgers_Button_Admin$Content
};

function BulkSale_ProductSaleLedgers_Button_Admin(Props) {
  var farmmorningUserId = Props.farmmorningUserId;
  var applicationId = Props.applicationId;
  var query = Props.query;
  return React.createElement(ReactDialog.Root, {
              children: null
            }, React.createElement(ReactDialog.Overlay, {
                  className: "dialog-overlay"
                }), React.createElement(ReactDialog.Trigger, {
                  children: React.createElement("span", {
                        className: "inline-block bg-primary-light text-primary py-1 px-2 rounded-lg mt-2"
                      }, "원표정보 입력"),
                  className: "text-left"
                }), React.createElement(ReactDialog.Content, {
                  children: React.createElement(React.Suspense, {
                        children: React.createElement(BulkSale_ProductSaleLedgers_Button_Admin$Content, {
                              farmmorningUserId: farmmorningUserId,
                              applicationId: applicationId,
                              query: query
                            }),
                        fallback: React.createElement(React.Fragment, undefined)
                      }),
                  className: "dialog-content-detail overflow-y-auto"
                }));
}

var FormEntry;

var FormUpdate;

var FormCreate;

var make = BulkSale_ProductSaleLedgers_Button_Admin;

export {
  FormEntry ,
  FormUpdate ,
  FormCreate ,
  Fragment ,
  MutationDelete ,
  LedgerCapsule ,
  LedgerAddButton ,
  Content ,
  make ,
  
}
/* react Not a pure module */
