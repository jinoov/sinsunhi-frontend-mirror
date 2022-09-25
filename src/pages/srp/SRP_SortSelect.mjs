// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Cn from "rescript-classnames/src/Cn.mjs";
import * as React from "react";
import * as Js_dict from "rescript/lib/es6/js_dict.js";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as ReactEvents from "../../utils/ReactEvents.mjs";
import * as Router from "next/router";
import * as PLP_FilterOption from "../buyer/plp/PLP_FilterOption.mjs";
import * as ReactDropdownMenu from "@radix-ui/react-dropdown-menu";
import ArrowGray800UpDownSvg from "../../../public/assets/arrow-gray800-up-down.svg";

var arrowUpDownIcon = ArrowGray800UpDownSvg;

function SRP_SortSelect$PC(props) {
  var router = Router.useRouter();
  var sectionType = PLP_FilterOption.Section.make(Js_dict.get(router.query, "section"));
  var label = PLP_FilterOption.Sort.makeSortLabel(Belt_Option.getWithDefault(Belt_Option.map(Js_dict.get(router.query, "sort"), (function (param) {
                  return PLP_FilterOption.Sort.decodeSort(sectionType, param);
                })), "UPDATED_DESC"));
  var priceOption = sectionType === "MATCHING" ? "PRICE_PER_KG_ASC" : "PRICE_ASC";
  var itemWidth = sectionType === "MATCHING" ? "w-[140px]" : "w-[120px]";
  var match = React.useState(function () {
        return false;
      });
  var setOpen = match[1];
  var makeOnSelect = function (sort) {
    return function (param) {
      return ReactEvents.interceptingHandler((function (param) {
                    setOpen(function (param) {
                          return false;
                        });
                    var newQuery = router.query;
                    newQuery["sort"] = PLP_FilterOption.Sort.encodeSort(sort);
                    router.replace({
                          pathname: router.pathname,
                          query: newQuery
                        });
                  }), param);
    };
  };
  return React.createElement("div", {
              className: "flex items-center"
            }, React.createElement("span", {
                  className: "text-gray-600 text-sm"
                }, "정렬기준: "), React.createElement(ReactDropdownMenu.Root, {
                  children: null,
                  _open: match[0],
                  onOpenChange: (function (to_) {
                      setOpen(function (param) {
                            return to_;
                          });
                    })
                }, React.createElement(ReactDropdownMenu.Trigger, {
                      children: React.createElement("div", {
                            className: "ml-2 flex items-center justify-center"
                          }, React.createElement("span", {
                                className: "text-sm mr-1 text-gray-800"
                              }, label), React.createElement("img", {
                                src: arrowUpDownIcon
                              })),
                      className: "focus:outline-none"
                    }), React.createElement(ReactDropdownMenu.Content, {
                      children: null,
                      align: "start",
                      className: "dropdown-content bg-white shadow-lg p-1 border border-[#cccccc] rounded-lg cursor-pointer"
                    }, React.createElement(ReactDropdownMenu.Item, {
                          children: Caml_option.some(PLP_FilterOption.Sort.makeSortLabel("UPDATED_DESC")),
                          className: Cn.make([
                                itemWidth,
                                "p-2 focus:outline-none text-gray-800 hover:bg-gray-100 rounded-lg"
                              ]),
                          onSelect: makeOnSelect("UPDATED_DESC")
                        }), React.createElement(ReactDropdownMenu.Item, {
                          children: Caml_option.some(PLP_FilterOption.Sort.makeSortLabel(priceOption)),
                          className: Cn.make([
                                itemWidth,
                                " p-2 focus:outline-none text-gray-800 hover:bg-gray-100 rounded-lg"
                              ]),
                          onSelect: makeOnSelect(priceOption)
                        }))));
}

var PC = {
  make: SRP_SortSelect$PC
};

function SRP_SortSelect$MO(props) {
  var router = Router.useRouter();
  var sectionType = PLP_FilterOption.Section.make(Js_dict.get(router.query, "section"));
  var label = PLP_FilterOption.Sort.makeSortLabel(Belt_Option.getWithDefault(Belt_Option.map(Js_dict.get(router.query, "sort"), (function (param) {
                  return PLP_FilterOption.Sort.decodeSort(sectionType, param);
                })), "UPDATED_DESC"));
  var match = React.useState(function () {
        return false;
      });
  var setOpen = match[1];
  var priceOption = sectionType === "MATCHING" ? "PRICE_PER_KG_ASC" : "PRICE_ASC";
  var itemWidth = sectionType === "MATCHING" ? "w-[140px]" : "w-[120px]";
  var makeOnSelect = function (sort) {
    return function (param) {
      return ReactEvents.interceptingHandler((function (param) {
                    setOpen(function (param) {
                          return false;
                        });
                    var newQuery = router.query;
                    newQuery["sort"] = PLP_FilterOption.Sort.encodeSort(sort);
                    router.replace({
                          pathname: router.pathname,
                          query: newQuery
                        });
                  }), param);
    };
  };
  return React.createElement("div", {
              className: "flex items-center"
            }, React.createElement(ReactDropdownMenu.Root, {
                  children: null,
                  _open: match[0],
                  onOpenChange: (function (to_) {
                      setOpen(function (param) {
                            return to_;
                          });
                    })
                }, React.createElement(ReactDropdownMenu.Trigger, {
                      children: React.createElement("div", {
                            className: "ml-2 flex items-center justify-center"
                          }, React.createElement("span", {
                                className: "text-sm mr-1 text-gray-800"
                              }, label), React.createElement("img", {
                                src: arrowUpDownIcon
                              })),
                      className: "focus:outline-none"
                    }), React.createElement(ReactDropdownMenu.Content, {
                      children: null,
                      align: "start",
                      className: "dropdown-content bg-white shadow-lg p-1 border border-[#cccccc] rounded-lg cursor-pointer"
                    }, React.createElement(ReactDropdownMenu.Item, {
                          children: Caml_option.some(PLP_FilterOption.Sort.makeSortLabel("UPDATED_DESC")),
                          className: Cn.make([
                                itemWidth,
                                "p-2 focus:outline-none text-gray-800 hover:bg-gray-100 rounded-lg"
                              ]),
                          onSelect: makeOnSelect("UPDATED_DESC")
                        }), React.createElement(ReactDropdownMenu.Item, {
                          children: Caml_option.some(PLP_FilterOption.Sort.makeSortLabel(priceOption)),
                          className: Cn.make([
                                itemWidth,
                                "p-2 focus:outline-none text-gray-800 hover:bg-gray-100 rounded-lg"
                              ]),
                          onSelect: makeOnSelect(priceOption)
                        }))));
}

var MO = {
  make: SRP_SortSelect$MO
};

export {
  arrowUpDownIcon ,
  PC ,
  MO ,
}
/* arrowUpDownIcon Not a pure module */
