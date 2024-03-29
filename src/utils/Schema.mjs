// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Curry from "rescript/lib/es6/curry.js";
import * as Js_dict from "rescript/lib/es6/js_dict.js";
import * as Js_json from "rescript/lib/es6/js_json.js";
import * as Belt_Array from "rescript/lib/es6/belt_Array.js";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as Caml_option from "rescript/lib/es6/caml_option.js";

function validate(vs, data) {
  return Belt_Array.reduce(vs, {
              TAG: /* Ok */0,
              _0: data
            }, (function (r, v) {
                var match = Curry._1(v, data);
                if (r.TAG === /* Ok */0) {
                  if (match.TAG === /* Ok */0) {
                    return {
                            TAG: /* Ok */0,
                            _0: r._0
                          };
                  } else {
                    return {
                            TAG: /* Error */1,
                            _0: [match._0]
                          };
                  }
                }
                var errs = r._0;
                if (match.TAG === /* Ok */0) {
                  return {
                          TAG: /* Error */1,
                          _0: errs
                        };
                } else {
                  return {
                          TAG: /* Error */1,
                          _0: Belt_Array.concat(errs, [match._0])
                        };
                }
              }));
}

function makeError(keyName, type_, msg) {
  return {
          type: type_,
          message: msg,
          keyName: keyName
        };
}

function makeResolverError(errors) {
  var resolverError = Belt_Array.reduce(errors, {}, (function (dict, error) {
          var match = Js_dict.get(dict, error.keyName);
          if (match !== undefined) {
            
          } else {
            dict[error.keyName] = Js_dict.fromArray([
                  [
                    "type",
                    error.type
                  ],
                  [
                    "message",
                    error.message
                  ]
                ]);
          }
          return dict;
        }));
  return {
          values: {},
          errors: resolverError
        };
}

function notEmpty(keyName, error, data) {
  var s = Js_dict.get(data, keyName);
  if (s === undefined) {
    return {
            TAG: /* Error */1,
            _0: error
          };
  }
  var str = Js_json.decodeString(Caml_option.valFromOption(s));
  if (str === "") {
    return {
            TAG: /* Error */1,
            _0: error
          };
  } else {
    return {
            TAG: /* Ok */0,
            _0: data
          };
  }
}

function maxLength(keyName, max, error, data) {
  var i = Belt_Option.map(Belt_Option.flatMap(Js_dict.get(data, keyName), Js_json.decodeString), (function (prim) {
          return prim.length;
        }));
  if (i !== undefined && i <= max) {
    return {
            TAG: /* Ok */0,
            _0: data
          };
  } else {
    return {
            TAG: /* Error */1,
            _0: error
          };
  }
}

export {
  validate ,
  makeError ,
  makeResolverError ,
  notEmpty ,
  maxLength ,
}
/* No side effect */
