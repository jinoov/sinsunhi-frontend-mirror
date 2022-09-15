// Generated by ReScript, PLEASE EDIT WITH CARE

import * as React from "react";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import ReactNl2br from "react-nl2br";
import * as ReactRelay from "react-relay";
import * as Js_null_undefined from "rescript/lib/es6/js_null_undefined.js";
import * as RescriptRelay_Internal from "rescript-relay/src/RescriptRelay_Internal.mjs";
import * as PDPNormalContentsGuideBuyer_fragment_graphql from "../../../../__generated__/PDPNormalContentsGuideBuyer_fragment_graphql.mjs";

function use(fRef) {
  var data = ReactRelay.useFragment(PDPNormalContentsGuideBuyer_fragment_graphql.node, fRef);
  return RescriptRelay_Internal.internal_useConvertedValue(PDPNormalContentsGuideBuyer_fragment_graphql.Internal.convertFragment, data);
}

function useOpt(opt_fRef) {
  var fr = opt_fRef !== undefined ? Caml_option.some(Caml_option.valFromOption(opt_fRef)) : undefined;
  var nullableFragmentData = ReactRelay.useFragment(PDPNormalContentsGuideBuyer_fragment_graphql.node, fr !== undefined ? Js_null_undefined.fromOption(Caml_option.some(Caml_option.valFromOption(fr))) : null);
  var data = (nullableFragmentData == null) ? undefined : Caml_option.some(nullableFragmentData);
  return RescriptRelay_Internal.internal_useConvertedValue((function (rawFragment) {
                if (rawFragment !== undefined) {
                  return PDPNormalContentsGuideBuyer_fragment_graphql.Internal.convertFragment(rawFragment);
                }
                
              }), data);
}

var Fragment_productNotationInformationType_decode = PDPNormalContentsGuideBuyer_fragment_graphql.Utils.productNotationInformationType_decode;

var Fragment_productNotationInformationType_fromString = PDPNormalContentsGuideBuyer_fragment_graphql.Utils.productNotationInformationType_fromString;

var Fragment = {
  productNotationInformationType_decode: Fragment_productNotationInformationType_decode,
  productNotationInformationType_fromString: Fragment_productNotationInformationType_fromString,
  Types: undefined,
  Operation: undefined,
  use: use,
  useOpt: useOpt
};

function PDP_Normal_ContentsGuide_Buyer$Divider(Props) {
  return React.createElement("div", {
              className: "w-full h-[1px] bg-gray-100"
            });
}

var Divider = {
  make: PDP_Normal_ContentsGuide_Buyer$Divider
};

function PDP_Normal_ContentsGuide_Buyer$PC$Info(Props) {
  var k = Props.k;
  var v = Props.v;
  return React.createElement("div", {
              className: "flex items-center"
            }, React.createElement("div", {
                  className: "p-[18px] h-full flex items-center bg-gray-50"
                }, React.createElement("span", {
                      className: "w-[140px] text-gray-900 text-[14px]"
                    }, ReactNl2br(k))), React.createElement("div", {
                  className: "p-[18px] h-full flex items-center"
                }, React.createElement("span", {
                      className: "w-[408px] text-gray-700 text-[14px]"
                    }, Belt_Option.mapWithDefault(v, null, (function (prim) {
                            return ReactNl2br(prim);
                          })))));
}

var Info = {
  make: PDP_Normal_ContentsGuide_Buyer$PC$Info
};

function PDP_Normal_ContentsGuide_Buyer$PC$WholeFood(Props) {
  var displayName = Props.displayName;
  var origin = Props.origin;
  var tmp = {
    k: "원산지"
  };
  if (origin !== undefined) {
    tmp.v = Caml_option.valFromOption(origin);
  }
  return React.createElement("div", {
              className: "w-full flex flex-wrap border-gray-100 border-y"
            }, React.createElement(PDP_Normal_ContentsGuide_Buyer$PC$Info, {
                  k: "품목 또는 명칭",
                  v: displayName
                }), React.createElement(PDP_Normal_ContentsGuide_Buyer$PC$Info, {
                  k: "포장단위별 내용물 용량, 중량, 수량, 크기",
                  v: "컨텐츠 참조"
                }), React.createElement(PDP_Normal_ContentsGuide_Buyer$Divider, {}), React.createElement(PDP_Normal_ContentsGuide_Buyer$PC$Info, {
                  k: "생산자(수입자)",
                  v: "컨텐츠 참조"
                }), React.createElement(PDP_Normal_ContentsGuide_Buyer$PC$Info, tmp), React.createElement(PDP_Normal_ContentsGuide_Buyer$Divider, {}), React.createElement(PDP_Normal_ContentsGuide_Buyer$PC$Info, {
                  k: "제조연월일",
                  v: "컨텐츠 참조"
                }), React.createElement(PDP_Normal_ContentsGuide_Buyer$PC$Info, {
                  k: "관련법상 표시사항",
                  v: "컨텐츠 참조"
                }), React.createElement(PDP_Normal_ContentsGuide_Buyer$Divider, {}), React.createElement(PDP_Normal_ContentsGuide_Buyer$PC$Info, {
                  k: "수입식품 문구 여부",
                  v: "컨텐츠 참조"
                }), React.createElement(PDP_Normal_ContentsGuide_Buyer$PC$Info, {
                  k: "상품구성 ",
                  v: displayName
                }), React.createElement(PDP_Normal_ContentsGuide_Buyer$Divider, {}), React.createElement(PDP_Normal_ContentsGuide_Buyer$PC$Info, {
                  k: "보관방법",
                  v: "컨텐츠 참조"
                }), React.createElement(PDP_Normal_ContentsGuide_Buyer$PC$Info, {
                  k: "소비자안전을 위한 주의 사항",
                  v: "컨텐츠 참조"
                }), React.createElement(PDP_Normal_ContentsGuide_Buyer$Divider, {}), React.createElement(PDP_Normal_ContentsGuide_Buyer$PC$Info, {
                  k: "소비자상담관련 전화번호",
                  v: "1670-5245"
                }));
}

var WholeFood = {
  make: PDP_Normal_ContentsGuide_Buyer$PC$WholeFood
};

function PDP_Normal_ContentsGuide_Buyer$PC$ProcessedFood(Props) {
  var displayName = Props.displayName;
  return React.createElement("div", {
              className: "w-full flex flex-wrap border-gray-100 border-y"
            }, React.createElement(PDP_Normal_ContentsGuide_Buyer$PC$Info, {
                  k: "제품명",
                  v: displayName
                }), React.createElement(PDP_Normal_ContentsGuide_Buyer$PC$Info, {
                  k: "식품의 유형",
                  v: "컨텐츠 참조"
                }), React.createElement(PDP_Normal_ContentsGuide_Buyer$Divider, {}), React.createElement(PDP_Normal_ContentsGuide_Buyer$PC$Info, {
                  k: "생산자 및 소재지",
                  v: "컨텐츠 참조"
                }), React.createElement(PDP_Normal_ContentsGuide_Buyer$PC$Info, {
                  k: "제조연월일",
                  v: "컨텐츠 참조, 제품에 별도표기"
                }), React.createElement(PDP_Normal_ContentsGuide_Buyer$Divider, {}), React.createElement(PDP_Normal_ContentsGuide_Buyer$PC$Info, {
                  k: "포장단위별 내용물의 용량(중량), 수량",
                  v: "컨텐츠 참조"
                }), React.createElement(PDP_Normal_ContentsGuide_Buyer$PC$Info, {
                  k: "원재료명 및 함량",
                  v: "컨텐츠 참조"
                }), React.createElement(PDP_Normal_ContentsGuide_Buyer$Divider, {}), React.createElement(PDP_Normal_ContentsGuide_Buyer$PC$Info, {
                  k: "영양성분",
                  v: "컨텐츠 참조"
                }), React.createElement(PDP_Normal_ContentsGuide_Buyer$PC$Info, {
                  k: "유전자변형식품에 해당하는 경우의 표시 ",
                  v: "컨텐츠 참조"
                }), React.createElement(PDP_Normal_ContentsGuide_Buyer$Divider, {}), React.createElement(PDP_Normal_ContentsGuide_Buyer$PC$Info, {
                  k: "소비자안전을 위한 주의 사항",
                  v: "컨텐츠 참조"
                }), React.createElement(PDP_Normal_ContentsGuide_Buyer$PC$Info, {
                  k: "수입식품 문구",
                  v: "컨텐츠 참조"
                }), React.createElement(PDP_Normal_ContentsGuide_Buyer$Divider, {}), React.createElement(PDP_Normal_ContentsGuide_Buyer$PC$Info, {
                  k: "소비자상담관련 전화번호",
                  v: "1670-5245"
                }));
}

var ProcessedFood = {
  make: PDP_Normal_ContentsGuide_Buyer$PC$ProcessedFood
};

function PDP_Normal_ContentsGuide_Buyer$PC(Props) {
  var query = Props.query;
  var match = use(query);
  var notationInformationType = match.notationInformationType;
  var displayName = match.displayName;
  if (notationInformationType !== undefined) {
    if (notationInformationType === "WHOLE_FOOD") {
      return React.createElement(PDP_Normal_ContentsGuide_Buyer$PC$WholeFood, {
                  displayName: displayName,
                  origin: match.origin
                });
    } else if (notationInformationType === "PROCESSED_FOOD") {
      return React.createElement(PDP_Normal_ContentsGuide_Buyer$PC$ProcessedFood, {
                  displayName: displayName
                });
    } else {
      return null;
    }
  } else {
    return null;
  }
}

var PC = {
  Info: Info,
  WholeFood: WholeFood,
  ProcessedFood: ProcessedFood,
  make: PDP_Normal_ContentsGuide_Buyer$PC
};

function PDP_Normal_ContentsGuide_Buyer$MO$Info(Props) {
  var k = Props.k;
  var v = Props.v;
  return React.createElement("div", {
              className: "flex items-center"
            }, React.createElement("div", {
                  className: "w-[140px] p-[10px] h-full flex items-center bg-gray-50"
                }, React.createElement("span", {
                      className: "text-gray-900 text-[14px]"
                    }, Belt_Option.mapWithDefault(k, null, (function (prim) {
                            return ReactNl2br(prim);
                          })))), React.createElement("div", {
                  className: "p-[10px] h-full flex items-center"
                }, React.createElement("span", {
                      className: "text-gray-700 text-[14px]"
                    }, Belt_Option.mapWithDefault(v, null, (function (prim) {
                            return ReactNl2br(prim);
                          })))));
}

var Info$1 = {
  make: PDP_Normal_ContentsGuide_Buyer$MO$Info
};

function PDP_Normal_ContentsGuide_Buyer$MO$WholeFood(Props) {
  var displayName = Props.displayName;
  var origin = Props.origin;
  var tmp = {
    k: "원산지"
  };
  if (origin !== undefined) {
    tmp.v = Caml_option.valFromOption(origin);
  }
  return React.createElement("div", {
              className: "w-full border-gray-100 border-y"
            }, React.createElement(PDP_Normal_ContentsGuide_Buyer$MO$Info, {
                  k: "품목 또는 명칭",
                  v: displayName
                }), React.createElement(PDP_Normal_ContentsGuide_Buyer$Divider, {}), React.createElement(PDP_Normal_ContentsGuide_Buyer$MO$Info, {
                  k: "포장단위별 내용물 용량, 중량, 수량, 크기",
                  v: "컨텐츠 참조"
                }), React.createElement(PDP_Normal_ContentsGuide_Buyer$Divider, {}), React.createElement(PDP_Normal_ContentsGuide_Buyer$MO$Info, {
                  k: "생산자(수입자)",
                  v: "컨텐츠 참조"
                }), React.createElement(PDP_Normal_ContentsGuide_Buyer$Divider, {}), React.createElement(PDP_Normal_ContentsGuide_Buyer$MO$Info, tmp), React.createElement(PDP_Normal_ContentsGuide_Buyer$Divider, {}), React.createElement(PDP_Normal_ContentsGuide_Buyer$MO$Info, {
                  k: "제조연월일",
                  v: "컨텐츠 참조"
                }), React.createElement(PDP_Normal_ContentsGuide_Buyer$Divider, {}), React.createElement(PDP_Normal_ContentsGuide_Buyer$MO$Info, {
                  k: "관련법상 표시사항",
                  v: "컨텐츠 참조"
                }), React.createElement(PDP_Normal_ContentsGuide_Buyer$Divider, {}), React.createElement(PDP_Normal_ContentsGuide_Buyer$MO$Info, {
                  k: "수입식품 문구 여부",
                  v: "컨텐츠 참조"
                }), React.createElement(PDP_Normal_ContentsGuide_Buyer$Divider, {}), React.createElement(PDP_Normal_ContentsGuide_Buyer$MO$Info, {
                  k: "상품구성 ",
                  v: displayName
                }), React.createElement(PDP_Normal_ContentsGuide_Buyer$Divider, {}), React.createElement(PDP_Normal_ContentsGuide_Buyer$MO$Info, {
                  k: "보관방법",
                  v: "컨텐츠 참조"
                }), React.createElement(PDP_Normal_ContentsGuide_Buyer$Divider, {}), React.createElement(PDP_Normal_ContentsGuide_Buyer$MO$Info, {
                  k: "소비자안전을 위한 주의 사항",
                  v: "컨텐츠 참조"
                }), React.createElement(PDP_Normal_ContentsGuide_Buyer$Divider, {}), React.createElement(PDP_Normal_ContentsGuide_Buyer$MO$Info, {
                  k: "소비자상담관련 전화번호",
                  v: "1670-5245"
                }));
}

var WholeFood$1 = {
  make: PDP_Normal_ContentsGuide_Buyer$MO$WholeFood
};

function PDP_Normal_ContentsGuide_Buyer$MO$ProcessedFood(Props) {
  var displayName = Props.displayName;
  return React.createElement("div", {
              className: "w-full border-gray-100 border-y"
            }, React.createElement(PDP_Normal_ContentsGuide_Buyer$MO$Info, {
                  k: "제품명",
                  v: displayName
                }), React.createElement(PDP_Normal_ContentsGuide_Buyer$Divider, {}), React.createElement(PDP_Normal_ContentsGuide_Buyer$MO$Info, {
                  k: "식품의 유형",
                  v: "컨텐츠 참조"
                }), React.createElement(PDP_Normal_ContentsGuide_Buyer$Divider, {}), React.createElement(PDP_Normal_ContentsGuide_Buyer$MO$Info, {
                  k: "생산자 및 소재지",
                  v: "컨텐츠 참조"
                }), React.createElement(PDP_Normal_ContentsGuide_Buyer$Divider, {}), React.createElement(PDP_Normal_ContentsGuide_Buyer$MO$Info, {
                  k: "제조연월일",
                  v: "컨텐츠 참조, 제품에 별도표기"
                }), React.createElement(PDP_Normal_ContentsGuide_Buyer$Divider, {}), React.createElement(PDP_Normal_ContentsGuide_Buyer$MO$Info, {
                  k: "포장단위별 내용물의 용량(중량), 수량",
                  v: "컨텐츠 참조"
                }), React.createElement(PDP_Normal_ContentsGuide_Buyer$Divider, {}), React.createElement(PDP_Normal_ContentsGuide_Buyer$MO$Info, {
                  k: "원재료명 및 함량",
                  v: "컨텐츠 참조"
                }), React.createElement(PDP_Normal_ContentsGuide_Buyer$Divider, {}), React.createElement(PDP_Normal_ContentsGuide_Buyer$MO$Info, {
                  k: "영양성분",
                  v: "컨텐츠 참조"
                }), React.createElement(PDP_Normal_ContentsGuide_Buyer$Divider, {}), React.createElement(PDP_Normal_ContentsGuide_Buyer$MO$Info, {
                  k: "유전자변형식품에 해당하는 경우의 표시 ",
                  v: "컨텐츠 참조"
                }), React.createElement(PDP_Normal_ContentsGuide_Buyer$Divider, {}), React.createElement(PDP_Normal_ContentsGuide_Buyer$MO$Info, {
                  k: "소비자안전을 위한 주의 사항",
                  v: "컨텐츠 참조"
                }), React.createElement(PDP_Normal_ContentsGuide_Buyer$Divider, {}), React.createElement(PDP_Normal_ContentsGuide_Buyer$MO$Info, {
                  k: "수입식품 문구",
                  v: "컨텐츠 참조"
                }), React.createElement(PDP_Normal_ContentsGuide_Buyer$Divider, {}), React.createElement(PDP_Normal_ContentsGuide_Buyer$MO$Info, {
                  k: "소비자상담관련 전화번호",
                  v: "1670-5245"
                }));
}

var ProcessedFood$1 = {
  make: PDP_Normal_ContentsGuide_Buyer$MO$ProcessedFood
};

function PDP_Normal_ContentsGuide_Buyer$MO(Props) {
  var query = Props.query;
  var match = use(query);
  var notationInformationType = match.notationInformationType;
  var displayName = match.displayName;
  if (notationInformationType !== undefined) {
    if (notationInformationType === "WHOLE_FOOD") {
      return React.createElement(PDP_Normal_ContentsGuide_Buyer$MO$WholeFood, {
                  displayName: displayName,
                  origin: match.origin
                });
    } else if (notationInformationType === "PROCESSED_FOOD") {
      return React.createElement(PDP_Normal_ContentsGuide_Buyer$MO$ProcessedFood, {
                  displayName: displayName
                });
    } else {
      return null;
    }
  } else {
    return null;
  }
}

var MO = {
  Info: Info$1,
  WholeFood: WholeFood$1,
  ProcessedFood: ProcessedFood$1,
  make: PDP_Normal_ContentsGuide_Buyer$MO
};

export {
  Fragment ,
  Divider ,
  PC ,
  MO ,
}
/* react Not a pure module */