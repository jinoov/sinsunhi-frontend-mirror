// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Curry from "rescript/lib/es6/curry.js";
import * as React from "react";

function format(second) {
  var doubleDigit = function (n) {
    if (n < 10) {
      return "0" + String(n) + "";
    } else {
      return String(n);
    }
  };
  var minuteAndSecond = function (second$p) {
    var min = second$p / 60 | 0;
    var sec = second$p - Math.imul(min, 60) | 0;
    return "" + String(min) + ":" + doubleDigit(sec) + "";
  };
  if (second < 0) {
    return "-" + minuteAndSecond(Math.abs(second)) + "";
  } else {
    return minuteAndSecond(Math.abs(second));
  }
}

function Timer(props) {
  var startTimeInSec = props.startTimeInSec;
  var onChangeStatus = props.onChangeStatus;
  var status = props.status;
  var match = React.useState(function () {
        return status;
      });
  var setStatus$p = match[1];
  var status$p = match[0];
  var match$1 = React.useState(function () {
        return startTimeInSec;
      });
  var setTime = match$1[1];
  var time = match$1[0];
  React.useEffect((function () {
          setStatus$p(function (param) {
                return status;
              });
        }), [status]);
  React.useEffect((function () {
          var id = setInterval((function (param) {
                  setTime(function (time) {
                        return time - 1 | 0;
                      });
                }), 1000);
          switch (status$p) {
            case /* Start */0 :
                setTime(function (param) {
                      return startTimeInSec;
                    });
                break;
            case /* Pause */1 :
                clearInterval(id);
                break;
            case /* Resume */2 :
                break;
            case /* Stop */3 :
                clearInterval(id);
                setTime(function (param) {
                      return startTimeInSec;
                    });
                break;
            
          }
          Curry._1(onChangeStatus, status$p);
          return (function (param) {
                    clearInterval(id);
                  });
        }), [status$p]);
  React.useEffect((function () {
          if (time <= 0) {
            setStatus$p(function (param) {
                  return /* Stop */3;
                });
          }
          
        }), [time]);
  return React.createElement("div", {
              className: props.className
            }, format(time));
}

var make = Timer;

export {
  format ,
  make ,
}
/* react Not a pure module */
