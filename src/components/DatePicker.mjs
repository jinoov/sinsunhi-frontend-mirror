// Generated by ReScript, PLEASE EDIT WITH CARE

import * as CssJs from "bs-css-emotion/src/CssJs.mjs";
import * as Curry from "rescript/lib/es6/curry.js";
import * as React from "react";
import * as Belt_Int from "rescript/lib/es6/belt_Int.js";
import * as Belt_Array from "rescript/lib/es6/belt_Array.js";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as Css_Js_Core from "bs-css/src/Css_Js_Core.mjs";
import * as DuetDatePicker from "../bindings/DuetDatePicker.mjs";
import Format from "date-fns/format";
import CalendarSvg from "../../public/assets/calendar.svg";

var calendarIcon = CalendarSvg;

var wrapper = CssJs.style([
      CssJs.selector(".duet-date__input-wrapper", [CssJs.width(CssJs.pct(100.0))]),
      CssJs.selector(".duet-date__input", [
            CssJs.height(CssJs.rem(2.25)),
            CssJs.border(CssJs.px(1), "solid", CssJs.hex("D5D5DD")),
            CssJs.padding2(CssJs.rem(0.25), CssJs.rem(1.0)),
            CssJs.textAlign("left"),
            CssJs.borderRadius(CssJs.px(8))
          ]),
      CssJs.selector("input::placeholder", [CssJs.color(CssJs.hex("808080"))]),
      CssJs.selector(".duet-date__toggle", [
            CssJs.width(CssJs.pct(100.0)),
            CssJs.opacity(0.0)
          ]),
      CssJs.selector(".duet-date__day.is-today.is-month", [
            CssJs.color(CssJs.hex("262626")),
            CssJs.background(CssJs.hex("ebfded")),
            CssJs.boxShadow(Css_Js_Core.Shadow.box(CssJs.px(0), CssJs.px(0), CssJs.px(0), CssJs.px(1), undefined, CssJs.hex("12b564")))
          ]),
      CssJs.selector(".duet-date__day.is-today.is-month[aria-pressed=true]", [
            CssJs.color(CssJs.white),
            CssJs.background(CssJs.hex("12b564"))
          ]),
      CssJs.selector(".duet-date__day.is-month[aria-pressed=true]", [CssJs.background(CssJs.hex("12b564"))]),
      CssJs.selector(".duet-date__day:focus", [
            CssJs.color(CssJs.white),
            CssJs.background(CssJs.hex("12b564")),
            CssJs.boxShadow(Css_Js_Core.Shadow.box(CssJs.px(0), CssJs.px(0), CssJs.px(5), CssJs.px(1), undefined, CssJs.hex("12b564")))
          ]),
      CssJs.marginRight(CssJs.px(4)),
      CssJs.lastOfType([CssJs.marginRight(CssJs.px(0))]),
      CssJs.display("block"),
      CssJs.position("relative")
    ]);

var Styles = {
  wrapper: wrapper
};

function DatePicker(Props) {
  var id = Props.id;
  var onChange = Props.onChange;
  var date = Props.date;
  var maxDate = Props.maxDate;
  var minDate = Props.minDate;
  var firstDayOfWeek = Props.firstDayOfWeek;
  var align = Props.align;
  var isDateDisabled = Props.isDateDisabled;
  var onFocus = Props.onFocus;
  var disabled = Props.disabled;
  var dateRe = /^(\d{4})\-(\d{1,2})\-(\d{1,2})$/;
  var tmp = {
    identifier: id,
    dateAdapter: {
      parse: (function (value, createDate) {
          return Belt_Option.flatMap(Caml_option.null_to_opt(dateRe.exec(value)), (function (result) {
                        var match = Belt_Option.flatMap(Belt_Array.get(result, 1), (function (prim) {
                                if (prim == null) {
                                  return ;
                                } else {
                                  return Caml_option.some(prim);
                                }
                              }));
                        var match$1 = Belt_Option.flatMap(Belt_Array.get(result, 2), (function (prim) {
                                if (prim == null) {
                                  return ;
                                } else {
                                  return Caml_option.some(prim);
                                }
                              }));
                        var match$2 = Belt_Option.flatMap(Belt_Array.get(result, 3), (function (prim) {
                                if (prim == null) {
                                  return ;
                                } else {
                                  return Caml_option.some(prim);
                                }
                              }));
                        if (match !== undefined && match$1 !== undefined && match$2 !== undefined) {
                          return Belt_Option.map(Belt_Int.fromString(match$1), (function (month) {
                                        return Curry._3(createDate, match, String(month + 1 | 0), match$2);
                                      }));
                        }
                        
                      }));
        }),
      format: (function (date) {
          return Format(date, "yyyy-MM-dd");
        })
    },
    localization: DuetDatePicker.krLocalization,
    onChange: onChange,
    direction: align !== undefined && !align ? "left" : "right"
  };
  var tmp$1 = Belt_Option.map(date, (function (date$p) {
          return Format(date$p, "yyyy-MM-dd");
        }));
  if (tmp$1 !== undefined) {
    tmp.value = tmp$1;
  }
  if (onFocus !== undefined) {
    tmp.onFocus = Caml_option.valFromOption(onFocus);
  }
  if (maxDate !== undefined) {
    tmp.max = maxDate;
  }
  if (minDate !== undefined) {
    tmp.min = minDate;
  }
  if (firstDayOfWeek !== undefined) {
    tmp.firstDayOfWeek = firstDayOfWeek;
  }
  if (isDateDisabled !== undefined) {
    tmp.isDateDisabled = Caml_option.valFromOption(isDateDisabled);
  }
  if (disabled !== undefined) {
    tmp.disabled = disabled;
  }
  return React.createElement("label", {
              className: wrapper
            }, React.createElement(DuetDatePicker.make, tmp), React.createElement("img", {
                  className: "absolute top-2 right-3",
                  src: calendarIcon
                }));
}

var make = DatePicker;

export {
  calendarIcon ,
  Styles ,
  make ,
  
}
/* calendarIcon Not a pure module */
