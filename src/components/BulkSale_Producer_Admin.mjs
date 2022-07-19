// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Curry from "rescript/lib/es6/curry.js";
import * as React from "react";
import * as Helper from "../utils/Helper.mjs";
import * as Locale from "../utils/Locale.mjs";
import * as Checkbox from "./common/Checkbox.mjs";
import * as Skeleton from "./Skeleton.mjs";
import * as Belt_List from "rescript/lib/es6/belt_List.js";
import * as Belt_Array from "rescript/lib/es6/belt_Array.js";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as Garter_Array from "@greenlabs/garter/src/Garter_Array.mjs";
import * as RescriptRelay from "rescript-relay/src/RescriptRelay.mjs";
import Format from "date-fns/format";
import * as Js_null_undefined from "rescript/lib/es6/js_null_undefined.js";
import * as Hooks from "react-relay/hooks";
import ReactImagesViewer from "react-images-viewer";
import * as RescriptRelay_Internal from "rescript-relay/src/RescriptRelay_Internal.mjs";
import * as Select_BulkSale_Search from "./Select_BulkSale_Search.mjs";
import * as Select_BulkSale_Application_Status from "./Select_BulkSale_Application_Status.mjs";
import * as BulkSale_Producer_MarketSales_Admin from "./BulkSale_Producer_MarketSales_Admin.mjs";
import * as BulkSale_Producer_Memo_Update_Button from "./BulkSale_Producer_Memo_Update_Button.mjs";
import * as BulkSaleProducerAdminRefetchQuery_graphql from "../__generated__/BulkSaleProducerAdminRefetchQuery_graphql.mjs";
import * as BulkSale_Producer_Sample_Review_Button_Admin from "./BulkSale_Producer_Sample_Review_Button_Admin.mjs";
import * as BulkSaleProducerAdminFragment_bulkSaleApplication_graphql from "../__generated__/BulkSaleProducerAdminFragment_bulkSaleApplication_graphql.mjs";

function internal_makeRefetchableFnOpts(fetchPolicy, onComplete, param) {
  var tmp = {};
  var tmp$1 = RescriptRelay.mapFetchPolicy(fetchPolicy);
  if (tmp$1 !== undefined) {
    tmp.fetchPolicy = Caml_option.valFromOption(tmp$1);
  }
  var tmp$2 = RescriptRelay_Internal.internal_nullableToOptionalExnHandler(onComplete);
  if (tmp$2 !== undefined) {
    tmp.onComplete = Caml_option.valFromOption(tmp$2);
  }
  return tmp;
}

function useRefetchable(fRef) {
  var match = Hooks.useRefetchableFragment(BulkSaleProducerAdminFragment_bulkSaleApplication_graphql.node, fRef);
  var refetchFn = match[1];
  var data = RescriptRelay_Internal.internal_useConvertedValue(BulkSaleProducerAdminFragment_bulkSaleApplication_graphql.Internal.convertFragment, match[0]);
  return [
          data,
          React.useMemo((function () {
                  return function (param, param$1, param$2, param$3) {
                    return Curry._2(refetchFn, RescriptRelay_Internal.internal_cleanObjectFromUndefinedRaw(BulkSaleProducerAdminRefetchQuery_graphql.Internal.convertVariables(param)), internal_makeRefetchableFnOpts(param$1, param$2, undefined));
                  };
                }), [refetchFn])
        ];
}

function use(fRef) {
  var data = Hooks.useFragment(BulkSaleProducerAdminFragment_bulkSaleApplication_graphql.node, fRef);
  return RescriptRelay_Internal.internal_useConvertedValue(BulkSaleProducerAdminFragment_bulkSaleApplication_graphql.Internal.convertFragment, data);
}

function useOpt(opt_fRef) {
  var fr = opt_fRef !== undefined ? Caml_option.some(Caml_option.valFromOption(opt_fRef)) : undefined;
  var nullableFragmentData = Hooks.useFragment(BulkSaleProducerAdminFragment_bulkSaleApplication_graphql.node, fr !== undefined ? Js_null_undefined.fromOption(Caml_option.some(Caml_option.valFromOption(fr))) : null);
  var data = (nullableFragmentData == null) ? undefined : Caml_option.some(nullableFragmentData);
  return RescriptRelay_Internal.internal_useConvertedValue((function (rawFragment) {
                if (rawFragment !== undefined) {
                  return BulkSaleProducerAdminFragment_bulkSaleApplication_graphql.Internal.convertFragment(rawFragment);
                }
                
              }), data);
}

var makeRefetchVariables = BulkSaleProducerAdminRefetchQuery_graphql.Types.makeRefetchVariables;

var Fragment_averageAnnualSalesRange_decode = BulkSaleProducerAdminFragment_bulkSaleApplication_graphql.Utils.averageAnnualSalesRange_decode;

var Fragment_averageAnnualSalesRange_fromString = BulkSaleProducerAdminFragment_bulkSaleApplication_graphql.Utils.averageAnnualSalesRange_fromString;

var Fragment_bulkSaleApplicationProgress_decode = BulkSaleProducerAdminFragment_bulkSaleApplication_graphql.Utils.bulkSaleApplicationProgress_decode;

var Fragment_bulkSaleApplicationProgress_fromString = BulkSaleProducerAdminFragment_bulkSaleApplication_graphql.Utils.bulkSaleApplicationProgress_fromString;

var Fragment_deliveryPackage_decode = BulkSaleProducerAdminFragment_bulkSaleApplication_graphql.Utils.deliveryPackage_decode;

var Fragment_deliveryPackage_fromString = BulkSaleProducerAdminFragment_bulkSaleApplication_graphql.Utils.deliveryPackage_fromString;

var Fragment_experienceYearsRange_decode = BulkSaleProducerAdminFragment_bulkSaleApplication_graphql.Utils.experienceYearsRange_decode;

var Fragment_experienceYearsRange_fromString = BulkSaleProducerAdminFragment_bulkSaleApplication_graphql.Utils.experienceYearsRange_fromString;

var Fragment_facilityType_decode = BulkSaleProducerAdminFragment_bulkSaleApplication_graphql.Utils.facilityType_decode;

var Fragment_facilityType_fromString = BulkSaleProducerAdminFragment_bulkSaleApplication_graphql.Utils.facilityType_fromString;

var Fragment_individualOrCompany_decode = BulkSaleProducerAdminFragment_bulkSaleApplication_graphql.Utils.individualOrCompany_decode;

var Fragment_individualOrCompany_fromString = BulkSaleProducerAdminFragment_bulkSaleApplication_graphql.Utils.individualOrCompany_fromString;

var Fragment_productPackageMassUnit_decode = BulkSaleProducerAdminFragment_bulkSaleApplication_graphql.Utils.productPackageMassUnit_decode;

var Fragment_productPackageMassUnit_fromString = BulkSaleProducerAdminFragment_bulkSaleApplication_graphql.Utils.productPackageMassUnit_fromString;

var Fragment_productionCertificate_decode = BulkSaleProducerAdminFragment_bulkSaleApplication_graphql.Utils.productionCertificate_decode;

var Fragment_productionCertificate_fromString = BulkSaleProducerAdminFragment_bulkSaleApplication_graphql.Utils.productionCertificate_fromString;

var Fragment_supplyDayOfMonth_decode = BulkSaleProducerAdminFragment_bulkSaleApplication_graphql.Utils.supplyDayOfMonth_decode;

var Fragment_supplyDayOfMonth_fromString = BulkSaleProducerAdminFragment_bulkSaleApplication_graphql.Utils.supplyDayOfMonth_fromString;

var Fragment_supplyFrequecy_decode = BulkSaleProducerAdminFragment_bulkSaleApplication_graphql.Utils.supplyFrequecy_decode;

var Fragment_supplyFrequecy_fromString = BulkSaleProducerAdminFragment_bulkSaleApplication_graphql.Utils.supplyFrequecy_fromString;

var Fragment = {
  averageAnnualSalesRange_decode: Fragment_averageAnnualSalesRange_decode,
  averageAnnualSalesRange_fromString: Fragment_averageAnnualSalesRange_fromString,
  bulkSaleApplicationProgress_decode: Fragment_bulkSaleApplicationProgress_decode,
  bulkSaleApplicationProgress_fromString: Fragment_bulkSaleApplicationProgress_fromString,
  deliveryPackage_decode: Fragment_deliveryPackage_decode,
  deliveryPackage_fromString: Fragment_deliveryPackage_fromString,
  experienceYearsRange_decode: Fragment_experienceYearsRange_decode,
  experienceYearsRange_fromString: Fragment_experienceYearsRange_fromString,
  facilityType_decode: Fragment_facilityType_decode,
  facilityType_fromString: Fragment_facilityType_fromString,
  individualOrCompany_decode: Fragment_individualOrCompany_decode,
  individualOrCompany_fromString: Fragment_individualOrCompany_fromString,
  productPackageMassUnit_decode: Fragment_productPackageMassUnit_decode,
  productPackageMassUnit_fromString: Fragment_productPackageMassUnit_fromString,
  productionCertificate_decode: Fragment_productionCertificate_decode,
  productionCertificate_fromString: Fragment_productionCertificate_fromString,
  supplyDayOfMonth_decode: Fragment_supplyDayOfMonth_decode,
  supplyDayOfMonth_fromString: Fragment_supplyDayOfMonth_fromString,
  supplyFrequecy_decode: Fragment_supplyFrequecy_decode,
  supplyFrequecy_fromString: Fragment_supplyFrequecy_fromString,
  Types: undefined,
  internal_makeRefetchableFnOpts: internal_makeRefetchableFnOpts,
  useRefetchable: useRefetchable,
  use: use,
  useOpt: useOpt,
  makeRefetchVariables: makeRefetchVariables
};

function formatDate(d) {
  return Format(new Date(d), "yyyy/MM/dd HH:mm");
}

function displayExperiencedYearRange(s) {
  if (s >= 21) {
    if (s !== 40) {
      return "";
    } else {
      return "~20년이상";
    }
  }
  if (s < 0) {
    return "";
  }
  switch (s) {
    case 0 :
        return "경력없음";
    case 1 :
        return "1년 미만";
    case 5 :
        return "1~5년";
    case 10 :
        return "5~10년";
    case 2 :
    case 3 :
    case 4 :
    case 6 :
    case 7 :
    case 8 :
    case 9 :
    case 11 :
    case 12 :
    case 13 :
    case 14 :
    case 15 :
    case 16 :
    case 17 :
    case 18 :
    case 19 :
        return "";
    case 20 :
        return "10~20년";
    
  }
}

function displayAnnualProductSalesInfo(s) {
  if (s === "FROM_500M_TO_INF") {
    return "5억원 이상";
  } else if (s === "FROM_0_TO_30M") {
    return "3천만원 미만";
  } else if (s === "FROM_100M_TO_300M") {
    return "1~3억원 미만";
  } else if (s === "FROM_300M_TO_500M") {
    return "3~5억원 미만";
  } else if (s === "FROM_30M_TO_100M") {
    return "3,000만원~1억원 미만";
  } else {
    return "-";
  }
}

function displayBusinessType(s) {
  if (s === "COMPANY") {
    return "법인";
  } else if (s === "INDIVIDUAL") {
    return "개인";
  } else {
    return "-";
  }
}

function displayFacilityType(facilityType) {
  if (facilityType === "OPEN_FIELD") {
    return "노지";
  } else if (facilityType === "VINYL_HOUSE_FIELD") {
    return "비닐하우스(토지)";
  } else if (facilityType === "VINYL_HOUSE_SMART_FARM") {
    return "비닐하우스(스마트팜)";
  } else if (facilityType === "GLASS") {
    return "유리온실";
  } else {
    return "";
  }
}

function displayCertificate(certificate) {
  if (certificate === "LOW_CARBON") {
    return "저탄소";
  } else if (certificate === "GAP") {
    return "GAP";
  } else if (certificate === "ECO_FRIENDLY") {
    return "친환경";
  } else {
    return "";
  }
}

function displaySupplyFrequency(f) {
  if (f === "DAILY") {
    return "매일";
  } else if (f === "ONCE_A_WEEK") {
    return "주 1~2회";
  } else if (f === "THREE_TIMES_A_WEEK") {
    return "주 3~5회";
  } else if (f === "MONTHLY") {
    return "월 1~2회";
  } else {
    return "";
  }
}

function displayDeliveryPackage(f) {
  if (f === "CONTI") {
    return "콘티";
  } else if (f === "TON_BAG") {
    return "톤백";
  } else {
    return "";
  }
}

function getEmailId(x) {
  return Garter_Array.firstExn(x.split("@"));
}

var months = {
  hd: [
    1,
    "1월"
  ],
  tl: {
    hd: [
      2,
      "2월"
    ],
    tl: {
      hd: [
        3,
        "3월"
      ],
      tl: {
        hd: [
          4,
          "4월"
        ],
        tl: {
          hd: [
            5,
            "5월"
          ],
          tl: {
            hd: [
              6,
              "6월"
            ],
            tl: {
              hd: [
                7,
                "7월"
              ],
              tl: {
                hd: [
                  8,
                  "8월"
                ],
                tl: {
                  hd: [
                    9,
                    "9월"
                  ],
                  tl: {
                    hd: [
                      10,
                      "10월"
                    ],
                    tl: {
                      hd: [
                        11,
                        "11월"
                      ],
                      tl: {
                        hd: [
                          12,
                          "12월"
                        ],
                        tl: /* [] */0
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }
};

function displaySupplyDays(d) {
  if (d === "EARLY") {
    return "초순";
  } else if (d === "MIDDLE") {
    return "중순";
  } else if (d === "LATE") {
    return "하순";
  } else {
    return "";
  }
}

function displaySupplyBeginToEnd(s1, s2) {
  var m1 = Belt_Option.getWithDefault(Belt_List.getAssoc(months, s1.month, (function (a, b) {
              return a === b;
            })), "");
  var m2 = Belt_Option.getWithDefault(Belt_List.getAssoc(months, s2.month, (function (a, b) {
              return a === b;
            })), "");
  var d1 = displaySupplyDays(s1.dayOfMonth);
  var d2 = displaySupplyDays(s2.dayOfMonth);
  return m1 + " " + d1 + " ~ " + m2 + " " + d2;
}

function BulkSale_Producer_Admin$Gallery(Props) {
  var imageUrls = Props.imageUrls;
  var match = React.useState(function () {
        return 0;
      });
  var setImageIndex = match[1];
  var match$1 = React.useState(function () {
        return false;
      });
  var setIsOpen = match$1[1];
  return React.createElement(React.Fragment, undefined, React.createElement("span", {
                  className: "underline",
                  onClick: (function (param) {
                      return setIsOpen(function (param) {
                                  return true;
                                });
                    })
                }, "사진 보기"), React.createElement(ReactImagesViewer, {
                  imgs: Belt_Array.map(imageUrls, (function (url) {
                          return {
                                  src: url
                                };
                        })),
                  isOpen: match$1[0],
                  onClickPrev: (function (param) {
                      return setImageIndex(function (idx) {
                                  return Math.max(0, idx - 1 | 0);
                                });
                    }),
                  onClickNext: (function (param) {
                      return setImageIndex(function (idx) {
                                  return Math.min(idx + 1 | 0, imageUrls.length - 1 | 0);
                                });
                    }),
                  onClose: (function (param) {
                      return setIsOpen(function (param) {
                                  return false;
                                });
                    }),
                  onClickThumbnail: (function (idx) {
                      return setImageIndex(function (param) {
                                  return idx;
                                });
                    }),
                  showThumbnails: true,
                  currImg: match[0]
                }));
}

var Gallery = {
  make: BulkSale_Producer_Admin$Gallery
};

function BulkSale_Producer_Admin$Item$Table(Props) {
  var node = Props.node;
  var refetchSummary = Props.refetchSummary;
  var application = use(node.fragmentRefs);
  var staff$p = application.staff;
  var campaign = application.bulkSaleCampaign;
  var campaign$1 = application.bulkSaleCampaign;
  var imageUrls = Belt_Option.mapWithDefault(application.userPccProduction, [], (function (p) {
          return p.images;
        }));
  var name = Belt_Option.mapWithDefault(application.farmmorningUser.userBusinessRegistrationInfo, "", (function (i) {
          return i.name;
        }));
  var zipCode = application.farm.zipCode;
  return React.createElement("li", {
              className: "grid grid-cols-11-admin-bulk-sale-producers"
            }, React.createElement("div", {
                  className: "h-full flex flex-col justify-center px-4 py-2"
                }, Format(new Date(application.appliedAt), "yyyy/MM/dd HH:mm")), React.createElement("div", {
                  className: "h-full flex flex-col justify-center px-4 py-2"
                }, React.createElement(Select_BulkSale_Application_Status.make, {
                      application: application,
                      refetchSummary: refetchSummary
                    })), React.createElement("div", {
                  className: "h-full flex flex-col justify-center px-4 py-2 relative"
                }, Belt_Option.mapWithDefault(application.staff, "", (function (x) {
                        return x.name + "( " + Garter_Array.firstExn(x.emailAddress.split("@")) + " )";
                      })), React.createElement("div", {
                      className: "absolute w-[180px] left-0"
                    }, React.createElement(Select_BulkSale_Search.Staff.make, {
                          applicationId: application.id,
                          staffInfo: staff$p !== undefined ? /* Selected */({
                                value: staff$p.id,
                                label: staff$p.name + "( " + Garter_Array.firstExn(staff$p.emailAddress.split("@")) + " )"
                              }) : /* NotSelected */0,
                          key: application.id
                        }))), React.createElement("div", {
                  className: "h-full flex flex-col justify-center px-4 py-2"
                }, React.createElement("p", {
                      className: "mb-2"
                    }, campaign !== undefined ? campaign.productCategory.crop.name + " > " + campaign.productCategory.name : application.productCategory.crop.name + " > " + application.productCategory.name), React.createElement(BulkSale_Producer_Sample_Review_Button_Admin.make, {
                      applicationId: application.id,
                      sampleReview: application.fragmentRefs
                    })), React.createElement("div", {
                  className: "h-full flex flex-col justify-center px-4 py-2"
                }, React.createElement("p", undefined, campaign$1 !== undefined ? Locale.Float.show(undefined, campaign$1.estimatedPurchasePriceMin, 0) + "원~" + Locale.Float.show(undefined, campaign$1.estimatedPurchasePriceMax, 0) + "원" : null, React.createElement("span", {
                          className: "text-text-L2"
                        }, Belt_Option.mapWithDefault(application.bulkSaleCampaign, null, (function (campaign) {
                                return "(" + campaign.preferredGrade + "," + campaign.preferredQuantity.display + ")";
                              })))), React.createElement("p", undefined, Belt_Option.mapWithDefault(application.bulkSaleCampaign, null, (function (campaign) {
                            return "수익률 " + String(campaign.estimatedSellerEarningRate) + "%";
                          })))), React.createElement("div", {
                  className: "h-full flex flex-row justify-between px-4 py-3"
                }, Belt_Option.mapWithDefault(Belt_Option.flatMap(application.userPccSalesCondition, (function (c) {
                            return c.averageAnnualSales;
                          })), "", displayAnnualProductSalesInfo)), React.createElement("div", {
                  className: "h-full flex flex-row justify-between px-4 py-3"
                }, Belt_Option.mapWithDefault(application.userPccSalesCondition, "", (function (c) {
                        if (c.canDeliver) {
                          return "예";
                        } else {
                          return "아니오";
                        }
                      }))), React.createElement("div", {
                  className: "h-full flex flex-row justify-between px-4 py-3"
                }, Belt_Option.getWithDefault(Belt_Option.flatMap(application.userPccSalesCondition, (function (c) {
                            return c.deliveryWeightUnit;
                          })), "")), React.createElement("div", {
                  className: "h-full flex flex-row justify-between px-4 py-3"
                }, Belt_Option.getWithDefault(Belt_Option.flatMap(application.userPccSalesCondition, (function (c) {
                            return c.deliveryDailyCapacity;
                          })), "")), React.createElement("div", {
                  className: "h-full flex flex-row justify-between px-4 py-3"
                }, Belt_Option.mapWithDefault(application.userPccSalesCondition, "", (function (c) {
                        return displaySupplyFrequency(c.supplyFrequency);
                      }))), React.createElement("div", {
                  className: "h-full flex flex-row justify-between px-4 py-3"
                }, Belt_Option.mapWithDefault(application.userPccSalesCondition, "", (function (c) {
                        var match = c.supplyBegin;
                        var match$1 = c.supplyEnd;
                        if (match !== undefined) {
                          if (match$1 !== undefined) {
                            return displaySupplyBeginToEnd(match, match$1);
                          } else {
                            return "상시 출하";
                          }
                        } else {
                          return "상시 출하";
                        }
                      }))), React.createElement("div", {
                  className: "h-full flex flex-row justify-between px-4 py-3"
                }, Belt_Option.mapWithDefault(application.userPccSalesCondition, "", (function (p) {
                        return Belt_Array.map(p.deliveryPackages, displayDeliveryPackage).join(", ");
                      }))), React.createElement("div", {
                  className: "h-full flex flex-row justify-between px-4 py-3"
                }, Belt_Option.mapWithDefault(application.userPccProduction, "", (function (p) {
                        return displayFacilityType(p.facilityType);
                      }))), React.createElement("div", {
                  className: "h-full flex flex-row justify-between px-4 py-3"
                }, Belt_Option.mapWithDefault(application.userPccProduction, "", (function (p) {
                        return Belt_Array.map(p.certificates, displayCertificate).join(", ");
                      }))), React.createElement("div", {
                  className: "h-full flex flex-row justify-between px-4 py-3"
                }, Belt_Option.mapWithDefault(application.userPccProduction, "", (function (p) {
                        return p.grade;
                      }))), React.createElement("div", {
                  className: "h-full flex flex-col justify-center px-4 py-2"
                }, React.createElement(BulkSale_Producer_MarketSales_Admin.make, {
                      query: application.fragmentRefs
                    })), React.createElement("div", {
                  className: "h-full flex flex-col justify-center px-4 py-2"
                }, Belt_Option.getWithDefault(Belt_Option.flatMap(application.bulkSaleProducerDetail, (function (d) {
                            return d.hasOnlineExperience;
                          })), false) ? "예" : "아니오"), React.createElement("div", {
                  className: "h-full flex flex-row justify-between px-4 py-3"
                }, Garter_Array.isEmpty(imageUrls) ? React.createElement("span", undefined, "사진 없음") : React.createElement(BulkSale_Producer_Admin$Gallery, {
                        imageUrls: imageUrls
                      })), React.createElement("div", {
                  className: "h-full flex flex-col justify-center px-4 py-2"
                }, React.createElement("div", {
                      className: "flex"
                    }, React.createElement("p", undefined, application.applicantName === "" ? "사용자: " + application.farmmorningUser.name : "사용자: " + application.applicantName), application.farmmorningUser.isDeleted ? React.createElement("span", {
                            className: "ml-2 py-0.5 px-1.5 text-xs bg-red-100 text-notice rounded"
                          }, "탈퇴") : null), React.createElement("p", undefined, name === "" ? null : "사업자: " + name), React.createElement("p", undefined, "(" + Belt_Option.getWithDefault(Belt_Option.flatMap(Helper.PhoneNumber.parse(application.farmmorningUser.phoneNumber), Helper.PhoneNumber.format), application.farmmorningUser.phoneNumber) + ")"), React.createElement("p", {
                      className: "text-text-L3"
                    }, Belt_Option.getWithDefault(Helper.$$Option.map2(application.farm.address, application.farm.addressDetail, (function (address, addressDetail) {
                                return address + " " + addressDetail;
                              })), "주소 없음")), React.createElement("p", {
                      className: "text-text-L3"
                    }, zipCode !== undefined ? "우)" + zipCode : "(우편번호 없음)")), React.createElement("div", {
                  className: "h-full flex flex-row justify-between px-4 py-3"
                }, Belt_Option.mapWithDefault(Belt_Option.flatMap(application.bulkSaleProducerDetail, (function (d) {
                            return d.handsOn;
                          })), "", (function (handsOn) {
                        if (handsOn) {
                          return "예";
                        } else {
                          return "아니오";
                        }
                      }))), React.createElement("div", {
                  className: "h-full flex flex-col justify-center px-4 py-2"
                }, React.createElement("p", undefined, Belt_Option.mapWithDefault(Belt_Option.flatMap(application.bulkSaleProducerDetail, (function (d) {
                                return d.experienceYearType;
                              })), "", displayExperiencedYearRange))), React.createElement("div", {
                  className: "h-full flex flex-row justify-between px-4 py-3"
                }, Belt_Option.getWithDefault(Belt_Option.flatMap(application.bulkSaleProducerDetail, (function (d) {
                            return d.producerComment;
                          })), "")), React.createElement("div", {
                  className: "h-full flex flex-row justify-between px-4 py-3"
                }, React.createElement("p", {
                      className: "h-[105px] pr-4 text-ellipsis line-clamp-5"
                    }, application.memo), React.createElement(BulkSale_Producer_Memo_Update_Button.make, {
                      applicationId: application.id,
                      memoData: application.memo
                    })));
}

function BulkSale_Producer_Admin$Item$Table$Loading(Props) {
  return React.createElement("li", {
              className: "grid grid-cols-7-admin-bulk-sale-product"
            }, React.createElement("div", {
                  className: "h-full flex flex-col px-4 py-2"
                }, React.createElement(Checkbox.make, {})), React.createElement("div", {
                  className: "h-full flex flex-col px-4 py-2"
                }, React.createElement(Skeleton.Box.make, {
                      className: "w-20"
                    }), React.createElement(Skeleton.Box.make, {}), React.createElement(Skeleton.Box.make, {
                      className: "w-12"
                    })), React.createElement("div", {
                  className: "h-full flex flex-col px-4 py-2"
                }, React.createElement(Skeleton.Box.make, {}), React.createElement(Skeleton.Box.make, {})), React.createElement("div", {
                  className: "h-full flex flex-col px-4 py-2"
                }, React.createElement(Skeleton.Box.make, {}), React.createElement(Skeleton.Box.make, {
                      className: "w-2/3"
                    }), React.createElement(Skeleton.Box.make, {
                      className: "w-8"
                    })), React.createElement("div", {
                  className: "h-full flex flex-col px-4 py-2"
                }, React.createElement(Skeleton.Box.make, {})), React.createElement("div", {
                  className: "h-full flex flex-col px-4 py-2"
                }, React.createElement(Skeleton.Box.make, {})), React.createElement("div", {
                  className: "h-full flex flex-col px-4 py-2"
                }, React.createElement(Skeleton.Box.make, {}), React.createElement(Skeleton.Box.make, {})));
}

var Loading = {
  make: BulkSale_Producer_Admin$Item$Table$Loading
};

var Table = {
  make: BulkSale_Producer_Admin$Item$Table,
  Loading: Loading
};

var Item = {
  Table: Table
};

function BulkSale_Producer_Admin(Props) {
  var node = Props.node;
  var refetchSummary = Props.refetchSummary;
  return React.createElement(BulkSale_Producer_Admin$Item$Table, {
              node: node,
              refetchSummary: refetchSummary
            });
}

var make = BulkSale_Producer_Admin;

export {
  Fragment ,
  formatDate ,
  displayExperiencedYearRange ,
  displayAnnualProductSalesInfo ,
  displayBusinessType ,
  displayFacilityType ,
  displayCertificate ,
  displaySupplyFrequency ,
  displayDeliveryPackage ,
  getEmailId ,
  months ,
  displaySupplyDays ,
  displaySupplyBeginToEnd ,
  Gallery ,
  Item ,
  make ,
  
}
/* react Not a pure module */
