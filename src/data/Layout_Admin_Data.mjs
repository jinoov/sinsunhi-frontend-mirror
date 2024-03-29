// Generated by ReScript, PLEASE EDIT WITH CARE

import * as React from "react";
import * as IconSise from "../components/svgs/IconSise.mjs";
import * as Belt_Array from "rescript/lib/es6/belt_Array.js";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as IconNaviBulkSale from "../components/svgs/IconNaviBulkSale.mjs";
import * as IconDownloadCenter from "../components/svgs/IconDownloadCenter.mjs";
import * as IconNaviSettlement from "../components/svgs/IconNaviSettlement.mjs";
import NaviUserSvg from "../../public/assets/navi-user.svg";
import NaviOrderSvg from "../../public/assets/navi-order.svg";
import NaviProductSvg from "../../public/assets/navi-product.svg";
import NaviDashboardSvg from "../../public/assets/navi-dashboard.svg";

var naviDashboardIcon = NaviDashboardSvg;

var naviOrderIcon = NaviOrderSvg;

var naviProductIcon = NaviProductSvg;

var naviUserIcon = NaviUserSvg;

var items = [
  {
    TAG: /* Root */0,
    title: "대시 보드",
    anchor: {
      url: "/admin/dashboard",
      target: "_self"
    },
    icon: React.createElement("img", {
          className: "w-5 h-5",
          src: naviDashboardIcon
        }),
    role: [
      /* Admin */2,
      /* ExternalStaff */3
    ],
    children: []
  },
  {
    TAG: /* Root */0,
    title: "상품",
    anchor: {
      url: "/admin/products",
      target: "_self"
    },
    icon: React.createElement("img", {
          className: "w-5 h-5",
          src: naviProductIcon
        }),
    role: [
      /* Admin */2,
      /* ExternalStaff */3
    ],
    children: [
      {
        TAG: /* Sub */1,
        title: "상품 등록",
        anchor: {
          url: "/admin/add-product",
          target: "_self"
        },
        slug: undefined,
        role: [/* Admin */2]
      },
      {
        TAG: /* Sub */1,
        title: "상품 조회·수정",
        anchor: {
          url: "/admin/products",
          target: "_self"
        },
        slug: Caml_option.some(/\/admin\/products\/\[pid\]/g),
        role: [
          /* Admin */2,
          /* ExternalStaff */3
        ]
      },
      {
        TAG: /* Sub */1,
        title: "단품 조회",
        anchor: {
          url: "/admin/product-options",
          target: "_self"
        },
        slug: undefined,
        role: [
          /* Admin */2,
          /* ExternalStaff */3
        ]
      }
    ]
  },
  {
    TAG: /* Root */0,
    title: "주문 배송",
    anchor: {
      url: "/admin/orders",
      target: "_self"
    },
    icon: React.createElement("img", {
          className: "w-5 h-5",
          src: naviOrderIcon
        }),
    role: [
      /* Admin */2,
      /* ExternalStaff */3
    ],
    children: [
      {
        TAG: /* Sub */1,
        title: "주문서 조회",
        anchor: {
          url: "/admin/orders",
          target: "_self"
        },
        slug: undefined,
        role: [
          /* Admin */2,
          /* ExternalStaff */3
        ]
      },
      {
        TAG: /* Sub */1,
        title: "주문서 등록",
        anchor: {
          url: "/admin/add-orders",
          target: "_self"
        },
        slug: undefined,
        role: [/* Admin */2]
      },
      {
        TAG: /* Sub */1,
        title: "송장번호 조회",
        anchor: {
          url: "/admin/tracking-numbers",
          target: "_self"
        },
        slug: undefined,
        role: [
          /* Admin */2,
          /* ExternalStaff */3
        ]
      },
      {
        TAG: /* Sub */1,
        title: "송장번호 등록",
        anchor: {
          url: "/admin/add-tracking-numbers",
          target: "_self"
        },
        slug: undefined,
        role: [/* Admin */2]
      }
    ]
  },
  {
    TAG: /* Root */0,
    title: "매칭 관리",
    anchor: {
      url: "/admin/matching/purchases",
      target: "_self"
    },
    icon: React.createElement("img", {
          className: "w-5 h-5",
          src: naviOrderIcon
        }),
    role: [/* Admin */2],
    children: [
      {
        TAG: /* Sub */1,
        title: "구매 신청 조회",
        anchor: {
          url: "/admin/matching/purchases",
          target: "_self"
        },
        slug: undefined,
        role: [/* Admin */2]
      },
      {
        TAG: /* Sub */1,
        title: "매칭 주문관리",
        anchor: {
          url: "/admin/rfq/web-order",
          target: "_self"
        },
        slug: undefined,
        role: [/* Admin */2]
      },
      {
        TAG: /* Sub */1,
        title: "매칭 결제관리",
        anchor: {
          url: "/admin/rfq/transactions",
          target: "_self"
        },
        slug: undefined,
        role: [/* Admin */2]
      }
    ]
  },
  {
    TAG: /* Root */0,
    title: "정산",
    anchor: {
      url: "/admin/cost-management",
      target: "_self"
    },
    icon: React.createElement(IconNaviSettlement.make, {
          height: "1.25rem",
          width: "1.25rem",
          fill: "#262626"
        }),
    role: [/* Admin */2],
    children: [
      {
        TAG: /* Sub */1,
        title: "단품가격관리",
        anchor: {
          url: "/admin/cost-management",
          target: "_self"
        },
        slug: undefined,
        role: [/* Admin */2]
      },
      {
        TAG: /* Sub */1,
        title: "정산기초금액 조회",
        anchor: {
          url: "/admin/settlements",
          target: "_self"
        },
        slug: undefined,
        role: [/* Admin */2]
      }
    ]
  },
  {
    TAG: /* Root */0,
    title: "소싱 관리",
    anchor: {
      url: "/admin/bulk-sale",
      target: "_self"
    },
    icon: React.createElement(IconNaviBulkSale.make, {
          height: "1.25rem",
          width: "1.25rem",
          fill: "#262626"
        }),
    role: [/* Admin */2],
    children: [
      {
        TAG: /* Sub */1,
        title: "소싱 상품 등록/수정",
        anchor: {
          url: "/admin/bulk-sale/products",
          target: "_self"
        },
        slug: undefined,
        role: [/* Admin */2]
      },
      {
        TAG: /* Sub */1,
        title: "생산자 소싱 관리",
        anchor: {
          url: "/admin/bulk-sale/producers",
          target: "_self"
        },
        slug: undefined,
        role: [/* Admin */2]
      }
    ]
  },
  {
    TAG: /* Root */0,
    title: "회원",
    anchor: {
      url: "/admin/farmer-users",
      target: "_self"
    },
    icon: React.createElement("img", {
          className: "w-5 h-5",
          src: naviUserIcon
        }),
    role: [/* Admin */2],
    children: [
      {
        TAG: /* Sub */1,
        title: "생산자 사용자 조회",
        anchor: {
          url: "/admin/farmer-users",
          target: "_self"
        },
        slug: undefined,
        role: [/* Admin */2]
      },
      {
        TAG: /* Sub */1,
        title: "바이어 사용자 조회",
        anchor: {
          url: "/admin/buyer-users",
          target: "_self"
        },
        slug: undefined,
        role: [/* Admin */2]
      }
    ]
  },
  {
    TAG: /* Root */0,
    title: "다운로드 센터",
    anchor: {
      url: "/admin/download-center",
      target: "_self"
    },
    icon: React.createElement(IconDownloadCenter.make, {
          width: "1.25rem",
          height: "1.25rem",
          fill: "#262626"
        }),
    role: [/* Admin */2],
    children: []
  },
  {
    TAG: /* Root */0,
    title: "농산물 시세분석",
    anchor: {
      url: "https://crophet.farmmorning.com/pages/marketprice",
      target: "_blank"
    },
    icon: React.createElement(IconSise.make, {
          width: "1.25rem",
          height: "1.25rem",
          fill: "#262626"
        }),
    role: [/* Admin */2],
    children: []
  }
];

function hasUrl(item, url) {
  if (item.TAG === /* Root */0) {
    if (url === item.anchor.url) {
      return true;
    } else {
      return Belt_Array.some(item.children, (function (child) {
                    return hasUrl(child, url);
                  }));
    }
  } else if (url === item.anchor.url) {
    return true;
  } else {
    return Belt_Option.mapWithDefault(item.slug, false, (function (slug) {
                  return slug.test(url);
                }));
  }
}

var Item = {
  items: items,
  hasUrl: hasUrl
};

export {
  naviDashboardIcon ,
  naviOrderIcon ,
  naviProductIcon ,
  naviUserIcon ,
  Item ,
}
/* naviDashboardIcon Not a pure module */
