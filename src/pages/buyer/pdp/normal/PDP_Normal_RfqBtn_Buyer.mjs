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
import * as PDPNormalRfqBtnBuyer_fragment_graphql from "../../../../__generated__/PDPNormalRfqBtnBuyer_fragment_graphql.mjs";

function use(fRef) {
  var data = ReactRelay.useFragment(PDPNormalRfqBtnBuyer_fragment_graphql.node, fRef);
  return RescriptRelay_Internal.internal_useConvertedValue(PDPNormalRfqBtnBuyer_fragment_graphql.Internal.convertFragment, data);
}

function useOpt(opt_fRef) {
  var fr = opt_fRef !== undefined ? Caml_option.some(Caml_option.valFromOption(opt_fRef)) : undefined;
  var nullableFragmentData = ReactRelay.useFragment(PDPNormalRfqBtnBuyer_fragment_graphql.node, fr !== undefined ? Js_null_undefined.fromOption(Caml_option.some(Caml_option.valFromOption(fr))) : null);
  var data = (nullableFragmentData == null) ? undefined : Caml_option.some(nullableFragmentData);
  return RescriptRelay_Internal.internal_useConvertedValue((function (rawFragment) {
                if (rawFragment !== undefined) {
                  return PDPNormalRfqBtnBuyer_fragment_graphql.Internal.convertFragment(rawFragment);
                }
                
              }), data);
}

var Fragment_productSalesType_decode = PDPNormalRfqBtnBuyer_fragment_graphql.Utils.productSalesType_decode;

var Fragment_productSalesType_fromString = PDPNormalRfqBtnBuyer_fragment_graphql.Utils.productSalesType_fromString;

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

function PDP_Normal_RfqBtn_Buyer$PC(Props) {
  var query = Props.query;
  var setShowModal = Props.setShowModal;
  var router = Router.useRouter();
  var user = Curry._1(CustomHooks.User.Buyer.use2, undefined);
  var match = use(query);
  var productId = match.productId;
  var displayName = match.displayName;
  var category = match.category;
  var btnStyle = "mt-4 w-full h-16 rounded-xl bg-primary-light hover:bg-primary-light-variant text-primary text-lg font-bold hover:text-primary-variant";
  var disabledStyle = "mt-4 w-full h-16 rounded-xl bg-disabled-L2 text-lg font-bold text-white";
  var rfqStatus = typeof user === "number" ? (
      user !== 0 ? /* Unauthorized */1 : /* Loading */0
    ) : (
      user._0.role !== 1 ? /* NoPermission */2 : /* Available */({
            _0: Belt_Option.getWithDefault(decode(match.salesType), /* RFQ_LIVESTOCK */0)
          })
    );
  if (typeof rfqStatus === "number") {
    switch (rfqStatus) {
      case /* Unauthorized */1 :
          return React.createElement("button", {
                      className: btnStyle,
                      onClick: (function (param) {
                          setShowModal(function (param) {
                                return /* Show */{
                                        _0: /* Unauthorized */{
                                          _0: "로그인 후에\n견적을 받으실 수 있습니다."
                                        }
                                      };
                              });
                        })
                    }, "최저가 견적문의");
      case /* Loading */0 :
      case /* NoPermission */2 :
          return React.createElement("button", {
                      className: disabledStyle,
                      disabled: true
                    }, "최저가 견적문의");
      
    }
  } else {
    if (rfqStatus._0) {
      var onClick = function (param) {
        DataGtm.push(DataGtm.mergeUserIdUnsafe(make(displayName, productId, category)));
        var prim1 = "/buyer/tradematch/buy/products/" + String(productId) + "/apply";
        router.push(prim1);
      };
      return React.createElement("button", {
                  className: btnStyle,
                  onClick: onClick
                }, "최저가 견적문의");
    }
    var onClick$1 = function (param) {
      DataGtm.push(DataGtm.mergeUserIdUnsafe(make(displayName, productId, category)));
      var prim1 = "/buyer/tradematch/buy/products/" + String(productId) + "/apply";
      router.push(prim1);
    };
    return React.createElement("div", {
                onClick: onClick$1
              }, React.createElement(RfqCreateRequestButton.make, {
                    className: btnStyle,
                    buttonText: "최저가 견적문의"
                  }));
  }
}

var PC = {
  make: PDP_Normal_RfqBtn_Buyer$PC
};

function PDP_Normal_RfqBtn_Buyer$MO(Props) {
  var query = Props.query;
  var setShowModal = Props.setShowModal;
  var router = Router.useRouter();
  var user = Curry._1(CustomHooks.User.Buyer.use2, undefined);
  var match = use(query);
  var productId = match.productId;
  var displayName = match.displayName;
  var category = match.category;
  var btnStyle = "flex flex-1 items-center justify-center rounded-xl bg-white border border-primary text-primary text-lg font-bold        whitespace-pre";
  var disabledStyle = "flex flex-1 items-center justify-center rounded-xl bg-disabled-L2 text-lg font-bold text-white whitespace-pre";
  var rfqStatus = typeof user === "number" ? (
      user !== 0 ? /* Unauthorized */1 : /* Loading */0
    ) : (
      user._0.role !== 1 ? /* NoPermission */2 : /* Available */({
            _0: Belt_Option.getWithDefault(decode(match.salesType), /* RFQ_LIVESTOCK */0)
          })
    );
  if (typeof rfqStatus !== "number") {
    if (rfqStatus._0) {
      return React.createElement(React.Fragment, undefined, React.createElement("button", {
                      className: btnStyle,
                      onClick: (function (param) {
                          DataGtm.push(DataGtm.mergeUserIdUnsafe(make(displayName, productId, category)));
                          var prim1 = "/buyer/tradematch/buy/products/" + String(productId) + "/apply";
                          router.push(prim1);
                        })
                    }, "견적문의"));
    } else {
      return React.createElement(RfqCreateRequestButton.make, {
                  className: btnStyle,
                  buttonText: "견적문의"
                });
    }
  }
  switch (rfqStatus) {
    case /* Unauthorized */1 :
        return React.createElement(React.Fragment, undefined, React.createElement("button", {
                        className: btnStyle,
                        onClick: (function (param) {
                            setShowModal(function (param) {
                                  return /* Show */{
                                          _0: /* Unauthorized */{
                                            _0: "로그인 후에\n견적을 받으실 수 있습니다."
                                          }
                                        };
                                });
                          })
                      }, "견적문의"));
    case /* Loading */0 :
    case /* NoPermission */2 :
        return React.createElement("button", {
                    className: disabledStyle,
                    disabled: true
                  }, "견적문의");
    
  }
}

var MO = {
  make: PDP_Normal_RfqBtn_Buyer$MO
};

export {
  Fragment ,
  QuotationType ,
  RequestQuotationGtm ,
  PC ,
  MO ,
}
/* react Not a pure module */
