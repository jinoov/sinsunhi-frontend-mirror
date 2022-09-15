// Generated by ReScript, PLEASE EDIT WITH CARE

import * as React from "react";
import * as ReactUtil from "../../utils/ReactUtil.mjs";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import EmptyGraySquareLgXPng from "../../../public/images/empty-gray-square-lg-3x.png";
import EmptyGraySquareSmXPng from "../../../public/images/empty-gray-square-sm-3x.png";

var placeholderSm = EmptyGraySquareSmXPng;

var placeholderLg = EmptyGraySquareLgXPng;

function getSrc(t) {
  if (t) {
    return placeholderLg;
  } else {
    return placeholderSm;
  }
}

var Placeholder = {
  getSrc: getSrc
};

function encode(t) {
  if (t) {
    return "lazy";
  } else {
    return "eager";
  }
}

var Loading = {
  encode: encode
};

function Image$MakeImage(Props) {
  var srcOpt = Props.src;
  var placeholderOpt = Props.placeholder;
  var loadingOpt = Props.loading;
  var alt = Props.alt;
  var className = Props.className;
  var src = srcOpt !== undefined ? srcOpt : placeholderSm;
  var placeholder = placeholderOpt !== undefined ? placeholderOpt : /* Sm */0;
  var loading = loadingOpt !== undefined ? loadingOpt : /* Eager */0;
  var match = React.useState(function () {
        return src;
      });
  var setSource = match[1];
  var tmp = {
    src: match[0],
    onError: (function (param) {
        setSource(function (param) {
              if (placeholder) {
                return placeholderLg;
              } else {
                return placeholderSm;
              }
            });
      }),
    loading: loading ? "lazy" : "eager"
  };
  if (className !== undefined) {
    tmp.className = Caml_option.valFromOption(className);
  }
  if (alt !== undefined) {
    tmp.alt = Caml_option.valFromOption(alt);
  }
  var props = tmp;
  return React.createElement(ReactUtil.SpreadProps.make, {
              children: React.createElement("img", undefined),
              props: props
            });
}

var MakeImage = {
  defaultImage: placeholderSm,
  make: Image$MakeImage
};

function $$Image(Props) {
  var src = Props.src;
  var placeholder = Props.placeholder;
  var loading = Props.loading;
  var alt = Props.alt;
  var className = Props.className;
  var tmp = {};
  if (src !== undefined) {
    tmp.src = Caml_option.valFromOption(src);
  }
  if (placeholder !== undefined) {
    tmp.placeholder = Caml_option.valFromOption(placeholder);
  }
  if (loading !== undefined) {
    tmp.loading = Caml_option.valFromOption(loading);
  }
  if (alt !== undefined) {
    tmp.alt = Caml_option.valFromOption(alt);
  }
  if (className !== undefined) {
    tmp.className = Caml_option.valFromOption(className);
  }
  if (src !== undefined) {
    tmp.key = src;
  }
  return React.createElement(Image$MakeImage, tmp);
}

var make = $$Image;

export {
  placeholderSm ,
  placeholderLg ,
  Placeholder ,
  Loading ,
  MakeImage ,
  make ,
}
/* placeholderSm Not a pure module */