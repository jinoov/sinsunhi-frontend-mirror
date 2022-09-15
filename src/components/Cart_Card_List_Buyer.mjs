// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Cx from "rescript-classnames/src/Cx.mjs";
import * as React from "react";
import * as Locale from "../utils/Locale.mjs";
import * as Skeleton from "./Skeleton.mjs";
import * as Garter_Fn from "@greenlabs/garter/src/Garter_Fn.mjs";
import Link from "next/link";
import * as Belt_Array from "rescript/lib/es6/belt_Array.js";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as Garter_Math from "@greenlabs/garter/src/Garter_Math.mjs";
import * as Cart_Buyer_Form from "./Cart_Buyer_Form.mjs";
import * as Cart_Buyer_Util from "./Cart_Buyer_Util.mjs";
import * as Cart_Card_Buyer from "./Cart_Card_Buyer.mjs";
import * as ReactHookForm from "react-hook-form";
import * as Cart_Delete_Button from "./Cart_Delete_Button.mjs";
import * as Create_Temp_Order_Button_Buyer from "./Create_Temp_Order_Button_Buyer.mjs";

function Cart_Card_List_Buyer$ProductNameAndDelete(Props) {
  var cartItem = Props.cartItem;
  var refetchCart = Props.refetchCart;
  return React.createElement("div", {
              className: "flex w-full justify-between items-baseline"
            }, React.createElement(Link, {
                  href: "/products/" + String(cartItem.productId) + "",
                  children: React.createElement("a", {
                        className: "text-text-L1 font-bold self-start underline-offset-4 hover:underline"
                      }, Belt_Option.getWithDefault(cartItem.productName, ""))
                }), React.createElement(Cart_Delete_Button.make, {
                  productOptions: cartItem.productOptions,
                  refetchCart: refetchCart,
                  width: "1.5rem",
                  height: "1.5rem",
                  fill: "#000000"
                }));
}

var ProductNameAndDelete = {
  make: Cart_Card_List_Buyer$ProductNameAndDelete
};

function Cart_Card_List_Buyer$List(Props) {
  var productOptions = Props.productOptions;
  var formNames = Props.formNames;
  var refetchCart = Props.refetchCart;
  var productStatus = Props.productStatus;
  return React.createElement("div", {
              className: "mt-5 flex flex-col gap-2"
            }, Belt_Array.mapWithIndex(productOptions, (function (cardIndex, productOption) {
                    return React.createElement(Cart_Card_Buyer.make, {
                                productOption: productOption,
                                refetchCart: refetchCart,
                                prefix: "" + formNames.productOptions + "." + String(cardIndex) + "",
                                productStatus: productStatus,
                                key: "" + formNames.productOptions + "." + String(cardIndex) + ""
                              });
                  })));
}

var List = {
  make: Cart_Card_List_Buyer$List
};

function Cart_Card_List_Buyer$BuyNow(Props) {
  var totalPrice = Props.totalPrice;
  var cartIds = Props.cartIds;
  var cartItems = Props.cartItems;
  return React.createElement("div", {
              className: "flex justify-between items-center mt-4"
            }, React.createElement(Create_Temp_Order_Button_Buyer.make, {
                  cartItems: cartItems,
                  cartIds: cartIds
                }), React.createElement("div", {
                  className: "flex flex-col items-end text-lg"
                }, React.createElement("span", {
                      className: "text-[13px] text-gray-600 min-w-max"
                    }, "배송타입에 따라 배송비 상이"), React.createElement("span", {
                      className: "text-text-L1 font-bold min-w-max"
                    }, "" + Locale.Int.show(undefined, totalPrice) + "원")));
}

var BuyNow = {
  make: Cart_Card_List_Buyer$BuyNow
};

function Cart_Card_List_Buyer$PC$PlaceHolder(Props) {
  return React.createElement("div", {
              className: "flex gap-4 w-full"
            }, React.createElement(Skeleton.Box.make, {
                  className: "min-w-[1.5rem]"
                }), React.createElement(Skeleton.Box.make, {
                  className: "min-w-[5rem] min-h-[5rem] rounded-[10px]"
                }), React.createElement("div", {
                  className: "w-full flex flex-col pb-4"
                }, React.createElement("div", {
                      className: "flex w-full justify-between items-baseline"
                    }, React.createElement(Skeleton.Box.make, {
                          className: "w-32"
                        }), React.createElement(Skeleton.Box.make, {
                          className: "w-6 h-6"
                        })), React.createElement(Skeleton.Box.make, {
                      className: "mt-5 flex flex-col gap-2 min-h-[6rem]"
                    }), React.createElement("div", {
                      className: "flex justify-between items-center mt-4"
                    }, React.createElement(Skeleton.Box.make, {
                          className: "w-20 h-10"
                        }), React.createElement(Skeleton.Box.make, {
                          className: "w-64"
                        }))));
}

var PlaceHolder = {
  make: Cart_Card_List_Buyer$PC$PlaceHolder
};

function Cart_Card_List_Buyer$PC(Props) {
  var formNames = Props.formNames;
  var cartItem = Props.cartItem;
  var targetNames = Props.targetNames;
  var totalPrice = Props.totalPrice;
  var isLast = Props.isLast;
  var refetchCart = Props.refetchCart;
  var checkedCartIds = Props.checkedCartIds;
  var productStatus = cartItem.productStatus;
  return React.createElement("div", {
              className: "flex gap-4 w-full"
            }, React.createElement(Cart_Buyer_Util.Checkbox.make, {
                  name: formNames.checked,
                  watchNames: targetNames,
                  targetNames: targetNames,
                  status: productStatus
                }), React.createElement(Link, {
                  href: "/products/" + String(cartItem.productId) + "",
                  children: React.createElement("a", undefined, React.createElement("img", {
                            className: "min-w-[80px] min-h-[80px] w-20 h-20 rounded-[10px]",
                            alt: "" + Belt_Option.getWithDefault(cartItem.productName, "") + "-image",
                            src: Belt_Option.getWithDefault(cartItem.imageUrl, "")
                          }))
                }), React.createElement("div", {
                  className: Cx.cx([
                        "w-full flex flex-col pb-4",
                        isLast ? "" : "border border-x-0 border-t-0 border-div-border-L2"
                      ])
                }, React.createElement(Cart_Card_List_Buyer$ProductNameAndDelete, {
                      cartItem: cartItem,
                      refetchCart: refetchCart
                    }), React.createElement(Cart_Card_List_Buyer$List, {
                      productOptions: cartItem.productOptions,
                      formNames: formNames,
                      refetchCart: refetchCart,
                      productStatus: productStatus
                    }), React.createElement(Cart_Card_List_Buyer$BuyNow, {
                      totalPrice: totalPrice,
                      cartIds: checkedCartIds,
                      cartItems: [cartItem]
                    })));
}

var PC = {
  PlaceHolder: PlaceHolder,
  make: Cart_Card_List_Buyer$PC
};

function Cart_Card_List_Buyer$MO$PlaceHolder(Props) {
  return React.createElement("div", {
              className: "flex flex-col w-full mt-4"
            }, React.createElement("div", {
                  className: "flex w-full gap-2"
                }, React.createElement("div", {
                      className: "flex gap-2 min-w-max"
                    }, React.createElement(Skeleton.Box.make, {
                          className: "min-w-[1.5rem]"
                        }), React.createElement(Skeleton.Box.make, {
                          className: "w-20 h-20 rounded-[10px]"
                        })), React.createElement("div", {
                      className: "flex justify-between w-full"
                    }, React.createElement(Skeleton.Box.make, {
                          className: "w-32"
                        }), React.createElement(Skeleton.Box.make, {
                          className: "w-6 h-6"
                        }))), React.createElement("div", {
                  className: "w-full"
                }, React.createElement(Skeleton.Box.make, {
                      className: "mt-5 flex flex-col gap-2 min-h-[6rem]"
                    }), React.createElement("div", {
                      className: "flex justify-between items-center mt-4"
                    }, React.createElement(Skeleton.Box.make, {
                          className: "w-20 h-10"
                        }), React.createElement(Skeleton.Box.make, {
                          className: "w-64"
                        }))));
}

var PlaceHolder$1 = {
  make: Cart_Card_List_Buyer$MO$PlaceHolder
};

function Cart_Card_List_Buyer$MO(Props) {
  var formNames = Props.formNames;
  var cartItem = Props.cartItem;
  var targetNames = Props.targetNames;
  var totalPrice = Props.totalPrice;
  var refetchCart = Props.refetchCart;
  var checkedCartIds = Props.checkedCartIds;
  var productStatus = cartItem.productStatus;
  return React.createElement("div", {
              className: "flex flex-col w-full mt-4"
            }, React.createElement("div", {
                  className: "flex w-full gap-2"
                }, React.createElement("div", {
                      className: "flex gap-2 min-w-max"
                    }, React.createElement(Cart_Buyer_Util.Checkbox.make, {
                          name: formNames.checked,
                          watchNames: targetNames,
                          targetNames: targetNames,
                          status: productStatus
                        }), React.createElement(Link, {
                          href: "/products/" + String(cartItem.productId) + "",
                          children: React.createElement("a", undefined, React.createElement("img", {
                                    className: "w-20 h-20 rounded-[10px]",
                                    alt: "" + Belt_Option.getWithDefault(cartItem.productName, "") + "-image",
                                    src: Belt_Option.getWithDefault(cartItem.imageUrl, "")
                                  }))
                        })), React.createElement(Cart_Card_List_Buyer$ProductNameAndDelete, {
                      cartItem: cartItem,
                      refetchCart: refetchCart
                    })), React.createElement("div", {
                  className: "w-full"
                }, React.createElement(Cart_Card_List_Buyer$List, {
                      productOptions: cartItem.productOptions,
                      formNames: formNames,
                      refetchCart: refetchCart,
                      productStatus: productStatus
                    }), React.createElement(Cart_Card_List_Buyer$BuyNow, {
                      totalPrice: totalPrice,
                      cartIds: checkedCartIds,
                      cartItems: [cartItem]
                    })));
}

var MO = {
  PlaceHolder: PlaceHolder$1,
  make: Cart_Card_List_Buyer$MO
};

function Cart_Card_List_Buyer$PlaceHolder(Props) {
  var deviceType = Props.deviceType;
  var tmp;
  switch (deviceType) {
    case /* Unknown */0 :
        tmp = null;
        break;
    case /* PC */1 :
        tmp = React.createElement(Cart_Card_List_Buyer$PC$PlaceHolder, {});
        break;
    case /* Mobile */2 :
        tmp = React.createElement(Cart_Card_List_Buyer$MO$PlaceHolder, {});
        break;
    
  }
  return React.createElement("div", {
              className: "flex bg-white w-full p-4 xl:p-0"
            }, tmp);
}

var PlaceHolder$2 = {
  make: Cart_Card_List_Buyer$PlaceHolder
};

function Cart_Card_List_Buyer(Props) {
  var cartItem = Props.cartItem;
  var refetchCart = Props.refetchCart;
  var prefix = Props.prefix;
  var isLast = Props.isLast;
  var deviceType = Props.deviceType;
  var match = ReactHookForm.useFormContext({
        mode: "onChange",
        shouldUnregister: true
      }, undefined);
  var productOptions = cartItem.productOptions;
  var setValue = match.setValue;
  var formNames = Cart_Buyer_Form.names(prefix);
  var watchOptions = ReactHookForm.useWatch({
        name: formNames.productOptions
      });
  var parsed = Belt_Option.map(Belt_Option.map(watchOptions, (function (a) {
              return Belt_Array.keepMap(a, (function (o) {
                            return Belt_Option.flatMap((o == null) ? undefined : Caml_option.some(o), (function (a) {
                                          var decode = Cart_Buyer_Form.productOption_decode(a);
                                          if (decode.TAG === /* Ok */0) {
                                            return decode._0;
                                          }
                                          
                                        }));
                          }));
            })), (function (options) {
          return Belt_Array.keep(options, (function (option) {
                        return Cart_Buyer_Form.soldable(option.optionStatus);
                      }));
        }));
  var targetNames = Belt_Array.keepMap(Belt_Array.mapWithIndex(productOptions, (function (i, option) {
              if (Cart_Buyer_Form.soldable(option.optionStatus)) {
                return Cart_Buyer_Form.names("" + formNames.productOptions + "." + String(i) + "").checked;
              }
              
            })), Garter_Fn.identity);
  var soldable = Belt_Array.keep(productOptions, (function (option) {
          if (option.checked) {
            return Cart_Buyer_Form.soldable(option.optionStatus);
          } else {
            return false;
          }
        }));
  var defaultTotalPrice = Garter_Math.sum_int(Belt_Array.map(soldable, (function (option) {
              return Math.imul(option.quantity, option.price);
            })));
  var defaultChecked = soldable.length;
  var defaultCheckedCartIds = Belt_Array.map(soldable, (function (option) {
          return option.cartId;
        }));
  var match$1 = Belt_Option.mapWithDefault(parsed, [
        defaultTotalPrice,
        defaultChecked,
        true,
        defaultCheckedCartIds
      ], (function (options) {
          var filtered = Belt_Array.keep(options, (function (option) {
                  return option.checked;
                }));
          return [
                  Garter_Math.sum_int(Belt_Array.map(filtered, (function (o) {
                              return Math.imul(o.price, o.quantity);
                            }))),
                  filtered.length,
                  defaultChecked === filtered.length,
                  Belt_Array.map(filtered, (function (o) {
                          return o.cartId;
                        }))
                ];
        }));
  var checkedCartIds = match$1[3];
  var checkedAll = match$1[2];
  var totalNumber = match$1[1];
  var totalPrice = match$1[0];
  React.useEffect((function () {
          setValue(formNames.checkedNumber, totalNumber);
          setValue(formNames.checked, checkedAll);
        }), [
        totalPrice,
        totalNumber,
        checkedAll
      ]);
  var tmp;
  switch (deviceType) {
    case /* Unknown */0 :
        tmp = null;
        break;
    case /* PC */1 :
        tmp = React.createElement(Cart_Card_List_Buyer$PC, {
              formNames: formNames,
              cartItem: cartItem,
              targetNames: targetNames,
              totalPrice: totalPrice,
              isLast: isLast,
              refetchCart: refetchCart,
              checkedCartIds: checkedCartIds
            });
        break;
    case /* Mobile */2 :
        tmp = React.createElement(Cart_Card_List_Buyer$MO, {
              formNames: formNames,
              cartItem: cartItem,
              targetNames: targetNames,
              totalPrice: totalPrice,
              refetchCart: refetchCart,
              checkedCartIds: checkedCartIds
            });
        break;
    
  }
  return React.createElement("div", {
              className: "flex bg-white p-4 xl:p-0"
            }, tmp);
}

var Form;

var Card;

var Util;

var Hidden;

var make = Cart_Card_List_Buyer;

export {
  Form ,
  Card ,
  Util ,
  Hidden ,
  ProductNameAndDelete ,
  List ,
  BuyNow ,
  PC ,
  MO ,
  PlaceHolder$2 as PlaceHolder,
  make ,
}
/* react Not a pure module */