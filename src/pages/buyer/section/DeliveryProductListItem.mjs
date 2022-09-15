// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Curry from "rescript/lib/es6/curry.js";
import * as $$Image from "../../../components/common/Image.mjs";
import * as React from "react";
import * as Locale from "../../../utils/Locale.mjs";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as CustomHooks from "../../../utils/CustomHooks.mjs";
import * as ReactEvents from "../../../utils/ReactEvents.mjs";
import * as Router from "next/router";
import * as ReactRelay from "react-relay";
import * as Product_Parser from "../../../utils/Product_Parser.mjs";
import * as Js_null_undefined from "rescript/lib/es6/js_null_undefined.js";
import * as RescriptRelay_Internal from "rescript-relay/src/RescriptRelay_Internal.mjs";
import * as DeliveryProductListItemFragment_graphql from "../../../__generated__/DeliveryProductListItemFragment_graphql.mjs";
import * as DeliveryProductListItemNormalFragment_graphql from "../../../__generated__/DeliveryProductListItemNormalFragment_graphql.mjs";
import * as DeliveryProductListItemQuotableFragment_graphql from "../../../__generated__/DeliveryProductListItemQuotableFragment_graphql.mjs";

function use(fRef) {
  var data = ReactRelay.useFragment(DeliveryProductListItemFragment_graphql.node, fRef);
  return RescriptRelay_Internal.internal_useConvertedValue(DeliveryProductListItemFragment_graphql.Internal.convertFragment, data);
}

function useOpt(opt_fRef) {
  var fr = opt_fRef !== undefined ? Caml_option.some(Caml_option.valFromOption(opt_fRef)) : undefined;
  var nullableFragmentData = ReactRelay.useFragment(DeliveryProductListItemFragment_graphql.node, fr !== undefined ? Js_null_undefined.fromOption(Caml_option.some(Caml_option.valFromOption(fr))) : null);
  var data = (nullableFragmentData == null) ? undefined : Caml_option.some(nullableFragmentData);
  return RescriptRelay_Internal.internal_useConvertedValue((function (rawFragment) {
                if (rawFragment !== undefined) {
                  return DeliveryProductListItemFragment_graphql.Internal.convertFragment(rawFragment);
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
  var data = ReactRelay.useFragment(DeliveryProductListItemNormalFragment_graphql.node, fRef);
  return RescriptRelay_Internal.internal_useConvertedValue(DeliveryProductListItemNormalFragment_graphql.Internal.convertFragment, data);
}

function useOpt$1(opt_fRef) {
  var fr = opt_fRef !== undefined ? Caml_option.some(Caml_option.valFromOption(opt_fRef)) : undefined;
  var nullableFragmentData = ReactRelay.useFragment(DeliveryProductListItemNormalFragment_graphql.node, fr !== undefined ? Js_null_undefined.fromOption(Caml_option.some(Caml_option.valFromOption(fr))) : null);
  var data = (nullableFragmentData == null) ? undefined : Caml_option.some(nullableFragmentData);
  return RescriptRelay_Internal.internal_useConvertedValue((function (rawFragment) {
                if (rawFragment !== undefined) {
                  return DeliveryProductListItemNormalFragment_graphql.Internal.convertFragment(rawFragment);
                }
                
              }), data);
}

var Normal_productStatus_decode = DeliveryProductListItemNormalFragment_graphql.Utils.productStatus_decode;

var Normal_productStatus_fromString = DeliveryProductListItemNormalFragment_graphql.Utils.productStatus_fromString;

var Normal = {
  productStatus_decode: Normal_productStatus_decode,
  productStatus_fromString: Normal_productStatus_fromString,
  Types: undefined,
  Operation: undefined,
  use: use$1,
  useOpt: useOpt$1
};

function use$2(fRef) {
  var data = ReactRelay.useFragment(DeliveryProductListItemQuotableFragment_graphql.node, fRef);
  return RescriptRelay_Internal.internal_useConvertedValue(DeliveryProductListItemQuotableFragment_graphql.Internal.convertFragment, data);
}

function useOpt$2(opt_fRef) {
  var fr = opt_fRef !== undefined ? Caml_option.some(Caml_option.valFromOption(opt_fRef)) : undefined;
  var nullableFragmentData = ReactRelay.useFragment(DeliveryProductListItemQuotableFragment_graphql.node, fr !== undefined ? Js_null_undefined.fromOption(Caml_option.some(Caml_option.valFromOption(fr))) : null);
  var data = (nullableFragmentData == null) ? undefined : Caml_option.some(nullableFragmentData);
  return RescriptRelay_Internal.internal_useConvertedValue((function (rawFragment) {
                if (rawFragment !== undefined) {
                  return DeliveryProductListItemQuotableFragment_graphql.Internal.convertFragment(rawFragment);
                }
                
              }), data);
}

var Quotable_productStatus_decode = DeliveryProductListItemQuotableFragment_graphql.Utils.productStatus_decode;

var Quotable_productStatus_fromString = DeliveryProductListItemQuotableFragment_graphql.Utils.productStatus_fromString;

var Quotable = {
  productStatus_decode: Quotable_productStatus_decode,
  productStatus_fromString: Quotable_productStatus_fromString,
  Types: undefined,
  Operation: undefined,
  use: use$2,
  useOpt: useOpt$2
};

var Fragments = {
  Root: Root,
  Normal: Normal,
  Quotable: Quotable
};

function DeliveryProductListItem$Soldout$PC(Props) {
  var show = Props.show;
  if (show) {
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
  make: DeliveryProductListItem$Soldout$PC
};

function DeliveryProductListItem$Soldout$MO(Props) {
  var show = Props.show;
  if (show) {
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
  make: DeliveryProductListItem$Soldout$MO
};

var Soldout = {
  PC: PC,
  MO: MO
};

function DeliveryProductListItem$Normal$PC(Props) {
  var query = Props.query;
  var user = Curry._1(CustomHooks.User.Buyer.use2, undefined);
  var router = Router.useRouter();
  var match = use$1(query);
  var productId = match.productId;
  var price = match.price;
  var isSoldout = match.status === "SOLDOUT";
  var onClick = function (param) {
    return ReactEvents.interceptingHandler((function (param) {
                  var prim1 = "/products/" + String(productId) + "";
                  router.push(prim1);
                }), param);
  };
  var tmp;
  var exit = 0;
  if (price !== undefined && typeof user !== "number") {
    tmp = React.createElement("span", {
          className: "mt-1 font-bold text-lg text-gray-800"
        }, "" + Locale.Float.show(undefined, price, 0) + "원");
  } else {
    exit = 1;
  }
  if (exit === 1) {
    tmp = React.createElement("span", {
          className: "mt-1 font-bold text-lg text-green-500"
        }, "공급가 회원공개");
  }
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
                    }), React.createElement(DeliveryProductListItem$Soldout$PC, {
                      show: isSoldout
                    })), React.createElement("div", {
                  className: "flex flex-col mt-4"
                }, React.createElement("span", {
                      className: "text-gray-800 line-clamp-2"
                    }, match.displayName), tmp));
}

var PC$1 = {
  make: DeliveryProductListItem$Normal$PC
};

function DeliveryProductListItem$Normal$MO(Props) {
  var query = Props.query;
  var user = Curry._1(CustomHooks.User.Buyer.use2, undefined);
  var router = Router.useRouter();
  var match = use$1(query);
  var productId = match.productId;
  var price = match.price;
  var isSoldout = match.status === "SOLDOUT";
  var onClick = function (param) {
    return ReactEvents.interceptingHandler((function (param) {
                  var prim1 = "/products/" + String(productId) + "";
                  router.push(prim1);
                }), param);
  };
  var tmp;
  var exit = 0;
  if (price !== undefined && typeof user !== "number") {
    tmp = React.createElement("span", {
          className: "mt-1 font-bold text-lg text-gray-800"
        }, "" + Locale.Float.show(undefined, price, 0) + "원");
  } else {
    exit = 1;
  }
  if (exit === 1) {
    tmp = React.createElement("span", {
          className: "mt-1 font-bold text-lg text-green-500"
        }, "공급가 회원공개");
  }
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
                    }), React.createElement(DeliveryProductListItem$Soldout$MO, {
                      show: isSoldout
                    })), React.createElement("div", {
                  className: "flex flex-col mt-3"
                }, React.createElement("span", {
                      className: "text-gray-800 line-clamp-2 text-sm"
                    }, match.displayName), tmp));
}

var MO$1 = {
  make: DeliveryProductListItem$Normal$MO
};

var Normal$1 = {
  PC: PC$1,
  MO: MO$1
};

function DeliveryProductListItem$Quotable$PC(Props) {
  var query = Props.query;
  var router = Router.useRouter();
  var user = Curry._1(CustomHooks.User.Buyer.use2, undefined);
  var match = use$2(query);
  var productId = match.productId;
  var price = match.price;
  var isSoldout = match.status === "SOLDOUT";
  var tmp;
  var exit = 0;
  if (price !== undefined && typeof user !== "number") {
    tmp = React.createElement("span", {
          className: "mt-1 font-bold text-lg text-gray-800"
        }, "" + Locale.Float.show(undefined, price, 0) + "원");
  } else {
    exit = 1;
  }
  if (exit === 1) {
    tmp = React.createElement("span", {
          className: "mt-1 font-bold text-lg text-green-500"
        }, "공급가 회원공개");
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
                    }), React.createElement(DeliveryProductListItem$Soldout$PC, {
                      show: isSoldout
                    })), React.createElement("div", {
                  className: "flex flex-col mt-4"
                }, React.createElement("span", {
                      className: "text-gray-800 line-clamp-2"
                    }, match.displayName), tmp));
}

var PC$2 = {
  make: DeliveryProductListItem$Quotable$PC
};

function DeliveryProductListItem$Quotable$MO(Props) {
  var query = Props.query;
  var router = Router.useRouter();
  var user = Curry._1(CustomHooks.User.Buyer.use2, undefined);
  console.log(user);
  var match = use$2(query);
  var productId = match.productId;
  var price = match.price;
  var isSoldout = match.status === "SOLDOUT";
  var tmp;
  var exit = 0;
  if (price !== undefined && typeof user !== "number") {
    tmp = React.createElement("span", {
          className: "mt-1 font-bold text-lg text-gray-800"
        }, "" + Locale.Float.show(undefined, price, 0) + "원");
  } else {
    exit = 1;
  }
  if (exit === 1) {
    tmp = React.createElement("span", {
          className: "mt-1 font-bold text-lg text-green-500"
        }, "공급가 회원공개");
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
                    }), React.createElement(DeliveryProductListItem$Soldout$MO, {
                      show: isSoldout
                    })), React.createElement("div", {
                  className: "flex flex-col mt-3"
                }, React.createElement("span", {
                      className: "text-gray-800 line-clamp-2 text-sm"
                    }, match.displayName), tmp));
}

var MO$2 = {
  make: DeliveryProductListItem$Quotable$MO
};

var Quotable$1 = {
  PC: PC$2,
  MO: MO$2
};

function DeliveryProductListItem$PC$Placeholder(Props) {
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
  make: DeliveryProductListItem$PC$Placeholder
};

function DeliveryProductListItem$PC(Props) {
  var query = Props.query;
  var match = use(query);
  var fragmentRefs = match.fragmentRefs;
  var match$1 = Product_Parser.Type.decode(match.__typename);
  if (match$1 !== undefined) {
    if (match$1 !== 1) {
      if (match$1 !== 0) {
        return null;
      } else {
        return React.createElement(DeliveryProductListItem$Normal$PC, {
                    query: fragmentRefs
                  });
      }
    } else {
      return React.createElement(DeliveryProductListItem$Quotable$PC, {
                  query: fragmentRefs
                });
    }
  } else {
    return null;
  }
}

var PC$3 = {
  Placeholder: Placeholder,
  make: DeliveryProductListItem$PC
};

function DeliveryProductListItem$MO$Placeholder(Props) {
  return React.createElement("div", undefined, React.createElement("div", {
                  className: "w-full aspect-square animate-pulse rounded-xl bg-gray-100"
                }), React.createElement("div", {
                  className: "mt-3 w-[132px] h-5 animate-pulse rounded-sm bg-gray-100"
                }), React.createElement("div", {
                  className: "mt-1 w-[68px] h-[22px] animate-pulse rounded-sm bg-gray-100"
                }));
}

var Placeholder$1 = {
  make: DeliveryProductListItem$MO$Placeholder
};

function DeliveryProductListItem$MO(Props) {
  var query = Props.query;
  var match = use(query);
  var fragmentRefs = match.fragmentRefs;
  var match$1 = Product_Parser.Type.decode(match.__typename);
  if (match$1 !== undefined) {
    if (match$1 !== 1) {
      if (match$1 !== 0) {
        return null;
      } else {
        return React.createElement(DeliveryProductListItem$Normal$MO, {
                    query: fragmentRefs
                  });
      }
    } else {
      return React.createElement(DeliveryProductListItem$Quotable$MO, {
                  query: fragmentRefs
                });
    }
  } else {
    return null;
  }
}

var MO$3 = {
  Placeholder: Placeholder$1,
  make: DeliveryProductListItem$MO
};

export {
  Fragments ,
  Soldout ,
  Normal$1 as Normal,
  Quotable$1 as Quotable,
  PC$3 as PC,
  MO$3 as MO,
}
/* Image Not a pure module */