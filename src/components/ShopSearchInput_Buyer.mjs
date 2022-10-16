// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Cx from "rescript-classnames/src/Cx.mjs";
import * as React from "react";
import * as Js_dict from "rescript/lib/es6/js_dict.js";
import * as IconSearch from "./svgs/IconSearch.mjs";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as ReactEvents from "../utils/ReactEvents.mjs";
import * as Router from "next/router";

function ShopSearchInput_Buyer(Props) {
  var router = Router.useRouter();
  var match = React.useState(function () {
        return "";
      });
  var setKeyword = match[1];
  var keyword = match[0];
  var match$1 = React.useState(function () {
        return false;
      });
  var setEditing = match$1[1];
  var $$default = "w-full h-full border-2 border-green-500 rounded-full px-4 remove-spin-button focus:outline-none focus:border-green-500 focus:ring-opacity-100 text-base";
  var inputStyle = match$1[0] ? Cx.cx([
          $$default,
          "text-green-500"
        ]) : $$default;
  var onChangeKeyword = function (e) {
    setKeyword(function (param) {
          return e.target.value;
        });
  };
  var submit = function (param) {
    return ReactEvents.interceptingHandler((function (param) {
                  if (keyword === "") {
                    return ;
                  }
                  var prim1_query = Js_dict.fromArray([[
                          "keyword",
                          encodeURIComponent(keyword)
                        ]]);
                  var prim1 = {
                    pathname: "/search",
                    query: prim1_query
                  };
                  router.push(prim1);
                }), param);
  };
  React.useEffect((function () {
          if (router.pathname === "/search") {
            Belt_Option.map(Belt_Option.map(Js_dict.get(router.query, "keyword"), (function (prim) {
                        return decodeURIComponent(prim);
                      })), (function (keyword$p) {
                    setKeyword(function (param) {
                          return keyword$p;
                        });
                  }));
          } else {
            setKeyword(function (param) {
                  return "";
                });
          }
        }), [router]);
  return React.createElement("form", {
              onSubmit: submit
            }, React.createElement("div", {
                  className: "flex min-w-[658px] h-13 justify-center relative"
                }, React.createElement("input", {
                      className: inputStyle,
                      name: "shop-search",
                      placeholder: "찾고있는 작물을 검색해보세요",
                      type: "text",
                      value: keyword,
                      onFocus: (function (param) {
                          setEditing(function (param) {
                                return true;
                              });
                        }),
                      onBlur: (function (param) {
                          setEditing(function (param) {
                                return false;
                              });
                        }),
                      onChange: onChangeKeyword
                    }), React.createElement("button", {
                      className: "absolute right-0 h-[52px] bg-green-500 rounded-full focus:outline-none flex items-center justify-center px-6",
                      type: "submit"
                    }, React.createElement(IconSearch.make, {
                          width: "24",
                          height: "24",
                          fill: "#fff"
                        }), React.createElement("span", {
                          className: "text-white font-bold"
                        }, "검색"))));
}

function ShopSearchInput_Buyer$MO(Props) {
  var router = Router.useRouter();
  var match = React.useState(function () {
        return "";
      });
  var setKeyword = match[1];
  var keyword = match[0];
  var match$1 = React.useState(function () {
        return false;
      });
  var setEditing = match$1[1];
  var $$default = "w-full h-10 border border-green-500 rounded-full px-4 remove-spin-button focus:outline-none focus:border-green-500 focus:ring-opacity-100 text-[15px]";
  var inputStyle = match$1[0] ? Cx.cx([
          $$default,
          "text-green-500"
        ]) : $$default;
  var onChangeKeyword = function (e) {
    setKeyword(function (param) {
          return e.target.value;
        });
  };
  var submit = function (param) {
    return ReactEvents.interceptingHandler((function (param) {
                  if (keyword === "") {
                    return ;
                  }
                  var prim1_query = Js_dict.fromArray([[
                          "keyword",
                          encodeURIComponent(keyword)
                        ]]);
                  var prim1 = {
                    pathname: "/search",
                    query: prim1_query
                  };
                  router.push(prim1);
                }), param);
  };
  React.useEffect((function () {
          if (router.pathname === "/search") {
            Belt_Option.map(Belt_Option.map(Js_dict.get(router.query, "keyword"), (function (prim) {
                        return decodeURIComponent(prim);
                      })), (function (keyword$p) {
                    setKeyword(function (param) {
                          return keyword$p;
                        });
                  }));
          } else {
            setKeyword(function (param) {
                  return "";
                });
          }
        }), [router]);
  var tmp = keyword === "" ? null : React.createElement("img", {
          className: "absolute w-6 h-6 right-10 top-1/2 translate-y-[-50%]",
          src: "/icons/reset-input-gray-circle@3x.png",
          onClick: (function (param) {
              return ReactEvents.interceptingHandler((function (param) {
                            setKeyword(function (param) {
                                  return "";
                                });
                          }), param);
            })
        });
  return React.createElement("form", {
              className: "w-full",
              onSubmit: submit
            }, React.createElement("div", {
                  className: "relative w-full"
                }, React.createElement("input", {
                      className: inputStyle,
                      name: "shop-search",
                      placeholder: "찾고있는 작물을 검색해보세요",
                      type: "text",
                      value: keyword,
                      onFocus: (function (param) {
                          setEditing(function (param) {
                                return true;
                              });
                        }),
                      onBlur: (function (param) {
                          setEditing(function (param) {
                                return false;
                              });
                        }),
                      onChange: onChangeKeyword
                    }), tmp, React.createElement("button", {
                      className: "absolute right-3 top-1/2 translate-y-[-50%]",
                      type: "submit"
                    }, React.createElement(IconSearch.make, {
                          width: "24",
                          height: "24",
                          fill: "#12B564"
                        }))));
}

var MO = {
  make: ShopSearchInput_Buyer$MO
};

var make = ShopSearchInput_Buyer;

export {
  make ,
  MO ,
}
/* react Not a pure module */
