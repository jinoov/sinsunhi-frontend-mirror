// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as Caml_option from "rescript/lib/es6/caml_option.js";

var $$window = typeof window === "undefined" ? undefined : window;

function signUp(userId) {
  var webView = window.ReactNativeWebView;
  if (!(webView == null)) {
    return Belt_Option.forEach(JSON.stringify({
                    type: "SIGN_UP",
                    userId: userId
                  }), (function (payload) {
                  webView.postMessage(payload);
                }));
  }
  
}

function signIn(userId) {
  var webView = window.ReactNativeWebView;
  if (!(webView == null)) {
    return Belt_Option.forEach(JSON.stringify({
                    type: "SIGN_IN",
                    userId: userId
                  }), (function (payload) {
                  webView.postMessage(payload);
                }));
  }
  
}

function airbridgeWithPayload(kind, payload, param) {
  var webView = window.ReactNativeWebView;
  if (!(webView == null)) {
    return Belt_Option.forEach(JSON.stringify({
                    type: kind,
                    payload: payload
                  }), (function (payload) {
                  webView.postMessage(payload);
                }));
  }
  
}

var PostMessage = {
  signUp: signUp,
  signIn: signIn,
  airbridgeWithPayload: airbridgeWithPayload
};

var ReactNativeWebView = {
  PostMessage: PostMessage
};

var $$Window = {
  ReactNativeWebView: ReactNativeWebView
};

var $$window$2 = $$window === undefined ? undefined : Caml_option.some($$window);

export {
  $$window$2 as $$window,
  $$Window ,
}
/* window Not a pure module */
