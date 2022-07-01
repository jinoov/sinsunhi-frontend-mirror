// Generated by ReScript, PLEASE EDIT WITH CARE

import * as React from "react";
import * as ReactUtil from "../../utils/ReactUtil.mjs";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as ReactHookForm from "react-hook-form";

var $$Error = {};

var Control = {};

function sync(syncHandler) {
  return syncHandler;
}

function async(asyncHandler) {
  return asyncHandler;
}

var Validation = {
  sync: sync,
  async: async
};

function make(prim0, prim1, prim2, prim3, prim4, prim5, prim6, prim7, prim8, prim9) {
  var tmp = {};
  if (prim0 !== undefined) {
    tmp.required = Caml_option.valFromOption(prim0);
  }
  if (prim1 !== undefined) {
    tmp.maxLength = Caml_option.valFromOption(prim1);
  }
  if (prim2 !== undefined) {
    tmp.minLength = Caml_option.valFromOption(prim2);
  }
  if (prim3 !== undefined) {
    tmp.max = Caml_option.valFromOption(prim3);
  }
  if (prim4 !== undefined) {
    tmp.min = Caml_option.valFromOption(prim4);
  }
  if (prim5 !== undefined) {
    tmp.pattern = Caml_option.valFromOption(prim5);
  }
  if (prim6 !== undefined) {
    tmp.validate = Caml_option.valFromOption(prim6);
  }
  if (prim7 !== undefined) {
    tmp.valueAsNumber = Caml_option.valFromOption(prim7);
  }
  if (prim8 !== undefined) {
    tmp.shouldUnregister = Caml_option.valFromOption(prim8);
  }
  return tmp;
}

var Rules = {
  make: make
};

var ErrorMessage = {};

function $$event(eventHandler) {
  return eventHandler;
}

function value(valueHandler) {
  return valueHandler;
}

function classify(unknown) {
  if (typeof unknown === "object" && !(unknown == null) && unknown._reactName === "onChange") {
    return {
            TAG: /* Event */0,
            _0: unknown
          };
  } else {
    return {
            TAG: /* Value */1,
            _0: unknown
          };
  }
}

var OnChangeArg = {
  $$event: $$event,
  value: value,
  classify: classify
};

var Controller = {
  OnChangeArg: OnChangeArg
};

var Register = {};

var Register$1 = {};

var Form = {};

var Controller$1 = {};

var WatchValues = {};

var FormState = {};

var Context = {};

var FieldArray = {};

var Hooks = {
  Register: Register$1,
  Form: Form,
  Controller: Controller$1,
  WatchValues: WatchValues,
  FormState: FormState,
  Context: Context,
  FieldArray: FieldArray
};

var P = {};

function ReactHookForm$Provider(Props) {
  var children = Props.children;
  var methods = Props.methods;
  return React.createElement(ReactUtil.SpreadProps.make, {
              children: React.createElement(ReactHookForm.FormProvider, {
                    children: children
                  }),
              props: methods
            });
}

var Provider = {
  P: P,
  make: ReactHookForm$Provider
};

export {
  $$Error ,
  Control ,
  Validation ,
  Rules ,
  ErrorMessage ,
  Controller ,
  Register ,
  Hooks ,
  Provider ,
  
}
/* react Not a pure module */
