// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Env from "../../../constants/Env.mjs";
import * as Curry from "rescript/lib/es6/curry.js";
import * as React from "react";
import * as RelayEnv from "../../../constants/RelayEnv.mjs";
import * as IconArrow from "../../../components/svgs/IconArrow.mjs";
import Link from "next/link";
import * as Js_promise from "rescript/lib/es6/js_promise.js";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as ChannelTalk from "../../../bindings/ChannelTalk.mjs";
import * as Router from "next/router";
import * as ReactRelay from "react-relay";
import * as DeviceDetect from "../../../bindings/DeviceDetect.mjs";
import * as Footer_Buyer from "../../../components/Footer_Buyer.mjs";
import * as Header_Buyer from "../../../components/Header_Buyer.mjs";
import * as Authorization from "../../../utils/Authorization.mjs";
import * as Bottom_Navbar from "../../../components/Bottom_Navbar.mjs";
import * as RescriptRelay from "rescript-relay/src/RescriptRelay.mjs";
import * as RelayRuntime from "relay-runtime";
import Format from "date-fns/format";
import * as ServerSideHelper from "../../../utils/ServerSideHelper.mjs";
import * as FeatureFlagWrapper from "../pc/FeatureFlagWrapper.mjs";
import SubMonths from "date-fns/subMonths";
import * as MyInfo_Layout_Buyer from "./components/MyInfo_Layout_Buyer.mjs";
import * as MyInfo_Skeleton_Buyer from "./components/MyInfo_Skeleton_Buyer.mjs";
import * as RescriptRelay_Internal from "rescript-relay/src/RescriptRelay_Internal.mjs";
import * as MyInfo_Cash_Remain_Buyer from "./components/MyInfo_Cash_Remain_Buyer.mjs";
import * as MyInfoBuyer_Query_graphql from "../../../__generated__/MyInfoBuyer_Query_graphql.mjs";
import * as RescriptReactErrorBoundary from "@rescript/react/src/RescriptReactErrorBoundary.mjs";
import * as MyInfo_ProfileSummary_Buyer from "./components/MyInfo_ProfileSummary_Buyer.mjs";
import * as FormulaComponents from "@greenlabs/formula-components";
import * as MyInfo_Processing_Order_Buyer from "./components/MyInfo_Processing_Order_Buyer.mjs";
import * as MyInfo_Profile_Complete_Buyer from "./components/MyInfo_Profile_Complete_Buyer.mjs";

function use(variables, fetchPolicy, fetchKey, networkCacheConfig, param) {
  var data = ReactRelay.useLazyLoadQuery(MyInfoBuyer_Query_graphql.node, RescriptRelay_Internal.internal_cleanObjectFromUndefinedRaw(MyInfoBuyer_Query_graphql.Internal.convertVariables(variables)), {
        fetchKey: fetchKey,
        fetchPolicy: RescriptRelay.mapFetchPolicy(fetchPolicy),
        networkCacheConfig: networkCacheConfig
      });
  return RescriptRelay_Internal.internal_useConvertedValue(MyInfoBuyer_Query_graphql.Internal.convertResponse, data);
}

function useLoader(param) {
  var match = ReactRelay.useQueryLoader(MyInfoBuyer_Query_graphql.node);
  var loadQueryFn = match[1];
  var loadQuery = React.useMemo((function () {
          return function (param, param$1, param$2, param$3) {
            return Curry._2(loadQueryFn, MyInfoBuyer_Query_graphql.Internal.convertVariables(param), {
                        fetchPolicy: param$1,
                        networkCacheConfig: param$2
                      });
          };
        }), [loadQueryFn]);
  return [
          Caml_option.nullable_to_opt(match[0]),
          loadQuery,
          match[2]
        ];
}

function $$fetch(environment, variables, onResult, networkCacheConfig, fetchPolicy, param) {
  ReactRelay.fetchQuery(environment, MyInfoBuyer_Query_graphql.node, MyInfoBuyer_Query_graphql.Internal.convertVariables(variables), {
          networkCacheConfig: networkCacheConfig,
          fetchPolicy: RescriptRelay.mapFetchQueryFetchPolicy(fetchPolicy)
        }).subscribe({
        next: (function (res) {
            Curry._1(onResult, {
                  TAG: /* Ok */0,
                  _0: MyInfoBuyer_Query_graphql.Internal.convertResponse(res)
                });
          }),
        error: (function (err) {
            Curry._1(onResult, {
                  TAG: /* Error */1,
                  _0: err
                });
          })
      });
}

function fetchPromised(environment, variables, networkCacheConfig, fetchPolicy, param) {
  var __x = ReactRelay.fetchQuery(environment, MyInfoBuyer_Query_graphql.node, MyInfoBuyer_Query_graphql.Internal.convertVariables(variables), {
          networkCacheConfig: networkCacheConfig,
          fetchPolicy: RescriptRelay.mapFetchQueryFetchPolicy(fetchPolicy)
        }).toPromise();
  return Js_promise.then_((function (res) {
                return Promise.resolve(MyInfoBuyer_Query_graphql.Internal.convertResponse(res));
              }), __x);
}

function usePreloaded(queryRef, param) {
  var data = ReactRelay.usePreloadedQuery(MyInfoBuyer_Query_graphql.node, queryRef);
  return RescriptRelay_Internal.internal_useConvertedValue(MyInfoBuyer_Query_graphql.Internal.convertResponse, data);
}

function retain(environment, variables) {
  var operationDescriptor = RelayRuntime.createOperationDescriptor(MyInfoBuyer_Query_graphql.node, MyInfoBuyer_Query_graphql.Internal.convertVariables(variables));
  return environment.retain(operationDescriptor);
}

var Query = {
  Operation: undefined,
  Types: undefined,
  use: use,
  useLoader: useLoader,
  $$fetch: $$fetch,
  fetchPromised: fetchPromised,
  usePreloaded: usePreloaded,
  retain: retain
};

function MyInfo_Buyer$PC(Props) {
  var to = new Date();
  var from = SubMonths(to, 1);
  var queryData = use({
        from: Format(from, "yyyyMMdd"),
        to: Format(to, "yyyyMMdd")
      }, undefined, undefined, undefined, undefined);
  var match = queryData.viewer;
  if (match === undefined) {
    return React.createElement(MyInfo_Skeleton_Buyer.PC.make, {});
  }
  var query = match.fragmentRefs;
  var oldUI = React.createElement(MyInfo_Layout_Buyer.make, {
        query: query,
        children: React.createElement("div", {
              className: "ml-4 flex flex-col w-full items-stretch"
            }, React.createElement("div", {
                  className: "w-full bg-white"
                }, React.createElement(MyInfo_Cash_Remain_Buyer.PC.make, {
                      query: query
                    })), React.createElement("div", {
                  className: "w-full mt-4 bg-white"
                }, React.createElement(MyInfo_Processing_Order_Buyer.PC.make, {
                      query: query
                    })), React.createElement(MyInfo_Profile_Complete_Buyer.PC.make, {
                  query: query
                }))
      });
  return React.createElement(FeatureFlagWrapper.make, {
              children: React.createElement(MyInfo_Layout_Buyer.make, {
                    query: query,
                    children: React.createElement("div", {
                          className: "flex flex-col w-full mb-14"
                        }, React.createElement("div", {
                              className: "w-full rounded-sm bg-white shadow-[0px_10px_40px_10px_rgba(0,0,0,0.03)] mb-4 px-[50px] pt-10 pb-5"
                            }, React.createElement("div", {
                                  className: "flex flex-col"
                                }, React.createElement(FormulaComponents.Text, {
                                      className: "mb-[15px]",
                                      variant: "headline",
                                      size: "lg",
                                      weight: "bold",
                                      children: "마이홈"
                                    }), React.createElement(MyInfo_ProfileSummary_Buyer.PC.make, {
                                      query: query
                                    }))), React.createElement("div", {
                              className: "w-full rounded-sm bg-white shadow-[0px_10px_40px_10px_rgba(0,0,0,0.03)] mb-4 px-[22px]"
                            }, React.createElement(MyInfo_Cash_Remain_Buyer.PC.make, {
                                  query: query
                                })), React.createElement("div", {
                              className: "w-full rounded-sm bg-white shadow-[0px_10px_40px_10px_rgba(0,0,0,0.03)] mb-4 px-[26px]"
                            }, React.createElement(MyInfo_Processing_Order_Buyer.PC.make, {
                                  query: query
                                })), React.createElement(MyInfo_Profile_Complete_Buyer.PC.make, {
                              query: query
                            }))
                  }),
              fallback: oldUI,
              featureFlag: "HOME_UI_UX"
            });
}

var PC = {
  make: MyInfo_Buyer$PC
};

function MyInfo_Buyer$Mobile$Main(Props) {
  var query = Props.query;
  return React.createElement("section", undefined, React.createElement("div", {
                  className: "px-5 pt-5 pb-6"
                }, React.createElement("div", {
                      className: "mb-10"
                    }, React.createElement(MyInfo_ProfileSummary_Buyer.Mobile.make, {
                          query: query
                        })), React.createElement("div", {
                      className: "mb-12"
                    }, React.createElement(MyInfo_Cash_Remain_Buyer.Mobile.make, {
                          query: query
                        })), React.createElement("div", {
                      className: "mb-12"
                    }, React.createElement(MyInfo_Processing_Order_Buyer.Mobile.make, {
                          query: query
                        })), React.createElement(MyInfo_Profile_Complete_Buyer.Mobile.make, {
                      query: query
                    })), React.createElement("div", {
                  className: "h-3 bg-gray-100"
                }));
}

var Main = {
  make: MyInfo_Buyer$Mobile$Main
};

function MyInfo_Buyer$Mobile(Props) {
  var to = new Date();
  var from = SubMonths(to, 1);
  var queryData = use({
        from: Format(from, "yyyyMMdd"),
        to: Format(to, "yyyyMMdd")
      }, undefined, undefined, undefined, undefined);
  var viewer = queryData.viewer;
  if (viewer !== undefined) {
    return React.createElement("div", {
                className: "w-full bg-white absolute top-0 pt-14 min-h-screen"
              }, React.createElement("div", {
                    className: "w-full max-w-3xl mx-auto bg-white h-full"
                  }, React.createElement("div", undefined, React.createElement("div", {
                            className: "flex flex-col"
                          }, React.createElement(MyInfo_Buyer$Mobile$Main, {
                                query: viewer.fragmentRefs
                              }), React.createElement("section", {
                                className: "px-4 mb-[60px]"
                              }, React.createElement("ol", undefined, React.createElement(Link, {
                                        href: "/buyer/me/account",
                                        children: React.createElement("li", {
                                              className: "py-5 flex justify-between items-center border-b border-gray-100"
                                            }, React.createElement("span", {
                                                  className: "font-bold"
                                                }, "계정정보"), React.createElement(IconArrow.make, {
                                                  height: "16",
                                                  width: "16",
                                                  fill: "#B2B2B2"
                                                }))
                                      }), React.createElement(Link, {
                                        href: "/buyer/upload",
                                        children: React.createElement("li", {
                                              className: "py-5 flex justify-between items-center border-b border-gray-100"
                                            }, React.createElement("span", {
                                                  className: "font-bold"
                                                }, "주문서 업로드"), React.createElement(IconArrow.make, {
                                                  height: "16",
                                                  width: "16",
                                                  fill: "#B2B2B2"
                                                }))
                                      }), React.createElement(Link, {
                                        href: "/buyer/orders",
                                        children: React.createElement("li", {
                                              className: "py-5 flex justify-between items-center border-b border-gray-100"
                                            }, React.createElement("span", {
                                                  className: "font-bold"
                                                }, "주문 내역"), React.createElement(IconArrow.make, {
                                                  height: "16",
                                                  width: "16",
                                                  fill: "#B2B2B2"
                                                }))
                                      }), React.createElement(Link, {
                                        href: "/buyer/transactions",
                                        children: React.createElement("li", {
                                              className: "py-5 flex justify-between items-center border-b border-gray-100"
                                            }, React.createElement("span", {
                                                  className: "font-bold"
                                                }, "결제 내역"), React.createElement(IconArrow.make, {
                                                  height: "16",
                                                  width: "16",
                                                  fill: "#B2B2B2"
                                                }))
                                      }), React.createElement(Link, {
                                        href: "/products/advanced-search",
                                        children: React.createElement("li", {
                                              className: "py-5 flex justify-between items-center border-b border-gray-100"
                                            }, React.createElement("span", {
                                                  className: "font-bold"
                                                }, "단품 확인"), React.createElement(IconArrow.make, {
                                                  height: "16",
                                                  width: "16",
                                                  fill: "#B2B2B2"
                                                }))
                                      }), React.createElement(Link, {
                                        href: "/buyer/me/like?mode=VIEW",
                                        children: React.createElement("li", {
                                              className: "py-5 flex justify-between items-center border-b border-gray-100"
                                            }, React.createElement("span", {
                                                  className: "font-bold"
                                                }, "찜한 상품"), React.createElement(IconArrow.make, {
                                                  height: "16",
                                                  width: "16",
                                                  fill: "#B2B2B2"
                                                }))
                                      }), React.createElement(Link, {
                                        href: "/buyer/me/recent-view?mode=VIEW",
                                        children: React.createElement("li", {
                                              className: "py-5 flex justify-between items-center border-b border-gray-100"
                                            }, React.createElement("span", {
                                                  className: "font-bold"
                                                }, "최근 본 상품"), React.createElement(IconArrow.make, {
                                                  height: "16",
                                                  width: "16",
                                                  fill: "#B2B2B2"
                                                }))
                                      }), React.createElement(Link, {
                                        href: "/buyer/download-center",
                                        children: React.createElement("li", {
                                              className: "py-5 flex justify-between items-center border-b border-gray-100"
                                            }, React.createElement("span", {
                                                  className: "font-bold"
                                                }, "다운로드 센터"), React.createElement(IconArrow.make, {
                                                  height: "16",
                                                  width: "16",
                                                  fill: "#B2B2B2"
                                                }))
                                      }), React.createElement(Link, {
                                        href: "https://drive.google.com/drive/u/0/folders/1DbaGUxpkYnJMrl4RPKRzpCqTfTUH7bYN",
                                        children: React.createElement("a", {
                                              rel: "noopener",
                                              target: "_blank"
                                            }, React.createElement("li", {
                                                  className: "py-5 flex justify-between items-center border-b border-gray-100"
                                                }, React.createElement("span", {
                                                      className: "font-bold"
                                                    }, "판매자료 다운로드"), React.createElement(IconArrow.make, {
                                                      height: "16",
                                                      width: "16",
                                                      fill: "#B2B2B2"
                                                    })))
                                      }), React.createElement(Link, {
                                        href: "https://shinsunmarket.co.kr/532",
                                        children: React.createElement("a", {
                                              target: "_blank"
                                            }, React.createElement("li", {
                                                  className: "py-5 flex justify-between items-center border-b border-gray-100"
                                                }, React.createElement("span", {
                                                      className: "font-bold"
                                                    }, "공지사항"), React.createElement(IconArrow.make, {
                                                      height: "16",
                                                      width: "16",
                                                      fill: "#B2B2B2"
                                                    })))
                                      }), React.createElement("li", {
                                        className: "py-5 flex justify-between items-center border-b border-gray-100",
                                        onClick: (function (param) {
                                            ChannelTalk.showMessenger(undefined);
                                          })
                                      }, React.createElement("span", {
                                            className: "font-bold"
                                          }, "1:1 문의하기"), React.createElement(IconArrow.make, {
                                            height: "16",
                                            width: "16",
                                            fill: "#B2B2B2"
                                          }))))))));
  } else {
    return null;
  }
}

var Mobile = {
  Main: Main,
  make: MyInfo_Buyer$Mobile
};

function $$default(param) {
  var deviceType = param.deviceType;
  var router = Router.useRouter();
  if (deviceType !== 1) {
    return React.createElement("div", {
                className: "w-full min-h-screen"
              }, React.createElement(Header_Buyer.Mobile.make, {
                    key: router.asPath
                  }), React.createElement(Authorization.Buyer.make, {
                    children: React.createElement(RescriptReactErrorBoundary.make, {
                          children: React.createElement(React.Suspense, {
                                children: React.createElement(MyInfo_Buyer$Mobile, {}),
                                fallback: React.createElement(MyInfo_Skeleton_Buyer.Mobile.Main.make, {})
                              }),
                          fallback: (function (param) {
                              return React.createElement("div", undefined, "계정정보를 가져오는데 실패했습니다");
                            })
                        }),
                    ssrFallback: React.createElement(MyInfo_Skeleton_Buyer.Mobile.Main.make, {})
                  }), React.createElement(Bottom_Navbar.make, {
                    deviceType: deviceType
                  }));
  }
  var oldUI = React.createElement("div", {
        className: "w-full min-h-screen"
      }, React.createElement(Header_Buyer.PC.make, {
            key: router.asPath
          }), React.createElement(Authorization.Buyer.make, {
            children: React.createElement(RescriptReactErrorBoundary.make, {
                  children: React.createElement(React.Suspense, {
                        children: React.createElement(MyInfo_Buyer$PC, {}),
                        fallback: React.createElement(MyInfo_Skeleton_Buyer.PC.make, {})
                      }),
                  fallback: (function (param) {
                      return React.createElement("div", undefined, "계정정보를 가져오는데 실패했습니다");
                    })
                }),
            ssrFallback: React.createElement(MyInfo_Skeleton_Buyer.PC.make, {})
          }), React.createElement(Footer_Buyer.PC.make, {}));
  return React.createElement(FeatureFlagWrapper.make, {
              children: React.createElement("div", {
                    className: "w-full min-h-screen bg-[#F0F2F5]"
                  }, React.createElement(Header_Buyer.PC.make, {
                        key: router.asPath
                      }), React.createElement(Authorization.Buyer.make, {
                        children: React.createElement(RescriptReactErrorBoundary.make, {
                              children: React.createElement(React.Suspense, {
                                    children: React.createElement(MyInfo_Buyer$PC, {}),
                                    fallback: React.createElement(MyInfo_Skeleton_Buyer.PC.make, {})
                                  }),
                              fallback: (function (param) {
                                  return React.createElement("div", undefined, "계정정보를 가져오는데 실패했습니다");
                                })
                            }),
                        ssrFallback: React.createElement(MyInfo_Skeleton_Buyer.PC.make, {})
                      }), React.createElement(Footer_Buyer.PC.make, {})),
              fallback: oldUI,
              featureFlag: "HOME_UI_UX"
            });
}

function getServerSideProps(ctx) {
  var environment = RelayEnv.environment({
        TAG: /* SinsunMarket */0,
        _0: Env.graphqlApiUrl
      });
  var gnbAndCategoryQuery = ServerSideHelper.gnbAndCategory(environment);
  var deviceType = DeviceDetect.detectDeviceFromCtx2(ctx.req);
  return ServerSideHelper.makeResultWithQuery(gnbAndCategoryQuery, environment, {
              deviceType: deviceType
            });
}

export {
  Query ,
  PC ,
  Mobile ,
  $$default ,
  $$default as default,
  getServerSideProps ,
}
/* Env Not a pure module */
