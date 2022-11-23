// Generated by ReScript, PLEASE EDIT WITH CARE

import * as React from "react";
import * as Caml_obj from "rescript/lib/es6/caml_obj.js";
import * as IconArrow from "../../../../components/svgs/IconArrow.mjs";
import * as Belt_Array from "rescript/lib/es6/belt_Array.js";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as Router from "next/router";
import * as ReactRelay from "react-relay";
import * as Js_null_undefined from "rescript/lib/es6/js_null_undefined.js";
import * as FeatureFlagWrapper from "../../pc/FeatureFlagWrapper.mjs";
import * as MyInfo_Layout_Buyer from "./MyInfo_Layout_Buyer.mjs";
import * as Update_Manager_Buyer from "../../../../components/Update_Manager_Buyer.mjs";
import * as Update_ShopURL_Buyer from "../../../../components/Update_ShopURL_Buyer.mjs";
import * as RescriptRelay_Internal from "rescript-relay/src/RescriptRelay_Internal.mjs";
import * as Update_CompanyName_Buyer from "../../../../components/Update_CompanyName_Buyer.mjs";
import * as Update_SectorAndSale_Buyer from "../../../../components/Update_SectorAndSale_Buyer.mjs";
import * as MyInfo_ProfilePicture_Buyer from "./MyInfo_ProfilePicture_Buyer.mjs";
import * as Update_InterestedCategories_Buyer from "../../../../components/Update_InterestedCategories_Buyer.mjs";
import * as MyInfoProfileBuyer_Fragment_graphql from "../../../../__generated__/MyInfoProfileBuyer_Fragment_graphql.mjs";
import WriteSvg from "../../../../../public/assets/write.svg";

function use(fRef) {
  var data = ReactRelay.useFragment(MyInfoProfileBuyer_Fragment_graphql.node, fRef);
  return RescriptRelay_Internal.internal_useConvertedValue(MyInfoProfileBuyer_Fragment_graphql.Internal.convertFragment, data);
}

function useOpt(opt_fRef) {
  var fr = opt_fRef !== undefined ? Caml_option.some(Caml_option.valFromOption(opt_fRef)) : undefined;
  var nullableFragmentData = ReactRelay.useFragment(MyInfoProfileBuyer_Fragment_graphql.node, fr !== undefined ? Js_null_undefined.fromOption(Caml_option.some(Caml_option.valFromOption(fr))) : null);
  var data = (nullableFragmentData == null) ? undefined : Caml_option.some(nullableFragmentData);
  return RescriptRelay_Internal.internal_useConvertedValue((function (rawFragment) {
                if (rawFragment !== undefined) {
                  return MyInfoProfileBuyer_Fragment_graphql.Internal.convertFragment(rawFragment);
                }
                
              }), data);
}

var Fragment_selfReportedBusinessSector_decode = MyInfoProfileBuyer_Fragment_graphql.Utils.selfReportedBusinessSector_decode;

var Fragment_selfReportedBusinessSector_fromString = MyInfoProfileBuyer_Fragment_graphql.Utils.selfReportedBusinessSector_fromString;

var Fragment_selfReportedSalesBin_decode = MyInfoProfileBuyer_Fragment_graphql.Utils.selfReportedSalesBin_decode;

var Fragment_selfReportedSalesBin_fromString = MyInfoProfileBuyer_Fragment_graphql.Utils.selfReportedSalesBin_fromString;

var Fragment = {
  selfReportedBusinessSector_decode: Fragment_selfReportedBusinessSector_decode,
  selfReportedBusinessSector_fromString: Fragment_selfReportedBusinessSector_fromString,
  selfReportedSalesBin_decode: Fragment_selfReportedSalesBin_decode,
  selfReportedSalesBin_fromString: Fragment_selfReportedSalesBin_fromString,
  Types: undefined,
  Operation: undefined,
  use: use,
  useOpt: useOpt
};

var writeIcon = WriteSvg;

function MyInfo_Profile_Buyer$PC(Props) {
  var query = Props.query;
  var match = React.useState(function () {
        
      });
  var setOpenModal = match[1];
  var openModal = match[0];
  var match$1 = use(query);
  var shopUrl = match$1.shopUrl;
  var saleBin = match$1.selfReportedSalesBin;
  var displayCategories = Belt_Array.map(Belt_Option.getWithDefault(match$1.interestedItemCategories, []), (function (param) {
            return param.name;
          })).join(",");
  var displaySectors = Belt_Array.map(Belt_Option.getWithDefault(match$1.selfReportedBusinessSectors, []), (function (param) {
            return param.label;
          })).join(",");
  var tmp = {
    isOpen: Caml_obj.equal(openModal, /* ShopUrl */2),
    onClose: (function (param) {
        setOpenModal(function (param) {
              
            });
      })
  };
  if (shopUrl !== undefined) {
    tmp.defaultValue = Caml_option.valFromOption(shopUrl);
  }
  if (shopUrl !== undefined) {
    tmp.key = shopUrl;
  }
  var oldUI = React.createElement(React.Fragment, undefined, React.createElement(MyInfo_Layout_Buyer.make, {
            query: query,
            children: React.createElement("div", {
                  className: "p-7 bg-white ml-4 w-full"
                }, React.createElement("div", {
                      className: "font-bold text-2xl"
                    }, "프로필정보"), React.createElement("div", {
                      className: "py-7 flex flex-col"
                    }, React.createElement("div", {
                          className: "mb-2"
                        }, React.createElement("div", {
                              className: "flex py-5"
                            }, React.createElement("div", {
                                  className: "min-w-[168px] w-1/6 font-bold"
                                }, "관심품목"), React.createElement("div", {
                                  className: "flex items-center"
                                }, displayCategories, React.createElement("button", {
                                      className: "shrink-0",
                                      onClick: (function (param) {
                                          setOpenModal(function (param) {
                                                return /* Categories */1;
                                              });
                                        })
                                    }, React.createElement("img", {
                                          className: "ml-2",
                                          height: "16px",
                                          src: "/assets/write.svg",
                                          width: "16px"
                                        })))), React.createElement("div", {
                              className: "flex py-5"
                            }, React.createElement("div", {
                                  className: "min-w-[168px] w-1/6 font-bold"
                                }, "업종 정보"), React.createElement("div", {
                                  className: "flex items-center"
                                }, displaySectors, React.createElement("button", {
                                      className: "shrink-0",
                                      onClick: (function (param) {
                                          setOpenModal(function (param) {
                                                return /* SectorAndSale */0;
                                              });
                                        })
                                    }, React.createElement("img", {
                                          className: "ml-2",
                                          height: "16px",
                                          src: "/assets/write.svg",
                                          width: "16px"
                                        })))), React.createElement("div", {
                              className: "flex py-5"
                            }, React.createElement("div", {
                                  className: "min-w-[168px] w-1/6 font-bold"
                                }, "연매출 정보"), React.createElement("div", {
                                  className: "flex items-center"
                                }, Belt_Option.mapWithDefault(saleBin, "", (function (param) {
                                        return param.label;
                                      })), React.createElement("button", {
                                      className: "shrink-0",
                                      onClick: (function (param) {
                                          setOpenModal(function (param) {
                                                return /* SectorAndSale */0;
                                              });
                                        })
                                    }, React.createElement("img", {
                                          className: "ml-2",
                                          height: "16px",
                                          src: "/assets/write.svg",
                                          width: "16px"
                                        })))), React.createElement("div", {
                              className: "flex py-5"
                            }, React.createElement("div", {
                                  className: "min-w-[168px] w-1/6 font-bold"
                                }, "쇼핑몰 URL"), React.createElement("div", {
                                  className: "flex items-center"
                                }, Belt_Option.getWithDefault(shopUrl, ""), React.createElement("button", {
                                      className: "shrink-0",
                                      onClick: (function (param) {
                                          setOpenModal(function (param) {
                                                return /* ShopUrl */2;
                                              });
                                        })
                                    }, React.createElement("img", {
                                          className: "ml-2",
                                          height: "16px",
                                          src: "/assets/write.svg",
                                          width: "16px"
                                        })))))))
          }), React.createElement(Update_SectorAndSale_Buyer.make, {
            isOpen: Caml_obj.equal(openModal, /* SectorAndSale */0),
            onClose: (function (param) {
                setOpenModal(function (param) {
                      
                    });
              })
          }), React.createElement(Update_InterestedCategories_Buyer.make, {
            isOpen: Caml_obj.equal(openModal, /* Categories */1),
            onClose: (function (param) {
                setOpenModal(function (param) {
                      
                    });
              })
          }), React.createElement(Update_ShopURL_Buyer.make, tmp));
  var tmp$1 = {
    isOpen: Caml_obj.equal(openModal, /* ShopUrl */2),
    onClose: (function (param) {
        setOpenModal(function (param) {
              
            });
      })
  };
  if (shopUrl !== undefined) {
    tmp$1.defaultValue = Caml_option.valFromOption(shopUrl);
  }
  if (shopUrl !== undefined) {
    tmp$1.key = shopUrl;
  }
  return React.createElement(FeatureFlagWrapper.make, {
              children: React.createElement(React.Fragment, undefined, React.createElement(MyInfo_Layout_Buyer.make, {
                        query: query,
                        children: React.createElement("div", {
                              className: "py-10 px-[50px] bg-white w-full rounded-sm shadow-[0px_10px_40px_10px_rgba(0,0,0,0.03)]"
                            }, React.createElement("div", {
                                  className: "font-bold text-[26px]"
                                }, "프로필정보"), React.createElement("div", {
                                  className: "py-7 flex flex-col"
                                }, React.createElement("div", {
                                      className: "mb-2"
                                    }, React.createElement("div", {
                                          className: "flex py-5"
                                        }, React.createElement("div", {
                                              className: "min-w-[168px] w-1/6 font-bold"
                                            }, "관심품목"), React.createElement("div", {
                                              className: "flex items-center"
                                            }, displayCategories, React.createElement("button", {
                                                  className: "shrink-0",
                                                  onClick: (function (param) {
                                                      setOpenModal(function (param) {
                                                            return /* Categories */1;
                                                          });
                                                    })
                                                }, React.createElement("img", {
                                                      className: "ml-2",
                                                      height: "16px",
                                                      src: "/assets/write.svg",
                                                      width: "16px"
                                                    })))), React.createElement("div", {
                                          className: "flex py-5"
                                        }, React.createElement("div", {
                                              className: "min-w-[168px] w-1/6 font-bold"
                                            }, "업종 정보"), React.createElement("div", {
                                              className: "flex items-center"
                                            }, displaySectors, React.createElement("button", {
                                                  className: "shrink-0",
                                                  onClick: (function (param) {
                                                      setOpenModal(function (param) {
                                                            return /* SectorAndSale */0;
                                                          });
                                                    })
                                                }, React.createElement("img", {
                                                      className: "ml-2",
                                                      height: "16px",
                                                      src: "/assets/write.svg",
                                                      width: "16px"
                                                    })))), React.createElement("div", {
                                          className: "flex py-5"
                                        }, React.createElement("div", {
                                              className: "min-w-[168px] w-1/6 font-bold"
                                            }, "연매출 정보"), React.createElement("div", {
                                              className: "flex items-center"
                                            }, Belt_Option.mapWithDefault(saleBin, "", (function (param) {
                                                    return param.label;
                                                  })), React.createElement("button", {
                                                  className: "shrink-0",
                                                  onClick: (function (param) {
                                                      setOpenModal(function (param) {
                                                            return /* SectorAndSale */0;
                                                          });
                                                    })
                                                }, React.createElement("img", {
                                                      className: "ml-2",
                                                      height: "16px",
                                                      src: "/assets/write.svg",
                                                      width: "16px"
                                                    })))), React.createElement("div", {
                                          className: "flex py-5"
                                        }, React.createElement("div", {
                                              className: "min-w-[168px] w-1/6 font-bold"
                                            }, "쇼핑몰 URL"), React.createElement("div", {
                                              className: "flex items-center"
                                            }, Belt_Option.getWithDefault(shopUrl, ""), React.createElement("button", {
                                                  className: "shrink-0",
                                                  onClick: (function (param) {
                                                      setOpenModal(function (param) {
                                                            return /* ShopUrl */2;
                                                          });
                                                    })
                                                }, React.createElement("img", {
                                                      className: "ml-2",
                                                      height: "16px",
                                                      src: "/assets/write.svg",
                                                      width: "16px"
                                                    })))))))
                      }), React.createElement(Update_SectorAndSale_Buyer.make, {
                        isOpen: Caml_obj.equal(openModal, /* SectorAndSale */0),
                        onClose: (function (param) {
                            setOpenModal(function (param) {
                                  
                                });
                          })
                      }), React.createElement(Update_InterestedCategories_Buyer.make, {
                        isOpen: Caml_obj.equal(openModal, /* Categories */1),
                        onClose: (function (param) {
                            setOpenModal(function (param) {
                                  
                                });
                          })
                      }), React.createElement(Update_ShopURL_Buyer.make, tmp$1)),
              fallback: oldUI,
              featureFlag: "HOME_UI_UX"
            });
}

var PC = {
  make: MyInfo_Profile_Buyer$PC
};

function toFragment(modal) {
  switch (modal) {
    case /* SectorAndSale */0 :
        return "#sector";
    case /* Categories */1 :
        return "#categories";
    case /* Company */2 :
        return "#company";
    case /* Manager */3 :
        return "#manager";
    case /* ShopUrl */4 :
        return "#shopurl";
    
  }
}

function MyInfo_Profile_Buyer$Mobile(Props) {
  var query = Props.query;
  var router = Router.useRouter();
  var match = React.useState(function () {
        
      });
  var setOpenModal = match[1];
  var openModal = match[0];
  var match$1 = use(query);
  var shopUrl = match$1.shopUrl;
  var company = match$1.name;
  var manager = match$1.manager;
  var displayCategories = Belt_Array.map(Belt_Option.getWithDefault(match$1.interestedItemCategories, []), (function (param) {
            return param.name;
          })).join(", ");
  var displaySectors = Belt_Array.map(Belt_Option.getWithDefault(match$1.selfReportedBusinessSectors, []), (function (param) {
            return param.label;
          })).join(", ");
  var open_ = function (modal) {
    if (!router.asPath.includes(toFragment(modal))) {
      router.push("" + router.asPath + "" + toFragment(modal) + "");
    }
    setOpenModal(function (param) {
          return modal;
        });
  };
  React.useEffect((function () {
          if (!router.asPath.includes("#") && Belt_Option.isSome(openModal)) {
            setOpenModal(function (param) {
                  
                });
          }
          
        }), [router.asPath]);
  var tmp = {
    isOpen: Caml_obj.equal(openModal, /* Manager */3),
    onClose: (function (param) {
        router.back();
      })
  };
  if (manager !== undefined) {
    tmp.defaultValue = Caml_option.valFromOption(manager);
  }
  if (manager !== undefined) {
    tmp.key = manager;
  }
  var tmp$1 = {
    isOpen: Caml_obj.equal(openModal, /* ShopUrl */4),
    onClose: (function (param) {
        router.back();
      })
  };
  if (shopUrl !== undefined) {
    tmp$1.defaultValue = Caml_option.valFromOption(shopUrl);
  }
  if (shopUrl !== undefined) {
    tmp$1.key = shopUrl;
  }
  return React.createElement(React.Fragment, undefined, React.createElement("div", {
                  className: "block w-full bg-white absolute top-0 pt-14 min-h-screen"
                }, React.createElement("div", {
                      className: "w-full max-w-3xl mx-auto bg-white h-full"
                    }, React.createElement("section", undefined, React.createElement("div", {
                              className: "py-10 flex flex-col items-center"
                            }, React.createElement(MyInfo_ProfilePicture_Buyer.make, {
                                  content: company,
                                  size: /* XLarge */2
                                }), React.createElement("button", {
                                  className: "mt-3 flex items-center",
                                  onClick: (function (param) {
                                      open_(/* Manager */3);
                                    })
                                }, React.createElement("span", {
                                      className: "font-bold text-gray-800 text-lg"
                                    }, Belt_Option.getWithDefault(manager, "")), React.createElement("img", {
                                      className: "ml-1",
                                      height: "16px",
                                      src: "/assets/write.svg",
                                      width: "16px"
                                    })), React.createElement("button", {
                                  className: "mt-1 flex items-center",
                                  onClick: (function (param) {
                                      open_(/* Company */2);
                                    })
                                }, React.createElement("span", {
                                      className: "text-gray-800"
                                    }, company), React.createElement("img", {
                                      className: "ml-1",
                                      height: "16px",
                                      src: "/assets/write.svg",
                                      width: "16px"
                                    })), React.createElement("div", {
                                  className: ""
                                }, React.createElement("span", {
                                      className: "text-gray-600 text-sm"
                                    }, match$1.uid))), React.createElement("div", {
                              className: "h-3 bg-gray-100"
                            }), React.createElement("ul", undefined, React.createElement("li", undefined, React.createElement("button", {
                                      className: "w-full py-[18px] px-4 flex items-center justify-between",
                                      onClick: (function (param) {
                                          open_(/* Categories */1);
                                        })
                                    }, React.createElement("div", {
                                          className: "flex items-center w-[calc(100%-16px)]"
                                        }, React.createElement("div", {
                                              className: "shrink-0"
                                            }, React.createElement("span", {
                                                  className: "font-bold"
                                                }, "관심품목")), React.createElement("div", {
                                              className: "text-gray-600 text-sm shrink ml-2 truncate"
                                            }, displayCategories)), React.createElement(IconArrow.make, {
                                          height: "16",
                                          width: "16",
                                          fill: "#B2B2B2"
                                        }))), React.createElement("li", undefined, React.createElement("button", {
                                      className: "w-full py-[18px] px-4 flex items-center justify-between",
                                      onClick: (function (param) {
                                          open_(/* SectorAndSale */0);
                                        })
                                    }, React.createElement("div", {
                                          className: "flex items-center w-[calc(100%-16px)]"
                                        }, React.createElement("div", {
                                              className: "shrink-0"
                                            }, React.createElement("span", {
                                                  className: "font-bold"
                                                }, "업종 정보")), React.createElement("div", {
                                              className: "text-gray-600 text-sm shrink mx-2 truncate"
                                            }, displaySectors)), React.createElement(IconArrow.make, {
                                          height: "16",
                                          width: "16",
                                          fill: "#B2B2B2"
                                        }))), React.createElement("li", undefined, React.createElement("button", {
                                      className: "w-full py-[18px] px-4 flex items-center justify-between",
                                      onClick: (function (param) {
                                          open_(/* SectorAndSale */0);
                                        })
                                    }, React.createElement("div", {
                                          className: "flex items-center"
                                        }, React.createElement("div", {
                                              className: "shrink-0"
                                            }, React.createElement("span", {
                                                  className: "font-bold"
                                                }, "연매출 정보")), React.createElement("div", {
                                              className: "text-gray-600 text-sm shrink mx-2 truncate"
                                            }, Belt_Option.mapWithDefault(match$1.selfReportedSalesBin, "", (function (param) {
                                                    return param.label;
                                                  })))), React.createElement(IconArrow.make, {
                                          height: "16",
                                          width: "16",
                                          fill: "#B2B2B2"
                                        }))), React.createElement("li", undefined, React.createElement("button", {
                                      className: "w-full py-[18px] px-4 flex items-center justify-between",
                                      onClick: (function (param) {
                                          open_(/* ShopUrl */4);
                                        })
                                    }, React.createElement("div", {
                                          className: "flex items-center"
                                        }, React.createElement("div", {
                                              className: "shrink-0"
                                            }, React.createElement("span", {
                                                  className: "font-bold"
                                                }, "쇼핑몰URL")), React.createElement("div", {
                                              className: "text-gray-600 text-sm shrink mx-2 truncate"
                                            }, Belt_Option.getWithDefault(shopUrl, ""))), React.createElement(IconArrow.make, {
                                          height: "16",
                                          width: "16",
                                          fill: "#B2B2B2"
                                        }))))))), React.createElement(Update_SectorAndSale_Buyer.make, {
                  isOpen: Caml_obj.equal(openModal, /* SectorAndSale */0),
                  onClose: (function (param) {
                      router.back();
                    })
                }), React.createElement(Update_InterestedCategories_Buyer.make, {
                  isOpen: Caml_obj.equal(openModal, /* Categories */1),
                  onClose: (function (param) {
                      router.back();
                    })
                }), React.createElement(Update_CompanyName_Buyer.make, {
                  isOpen: Caml_obj.equal(openModal, /* Company */2),
                  onClose: (function (param) {
                      router.back();
                    }),
                  defaultValue: company,
                  key: company
                }), React.createElement(Update_Manager_Buyer.make, tmp), React.createElement(Update_ShopURL_Buyer.make, tmp$1));
}

var Mobile = {
  toFragment: toFragment,
  make: MyInfo_Profile_Buyer$Mobile
};

export {
  Fragment ,
  writeIcon ,
  PC ,
  Mobile ,
}
/* writeIcon Not a pure module */
