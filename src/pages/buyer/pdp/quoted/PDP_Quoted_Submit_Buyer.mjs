// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Curry from "rescript/lib/es6/curry.js";
import * as React from "react";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as ChannelTalk from "../../../../bindings/ChannelTalk.mjs";
import * as CustomHooks from "../../../../utils/CustomHooks.mjs";
import * as PDP_Quoted_Gtm_Buyer from "./PDP_Quoted_Gtm_Buyer.mjs";
import * as RfqCreateRequestButton from "../../../../components/RfqCreateRequestButton.mjs";

function PDP_Quoted_Submit_Buyer$PC(Props) {
  var setShowModal = Props.setShowModal;
  var query = Props.query;
  var user = Curry._1(CustomHooks.User.Buyer.use2, undefined);
  var gtmPushClickRfq = PDP_Quoted_Gtm_Buyer.ClickRfq.use(query);
  var btnStyle = "w-full h-16 rounded-xl bg-primary hover:bg-primary-variant text-white text-lg font-bold";
  var disabledStyle = "w-full h-16 rounded-xl flex items-center justify-center bg-gray-300 text-white font-bold text-xl";
  var orderStatus = typeof user === "number" ? (
      user !== 0 ? /* Unauthorized */1 : /* Loading */0
    ) : (
      user._0.role !== 1 ? /* NoPermission */2 : /* Fulfilled */3
    );
  console.log(orderStatus);
  switch (orderStatus) {
    case /* Unauthorized */1 :
        return React.createElement("button", {
                    className: btnStyle,
                    onClick: (function (param) {
                        return setShowModal(function (param) {
                                    return /* Show */{
                                            _0: /* Unauthorized */0
                                          };
                                  });
                      })
                  }, "최저가 견적받기");
    case /* Loading */0 :
    case /* NoPermission */2 :
        return React.createElement("button", {
                    className: disabledStyle,
                    disabled: true
                  }, "최저가 견적받기");
    case /* Fulfilled */3 :
        return React.createElement("div", {
                    onClick: (function (param) {
                        return Curry._1(gtmPushClickRfq, undefined);
                      })
                  }, React.createElement(RfqCreateRequestButton.make, {
                        className: btnStyle,
                        buttonText: "최저가 견적받기"
                      }));
    
  }
}

var PC = {
  make: PDP_Quoted_Submit_Buyer$PC
};

function PDP_Quoted_Submit_Buyer$MO$CTAContainer(Props) {
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
  make: PDP_Quoted_Submit_Buyer$MO$CTAContainer
};

function PDP_Quoted_Submit_Buyer$MO(Props) {
  var setShowModal = Props.setShowModal;
  var query = Props.query;
  var user = Curry._1(CustomHooks.User.Buyer.use2, undefined);
  var gtmPushClickRfq = PDP_Quoted_Gtm_Buyer.ClickRfq.use(query);
  var btnStyle = "h-14 w-full rounded-xl bg-primary text-white text-lg font-bold";
  var disabledStyle = "h-14 w-full rounded-xl bg-disabled-L2 text-white text-lg font-bold";
  var orderStatus = typeof user === "number" ? (
      user !== 0 ? /* Unauthorized */1 : /* Loading */0
    ) : (
      user._0.role !== 1 ? /* NoPermission */2 : /* Fulfilled */3
    );
  switch (orderStatus) {
    case /* Loading */0 :
        return React.createElement("button", {
                    className: disabledStyle,
                    disabled: true
                  }, "최저가 견적받기");
    case /* Unauthorized */1 :
        return React.createElement(React.Fragment, undefined, React.createElement("button", {
                        className: btnStyle,
                        onClick: (function (param) {
                            return setShowModal(function (param) {
                                        return /* Show */{
                                                _0: /* Unauthorized */0
                                              };
                                      });
                          })
                      }, "최저가 견적받기"), React.createElement(PDP_Quoted_Submit_Buyer$MO$CTAContainer, {
                        children: React.createElement("button", {
                              className: btnStyle,
                              onClick: (function (param) {
                                  return setShowModal(function (param) {
                                              return /* Show */{
                                                      _0: /* Unauthorized */0
                                                    };
                                            });
                                })
                            }, "최저가 견적받기")
                      }));
    case /* NoPermission */2 :
        return React.createElement(React.Fragment, undefined, React.createElement("button", {
                        className: disabledStyle,
                        disabled: true
                      }, "최저가 견적받기"), React.createElement(PDP_Quoted_Submit_Buyer$MO$CTAContainer, {
                        children: React.createElement("button", {
                              className: disabledStyle,
                              disabled: true
                            }, "최저가 견적받기")
                      }));
    case /* Fulfilled */3 :
        return React.createElement(React.Fragment, undefined, React.createElement("div", {
                        onClick: (function (param) {
                            return Curry._1(gtmPushClickRfq, undefined);
                          })
                      }, React.createElement(RfqCreateRequestButton.make, {
                            className: btnStyle,
                            buttonText: "최저가 견적받기"
                          })), React.createElement(PDP_Quoted_Submit_Buyer$MO$CTAContainer, {
                        children: React.createElement("div", {
                              onClick: (function (param) {
                                  return Curry._1(gtmPushClickRfq, undefined);
                                })
                            }, React.createElement(RfqCreateRequestButton.make, {
                                  className: btnStyle,
                                  buttonText: "최저가 견적받기"
                                }))
                      }));
    
  }
}

var MO = {
  CTAContainer: CTAContainer,
  make: PDP_Quoted_Submit_Buyer$MO
};

export {
  PC ,
  MO ,
  
}
/* react Not a pure module */
