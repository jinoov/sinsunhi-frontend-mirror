@react.component
let make = (~children) => {
  let router = Next.Router.useRouter()
  let firstPathname = router.pathname->Js.String2.split("/")->Array.getBy(x => x !== "")
  let secondPathname =
    router.pathname->Js.String2.split("/")->Array.keep(x => x !== "")->Garter.Array.get(1)

  switch (firstPathname, secondPathname) {
  | (Some("seller"), Some("activate-user")) =>
    <>
      <Header.SellerActivateUser />
      {children}
    </>
  | (Some("seller"), Some("signin"))
  | (Some("seller"), Some("signup"))
  | (Some("seller"), Some("reset-password"))
  | (Some("seller"), Some("rfq")) => children
  | (Some("seller"), _) => <Layout_Seller> {children} </Layout_Seller>
  | (Some("browser-guide"), _)
  | (Some("privacy"), _)
  | (Some("terms"), _)
  | _ => children
  }
}
