// Generated by ReScript, PLEASE EDIT WITH CARE

import * as React from "react";

function Delivery_Main_InfoBanner$PC$Skeleton(props) {
  return React.createElement("div", {
              className: "w-[1280px] mx-auto h-[108px] rounded-[10px] animate-pulse bg-gray-150"
            });
}

var Skeleton = {
  make: Delivery_Main_InfoBanner$PC$Skeleton
};

function Delivery_Main_InfoBanner$PC(props) {
  return React.createElement("div", {
              className: "w-[1280px] mx-auto h-[98px] rounded-[10px] flex items-center bg-green-50 pl-9"
            }, React.createElement("img", {
                  className: "w-[111px] object-contain",
                  src: "https://public.sinsunhi.com/images/20220713/sinsun_delivery_description.png"
                }), React.createElement("div", {
                  className: "flex-1 flex flex-col h-full text-lg items-stretch pl-9 py-[26px] text-gray-800 "
                }, React.createElement("div", {
                      className: "font-bold mb-1 leading-[22px]"
                    }, "신선배송이란?"), React.createElement("div", {
                      className: "leading-5"
                    }, "신선한 상품들을 바로 구매할 수 있고,\n여러 곳으로 배송할 수 있습니다.")));
}

var PC = {
  Skeleton: Skeleton,
  make: Delivery_Main_InfoBanner$PC
};

function Delivery_Main_InfoBanner$MO$Skeleton(props) {
  return React.createElement("div", {
              className: "w-full flex h-[98px] animate-pulse bg-gray-150"
            });
}

var Skeleton$1 = {
  make: Delivery_Main_InfoBanner$MO$Skeleton
};

function Delivery_Main_InfoBanner$MO(props) {
  return React.createElement("div", {
              className: "w-full flex h-[98px] bg-green-50"
            }, React.createElement("div", {
                  className: "flex-1 flex flex-col h-full p-4 text-sm text-gray-800"
                }, React.createElement("div", {
                      className: "font-bold mb-1"
                    }, "신선배송이란?"), React.createElement("div", {
                      className: "whitespace-pre"
                    }, "신선한 상품들을 바로 구매할 수 있고,\n여러 곳으로 배송할 수 있습니다.")), React.createElement("img", {
                  className: "w-[108px] h-full mr-[18px] object-contain",
                  src: "https://public.sinsunhi.com/images/20220713/sinsun_delivery_description.png"
                }));
}

var MO = {
  Skeleton: Skeleton$1,
  make: Delivery_Main_InfoBanner$MO
};

export {
  PC ,
  MO ,
}
/* react Not a pure module */
