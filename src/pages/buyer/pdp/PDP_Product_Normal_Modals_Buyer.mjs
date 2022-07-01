// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Curry from "rescript/lib/es6/curry.js";
import * as React from "react";
import * as DS_Icon from "../../../components/svgs/DS_Icon.mjs";
import * as Js_dict from "rescript/lib/es6/js_dict.js";
import * as Caml_obj from "rescript/lib/es6/caml_obj.js";
import * as ReactEvents from "../../../utils/ReactEvents.mjs";
import * as Router from "next/router";
import * as DS_BottomDrawer from "../../../components/common/container/DS_BottomDrawer.mjs";
import * as ShopDialog_Buyer from "../ShopDialog_Buyer.mjs";
import * as ReactDialog from "@radix-ui/react-dialog";
import * as PDP_Product_Normal_OrderSpecification_Buyer from "./PDP_Product_Normal_OrderSpecification_Buyer.mjs";

function PDP_Product_Normal_Modals_Buyer$Unauthorized$PC(Props) {
  var show = Props.show;
  var closeFn = Props.closeFn;
  var router = Router.useRouter();
  var onConfirm = function (param) {
    return ReactEvents.interceptingHandler((function (param) {
                  var redirectUrl = new URLSearchParams(Js_dict.fromArray([[
                                "redirect",
                                router.asPath
                              ]])).toString();
                  router.push("/buyer/signin?" + redirectUrl);
                  
                }), param);
  };
  var onCancel = function (param) {
    return ReactEvents.interceptingHandler((function (param) {
                  return Curry._1(closeFn, undefined);
                }), param);
  };
  return React.createElement(ShopDialog_Buyer.make, {
              isShow: show,
              confirmText: "로그인",
              cancelText: "취소",
              onConfirm: onConfirm,
              onCancel: onCancel,
              children: React.createElement("div", {
                    className: "h-18 mt-8 px-8 py-6 flex flex-col items-center justify-center text-lg text-text-L1"
                  }, React.createElement("span", undefined, "로그인 후에"), React.createElement("span", undefined, "구매하실 수 있습니다."))
            });
}

var PC = {
  make: PDP_Product_Normal_Modals_Buyer$Unauthorized$PC
};

function PDP_Product_Normal_Modals_Buyer$Unauthorized$MO(Props) {
  var show = Props.show;
  var closeFn = Props.closeFn;
  var router = Router.useRouter();
  var onConfirm = function (param) {
    return ReactEvents.interceptingHandler((function (param) {
                  var redirectUrl = new URLSearchParams(Js_dict.fromArray([[
                                "redirect",
                                router.asPath
                              ]])).toString();
                  router.push("/buyer/signin?" + redirectUrl);
                  
                }), param);
  };
  var onCancel = function (param) {
    return ReactEvents.interceptingHandler((function (param) {
                  return Curry._1(closeFn, undefined);
                }), param);
  };
  return React.createElement(ShopDialog_Buyer.Mo.make, {
              isShow: show,
              confirmText: "로그인",
              cancelText: "취소",
              onConfirm: onConfirm,
              onCancel: onCancel,
              children: React.createElement("div", {
                    className: "h-18 mt-8 px-8 py-6 flex flex-col items-center justify-center text-lg text-text-L1"
                  }, React.createElement("span", undefined, "로그인 후에"), React.createElement("span", undefined, "구매하실 수 있습니다."))
            });
}

var MO = {
  make: PDP_Product_Normal_Modals_Buyer$Unauthorized$MO
};

var Unauthorized = {
  PC: PC,
  MO: MO
};

function PDP_Product_Normal_Modals_Buyer$Confirm$MO(Props) {
  var show = Props.show;
  var closeFn = Props.closeFn;
  var selected = Props.selected;
  var quantity = Props.quantity;
  var setQuantity = Props.setQuantity;
  return React.createElement(DS_BottomDrawer.Root.make, {
              isShow: show,
              onClose: closeFn,
              children: null
            }, React.createElement(DS_BottomDrawer.Header.make, {}), React.createElement(DS_BottomDrawer.Body.make, {
                  children: React.createElement("div", {
                        className: "px-4 pb-9"
                      }, selected !== undefined ? React.createElement(React.Suspense, {
                              children: React.createElement(PDP_Product_Normal_OrderSpecification_Buyer.make, {
                                    selectedSkuId: selected.id,
                                    quantity: quantity,
                                    setQuantity: setQuantity
                                  }),
                              fallback: React.createElement(PDP_Product_Normal_OrderSpecification_Buyer.Placeholder.make, {})
                            }) : null)
                }));
}

var MO$1 = {
  make: PDP_Product_Normal_Modals_Buyer$Confirm$MO
};

function PDP_Product_Normal_Modals_Buyer$Confirm$PC(Props) {
  var show = Props.show;
  var closeFn = Props.closeFn;
  var selected = Props.selected;
  var quantity = Props.quantity;
  var setQuantity = Props.setQuantity;
  return React.createElement(ReactDialog.Root, {
              children: React.createElement(ReactDialog.Portal, {
                    children: null
                  }, React.createElement(ReactDialog.Overlay, {
                        className: "dialog-overlay"
                      }), React.createElement(ReactDialog.Content, {
                        children: React.createElement("div", {
                              className: "px-5"
                            }, React.createElement("section", {
                                  className: "w-full h-14 flex justify-end items-center"
                                }, React.createElement("button", {
                                      onClick: closeFn
                                    }, React.createElement(DS_Icon.Common.CloseLarge2.make, {
                                          height: "24",
                                          width: "24"
                                        }))), React.createElement("section", {
                                  className: "mt-4"
                                }, selected !== undefined ? React.createElement(React.Suspense, {
                                        children: React.createElement(PDP_Product_Normal_OrderSpecification_Buyer.make, {
                                              selectedSkuId: selected.id,
                                              quantity: quantity,
                                              setQuantity: setQuantity
                                            }),
                                        fallback: React.createElement(PDP_Product_Normal_OrderSpecification_Buyer.Placeholder.make, {})
                                      }) : null)),
                        className: "dialog-content-base bg-white rounded-xl w-[calc(100vw-40px)] max-w-[calc(768px-40px)]",
                        onPointerDownOutside: closeFn
                      })),
              open: show
            });
}

var PC$1 = {
  make: PDP_Product_Normal_Modals_Buyer$Confirm$PC
};

var Confirm = {
  MO: MO$1,
  PC: PC$1
};

function PDP_Product_Normal_Modals_Buyer$Soon$PC(Props) {
  var show = Props.show;
  var closeFn = Props.closeFn;
  var onCancel = function (param) {
    return ReactEvents.interceptingHandler((function (param) {
                  return Curry._1(closeFn, undefined);
                }), param);
  };
  return React.createElement(ShopDialog_Buyer.make, {
              isShow: show,
              cancelText: "확인",
              onCancel: onCancel,
              children: React.createElement("div", {
                    className: "mt-8 px-8 py-6 flex flex-col items-center justify-center text-text-L1"
                  }, React.createElement("span", undefined, "위탁 사업자 배송을 제외한 구매하기 기능은 6월 30일 오픈입니다."), React.createElement("span", undefined, "위탁 배송을 원하시는 분은 ‘위탁 배송 주문’ 버튼을 눌러주세요."))
            });
}

var PC$2 = {
  make: PDP_Product_Normal_Modals_Buyer$Soon$PC
};

function PDP_Product_Normal_Modals_Buyer$Soon$MO(Props) {
  var show = Props.show;
  var closeFn = Props.closeFn;
  var onCancel = function (param) {
    return ReactEvents.interceptingHandler((function (param) {
                  return Curry._1(closeFn, undefined);
                }), param);
  };
  return React.createElement(ShopDialog_Buyer.Mo.make, {
              isShow: show,
              cancelText: "확인",
              onCancel: onCancel,
              children: React.createElement("div", {
                    className: "mt-8 px-8 py-6 flex flex-col items-center justify-center text-lg text-text-L1 text-center"
                  }, React.createElement("span", undefined, "위탁 사업자 배송을 제외한 구매하기 기능은 6월 30일 오픈입니다."), React.createElement("span", undefined, "위탁 배송을 원하시는 분은 ‘위탁 배송 주문’ 버튼을 눌러주세요."))
            });
}

var MO$2 = {
  make: PDP_Product_Normal_Modals_Buyer$Soon$MO
};

var Soon = {
  PC: PC$2,
  MO: MO$2
};

function PDP_Product_Normal_Modals_Buyer$NoOption$PC(Props) {
  var show = Props.show;
  var closeFn = Props.closeFn;
  var onCancel = function (param) {
    return ReactEvents.interceptingHandler((function (param) {
                  return Curry._1(closeFn, undefined);
                }), param);
  };
  return React.createElement(ShopDialog_Buyer.make, {
              isShow: show,
              cancelText: "확인",
              onCancel: onCancel,
              children: React.createElement("div", {
                    className: "h-18 mt-8 px-8 py-6 flex flex-col items-center justify-center text-lg text-text-L1"
                  }, React.createElement("span", undefined, "단품을 선택해 주세요."))
            });
}

var PC$3 = {
  make: PDP_Product_Normal_Modals_Buyer$NoOption$PC
};

function PDP_Product_Normal_Modals_Buyer$NoOption$MO(Props) {
  var show = Props.show;
  var closeFn = Props.closeFn;
  var onCancel = function (param) {
    return ReactEvents.interceptingHandler((function (param) {
                  return Curry._1(closeFn, undefined);
                }), param);
  };
  return React.createElement(ShopDialog_Buyer.Mo.make, {
              isShow: show,
              cancelText: "확인",
              onCancel: onCancel,
              children: React.createElement("div", {
                    className: "h-18 mt-8 px-8 py-6 flex flex-col items-center justify-center text-lg text-text-L1"
                  }, React.createElement("span", undefined, "단품을 선택해 주세요."))
            });
}

var MO$3 = {
  make: PDP_Product_Normal_Modals_Buyer$NoOption$MO
};

var NoOption = {
  PC: PC$3,
  MO: MO$3
};

function PDP_Product_Normal_Modals_Buyer$PC(Props) {
  var show = Props.show;
  var setShow = Props.setShow;
  var selected = Props.selected;
  var quantity = Props.quantity;
  var setQuantity = Props.setQuantity;
  var closeFn = function (param) {
    return setShow(function (param) {
                return /* Hide */0;
              });
  };
  return React.createElement(React.Fragment, undefined, React.createElement(PDP_Product_Normal_Modals_Buyer$Confirm$PC, {
                  show: Caml_obj.caml_equal(show, /* Show */{
                        _0: /* Confirm */1
                      }) ? true : false,
                  closeFn: closeFn,
                  selected: selected,
                  quantity: quantity,
                  setQuantity: setQuantity
                }), React.createElement(PDP_Product_Normal_Modals_Buyer$Unauthorized$PC, {
                  show: Caml_obj.caml_equal(show, /* Show */{
                        _0: /* Unauthorized */0
                      }) ? /* Show */0 : /* Hide */1,
                  closeFn: closeFn
                }), React.createElement(PDP_Product_Normal_Modals_Buyer$NoOption$PC, {
                  show: Caml_obj.caml_equal(show, /* Show */{
                        _0: /* NoOption */3
                      }) ? /* Show */0 : /* Hide */1,
                  closeFn: closeFn
                }), React.createElement(PDP_Product_Normal_Modals_Buyer$Soon$PC, {
                  show: Caml_obj.caml_equal(show, /* Show */{
                        _0: /* Soon */2
                      }) ? /* Show */0 : /* Hide */1,
                  closeFn: closeFn
                }));
}

var PC$4 = {
  make: PDP_Product_Normal_Modals_Buyer$PC
};

function PDP_Product_Normal_Modals_Buyer$MO(Props) {
  var show = Props.show;
  var setShow = Props.setShow;
  var selected = Props.selected;
  var quantity = Props.quantity;
  var setQuantity = Props.setQuantity;
  var closeFn = function (param) {
    return setShow(function (param) {
                return /* Hide */0;
              });
  };
  return React.createElement(React.Fragment, undefined, React.createElement(PDP_Product_Normal_Modals_Buyer$Confirm$MO, {
                  show: Caml_obj.caml_equal(show, /* Show */{
                        _0: /* Confirm */1
                      }) ? true : false,
                  closeFn: closeFn,
                  selected: selected,
                  quantity: quantity,
                  setQuantity: setQuantity
                }), React.createElement(PDP_Product_Normal_Modals_Buyer$Unauthorized$MO, {
                  show: Caml_obj.caml_equal(show, /* Show */{
                        _0: /* Unauthorized */0
                      }) ? /* Show */0 : /* Hide */1,
                  closeFn: closeFn
                }), React.createElement(PDP_Product_Normal_Modals_Buyer$NoOption$MO, {
                  show: Caml_obj.caml_equal(show, /* Show */{
                        _0: /* NoOption */3
                      }) ? /* Show */0 : /* Hide */1,
                  closeFn: closeFn
                }), React.createElement(PDP_Product_Normal_Modals_Buyer$Soon$MO, {
                  show: Caml_obj.caml_equal(show, /* Show */{
                        _0: /* Soon */2
                      }) ? /* Show */0 : /* Hide */1,
                  closeFn: closeFn
                }));
}

var MO$4 = {
  make: PDP_Product_Normal_Modals_Buyer$MO
};

export {
  Unauthorized ,
  Confirm ,
  Soon ,
  NoOption ,
  PC$4 as PC,
  MO$4 as MO,
  
}
/* react Not a pure module */
