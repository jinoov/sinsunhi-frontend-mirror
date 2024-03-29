// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as Caml_option from "rescript/lib/es6/caml_option.js";

function make(str, option) {
  var id = {
    contents: null
  };
  id.contents = setInterval((function (param) {
          var makeExn = window.ChannelIO;
          if (!(makeExn == null)) {
            Belt_Option.forEach(Caml_option.nullable_to_opt(id.contents), (function (prim) {
                    clearInterval(prim);
                  }));
            return makeExn(str, option);
          }
          
        }), 200);
}

function makeWithCallback(str, option, cb) {
  var id = {
    contents: null
  };
  id.contents = setInterval((function (param) {
          var makeWithCallback = window.ChannelIO;
          if (!(makeWithCallback == null)) {
            Belt_Option.forEach(Caml_option.nullable_to_opt(id.contents), (function (prim) {
                    clearInterval(prim);
                  }));
            return makeWithCallback(str, option, cb);
          }
          
        }), 200);
}

function track(str1, str2, option) {
  var id = {
    contents: null
  };
  id.contents = setInterval((function (param) {
          var track = window.ChannelIO;
          if (!(track == null)) {
            Belt_Option.forEach(Caml_option.nullable_to_opt(id.contents), (function (prim) {
                    clearInterval(prim);
                  }));
            return track(str1, str2, option);
          }
          
        }), 200);
}

function $$do(action) {
  var id = {
    contents: null
  };
  id.contents = setInterval((function (param) {
          var $$do = window.ChannelIO;
          if (!($$do == null)) {
            Belt_Option.forEach(Caml_option.nullable_to_opt(id.contents), (function (prim) {
                    clearInterval(prim);
                  }));
            return $$do(action);
          }
          
        }), 200);
}

function shutdown(param) {
  $$do("shutdown");
}

function showMessenger(param) {
  $$do("showMessenger");
}

function showChannelButton(param) {
  $$do("showChannelButton");
}

function hideChannelButton(param) {
  $$do("hideChannelButton");
}

export {
  make ,
  makeWithCallback ,
  track ,
  $$do ,
  shutdown ,
  showMessenger ,
  showChannelButton ,
  hideChannelButton ,
}
/* No side effect */
