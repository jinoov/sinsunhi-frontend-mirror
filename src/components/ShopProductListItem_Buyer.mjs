// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Cn from "rescript-classnames/src/Cn.mjs";
import * as Curry from "rescript/lib/es6/curry.js";
import * as $$Image from "./common/Image.mjs";
import * as React from "react";
import * as Locale from "../utils/Locale.mjs";
import * as Skeleton from "./Skeleton.mjs";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as CustomHooks from "../utils/CustomHooks.mjs";
import * as Router from "next/router";
import * as ReactRelay from "react-relay";
import * as Product_Parser from "../utils/Product_Parser.mjs";
import * as Js_null_undefined from "rescript/lib/es6/js_null_undefined.js";
import * as RescriptRelay_Internal from "rescript-relay/src/RescriptRelay_Internal.mjs";
import * as ShopProductListItemBuyerFragment_graphql from "../__generated__/ShopProductListItemBuyerFragment_graphql.mjs";
import * as ShopProductListItemBuyerNormalFragment_graphql from "../__generated__/ShopProductListItemBuyerNormalFragment_graphql.mjs";
import * as ShopProductListItemBuyerQuotedFragment_graphql from "../__generated__/ShopProductListItemBuyerQuotedFragment_graphql.mjs";
import * as ShopProductListItemBuyerMatchingFragment_graphql from "../__generated__/ShopProductListItemBuyerMatchingFragment_graphql.mjs";

function use(fRef) {
  var data = ReactRelay.useFragment(ShopProductListItemBuyerFragment_graphql.node, fRef);
  return RescriptRelay_Internal.internal_useConvertedValue(ShopProductListItemBuyerFragment_graphql.Internal.convertFragment, data);
}

function useOpt(opt_fRef) {
  var fr = opt_fRef !== undefined ? Caml_option.some(Caml_option.valFromOption(opt_fRef)) : undefined;
  var nullableFragmentData = ReactRelay.useFragment(ShopProductListItemBuyerFragment_graphql.node, fr !== undefined ? Js_null_undefined.fromOption(Caml_option.some(Caml_option.valFromOption(fr))) : null);
  var data = (nullableFragmentData == null) ? undefined : Caml_option.some(nullableFragmentData);
  return RescriptRelay_Internal.internal_useConvertedValue((function (rawFragment) {
                if (rawFragment !== undefined) {
                  return ShopProductListItemBuyerFragment_graphql.Internal.convertFragment(rawFragment);
                }
                
              }), data);
}

var Root = {
  Types: undefined,
  Operation: undefined,
  use: use,
  useOpt: useOpt
};

function use$1(fRef) {
  var data = ReactRelay.useFragment(ShopProductListItemBuyerNormalFragment_graphql.node, fRef);
  return RescriptRelay_Internal.internal_useConvertedValue(ShopProductListItemBuyerNormalFragment_graphql.Internal.convertFragment, data);
}

function useOpt$1(opt_fRef) {
  var fr = opt_fRef !== undefined ? Caml_option.some(Caml_option.valFromOption(opt_fRef)) : undefined;
  var nullableFragmentData = ReactRelay.useFragment(ShopProductListItemBuyerNormalFragment_graphql.node, fr !== undefined ? Js_null_undefined.fromOption(Caml_option.some(Caml_option.valFromOption(fr))) : null);
  var data = (nullableFragmentData == null) ? undefined : Caml_option.some(nullableFragmentData);
  return RescriptRelay_Internal.internal_useConvertedValue((function (rawFragment) {
                if (rawFragment !== undefined) {
                  return ShopProductListItemBuyerNormalFragment_graphql.Internal.convertFragment(rawFragment);
                }
                
              }), data);
}

var Normal_productStatus_decode = ShopProductListItemBuyerNormalFragment_graphql.Utils.productStatus_decode;

var Normal_productStatus_fromString = ShopProductListItemBuyerNormalFragment_graphql.Utils.productStatus_fromString;

var Normal = {
  productStatus_decode: Normal_productStatus_decode,
  productStatus_fromString: Normal_productStatus_fromString,
  Types: undefined,
  Operation: undefined,
  use: use$1,
  useOpt: useOpt$1
};

function use$2(fRef) {
  var data = ReactRelay.useFragment(ShopProductListItemBuyerQuotedFragment_graphql.node, fRef);
  return RescriptRelay_Internal.internal_useConvertedValue(ShopProductListItemBuyerQuotedFragment_graphql.Internal.convertFragment, data);
}

function useOpt$2(opt_fRef) {
  var fr = opt_fRef !== undefined ? Caml_option.some(Caml_option.valFromOption(opt_fRef)) : undefined;
  var nullableFragmentData = ReactRelay.useFragment(ShopProductListItemBuyerQuotedFragment_graphql.node, fr !== undefined ? Js_null_undefined.fromOption(Caml_option.some(Caml_option.valFromOption(fr))) : null);
  var data = (nullableFragmentData == null) ? undefined : Caml_option.some(nullableFragmentData);
  return RescriptRelay_Internal.internal_useConvertedValue((function (rawFragment) {
                if (rawFragment !== undefined) {
                  return ShopProductListItemBuyerQuotedFragment_graphql.Internal.convertFragment(rawFragment);
                }
                
              }), data);
}

var Quoted_productStatus_decode = ShopProductListItemBuyerQuotedFragment_graphql.Utils.productStatus_decode;

var Quoted_productStatus_fromString = ShopProductListItemBuyerQuotedFragment_graphql.Utils.productStatus_fromString;

var Quoted = {
  productStatus_decode: Quoted_productStatus_decode,
  productStatus_fromString: Quoted_productStatus_fromString,
  Types: undefined,
  Operation: undefined,
  use: use$2,
  useOpt: useOpt$2
};

function use$3(fRef) {
  var data = ReactRelay.useFragment(ShopProductListItemBuyerMatchingFragment_graphql.node, fRef);
  return RescriptRelay_Internal.internal_useConvertedValue(ShopProductListItemBuyerMatchingFragment_graphql.Internal.convertFragment, data);
}

function useOpt$3(opt_fRef) {
  var fr = opt_fRef !== undefined ? Caml_option.some(Caml_option.valFromOption(opt_fRef)) : undefined;
  var nullableFragmentData = ReactRelay.useFragment(ShopProductListItemBuyerMatchingFragment_graphql.node, fr !== undefined ? Js_null_undefined.fromOption(Caml_option.some(Caml_option.valFromOption(fr))) : null);
  var data = (nullableFragmentData == null) ? undefined : Caml_option.some(nullableFragmentData);
  return RescriptRelay_Internal.internal_useConvertedValue((function (rawFragment) {
                if (rawFragment !== undefined) {
                  return ShopProductListItemBuyerMatchingFragment_graphql.Internal.convertFragment(rawFragment);
                }
                
              }), data);
}

var Matching_productStatus_decode = ShopProductListItemBuyerMatchingFragment_graphql.Utils.productStatus_decode;

var Matching_productStatus_fromString = ShopProductListItemBuyerMatchingFragment_graphql.Utils.productStatus_fromString;

var Matching = {
  productStatus_decode: Matching_productStatus_decode,
  productStatus_fromString: Matching_productStatus_fromString,
  Types: undefined,
  Operation: undefined,
  use: use$3,
  useOpt: useOpt$3
};

var Fragments = {
  Root: Root,
  Normal: Normal,
  Quoted: Quoted,
  Matching: Matching
};

function ShopProductListItem_Buyer$StatusLabel(props) {
  return React.createElement(React.Fragment, undefined, React.createElement("div", {
                  className: "w-full h-full absolute top-0 left-0 bg-white opacity-40 rounded-xl"
                }), React.createElement("div", {
                  className: "absolute bottom-0 w-full h-10 bg-gray-600 flex items-center justify-center opacity-90"
                }, React.createElement("span", {
                      className: "text-white text-xl font-bold"
                    }, props.text)));
}

var StatusLabel = {
  make: ShopProductListItem_Buyer$StatusLabel
};

function ShopProductListItem_Buyer$Normal$PC(props) {
  var router = Router.useRouter();
  var user = Curry._1(CustomHooks.User.Buyer.use2, undefined);
  var match = use$1(props.query);
  var status = match.status;
  var productId = match.productId;
  var priceLabel = Belt_Option.mapWithDefault(match.price, "", (function (price$p) {
          return "" + Locale.Float.show(undefined, price$p, 0) + "원";
        }));
  var tmp;
  if (typeof user === "number") {
    tmp = user !== 0 ? React.createElement("span", {
            className: "mt-2 font-bold text-lg text-green-500"
          }, "공급가 회원공개") : React.createElement(Skeleton.Box.make, {});
  } else {
    var textColor = status === "HIDDEN_SALE" || status === "SOLDOUT" ? " text-gray-400" : " text-text-L1";
    tmp = React.createElement("span", {
          className: "mt-2 font-bold text-lg" + textColor
        }, priceLabel);
  }
  return React.createElement("div", {
              className: "w-[280px] h-[376px] cursor-pointer",
              onClick: (function (param) {
                  var prim1 = "/products/" + String(productId) + "";
                  router.push(prim1);
                })
            }, React.createElement("div", {
                  className: "w-[280px] aspect-square rounded-xl overflow-hidden relative"
                }, React.createElement($$Image.make, {
                      src: match.image.thumb800x800,
                      placeholder: /* Sm */0,
                      loading: /* Lazy */1,
                      alt: "product-" + String(productId) + "",
                      className: "w-full h-full object-cover"
                    }), React.createElement("div", {
                      className: "w-full h-full absolute top-0 left-0 bg-black/[.03] rounded-2xl"
                    }), status === "NOSALE" ? React.createElement(ShopProductListItem_Buyer$StatusLabel, {
                        text: "숨김"
                      }) : (
                    status === "SOLDOUT" ? React.createElement(ShopProductListItem_Buyer$StatusLabel, {
                            text: "품절"
                          }) : (
                        status === "HIDDEN_SALE" ? React.createElement(ShopProductListItem_Buyer$StatusLabel, {
                                text: "비공개 판매"
                              }) : null
                      )
                  )), React.createElement("div", {
                  className: "flex flex-col mt-4"
                }, React.createElement("span", {
                      className: "text-gray-800 line-clamp-2"
                    }, match.displayName), tmp));
}

var PC = {
  make: ShopProductListItem_Buyer$Normal$PC
};

function ShopProductListItem_Buyer$Normal$MO(props) {
  var router = Router.useRouter();
  var user = Curry._1(CustomHooks.User.Buyer.use2, undefined);
  var match = use$1(props.query);
  var status = match.status;
  var productId = match.productId;
  var isSoldout = status === "SOLDOUT";
  var priceLabel = Belt_Option.mapWithDefault(match.price, "", (function (price$p) {
          return "" + Locale.Float.show(undefined, price$p, 0) + "원";
        }));
  var tmp;
  if (typeof user === "number") {
    tmp = user !== 0 ? React.createElement("span", {
            className: "mt-1 font-bold text-green-500"
          }, "공급가 회원공개") : React.createElement(Skeleton.Box.make, {});
  } else {
    var textColor = isSoldout ? " text-gray-400" : " text-text-L1";
    tmp = React.createElement("span", {
          className: "mt-1 font-bold" + textColor
        }, priceLabel);
  }
  return React.createElement("div", {
              className: "cursor-pointer",
              onClick: (function (param) {
                  var prim1 = "/products/" + String(productId) + "";
                  router.push(prim1);
                })
            }, React.createElement("div", {
                  className: "rounded-xl overflow-hidden relative aspect-square"
                }, React.createElement($$Image.make, {
                      src: match.image.thumb800x800,
                      placeholder: /* Sm */0,
                      loading: /* Lazy */1,
                      alt: "product-" + String(productId) + "",
                      className: "w-full h-full object-cover"
                    }), React.createElement("div", {
                      className: "w-full h-full absolute top-0 left-0 bg-black/[.03] rounded-xl"
                    }), status === "NOSALE" ? React.createElement(ShopProductListItem_Buyer$StatusLabel, {
                        text: "숨김"
                      }) : (
                    status === "SOLDOUT" ? React.createElement(ShopProductListItem_Buyer$StatusLabel, {
                            text: "품절"
                          }) : (
                        status === "HIDDEN_SALE" ? React.createElement(ShopProductListItem_Buyer$StatusLabel, {
                                text: "비공개 판매"
                              }) : null
                      )
                  )), React.createElement("div", {
                  className: "flex flex-col mt-3"
                }, React.createElement("span", {
                      className: "text-gray-800 line-clamp-2 text-sm"
                    }, match.displayName), tmp));
}

var MO = {
  make: ShopProductListItem_Buyer$Normal$MO
};

var Normal$1 = {
  PC: PC,
  MO: MO
};

function ShopProductListItem_Buyer$Quoted$PC(props) {
  var router = Router.useRouter();
  var match = use$2(props.query);
  var status = match.status;
  var productId = match.productId;
  return React.createElement("div", {
              className: "w-[280px] h-[376px] cursor-pointer",
              onClick: (function (param) {
                  var prim1 = "/products/" + String(productId) + "";
                  router.push(prim1);
                })
            }, React.createElement("div", {
                  className: "w-[280px] aspect-square rounded-xl overflow-hidden relative"
                }, React.createElement($$Image.make, {
                      src: match.image.thumb800x800,
                      placeholder: /* Sm */0,
                      loading: /* Lazy */1,
                      alt: "product-" + String(productId) + "",
                      className: "w-full h-full object-cover"
                    }), React.createElement("div", {
                      className: "w-full h-full absolute top-0 left-0 bg-black/[.03] rounded-2xl"
                    }), status === "NOSALE" ? React.createElement(ShopProductListItem_Buyer$StatusLabel, {
                        text: "숨김"
                      }) : (
                    status === "SOLDOUT" ? React.createElement(ShopProductListItem_Buyer$StatusLabel, {
                            text: "품절"
                          }) : (
                        status === "HIDDEN_SALE" ? React.createElement(ShopProductListItem_Buyer$StatusLabel, {
                                text: "비공개 판매"
                              }) : null
                      )
                  )), React.createElement("div", {
                  className: "flex flex-col mt-4"
                }, React.createElement("span", {
                      className: "text-gray-800 line-clamp-2"
                    }, match.displayName), React.createElement("span", {
                      className: "mt-2 font-bold text-lg text-blue-500"
                    }, "최저가 견적받기")));
}

var PC$1 = {
  make: ShopProductListItem_Buyer$Quoted$PC
};

function ShopProductListItem_Buyer$Quoted$MO(props) {
  var router = Router.useRouter();
  var match = use$2(props.query);
  var status = match.status;
  var productId = match.productId;
  return React.createElement("div", {
              className: "cursor-pointer",
              onClick: (function (param) {
                  var prim1 = "/products/" + String(productId) + "";
                  router.push(prim1);
                })
            }, React.createElement("div", {
                  className: "rounded-xl overflow-hidden relative aspect-square"
                }, React.createElement($$Image.make, {
                      src: match.image.thumb800x800,
                      placeholder: /* Sm */0,
                      loading: /* Lazy */1,
                      alt: "product-" + String(productId) + "",
                      className: "w-full h-full object-cover"
                    }), React.createElement("div", {
                      className: "w-full h-full absolute top-0 left-0 bg-black/[.03] rounded-xl"
                    }), status === "NOSALE" ? React.createElement(ShopProductListItem_Buyer$StatusLabel, {
                        text: "숨김"
                      }) : (
                    status === "SOLDOUT" ? React.createElement(ShopProductListItem_Buyer$StatusLabel, {
                            text: "품절"
                          }) : (
                        status === "HIDDEN_SALE" ? React.createElement(ShopProductListItem_Buyer$StatusLabel, {
                                text: "비공개 판매"
                              }) : null
                      )
                  )), React.createElement("div", {
                  className: "flex flex-col mt-3"
                }, React.createElement("span", {
                      className: "text-text-L1 line-clamp-2 text-sm"
                    }, match.displayName), React.createElement("span", {
                      className: "mt-1 font-bold text-blue-500"
                    }, "최저가 견적받기")));
}

var MO$1 = {
  make: ShopProductListItem_Buyer$Quoted$MO
};

var Quoted$1 = {
  PC: PC$1,
  MO: MO$1
};

function ShopProductListItem_Buyer$Matching$ProductName$PC(props) {
  return React.createElement("span", {
              className: "text-gray-800 flex-wrap overflow-hidden gap-1"
            }, React.createElement("span", undefined, props.productName), React.createElement("span", undefined, "," + Locale.Float.show(undefined, props.representativeWeight, 1) + "Kg "));
}

var PC$2 = {
  make: ShopProductListItem_Buyer$Matching$ProductName$PC
};

function ShopProductListItem_Buyer$Matching$ProductName$MO(props) {
  return React.createElement("span", {
              className: "text-gray-800 line-clamp-2 text-sm"
            }, React.createElement("span", undefined, props.productName), React.createElement("span", undefined, "," + Locale.Float.show(undefined, props.representativeWeight, 1) + "Kg"));
}

var MO$2 = {
  make: ShopProductListItem_Buyer$Matching$ProductName$MO
};

var ProductName = {
  PC: PC$2,
  MO: MO$2
};

function ShopProductListItem_Buyer$Matching$PriceText$PC(props) {
  return React.createElement("div", {
              className: "inline-flex flex-col"
            }, React.createElement("span", {
                  className: Cn.make([
                        "mt-1 font-bold text-lg",
                        props.isSoldout ? "text-text-L3" : "text-text-L1"
                      ])
                }, "" + Locale.Float.show(undefined, props.price, 0) + "원"), React.createElement("span", {
                  className: "text-sm text-text-L2"
                }, "kg당 " + Locale.Float.show(undefined, props.pricePerKg, 0) + "원"));
}

var PC$3 = {
  make: ShopProductListItem_Buyer$Matching$PriceText$PC
};

function ShopProductListItem_Buyer$Matching$PriceText$MO(props) {
  return React.createElement("div", {
              className: "inline-flex flex-col"
            }, React.createElement("span", {
                  className: Cn.make([
                        "mt-1 font-bold",
                        props.isSoldout ? "text-text-L3" : "text-text-L1"
                      ])
                }, "" + Locale.Float.show(undefined, props.price, 0) + "원"), React.createElement("span", {
                  className: "text-sm text-text-L2"
                }, "kg당 " + Locale.Float.show(undefined, props.pricePerKg, 0) + "원"));
}

var MO$3 = {
  make: ShopProductListItem_Buyer$Matching$PriceText$MO
};

var PriceText = {
  PC: PC$3,
  MO: MO$3
};

function ShopProductListItem_Buyer$Matching$PC(props) {
  var router = Router.useRouter();
  var user = Curry._1(CustomHooks.User.Buyer.use2, undefined);
  var match = use$3(props.query);
  var status = match.status;
  var representativeWeight = match.representativeWeight;
  var productId = match.productId;
  var pricePerKg = match.pricePerKg;
  var price = match.price;
  var tmp;
  var exit = 0;
  if (price !== undefined) {
    if (pricePerKg !== undefined && typeof user !== "number") {
      var isSoldout = status === "SOLDOUT";
      tmp = React.createElement(ShopProductListItem_Buyer$Matching$PriceText$PC, {
            price: price,
            pricePerKg: pricePerKg,
            isSoldout: isSoldout
          });
    } else {
      exit = 1;
    }
  } else if (pricePerKg !== undefined && typeof user !== "number") {
    var isSoldout$1 = status === "SOLDOUT";
    tmp = React.createElement(ShopProductListItem_Buyer$Matching$PriceText$PC, {
          price: pricePerKg * representativeWeight,
          pricePerKg: pricePerKg,
          isSoldout: isSoldout$1
        });
  } else {
    exit = 1;
  }
  if (exit === 1) {
    tmp = React.createElement("span", {
          className: "mt-2 font-bold text-lg text-green-500"
        }, "예상가 회원공개");
  }
  return React.createElement("div", {
              className: "w-[280px] h-[376px] cursor-pointer",
              onClick: (function (param) {
                  var prim1 = "/products/" + String(productId) + "";
                  router.push(prim1);
                })
            }, React.createElement("div", {
                  className: "w-[280px] aspect-square rounded-xl overflow-hidden relative"
                }, React.createElement($$Image.make, {
                      src: match.image.thumb800x800,
                      placeholder: /* Sm */0,
                      loading: /* Lazy */1,
                      alt: "product-" + String(productId) + "",
                      className: "w-full h-full object-cover"
                    }), React.createElement("div", {
                      className: "w-full h-full absolute top-0 left-0 bg-black/[.03] rounded-2xl"
                    }), status === "NOSALE" ? React.createElement(ShopProductListItem_Buyer$StatusLabel, {
                        text: "숨김"
                      }) : (
                    status === "SOLDOUT" ? React.createElement(ShopProductListItem_Buyer$StatusLabel, {
                            text: "품절"
                          }) : (
                        status === "HIDDEN_SALE" ? React.createElement(ShopProductListItem_Buyer$StatusLabel, {
                                text: "비공개 판매"
                              }) : null
                      )
                  )), React.createElement("div", {
                  className: "flex flex-col mt-4"
                }, React.createElement(ShopProductListItem_Buyer$Matching$ProductName$PC, {
                      productName: match.displayName,
                      representativeWeight: representativeWeight
                    }), tmp));
}

var PC$4 = {
  make: ShopProductListItem_Buyer$Matching$PC
};

function ShopProductListItem_Buyer$Matching$MO(props) {
  var router = Router.useRouter();
  var user = Curry._1(CustomHooks.User.Buyer.use2, undefined);
  var match = use$3(props.query);
  var status = match.status;
  var representativeWeight = match.representativeWeight;
  var productId = match.productId;
  var pricePerKg = match.pricePerKg;
  var price = match.price;
  var tmp;
  var exit = 0;
  if (price !== undefined) {
    if (pricePerKg !== undefined && typeof user !== "number") {
      var isSoldout = status === "SOLDOUT";
      tmp = React.createElement(ShopProductListItem_Buyer$Matching$PriceText$MO, {
            price: price,
            pricePerKg: pricePerKg,
            isSoldout: isSoldout
          });
    } else {
      exit = 1;
    }
  } else if (pricePerKg !== undefined && typeof user !== "number") {
    var isSoldout$1 = status === "SOLDOUT";
    tmp = React.createElement(ShopProductListItem_Buyer$Matching$PriceText$MO, {
          price: pricePerKg * representativeWeight,
          pricePerKg: pricePerKg,
          isSoldout: isSoldout$1
        });
  } else {
    exit = 1;
  }
  if (exit === 1) {
    tmp = React.createElement("span", {
          className: "mt-2 font-bold text-lg text-green-500"
        }, "예상가 회원공개");
  }
  return React.createElement("div", {
              className: "cursor-pointer",
              onClick: (function (param) {
                  var prim1 = "/products/" + String(productId) + "";
                  router.push(prim1);
                })
            }, React.createElement("div", {
                  className: "rounded-xl overflow-hidden relative aspect-square"
                }, React.createElement($$Image.make, {
                      src: match.image.thumb800x800,
                      placeholder: /* Sm */0,
                      loading: /* Lazy */1,
                      alt: "product-" + String(productId) + "",
                      className: "w-full h-full object-cover"
                    }), React.createElement("div", {
                      className: "w-full h-full absolute top-0 left-0 bg-black/[.03] rounded-xl"
                    }), status === "NOSALE" ? React.createElement(ShopProductListItem_Buyer$StatusLabel, {
                        text: "숨김"
                      }) : (
                    status === "SOLDOUT" ? React.createElement(ShopProductListItem_Buyer$StatusLabel, {
                            text: "품절"
                          }) : (
                        status === "HIDDEN_SALE" ? React.createElement(ShopProductListItem_Buyer$StatusLabel, {
                                text: "비공개 판매"
                              }) : null
                      )
                  )), React.createElement("div", {
                  className: "flex flex-col mt-3"
                }, React.createElement(ShopProductListItem_Buyer$Matching$ProductName$MO, {
                      productName: match.displayName,
                      representativeWeight: representativeWeight
                    }), tmp));
}

var MO$4 = {
  make: ShopProductListItem_Buyer$Matching$MO
};

var Matching$1 = {
  ProductName: ProductName,
  PriceText: PriceText,
  PC: PC$4,
  MO: MO$4
};

function ShopProductListItem_Buyer$PC$Placeholder(props) {
  return React.createElement("div", {
              className: "w-[280px] h-[376px]"
            }, React.createElement("div", {
                  className: "w-[280px] h-[280px] animate-pulse rounded-xl bg-gray-100"
                }), React.createElement("div", {
                  className: "mt-3 w-[244px] h-[24px] animate-pulse rounded-sm bg-gray-100"
                }), React.createElement("div", {
                  className: "mt-2 w-[88px] h-[24px] animate-pulse rounded-sm bg-gray-100"
                }));
}

var Placeholder = {
  make: ShopProductListItem_Buyer$PC$Placeholder
};

function ShopProductListItem_Buyer$PC(props) {
  var match = use(props.query);
  var fragmentRefs = match.fragmentRefs;
  var match$1 = Product_Parser.Type.decode(match.__typename);
  if (match$1 !== undefined) {
    if (match$1 !== 2) {
      if (match$1 >= 3) {
        return React.createElement(ShopProductListItem_Buyer$Matching$PC, {
                    query: fragmentRefs
                  });
      } else {
        return React.createElement(ShopProductListItem_Buyer$Normal$PC, {
                    query: fragmentRefs
                  });
      }
    } else {
      return React.createElement(ShopProductListItem_Buyer$Quoted$PC, {
                  query: fragmentRefs
                });
    }
  } else {
    return null;
  }
}

var PC$5 = {
  Placeholder: Placeholder,
  make: ShopProductListItem_Buyer$PC
};

function ShopProductListItem_Buyer$MO$Placeholder(props) {
  return React.createElement("div", undefined, React.createElement("div", {
                  className: "w-full aspect-square animate-pulse rounded-xl bg-gray-100"
                }), React.createElement("div", {
                  className: "mt-3 w-[132px] h-5 animate-pulse rounded-sm bg-gray-100"
                }), React.createElement("div", {
                  className: "mt-1 w-[68px] h-[22px] animate-pulse rounded-sm bg-gray-100"
                }));
}

var Placeholder$1 = {
  make: ShopProductListItem_Buyer$MO$Placeholder
};

function ShopProductListItem_Buyer$MO(props) {
  var match = use(props.query);
  var fragmentRefs = match.fragmentRefs;
  var match$1 = Product_Parser.Type.decode(match.__typename);
  if (match$1 !== undefined) {
    if (match$1 !== 2) {
      if (match$1 >= 3) {
        return React.createElement(ShopProductListItem_Buyer$Matching$MO, {
                    query: fragmentRefs
                  });
      } else {
        return React.createElement(ShopProductListItem_Buyer$Normal$MO, {
                    query: fragmentRefs
                  });
      }
    } else {
      return React.createElement(ShopProductListItem_Buyer$Quoted$MO, {
                  query: fragmentRefs
                });
    }
  } else {
    return null;
  }
}

var MO$5 = {
  Placeholder: Placeholder$1,
  make: ShopProductListItem_Buyer$MO
};

export {
  Fragments ,
  StatusLabel ,
  Normal$1 as Normal,
  Quoted$1 as Quoted,
  Matching$1 as Matching,
  PC$5 as PC,
  MO$5 as MO,
}
/* Image Not a pure module */
