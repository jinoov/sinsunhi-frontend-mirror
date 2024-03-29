// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Curry from "rescript/lib/es6/curry.js";
import * as React from "react";
import * as DataGtm from "../../../../utils/DataGtm.mjs";
import * as Belt_Array from "rescript/lib/es6/belt_Array.js";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as CustomHooks from "../../../../utils/CustomHooks.mjs";
import * as ReactRelay from "react-relay";
import * as Belt_MapString from "rescript/lib/es6/belt_MapString.js";
import * as Product_Parser from "../../../../utils/Product_Parser.mjs";
import * as PDP_Like_Button from "../common/PDP_Like_Button.mjs";
import * as Js_null_undefined from "rescript/lib/es6/js_null_undefined.js";
import * as PDP_CsChat_Button from "../common/PDP_CsChat_Button.mjs";
import * as RescriptRelay_Internal from "rescript-relay/src/RescriptRelay_Internal.mjs";
import * as PDP_CTA_Container_Buyer from "../common/PDP_CTA_Container_Buyer.mjs";
import * as PDP_Normal_RfqBtn_Buyer from "./PDP_Normal_RfqBtn_Buyer.mjs";
import * as PDPNormalSubmitBuyerFragment_graphql from "../../../../__generated__/PDPNormalSubmitBuyerFragment_graphql.mjs";
import * as PDPNormalSubmitBuyer_fragment_graphql from "../../../../__generated__/PDPNormalSubmitBuyer_fragment_graphql.mjs";

function use(fRef) {
  var data = ReactRelay.useFragment(PDPNormalSubmitBuyerFragment_graphql.node, fRef);
  return RescriptRelay_Internal.internal_useConvertedValue(PDPNormalSubmitBuyerFragment_graphql.Internal.convertFragment, data);
}

function useOpt(opt_fRef) {
  var fr = opt_fRef !== undefined ? Caml_option.some(Caml_option.valFromOption(opt_fRef)) : undefined;
  var nullableFragmentData = ReactRelay.useFragment(PDPNormalSubmitBuyerFragment_graphql.node, fr !== undefined ? Js_null_undefined.fromOption(Caml_option.some(Caml_option.valFromOption(fr))) : null);
  var data = (nullableFragmentData == null) ? undefined : Caml_option.some(nullableFragmentData);
  return RescriptRelay_Internal.internal_useConvertedValue((function (rawFragment) {
                if (rawFragment !== undefined) {
                  return PDPNormalSubmitBuyerFragment_graphql.Internal.convertFragment(rawFragment);
                }
                
              }), data);
}

var Fragment_productStatus_decode = PDPNormalSubmitBuyerFragment_graphql.Utils.productStatus_decode;

var Fragment_productStatus_fromString = PDPNormalSubmitBuyerFragment_graphql.Utils.productStatus_fromString;

var Fragment = {
  productStatus_decode: Fragment_productStatus_decode,
  productStatus_fromString: Fragment_productStatus_fromString,
  Types: undefined,
  Operation: undefined,
  use: use,
  useOpt: useOpt
};

function use$1(fRef) {
  var data = ReactRelay.useFragment(PDPNormalSubmitBuyer_fragment_graphql.node, fRef);
  return RescriptRelay_Internal.internal_useConvertedValue(PDPNormalSubmitBuyer_fragment_graphql.Internal.convertFragment, data);
}

function useOpt$1(opt_fRef) {
  var fr = opt_fRef !== undefined ? Caml_option.some(Caml_option.valFromOption(opt_fRef)) : undefined;
  var nullableFragmentData = ReactRelay.useFragment(PDPNormalSubmitBuyer_fragment_graphql.node, fr !== undefined ? Js_null_undefined.fromOption(Caml_option.some(Caml_option.valFromOption(fr))) : null);
  var data = (nullableFragmentData == null) ? undefined : Caml_option.some(nullableFragmentData);
  return RescriptRelay_Internal.internal_useConvertedValue((function (rawFragment) {
                if (rawFragment !== undefined) {
                  return PDPNormalSubmitBuyer_fragment_graphql.Internal.convertFragment(rawFragment);
                }
                
              }), data);
}

var ButtonFragment = {
  Types: undefined,
  Operation: undefined,
  use: use$1,
  useOpt: useOpt$1
};

function make(product, selectedOptions) {
  var productOptions = product.productOptions;
  var productId = product.productId;
  var displayName = product.displayName;
  var categoryNames = Belt_Array.map(product.category.fullyQualifiedName, (function (param) {
          return param.name;
        }));
  var producerCode = Belt_Option.map(product.producer, (function (param) {
          return param.producerCode;
        }));
  var options = Belt_Array.keepMap(Belt_MapString.toArray(selectedOptions), (function (param) {
          var quantity = param[1];
          var optionId = param[0];
          return Belt_Option.flatMap(productOptions, (function (param) {
                        var match = Belt_Array.getBy(param.edges, (function (param) {
                                return param.node.id === optionId;
                              }));
                        if (match === undefined) {
                          return ;
                        }
                        var match$1 = match.node;
                        return {
                                stockSku: match$1.stockSku,
                                price: match$1.price,
                                quantity: quantity
                              };
                      }));
        }));
  var filterEmptyArr = function (arr) {
    if (arr.length !== 0) {
      return arr;
    }
    
  };
  var makeItems = function (nonEmptyOptions) {
    return Belt_Array.map(nonEmptyOptions, (function (param) {
                  return {
                          currency: "KRW",
                          item_id: String(productId),
                          item_name: displayName,
                          item_brand: Js_null_undefined.fromOption(producerCode),
                          item_variant: param.stockSku,
                          price: Js_null_undefined.fromOption(param.price),
                          quantity: param.quantity,
                          item_category: Js_null_undefined.fromOption(Belt_Array.get(categoryNames, 0)),
                          item_category2: Js_null_undefined.fromOption(Belt_Array.get(categoryNames, 1)),
                          item_category3: Js_null_undefined.fromOption(Belt_Array.get(categoryNames, 2)),
                          item_category4: Js_null_undefined.fromOption(Belt_Array.get(categoryNames, 3)),
                          item_category5: Js_null_undefined.fromOption(Belt_Array.get(categoryNames, 4))
                        };
                }));
  };
  return Belt_Option.map(filterEmptyArr(options), (function (nonEmptyOptions) {
                return {
                        event: "click_purchase",
                        ecommerce: {
                          items: makeItems(nonEmptyOptions)
                        }
                      };
              }));
}

var ClickPurchaseGtm = {
  make: make
};

function PDP_Normal_Submit_Buyer$PC$ActionBtn(Props) {
  var query = Props.query;
  var className = Props.className;
  var selectedOptions = Props.selectedOptions;
  var setShowModal = Props.setShowModal;
  var children = Props.children;
  var product = use$1(query);
  var onClick = function (param) {
    Belt_Option.map(make(product, selectedOptions), (function (event$p) {
            DataGtm.push({
                  ecommerce: null
                });
            DataGtm.push(DataGtm.mergeUserIdUnsafe(event$p));
          }));
    setShowModal(function (param) {
          return /* Show */{
                  _0: /* Confirm */1
                };
        });
  };
  return React.createElement("button", {
              className: className,
              onClick: onClick
            }, children);
}

var ActionBtn = {
  make: PDP_Normal_Submit_Buyer$PC$ActionBtn
};

function PDP_Normal_Submit_Buyer$PC$OrderBtn(Props) {
  var status = Props.status;
  var selectedOptions = Props.selectedOptions;
  var setShowModal = Props.setShowModal;
  var query = Props.query;
  var user = Curry._1(CustomHooks.User.Buyer.use2, undefined);
  var btnStyle = "w-full h-16 rounded-xl flex items-center justify-center bg-primary hover:bg-primary-variant text-lg font-bold text-white";
  var disabledStyle = "w-full h-16 rounded-xl flex items-center justify-center bg-gray-300 text-white font-bold text-xl";
  var orderStatus;
  if (status === "SOLDOUT") {
    orderStatus = /* Soldout */1;
  } else if (typeof user === "number") {
    orderStatus = user !== 0 ? /* Unauthorized */2 : /* Loading */0;
  } else {
    var match = Belt_MapString.toArray(selectedOptions);
    orderStatus = match.length !== 0 ? /* Available */({
          _0: selectedOptions
        }) : /* NoOption */3;
  }
  if (typeof orderStatus !== "number") {
    return React.createElement(PDP_Normal_Submit_Buyer$PC$ActionBtn, {
                query: query,
                className: btnStyle,
                selectedOptions: orderStatus._0,
                setShowModal: setShowModal,
                children: "구매하기"
              });
  }
  switch (orderStatus) {
    case /* Loading */0 :
        return React.createElement("button", {
                    className: disabledStyle,
                    disabled: true
                  }, "");
    case /* Soldout */1 :
        return React.createElement("button", {
                    className: disabledStyle,
                    disabled: true
                  }, "품절");
    case /* Unauthorized */2 :
        return React.createElement("button", {
                    className: btnStyle,
                    onClick: (function (param) {
                        setShowModal(function (param) {
                              return /* Show */{
                                      _0: /* Unauthorized */{
                                        _0: "로그인 후에\n구매하실 수 있습니다."
                                      }
                                    };
                            });
                      })
                  }, "구매하기");
    case /* NoOption */3 :
        return React.createElement("button", {
                    className: btnStyle,
                    onClick: (function (param) {
                        setShowModal(function (param) {
                              return /* Show */{
                                      _0: /* NoOption */0
                                    };
                            });
                      })
                  }, "구매하기");
    
  }
}

var OrderBtn = {
  make: PDP_Normal_Submit_Buyer$PC$OrderBtn
};

function PDP_Normal_Submit_Buyer$PC(Props) {
  var query = Props.query;
  var selectedOptions = Props.selectedOptions;
  var setShowModal = Props.setShowModal;
  var match = use(query);
  var fragmentRefs = match.fragmentRefs;
  var match$1 = Product_Parser.Type.decode(match.__typename);
  return React.createElement("section", {
              className: "w-full"
            }, React.createElement("div", {
                  className: "flex items-center box-border"
                }, React.createElement("span", {
                      className: "w-16 mr-2"
                    }, React.createElement(PDP_Like_Button.make, {
                          query: fragmentRefs
                        })), React.createElement("span", {
                      className: "w-16 mr-2"
                    }, React.createElement(PDP_CsChat_Button.make, {})), React.createElement(PDP_Normal_Submit_Buyer$PC$OrderBtn, {
                      status: match.status,
                      selectedOptions: selectedOptions,
                      setShowModal: setShowModal,
                      query: fragmentRefs
                    })), match$1 === 1 ? React.createElement(PDP_Normal_RfqBtn_Buyer.PC.make, {
                    query: fragmentRefs,
                    setShowModal: setShowModal
                  }) : null);
}

var PC = {
  ActionBtn: ActionBtn,
  OrderBtn: OrderBtn,
  make: PDP_Normal_Submit_Buyer$PC
};

function PDP_Normal_Submit_Buyer$MO$OrderBtn$ActionBtn(Props) {
  var query = Props.query;
  var className = Props.className;
  var selectedOptions = Props.selectedOptions;
  var setShowModal = Props.setShowModal;
  var children = Props.children;
  var product = use$1(query);
  var onClick = function (param) {
    Belt_Option.map(make(product, selectedOptions), (function (event$p) {
            DataGtm.push({
                  ecommerce: null
                });
            DataGtm.push(DataGtm.mergeUserIdUnsafe(event$p));
          }));
    setShowModal(function (param) {
          return /* Show */{
                  _0: /* Confirm */1
                };
        });
  };
  return React.createElement("button", {
              className: className,
              onClick: onClick
            }, children);
}

var ActionBtn$1 = {
  make: PDP_Normal_Submit_Buyer$MO$OrderBtn$ActionBtn
};

function PDP_Normal_Submit_Buyer$MO$OrderBtn(Props) {
  var status = Props.status;
  var selectedOptions = Props.selectedOptions;
  var setShowModal = Props.setShowModal;
  var query = Props.query;
  var user = Curry._1(CustomHooks.User.Buyer.use2, undefined);
  var btnStyle = "flex flex-1 rounded-xl items-center justify-center bg-primary font-bold text-white";
  var disabledStyle = "flex flex-1 rounded-xl items-center justify-center bg-gray-300 text-white font-bold";
  var orderStatus;
  if (status === "SOLDOUT") {
    orderStatus = /* Soldout */1;
  } else if (typeof user === "number") {
    orderStatus = user !== 0 ? /* Unauthorized */2 : /* Loading */0;
  } else {
    var match = Belt_MapString.toArray(selectedOptions);
    orderStatus = match.length !== 0 ? /* Available */({
          _0: selectedOptions
        }) : /* NoOption */3;
  }
  if (typeof orderStatus !== "number") {
    return React.createElement(PDP_Normal_Submit_Buyer$MO$OrderBtn$ActionBtn, {
                query: query,
                className: btnStyle,
                selectedOptions: orderStatus._0,
                setShowModal: setShowModal,
                children: "구매하기"
              });
  }
  switch (orderStatus) {
    case /* Loading */0 :
        return React.createElement("button", {
                    className: disabledStyle,
                    disabled: true
                  }, "");
    case /* Soldout */1 :
        return React.createElement("button", {
                    className: disabledStyle,
                    disabled: true
                  }, "품절");
    case /* Unauthorized */2 :
        return React.createElement("button", {
                    className: btnStyle,
                    onClick: (function (param) {
                        setShowModal(function (param) {
                              return /* Show */{
                                      _0: /* Unauthorized */{
                                        _0: "로그인 후에\n구매하실 수 있습니다."
                                      }
                                    };
                            });
                      })
                  }, "구매하기");
    case /* NoOption */3 :
        return React.createElement("button", {
                    className: btnStyle,
                    onClick: (function (param) {
                        setShowModal(function (param) {
                              return /* Show */{
                                      _0: /* NoOption */0
                                    };
                            });
                      })
                  }, "구매하기");
    
  }
}

var OrderBtn$1 = {
  ActionBtn: ActionBtn$1,
  make: PDP_Normal_Submit_Buyer$MO$OrderBtn
};

function PDP_Normal_Submit_Buyer$MO(Props) {
  var query = Props.query;
  var selectedOptions = Props.selectedOptions;
  var setShowModal = Props.setShowModal;
  var match = use(query);
  var fragmentRefs = match.fragmentRefs;
  var match$1 = Product_Parser.Type.decode(match.__typename);
  return React.createElement(PDP_CTA_Container_Buyer.make, {
              query: fragmentRefs,
              children: null
            }, match$1 === 1 ? React.createElement(React.Fragment, undefined, React.createElement(PDP_Normal_RfqBtn_Buyer.MO.make, {
                        query: fragmentRefs,
                        setShowModal: setShowModal
                      })) : null, React.createElement(PDP_Normal_Submit_Buyer$MO$OrderBtn, {
                  status: match.status,
                  selectedOptions: selectedOptions,
                  setShowModal: setShowModal,
                  query: fragmentRefs
                }));
}

var MO = {
  OrderBtn: OrderBtn$1,
  make: PDP_Normal_Submit_Buyer$MO
};

export {
  Fragment ,
  ButtonFragment ,
  ClickPurchaseGtm ,
  PC ,
  MO ,
}
/* react Not a pure module */
