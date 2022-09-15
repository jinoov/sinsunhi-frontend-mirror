// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Locale from "./Locale.mjs";
import * as Belt_List from "rescript/lib/es6/belt_List.js";
import * as Belt_Array from "rescript/lib/es6/belt_Array.js";
import * as Pervasives from "rescript/lib/es6/pervasives.js";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import Format from "date-fns/format";
import ParseISO from "date-fns/parseISO";

function decode(s) {
  switch (s) {
    case "MatchingProduct" :
        return /* Matching */3;
    case "NormalProduct" :
        return /* Normal */0;
    case "QuotableProduct" :
        return /* Quotable */1;
    case "QuotedProduct" :
        return /* Quoted */2;
    default:
      return ;
  }
}

function encode(t) {
  switch (t) {
    case /* Normal */0 :
        return "NormalProduct";
    case /* Quotable */1 :
        return "QuotableProduct";
    case /* Quoted */2 :
        return "QuotedProduct";
    case /* Matching */3 :
        return "MatchingProduct";
    
  }
}

var Type = {
  decode: decode,
  encode: encode
};

function make(dealingDate, higher, mean, lower) {
  return {
          dealingDate: dealingDate,
          higher: higher,
          mean: mean,
          lower: lower
        };
}

var MarketPrice = {
  make: make
};

function isEmpty(raw) {
  return Belt_Array.every(raw, (function (param) {
                if (Belt_Option.isNone(param.higher) && Belt_Option.isNone(param.mean)) {
                  return Belt_Option.isNone(param.lower);
                } else {
                  return false;
                }
              }));
}

function make$1(marketPrices, representativeWeight) {
  if (isEmpty(marketPrices)) {
    return ;
  }
  var match = Belt_Array.reduce(marketPrices, [
        /* [] */0,
        /* [] */0,
        /* [] */0,
        /* [] */0
      ], (function (prev, curr) {
          var multiply = function (f, i) {
            return Locale.Float.round0(i * f);
          };
          return [
                  {
                    hd: Format(ParseISO(curr.dealingDate), "M.dd"),
                    tl: prev[0]
                  },
                  {
                    hd: Belt_Option.map(curr.higher, (function (param) {
                            return multiply(representativeWeight, param);
                          })),
                    tl: prev[1]
                  },
                  {
                    hd: Belt_Option.map(curr.mean, (function (param) {
                            return multiply(representativeWeight, param);
                          })),
                    tl: prev[2]
                  },
                  {
                    hd: Belt_Option.map(curr.lower, (function (param) {
                            return multiply(representativeWeight, param);
                          })),
                    tl: prev[3]
                  }
                ];
        }));
  return {
          dates: Belt_List.toArray(Belt_List.reverse(match[0])),
          highers: Belt_List.toArray(Belt_List.reverse(match[1])),
          means: Belt_List.toArray(Belt_List.reverse(match[2])),
          lowers: Belt_List.toArray(Belt_List.reverse(match[3]))
        };
}

var Payload = {
  isEmpty: isEmpty,
  make: make$1
};

function make$2(high, medium, low) {
  return {
          high: high,
          medium: medium,
          low: low
        };
}

var Group = {
  make: make$2
};

function make$3(chartData) {
  return {
          tooltip: {
            trigger: "axis",
            backgroundColor: "rgba(38,38,38,1)",
            textStyle: {
              color: "rgba(255, 255, 255, 1)"
            }
          },
          grid: {
            right: "16px",
            left: "50px"
          },
          xAxis: {
            boundaryGap: false,
            data: chartData.dates,
            axisTick: {
              show: false
            },
            axisPointer: {
              show: true
            }
          },
          yAxis: {
            type: "value"
          },
          series: [
            {
              type: "line",
              name: "",
              data: chartData.highers,
              connectNulls: true,
              itemStyle: {
                color: "#ff5735"
              },
              lineStyle: {
                color: "#ff5735"
              }
            },
            {
              type: "line",
              name: "",
              data: chartData.means,
              connectNulls: true,
              itemStyle: {
                color: "#12b564"
              },
              lineStyle: {
                color: "#12b564"
              }
            },
            {
              type: "line",
              name: "",
              data: chartData.lowers,
              connectNulls: true,
              itemStyle: {
                color: "#2751c4"
              },
              lineStyle: {
                color: "#2751c4"
              }
            }
          ]
        };
}

var Graph = {
  make: make$3
};

function reduce(arr, init, fn) {
  return Belt_Array.reduce(Belt_Array.keepMap(arr, (function (x) {
                    return x;
                  })), init, fn);
}

function getMax(arr) {
  return reduce(arr, Pervasives.min_float, (function (prim0, prim1) {
                if (prim0 > prim1) {
                  return prim0;
                } else {
                  return prim1;
                }
              }));
}

function getMin(arr) {
  return reduce(arr, Pervasives.max_float, (function (prim0, prim1) {
                if (prim0 < prim1) {
                  return prim0;
                } else {
                  return prim1;
                }
              }));
}

function make$4(param) {
  var lowers = param.lowers;
  var means = param.means;
  var highers = param.highers;
  return {
          higherMax: getMax(highers),
          higherMin: getMin(highers),
          meanMax: getMax(means),
          meanMin: getMin(means),
          lowerMax: getMax(lowers),
          lowerMin: getMin(lowers)
        };
}

var Table = {
  reduce: reduce,
  getMax: getMax,
  getMin: getMin,
  make: make$4
};

var Chart = {
  Payload: Payload,
  Group: Group,
  Graph: Graph,
  Table: Table
};

var Matching = {
  MarketPrice: MarketPrice,
  Chart: Chart
};

export {
  Type ,
  Matching ,
}
/* Locale Not a pure module */
