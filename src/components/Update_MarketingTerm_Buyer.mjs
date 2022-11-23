// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Env from "../constants/Env.mjs";
import * as Curry from "rescript/lib/es6/curry.js";
import * as React from "react";
import * as Switcher from "./common/Switcher.mjs";
import * as Belt_List from "rescript/lib/es6/belt_List.js";
import * as IconClose from "./svgs/IconClose.mjs";
import Link from "next/link";
import * as Belt_Array from "rescript/lib/es6/belt_Array.js";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as ReactRelay from "react-relay";
import * as RelayRuntime from "relay-runtime";
import * as Js_null_undefined from "rescript/lib/es6/js_null_undefined.js";
import * as ReactDialog from "@radix-ui/react-dialog";
import * as RescriptRelay_Internal from "rescript-relay/src/RescriptRelay_Internal.mjs";
import * as UpdateMarketingTermBuyer_Fragment_graphql from "../__generated__/UpdateMarketingTermBuyer_Fragment_graphql.mjs";
import * as UpdateMarketingTermBuyer_Mutation_graphql from "../__generated__/UpdateMarketingTermBuyer_Mutation_graphql.mjs";

function use(fRef) {
  var data = ReactRelay.useFragment(UpdateMarketingTermBuyer_Fragment_graphql.node, fRef);
  return RescriptRelay_Internal.internal_useConvertedValue(UpdateMarketingTermBuyer_Fragment_graphql.Internal.convertFragment, data);
}

function useOpt(opt_fRef) {
  var fr = opt_fRef !== undefined ? Caml_option.some(Caml_option.valFromOption(opt_fRef)) : undefined;
  var nullableFragmentData = ReactRelay.useFragment(UpdateMarketingTermBuyer_Fragment_graphql.node, fr !== undefined ? Js_null_undefined.fromOption(Caml_option.some(Caml_option.valFromOption(fr))) : null);
  var data = (nullableFragmentData == null) ? undefined : Caml_option.some(nullableFragmentData);
  return RescriptRelay_Internal.internal_useConvertedValue((function (rawFragment) {
                if (rawFragment !== undefined) {
                  return UpdateMarketingTermBuyer_Fragment_graphql.Internal.convertFragment(rawFragment);
                }
                
              }), data);
}

var Fragment = {
  Types: undefined,
  Operation: undefined,
  use: use,
  useOpt: useOpt
};

function commitMutation(environment, variables, optimisticUpdater, optimisticResponse, updater, onCompleted, onError, uploadables, param) {
  return RelayRuntime.commitMutation(environment, {
              mutation: UpdateMarketingTermBuyer_Mutation_graphql.node,
              variables: UpdateMarketingTermBuyer_Mutation_graphql.Internal.convertVariables(variables),
              onCompleted: (function (res, err) {
                  if (onCompleted !== undefined) {
                    return Curry._2(onCompleted, UpdateMarketingTermBuyer_Mutation_graphql.Internal.convertResponse(res), (err == null) ? undefined : Caml_option.some(err));
                  }
                  
                }),
              onError: (function (err) {
                  if (onError !== undefined) {
                    return Curry._1(onError, (err == null) ? undefined : Caml_option.some(err));
                  }
                  
                }),
              optimisticResponse: optimisticResponse !== undefined ? UpdateMarketingTermBuyer_Mutation_graphql.Internal.convertWrapRawResponse(optimisticResponse) : undefined,
              optimisticUpdater: optimisticUpdater,
              updater: updater !== undefined ? (function (store, r) {
                    Curry._2(updater, store, UpdateMarketingTermBuyer_Mutation_graphql.Internal.convertResponse(r));
                  }) : undefined,
              uploadables: uploadables
            });
}

function use$1(param) {
  var match = ReactRelay.useMutation(UpdateMarketingTermBuyer_Mutation_graphql.node);
  var mutate = match[0];
  return [
          React.useMemo((function () {
                  return function (param, param$1, param$2, param$3, param$4, param$5, param$6, param$7, param$8) {
                    return Curry._1(mutate, {
                                onError: param,
                                onCompleted: param$1 !== undefined ? (function (r, errors) {
                                      Curry._2(param$1, UpdateMarketingTermBuyer_Mutation_graphql.Internal.convertResponse(r), (errors == null) ? undefined : Caml_option.some(errors));
                                    }) : undefined,
                                onUnsubscribe: param$2,
                                optimisticResponse: param$3 !== undefined ? UpdateMarketingTermBuyer_Mutation_graphql.Internal.convertWrapRawResponse(param$3) : undefined,
                                optimisticUpdater: param$4,
                                updater: param$5 !== undefined ? (function (store, r) {
                                      Curry._2(param$5, store, UpdateMarketingTermBuyer_Mutation_graphql.Internal.convertResponse(r));
                                    }) : undefined,
                                variables: UpdateMarketingTermBuyer_Mutation_graphql.Internal.convertVariables(param$6),
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
  use: use$1
};

function Update_MarketingTerm_Buyer(Props) {
  var isOpen = Props.isOpen;
  var onClose = Props.onClose;
  var query = Props.query;
  var match = use(query);
  var match$1 = use$1(undefined);
  var mutate = match$1[0];
  var status = Belt_Option.isSome(Belt_List.getAssoc(Belt_List.fromArray(Belt_Array.map(match.terms.edges, (function (param) {
                      var match = param.node;
                      var agreement = match.agreement;
                      return [
                              agreement,
                              [
                                agreement,
                                match.id
                              ]
                            ];
                    }))), "marketing", (function (a, b) {
              return a === b;
            })));
  var handleChange = function (param) {
    Curry.app(mutate, [
          undefined,
          undefined,
          undefined,
          undefined,
          undefined,
          undefined,
          {
            isAgree: !status
          },
          undefined,
          undefined
        ]);
  };
  return React.createElement(ReactDialog.Root, {
              children: null,
              open: isOpen
            }, React.createElement(ReactDialog.Overlay, {
                  className: "dialog-overlay"
                }), React.createElement(ReactDialog.Content, {
                  children: React.createElement("div", {
                        className: "fixed top-0 left-0 h-full xl:static bg-white w-full max-w-3xl xl:min-h-fit xl:min-w-min xl:w-[90vh] xl:max-w-[480px] xl:max-h-[85vh] "
                      }, React.createElement("section", {
                            className: "h-14 w-full xl:h-auto xl:w-auto xl:mt-10"
                          }, React.createElement("div", {
                                className: "flex items-center justify-between px-5 w-full py-4 xl:h-14 xl:w-full xl:pb-10"
                              }, React.createElement("div", {
                                    className: "w-6"
                                  }), React.createElement("div", undefined, React.createElement("span", {
                                        className: "font-bold"
                                      }, "서비스 이용동의")), React.createElement(ReactDialog.Close, {
                                    onClick: (function (param) {
                                        Curry._1(onClose, undefined);
                                      }),
                                    children: React.createElement(IconClose.make, {
                                          height: "24",
                                          width: "24",
                                          fill: "#262626"
                                        }),
                                    className: "focus:outline-none"
                                  }))), React.createElement("section", {
                            className: "my-6 px-4"
                          }, React.createElement("div", {
                                className: "flex flex-col "
                              }, React.createElement("div", {
                                    className: "flex flex-col mb-10"
                                  }, React.createElement("ol", undefined, React.createElement(Link, {
                                            href: Env.termsUrl,
                                            children: React.createElement("a", {
                                                  rel: "noopener",
                                                  target: "_blank"
                                                }, React.createElement("li", {
                                                      className: "py-4 text-sm border-b"
                                                    }, React.createElement("span", {
                                                          className: "font-bold"
                                                        }, "이용약관"), React.createElement("span", {
                                                          className: "text-text-L3 ml-1"
                                                        }, "자세히보기")))
                                          }), React.createElement(Link, {
                                            href: Env.privacyPolicyUrl,
                                            children: React.createElement("a", {
                                                  rel: "noopener",
                                                  target: "_blank"
                                                }, React.createElement("li", {
                                                      className: "py-4 text-sm border-b"
                                                    }, React.createElement("span", {
                                                          className: "font-bold"
                                                        }, "개인정보 처리방침"), React.createElement("span", {
                                                          className: "text-text-L3 ml-1"
                                                        }, "자세히보기")))
                                          }), React.createElement("li", {
                                            className: "py-4 text-sm flex justify-between items-center border-b"
                                          }, React.createElement(Link, {
                                                href: Env.privacyMarketing,
                                                children: React.createElement("a", {
                                                      rel: "noopener",
                                                      target: "_blank"
                                                    }, React.createElement("span", {
                                                          className: "font-bold"
                                                        }, "마케팅 이용 동의(선택)"), React.createElement("span", {
                                                          className: "text-text-L3 ml-1"
                                                        }, "자세히보기"))
                                              }), React.createElement("div", {
                                                className: "mr-2"
                                              }, React.createElement(Switcher.make, {
                                                    checked: status,
                                                    onCheckedChange: handleChange,
                                                    disabled: match$1[1]
                                                  })))))))),
                  className: "dialog-content-plain bottom-0 left-0 xl:bottom-auto xl:left-auto xl:rounded-2xl xl:state-open:top-1/2 xl:state-open:left-1/2 xl:state-open:-translate-x-1/2 xl:state-open:-translate-y-1/2",
                  onOpenAutoFocus: (function (prim) {
                      prim.preventDefault();
                    })
                }));
}

var make = Update_MarketingTerm_Buyer;

export {
  Fragment ,
  Mutation ,
  make ,
}
/* Env Not a pure module */
