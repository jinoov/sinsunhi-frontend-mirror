// Generated by ReScript, PLEASE EDIT WITH CARE

import * as React from "react";
import * as Search_Producers_Admin from "./Search_Producers_Admin.mjs";
import * as Status_BulkSale_Producer from "./common/Status_BulkSale_Producer.mjs";

function Summary_BulkSale_Producers_Admin$Skeleton(Props) {
  return React.createElement("div", {
              className: "py-3 px-7 mt-4 mx-4 shadow-gl bg-white rounded"
            }, React.createElement("ol", {
                  className: "grid grid-cols-2 sm:grid-cols-4 lg:grid-cols-7 lg:justify-between lg:w-full lg:py-3"
                }, React.createElement(Status_BulkSale_Producer.Total.Skeleton.make, {}), React.createElement(Status_BulkSale_Producer.Item.Skeleton.make, {
                      kind: /* APPLIED */0
                    }), React.createElement(Status_BulkSale_Producer.Item.Skeleton.make, {
                      kind: /* UNDER_DISCUSSION */1
                    }), React.createElement(Status_BulkSale_Producer.Item.Skeleton.make, {
                      kind: /* ON_SITE_MEETING_SCHEDULED */2
                    }), React.createElement(Status_BulkSale_Producer.Item.Skeleton.make, {
                      kind: /* SAMPLE_REQUESTED */3
                    }), React.createElement(Status_BulkSale_Producer.Item.Skeleton.make, {
                      kind: /* SAMPLE_REVIEWING */4
                    }), React.createElement(Status_BulkSale_Producer.Item.Skeleton.make, {
                      kind: /* REJECTED */5
                    }), React.createElement(Status_BulkSale_Producer.Item.Skeleton.make, {
                      kind: /* CONFIRMED */6
                    }), React.createElement(Status_BulkSale_Producer.Item.Skeleton.make, {
                      kind: /* WITHDRAWN */7
                    })));
}

var Skeleton = {
  make: Summary_BulkSale_Producers_Admin$Skeleton
};

function Summary_BulkSale_Producers_Admin$StatusFilter(Props) {
  var data = Props.data;
  return React.createElement("ol", {
              className: "grid grid-cols-2 sm:grid-cols-4 lg:grid-cols-7 lg:justify-between lg:w-full lg:py-3"
            }, React.createElement(Status_BulkSale_Producer.Total.make, {
                  data: data
                }), React.createElement(Status_BulkSale_Producer.Item.make, {
                  kind: /* APPLIED */0,
                  data: data
                }), React.createElement(Status_BulkSale_Producer.Item.make, {
                  kind: /* UNDER_DISCUSSION */1,
                  data: data
                }), React.createElement(Status_BulkSale_Producer.Item.make, {
                  kind: /* ON_SITE_MEETING_SCHEDULED */2,
                  data: data
                }), React.createElement(Status_BulkSale_Producer.Item.make, {
                  kind: /* SAMPLE_REQUESTED */3,
                  data: data
                }), React.createElement(Status_BulkSale_Producer.Item.make, {
                  kind: /* SAMPLE_REVIEWING */4,
                  data: data
                }), React.createElement(Status_BulkSale_Producer.Item.make, {
                  kind: /* REJECTED */5,
                  data: data
                }), React.createElement(Status_BulkSale_Producer.Item.make, {
                  kind: /* CONFIRMED */6,
                  data: data
                }), React.createElement(Status_BulkSale_Producer.Item.make, {
                  kind: /* WITHDRAWN */7,
                  data: data
                }));
}

var StatusFilter = {
  make: Summary_BulkSale_Producers_Admin$StatusFilter
};

function Summary_BulkSale_Producers_Admin(Props) {
  var summary = Props.summary;
  return React.createElement("div", {
              className: "py-3 px-7 mt-4 mx-4 bg-white rounded"
            }, React.createElement(Summary_BulkSale_Producers_Admin$StatusFilter, {
                  data: summary
                }), React.createElement(Search_Producers_Admin.make, {}));
}

var make = Summary_BulkSale_Producers_Admin;

export {
  Skeleton ,
  StatusFilter ,
  make ,
}
/* react Not a pure module */
