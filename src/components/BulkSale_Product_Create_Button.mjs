// Generated by ReScript, PLEASE EDIT WITH CARE

import * as V from "../utils/V.mjs";
import * as Curry from "rescript/lib/es6/curry.js";
import * as Input from "./common/Input.mjs";
import * as React from "@rescript/react/src/React.mjs";
import * as React$1 from "react";
import * as IconClose from "./svgs/IconClose.mjs";
import * as Belt_Array from "rescript/lib/es6/belt_Array.js";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as ReactRelay from "react-relay";
import * as Garter_Array from "@greenlabs/garter/src/Garter_Array.mjs";
import * as RelayRuntime from "relay-runtime";
import * as Select_BulkSale_Crop from "./Select_BulkSale_Crop.mjs";
import * as Webapi__Dom__Element from "rescript-webapi/src/Webapi/Dom/Webapi__Dom__Element.mjs";
import * as ReactDialog from "@radix-ui/react-dialog";
import * as Select_BulkSale_ProductGrade from "./Select_BulkSale_ProductGrade.mjs";
import * as Select_BulkSale_ProductCategory from "./Select_BulkSale_ProductCategory.mjs";
import * as Input_Select_BulkSale_ProductQuantity from "./Input_Select_BulkSale_ProductQuantity.mjs";
import * as BulkSaleProductCreateButtonMutation_graphql from "../__generated__/BulkSaleProductCreateButtonMutation_graphql.mjs";

function commitMutation(environment, variables, optimisticUpdater, optimisticResponse, updater, onCompleted, onError, uploadables, param) {
  return RelayRuntime.commitMutation(environment, {
              mutation: BulkSaleProductCreateButtonMutation_graphql.node,
              variables: BulkSaleProductCreateButtonMutation_graphql.Internal.convertVariables(variables),
              onCompleted: (function (res, err) {
                  if (onCompleted !== undefined) {
                    return Curry._2(onCompleted, BulkSaleProductCreateButtonMutation_graphql.Internal.convertResponse(res), (err == null) ? undefined : Caml_option.some(err));
                  }
                  
                }),
              onError: (function (err) {
                  if (onError !== undefined) {
                    return Curry._1(onError, (err == null) ? undefined : Caml_option.some(err));
                  }
                  
                }),
              optimisticResponse: optimisticResponse !== undefined ? BulkSaleProductCreateButtonMutation_graphql.Internal.convertWrapRawResponse(optimisticResponse) : undefined,
              optimisticUpdater: optimisticUpdater,
              updater: updater !== undefined ? (function (store, r) {
                    Curry._2(updater, store, BulkSaleProductCreateButtonMutation_graphql.Internal.convertResponse(r));
                  }) : undefined,
              uploadables: uploadables
            });
}

function use(param) {
  var match = ReactRelay.useMutation(BulkSaleProductCreateButtonMutation_graphql.node);
  var mutate = match[0];
  return [
          React$1.useMemo((function () {
                  return function (param, param$1, param$2, param$3, param$4, param$5, param$6, param$7, param$8) {
                    return Curry._1(mutate, {
                                onError: param,
                                onCompleted: param$1 !== undefined ? (function (r, errors) {
                                      Curry._2(param$1, BulkSaleProductCreateButtonMutation_graphql.Internal.convertResponse(r), (errors == null) ? undefined : Caml_option.some(errors));
                                    }) : undefined,
                                onUnsubscribe: param$2,
                                optimisticResponse: param$3 !== undefined ? BulkSaleProductCreateButtonMutation_graphql.Internal.convertWrapRawResponse(param$3) : undefined,
                                optimisticUpdater: param$4,
                                updater: param$5 !== undefined ? (function (store, r) {
                                      Curry._2(param$5, store, BulkSaleProductCreateButtonMutation_graphql.Internal.convertResponse(r));
                                    }) : undefined,
                                variables: BulkSaleProductCreateButtonMutation_graphql.Internal.convertVariables(param$6),
                                uploadables: param$7
                              });
                  };
                }), [mutate]),
          match[1]
        ];
}

var Mutation_productPackageMassUnit_decode = BulkSaleProductCreateButtonMutation_graphql.Utils.productPackageMassUnit_decode;

var Mutation_productPackageMassUnit_fromString = BulkSaleProductCreateButtonMutation_graphql.Utils.productPackageMassUnit_fromString;

var Mutation = {
  productPackageMassUnit_decode: Mutation_productPackageMassUnit_decode,
  productPackageMassUnit_fromString: Mutation_productPackageMassUnit_fromString,
  Operation: undefined,
  Types: undefined,
  commitMutation: commitMutation,
  use: use
};

function makeInput(productCategoryId, preferredGrade, preferredQuantityAmount, preferredQuantityUnit, estimatedSellerEarningRate, estimatedPurchasePriceMin, estimatedPurchasePriceMax, isOpen) {
  return {
          displayOrder: undefined,
          estimatedPurchasePriceMax: estimatedPurchasePriceMax,
          estimatedPurchasePriceMin: estimatedPurchasePriceMin,
          estimatedSellerEarningRate: estimatedSellerEarningRate,
          isOpen: isOpen,
          preferredGrade: preferredGrade,
          preferredQuantity: {
            amount: preferredQuantityAmount,
            unit: preferredQuantityUnit
          },
          productCategoryId: productCategoryId
        };
}

function BulkSale_Product_Create_Button(props) {
  var refetchSummary = props.refetchSummary;
  var connectionId = props.connectionId;
  var match = use(undefined);
  var isMutating = match[1];
  var mutate = match[0];
  var match$1 = React$1.useState(function () {
        return /* NotSelected */0;
      });
  var setCropId = match$1[1];
  var cropId = match$1[0];
  var match$2 = React$1.useState(function () {
        return /* NotSelected */0;
      });
  var setProductCategoryId = match$2[1];
  var productCategoryId = match$2[0];
  var match$3 = React$1.useState(function () {
        
      });
  var setPreferredGrade = match$3[1];
  var preferredGrade = match$3[0];
  var match$4 = React$1.useState(function () {
        
      });
  var setPreferredQuantityAmount = match$4[1];
  var preferredQuantityAmount = match$4[0];
  var match$5 = React$1.useState(function () {
        return "KG";
      });
  var setPreferredQuantityUnit = match$5[1];
  var preferredQuantityUnit = match$5[0];
  var match$6 = React$1.useState(function () {
        return "";
      });
  var setEstimatedSellerEarningRate = match$6[1];
  var estimatedSellerEarningRate = match$6[0];
  var match$7 = React$1.useState(function () {
        return "";
      });
  var setEstimatedPurchasePriceMin = match$7[1];
  var estimatedPurchasePriceMin = match$7[0];
  var match$8 = React$1.useState(function () {
        return "";
      });
  var setEstimatedPurchasePriceMax = match$8[1];
  var estimatedPurchasePriceMax = match$8[0];
  var match$9 = React$1.useState(function () {
        return [];
      });
  var setFormErrors = match$9[1];
  var formErrors = match$9[0];
  var prefill = function (isOpen) {
    if (isOpen) {
      setCropId(function (param) {
            return /* NotSelected */0;
          });
      setProductCategoryId(function (param) {
            return /* NotSelected */0;
          });
      setPreferredGrade(function (param) {
            
          });
      setPreferredQuantityAmount(function (param) {
            
          });
      setEstimatedSellerEarningRate(function (param) {
            return "";
          });
      setEstimatedPurchasePriceMin(function (param) {
            return "";
          });
      return setEstimatedPurchasePriceMax(function (param) {
                  return "";
                });
    }
    
  };
  var handleOnSelect = function (cleanUpFn, setFn, value) {
    setFn(function (param) {
          return value;
        });
    if (cleanUpFn !== undefined) {
      return Curry._1(cleanUpFn, undefined);
    }
    
  };
  var handleOnChange = function (cleanUpFn, setFn, e) {
    var value = e.target.value;
    setFn(function (param) {
          return value;
        });
    if (cleanUpFn !== undefined) {
      return Curry._1(cleanUpFn, undefined);
    }
    
  };
  var handleOnSelectPackageUnit = function (e) {
    var value = e.target.value;
    var value$p = Input_Select_BulkSale_ProductQuantity.decodePackageUnit(value);
    if (value$p.TAG !== /* Ok */0) {
      return ;
    }
    var value$p$1 = value$p._0;
    setPreferredQuantityUnit(function (param) {
          return value$p$1;
        });
  };
  var partial_arg = (function (param) {
      setProductCategoryId(function (param) {
            return /* NotSelected */0;
          });
      setPreferredGrade(function (param) {
            
          });
      setPreferredQuantityAmount(function (param) {
            
          });
      setPreferredQuantityUnit(function (param) {
            return "KG";
          });
    });
  var partial_arg$1 = (function (param) {
      setPreferredGrade(function (param) {
            
          });
      setPreferredQuantityAmount(function (param) {
            
          });
      setPreferredQuantityUnit(function (param) {
            return "KG";
          });
    });
  return React$1.createElement(ReactDialog.Root, {
              children: null,
              onOpenChange: prefill
            }, React$1.createElement(ReactDialog.Overlay, {
                  className: "dialog-overlay"
                }), React$1.createElement(ReactDialog.Trigger, {
                  children: "신규 상품 등록",
                  className: "h-8 px-3 py-1 text-[15px] text-white bg-primary rounded-lg focus:outline-none"
                }), React$1.createElement(ReactDialog.Content, {
                  children: React$1.createElement("section", {
                        className: "p-5"
                      }, React$1.createElement("article", {
                            className: "flex"
                          }, React$1.createElement("h2", {
                                className: "text-xl font-bold"
                              }, "신규 상품 등록"), React$1.createElement(ReactDialog.Close, {
                                children: React$1.createElement(IconClose.make, {
                                      height: "24",
                                      width: "24",
                                      fill: "#262626"
                                    }),
                                className: "inline-block p-1 focus:outline-none ml-auto"
                              })), React$1.createElement(React$1.Suspense, {
                            children: Caml_option.some(React$1.createElement(Select_BulkSale_Crop.make, {
                                      cropId: cropId,
                                      onChange: (function (param) {
                                          return handleOnSelect(partial_arg, setCropId, param);
                                        }),
                                      error: Garter_Array.first(Belt_Array.keepMap(formErrors, (function (error) {
                                                  if (typeof error === "object" && error.NAME === "ErrorProductCategoryId") {
                                                    return error.VAL;
                                                  }
                                                  
                                                })))
                                    })),
                            fallback: Caml_option.some(React$1.createElement("div", undefined, "로딩 중.."))
                          }), React$1.createElement(React$1.Suspense, {
                            children: Caml_option.some(React.createElementWithKey(Select_BulkSale_ProductCategory.make, {
                                      cropId: cropId,
                                      productCategoryId: productCategoryId,
                                      onChange: (function (param) {
                                          return handleOnSelect(partial_arg$1, setProductCategoryId, param);
                                        }),
                                      error: Garter_Array.first(Belt_Array.keepMap(formErrors, (function (error) {
                                                  if (typeof error === "object" && error.NAME === "ErrorProductCategoryId") {
                                                    return error.VAL;
                                                  }
                                                  
                                                })))
                                    }, cropId ? cropId.value : "")),
                            fallback: Caml_option.some(React$1.createElement("div", undefined, "로딩 중.."))
                          }), React$1.createElement(React$1.Suspense, {
                            children: Caml_option.some(React$1.createElement(Select_BulkSale_ProductGrade.make, {
                                      productCategoryId: productCategoryId,
                                      preferredGrade: preferredGrade,
                                      onChange: (function (param) {
                                          return handleOnChange(undefined, setPreferredGrade, param);
                                        }),
                                      error: Garter_Array.first(Belt_Array.keepMap(formErrors, (function (error) {
                                                  if (typeof error === "object" && error.NAME === "ErrorGrade") {
                                                    return error.VAL;
                                                  }
                                                  
                                                })))
                                    })),
                            fallback: Caml_option.some(React$1.createElement("div", undefined, "로딩 중.."))
                          }), React$1.createElement(Input_Select_BulkSale_ProductQuantity.make, {
                            quantityAmount: preferredQuantityAmount,
                            quantityUnit: preferredQuantityUnit,
                            onChangeAmount: (function (param) {
                                return handleOnChange(undefined, setPreferredQuantityAmount, param);
                              }),
                            onChangeUnit: handleOnSelectPackageUnit,
                            error: Garter_Array.first(Belt_Array.keepMap(formErrors, (function (error) {
                                        if (typeof error === "object" && error.NAME === "ErrorAmount") {
                                          return error.VAL;
                                        }
                                        
                                      })))
                          }), React$1.createElement("article", {
                            className: "mt-5"
                          }, React$1.createElement("h3", undefined, "예상 추가 수익 비율"), React$1.createElement("div", {
                                className: "flex mt-2"
                              }, React$1.createElement(Input.make, {
                                    type_: "profit-ratio",
                                    name: "profit-ratio",
                                    placeholder: "0",
                                    className: "flex-1 mr-1",
                                    value: estimatedSellerEarningRate,
                                    onChange: (function (param) {
                                        return handleOnChange(undefined, setEstimatedSellerEarningRate, param);
                                      }),
                                    size: /* Small */2,
                                    error: Garter_Array.first(Belt_Array.keepMap(formErrors, (function (error) {
                                                if (typeof error === "object" && error.NAME === "ErrorEarningRate") {
                                                  return error.VAL;
                                                }
                                                
                                              }))),
                                    textAlign: /* Right */2
                                  }))), React$1.createElement("article", {
                            className: "mt-5"
                          }, React$1.createElement("h3", undefined, "적정 구매 가격"), React$1.createElement("div", {
                                className: "flex mt-2"
                              }, React$1.createElement(Input.make, {
                                    type_: "profit-ratio",
                                    name: "profit-ratio",
                                    placeholder: "0",
                                    className: "flex-1 mr-1",
                                    value: estimatedPurchasePriceMin,
                                    onChange: (function (param) {
                                        return handleOnChange(undefined, setEstimatedPurchasePriceMin, param);
                                      }),
                                    size: /* Small */2,
                                    error: Garter_Array.first(Belt_Array.keepMap(formErrors, (function (error) {
                                                if (typeof error === "object" && error.NAME === "ErrorPriceMin") {
                                                  return error.VAL;
                                                }
                                                
                                              }))),
                                    textAlign: /* Right */2
                                  }), React$1.createElement(Input.make, {
                                    type_: "profit-ratio",
                                    name: "profit-ratio",
                                    placeholder: "0",
                                    className: "flex-1 mr-1",
                                    value: estimatedPurchasePriceMax,
                                    onChange: (function (param) {
                                        return handleOnChange(undefined, setEstimatedPurchasePriceMax, param);
                                      }),
                                    size: /* Small */2,
                                    error: Garter_Array.first(Belt_Array.keepMap(formErrors, (function (error) {
                                                if (typeof error === "object" && error.NAME === "ErrorPriceMax") {
                                                  return error.VAL;
                                                }
                                                
                                              }))),
                                    textAlign: /* Right */2
                                  }))), React$1.createElement("article", {
                            className: "flex justify-center items-center mt-5"
                          }, React$1.createElement(ReactDialog.Close, {
                                children: React$1.createElement("span", {
                                      className: "btn-level6 py-3 px-5",
                                      id: "btn-close"
                                    }, "닫기"),
                                className: "flex mr-2"
                              }), React$1.createElement("span", {
                                className: "flex mr-2"
                              }, React$1.createElement("button", {
                                    className: isMutating ? "btn-level1-disabled py-3 px-5" : "btn-level1 py-3 px-5",
                                    disabled: isMutating,
                                    onClick: (function (param) {
                                        var input = V.ap(V.ap(V.ap(V.ap(V.ap(V.ap(V.ap(V.map(makeInput, V.$$Option.nonEmpty({
                                                                              NAME: "ErrorProductCategoryId",
                                                                              VAL: "품목 품종을 선택해주세요"
                                                                            }, productCategoryId ? productCategoryId.value : undefined)), V.$$Option.nonEmpty({
                                                                          NAME: "ErrorGrade",
                                                                          VAL: "등급을 입력해주세요"
                                                                        }, preferredGrade)), V.$$Option.$$float({
                                                                      NAME: "ErrorAmount",
                                                                      VAL: "중량을 입력해주세요"
                                                                    }, preferredQuantityAmount)), V.pure(preferredQuantityUnit)), V.$$float({
                                                              NAME: "ErrorEarningRate",
                                                              VAL: "예상 추가 수비 비율을 입력해주세요"
                                                            }, estimatedSellerEarningRate)), V.$$int({
                                                          NAME: "ErrorPriceMin",
                                                          VAL: "적정 구매 가격을 입력해주세요"
                                                        }, estimatedPurchasePriceMin)), V.$$int({
                                                      NAME: "ErrorPriceMax",
                                                      VAL: "적정 구매 가격을 입력해주세요"
                                                    }, estimatedPurchasePriceMax)), V.shouldBeTrue({
                                                  NAME: "ErrorIsOpen",
                                                  VAL: ""
                                                }, true));
                                        if (input.TAG === /* Ok */0) {
                                          Curry.app(mutate, [
                                                undefined,
                                                (function (param, param$1) {
                                                    Curry._1(refetchSummary, undefined);
                                                    var buttonClose = document.getElementById("btn-close");
                                                    Belt_Option.forEach(Belt_Option.flatMap((buttonClose == null) ? undefined : Caml_option.some(buttonClose), Webapi__Dom__Element.asHtmlElement), (function (buttonClose$p) {
                                                            buttonClose$p.click();
                                                          }));
                                                  }),
                                                undefined,
                                                undefined,
                                                undefined,
                                                undefined,
                                                {
                                                  connections: [connectionId],
                                                  input: input._0
                                                },
                                                undefined,
                                                undefined
                                              ]);
                                          return ;
                                        }
                                        var errors = input._0;
                                        setFormErrors(function (param) {
                                              return errors;
                                            });
                                      })
                                  }, "저장")))),
                  className: "dialog-content overflow-y-auto"
                }));
}

var make = BulkSale_Product_Create_Button;

export {
  Mutation ,
  makeInput ,
  make ,
}
/* Input Not a pure module */
