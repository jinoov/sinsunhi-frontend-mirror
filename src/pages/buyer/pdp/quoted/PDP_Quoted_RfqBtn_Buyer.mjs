// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Curry from "rescript/lib/es6/curry.js";
import * as React from "react";
import * as DataGtm from "../../../../utils/DataGtm.mjs";
import * as Belt_Array from "rescript/lib/es6/belt_Array.js";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as CustomHooks from "../../../../utils/CustomHooks.mjs";
import * as Router from "next/router";
import * as ReactRelay from "react-relay";
import * as Js_null_undefined from "rescript/lib/es6/js_null_undefined.js";
import * as RescriptRelay_Internal from "rescript-relay/src/RescriptRelay_Internal.mjs";
import * as RfqCreateRequestButton from "../../../../components/RfqCreateRequestButton.mjs";
import * as PDP_CTA_Container_Buyer from "../common/PDP_CTA_Container_Buyer.mjs";
import * as PDPQuotedRfqBtnBuyer_fragment_graphql from "../../../../__generated__/PDPQuotedRfqBtnBuyer_fragment_graphql.mjs";

function use(fRef) {
  var data = ReactRelay.useFragment(PDPQuotedRfqBtnBuyer_fragment_graphql.node, fRef);
  return RescriptRelay_Internal.internal_useConvertedValue(PDPQuotedRfqBtnBuyer_fragment_graphql.Internal.convertFragment, data);
}

function useOpt(opt_fRef) {
  var fr = opt_fRef !== undefined ? Caml_option.some(Caml_option.valFromOption(opt_fRef)) : undefined;
  var nullableFragmentData = ReactRelay.useFragment(PDPQuotedRfqBtnBuyer_fragment_graphql.node, fr !== undefined ? Js_null_undefined.fromOption(Caml_option.some(Caml_option.valFromOption(fr))) : null);
  var data = (nullableFragmentData == null) ? undefined : Caml_option.some(nullableFragmentData);
  return RescriptRelay_Internal.internal_useConvertedValue((function (rawFragment) {
                if (rawFragment !== undefined) {
                  return PDPQuotedRfqBtnBuyer_fragment_graphql.Internal.convertFragment(rawFragment);
                }
                
              }), data);
}

var Fragment_productSalesType_decode = PDPQuotedRfqBtnBuyer_fragment_graphql.Utils.productSalesType_decode;

var Fragment_productSalesType_fromString = PDPQuotedRfqBtnBuyer_fragment_graphql.Utils.productSalesType_fromString;

var Fragment = {
  productSalesType_decode: Fragment_productSalesType_decode,
  productSalesType_fromString: Fragment_productSalesType_fromString,
  Types: undefined,
  Operation: undefined,
  use: use,
  useOpt: useOpt
};

function decode(v) {
  if (v === "RFQ_LIVESTOCK") {
    return /* RFQ_LIVESTOCK */0;
  } else if (v === "TRADEMATCH_AQUATIC") {
    return /* TRADEMATCH_AQUATIC */1;
  } else {
    return ;
  }
}

function encode(v) {
  if (v) {
    return "TRADEMATCH_AQUATIC";
  } else {
    return "RFQ_LIVESTOCK";
  }
}

var QuotationType = {
  decode: decode,
  encode: encode
};

function make(displayName, productId, category) {
  var categoryNames = Belt_Array.map(category.fullyQualifiedName, (function (param) {
          return param.name;
        }));
  return {
          event: "request_quotation",
          click_rfq_btn: {
            item_type: "견적",
            item_id: String(productId),
            item_name: displayName,
            item_category: Js_null_undefined.fromOption(Belt_Array.get(categoryNames, 0)),
            item_category2: Js_null_undefined.fromOption(Belt_Array.get(categoryNames, 1)),
            item_category3: Js_null_undefined.fromOption(Belt_Array.get(categoryNames, 2)),
            item_category4: Js_null_undefined.fromOption(Belt_Array.get(categoryNames, 3)),
            item_category5: Js_null_undefined.fromOption(Belt_Array.get(categoryNames, 4))
          }
        };
}

var RequestQuotationGtm = {
  make: make
};

function PDP_Quoted_RfqBtn_Buyer$PC(Props) {
  var setShowModal = Props.setShowModal;
  var query = Props.query;
  var router = Router.useRouter();
  var user = Curry._1(CustomHooks.User.Buyer.use2, undefined);
  var match = use(query);
  var productId = match.productId;
  var displayName = match.displayName;
  var category = match.category;
  var rfqStatus = typeof user === "number" ? (
      user !== 0 ? /* Unauthorized */1 : /* Loading */0
    ) : (
      user._0.role !== 1 ? /* NoPermission */2 : /* Available */({
            _0: Belt_Option.getWithDefault(decode(match.salesType), /* RFQ_LIVESTOCK */0)
          })
    );
  var btnStyle = "w-full h-16 rounded-xl bg-primary hover:bg-primary-variant text-white text-lg font-bold flex-1";
  var disabledStyle = "w-full h-16 rounded-xl flex items-center justify-center bg-gray-300 text-white font-bold text-xl flex-1";
  if (typeof rfqStatus !== "number") {
    if (rfqStatus._0) {
      return React.createElement("button", {
                  className: btnStyle,
                  onClick: (function (param) {
                      DataGtm.push(DataGtm.mergeUserIdUnsafe(make(displayName, productId, category)));
                      var prim1 = "/buyer/tradematch/buy/products/" + String(productId) + "/apply";
                      router.push(prim1);
                    })
                }, "최저가 견적받기");
    } else {
      return React.createElement("div", {
                  className: "flex-1",
                  onClick: (function (param) {
                      DataGtm.push(DataGtm.mergeUserIdUnsafe(make(displayName, productId, category)));
                    })
                }, React.createElement(RfqCreateRequestButton.make, {
                      className: btnStyle,
                      buttonText: "최저가 견적받기"
                    }));
    }
  }
  switch (rfqStatus) {
    case /* Unauthorized */1 :
        return React.createElement("button", {
                    className: btnStyle,
                    onClick: (function (param) {
                        setShowModal(function (param) {
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
    
  }
}

var PC = {
  make: PDP_Quoted_RfqBtn_Buyer$PC
};

function PDP_Quoted_RfqBtn_Buyer$MO(Props) {
  var setShowModal = Props.setShowModal;
  var query = Props.query;
  var router = Router.useRouter();
  var user = Curry._1(CustomHooks.User.Buyer.use2, undefined);
  var match = use(query);
  var fragmentRefs = match.fragmentRefs;
  var productId = match.productId;
  var displayName = match.displayName;
  var category = match.category;
  var rfqStatus = typeof user === "number" ? (
      user !== 0 ? /* Unauthorized */1 : /* Loading */0
    ) : (
      user._0.role !== 1 ? /* NoPermission */2 : /* Available */({
            _0: Belt_Option.getWithDefault(decode(match.salesType), /* RFQ_LIVESTOCK */0)
          })
    );
  var btnStyle = "h-14 flex-1 rounded-xl bg-primary text-white text-lg font-bold";
  var disabledStyle = "h-14 flex-1 rounded-xl bg-disabled-L2 text-white text-lg font-bold";
  if (typeof rfqStatus === "number") {
    switch (rfqStatus) {
      case /* Loading */0 :
          return React.createElement("button", {
                      className: disabledStyle,
                      disabled: true
                    }, "최저가 견적받기");
      case /* Unauthorized */1 :
          return React.createElement(React.Fragment, undefined, React.createElement("button", {
                          className: btnStyle,
                          onClick: (function (param) {
                              setShowModal(function (param) {
                                    return /* Show */{
                                            _0: /* Unauthorized */0
                                          };
                                  });
                            })
                        }, "최저가 견적받기"), React.createElement(PDP_CTA_Container_Buyer.make, {
                          query: fragmentRefs,
                          children: React.createElement("button", {
                                className: btnStyle,
                                onClick: (function (param) {
                                    setShowModal(function (param) {
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
                        }, "최저가 견적받기"), React.createElement(PDP_CTA_Container_Buyer.make, {
                          query: fragmentRefs,
                          children: React.createElement("button", {
                                className: disabledStyle,
                                disabled: true
                              }, "최저가 견적받기")
                        }));
      
    }
  } else {
    if (rfqStatus._0) {
      var onClick = function (param) {
        DataGtm.push(DataGtm.mergeUserIdUnsafe(make(displayName, productId, category)));
        var prim1 = "/buyer/tradematch/buy/products/" + String(productId) + "/apply";
        router.push(prim1);
      };
      return React.createElement(React.Fragment, undefined, React.createElement("button", {
                      className: btnStyle,
                      onClick: onClick
                    }, "최저가 견적받기"), React.createElement(PDP_CTA_Container_Buyer.make, {
                      query: fragmentRefs,
                      children: React.createElement("button", {
                            className: btnStyle,
                            onClick: onClick
                          }, "최저가 견적받기")
                    }));
    }
    var onClick$1 = function (param) {
      DataGtm.push(DataGtm.mergeUserIdUnsafe(make(displayName, productId, category)));
    };
    return React.createElement(React.Fragment, undefined, React.createElement("div", {
                    onClick: onClick$1
                  }, React.createElement(RfqCreateRequestButton.make, {
                        className: btnStyle,
                        buttonText: "최저가 견적받기"
                      })), React.createElement(PDP_CTA_Container_Buyer.make, {
                    query: fragmentRefs,
                    children: React.createElement("div", {
                          className: "w-full flex flex-1",
                          onClick: onClick$1
                        }, React.createElement(RfqCreateRequestButton.make, {
                              className: btnStyle,
                              buttonText: "최저가 견적받기"
                            }))
                  }));
  }
}

var MO = {
  make: PDP_Quoted_RfqBtn_Buyer$MO
};

export {
  Fragment ,
  QuotationType ,
  RequestQuotationGtm ,
  PC ,
  MO ,
}
/* react Not a pure module */
