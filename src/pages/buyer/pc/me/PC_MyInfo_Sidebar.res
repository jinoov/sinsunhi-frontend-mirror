@react.component
let make = () => {
  let router = Next.Router.useRouter()

  let isSelected = link => {
    router.pathname == link
  }

  let routes = [
    ("마이홈", "/buyer/me"),
    ("프로필정보", "/buyer/me/profile"),
    ("계정정보", "/buyer/me/account"),
    ("주문서 업로드", "/buyer/upload"),
    ("주문 내역", "/buyer/orders"),
    ("결제 내역", "/buyer/transactions"),
    ("단품 확인", "/products/advanced-search"),
    ("다운로드 센터", "/buyer/download-center"),
  ]

  <PC_Sidebar>
    {routes
    ->Array.map(((name, link)) =>
      <PC_Sidebar.Item.Route
        displayName=name
        pathObj={
          pathname: link,
        }
        routeFn=#push
        selected={isSelected(link)}
        key=name
      />
    )
    ->React.array}
    <PC_Sidebar.Item.Link
      displayName="판매자료 다운로드"
      href="https://drive.google.com/drive/u/0/folders/1DbaGUxpkYnJMrl4RPKRzpCqTfTUH7bYN"
      newTab=true
    />
    <PC_Sidebar.Item.Action
      displayName="1:1 문의" selected=false onClick={_ => ChannelTalk.showMessenger()}
    />
    <PC_Sidebar.Item.Route
      displayName="고객지원"
      pathObj={
        pathname: "https://shinsunmarket.co.kr/532",
      }
      routeFn=#push
      selected={isSelected("https://shinsunmarket.co.kr/532")}
    />
  </PC_Sidebar>
}
