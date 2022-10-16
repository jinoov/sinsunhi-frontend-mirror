// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Curry from "rescript/lib/es6/curry.js";
import * as Input from "./common/Input.mjs";
import * as React from "react";
import * as Js_dict from "rescript/lib/es6/js_dict.js";
import * as Textarea from "./common/Textarea.mjs";
import * as Belt_Array from "rescript/lib/es6/belt_Array.js";
import * as DatePicker from "./DatePicker.mjs";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as ReactEvents from "../utils/ReactEvents.mjs";
import * as Router from "next/router";
import * as Garter_Array from "@greenlabs/garter/src/Garter_Array.mjs";
import Parse from "date-fns/parse";
import * as IconArrowSelect from "./svgs/IconArrowSelect.mjs";
import * as ReForm__Helpers from "@rescriptbr/reform/src/ReForm__Helpers.mjs";
import Format from "date-fns/format";
import SubDays from "date-fns/subDays";
import * as PeriodSelector_Settlement from "./common/PeriodSelector_Settlement.mjs";
import * as Query_Settlement_Form_Admin from "./Query_Settlement_Form_Admin.mjs";

function getSettlementCycle(q) {
  return Js_dict.get(q, "settlement-cycle");
}

function parseSettlementCycle(value) {
  if (value === "week") {
    return /* Week */0;
  } else if (value === "half-month") {
    return /* HalfMonth */1;
  } else if (value === "month") {
    return /* Month */2;
  } else {
    return ;
  }
}

function stringifySettlementCycle(settlementCycle) {
  switch (settlementCycle) {
    case /* Week */0 :
        return "1주";
    case /* HalfMonth */1 :
        return "15일";
    case /* Month */2 :
        return "1개월";
    
  }
}

function Summary_Settlement_Admin(Props) {
  var onReset = Props.onReset;
  var onQuery = Props.onQuery;
  var router = Router.useRouter();
  var match = React.useState(function () {
        return /* Week */0;
      });
  var setSettlementCycle = match[1];
  var settlementCycle = match[0];
  var match$1 = React.useState(function () {
        return {
                from: SubDays(new Date(), 7),
                to_: new Date()
              };
      });
  var setQuery = match$1[1];
  var query = match$1[0];
  var handleOnChangeDate = function (t, e) {
    var newDate = e.detail.valueAsDate;
    if (t) {
      if (newDate === undefined) {
        return ;
      }
      var newDate$p = Caml_option.valFromOption(newDate);
      return setQuery(function (prev) {
                  return {
                          from: prev.from,
                          to_: newDate$p
                        };
                });
    }
    if (newDate === undefined) {
      return ;
    }
    var newDate$p$1 = Caml_option.valFromOption(newDate);
    setQuery(function (prev) {
          return {
                  from: newDate$p$1,
                  to_: prev.to_
                };
        });
  };
  var handleOnChangeSettlementCycle = function (f, t) {
    setQuery(function (param) {
          return {
                  from: f,
                  to_: t
                };
        });
  };
  var onSubmit = function (param) {
    var state = param.state;
    var producerName = Query_Settlement_Form_Admin.FormFields.get(state.values, /* ProducerName */0);
    var producerCodes = Query_Settlement_Form_Admin.FormFields.get(state.values, /* ProducerCodes */1);
    router.query["producer-name"] = producerName;
    router.query["producer-codes"] = producerCodes;
    var tmp;
    switch (settlementCycle) {
      case /* Week */0 :
          tmp = "week";
          break;
      case /* HalfMonth */1 :
          tmp = "half-month";
          break;
      case /* Month */2 :
          tmp = "month";
          break;
      
    }
    router.query["settlement-cycle"] = tmp;
    router.query["from"] = Format(query.from, "yyyyMMdd");
    router.query["to"] = Format(query.to_, "yyyyMMdd");
    router.push("" + router.pathname + "?" + new URLSearchParams(router.query).toString() + "");
  };
  var form = Curry._7(Query_Settlement_Form_Admin.Form.use, Query_Settlement_Form_Admin.initialState, /* Schema */{
        _0: Belt_Array.concatMany([Curry._4(Query_Settlement_Form_Admin.Form.ReSchema.Validation.regExp, "숫자(Enter 또는 \",\"로 구분 가능)만 입력해주세요", "^(G-[0-9]+([,\n\\s]+)?)*$", undefined, /* ProducerCodes */1)])
      }, onSubmit, undefined, undefined, /* OnChange */0, undefined);
  var handleOnSubmit = function (param) {
    return ReactEvents.interceptingHandler((function (param) {
                  Curry._1(onQuery, undefined);
                  Curry._1(form.submit, undefined);
                }), param);
  };
  React.useEffect((function () {
          Garter_Array.forEach(Js_dict.entries(router.query), (function (entry) {
                  var v = entry[1];
                  var k = entry[0];
                  if (k === "producer-name") {
                    return Curry._4(form.setFieldValue, /* ProducerName */0, v, true, undefined);
                  } else if (k === "producer-codes") {
                    return Curry._4(form.setFieldValue, /* ProducerCodes */1, v, true, undefined);
                  } else if (k === "settlement-cycle") {
                    return Belt_Option.forEach(parseSettlementCycle(v), (function (settlementCycle$p) {
                                  setSettlementCycle(function (param) {
                                        return settlementCycle$p;
                                      });
                                }));
                  } else if (k === "from") {
                    return setQuery(function (prev) {
                                return {
                                        from: Parse(v, "yyyyMMdd", new Date()),
                                        to_: prev.to_
                                      };
                              });
                  } else if (k === "to") {
                    return setQuery(function (prev) {
                                return {
                                        from: prev.from,
                                        to_: Parse(v, "yyyyMMdd", new Date())
                                      };
                              });
                  } else {
                    return ;
                  }
                }));
        }), [router.query]);
  var handleOnReset = function (param) {
    return ReactEvents.interceptingHandler((function (param) {
                  Curry._1(onReset, undefined);
                  Curry._4(form.setFieldValue, /* ProducerName */0, "", true, undefined);
                  Curry._4(form.setFieldValue, /* ProducerCodes */1, "", true, undefined);
                  setSettlementCycle(function (param) {
                        return /* Week */0;
                      });
                  setQuery(function (param) {
                        return {
                                from: SubDays(new Date(), 7),
                                to_: new Date()
                              };
                      });
                }), param);
  };
  var handleKeyDownEnter = function (e) {
    if (e.keyCode === 13 && e.shiftKey === false) {
      e.preventDefault();
      return Curry._1(form.submit, undefined);
    }
    
  };
  var partial_arg = Curry._1(form.handleChange, /* ProducerName */0);
  var partial_arg$1 = Curry._1(form.handleChange, /* ProducerCodes */1);
  return React.createElement("div", {
              className: "p-7 m-4 bg-white shadow-gl rounded"
            }, React.createElement("form", {
                  onSubmit: handleOnSubmit
                }, React.createElement("h2", {
                      className: "text-text-L1 text-lg font-bold mb-5"
                    }, "상품 검색"), React.createElement("div", {
                      className: "py-6 flex flex-col text-sm bg-gray-gl rounded-xl"
                    }, React.createElement("div", {
                          className: "flex"
                        }, React.createElement("div", {
                              className: "w-32 font-bold mt-2 pl-7 whitespace-nowrap"
                            }, "검색"), React.createElement("div", {
                              className: "flex-1"
                            }, React.createElement("div", {
                                  className: "flex"
                                }, React.createElement("div", {
                                      className: "w-64 flex items-center mr-16"
                                    }, React.createElement("label", {
                                          className: "whitespace-nowrap w-20 mr-2",
                                          htmlFor: "buyer-name"
                                        }, "생산자명"), React.createElement(Input.make, {
                                          type_: "text",
                                          name: "buyer-name",
                                          placeholder: "생산자명",
                                          value: Query_Settlement_Form_Admin.FormFields.get(form.values, /* ProducerName */0),
                                          onChange: (function (param) {
                                              return ReForm__Helpers.handleChange(partial_arg, param);
                                            }),
                                          error: undefined,
                                          tabIndex: 1
                                        })), React.createElement("div", {
                                      className: "min-w-1/2 flex items-center"
                                    }, React.createElement("label", {
                                          className: "whitespace-nowrap mr-4",
                                          htmlFor: "orderer-name"
                                        }, "생산자번호"), React.createElement(Textarea.make, {
                                          type_: "text",
                                          name: "orderer-name",
                                          placeholder: "생산자번호 입력(Enter 또는 “,”로 구분 가능, 최대 100개 입력 가능)",
                                          className: "flex-1",
                                          value: Query_Settlement_Form_Admin.FormFields.get(form.values, /* ProducerCodes */1),
                                          onChange: (function (param) {
                                              return ReForm__Helpers.handleChange(partial_arg$1, param);
                                            }),
                                          error: Curry._1(form.getFieldError, /* Field */{
                                                _0: /* ProducerCodes */1
                                              }),
                                          tabIndex: 2,
                                          rows: 1,
                                          onKeyDown: handleKeyDownEnter
                                        }))), React.createElement("div", {
                                  className: "flex mt-3"
                                }, React.createElement("div", {
                                      className: "w-64 flex items-center mr-2"
                                    }, React.createElement("label", {
                                          className: "block whitespace-nowrap w-16",
                                          htmlFor: "product-identifier"
                                        }, "정산주기"), React.createElement("div", {
                                          className: "flex-1 block relative"
                                        }, React.createElement("span", {
                                              className: "flex items-center border border-border-default-L1 rounded-lg py-2 px-3 text-enabled-L1 bg-white leading-4.5"
                                            }, stringifySettlementCycle(settlementCycle)), React.createElement("span", {
                                              className: "absolute top-1.5 right-2"
                                            }, React.createElement(IconArrowSelect.make, {
                                                  height: "24",
                                                  width: "24",
                                                  fill: "#121212"
                                                })), React.createElement("select", {
                                              className: "block w-full h-full absolute top-0 opacity-0",
                                              id: "period",
                                              value: stringifySettlementCycle(settlementCycle),
                                              onChange: (function (param) {
                                                  var value = param.target.value;
                                                  if (value === "1주") {
                                                    return setSettlementCycle(function (param) {
                                                                return /* Week */0;
                                                              });
                                                  } else if (value === "15일") {
                                                    return setSettlementCycle(function (param) {
                                                                return /* HalfMonth */1;
                                                              });
                                                  } else if (value === "1개월") {
                                                    return setSettlementCycle(function (param) {
                                                                return /* Month */2;
                                                              });
                                                  } else {
                                                    return setSettlementCycle(function (param) {
                                                                return /* Week */0;
                                                              });
                                                  }
                                                })
                                            }, React.createElement("option", {
                                                  value: "1주"
                                                }, "1주"), React.createElement("option", {
                                                  value: "15일"
                                                }, "15일"), React.createElement("option", {
                                                  value: "1개월"
                                                }, "1개월"))))))), React.createElement("div", {
                          className: "flex mt-3"
                        }, React.createElement("div", {
                              className: "w-32 font-bold flex items-center pl-7"
                            }, "기간"), React.createElement("div", {
                              className: "flex"
                            }, React.createElement("div", {
                                  className: "flex mr-8"
                                }, React.createElement(PeriodSelector_Settlement.make, {
                                      from: query.from,
                                      to_: query.to_,
                                      onSelect: handleOnChangeSettlementCycle
                                    })), React.createElement(DatePicker.make, {
                                  id: "from",
                                  onChange: (function (param) {
                                      return handleOnChangeDate(/* From */0, param);
                                    }),
                                  date: query.from,
                                  maxDate: Format(new Date(), "yyyy-MM-dd"),
                                  firstDayOfWeek: 0
                                }), React.createElement("span", {
                                  className: "flex items-center mr-1"
                                }, "~"), React.createElement(DatePicker.make, {
                                  id: "to",
                                  onChange: (function (param) {
                                      return handleOnChangeDate(/* To */1, param);
                                    }),
                                  date: query.to_,
                                  maxDate: Format(new Date(), "yyyy-MM-dd"),
                                  minDate: Format(query.from, "yyyy-MM-dd"),
                                  firstDayOfWeek: 0
                                })))), React.createElement("div", {
                      className: "flex justify-center mt-5"
                    }, React.createElement("span", {
                          className: "w-20 h-11 flex mr-2"
                        }, React.createElement("input", {
                              className: "btn-level6",
                              tabIndex: 7,
                              type: "button",
                              value: "초기화",
                              onClick: handleOnReset
                            })), React.createElement("span", {
                          className: "w-20 h-11 flex"
                        }, React.createElement("input", {
                              className: "btn-level1",
                              tabIndex: 6,
                              type: "submit",
                              value: "검색"
                            })))));
}

var FormFields;

var Form;

var make = Summary_Settlement_Admin;

export {
  FormFields ,
  Form ,
  getSettlementCycle ,
  parseSettlementCycle ,
  stringifySettlementCycle ,
  make ,
}
/* Input Not a pure module */
