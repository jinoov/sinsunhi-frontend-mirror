// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Curry from "rescript/lib/es6/curry.js";
import * as React from "react";
import Head from "next/head";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as CustomHooks from "./CustomHooks.mjs";
import * as OpenGraph_Header from "../components/OpenGraph_Header.mjs";

function getFallback(fallback) {
  return Belt_Option.getWithDefault(fallback, React.createElement("div", undefined, "인증 확인 중 입니다."));
}

function Layout(UserHook) {
  var Authorization$Layout = function (Props) {
    var children = Props.children;
    var title = Props.title;
    var fallback = Props.fallback;
    var ssrFallbackOpt = Props.ssrFallback;
    var ssrFallback = ssrFallbackOpt !== undefined ? Caml_option.valFromOption(ssrFallbackOpt) : null;
    var user = Curry._1(UserHook.use, undefined);
    return React.createElement(React.Fragment, undefined, React.createElement(Head, {
                    children: React.createElement("title", undefined, "신선하이 " + Belt_Option.mapWithDefault(title, "", (function (t) {
                                return "| " + t + "";
                              })) + "")
                  }), React.createElement(OpenGraph_Header.make, {
                    title: "신선하이 " + Belt_Option.mapWithDefault(title, "", (function (t) {
                            return "| " + t + "";
                          })) + ""
                  }), typeof user === "number" ? (
                  user !== 0 ? getFallback(fallback) : ssrFallback
                ) : children);
  };
  return {
          make: Authorization$Layout
        };
}

var UserHook = CustomHooks.User.Admin;

function Authorization$Layout(Props) {
  var children = Props.children;
  var title = Props.title;
  var fallback = Props.fallback;
  var ssrFallbackOpt = Props.ssrFallback;
  var ssrFallback = ssrFallbackOpt !== undefined ? Caml_option.valFromOption(ssrFallbackOpt) : null;
  var user = Curry._1(UserHook.use, undefined);
  return React.createElement(React.Fragment, undefined, React.createElement(Head, {
                  children: React.createElement("title", undefined, "신선하이 " + Belt_Option.mapWithDefault(title, "", (function (t) {
                              return "| " + t + "";
                            })) + "")
                }), React.createElement(OpenGraph_Header.make, {
                  title: "신선하이 " + Belt_Option.mapWithDefault(title, "", (function (t) {
                          return "| " + t + "";
                        })) + ""
                }), typeof user === "number" ? (
                user !== 0 ? getFallback(fallback) : ssrFallback
              ) : children);
}

var Admin = {
  make: Authorization$Layout
};

var UserHook$1 = CustomHooks.User.Buyer;

function Authorization$Layout$1(Props) {
  var children = Props.children;
  var title = Props.title;
  var fallback = Props.fallback;
  var ssrFallbackOpt = Props.ssrFallback;
  var ssrFallback = ssrFallbackOpt !== undefined ? Caml_option.valFromOption(ssrFallbackOpt) : null;
  var user = Curry._1(UserHook$1.use, undefined);
  return React.createElement(React.Fragment, undefined, React.createElement(Head, {
                  children: React.createElement("title", undefined, "신선하이 " + Belt_Option.mapWithDefault(title, "", (function (t) {
                              return "| " + t + "";
                            })) + "")
                }), React.createElement(OpenGraph_Header.make, {
                  title: "신선하이 " + Belt_Option.mapWithDefault(title, "", (function (t) {
                          return "| " + t + "";
                        })) + ""
                }), typeof user === "number" ? (
                user !== 0 ? getFallback(fallback) : ssrFallback
              ) : children);
}

var Buyer = {
  make: Authorization$Layout$1
};

var UserHook$2 = CustomHooks.User.Seller;

function Authorization$Layout$2(Props) {
  var children = Props.children;
  var title = Props.title;
  var fallback = Props.fallback;
  var ssrFallbackOpt = Props.ssrFallback;
  var ssrFallback = ssrFallbackOpt !== undefined ? Caml_option.valFromOption(ssrFallbackOpt) : null;
  var user = Curry._1(UserHook$2.use, undefined);
  return React.createElement(React.Fragment, undefined, React.createElement(Head, {
                  children: React.createElement("title", undefined, "신선하이 " + Belt_Option.mapWithDefault(title, "", (function (t) {
                              return "| " + t + "";
                            })) + "")
                }), React.createElement(OpenGraph_Header.make, {
                  title: "신선하이 " + Belt_Option.mapWithDefault(title, "", (function (t) {
                          return "| " + t + "";
                        })) + ""
                }), typeof user === "number" ? (
                user !== 0 ? getFallback(fallback) : ssrFallback
              ) : children);
}

var Seller = {
  make: Authorization$Layout$2
};

export {
  getFallback ,
  Layout ,
  Admin ,
  Buyer ,
  Seller ,
}
/* react Not a pure module */
