// Generated by ReScript, PLEASE EDIT WITH CARE

import * as V from "../utils/V.mjs";
import * as Curry from "rescript/lib/es6/curry.js";
import * as Input from "./common/Input.mjs";
import * as React from "react";
import * as IconCheck from "./svgs/IconCheck.mjs";
import * as IconClose from "./svgs/IconClose.mjs";
import * as IconError from "./svgs/IconError.mjs";
import * as Belt_Array from "rescript/lib/es6/belt_Array.js";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as Garter_Array from "@greenlabs/garter/src/Garter_Array.mjs";
import * as RelayRuntime from "relay-runtime";
import * as IconArrowSelect from "./svgs/IconArrowSelect.mjs";
import * as Hooks from "react-relay/hooks";
import * as Webapi__Dom__Element from "rescript-webapi/src/Webapi/Dom/Webapi__Dom__Element.mjs";
import * as ReactDialog from "@radix-ui/react-dialog";
import * as ReactToastNotifications from "react-toast-notifications";
import * as Input_Select_BulkSale_ProductQuantity from "./Input_Select_BulkSale_ProductQuantity.mjs";
import * as BulkSaleProducerSampleReviewButtonCreateAdminMutation_graphql from "../__generated__/BulkSaleProducerSampleReviewButtonCreateAdminMutation_graphql.mjs";

function commitMutation(environment, variables, optimisticUpdater, optimisticResponse, updater, onCompleted, onError, uploadables, param) {
  return RelayRuntime.commitMutation(environment, {
              mutation: BulkSaleProducerSampleReviewButtonCreateAdminMutation_graphql.node,
              variables: BulkSaleProducerSampleReviewButtonCreateAdminMutation_graphql.Internal.convertVariables(variables),
              onCompleted: (function (res, err) {
                  if (onCompleted !== undefined) {
                    return Curry._2(onCompleted, BulkSaleProducerSampleReviewButtonCreateAdminMutation_graphql.Internal.convertResponse(res), (err == null) ? undefined : Caml_option.some(err));
                  }
                  
                }),
              onError: (function (err) {
                  if (onError !== undefined) {
                    return Curry._1(onError, (err == null) ? undefined : Caml_option.some(err));
                  }
                  
                }),
              optimisticResponse: optimisticResponse !== undefined ? BulkSaleProducerSampleReviewButtonCreateAdminMutation_graphql.Internal.convertWrapRawResponse(optimisticResponse) : undefined,
              optimisticUpdater: optimisticUpdater,
              updater: updater !== undefined ? (function (store, r) {
                    return Curry._2(updater, store, BulkSaleProducerSampleReviewButtonCreateAdminMutation_graphql.Internal.convertResponse(r));
                  }) : undefined,
              uploadables: uploadables
            });
}

function use(param) {
  var match = Hooks.useMutation(BulkSaleProducerSampleReviewButtonCreateAdminMutation_graphql.node);
  var mutate = match[0];
  return [
          React.useMemo((function () {
                  return function (param, param$1, param$2, param$3, param$4, param$5, param$6, param$7, param$8) {
                    return Curry._1(mutate, {
                                onError: param,
                                onCompleted: param$1 !== undefined ? (function (r, errors) {
                                      return Curry._2(param$1, BulkSaleProducerSampleReviewButtonCreateAdminMutation_graphql.Internal.convertResponse(r), (errors == null) ? undefined : Caml_option.some(errors));
                                    }) : undefined,
                                onUnsubscribe: param$2,
                                optimisticResponse: param$3 !== undefined ? BulkSaleProducerSampleReviewButtonCreateAdminMutation_graphql.Internal.convertWrapRawResponse(param$3) : undefined,
                                optimisticUpdater: param$4,
                                updater: param$5 !== undefined ? (function (store, r) {
                                      return Curry._2(param$5, store, BulkSaleProducerSampleReviewButtonCreateAdminMutation_graphql.Internal.convertResponse(r));
                                    }) : undefined,
                                variables: BulkSaleProducerSampleReviewButtonCreateAdminMutation_graphql.Internal.convertVariables(param$6),
                                uploadables: param$7
                              });
                  };
                }), [mutate]),
          match[1]
        ];
}

var Mutation_productPackageMassUnit_decode = BulkSaleProducerSampleReviewButtonCreateAdminMutation_graphql.Utils.productPackageMassUnit_decode;

var Mutation_productPackageMassUnit_fromString = BulkSaleProducerSampleReviewButtonCreateAdminMutation_graphql.Utils.productPackageMassUnit_fromString;

var Mutation_reviewScore_decode = BulkSaleProducerSampleReviewButtonCreateAdminMutation_graphql.Utils.reviewScore_decode;

var Mutation_reviewScore_fromString = BulkSaleProducerSampleReviewButtonCreateAdminMutation_graphql.Utils.reviewScore_fromString;

var Mutation_make_bulkSaleSampleReviewCreateInput = BulkSaleProducerSampleReviewButtonCreateAdminMutation_graphql.Utils.make_bulkSaleSampleReviewCreateInput;

var Mutation_make_productPackageMassInput = BulkSaleProducerSampleReviewButtonCreateAdminMutation_graphql.Utils.make_productPackageMassInput;

var Mutation_makeVariables = BulkSaleProducerSampleReviewButtonCreateAdminMutation_graphql.Utils.makeVariables;

var Mutation = {
  productPackageMassUnit_decode: Mutation_productPackageMassUnit_decode,
  productPackageMassUnit_fromString: Mutation_productPackageMassUnit_fromString,
  reviewScore_decode: Mutation_reviewScore_decode,
  reviewScore_fromString: Mutation_reviewScore_fromString,
  make_bulkSaleSampleReviewCreateInput: Mutation_make_bulkSaleSampleReviewCreateInput,
  make_productPackageMassInput: Mutation_make_productPackageMassInput,
  makeVariables: Mutation_makeVariables,
  Types: undefined,
  commitMutation: commitMutation,
  use: use
};

function decodePackageUnit(s) {
  if (s === "kg") {
    return {
            TAG: /* Ok */0,
            _0: "KG"
          };
  } else if (s === "g") {
    return {
            TAG: /* Ok */0,
            _0: "G"
          };
  } else if (s === "mg") {
    return {
            TAG: /* Ok */0,
            _0: "MG"
          };
  } else {
    return {
            TAG: /* Error */1,
            _0: undefined
          };
  }
}

function stringifyPackageUnit(s) {
  if (s === "G") {
    return "g";
  } else if (s === "KG") {
    return "kg";
  } else if (s === "MG") {
    return "mg";
  } else {
    return "";
  }
}

function convertPackageUnit(s) {
  if (s === "G") {
    return "G";
  } else if (s === "KG" || s !== "MG") {
    return "KG";
  } else {
    return "MG";
  }
}

function decodeScore(s) {
  if (s === "very-bad") {
    return {
            TAG: /* Ok */0,
            _0: "VERY_BAD"
          };
  } else if (s === "bad") {
    return {
            TAG: /* Ok */0,
            _0: "BAD"
          };
  } else if (s === "good") {
    return {
            TAG: /* Ok */0,
            _0: "GOOD"
          };
  } else if (s === "very-good") {
    return {
            TAG: /* Ok */0,
            _0: "VERY_GOOD"
          };
  } else {
    return {
            TAG: /* Error */1,
            _0: undefined
          };
  }
}

function stringifyScore(s) {
  if (s === "BAD") {
    return "bad";
  } else if (s === "VERY_GOOD") {
    return "very-good";
  } else if (s === "GOOD") {
    return "good";
  } else if (s === "VERY_BAD") {
    return "very-bad";
  } else {
    return "";
  }
}

function displayScore(s) {
  if (s === "BAD") {
    return "불량";
  } else if (s === "VERY_GOOD") {
    return "매우양호";
  } else if (s === "GOOD") {
    return "양호";
  } else if (s === "VERY_BAD") {
    return "매우불량";
  } else {
    return "";
  }
}

function convertScore(s) {
  if (s === "BAD") {
    return "BAD";
  } else if (s === "VERY_GOOD") {
    return "VERY_GOOD";
  } else if (s === "GOOD") {
    return "GOOD";
  } else {
    return "VERY_BAD";
  }
}

function makeInput(applicationId, amount, unit, brix, packageScore, marketabilityScore) {
  return {
          brix: brix,
          bulkSaleApplicationId: applicationId,
          marketabilityScore: marketabilityScore,
          packageScore: packageScore,
          quantity: {
            amount: amount,
            unit: unit
          }
        };
}

function BulkSale_Producer_Sample_Review_Button_Create_Admin(Props) {
  var applicationId = Props.applicationId;
  var refetchSampleReviews = Props.refetchSampleReviews;
  var match = ReactToastNotifications.useToasts();
  var addToast = match.addToast;
  var match$1 = use(undefined);
  var isMutating = match$1[1];
  var mutate = match$1[0];
  var match$2 = React.useState(function () {
        
      });
  var setQuantityAmount = match$2[1];
  var quantityAmount = match$2[0];
  var match$3 = React.useState(function () {
        return "KG";
      });
  var setQuantityUnit = match$3[1];
  var quantityUnit = match$3[0];
  var match$4 = React.useState(function () {
        
      });
  var setBrix = match$4[1];
  var brix = match$4[0];
  var match$5 = React.useState(function () {
        return "VERY_GOOD";
      });
  var setPackageScore = match$5[1];
  var packageScore = match$5[0];
  var match$6 = React.useState(function () {
        return "VERY_GOOD";
      });
  var setMarketabilityScore = match$6[1];
  var marketabilityScore = match$6[0];
  var match$7 = React.useState(function () {
        return [];
      });
  var setFormErrors = match$7[1];
  var close = function (param) {
    var buttonClose = document.getElementById("btn-close");
    Belt_Option.forEach(Belt_Option.flatMap((buttonClose == null) ? undefined : Caml_option.some(buttonClose), Webapi__Dom__Element.asHtmlElement), (function (buttonClose$p) {
            buttonClose$p.click();
            
          }));
    
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
  var handleOnSelect = function (setFn, decodeFn, e) {
    var value = e.target.value;
    var value$p = Curry._1(decodeFn, value);
    if (value$p.TAG !== /* Ok */0) {
      return ;
    }
    var value$p$1 = value$p._0;
    return setFn(function (param) {
                return value$p$1;
              });
  };
  return React.createElement(ReactDialog.Content, {
              children: null,
              className: "dialog-content-detail overflow-y-auto"
            }, React.createElement("section", {
                  className: "p-5"
                }, React.createElement("article", {
                      className: "flex"
                    }, React.createElement("h2", {
                          className: "text-xl font-bold"
                        }, "상품 평가"), React.createElement(ReactDialog.Close, {
                          children: React.createElement(IconClose.make, {
                                height: "24",
                                width: "24",
                                fill: "#262626"
                              }),
                          className: "inline-block p-1 focus:outline-none ml-auto"
                        }))), React.createElement("section", {
                  className: "p-5"
                }, React.createElement("article", {
                      className: "bg-red-50 rounded-lg p-4 text-emphasis"
                    }, "샘플 수령 및 품평회 이후 입력 부탁드립니다. (빈칸 제출 가능)")), React.createElement("section", {
                  className: "p-5 grid grid-cols-2 gap-x-4"
                }, React.createElement("article", {
                      className: "mt-5"
                    }, React.createElement("h3", undefined, "단위"), React.createElement(Input_Select_BulkSale_ProductQuantity.make, {
                          quantityAmount: quantityAmount,
                          quantityUnit: quantityUnit,
                          onChangeAmount: (function (param) {
                              return handleOnChange(undefined, setQuantityAmount, param);
                            }),
                          onChangeUnit: (function (param) {
                              return handleOnSelect(setQuantityUnit, Input_Select_BulkSale_ProductQuantity.decodePackageUnit, param);
                            }),
                          error: Garter_Array.first(Belt_Array.keepMap(match$7[0], (function (error) {
                                      if (typeof error === "object" && error.NAME === "ErrorQuantityAmount") {
                                        return error.VAL;
                                      }
                                      
                                    })))
                        })), React.createElement("article", {
                      className: "mt-5"
                    }, React.createElement("h3", undefined, "브릭스(Brix)"), React.createElement("div", {
                          className: "flex mt-2"
                        }, React.createElement(Input.make, {
                              type_: "brix",
                              name: "brix",
                              placeholder: "0",
                              className: "flex-1 mr-1",
                              value: Belt_Option.getWithDefault(brix, ""),
                              onChange: (function (param) {
                                  return handleOnChange(undefined, setBrix, param);
                                }),
                              size: /* Small */2,
                              error: undefined,
                              textAlign: /* Right */2
                            }))), React.createElement("article", {
                      className: "mt-5"
                    }, React.createElement("h3", undefined, "포장상태"), React.createElement("label", {
                          className: "block relative mt-2"
                        }, React.createElement("span", {
                              className: "flex items-center border border-border-default-L1 rounded-lg h-9 px-3 text-enabled-L1"
                            }, displayScore(packageScore)), React.createElement("span", {
                              className: "absolute top-1.5 right-2"
                            }, React.createElement(IconArrowSelect.make, {
                                  height: "24",
                                  width: "24",
                                  fill: "#121212"
                                })), React.createElement("select", {
                              className: "block w-full h-full absolute top-0 opacity-0",
                              value: stringifyScore(packageScore),
                              onChange: (function (param) {
                                  return handleOnSelect(setPackageScore, decodeScore, param);
                                })
                            }, Belt_Array.map([
                                  "VERY_GOOD",
                                  "GOOD",
                                  "BAD",
                                  "VERY_BAD"
                                ], (function (unit) {
                                    return React.createElement("option", {
                                                key: stringifyScore(unit),
                                                value: stringifyScore(unit)
                                              }, displayScore(unit));
                                  }))))), React.createElement("article", {
                      className: "mt-5"
                    }, React.createElement("h3", undefined, "상품성"), React.createElement("label", {
                          className: "block relative mt-2"
                        }, React.createElement("span", {
                              className: "flex items-center border border-border-default-L1 rounded-lg h-9 px-3 text-enabled-L1"
                            }, displayScore(marketabilityScore)), React.createElement("span", {
                              className: "absolute top-1.5 right-2"
                            }, React.createElement(IconArrowSelect.make, {
                                  height: "24",
                                  width: "24",
                                  fill: "#121212"
                                })), React.createElement("select", {
                              className: "block w-full h-full absolute top-0 opacity-0",
                              value: stringifyScore(marketabilityScore),
                              onChange: (function (param) {
                                  return handleOnSelect(setMarketabilityScore, decodeScore, param);
                                })
                            }, Belt_Array.map([
                                  "VERY_GOOD",
                                  "GOOD",
                                  "BAD",
                                  "VERY_BAD"
                                ], (function (unit) {
                                    return React.createElement("option", {
                                                key: stringifyScore(unit),
                                                value: stringifyScore(unit)
                                              }, displayScore(unit));
                                  })))))), React.createElement("section", {
                  className: "p-5"
                }, React.createElement("article", {
                      className: "flex justify-center items-center"
                    }, React.createElement(ReactDialog.Close, {
                          children: React.createElement("span", {
                                className: "btn-level6 py-3 px-5",
                                id: "btn-close"
                              }, "닫기"),
                          className: "flex mr-2"
                        }), React.createElement("span", {
                          className: "flex mr-2"
                        }, React.createElement("button", {
                              className: isMutating ? "btn-level1-disabled py-3 px-5" : "btn-level1 py-3 px-5",
                              disabled: isMutating,
                              onClick: (function (param) {
                                  var input = V.ap(V.ap(V.ap(V.ap(V.ap(V.map(makeInput, V.nonEmpty({
                                                                NAME: "ErrorApplicationId",
                                                                VAL: "ApplicationId가 필요 합니다."
                                                              }, applicationId)), V.$$Option.$$float({
                                                            NAME: "ErrorQuantityAmount",
                                                            VAL: "단위가 입력되어야 합니다."
                                                          }, quantityAmount)), V.pure(quantityUnit)), V.pure(brix)), V.pure(packageScore)), V.pure(marketabilityScore));
                                  if (input.TAG === /* Ok */0) {
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
                                                          }), "수정 요청에 성공하였습니다."), {
                                                    appearance: "success"
                                                  });
                                              close(undefined);
                                              return Curry._1(refetchSampleReviews, undefined);
                                            }),
                                          undefined,
                                          undefined,
                                          undefined,
                                          undefined,
                                          {
                                            input: input._0
                                          },
                                          undefined,
                                          undefined
                                        ]);
                                    return ;
                                  }
                                  var errors = input._0;
                                  return setFormErrors(function (param) {
                                              return errors;
                                            });
                                })
                            }, "저장")))));
}

var make = BulkSale_Producer_Sample_Review_Button_Create_Admin;

export {
  Mutation ,
  decodePackageUnit ,
  stringifyPackageUnit ,
  convertPackageUnit ,
  decodeScore ,
  stringifyScore ,
  displayScore ,
  convertScore ,
  makeInput ,
  make ,
  
}
/* Input Not a pure module */
