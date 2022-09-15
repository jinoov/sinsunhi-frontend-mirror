// Generated by ReScript, PLEASE EDIT WITH CARE

import * as V from "../utils/V.mjs";
import * as Curry from "rescript/lib/es6/curry.js";
import * as Input from "./common/Input.mjs";
import * as React from "react";
import * as Belt_Int from "rescript/lib/es6/belt_Int.js";
import * as Textarea from "./common/Textarea.mjs";
import * as IconCheck from "./svgs/IconCheck.mjs";
import * as IconError from "./svgs/IconError.mjs";
import * as Belt_Array from "rescript/lib/es6/belt_Array.js";
import * as Belt_Float from "rescript/lib/es6/belt_Float.js";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as ReactRelay from "react-relay";
import * as Garter_Array from "@greenlabs/garter/src/Garter_Array.mjs";
import * as RelayRuntime from "relay-runtime";
import * as Webapi__Dom__Element from "rescript-webapi/src/Webapi/Dom/Webapi__Dom__Element.mjs";
import * as ReactDialog from "@radix-ui/react-dialog";
import * as Select_Delivery_Company from "./Select_Delivery_Company.mjs";
import * as ReactToastNotifications from "react-toast-notifications";
import * as BulkSale_Producer_OnlineMarketInfo_Button_Util from "./BulkSale_Producer_OnlineMarketInfo_Button_Util.mjs";
import * as BulkSaleProducerOnlineMarketInfoButtonUpdateAdminMutation_graphql from "../__generated__/BulkSaleProducerOnlineMarketInfoButtonUpdateAdminMutation_graphql.mjs";

function commitMutation(environment, variables, optimisticUpdater, optimisticResponse, updater, onCompleted, onError, uploadables, param) {
  return RelayRuntime.commitMutation(environment, {
              mutation: BulkSaleProducerOnlineMarketInfoButtonUpdateAdminMutation_graphql.node,
              variables: BulkSaleProducerOnlineMarketInfoButtonUpdateAdminMutation_graphql.Internal.convertVariables(variables),
              onCompleted: (function (res, err) {
                  if (onCompleted !== undefined) {
                    return Curry._2(onCompleted, BulkSaleProducerOnlineMarketInfoButtonUpdateAdminMutation_graphql.Internal.convertResponse(res), (err == null) ? undefined : Caml_option.some(err));
                  }
                  
                }),
              onError: (function (err) {
                  if (onError !== undefined) {
                    return Curry._1(onError, (err == null) ? undefined : Caml_option.some(err));
                  }
                  
                }),
              optimisticResponse: optimisticResponse !== undefined ? BulkSaleProducerOnlineMarketInfoButtonUpdateAdminMutation_graphql.Internal.convertWrapRawResponse(optimisticResponse) : undefined,
              optimisticUpdater: optimisticUpdater,
              updater: updater !== undefined ? (function (store, r) {
                    Curry._2(updater, store, BulkSaleProducerOnlineMarketInfoButtonUpdateAdminMutation_graphql.Internal.convertResponse(r));
                  }) : undefined,
              uploadables: uploadables
            });
}

function use(param) {
  var match = ReactRelay.useMutation(BulkSaleProducerOnlineMarketInfoButtonUpdateAdminMutation_graphql.node);
  var mutate = match[0];
  return [
          React.useMemo((function () {
                  return function (param, param$1, param$2, param$3, param$4, param$5, param$6, param$7, param$8) {
                    return Curry._1(mutate, {
                                onError: param,
                                onCompleted: param$1 !== undefined ? (function (r, errors) {
                                      Curry._2(param$1, BulkSaleProducerOnlineMarketInfoButtonUpdateAdminMutation_graphql.Internal.convertResponse(r), (errors == null) ? undefined : Caml_option.some(errors));
                                    }) : undefined,
                                onUnsubscribe: param$2,
                                optimisticResponse: param$3 !== undefined ? BulkSaleProducerOnlineMarketInfoButtonUpdateAdminMutation_graphql.Internal.convertWrapRawResponse(param$3) : undefined,
                                optimisticUpdater: param$4,
                                updater: param$5 !== undefined ? (function (store, r) {
                                      Curry._2(param$5, store, BulkSaleProducerOnlineMarketInfoButtonUpdateAdminMutation_graphql.Internal.convertResponse(r));
                                    }) : undefined,
                                variables: BulkSaleProducerOnlineMarketInfoButtonUpdateAdminMutation_graphql.Internal.convertVariables(param$6),
                                uploadables: param$7
                              });
                  };
                }), [mutate]),
          match[1]
        ];
}

var Mutation_onlineMarket_decode = BulkSaleProducerOnlineMarketInfoButtonUpdateAdminMutation_graphql.Utils.onlineMarket_decode;

var Mutation_onlineMarket_fromString = BulkSaleProducerOnlineMarketInfoButtonUpdateAdminMutation_graphql.Utils.onlineMarket_fromString;

var Mutation = {
  onlineMarket_decode: Mutation_onlineMarket_decode,
  onlineMarket_fromString: Mutation_onlineMarket_fromString,
  Operation: undefined,
  Types: undefined,
  commitMutation: commitMutation,
  use: use
};

function makeInput(market, deliveryCompanyId, url, averageReviewScore, numberOfComments) {
  return {
          averageReviewScore: averageReviewScore,
          deliveryCompanyId: deliveryCompanyId,
          market: market,
          numberOfComments: numberOfComments,
          url: url
        };
}

function BulkSale_Producer_OnlineMarketInfo_Button_Update_Admin$Form(Props) {
  var connectionId = Props.connectionId;
  var selectedMarket = Props.selectedMarket;
  var market = Props.market;
  var match = ReactToastNotifications.useToasts();
  var addToast = match.addToast;
  var match$1 = use(undefined);
  var isMutating = match$1[1];
  var mutate = match$1[0];
  var match$2 = React.useState(function () {
        return Belt_Option.map(market.node.deliveryCompany, (function (dc) {
                      return dc.id;
                    }));
      });
  var setDeliveryCompanyId = match$2[1];
  var deliveryCompanyId = match$2[0];
  var match$3 = React.useState(function () {
        return market.node.url;
      });
  var setUrl = match$3[1];
  var url = match$3[0];
  var match$4 = React.useState(function () {
        return String(market.node.averageReviewScore);
      });
  var setAverageReviewScore = match$4[1];
  var averageReviewScore = match$4[0];
  var match$5 = React.useState(function () {
        return String(market.node.numberOfComments);
      });
  var setNumberOfComments = match$5[1];
  var numberOfComments = match$5[0];
  var match$6 = React.useState(function () {
        return [];
      });
  var setFormErrors = match$6[1];
  var handleOnChange = function (setFn, e) {
    var value = e.target.value;
    return setFn(function (param) {
                return value;
              });
  };
  React.useEffect((function () {
          setDeliveryCompanyId(function (param) {
                return Belt_Option.map(market.node.deliveryCompany, (function (dc) {
                              return dc.id;
                            }));
              });
          setUrl(function (param) {
                return market.node.url;
              });
          setAverageReviewScore(function (param) {
                return String(market.node.averageReviewScore);
              });
          setNumberOfComments(function (param) {
                return String(market.node.numberOfComments);
              });
        }), [market]);
  return React.createElement("section", {
              className: "pb-5"
            }, React.createElement(Select_Delivery_Company.make, {
                  label: "계약된 택배사",
                  deliveryCompanyId: deliveryCompanyId,
                  onChange: (function (param) {
                      return handleOnChange(setDeliveryCompanyId, param);
                    }),
                  error: Garter_Array.first(Belt_Array.keepMap(match$6[0], (function (error) {
                              if (typeof error === "object" && error.NAME === "ErrorDeliveryCompanyId") {
                                return error.VAL;
                              }
                              
                            })))
                }), React.createElement("article", {
                  className: "mt-5 px-5"
                }, React.createElement("h3", undefined, "판매했던 URL"), React.createElement("div", {
                      className: "flex mt-2"
                    }, React.createElement(Textarea.make, {
                          type_: "online-sale-urls",
                          name: "online-sale-urls",
                          placeholder: "URL 입력",
                          className: "flex-1 mr-1",
                          value: Belt_Option.getWithDefault(url, ""),
                          onChange: (function (param) {
                              return handleOnChange(setUrl, param);
                            }),
                          size: /* Small */3,
                          error: undefined
                        }))), React.createElement("section", {
                  className: "flex mt-5 px-5"
                }, React.createElement("article", {
                      className: "flex-1"
                    }, React.createElement("h3", undefined, "평점"), React.createElement("div", {
                          className: "flex mt-2"
                        }, React.createElement(Input.make, {
                              type_: "online-sale-average-review-score",
                              name: "online-sale-average-review-score",
                              placeholder: "평점 입력",
                              className: "flex-1 mr-1",
                              value: Belt_Option.getWithDefault(averageReviewScore, ""),
                              onChange: (function (param) {
                                  return handleOnChange(setAverageReviewScore, param);
                                }),
                              size: /* Small */2,
                              error: undefined
                            }))), React.createElement("article", {
                      className: "flex-1"
                    }, React.createElement("h3", undefined, "댓글 수"), React.createElement("div", {
                          className: "flex mt-2"
                        }, React.createElement(Input.make, {
                              type_: "online-sale-average-review-score",
                              name: "online-sale-average-review-score",
                              placeholder: "댓글 수 입력",
                              className: "flex-1 mr-1",
                              value: Belt_Option.getWithDefault(numberOfComments, ""),
                              onChange: (function (param) {
                                  return handleOnChange(setNumberOfComments, param);
                                }),
                              size: /* Small */2,
                              error: undefined
                            })))), React.createElement("article", {
                  className: "flex justify-center items-center mt-5"
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
                              var input = V.ap(V.ap(V.ap(V.ap(V.map(makeInput, V.pure(Belt_Option.flatMap(selectedMarket, BulkSale_Producer_OnlineMarketInfo_Button_Util.convertOnlineMarket))), V.$$Option.nonEmpty({
                                                    NAME: "ErrorDeliveryCompanyId",
                                                    VAL: "택배사를 선택해야 합니다."
                                                  }, deliveryCompanyId)), V.pure(url)), V.pure(Belt_Option.flatMap(averageReviewScore, Belt_Float.fromString))), V.pure(Belt_Option.flatMap(numberOfComments, Belt_Int.fromString)));
                              if (input.TAG === /* Ok */0) {
                                Curry.app(mutate, [
                                      (function (err) {
                                          console.log(err);
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
                                        id: market.node.id,
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
                        }, "저장"))));
}

var Form = {
  make: BulkSale_Producer_OnlineMarketInfo_Button_Update_Admin$Form
};

var Util;

export {
  Util ,
  Mutation ,
  makeInput ,
  Form ,
}
/* Input Not a pure module */
