// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Spice from "@greenlabs/ppx-spice/src/rescript/Spice.mjs";
import * as Garter_Fn from "@greenlabs/garter/src/Garter_Fn.mjs";
import * as Belt_Result from "rescript/lib/es6/belt_Result.js";
import * as LocalStorage from "./LocalStorage.mjs";

function toString(value) {
  return value;
}

var PhoneNumberConfig = {
  key: "SS_PHONENUMBER",
  fromString: Garter_Fn.identity,
  toString: toString
};

function toString$1(value) {
  return value;
}

var BuyerEmailConfig = {
  key: "SS_BUYER_EMAIL",
  fromString: Garter_Fn.identity,
  toString: toString$1
};

var key = "SS_EMAIL_ADMIN";

function toString$2(value) {
  return value;
}

var EmailAdminConfig = {
  defaultValue: "",
  key: key,
  fromString: Garter_Fn.identity,
  toString: toString$2
};

function t_encode(v) {
  return Spice.arrayToJson(Spice.stringToJson, v);
}

function t_decode(v) {
  return Spice.arrayFromJson(Spice.stringFromJson, v);
}

var key$1 = "SS_ADMIN_MENU";

function fromString(str) {
  try {
    var v = JSON.parse(str);
    return Belt_Result.getExn(Spice.arrayFromJson(Spice.stringFromJson, v));
  }
  catch (exn){
    return [];
  }
}

function toString$3(arr) {
  return JSON.stringify(Spice.arrayToJson(Spice.stringToJson, arr));
}

var AdminMenuConfig = {
  t_encode: t_encode,
  t_decode: t_decode,
  key: key$1,
  fromString: fromString,
  toString: toString$3
};

function toString$4(value) {
  return value;
}

var AccessTokenConfig = {
  key: "SS_ACCESS_TOKEN",
  fromString: Garter_Fn.identity,
  toString: toString$4
};

function toString$5(value) {
  return value;
}

var RefreshTokenConfig = {
  key: "SS_REFRESH_TOKEN",
  fromString: Garter_Fn.identity,
  toString: toString$5
};

function toString$6(value) {
  return value;
}

var BuyerInfoConfig = {
  key: "SS_BUYER_INFO_LAST_SHOWN",
  fromString: Garter_Fn.identity,
  toString: toString$6
};

function t_encode$1(v) {
  return Spice.dictToJson(Spice.stringToJson, v);
}

function t_decode$1(v) {
  return Spice.dictFromJson(Spice.stringFromJson, v);
}

var key$2 = "SS_RECENT_SEARCH_KEYWORD";

function fromString$1(str) {
  try {
    var v = JSON.parse(str);
    return Belt_Result.getExn(Spice.dictFromJson(Spice.stringFromJson, v));
  }
  catch (exn){
    return {};
  }
}

function toString$7(value) {
  return JSON.stringify(Spice.dictToJson(Spice.stringToJson, value));
}

var RecentSearchKeywordConfig = {
  t_encode: t_encode$1,
  t_decode: t_decode$1,
  key: key$2,
  fromString: fromString$1,
  toString: toString$7
};

var PhoneNumber = LocalStorage.Make(PhoneNumberConfig);

var BuyerEmail = LocalStorage.Make(BuyerEmailConfig);

var EmailAdmin = LocalStorage.Make({
      key: key,
      fromString: Garter_Fn.identity,
      toString: toString$2
    });

var AdminMenu = LocalStorage.Make({
      key: key$1,
      fromString: fromString,
      toString: toString$3
    });

var AccessToken = LocalStorage.Make(AccessTokenConfig);

var RefreshToken = LocalStorage.Make(RefreshTokenConfig);

var BuyerInfoLastShown = LocalStorage.Make(BuyerInfoConfig);

var RecentSearchKeyword = LocalStorage.Make({
      key: key$2,
      fromString: fromString$1,
      toString: toString$7
    });

export {
  PhoneNumberConfig ,
  BuyerEmailConfig ,
  EmailAdminConfig ,
  AdminMenuConfig ,
  AccessTokenConfig ,
  RefreshTokenConfig ,
  BuyerInfoConfig ,
  RecentSearchKeywordConfig ,
  PhoneNumber ,
  BuyerEmail ,
  EmailAdmin ,
  AdminMenu ,
  AccessToken ,
  RefreshToken ,
  BuyerInfoLastShown ,
  RecentSearchKeyword ,
}
/* PhoneNumber Not a pure module */
