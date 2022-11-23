// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Curry from "rescript/lib/es6/curry.js";
import * as React from "react";
import * as Textarea from "./common/Textarea.mjs";
import * as IconCheck from "./svgs/IconCheck.mjs";
import * as IconClose from "./svgs/IconClose.mjs";
import * as IconError from "./svgs/IconError.mjs";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as ReactRelay from "react-relay";
import * as RelayRuntime from "relay-runtime";
import * as Webapi__Dom__Element from "rescript-webapi/src/Webapi/Dom/Webapi__Dom__Element.mjs";
import * as ReactDialog from "@radix-ui/react-dialog";
import * as ReactToastNotifications from "react-toast-notifications";
import EditSvg from "../../public/assets/edit.svg";
import * as BulkSaleProducerMemoUpdateButtonMutation_graphql from "../__generated__/BulkSaleProducerMemoUpdateButtonMutation_graphql.mjs";

var editIcon = EditSvg;

function commitMutation(environment, variables, optimisticUpdater, optimisticResponse, updater, onCompleted, onError, uploadables, param) {
  return RelayRuntime.commitMutation(environment, {
              mutation: BulkSaleProducerMemoUpdateButtonMutation_graphql.node,
              variables: BulkSaleProducerMemoUpdateButtonMutation_graphql.Internal.convertVariables(variables),
              onCompleted: (function (res, err) {
                  if (onCompleted !== undefined) {
                    return Curry._2(onCompleted, BulkSaleProducerMemoUpdateButtonMutation_graphql.Internal.convertResponse(res), (err == null) ? undefined : Caml_option.some(err));
                  }
                  
                }),
              onError: (function (err) {
                  if (onError !== undefined) {
                    return Curry._1(onError, (err == null) ? undefined : Caml_option.some(err));
                  }
                  
                }),
              optimisticResponse: optimisticResponse !== undefined ? BulkSaleProducerMemoUpdateButtonMutation_graphql.Internal.convertWrapRawResponse(optimisticResponse) : undefined,
              optimisticUpdater: optimisticUpdater,
              updater: updater !== undefined ? (function (store, r) {
                    Curry._2(updater, store, BulkSaleProducerMemoUpdateButtonMutation_graphql.Internal.convertResponse(r));
                  }) : undefined,
              uploadables: uploadables
            });
}

function use(param) {
  var match = ReactRelay.useMutation(BulkSaleProducerMemoUpdateButtonMutation_graphql.node);
  var mutate = match[0];
  return [
          React.useMemo((function () {
                  return function (param, param$1, param$2, param$3, param$4, param$5, param$6, param$7, param$8) {
                    return Curry._1(mutate, {
                                onError: param,
                                onCompleted: param$1 !== undefined ? (function (r, errors) {
                                      Curry._2(param$1, BulkSaleProducerMemoUpdateButtonMutation_graphql.Internal.convertResponse(r), (errors == null) ? undefined : Caml_option.some(errors));
                                    }) : undefined,
                                onUnsubscribe: param$2,
                                optimisticResponse: param$3 !== undefined ? BulkSaleProducerMemoUpdateButtonMutation_graphql.Internal.convertWrapRawResponse(param$3) : undefined,
                                optimisticUpdater: param$4,
                                updater: param$5 !== undefined ? (function (store, r) {
                                      Curry._2(param$5, store, BulkSaleProducerMemoUpdateButtonMutation_graphql.Internal.convertResponse(r));
                                    }) : undefined,
                                variables: BulkSaleProducerMemoUpdateButtonMutation_graphql.Internal.convertVariables(param$6),
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

function BulkSale_Producer_Memo_Update_Button(Props) {
  var applicationId = Props.applicationId;
  var memoData = Props.memoData;
  var match = ReactToastNotifications.useToasts();
  var addToast = match.addToast;
  var match$1 = use(undefined);
  var mutate = match$1[0];
  var match$2 = React.useState(function () {
        return memoData;
      });
  var setMemo = match$2[1];
  var memo = match$2[0];
  var close = function (param) {
    var buttonClose = document.getElementById("btn-close");
    Belt_Option.forEach(Belt_Option.flatMap((buttonClose == null) ? undefined : Caml_option.some(buttonClose), Webapi__Dom__Element.asHtmlElement), (function (buttonClose$p) {
            buttonClose$p.click();
          }));
  };
  return React.createElement(ReactDialog.Root, {
              children: null
            }, React.createElement(ReactDialog.Overlay, {
                  className: "dialog-overlay"
                }), React.createElement(ReactDialog.Trigger, {
                  children: React.createElement("img", {
                        className: "mr-1",
                        src: editIcon
                      }),
                  className: "inline-flex"
                }), React.createElement(ReactDialog.Content, {
                  children: React.createElement("section", {
                        className: "p-5"
                      }, React.createElement("article", {
                            className: "flex justify-between"
                          }, React.createElement("h2", {
                                className: "text-xl font-bold"
                              }, "메모작성"), React.createElement(ReactDialog.Close, {
                                children: React.createElement(IconClose.make, {
                                      height: "24",
                                      width: "24",
                                      fill: "#262626"
                                    }),
                                className: "inline-block p-1 focus:outline-none ml-auto"
                              })), React.createElement("article", undefined, React.createElement("h5", {
                                className: "mt-7"
                              }, "메모"), React.createElement("div", {
                                className: "flex mt-2 h-[140px]"
                              }, React.createElement(Textarea.make, {
                                    type_: "online-sale-urls",
                                    name: "online-sale-urls",
                                    placeholder: "유저에게 노출되지 않는 메모입니다. (최대 200자)\n* test건의 경우, “#TEST”로 작성하여 표시합니다.\n* 표에서 125자(작성기준 2줄)까지 노출됩니다.\n* 전체 내용은 작성버튼을 누르거나 엑셀 파일을 다룬로드하여 확인할 수 있습니다.",
                                    className: "flex-1 mr-1 h-full",
                                    value: Belt_Option.getWithDefault(memo, ""),
                                    onChange: (function (param) {
                                        var value = param.target.value;
                                        return setMemo(function (param) {
                                                    return value;
                                                  });
                                      }),
                                    size: /* XLarge */0,
                                    error: undefined
                                  }))), React.createElement("div", {
                            className: "flex justify-center items-center mt-8"
                          }, React.createElement(ReactDialog.Close, {
                                children: React.createElement("span", {
                                      className: "py-1.5 px-3 text-sm font-normal rounded-lg bg-surface mr-1",
                                      id: "btn-close"
                                    }, "닫기"),
                                className: "flex"
                              }), React.createElement("span", {
                                className: "py-1.5 px-3 text-sm font-normal rounded-lg bg-primary text-white ml-1",
                                disabled: match$1[1],
                                onClick: (function (param) {
                                    var input_input = {
                                      memo: Belt_Option.getWithDefault(memo, "")
                                    };
                                    var input = {
                                      id: applicationId,
                                      input: input_input
                                    };
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
                                              close(undefined);
                                            }),
                                          (function (param, param$1) {
                                              addToast(React.createElement("div", {
                                                        className: "flex items-center"
                                                      }, React.createElement(IconCheck.make, {
                                                            height: "24",
                                                            width: "24",
                                                            fill: "#12B564",
                                                            className: "mr-2"
                                                          }), "메모를 수정하였습니다."), {
                                                    appearance: "success"
                                                  });
                                              close(undefined);
                                            }),
                                          undefined,
                                          undefined,
                                          undefined,
                                          undefined,
                                          input,
                                          undefined,
                                          undefined
                                        ]);
                                  })
                              }, "저장"))),
                  className: "dialog-content-memo overflow-y-auto rounded-xl",
                  onOpenAutoFocus: (function (prim) {
                      prim.preventDefault();
                    })
                }));
}

var make = BulkSale_Producer_Memo_Update_Button;

export {
  editIcon ,
  Mutation ,
  make ,
}
/* editIcon Not a pure module */
