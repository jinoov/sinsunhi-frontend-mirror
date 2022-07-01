// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Spice from "@greenlabs/ppx-spice/src/rescript/Spice.mjs";
import * as Js_dict from "rescript/lib/es6/js_dict.js";
import * as Js_json from "rescript/lib/es6/js_json.js";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as Belt_Result from "rescript/lib/es6/belt_Result.js";

function selectValue_encode(v) {
  return Js_dict.fromArray([
              [
                "value",
                Spice.stringToJson(v.value)
              ],
              [
                "label",
                Spice.stringToJson(v.label)
              ]
            ]);
}

function selectValue_decode(v) {
  var dict = Js_json.classify(v);
  if (typeof dict === "number") {
    return Spice.error(undefined, "Not an object", v);
  }
  if (dict.TAG !== /* JSONObject */2) {
    return Spice.error(undefined, "Not an object", v);
  }
  var dict$1 = dict._0;
  var value = Spice.stringFromJson(Belt_Option.getWithDefault(Js_dict.get(dict$1, "value"), null));
  if (value.TAG === /* Ok */0) {
    var label = Spice.stringFromJson(Belt_Option.getWithDefault(Js_dict.get(dict$1, "label"), null));
    if (label.TAG === /* Ok */0) {
      return {
              TAG: /* Ok */0,
              _0: {
                value: value._0,
                label: label._0
              }
            };
    }
    var e = label._0;
    return {
            TAG: /* Error */1,
            _0: {
              path: ".label" + e.path,
              message: e.message,
              value: e.value
            }
          };
  }
  var e$1 = value._0;
  return {
          TAG: /* Error */1,
          _0: {
            path: ".value" + e$1.path,
            message: e$1.message,
            value: e$1.value
          }
        };
}

function encoderRule(v) {
  if (v) {
    return Js_dict.fromArray([
                [
                  "value",
                  v.value
                ],
                [
                  "label",
                  v.label
                ]
              ]);
  } else {
    return null;
  }
}

function decoderRule(j) {
  return {
          TAG: /* Ok */0,
          _0: Belt_Result.mapWithDefault(selectValue_decode(j), /* NotSelected */0, (function (param) {
                  return /* Selected */{
                          value: param.value,
                          label: param.label
                        };
                }))
        };
}

var codecSelectOption = [
  encoderRule,
  decoderRule
];

function toOption(t) {
  if (t) {
    return {
            value: t.value,
            label: t.label
          };
  }
  
}

var Plain = {};

export {
  selectValue_encode ,
  selectValue_decode ,
  encoderRule ,
  decoderRule ,
  codecSelectOption ,
  toOption ,
  Plain ,
  
}
/* No side effect */
