// Generated by ReScript, PLEASE EDIT WITH CARE

import * as React from "react";
import * as Divider from "../../../components/common/Divider.mjs";
import Head from "next/head";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as ChannelTalkHelper from "../../../utils/ChannelTalkHelper.mjs";
import * as SectionMain_PC_Title from "./SectionMain_PC_Title.mjs";
import * as Matching_Main_Category from "./Matching_Main_Category.mjs";
import * as Matching_Main_InfoBanner from "./Matching_Main_InfoBanner.mjs";
import * as Matching_Main_AllProducts from "./Matching_Main_AllProducts.mjs";
import * as RescriptReactErrorBoundary from "@rescript/react/src/RescriptReactErrorBoundary.mjs";

function SectionMain_Matching$PC$View(props) {
  return React.createElement(React.Fragment, undefined, React.createElement(SectionMain_PC_Title.make, {
                  title: "신선매칭"
                }), React.createElement(Matching_Main_InfoBanner.PC.make, {}), React.createElement(Matching_Main_Category.PC.make, {}), React.createElement(Matching_Main_AllProducts.PC.make, {}));
}

var View = {
  make: SectionMain_Matching$PC$View
};

function SectionMain_Matching$PC$Skeleton(props) {
  return React.createElement(React.Fragment, undefined, React.createElement(SectionMain_PC_Title.Skeleton.make, {}), React.createElement(Matching_Main_InfoBanner.PC.Skeleton.make, {}), React.createElement(Matching_Main_Category.PC.Skeleton.make, {}), React.createElement(Matching_Main_AllProducts.PC.Skeleton.make, {}));
}

var Skeleton = {
  make: SectionMain_Matching$PC$Skeleton
};

function SectionMain_Matching$PC(props) {
  return React.createElement(SectionMain_Matching$PC$View, {});
}

var PC = {
  View: View,
  Skeleton: Skeleton,
  make: SectionMain_Matching$PC
};

function SectionMain_Matching$MO$View(props) {
  return React.createElement(React.Fragment, undefined, React.createElement(Matching_Main_InfoBanner.MO.make, {}), React.createElement(Matching_Main_Category.MO.make, {}), React.createElement(Divider.make, {}), React.createElement(Matching_Main_AllProducts.MO.make, {}));
}

var View$1 = {
  make: SectionMain_Matching$MO$View
};

function SectionMain_Matching$MO$Skeleton(props) {
  return React.createElement(React.Fragment, undefined, React.createElement(Matching_Main_InfoBanner.MO.Skeleton.make, {}), React.createElement(Matching_Main_Category.MO.Skeleton.make, {}), React.createElement(Divider.make, {}), React.createElement(Matching_Main_Category.MO.Skeleton.make, {}), React.createElement(Matching_Main_AllProducts.MO.Skeleton.make, {}));
}

var Skeleton$1 = {
  make: SectionMain_Matching$MO$Skeleton
};

function SectionMain_Matching$MO(props) {
  return React.createElement(SectionMain_Matching$MO$View, {});
}

var MO = {
  View: View$1,
  Skeleton: Skeleton$1,
  make: SectionMain_Matching$MO
};

function SectionMain_Matching$Skeleton(props) {
  switch (props.deviceType) {
    case /* Unknown */0 :
        return null;
    case /* PC */1 :
        return React.createElement(SectionMain_Matching$PC$Skeleton, {});
    case /* Mobile */2 :
        return React.createElement(SectionMain_Matching$MO$Skeleton, {});
    
  }
}

var Skeleton$2 = {
  make: SectionMain_Matching$Skeleton
};

function SectionMain_Matching$Container(props) {
  ChannelTalkHelper.Hook.use(undefined, undefined, undefined);
  switch (props.deviceType) {
    case /* Unknown */0 :
        return null;
    case /* PC */1 :
        return React.createElement(SectionMain_Matching$PC, {});
    case /* Mobile */2 :
        return React.createElement(SectionMain_Matching$MO, {});
    
  }
}

var Container = {
  make: SectionMain_Matching$Container
};

function SectionMain_Matching(props) {
  var deviceType = props.deviceType;
  var match = React.useState(function () {
        return false;
      });
  var setIsCsr = match[1];
  React.useEffect((function () {
          setIsCsr(function (param) {
                return true;
              });
        }), []);
  return React.createElement(React.Fragment, undefined, React.createElement(Head, {
                  children: React.createElement("title", undefined, "신선하이 신선매칭")
                }), React.createElement(RescriptReactErrorBoundary.make, {
                  children: React.createElement(React.Suspense, {
                        children: Caml_option.some(match[0] ? React.createElement(SectionMain_Matching$Container, {
                                    deviceType: deviceType
                                  }) : React.createElement(SectionMain_Matching$Skeleton, {
                                    deviceType: deviceType
                                  })),
                        fallback: Caml_option.some(React.createElement(SectionMain_Matching$Skeleton, {
                                  deviceType: deviceType
                                }))
                      }),
                  fallback: (function (param) {
                      return React.createElement(SectionMain_Matching$Skeleton, {
                                  deviceType: deviceType
                                });
                    })
                }));
}

var make = SectionMain_Matching;

export {
  PC ,
  MO ,
  Skeleton$2 as Skeleton,
  Container ,
  make ,
}
/* react Not a pure module */
