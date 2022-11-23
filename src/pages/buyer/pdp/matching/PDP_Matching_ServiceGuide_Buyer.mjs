// Generated by ReScript, PLEASE EDIT WITH CARE

import * as $$Image from "../../../../components/common/Image.mjs";
import * as React from "react";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import ReactNl2br from "react-nl2br";

function PDP_Matching_ServiceGuide_Buyer$Card(Props) {
  var className = Props.className;
  var children = Props.children;
  return React.createElement("div", {
              className: "w-full bg-[#ECF6EC] rounded-xl py-10 px-7 flex flex-col items-center " + Belt_Option.getWithDefault(className, "")
            }, Belt_Option.getWithDefault(children, null));
}

var Card = {
  make: PDP_Matching_ServiceGuide_Buyer$Card
};

function PDP_Matching_ServiceGuide_Buyer$PriceCard(Props) {
  return React.createElement(PDP_Matching_ServiceGuide_Buyer$Card, {
              children: null
            }, React.createElement("span", {
                  className: "text-[26px] font-bold text-text-L1"
                }, "국내", React.createElement("span", {
                      className: "text-primary-variant"
                    }, " 최저가 "), "도전"), React.createElement("p", {
                  className: "mt-4 max-w-[335px] text-gray-700 text-[17px] text-center"
                }, "신선하이는 생산자와 직접 매칭이 가능하여 중간 유통을 최소화할 수 있습니다."), React.createElement("div", {
                  className: "mt-10 py-2"
                }, React.createElement($$Image.make, {
                      src: "/images/matching-card-price.png",
                      loading: /* Lazy */1,
                      alt: "신선하이 매칭 가격",
                      className: "w-[280px] h-[144px] object-contain"
                    })));
}

var PriceCard = {
  make: PDP_Matching_ServiceGuide_Buyer$PriceCard
};

function PDP_Matching_ServiceGuide_Buyer$GradeCard(Props) {
  return React.createElement(PDP_Matching_ServiceGuide_Buyer$Card, {
              className: "mt-4",
              children: null
            }, React.createElement("span", {
                  className: "text-[26px] font-bold text-text-L1"
                }, "신선하이 자체"), React.createElement("span", {
                  className: "text-[26px] font-bold text-primary-variant"
                }, "가격 분류 체계"), React.createElement("p", {
                  className: "mt-4 max-w-[335px] text-gray-700 text-[17px] text-center"
                }, "신선하이는 고객들의 직곽적으로 파악할 수 있도록 3가지 형태로 가격 분류 체계를 설계하였습니다."), React.createElement("div", {
                  className: "mt-10 py-2"
                }, React.createElement($$Image.make, {
                      src: "/images/matching-card-grade.png",
                      loading: /* Lazy */1,
                      alt: "신선하이 매칭 가격 분류",
                      className: "w-[262px] h-[126px] object-contain"
                    })));
}

var GradeCard = {
  make: PDP_Matching_ServiceGuide_Buyer$GradeCard
};

function PDP_Matching_ServiceGuide_Buyer$DeliveryCard(Props) {
  return React.createElement(PDP_Matching_ServiceGuide_Buyer$Card, {
              className: "mt-4",
              children: null
            }, React.createElement("span", {
                  className: "text-[26px] font-bold text-text-L1"
                }, "당일 매칭,"), React.createElement("span", {
                  className: "text-[26px] font-bold text-primary-variant"
                }, "매칭 후일 바로 발송"), React.createElement("p", {
                  className: "mt-4 max-w-[335px] text-gray-700 text-[17px] text-center"
                }, "신선하이는 생산들에게 직접 견적을 발송받아 바이어와 빠르게 매칭을 해드립니다."), React.createElement("div", {
                  className: "mt-10 py-2"
                }, React.createElement($$Image.make, {
                      src: "/images/matching-card-delivery.png",
                      loading: /* Lazy */1,
                      alt: "신선하이 매칭 배송",
                      className: "w-[180px] h-[144px] object-contain"
                    })));
}

var DeliveryCard = {
  make: PDP_Matching_ServiceGuide_Buyer$DeliveryCard
};

function PDP_Matching_ServiceGuide_Buyer$Banner(Props) {
  return React.createElement("div", {
              className: "w-full relative"
            }, React.createElement("picture", undefined, React.createElement("source", {
                      media: "(max-width: 450px)",
                      srcSet: "/images/matching-guide-bg-mo.png"
                    }), React.createElement("source", {
                      media: "(min-width: 451px)",
                      srcSet: "/images/matching-guide-bg-pc.png"
                    }), React.createElement($$Image.make, {
                      src: "/images/matching-guide-bg-pc.png",
                      alt: "신선하이 매칭",
                      className: "w-full h-[336px] object-cover"
                    })), React.createElement("div", {
                  className: "absolute top-1/2 -translate-y-1/2 left-1/2 -translate-x-1/2"
                }, React.createElement("div", {
                      className: "w-[315px] flex flex-col items-center"
                    }, React.createElement("div", {
                          className: "py-[6px] px-4 bg-white text-primary font-bold text-sm rounded-full"
                        }, "최저가 견적받기"), React.createElement("div", {
                          className: "mt-4 text-white text-[26px] flex flex-col items-center"
                        }, React.createElement("span", {
                              className: "font-bold"
                            }, "신선하이 매칭"), React.createElement("span", undefined, "서비스를 알려드릴게요")), React.createElement("div", {
                          className: "mt-4"
                        }, React.createElement("p", {
                              className: "text-center text-white"
                            }, "팜모닝 70만 농가의 판매신청 데이터를 바탕으로 원하는 스펙의 상품을 쉽고 빠르게 전국도매시장 시세와 비교하여 구매할 수 있는 서비스입니다.")))));
}

var Banner = {
  make: PDP_Matching_ServiceGuide_Buyer$Banner
};

function PDP_Matching_ServiceGuide_Buyer$Footer(Props) {
  return React.createElement("section", {
              className: "py-[60px] px-[30px] bg-blue-gray-700"
            }, React.createElement("div", {
                  className: "flex flex-col items-center text-xl font-bold text-center"
                }, React.createElement("span", {
                      className: "hidden md:block text-white"
                    }, ReactNl2br("신선하이 전문 MD는 신선도, 모양, 짓무름, 당도 등")), React.createElement("span", {
                      className: "block md:hidden text-white"
                    }, ReactNl2br("신선하이 전문 MD는\n신선도, 모양, 짓무름, 당도 등")), React.createElement("span", {
                      className: "text-primary"
                    }, "상품을 꼼꼼하게 확인합니다. 안심하고 구매하셔도 좋습니다.")));
}

var Footer = {
  make: PDP_Matching_ServiceGuide_Buyer$Footer
};

function PDP_Matching_ServiceGuide_Buyer$Content(Props) {
  return React.createElement(React.Fragment, undefined, React.createElement(PDP_Matching_ServiceGuide_Buyer$Banner, {}), React.createElement("section", {
                  className: "px-5 pt-10 pb-[66px]"
                }, React.createElement(PDP_Matching_ServiceGuide_Buyer$PriceCard, {}), React.createElement(PDP_Matching_ServiceGuide_Buyer$GradeCard, {}), React.createElement(PDP_Matching_ServiceGuide_Buyer$DeliveryCard, {})), React.createElement(PDP_Matching_ServiceGuide_Buyer$Footer, {}));
}

var Content = {
  make: PDP_Matching_ServiceGuide_Buyer$Content
};

function PDP_Matching_ServiceGuide_Buyer$Trigger(Props) {
  var onClick = Props.onClick;
  return React.createElement("button", {
              className: "w-full p-5 rounded-xl bg-[#EFF7FC] flex items-center justify-between",
              onClick: onClick
            }, React.createElement("div", {
                  className: "flex flex-col items-start"
                }, React.createElement("span", {
                      className: "text-black text-base font-bold"
                    }, "신선매칭이란?"), React.createElement("span", {
                      className: "mt-2 text-gray-600 text-sm text-left"
                    }, ReactNl2br("필요한 품종에 대해 견적요청하시면,\n최저가 상품을 연결해드립니다."))), React.createElement($$Image.make, {
                  src: "/images/matching-button.png",
                  alt: "",
                  className: "w-[69px] object-contain"
                }));
}

var Trigger = {
  make: PDP_Matching_ServiceGuide_Buyer$Trigger
};

export {
  Card ,
  PriceCard ,
  GradeCard ,
  DeliveryCard ,
  Banner ,
  Footer ,
  Content ,
  Trigger ,
}
/* Image Not a pure module */
