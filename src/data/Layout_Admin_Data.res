@module("../../public/assets/navi-dashboard.svg")
external naviDashboardIcon: string = "default"
@module("../../public/assets/navi-order.svg")
external naviOrderIcon: string = "default"
@module("../../public/assets/navi-product.svg")
external naviProductIcon: string = "default"
@module("../../public/assets/navi-user.svg")
external naviUserIcon: string = "default"

module Item = {
  open CustomHooks.Auth
  type rec t =
    | Root({
        title: string,
        anchor: anchor,
        icon: React.element,
        role: array<role>,
        children: array<t>,
      })
    | Sub({title: string, anchor: anchor, slug: option<Js.Re.t>, role: array<role>})
  and anchor = {
    url: string,
    target: target,
  }
  and target = [
    | @as("_self") #_self
    | @as("_blank") #_blank
    | @as("_parent") #_parent
    | @as("_top") #_top
  ]

  let items: array<t> = [
    Root({
      title: `대시 보드`,
      anchor: {url: "/admin/dashboard", target: #_self}, // fs 원래대로
      icon: <img src=naviDashboardIcon className=%twc("w-5 h-5") />,
      role: [Admin, ExternalStaff],
      children: [],
    }),
    Root({
      title: `상품`,
      anchor: {url: "/admin/products", target: #_self},
      icon: <img src=naviProductIcon className=%twc("w-5 h-5") />,
      role: [Admin, ExternalStaff],
      children: [
        Sub({
          title: `상품 등록`,
          anchor: {url: "/admin/add-product", target: #_self},
          slug: None,
          role: [Admin],
        }),
        Sub({
          title: `상품 조회·수정`,
          anchor: {url: "/admin/products", target: #_self},
          slug: Some(%re("/\/admin\/products\/\[pid\]/g")),
          role: [Admin, ExternalStaff],
        }),
        Sub({
          title: `단품 조회`,
          anchor: {url: "/admin/product-options", target: #_self},
          slug: None,
          role: [Admin, ExternalStaff],
        }),
      ],
    }),
    Root({
      title: `주문 배송`,
      anchor: {url: "/admin/orders", target: #_self},
      icon: <img src=naviOrderIcon className=%twc("w-5 h-5") />,
      role: [Admin, ExternalStaff],
      children: [
        Sub({
          title: `주문서 조회`,
          anchor: {url: "/admin/orders", target: #_self},
          slug: None,
          role: [Admin, ExternalStaff],
        }),
        Sub({
          title: `주문서 등록`,
          anchor: {url: "/admin/add-orders", target: #_self},
          slug: None,
          role: [Admin],
        }),
        Sub({
          title: `송장번호 조회`,
          anchor: {url: "/admin/tracking-numbers", target: #_self},
          slug: None,
          role: [Admin, ExternalStaff],
        }),
        Sub({
          title: `송장번호 등록`,
          anchor: {url: "/admin/add-tracking-numbers", target: #_self},
          slug: None,
          role: [Admin],
        }),
      ],
    }),
    Root({
      title: `정산`,
      anchor: {url: "/admin/cost-management", target: #_self},
      icon: <IconNaviSettlement width="1.25rem" height="1.25rem" fill="#262626" />,
      role: [Admin],
      children: [
        Sub({
          title: `단품가격관리`,
          anchor: {url: "/admin/cost-management", target: #_self},
          slug: None,
          role: [Admin],
        }),
        Sub({
          title: `정산기초금액 조회`,
          anchor: {url: "/admin/settlements", target: #_self},
          slug: None,
          role: [Admin],
        }),
      ],
    }),
    Root({
      title: `소싱 관리`,
      anchor: {url: "/admin/bulk-sale", target: #_self},
      icon: <IconNaviBulkSale width="1.25rem" height="1.25rem" fill="#262626" />,
      role: [Admin],
      children: [
        Sub({
          title: `소싱 상품 등록/수정`,
          anchor: {url: "/admin/bulk-sale/products", target: #_self},
          slug: None,
          role: [Admin],
        }),
        Sub({
          title: `생산자 소싱 관리`,
          anchor: {url: "/admin/bulk-sale/producers", target: #_self},
          slug: None,
          role: [Admin],
        }),
      ],
    }),
    Root({
      title: `회원`,
      anchor: {url: "/admin/farmer-users", target: #_self},
      icon: <img src=naviUserIcon className=%twc("w-5 h-5") />,
      role: [Admin],
      children: [
        Sub({
          title: `생산자 사용자 조회`,
          anchor: {url: "/admin/farmer-users", target: #_self},
          slug: None,
          role: [Admin],
        }),
        Sub({
          title: `바이어 사용자 조회`,
          anchor: {url: "/admin/buyer-users", target: #_self},
          slug: None,
          role: [Admin],
        }),
      ],
    }),
    Root({
      title: `다운로드 센터`,
      anchor: {url: "/admin/download-center", target: #_self},
      icon: <IconDownloadCenter height="1.25rem" width="1.25rem" fill="#262626" />,
      role: [Admin],
      children: [],
    }),
    Root({
      title: `농산물 시세분석`,
      anchor: {url: "https://crophet.farmmorning.com/pages/marketprice", target: #_blank},
      icon: <IconSise height="1.25rem" width="1.25rem" fill="#262626" />,
      role: [Admin],
      children: [],
    }),
  ]

  let rec hasUrl = (item, url) =>
    switch item {
    | Root(root) => url == root.anchor.url || root.children->Array.some(child => hasUrl(child, url))
    | Sub(sub) =>
      url == sub.anchor.url ||
        sub.slug->Option.mapWithDefault(false, slug => Js.Re.test_(slug, url))
    }
}
