// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Curry from "rescript/lib/es6/curry.js";
import * as $$Image from "../../../components/common/Image.mjs";
import * as React from "react";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as CustomHooks from "../../../utils/CustomHooks.mjs";
import * as ReactEvents from "../../../utils/ReactEvents.mjs";
import * as Router from "next/router";
import * as ReactRelay from "react-relay";
import * as Product_Parser from "../../../utils/Product_Parser.mjs";
import * as Js_null_undefined from "rescript/lib/es6/js_null_undefined.js";
import * as RescriptRelay_Internal from "rescript-relay/src/RescriptRelay_Internal.mjs";
import * as ShopProductListItem_Buyer from "../../../components/ShopProductListItem_Buyer.mjs";
import * as MatchingProductListItemFragment_graphql from "../../../__generated__/MatchingProductListItemFragment_graphql.mjs";
import * as MatchingProductListItemQuotedFragment_graphql from "../../../__generated__/MatchingProductListItemQuotedFragment_graphql.mjs";
import * as MatchingProductListItemMatchingFragment_graphql from "../../../__generated__/MatchingProductListItemMatchingFragment_graphql.mjs";

function use(fRef) {
  var data = ReactRelay.useFragment(MatchingProductListItemFragment_graphql.node, fRef);
  return RescriptRelay_Internal.internal_useConvertedValue(MatchingProductListItemFragment_graphql.Internal.convertFragment, data);
}

function useOpt(opt_fRef) {
  var fr = opt_fRef !== undefined ? Caml_option.some(Caml_option.valFromOption(opt_fRef)) : undefined;
  var nullableFragmentData = ReactRelay.useFragment(MatchingProductListItemFragment_graphql.node, fr !== undefined ? Js_null_undefined.fromOption(Caml_option.some(Caml_option.valFromOption(fr))) : null);
  var data = (nullableFragmentData == null) ? undefined : Caml_option.some(nullableFragmentData);
  return RescriptRelay_Internal.internal_useConvertedValue((function (rawFragment) {
                if (rawFragment !== undefined) {
                  return MatchingProductListItemFragment_graphql.Internal.convertFragment(rawFragment);
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
  var data = ReactRelay.useFragment(MatchingProductListItemQuotedFragment_graphql.node, fRef);
  return RescriptRelay_Internal.internal_useConvertedValue(MatchingProductListItemQuotedFragment_graphql.Internal.convertFragment, data);
}

function useOpt$1(opt_fRef) {
  var fr = opt_fRef !== undefined ? Caml_option.some(Caml_option.valFromOption(opt_fRef)) : undefined;
  var nullableFragmentData = ReactRelay.useFragment(MatchingProductListItemQuotedFragment_graphql.node, fr !== undefined ? Js_null_undefined.fromOption(Caml_option.some(Caml_option.valFromOption(fr))) : null);
  var data = (nullableFragmentData == null) ? undefined : Caml_option.some(nullableFragmentData);
  return RescriptRelay_Internal.internal_useConvertedValue((function (rawFragment) {
                if (rawFragment !== undefined) {
                  return MatchingProductListItemQuotedFragment_graphql.Internal.convertFragment(rawFragment);
                }
                
              }), data);
}

var Quoted_productStatus_decode = MatchingProductListItemQuotedFragment_graphql.Utils.productStatus_decode;

var Quoted_productStatus_fromString = MatchingProductListItemQuotedFragment_graphql.Utils.productStatus_fromString;

var Quoted = {
  productStatus_decode: Quoted_productStatus_decode,
  productStatus_fromString: Quoted_productStatus_fromString,
  Types: undefined,
  Operation: undefined,
  use: use$1,
  useOpt: useOpt$1
};

function use$2(fRef) {
  var data = ReactRelay.useFragment(MatchingProductListItemMatchingFragment_graphql.node, fRef);
  return RescriptRelay_Internal.internal_useConvertedValue(MatchingProductListItemMatchingFragment_graphql.Internal.convertFragment, data);
}

function useOpt$2(opt_fRef) {
  var fr = opt_fRef !== undefined ? Caml_option.some(Caml_option.valFromOption(opt_fRef)) : undefined;
  var nullableFragmentData = ReactRelay.useFragment(MatchingProductListItemMatchingFragment_graphql.node, fr !== undefined ? Js_null_undefined.fromOption(Caml_option.some(Caml_option.valFromOption(fr))) : null);
  var data = (nullableFragmentData == null) ? undefined : Caml_option.some(nullableFragmentData);
  return RescriptRelay_Internal.internal_useConvertedValue((function (rawFragment) {
                if (rawFragment !== undefined) {
                  return MatchingProductListItemMatchingFragment_graphql.Internal.convertFragment(rawFragment);
                }
                
              }), data);
}

var Matching_productStatus_decode = MatchingProductListItemMatchingFragment_graphql.Utils.productStatus_decode;

var Matching_productStatus_fromString = MatchingProductListItemMatchingFragment_graphql.Utils.productStatus_fromString;

var Matching = {
  productStatus_decode: Matching_productStatus_decode,
  productStatus_fromString: Matching_productStatus_fromString,
  Types: undefined,
  Operation: undefined,
  use: use$2,
  useOpt: useOpt$2
};

var Fragments = {
  Root: Root,
  Quoted: Quoted,
  Matching: Matching
};

function MatchingProductListItem$Soldout$PC(props) {
  if (props.show) {
    return React.createElement(React.Fragment, undefined, React.createElement("div", {
                    className: "w-full h-full absolute top-0 left-0 bg-white opacity-40 rounded-xl"
                  }), React.createElement("div", {
                    className: "absolute bottom-0 w-full h-8 bg-gray-600 flex items-center justify-center opacity-90"
                  }, React.createElement("span", {
                        className: "text-white font-bold"
                      }, "품절")));
  } else {
    return null;
  }
}

var PC = {
  make: MatchingProductListItem$Soldout$PC
};

function MatchingProductListItem$Soldout$MO(props) {
  if (props.show) {
    return React.createElement(React.Fragment, undefined, React.createElement("div", {
                    className: "w-full h-full absolute top-0 left-0 bg-white opacity-40 rounded-xl"
                  }), React.createElement("div", {
                    className: "absolute bottom-0 w-full h-8 bg-gray-600 flex items-center justify-center opacity-90"
                  }, React.createElement("span", {
                        className: "text-white font-bold"
                      }, "품절")));
  } else {
    return null;
  }
}

var MO = {
  make: MatchingProductListItem$Soldout$MO
};

var Soldout = {
  PC: PC,
  MO: MO
};

function MatchingProductListItem$Quoted$PC(props) {
  var router = Router.useRouter();
  var match = use$1(props.query);
  var productId = match.productId;
  var isSoldout = match.status === "SOLDOUT";
  var onClick = function (param) {
    return ReactEvents.interceptingHandler((function (param) {
                  var prim1 = "/products/" + String(productId) + "";
                  router.push(prim1);
                }), param);
  };
  return React.createElement("div", {
              className: "w-[280px] h-[376px] cursor-pointer",
              onClick: onClick
            }, React.createElement("div", {
                  className: "w-[280px] aspect-square rounded-xl overflow-hidden relative"
                }, React.createElement($$Image.make, {
                      src: match.image.thumb400x400,
                      placeholder: /* Sm */0,
                      loading: /* Lazy */1,
                      alt: "product-" + String(productId) + "",
                      className: "w-full h-full object-cover"
                    }), React.createElement("div", {
                      className: "w-full h-full absolute top-0 left-0 bg-black/[.03] rounded-2xl"
                    }), React.createElement(MatchingProductListItem$Soldout$PC, {
                      show: isSoldout
                    })), React.createElement("div", {
                  className: "flex flex-col mt-4"
                }, React.createElement("span", {
                      className: "text-gray-800 line-clamp-2"
                    }, match.displayName), React.createElement("span", {
                      className: "mt-2 font-bold text-lg text-blue-500"
                    }, "최저가 견적받기")));
}

var PC$1 = {
  make: MatchingProductListItem$Quoted$PC
};

function MatchingProductListItem$Quoted$MO(props) {
  var router = Router.useRouter();
  var match = use$1(props.query);
  var productId = match.productId;
  var isSoldout = match.status === "SOLDOUT";
  var onClick = function (param) {
    return ReactEvents.interceptingHandler((function (param) {
                  var prim1 = "/products/" + String(productId) + "";
                  router.push(prim1);
                }), param);
  };
  return React.createElement("div", {
              className: "cursor-pointer",
              onClick: onClick
            }, React.createElement("div", {
                  className: "rounded-xl overflow-hidden relative aspect-square"
                }, React.createElement($$Image.make, {
                      src: match.image.thumb400x400,
                      placeholder: /* Sm */0,
                      loading: /* Lazy */1,
                      alt: "product-" + String(productId) + "",
                      className: "w-full h-full object-cover"
                    }), React.createElement("div", {
                      className: "w-full h-full absolute top-0 left-0 bg-black/[.03] rounded-xl"
                    }), React.createElement(MatchingProductListItem$Soldout$MO, {
                      show: isSoldout
                    })), React.createElement("div", {
                  className: "flex flex-col mt-3"
                }, React.createElement("span", {
                      className: "text-gray-800 line-clamp-2 text-sm"
                    }, match.displayName), React.createElement("span", {
                      className: "mt-1 font-bold text-blue-500"
                    }, "최저가 견적받기")));
}

var MO$1 = {
  make: MatchingProductListItem$Quoted$MO
};

var Quoted$1 = {
  PC: PC$1,
  MO: MO$1
};

function MatchingProductListItem$Matching$PC(props) {
  var router = Router.useRouter();
  var user = Curry._1(CustomHooks.User.Buyer.use2, undefined);
  var match = use$2(props.query);
  var representativeWeight = match.representativeWeight;
  var productId = match.productId;
  var pricePerKg = match.pricePerKg;
  var price = match.price;
  var isSoldout = match.status === "SOLDOUT";
  var tmp;
  var exit = 0;
  if (price !== undefined) {
    if (pricePerKg !== undefined && typeof user !== "number") {
      tmp = React.createElement(ShopProductListItem_Buyer.Matching.PriceText.PC.make, {
            price: price,
            pricePerKg: pricePerKg,
            isSoldout: isSoldout
          });
    } else {
      exit = 1;
    }
  } else if (pricePerKg !== undefined && typeof user !== "number") {
    tmp = React.createElement(ShopProductListItem_Buyer.Matching.PriceText.PC.make, {
          price: pricePerKg * representativeWeight,
          pricePerKg: pricePerKg,
          isSoldout: isSoldout
        });
  } else {
    exit = 1;
  }
  if (exit === 1) {
    tmp = React.createElement("span", {
          className: "mt-1 font-bold text-lg text-green-500"
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
                      src: match.image.thumb400x400,
                      placeholder: /* Sm */0,
                      loading: /* Lazy */1,
                      alt: "product-" + String(productId) + "",
                      className: "w-full h-full object-cover"
                    }), React.createElement("div", {
                      className: "w-full h-full absolute top-0 left-0 bg-black/[.03] rounded-2xl"
                    }), React.createElement(MatchingProductListItem$Soldout$PC, {
                      show: isSoldout
                    })), React.createElement("div", {
                  className: "flex flex-col mt-4"
                }, React.createElement(ShopProductListItem_Buyer.Matching.ProductName.PC.make, {
                      productName: match.displayName,
                      representativeWeight: representativeWeight
                    }), tmp));
}

var PC$2 = {
  make: MatchingProductListItem$Matching$PC
};

function MatchingProductListItem$Matching$MO(props) {
  var router = Router.useRouter();
  var user = Curry._1(CustomHooks.User.Buyer.use2, undefined);
  var match = use$2(props.query);
  var representativeWeight = match.representativeWeight;
  var productId = match.productId;
  var pricePerKg = match.pricePerKg;
  var price = match.price;
  var isSoldout = match.status === "SOLDOUT";
  var tmp;
  var exit = 0;
  if (price !== undefined) {
    if (pricePerKg !== undefined && typeof user !== "number") {
      tmp = React.createElement(ShopProductListItem_Buyer.Matching.PriceText.MO.make, {
            price: price,
            pricePerKg: pricePerKg,
            isSoldout: isSoldout
          });
    } else {
      exit = 1;
    }
  } else if (pricePerKg !== undefined && typeof user !== "number") {
    tmp = React.createElement(ShopProductListItem_Buyer.Matching.PriceText.MO.make, {
          price: pricePerKg * representativeWeight,
          pricePerKg: pricePerKg,
          isSoldout: isSoldout
        });
  } else {
    exit = 1;
  }
  if (exit === 1) {
    tmp = React.createElement("span", {
          className: "mt-2 font-bold  text-green-500"
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
                      src: match.image.thumb400x400,
                      placeholder: /* Sm */0,
                      loading: /* Lazy */1,
                      alt: "product-" + String(productId) + "",
                      className: "w-full h-full object-cover"
                    }), React.createElement("div", {
                      className: "w-full h-full absolute top-0 left-0 bg-black/[.03] rounded-xl"
                    }), React.createElement(MatchingProductListItem$Soldout$MO, {
                      show: isSoldout
                    })), React.createElement("div", {
                  className: "flex flex-col mt-3"
                }, React.createElement(ShopProductListItem_Buyer.Matching.ProductName.MO.make, {
                      productName: match.displayName,
                      representativeWeight: representativeWeight
                    }), tmp));
}

var MO$2 = {
  make: MatchingProductListItem$Matching$MO
};

var Matching$1 = {
  PC: PC$2,
  MO: MO$2
};

function MatchingProductListItem$PC$Placeholder(props) {
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
  make: MatchingProductListItem$PC$Placeholder
};

function MatchingProductListItem$PC(props) {
  var match = use(props.query);
  var fragmentRefs = match.fragmentRefs;
  var match$1 = Product_Parser.Type.decode(match.__typename);
  if (match$1 !== undefined) {
    if (match$1 !== 2) {
      if (match$1 >= 3) {
        return React.createElement(MatchingProductListItem$Matching$PC, {
                    query: fragmentRefs
                  });
      } else {
        return null;
      }
    } else {
      return React.createElement(MatchingProductListItem$Quoted$PC, {
                  query: fragmentRefs
                });
    }
  } else {
    return null;
  }
}

var PC$3 = {
  Placeholder: Placeholder,
  make: MatchingProductListItem$PC
};

function MatchingProductListItem$MO$Placeholder(props) {
  return React.createElement("div", undefined, React.createElement("div", {
                  className: "w-full aspect-square animate-pulse rounded-xl bg-gray-100"
                }), React.createElement("div", {
                  className: "mt-3 w-[132px] h-5 animate-pulse rounded-sm bg-gray-100"
                }), React.createElement("div", {
                  className: "mt-1 w-[68px] h-[22px] animate-pulse rounded-sm bg-gray-100"
                }));
}

var Placeholder$1 = {
  make: MatchingProductListItem$MO$Placeholder
};

function MatchingProductListItem$MO(props) {
  var match = use(props.query);
  var fragmentRefs = match.fragmentRefs;
  var match$1 = Product_Parser.Type.decode(match.__typename);
  if (match$1 !== undefined) {
    if (match$1 !== 2) {
      if (match$1 >= 3) {
        return React.createElement(MatchingProductListItem$Matching$MO, {
                    query: fragmentRefs
                  });
      } else {
        return null;
      }
    } else {
      return React.createElement(MatchingProductListItem$Quoted$MO, {
                  query: fragmentRefs
                });
    }
  } else {
    return null;
  }
}

var MO$3 = {
  Placeholder: Placeholder$1,
  make: MatchingProductListItem$MO
};

export {
  Fragments ,
  Soldout ,
  Quoted$1 as Quoted,
  Matching$1 as Matching,
  PC$3 as PC,
  MO$3 as MO,
}
/* Image Not a pure module */
