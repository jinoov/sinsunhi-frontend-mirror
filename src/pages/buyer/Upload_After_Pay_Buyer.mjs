// Generated by ReScript, PLEASE EDIT WITH CARE

import * as React from "react";
import * as Locale from "../../utils/Locale.mjs";
import * as ReactUtil from "../../utils/ReactUtil.mjs";
import * as Belt_Array from "rescript/lib/es6/belt_Array.js";
import * as CustomHooks from "../../utils/CustomHooks.mjs";
import * as Router from "next/router";
import * as Upload_Buyer from "./Upload_Buyer.mjs";
import * as Authorization from "../../utils/Authorization.mjs";
import * as Belt_SetString from "rescript/lib/es6/belt_SetString.js";
import * as Guide_Upload_Buyer from "../../components/Guide_Upload_Buyer.mjs";
import * as After_Pay_Orders_List from "./After_Pay_Orders_List.mjs";
import * as Upload_After_Pay_Form from "./Upload_After_Pay_Form.mjs";
import * as ReactAccordion from "@radix-ui/react-accordion";
import * as Agreement_After_Pay_Buyer from "./Agreement_After_Pay_Buyer.mjs";
import DropdownSvg from "../../../public/assets/dropdown.svg";

var dropdownIcon = DropdownSvg;

function Upload_After_Pay_Buyer$BalanceView(Props) {
  var balance = Props.balance;
  var credit = Props.credit;
  var maxExpiryDays = Props.maxExpiryDays;
  var rate = Props.rate;
  var match = React.useState(function () {
        return false;
      });
  var setOpen = match[1];
  var handleOrdersListOpen = function (param) {
    return setOpen(function (param) {
                return true;
              });
  };
  return React.createElement(React.Fragment, undefined, React.createElement(After_Pay_Orders_List.make, {
                  open_: match[0],
                  setOpen: setOpen
                }), React.createElement("div", {
                  className: "container max-w-lg mx-auto sm:shadow-gl px-7"
                }, React.createElement("div", {
                      className: "flex flex-col divide-y"
                    }, React.createElement("div", {
                          className: "flex flex-col gap-6 py-7"
                        }, React.createElement("div", {
                              className: "flex items-end"
                            }, React.createElement("div", undefined, React.createElement("div", {
                                      className: "text-sm"
                                    }, "나중결제 가능 금액"), React.createElement("div", {
                                      className: "text-lg font-bold text-green-500"
                                    }, Locale.Float.show(undefined, balance, 0) + " 원")), React.createElement("div", {
                                  className: "ml-auto"
                                }, React.createElement(ReactUtil.SpreadProps.make, {
                                      children: React.createElement("button", {
                                            className: "btn-level6-small px-2 py-1",
                                            onClick: handleOrdersListOpen
                                          }, "내역보기"),
                                      props: {
                                        "data-gtm": "btn-after-pay-history-list"
                                      }
                                    }))), React.createElement("div", undefined, React.createElement("div", {
                                  className: "text-sm"
                                }, "총 나중결제 이용 한도"), React.createElement("div", {
                                  className: "text-lg font-bold"
                                }, Locale.Float.show(undefined, credit, 0) + " 원"))), React.createElement("div", {
                          className: "flex flex-col gap-3 text-sm py-5"
                        }, React.createElement("div", {
                              className: "flex place-content-between"
                            }, React.createElement("div", {
                                  className: "text-gray-600"
                                }, "수수료"), React.createElement("div", {
                                  className: "col-span-3"
                                }, rate + "%")), React.createElement("div", {
                              className: "flex place-content-between"
                            }, React.createElement("div", {
                                  className: "text-gray-600"
                                }, "만기일"), React.createElement("div", {
                                  className: "col-span-3"
                                }, "주문서별 업로드 완료일 기준 ", React.createElement("b", undefined, "최대 " + String(maxExpiryDays) + "일"))), React.createElement("div", {
                              className: "flex place-content-between"
                            }, React.createElement("div", {
                                  className: "text-gray-600"
                                }, "상환계좌"), React.createElement("div", {
                                  className: "col-span-3"
                                }, "신한은행 140-013-193191"))))));
}

var BalanceView = {
  make: Upload_After_Pay_Buyer$BalanceView
};

function Upload_After_Pay_Buyer$Balance(Props) {
  var result = CustomHooks.AfterPayCredit.use(undefined);
  if (typeof result === "number") {
    return null;
  }
  if (result.TAG !== /* Loaded */0) {
    return React.createElement("div", undefined, "처리 중 오류가 발생하였습니다.");
  }
  var response = result._0.credit;
  var balance = response.debtMax - response.debtTotal | 0;
  var credit = response.debtMax;
  var maxExpiryDays = response.debtExpiryDays;
  var rate = String(response.debtInterestRate);
  return React.createElement(Upload_After_Pay_Buyer$BalanceView, {
              balance: balance,
              credit: credit,
              maxExpiryDays: maxExpiryDays,
              rate: rate
            });
}

var Balance = {
  make: Upload_After_Pay_Buyer$Balance
};

function Upload_After_Pay_Buyer$Notice(Props) {
  var match = React.useState(function () {
        return "자세히 보기";
      });
  var setText = match[1];
  var handleChange = function (value) {
    return setText(function (param) {
                if (value.length !== 0) {
                  return "접기";
                } else {
                  return "자세히 보기";
                }
              });
  };
  return React.createElement("div", {
              className: "text-red-500 bg-red-50 border-red-150 border py-4 px-5 container max-w-lg mx-auto mt-7"
            }, React.createElement("div", undefined, React.createElement("b", undefined, "[필독사항]"), React.createElement("br", undefined), "나중결제 주문을 위한 필독사항을 꼭 확인하세요"), React.createElement(ReactAccordion.Root, {
                  children: React.createElement(ReactAccordion.Item, {
                        children: null,
                        value: "guide-1"
                      }, React.createElement(ReactAccordion.Content, {
                            children: React.createElement("ol", {
                                  className: "space-y-4 mt-4"
                                }, React.createElement("li", undefined, "1. 나중결제는 기존 선결제와 달리 현금영수증이 자동발급되지 않으며,세금계산서(발주금액+수수료 합계액)로 발행됩니다."), React.createElement("li", undefined, "2. 나중결제는 주문서 단위로 접수, 관리됩니다. 따라서 만기시 수수료 포함하여 주문서별 총발주금액을 일괄 상환하셔야 합니다. 상환 필요 금액은 [이용내역]  및 별도 카톡 알림으로 확인 가능합니다."), React.createElement("li", undefined, "3. 나중결제 이용 가능 한도 및 수수료는 내부 기준에 따라 부여되며, 연체 없이 꾸준한 이용시에는 한도 상향, 수수료 인하 등의 추가 혜택으로 연결될 수 있습니다."), React.createElement("li", undefined, "4.연체시 나중결제 서비스를 이용할 수 없으며, 연체원금에 대한 연체수수료가 일할로 부과됩니다.", React.createElement("br", undefined), "(일 0.03%)"), React.createElement("li", undefined, "5.가이드를 참고하여 주문서를 작성해주세요. ", React.createElement("a", {
                                          className: "underline",
                                          href: "https://drive.google.com/file/d/1BQQ5Vg0eNWjCNlY925cGi-VDUyfFvBkf/view",
                                          target: "_new"
                                        }, "[가이드]"), React.createElement("br", undefined), "양식에 맞지 않을 경우 주문이 실패할 수 있습니다 ")),
                            className: "accordian-content"
                          }), React.createElement(ReactAccordion.Header, {
                            children: React.createElement(ReactAccordion.Trigger, {
                                  children: React.createElement("div", {
                                        className: "flex items-center"
                                      }, React.createElement("div", {
                                            className: "text-sm underline"
                                          }, match[0]), React.createElement("img", {
                                            className: "accordian-icon",
                                            src: dropdownIcon
                                          })),
                                  className: "mt-4 accordian-trigger"
                                })
                          })),
                  type: "multiple",
                  onValueChange: handleChange
                }));
}

var Notice = {
  make: Upload_After_Pay_Buyer$Notice
};

function Upload_After_Pay_Buyer(Props) {
  var agreements = CustomHooks.AfterPayAgreement.use(undefined);
  var router = Router.useRouter();
  React.useEffect((function () {
          if (typeof agreements === "number") {
            if (agreements !== /* Loading */0) {
              router.replace("/buyer/upload");
            }
            
          } else if (agreements.TAG === /* Loaded */0) {
            var didAgreements = Belt_SetString.fromArray(Belt_Array.map(agreements._0.terms, (function (param) {
                        return param.agreement;
                      })));
            var reuquiredAgreements = Belt_SetString.fromArray([
                  Agreement_After_Pay_Buyer.Agreement.agree1,
                  Agreement_After_Pay_Buyer.Agreement.agree2,
                  Agreement_After_Pay_Buyer.Agreement.agree3,
                  Agreement_After_Pay_Buyer.Agreement.agree4
                ]);
            if (false === Belt_SetString.eq(didAgreements, reuquiredAgreements)) {
              router.replace("/buyer/after-pay/agreement");
            }
            
          } else {
            router.replace("/buyer/upload");
          }
          
        }), [agreements]);
  return React.createElement(Authorization.Buyer.make, {
              children: null,
              title: "주문서 업로드"
            }, React.createElement(Upload_After_Pay_Buyer$Notice, {}), React.createElement(Upload_Buyer.Tab.AfterPay.make, {}), React.createElement(Upload_After_Pay_Buyer$Balance, {}), React.createElement(Upload_After_Pay_Form.UploadForm.make, {}), React.createElement(Upload_After_Pay_Form.UploadResult.make, {}), React.createElement(Guide_Upload_Buyer.make, {}));
}

var make = Upload_After_Pay_Buyer;

export {
  dropdownIcon ,
  BalanceView ,
  Balance ,
  Notice ,
  make ,
  
}
/* dropdownIcon Not a pure module */
