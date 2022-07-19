// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Curry from "rescript/lib/es6/curry.js";
import * as React from "react";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as ChannelTalk from "../../../../bindings/ChannelTalk.mjs";
import * as CustomHooks from "../../../../utils/CustomHooks.mjs";
import * as Product_Parser from "../../../../utils/Product_Parser.mjs";
import * as Js_null_undefined from "rescript/lib/es6/js_null_undefined.js";
import * as Hooks from "react-relay/hooks";
import * as PDP_Normal_Gtm_Buyer from "./PDP_Normal_Gtm_Buyer.mjs";
import * as RescriptRelay_Internal from "rescript-relay/src/RescriptRelay_Internal.mjs";
import * as RfqCreateRequestButton from "../../../../components/RfqCreateRequestButton.mjs";
import * as PDPNormalSubmitBuyerFragment_graphql from "../../../../__generated__/PDPNormalSubmitBuyerFragment_graphql.mjs";

function use(fRef) {
  var data = Hooks.useFragment(PDPNormalSubmitBuyerFragment_graphql.node, fRef);
  return RescriptRelay_Internal.internal_useConvertedValue(PDPNormalSubmitBuyerFragment_graphql.Internal.convertFragment, data);
}

function useOpt(opt_fRef) {
  var fr = opt_fRef !== undefined ? Caml_option.some(Caml_option.valFromOption(opt_fRef)) : undefined;
  var nullableFragmentData = Hooks.useFragment(PDPNormalSubmitBuyerFragment_graphql.node, fr !== undefined ? Js_null_undefined.fromOption(Caml_option.some(Caml_option.valFromOption(fr))) : null);
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
  use: use,
  useOpt: useOpt
};

function PDP_Normal_Submit_Buyer$PC$ActionBtn(Props) {
  var query = Props.query;
  var className = Props.className;
  var selectedOptionId = Props.selectedOptionId;
  var setShowModal = Props.setShowModal;
  var quantity = Props.quantity;
  var children = Props.children;
  var pushGtmClickBuy = PDP_Normal_Gtm_Buyer.ClickBuy.use(query, selectedOptionId, quantity);
  var onClick = function (param) {
    setShowModal(function (param) {
          return /* Show */{
                  _0: /* Confirm */1
                };
        });
    return Curry._1(pushGtmClickBuy, undefined);
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
  var selectedOptionId = Props.selectedOptionId;
  var setShowModal = Props.setShowModal;
  var query = Props.query;
  var quantity = Props.quantity;
  var user = Curry._1(CustomHooks.User.Buyer.use2, undefined);
  var btnStyle = "w-full h-16 rounded-xl flex items-center justify-center bg-primary hover:bg-primary-variant text-lg font-bold text-white";
  var disabledStyle = "w-full h-16 rounded-xl flex items-center justify-center bg-gray-300 text-white font-bold text-xl";
  var orderStatus = status === "SOLDOUT" ? /* Soldout */1 : (
      typeof user === "number" ? (
          user !== 0 ? /* Unauthorized */2 : /* Loading */0
        ) : (
          selectedOptionId !== undefined ? /* Fulfilled */({
                _0: selectedOptionId
              }) : /* NoOption */3
        )
    );
  if (typeof orderStatus !== "number") {
    return React.createElement(PDP_Normal_Submit_Buyer$PC$ActionBtn, {
                query: query,
                className: btnStyle,
                selectedOptionId: orderStatus._0,
                setShowModal: setShowModal,
                quantity: quantity,
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
                        return setShowModal(function (param) {
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
                        return setShowModal(function (param) {
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

function PDP_Normal_Submit_Buyer$PC$RfqBtn(Props) {
  var setShowModal = Props.setShowModal;
  var buttonText = "최저가 견적문의";
  var user = Curry._1(CustomHooks.User.Buyer.use2, undefined);
  var btnStyle = "mt-4 w-full h-16 rounded-xl bg-primary-light hover:bg-primary-light-variant text-primary text-lg font-bold hover:text-primary-variant";
  var disabledStyle = "mt-4 w-full h-16 rounded-xl bg-disabled-L2 text-lg font-bold text-white";
  if (typeof user === "number") {
    if (user !== 0) {
      return React.createElement("button", {
                  className: btnStyle,
                  onClick: (function (param) {
                      return setShowModal(function (param) {
                                  return /* Show */{
                                          _0: /* Unauthorized */{
                                            _0: "로그인 후에\n견적을 받으실 수 있습니다."
                                          }
                                        };
                                });
                    })
                }, buttonText);
    } else {
      return React.createElement("button", {
                  className: disabledStyle,
                  disabled: true
                }, buttonText);
    }
  } else if (user._0.role !== 1) {
    return React.createElement("button", {
                className: disabledStyle,
                disabled: true
              }, buttonText);
  } else {
    return React.createElement(RfqCreateRequestButton.make, {
                className: btnStyle,
                buttonText: buttonText
              });
  }
}

var RfqBtn = {
  make: PDP_Normal_Submit_Buyer$PC$RfqBtn
};

function PDP_Normal_Submit_Buyer$PC(Props) {
  var query = Props.query;
  var selectedOptionId = Props.selectedOptionId;
  var setShowModal = Props.setShowModal;
  var quantity = Props.quantity;
  var match = use(query);
  var match$1 = Product_Parser.Type.decode(match.__typename);
  return React.createElement("section", {
              className: "w-full"
            }, React.createElement(PDP_Normal_Submit_Buyer$PC$OrderBtn, {
                  status: match.status,
                  selectedOptionId: selectedOptionId,
                  setShowModal: setShowModal,
                  query: match.fragmentRefs,
                  quantity: quantity
                }), match$1 === 1 ? React.createElement(PDP_Normal_Submit_Buyer$PC$RfqBtn, {
                    setShowModal: setShowModal
                  }) : null);
}

var PC = {
  ActionBtn: ActionBtn,
  OrderBtn: OrderBtn,
  RfqBtn: RfqBtn,
  make: PDP_Normal_Submit_Buyer$PC
};

function PDP_Normal_Submit_Buyer$MO$CTAContainer(Props) {
  var children = Props.children;
  return React.createElement("div", {
              className: "fixed w-full bottom-0 left-0"
            }, React.createElement("div", {
                  className: "w-full max-w-[768px] p-3 mx-auto border-t border-t-gray-100 bg-white"
                }, React.createElement("div", {
                      className: "w-full h-14 flex"
                    }, React.createElement("button", {
                          onClick: (function (param) {
                              return ChannelTalk.showMessenger(undefined);
                            })
                        }, React.createElement("img", {
                              className: "w-14 h-14 mr-2",
                              alt: "cta-cs-btn-mobile",
                              src: "/icons/cs-gray-square.png"
                            })), Belt_Option.getWithDefault(children, null))));
}

var CTAContainer = {
  make: PDP_Normal_Submit_Buyer$MO$CTAContainer
};

function PDP_Normal_Submit_Buyer$MO$OrderBtn$ActionBtn(Props) {
  var query = Props.query;
  var className = Props.className;
  var selectedOptionId = Props.selectedOptionId;
  var setShowModal = Props.setShowModal;
  var quantity = Props.quantity;
  var children = Props.children;
  var pushGtmClickBuy = PDP_Normal_Gtm_Buyer.ClickBuy.use(query, selectedOptionId, quantity);
  var onClick = function (param) {
    setShowModal(function (param) {
          return /* Show */{
                  _0: /* Confirm */1
                };
        });
    return Curry._1(pushGtmClickBuy, undefined);
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
  var selectedOptionId = Props.selectedOptionId;
  var setShowModal = Props.setShowModal;
  var query = Props.query;
  var quantity = Props.quantity;
  var user = Curry._1(CustomHooks.User.Buyer.use2, undefined);
  var btnStyle = "flex flex-1 rounded-xl items-center justify-center bg-primary font-bold text-white";
  var disabledStyle = "flex flex-1 rounded-xl items-center justify-center bg-gray-300 text-white font-bold";
  var orderStatus = status === "SOLDOUT" ? /* Soldout */1 : (
      typeof user === "number" ? (
          user !== 0 ? /* Unauthorized */2 : /* Loading */0
        ) : (
          selectedOptionId !== undefined ? /* Fulfilled */({
                _0: selectedOptionId
              }) : /* NoOption */3
        )
    );
  if (typeof orderStatus !== "number") {
    return React.createElement(PDP_Normal_Submit_Buyer$MO$OrderBtn$ActionBtn, {
                query: query,
                className: btnStyle,
                selectedOptionId: orderStatus._0,
                setShowModal: setShowModal,
                quantity: quantity,
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
                        return setShowModal(function (param) {
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
                        return setShowModal(function (param) {
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

function PDP_Normal_Submit_Buyer$MO$RfqBtn(Props) {
  var setShowModal = Props.setShowModal;
  var buttonText = "최저가 견적문의";
  var user = Curry._1(CustomHooks.User.Buyer.use2, undefined);
  var btnStyle = "flex flex-1 items-center justify-center rounded-xl bg-white border border-primary text-primary text-lg font-bold";
  var disabledStyle = "flex flex-1 items-center justify-center rounded-xl bg-disabled-L2 text-lg font-bold text-white";
  if (typeof user === "number") {
    if (user !== 0) {
      return React.createElement(React.Fragment, undefined, React.createElement("button", {
                      className: btnStyle,
                      onClick: (function (param) {
                          return setShowModal(function (param) {
                                      return /* Show */{
                                              _0: /* Unauthorized */{
                                                _0: "로그인 후에\n견적을 받으실 수 있습니다."
                                              }
                                            };
                                    });
                        })
                    }, buttonText));
    } else {
      return React.createElement("button", {
                  className: disabledStyle,
                  disabled: true
                }, buttonText);
    }
  } else if (user._0.role !== 1) {
    return React.createElement("button", {
                className: disabledStyle,
                disabled: true
              }, buttonText);
  } else {
    return React.createElement(RfqCreateRequestButton.make, {
                className: btnStyle,
                buttonText: "최저가 견적문의"
              });
  }
}

var RfqBtn$1 = {
  make: PDP_Normal_Submit_Buyer$MO$RfqBtn
};

function PDP_Normal_Submit_Buyer$MO(Props) {
  var query = Props.query;
  var selectedOptionId = Props.selectedOptionId;
  var setShowModal = Props.setShowModal;
  var quantity = Props.quantity;
  var match = use(query);
  var fragmentRefs = match.fragmentRefs;
  var status = match.status;
  var __typename = match.__typename;
  var match$1 = Product_Parser.Type.decode(__typename);
  var match$2 = Product_Parser.Type.decode(__typename);
  return React.createElement(React.Fragment, undefined, React.createElement("div", {
                  className: "w-full h-14 flex"
                }, match$1 === 1 ? React.createElement(React.Fragment, undefined, React.createElement(PDP_Normal_Submit_Buyer$MO$RfqBtn, {
                            setShowModal: setShowModal
                          }), React.createElement("div", {
                            className: "w-2"
                          })) : null, React.createElement(PDP_Normal_Submit_Buyer$MO$OrderBtn, {
                      status: status,
                      selectedOptionId: selectedOptionId,
                      setShowModal: setShowModal,
                      query: fragmentRefs,
                      quantity: quantity
                    })), React.createElement(PDP_Normal_Submit_Buyer$MO$CTAContainer, {
                  children: null
                }, match$2 === 1 ? React.createElement(React.Fragment, undefined, React.createElement(PDP_Normal_Submit_Buyer$MO$RfqBtn, {
                            setShowModal: setShowModal
                          }), React.createElement("div", {
                            className: "w-2"
                          })) : null, React.createElement(PDP_Normal_Submit_Buyer$MO$OrderBtn, {
                      status: status,
                      selectedOptionId: selectedOptionId,
                      setShowModal: setShowModal,
                      query: fragmentRefs,
                      quantity: quantity
                    })));
}

var MO = {
  CTAContainer: CTAContainer,
  OrderBtn: OrderBtn$1,
  RfqBtn: RfqBtn$1,
  make: PDP_Normal_Submit_Buyer$MO
};

export {
  Fragment ,
  PC ,
  MO ,
  
}
/* react Not a pure module */
