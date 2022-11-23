// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Curry from "rescript/lib/es6/curry.js";
import * as React from "react";
import * as Js_json from "rescript/lib/es6/js_json.js";
import * as Caml_obj from "rescript/lib/es6/caml_obj.js";
import * as Skeleton from "./Skeleton.mjs";
import * as Garter_Fn from "@greenlabs/garter/src/Garter_Fn.mjs";
import * as Belt_Array from "rescript/lib/es6/belt_Array.js";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as ReactEvents from "../utils/ReactEvents.mjs";
import * as ReactHookForm from "../bindings/ReactHookForm/ReactHookForm.mjs";
import * as Cart_Buyer_Form from "./Cart_Buyer_Form.mjs";
import * as ReactHookForm$1 from "react-hook-form";
import * as ReactDialog from "@radix-ui/react-dialog";
import CheckboxCheckedSvg from "../../public/assets/checkbox-checked.svg";
import CheckboxDisableSvg from "../../public/assets/checkbox-disable.svg";
import CheckboxDimUncheckedSvg from "../../public/assets/checkbox-dim-unchecked.svg";

var checkboxCheckedIcon = CheckboxCheckedSvg;

var checkboxUncheckedIcon = CheckboxDimUncheckedSvg;

var checkboxDisableIcon = CheckboxDisableSvg;

function Cart_Buyer_Util$Hidden$Checkbox(Props) {
  var checked = Props.checked;
  var inputName = Props.inputName;
  var match = ReactHookForm$1.useFormContext({
        mode: "all",
        shouldUnregister: true
      }, undefined);
  var setValue = match.setValue;
  var match$1 = match.register(inputName, undefined);
  var name = match$1.name;
  React.useEffect((function () {
          setValue(inputName, checked);
        }), [checked]);
  return React.createElement("input", {
              ref: match$1.ref,
              id: name,
              checked: checked,
              name: name,
              type: "checkbox"
            });
}

var Checkbox = {
  make: Cart_Buyer_Util$Hidden$Checkbox
};

function Cart_Buyer_Util$Hidden$NullableNumberInput(Props) {
  var value = Props.value;
  var inputName = Props.inputName;
  var match = ReactHookForm$1.useFormContext({
        mode: "all",
        shouldUnregister: true
      }, undefined);
  var match$1 = match.register(inputName, {
        valueAsNumber: Belt_Option.isSome(value)
      });
  var name = match$1.name;
  if (Belt_Option.isSome(value)) {
    
  } else {
    match.setValue(inputName, null);
  }
  var tmp = {
    ref: match$1.ref,
    id: name,
    name: name,
    type: "hidden"
  };
  if (value !== undefined) {
    tmp.defaultValue = Caml_option.valFromOption(value);
  }
  if (value !== undefined) {
    tmp.value = Caml_option.valFromOption(value);
  }
  return React.createElement("input", tmp);
}

var NullableNumberInput = {
  make: Cart_Buyer_Util$Hidden$NullableNumberInput
};

function Cart_Buyer_Util$Hidden$NumberInput(Props) {
  var value = Props.value;
  var inputName = Props.inputName;
  var match = ReactHookForm$1.useFormContext({
        mode: "all",
        shouldUnregister: true
      }, undefined);
  var setValue = match.setValue;
  var match$1 = match.register(inputName, {
        valueAsNumber: true
      });
  var name = match$1.name;
  React.useEffect((function () {
          setValue(inputName, value);
        }), [value]);
  return React.createElement("input", {
              ref: match$1.ref,
              defaultValue: value,
              id: name,
              name: name,
              type: "hidden",
              value: value
            });
}

var NumberInput = {
  make: Cart_Buyer_Util$Hidden$NumberInput
};

function Cart_Buyer_Util$Hidden(Props) {
  var value = Props.value;
  var inputName = Props.inputName;
  var match = ReactHookForm$1.useFormContext({
        mode: "all",
        shouldUnregister: true
      }, undefined);
  var setValue = match.setValue;
  var match$1 = match.register(inputName, undefined);
  var name = match$1.name;
  React.useEffect((function () {
          setValue(inputName, Belt_Option.getWithDefault(value, ""));
        }), [value]);
  var tmp = {
    ref: match$1.ref,
    id: name,
    name: name,
    type: "hidden"
  };
  if (value !== undefined) {
    tmp.defaultValue = Caml_option.valFromOption(value);
  }
  return React.createElement("input", tmp);
}

var Hidden = {
  Checkbox: Checkbox,
  NullableNumberInput: NullableNumberInput,
  NumberInput: NumberInput,
  make: Cart_Buyer_Util$Hidden
};

function Cart_Buyer_Util$Checkbox(Props) {
  var name = Props.name;
  var watchNamesOpt = Props.watchNames;
  var targetNamesOpt = Props.targetNames;
  var status = Props.status;
  var watchNames = watchNamesOpt !== undefined ? watchNamesOpt : [];
  var targetNames = targetNamesOpt !== undefined ? targetNamesOpt : [];
  var match = ReactHookForm$1.useFormContext({
        mode: "onChange"
      }, undefined);
  var setValue = match.setValue;
  var watchValues = ReactHookForm$1.useWatch({
        name: watchNames
      });
  var handleCheckBox = function (changeFn, v) {
    return function (param) {
      return ReactEvents.interceptingHandler((function (param) {
                    Belt_Option.forEach(Js_json.decodeBoolean(v), (function (v$p) {
                            Curry._1(changeFn, Curry._1(ReactHookForm.Controller.OnChangeArg.value, !v$p));
                            Belt_Array.forEach(targetNames, (function (targetName) {
                                    setValue(targetName, !v$p);
                                  }));
                          }));
                  }), param);
    };
  };
  React.useEffect((function () {
          Belt_Option.forEach(Belt_Option.map(watchValues, (function (watchValues$p) {
                      if (watchValues$p.length === watchNames.length) {
                        return Belt_Array.reduce(Belt_Array.keepMap(watchValues$p, Garter_Fn.identity), true, (function (acc, cur) {
                                      if (acc) {
                                        return cur;
                                      } else {
                                        return false;
                                      }
                                    }));
                      } else {
                        return true;
                      }
                    })), (function (b) {
                  setValue(name, b);
                }));
        }), [watchValues]);
  return React.createElement(ReactHookForm$1.Controller, {
              name: name,
              control: match.control,
              render: (function (param) {
                  var match = param.field;
                  var value = match.value;
                  var match$1 = Cart_Buyer_Form.soldable(status);
                  if (match$1 && targetNames.length !== 0) {
                    return React.createElement("button", {
                                className: "self-start w-6 h-6 min-w-max",
                                onClick: handleCheckBox(match.onChange, value)
                              }, React.createElement("img", {
                                    className: "w-6 h-6 min-w-max",
                                    alt: "check-icon",
                                    src: Belt_Option.getWithDefault(Js_json.decodeBoolean(value), false) ? checkboxCheckedIcon : checkboxUncheckedIcon
                                  }));
                  }
                  return React.createElement("img", {
                              className: "w-6 h-6 min-w-max self-start",
                              alt: "check-diable-icon",
                              src: checkboxDisableIcon
                            });
                }),
              defaultValue: true
            });
}

var Checkbox$1 = {
  make: Cart_Buyer_Util$Checkbox
};

function Cart_Buyer_Util$SubmitDialog(Props) {
  var _open = Props.open;
  var setOpen = Props.setOpen;
  return React.createElement(ReactDialog.Root, {
              children: React.createElement(ReactDialog.Portal, {
                    children: null
                  }, React.createElement(ReactDialog.Overlay, {
                        className: "dialog-overlay"
                      }), React.createElement(ReactDialog.Content, {
                        children: null,
                        className: "dialog-content p-7 bg-white rounded-xl w-[480px] flex flex-col gap-7 items-center justify-center",
                        onOpenAutoFocus: (function (prim) {
                            prim.preventDefault();
                          })
                      }, React.createElement("span", {
                            className: "whitespace-pre text-center text-text-L1 pt-3"
                          }, "주문하실 상품을\n선택해주세요"), React.createElement("div", {
                            className: "flex w-full justify-center items-center gap-2"
                          }, React.createElement("button", {
                                className: "w-1/2 rounded-xl h-13 bg-enabled-L5",
                                onClick: (function (param) {
                                    return ReactEvents.interceptingHandler((function (param) {
                                                  setOpen(function (param) {
                                                        return false;
                                                      });
                                                }), param);
                                  })
                              }, "확인")))),
              open: _open
            });
}

var SubmitDialog = {
  make: Cart_Buyer_Util$SubmitDialog
};

function Cart_Buyer_Util$HiddenInputs(Props) {
  var data = Props.data;
  var prefix = Props.prefix;
  var parnetFormName = Cart_Buyer_Form.names(prefix);
  return Belt_Array.mapWithIndex(data, (function (cartIndex, cartItem) {
                var formNames = Cart_Buyer_Form.names("" + parnetFormName.cartItems + "." + String(cartIndex) + "");
                return React.createElement("div", {
                            key: formNames.name,
                            className: "hidden"
                          }, React.createElement(Cart_Buyer_Util$Hidden$NumberInput, {
                                value: String(cartItem.productId),
                                inputName: formNames.productId
                              }), React.createElement(Cart_Buyer_Util$Hidden, {
                                value: cartItem.productName,
                                inputName: formNames.productName
                              }), React.createElement(Cart_Buyer_Util$Hidden$NumberInput, {
                                value: String(3),
                                inputName: formNames.checkedNumber
                              }), React.createElement(Cart_Buyer_Util$Hidden, {
                                value: Js_json.decodeString(Cart_Buyer_Form.productStatus_encode(cartItem.productStatus)),
                                inputName: formNames.productStatus
                              }), React.createElement(Cart_Buyer_Util$Hidden, {
                                value: cartItem.imageUrl,
                                inputName: formNames.imageUrl
                              }), React.createElement(Cart_Buyer_Util$Hidden, {
                                value: cartItem.updatedAt,
                                inputName: formNames.updatedAt
                              }), Belt_Array.mapWithIndex(cartItem.productOptions, (function (optionIndex, productOption) {
                                  var formNames2 = Cart_Buyer_Form.names("" + formNames.productOptions + "." + String(optionIndex) + "");
                                  return React.createElement("div", {
                                              key: formNames2.name
                                            }, React.createElement(Cart_Buyer_Util$Hidden$NumberInput, {
                                                  value: String(productOption.cartId),
                                                  inputName: formNames2.cartId
                                                }), React.createElement(Cart_Buyer_Util$Hidden$NumberInput, {
                                                  value: String(productOption.productOptionId),
                                                  inputName: formNames2.productOptionId
                                                }), React.createElement(Cart_Buyer_Util$Hidden, {
                                                  value: Js_json.decodeString(Cart_Buyer_Form.productStatus_encode(productOption.optionStatus)),
                                                  inputName: formNames2.optionStatus
                                                }), React.createElement(Cart_Buyer_Util$Hidden$NumberInput, {
                                                  value: String(productOption.price),
                                                  inputName: formNames2.price
                                                }), React.createElement(Cart_Buyer_Util$Hidden$NumberInput, {
                                                  value: String(productOption.quantity),
                                                  inputName: formNames2.quantity
                                                }), React.createElement(Cart_Buyer_Util$Hidden, {
                                                  value: productOption.updatedAt,
                                                  inputName: formNames2.updatedAt
                                                }), React.createElement(Cart_Buyer_Util$Hidden, {
                                                  value: productOption.productOptionName,
                                                  inputName: formNames2.productOptionName
                                                }), React.createElement(Cart_Buyer_Util$Hidden$Checkbox, {
                                                  checked: productOption.adhocStockIsLimited,
                                                  inputName: formNames2.adhocStockIsLimited
                                                }), React.createElement(Cart_Buyer_Util$Hidden$Checkbox, {
                                                  checked: productOption.adhocStockIsNumRemainingVisible,
                                                  inputName: formNames2.adhocStockIsNumRemainingVisible
                                                }), React.createElement(Cart_Buyer_Util$Hidden$NullableNumberInput, {
                                                  value: Belt_Option.map(productOption.adhocStockNumRemaining, (function (x) {
                                                          return String(x);
                                                        })),
                                                  inputName: formNames2.adhocStockNumRemaining
                                                }));
                                })));
              }));
}

var HiddenInputs = {
  make: Cart_Buyer_Util$HiddenInputs
};

function Cart_Buyer_Util$RadioButton$PlaceHolder(Props) {
  return React.createElement(Skeleton.Box.make, {
              className: "w-32 xl:w-52 min-h-[2.75rem] rounded-xl"
            });
}

var PlaceHolder = {
  make: Cart_Buyer_Util$RadioButton$PlaceHolder
};

function Cart_Buyer_Util$RadioButton$PC(Props) {
  var watchValue = Props.watchValue;
  var name = Props.name;
  var value = Props.value;
  var checked = Belt_Option.mapWithDefault(watchValue, false, (function (watch) {
          return Caml_obj.equal(watch, value);
        }));
  return React.createElement("div", {
              className: checked ? "w-full pt-7 pb-4 border border-x-0 border-t-0 text-lg text-center text-text-L1 font-bold border-border-active cursor-pointer " : "w-full pt-7 pb-4 border border-x-0 border-t-0 text-lg text-center text-text-L2 font-bold border-border-default-L2 cursor-pointer"
            }, name);
}

var PC = {
  make: Cart_Buyer_Util$RadioButton$PC
};

function Cart_Buyer_Util$RadioButton$MO(Props) {
  var watchValue = Props.watchValue;
  var name = Props.name;
  var value = Props.value;
  var checked = Belt_Option.mapWithDefault(watchValue, false, (function (watch) {
          return Caml_obj.equal(watch, value);
        }));
  return React.createElement("div", {
              className: checked ? "w-full pt-4 pb-4 border border-x-0 border-t-0 text-base text-center text-text-L1 font-bold border-border-active cursor-pointer " : "w-full pt-4 pb-4 border border-x-0 border-t-0 text-base text-center text-text-L2 font-bold border-border-default-L2 cursor-pointer"
            }, name);
}

var MO = {
  make: Cart_Buyer_Util$RadioButton$MO
};

var RadioButton = {
  PlaceHolder: PlaceHolder,
  PC: PC,
  MO: MO
};

var Form;

export {
  Form ,
  checkboxCheckedIcon ,
  checkboxUncheckedIcon ,
  checkboxDisableIcon ,
  Hidden ,
  Checkbox$1 as Checkbox,
  SubmitDialog ,
  HiddenInputs ,
  RadioButton ,
}
/* checkboxCheckedIcon Not a pure module */
