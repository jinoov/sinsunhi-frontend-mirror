// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Curry from "rescript/lib/es6/curry.js";
import * as React from "react";
import * as DS_Icon from "../../../../components/svgs/DS_Icon.mjs";
import * as Js_dict from "rescript/lib/es6/js_dict.js";
import * as IconClose from "../../../../components/svgs/IconClose.mjs";
import * as Router from "next/router";
import ReactNl2br from "react-nl2br";
import * as Belt_MapString from "rescript/lib/es6/belt_MapString.js";
import * as DS_BottomDrawer from "../../../../components/common/container/DS_BottomDrawer.mjs";
import * as ShopDialog_Buyer from "../../ShopDialog_Buyer.mjs";
import * as ReactDialog from "@radix-ui/react-dialog";
import * as ReactScrollArea from "@radix-ui/react-scroll-area";
import * as PDP_Normal_ContentsGuide_Buyer from "./PDP_Normal_ContentsGuide_Buyer.mjs";
import * as PDP_Normal_OrderSpecification_Buyer from "./PDP_Normal_OrderSpecification_Buyer.mjs";

function PDP_Normal_Modals_Buyer$ContentsGuide$Scroll(Props) {
  var children = Props.children;
  return React.createElement(ReactScrollArea.Root, {
              children: null,
              className: "h-screen flex flex-col overflow-hidden"
            }, React.createElement(ReactScrollArea.Viewport, {
                  children: children,
                  className: "w-full h-full"
                }), React.createElement(ReactScrollArea.Scrollbar, {
                  children: React.createElement(ReactScrollArea.Thumb, {})
                }));
}

var Scroll = {
  make: PDP_Normal_Modals_Buyer$ContentsGuide$Scroll
};

function PDP_Normal_Modals_Buyer$ContentsGuide$ContentsGuideHeader(Props) {
  var closeFn = Props.closeFn;
  return React.createElement("section", {
              className: "w-full h-14 flex items-center px-4"
            }, React.createElement("div", {
                  className: "w-10 h-10"
                }), React.createElement("div", {
                  className: "flex flex-1 items-center justify-center"
                }, React.createElement("h1", {
                      className: "font-bold text-gray-800 text-xl"
                    }, "필수 표기정보")), React.createElement("button", {
                  className: "w-10 h-10 flex items-center justify-center ",
                  onClick: closeFn
                }, React.createElement(IconClose.make, {
                      height: "24",
                      width: "24",
                      fill: "#262626"
                    })));
}

var ContentsGuideHeader = {
  make: PDP_Normal_Modals_Buyer$ContentsGuide$ContentsGuideHeader
};

function PDP_Normal_Modals_Buyer$ContentsGuide(Props) {
  var show = Props.show;
  var closeFn = Props.closeFn;
  var query = Props.query;
  var _open;
  if (show) {
    var match = show._0;
    _open = typeof match === "number" ? match >= 2 : false;
  } else {
    _open = false;
  }
  return React.createElement(ReactDialog.Root, {
              children: React.createElement(ReactDialog.Portal, {
                    children: null
                  }, React.createElement(ReactDialog.Overlay, {
                        className: "dialog-overlay"
                      }), React.createElement(ReactDialog.Content, {
                        children: React.createElement(PDP_Normal_Modals_Buyer$ContentsGuide$Scroll, {
                              children: null
                            }, React.createElement(PDP_Normal_Modals_Buyer$ContentsGuide$ContentsGuideHeader, {
                                  closeFn: closeFn
                                }), React.createElement("div", {
                                  className: "w-full px-5 py-2"
                                }, React.createElement(PDP_Normal_ContentsGuide_Buyer.MO.make, {
                                      query: query
                                    }))),
                        className: "dialog-content-base w-full max-w-[768px] min-h-screen"
                      })),
              open: _open
            });
}

var ContentsGuide = {
  Scroll: Scroll,
  ContentsGuideHeader: ContentsGuideHeader,
  make: PDP_Normal_Modals_Buyer$ContentsGuide
};

function PDP_Normal_Modals_Buyer$Unauthorized$PC(Props) {
  var show = Props.show;
  var closeFn = Props.closeFn;
  var router = Router.useRouter();
  var match;
  if (show) {
    var message = show._0;
    match = typeof message === "number" ? [
        /* Hide */1,
        ""
      ] : [
        /* Show */0,
        message._0
      ];
  } else {
    match = [
      /* Hide */1,
      ""
    ];
  }
  return React.createElement(ShopDialog_Buyer.make, {
              isShow: match[0],
              confirmText: "로그인",
              cancelText: "취소",
              onConfirm: (function (param) {
                  var redirect = Js_dict.get(router.query, "redirect");
                  var redirectUrl = redirect !== undefined ? new URLSearchParams(Js_dict.fromArray([[
                                  "redirect",
                                  redirect
                                ]])).toString() : new URLSearchParams(Js_dict.fromArray([[
                                  "redirect",
                                  router.asPath
                                ]])).toString();
                  router.push("/buyer/signin?" + redirectUrl + "");
                }),
              onCancel: (function (param) {
                  Curry._1(closeFn, undefined);
                }),
              children: React.createElement("div", {
                    className: "h-18 mt-8 px-8 py-6 flex flex-col items-center justify-center text-lg text-text-L1"
                  }, React.createElement("span", {
                        className: "text-center"
                      }, ReactNl2br(match[1])))
            });
}

var PC = {
  make: PDP_Normal_Modals_Buyer$Unauthorized$PC
};

function PDP_Normal_Modals_Buyer$Unauthorized$MO(Props) {
  var show = Props.show;
  var closeFn = Props.closeFn;
  var router = Router.useRouter();
  var match;
  if (show) {
    var message = show._0;
    match = typeof message === "number" ? [
        /* Hide */1,
        ""
      ] : [
        /* Show */0,
        message._0
      ];
  } else {
    match = [
      /* Hide */1,
      ""
    ];
  }
  return React.createElement(ShopDialog_Buyer.Mo.make, {
              isShow: match[0],
              confirmText: "로그인",
              cancelText: "취소",
              onConfirm: (function (param) {
                  var redirect = Js_dict.get(router.query, "redirect");
                  var redirectUrl = redirect !== undefined ? new URLSearchParams(Js_dict.fromArray([[
                                  "redirect",
                                  redirect
                                ]])).toString() : new URLSearchParams(Js_dict.fromArray([[
                                  "redirect",
                                  router.asPath
                                ]])).toString();
                  router.push("/buyer/signin?" + redirectUrl + "");
                }),
              onCancel: (function (param) {
                  Curry._1(closeFn, undefined);
                }),
              children: React.createElement("div", {
                    className: "h-18 mt-8 px-8 py-6 flex flex-col items-center justify-center text-lg text-text-L1"
                  }, React.createElement("span", {
                        className: "text-center"
                      }, ReactNl2br(match[1])))
            });
}

var MO = {
  make: PDP_Normal_Modals_Buyer$Unauthorized$MO
};

var Unauthorized = {
  PC: PC,
  MO: MO
};

function PDP_Normal_Modals_Buyer$Confirm$MO(Props) {
  var show = Props.show;
  var closeFn = Props.closeFn;
  var query = Props.query;
  var selectedOptions = Props.selectedOptions;
  var setSelectedOptions = Props.setSelectedOptions;
  var isShow = show ? show._0 === 1 : false;
  React.useEffect((function () {
          var match = Belt_MapString.toArray(selectedOptions);
          if (match.length !== 0) {
            
          } else {
            Curry._1(closeFn, undefined);
          }
        }), [selectedOptions]);
  return React.createElement(DS_BottomDrawer.Root.make, {
              isShow: isShow,
              onClose: closeFn,
              children: null
            }, React.createElement(DS_BottomDrawer.Header.make, {}), React.createElement(DS_BottomDrawer.Body.make, {
                  children: React.createElement("div", {
                        className: "pb-9"
                      }, React.createElement(React.Suspense, {
                            children: React.createElement(PDP_Normal_OrderSpecification_Buyer.make, {
                                  query: query,
                                  selectedOptions: selectedOptions,
                                  setSelectedOptions: setSelectedOptions,
                                  closeFn: closeFn
                                }),
                            fallback: React.createElement(PDP_Normal_OrderSpecification_Buyer.Placeholder.make, {})
                          }))
                }));
}

var MO$1 = {
  make: PDP_Normal_Modals_Buyer$Confirm$MO
};

function PDP_Normal_Modals_Buyer$Confirm$PC(Props) {
  var show = Props.show;
  var closeFn = Props.closeFn;
  var query = Props.query;
  var selectedOptions = Props.selectedOptions;
  var setSelectedOptions = Props.setSelectedOptions;
  var _open = show ? show._0 === 1 : false;
  React.useEffect((function () {
          var match = Belt_MapString.toArray(selectedOptions);
          if (match.length !== 0) {
            
          } else {
            Curry._1(closeFn, undefined);
          }
        }), [selectedOptions]);
  return React.createElement(ReactDialog.Root, {
              children: React.createElement(ReactDialog.Portal, {
                    children: null
                  }, React.createElement(ReactDialog.Overlay, {
                        className: "dialog-overlay"
                      }), React.createElement(ReactDialog.Content, {
                        children: React.createElement("div", undefined, React.createElement("section", {
                                  className: "w-full h-14 flex justify-end items-center px-4"
                                }, React.createElement("button", {
                                      onClick: (function (param) {
                                          Curry._1(closeFn, undefined);
                                        })
                                    }, React.createElement(DS_Icon.Common.CloseLarge2.make, {
                                          height: "24",
                                          width: "24"
                                        }))), React.createElement("section", {
                                  className: "mt-4"
                                }, React.createElement(React.Suspense, {
                                      children: React.createElement(PDP_Normal_OrderSpecification_Buyer.make, {
                                            query: query,
                                            selectedOptions: selectedOptions,
                                            setSelectedOptions: setSelectedOptions,
                                            closeFn: closeFn
                                          }),
                                      fallback: React.createElement(PDP_Normal_OrderSpecification_Buyer.Placeholder.make, {})
                                    }))),
                        className: "dialog-content-base bg-white rounded-xl w-[calc(100vw-40px)] max-w-[calc(768px-40px)]",
                        onPointerDownOutside: (function (param) {
                            Curry._1(closeFn, undefined);
                          }),
                        onOpenAutoFocus: (function (prim) {
                            prim.preventDefault();
                          })
                      })),
              open: _open
            });
}

var PC$1 = {
  make: PDP_Normal_Modals_Buyer$Confirm$PC
};

var Confirm = {
  MO: MO$1,
  PC: PC$1
};

function PDP_Normal_Modals_Buyer$NoOption$PC(Props) {
  var show = Props.show;
  var closeFn = Props.closeFn;
  var isShow = show && show._0 === 0 ? /* Show */0 : /* Hide */1;
  return React.createElement(ShopDialog_Buyer.make, {
              isShow: isShow,
              cancelText: "확인",
              onCancel: (function (param) {
                  Curry._1(closeFn, undefined);
                }),
              children: React.createElement("div", {
                    className: "h-18 mt-8 px-8 py-6 flex flex-col items-center justify-center text-lg text-text-L1"
                  }, React.createElement("span", undefined, "단품을 선택해 주세요."))
            });
}

var PC$2 = {
  make: PDP_Normal_Modals_Buyer$NoOption$PC
};

function PDP_Normal_Modals_Buyer$NoOption$MO(Props) {
  var show = Props.show;
  var closeFn = Props.closeFn;
  var isShow = show && show._0 === 0 ? /* Show */0 : /* Hide */1;
  return React.createElement(ShopDialog_Buyer.Mo.make, {
              isShow: isShow,
              cancelText: "확인",
              onCancel: (function (param) {
                  Curry._1(closeFn, undefined);
                }),
              children: React.createElement("div", {
                    className: "h-18 mt-8 px-8 py-6 flex flex-col items-center justify-center text-lg text-text-L1"
                  }, React.createElement("span", undefined, "단품을 선택해 주세요."))
            });
}

var MO$2 = {
  make: PDP_Normal_Modals_Buyer$NoOption$MO
};

var NoOption = {
  PC: PC$2,
  MO: MO$2
};

function PDP_Normal_Modals_Buyer$PC(Props) {
  var show = Props.show;
  var setShow = Props.setShow;
  var selectedOptions = Props.selectedOptions;
  var setSelectedOptions = Props.setSelectedOptions;
  var query = Props.query;
  var closeFn = function (param) {
    setShow(function (param) {
          return /* Hide */0;
        });
  };
  return React.createElement(React.Fragment, undefined, React.createElement(PDP_Normal_Modals_Buyer$Confirm$PC, {
                  show: show,
                  closeFn: closeFn,
                  query: query,
                  selectedOptions: selectedOptions,
                  setSelectedOptions: setSelectedOptions
                }), React.createElement(PDP_Normal_Modals_Buyer$Unauthorized$PC, {
                  show: show,
                  closeFn: closeFn
                }), React.createElement(PDP_Normal_Modals_Buyer$NoOption$PC, {
                  show: show,
                  closeFn: closeFn
                }));
}

var PC$3 = {
  make: PDP_Normal_Modals_Buyer$PC
};

function PDP_Normal_Modals_Buyer$MO(Props) {
  var show = Props.show;
  var setShow = Props.setShow;
  var selectedOptions = Props.selectedOptions;
  var setSelectedOptions = Props.setSelectedOptions;
  var query = Props.query;
  var closeFn = function (param) {
    setShow(function (param) {
          return /* Hide */0;
        });
  };
  return React.createElement(React.Fragment, undefined, React.createElement(PDP_Normal_Modals_Buyer$Confirm$MO, {
                  show: show,
                  closeFn: closeFn,
                  query: query,
                  selectedOptions: selectedOptions,
                  setSelectedOptions: setSelectedOptions
                }), React.createElement(PDP_Normal_Modals_Buyer$Unauthorized$MO, {
                  show: show,
                  closeFn: closeFn
                }), React.createElement(PDP_Normal_Modals_Buyer$NoOption$MO, {
                  show: show,
                  closeFn: closeFn
                }), React.createElement(PDP_Normal_Modals_Buyer$ContentsGuide, {
                  show: show,
                  closeFn: closeFn,
                  query: query
                }));
}

var MO$3 = {
  make: PDP_Normal_Modals_Buyer$MO
};

export {
  ContentsGuide ,
  Unauthorized ,
  Confirm ,
  NoOption ,
  PC$3 as PC,
  MO$3 as MO,
}
/* react Not a pure module */
