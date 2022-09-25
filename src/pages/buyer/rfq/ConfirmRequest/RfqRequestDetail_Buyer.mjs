// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Cx from "rescript-classnames/src/Cx.mjs";
import * as Env from "../../../../constants/Env.mjs";
import * as Curry from "rescript/lib/es6/curry.js";
import * as React from "@rescript/react/src/React.mjs";
import * as React$1 from "react";
import * as Global from "../../../../components/Global.mjs";
import * as DS_Icon from "../../../../components/svgs/DS_Icon.mjs";
import * as DataGtm from "../../../../utils/DataGtm.mjs";
import * as DS_Title from "../../../../components/common/container/DS_Title.mjs";
import * as Belt_Array from "rescript/lib/es6/belt_Array.js";
import * as Caml_int32 from "rescript/lib/es6/caml_int32.js";
import * as Js_promise from "rescript/lib/es6/js_promise.js";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as Router from "next/router";
import * as ReactRelay from "react-relay";
import * as DS_TitleList from "../../../../components/common/element/DS_TitleList.mjs";
import * as Authorization from "../../../../utils/Authorization.mjs";
import * as RescriptRelay from "rescript-relay/src/RescriptRelay.mjs";
import * as RelayRuntime from "relay-runtime";
import * as DS_ButtonContainer from "../../../../components/common/container/DS_ButtonContainer.mjs";
import * as RescriptRelay_Internal from "rescript-relay/src/RescriptRelay_Internal.mjs";
import * as RfqRequestDetailBuyer_Current_Request_Query_graphql from "../../../../__generated__/RfqRequestDetailBuyer_Current_Request_Query_graphql.mjs";

function use(variables, fetchPolicy, fetchKey, networkCacheConfig, param) {
  var data = ReactRelay.useLazyLoadQuery(RfqRequestDetailBuyer_Current_Request_Query_graphql.node, RescriptRelay_Internal.internal_cleanObjectFromUndefinedRaw(RfqRequestDetailBuyer_Current_Request_Query_graphql.Internal.convertVariables(variables)), {
        fetchKey: fetchKey,
        fetchPolicy: RescriptRelay.mapFetchPolicy(fetchPolicy),
        networkCacheConfig: networkCacheConfig
      });
  return RescriptRelay_Internal.internal_useConvertedValue(RfqRequestDetailBuyer_Current_Request_Query_graphql.Internal.convertResponse, data);
}

function useLoader(param) {
  var match = ReactRelay.useQueryLoader(RfqRequestDetailBuyer_Current_Request_Query_graphql.node);
  var loadQueryFn = match[1];
  var loadQuery = React$1.useMemo((function () {
          return function (param, param$1, param$2, param$3) {
            return Curry._2(loadQueryFn, RfqRequestDetailBuyer_Current_Request_Query_graphql.Internal.convertVariables(param), {
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
  ReactRelay.fetchQuery(environment, RfqRequestDetailBuyer_Current_Request_Query_graphql.node, RfqRequestDetailBuyer_Current_Request_Query_graphql.Internal.convertVariables(variables), {
          networkCacheConfig: networkCacheConfig,
          fetchPolicy: RescriptRelay.mapFetchQueryFetchPolicy(fetchPolicy)
        }).subscribe({
        next: (function (res) {
            Curry._1(onResult, {
                  TAG: /* Ok */0,
                  _0: RfqRequestDetailBuyer_Current_Request_Query_graphql.Internal.convertResponse(res)
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
  var __x = ReactRelay.fetchQuery(environment, RfqRequestDetailBuyer_Current_Request_Query_graphql.node, RfqRequestDetailBuyer_Current_Request_Query_graphql.Internal.convertVariables(variables), {
          networkCacheConfig: networkCacheConfig,
          fetchPolicy: RescriptRelay.mapFetchQueryFetchPolicy(fetchPolicy)
        }).toPromise();
  return Js_promise.then_((function (res) {
                return Promise.resolve(RfqRequestDetailBuyer_Current_Request_Query_graphql.Internal.convertResponse(res));
              }), __x);
}

function usePreloaded(queryRef, param) {
  var data = ReactRelay.usePreloadedQuery(RfqRequestDetailBuyer_Current_Request_Query_graphql.node, queryRef);
  return RescriptRelay_Internal.internal_useConvertedValue(RfqRequestDetailBuyer_Current_Request_Query_graphql.Internal.convertResponse, data);
}

function retain(environment, variables) {
  var operationDescriptor = RelayRuntime.createOperationDescriptor(RfqRequestDetailBuyer_Current_Request_Query_graphql.node, RfqRequestDetailBuyer_Current_Request_Query_graphql.Internal.convertVariables(variables));
  return environment.retain(operationDescriptor);
}

var Query_rfqRequestItemStatus_decode = RfqRequestDetailBuyer_Current_Request_Query_graphql.Utils.rfqRequestItemStatus_decode;

var Query_rfqRequestItemStatus_fromString = RfqRequestDetailBuyer_Current_Request_Query_graphql.Utils.rfqRequestItemStatus_fromString;

var Query_rfqRequestStatus_decode = RfqRequestDetailBuyer_Current_Request_Query_graphql.Utils.rfqRequestStatus_decode;

var Query_rfqRequestStatus_fromString = RfqRequestDetailBuyer_Current_Request_Query_graphql.Utils.rfqRequestStatus_fromString;

var Query = {
  rfqRequestItemStatus_decode: Query_rfqRequestItemStatus_decode,
  rfqRequestItemStatus_fromString: Query_rfqRequestItemStatus_fromString,
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

function RfqRequestDetail_Buyer$StatusLabel(props) {
  var status = props.status;
  var defaultStyle = "px-2 py-1 rounded-[4px] text-sm font-bold truncate";
  var redStyle = "bg-red-500 bg-opacity-10 text-red-500";
  if (status === "WAITING_FOR_QUOTATION" || status === "DRAFT" || status === "REVIEW_REQUIRED" || status === "READY_TO_REQUEST") {
    return null;
  } else if (status === "ORDER_TIMEOUT") {
    return React$1.createElement("div", {
                className: Cx.cx([
                      defaultStyle,
                      redStyle
                    ])
              }, "견적 만료");
  } else if (status === "WAITING_FOR_ORDER") {
    return React$1.createElement("div", {
                className: Cx.cx([
                      defaultStyle,
                      "bg-primary bg-opacity-10 text-primary"
                    ])
              }, "견적서 도착");
  } else if (status === "MATCH_FAILED") {
    return React$1.createElement("div", {
                className: Cx.cx([
                      defaultStyle,
                      "bg-gray-600 bg-opacity-10 text-gray-600"
                    ])
              }, "견적 실패");
  } else if (status === "ORDERED") {
    return React$1.createElement("div", {
                className: Cx.cx([
                      defaultStyle,
                      "bg-blue-500 bg-opacity-10 text-blue-500"
                    ])
              }, "주문 요청");
  } else if (status === "REQUEST_CANCELED") {
    return React$1.createElement("div", {
                className: Cx.cx([
                      defaultStyle,
                      redStyle
                    ])
              }, "요청 취소");
  } else {
    return null;
  }
}

var StatusLabel = {
  make: RfqRequestDetail_Buyer$StatusLabel
};

function RfqRequestDetail_Buyer$QuotationListitem(props) {
  var itemId = props.itemId;
  var router = Router.useRouter();
  return React$1.createElement("li", {
              className: "flex items-center mx-5 p-5 cursor-pointer bg-white rounded-lg mb-3",
              onClick: (function (param) {
                  router.push("" + router.asPath + "/" + itemId + "");
                })
            }, React$1.createElement("div", {
                  className: "flex flex-col justify-between truncate"
                }, React$1.createElement(DS_TitleList.Left.Title3Subtitle1.make, {
                      title1: props.speciesName,
                      title2: props.name,
                      title3: props.isDomestic ? "국내" : "수입"
                    })), React$1.createElement("div", {
                  className: "ml-auto pl-2"
                }, React$1.createElement("div", {
                      className: "flex items-center"
                    }, React$1.createElement(RfqRequestDetail_Buyer$StatusLabel, {
                          status: props.status
                        }), React$1.createElement(DS_Icon.Common.ArrowRightLarge1.make, {
                          height: "24",
                          width: "24"
                        }))));
}

var QuotationListitem = {
  make: RfqRequestDetail_Buyer$QuotationListitem
};

function RfqRequestDetail_Buyer$BottomButton(props) {
  var requestId = props.requestId;
  var status = props.status;
  var router = Router.useRouter();
  if (!(status === "WAITING_FOR_QUOTATION" || status === "REQUEST_CANCELED" || status === "REQUEST_PROCESSED" || status === "REVIEW_REQUIRED" || status === "READY_TO_REQUEST") && status === "DRAFT") {
    return React$1.createElement(DS_ButtonContainer.Floating1.make, {
                label: "견적서 이어 작성하기",
                onClick: (function (param) {
                    DataGtm.push(DataGtm.mergeUserIdUnsafe({
                              event: "Expose_view_RFQ_Livestock_SelectingPart"
                            }));
                    router.push("/buyer/rfq/request/draft/basket?requestId=" + requestId + "");
                  })
              });
  }
  return React$1.createElement(DS_ButtonContainer.Floating1.make, {
              label: "담당자에게 문의하기",
              onClick: (function (param) {
                  if (Global.$$window !== undefined) {
                    Caml_option.valFromOption(Global.$$window).open("" + Env.customerServiceUrl + "" + Env.customerServicePaths.rfqContactManager + "", undefined, "");
                    return ;
                  }
                  
                }),
              buttonType: "white"
            });
}

var BottomButton = {
  make: RfqRequestDetail_Buyer$BottomButton
};

function RfqRequestDetail_Buyer$TimerTitle(props) {
  var remainSecondsUntilQuotationExpired = props.remainSecondsUntilQuotationExpired;
  var match = React$1.useState(function () {
        return remainSecondsUntilQuotationExpired;
      });
  var setTime = match[1];
  var time = match[0];
  React$1.useEffect((function () {
          var id = setInterval((function (param) {
                  setTime(function (time) {
                        return Math.max(0, time - 1 | 0);
                      });
                }), 1000);
          return (function (param) {
                    clearInterval(id);
                  });
        }), []);
  var getRemainTimes = function (s) {
    var oneHourSeconds = 3600;
    var oneDaySeconds = Math.imul(oneHourSeconds, 24);
    var remainDays = Caml_int32.div(s, oneDaySeconds);
    var remainHourSeconds = Caml_int32.mod_(s, oneDaySeconds);
    var remainHours = Caml_int32.div(remainHourSeconds, oneHourSeconds);
    var remainMinuteSeconds = Caml_int32.mod_(remainHourSeconds, oneHourSeconds);
    var remainMinutes = remainMinuteSeconds / 60 | 0;
    var remainSeconds = remainMinuteSeconds % 60;
    return [
            {
              TAG: /* Day */0,
              _0: remainDays
            },
            {
              TAG: /* Hour */1,
              _0: remainHours
            },
            {
              TAG: /* Minute */2,
              _0: remainMinutes
            },
            {
              TAG: /* Second */3,
              _0: remainSeconds
            }
          ];
  };
  var getTimeText = function (time) {
    var generateText = function (num, postfix) {
      return Belt_Option.mapWithDefault(Belt_Option.keep(num, (function (x) {
                        return x > 0;
                      })), "", (function (x) {
                    return "" + String(x) + "" + postfix + "";
                  }));
    };
    switch (time.TAG | 0) {
      case /* Day */0 :
          return generateText(time._0, "일 ");
      case /* Hour */1 :
          return generateText(time._0, "시간 ");
      case /* Minute */2 :
          return generateText(time._0, "분 ");
      case /* Second */3 :
          return generateText(time._0, "초");
      
    }
  };
  var match$1 = getRemainTimes(time);
  var dayText = getTimeText(match$1[0]);
  var hourText = getTimeText(match$1[1]);
  var minuteText = getTimeText(match$1[2]);
  var secondText = getTimeText(match$1[3]);
  var timeText = time > 0 ? "" + dayText + "" + hourText + "" + minuteText + "" + secondText + " 후 마감됩니다." : "마감되었습니다.";
  return React$1.createElement(DS_Title.Normal1.TextGroup.make, {
              title1: "견적 요청 현황",
              subTitle: timeText
            });
}

var TimerTitle = {
  make: RfqRequestDetail_Buyer$TimerTitle
};

function RfqRequestDetail_Buyer$Title(props) {
  var status = props.status;
  return React$1.createElement(DS_Title.Normal1.Root.make, {
              children: status === "WAITING_FOR_QUOTATION" || status === "REVIEW_REQUIRED" || status === "READY_TO_REQUEST" ? React$1.createElement(DS_Title.Normal1.TextGroup.make, {
                      title1: "요청 중인 견적서입니다.",
                      subTitle: "견적서가 도착하면 알려드릴게요."
                    }) : (
                  status === "DRAFT" ? React$1.createElement(DS_Title.Normal1.TextGroup.make, {
                          title1: "작성 중인 견적서입니다.",
                          subTitle: "아래의 버튼을 눌러 이어 작성해주세요."
                        }) : (
                      status === "REQUEST_PROCESSED" ? React$1.createElement(RfqRequestDetail_Buyer$TimerTitle, {
                              remainSecondsUntilQuotationExpired: props.remainSecondsUntilQuotationExpired
                            }) : (
                          status === "REQUEST_CANCELED" ? React$1.createElement(DS_Title.Normal1.TextGroup.make, {
                                  title1: "요청이 취소된 견적서입니다.",
                                  subTitle: "아래의 버튼을 눌러 새로운 견적을 신청해주세요."
                                }) : React$1.createElement(DS_Title.Normal1.TextGroup.make, {
                                  title1: "잘못된 견적서입니다.",
                                  subTitle: "견적서 정보를 확인할 수 없습니다."
                                })
                        )
                    )
                ),
              className: "mt-10 mb-10"
            });
}

var Title = {
  make: RfqRequestDetail_Buyer$Title
};

function RfqRequestDetail_Buyer$Detail(props) {
  var requestId = props.requestId;
  var match = use({
        id: requestId
      }, /* NetworkOnly */3, undefined, undefined, undefined);
  var node = match.node;
  React$1.useEffect((function () {
          DataGtm.push(DataGtm.mergeUserIdUnsafe({
                    event: "view_rfq_livestock_status_quotationlist",
                    request_id: requestId
                  }));
        }), []);
  if (node === undefined) {
    return React$1.createElement("div", {
                className: "relative container max-w-3xl mx-auto min-h-screen sm:shadow-gl pt-7 pb-[96px] bg-gray-50"
              }, React$1.createElement(DS_Title.Normal1.Root.make, {
                    children: React$1.createElement(DS_Title.Normal1.TextGroup.make, {
                          title1: "견적서 정보를 찾을 수 없습니다.",
                          subTitle: "아래의 버튼을 눌러 문의해주세요."
                        }),
                    className: "mt-10 mb-10"
                  }), React$1.createElement(RfqRequestDetail_Buyer$BottomButton, {
                    status: "NONE",
                    requestId: requestId
                  }));
  }
  var status = node.status;
  return React$1.createElement("div", {
              className: "relative container max-w-3xl mx-auto min-h-screen sm:shadow-gl pt-7 pb-[96px] bg-gray-50"
            }, React$1.createElement(RfqRequestDetail_Buyer$Title, {
                  status: status,
                  remainSecondsUntilQuotationExpired: node.remainSecondsUntilQuotationExpired
                }), Belt_Array.mapWithIndex(node.items.edges, (function (index, item) {
                    var match = item.node;
                    var species = match.species;
                    var part = match.part;
                    var itemId = match.id;
                    if (itemId !== undefined && part !== undefined && species !== undefined) {
                      return React.createElementWithKey(RfqRequestDetail_Buyer$QuotationListitem, {
                                  itemId: itemId,
                                  name: part.name,
                                  speciesName: species.shortName,
                                  isDomestic: part.isDomestic,
                                  status: match.status
                                }, String(index));
                    } else {
                      return null;
                    }
                  })), React$1.createElement("div", undefined), React$1.createElement(RfqRequestDetail_Buyer$BottomButton, {
                  status: status,
                  requestId: requestId
                }));
}

var Detail = {
  make: RfqRequestDetail_Buyer$Detail
};

function RfqRequestDetail_Buyer(props) {
  var requestId = props.requestId;
  var router = Router.useRouter();
  if (requestId !== undefined) {
    return React$1.createElement(Authorization.Buyer.make, {
                children: React$1.createElement(RfqRequestDetail_Buyer$Detail, {
                      requestId: requestId
                    }),
                title: "견적서 확인하기",
                fallback: Caml_option.some(null)
              });
  } else {
    React$1.useEffect((function () {
            router.replace("/buyer/rfq");
          }), []);
    return null;
  }
}

var make = RfqRequestDetail_Buyer;

export {
  Query ,
  StatusLabel ,
  QuotationListitem ,
  BottomButton ,
  TimerTitle ,
  Title ,
  Detail ,
  make ,
}
/* Env Not a pure module */
