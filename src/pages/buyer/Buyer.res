@react.component
let make = (~children) => {
  let router = Next.Router.useRouter()
  let firstPathname = router.pathname->Js.String2.split("/")->Array.getBy(x => x !== "")
  let secondPathname =
    router.pathname->Js.String2.split("/")->Array.keep(x => x !== "")->Garter.Array.get(1)

  switch (firstPathname, secondPathname) {
  | (Some("buyer"), Some("rfq"))
  | (Some("buyer"), Some("tradematch")) =>
    <Layout_Estimation_Services_Buyer> {children} </Layout_Estimation_Services_Buyer>
  | (Some("buyer"), None)
  | (Some("buyer"), Some("search")) => children
  | (Some("buyer"), Some("me")) => children
  | (Some("buyer"), _)
  | (Some("products"), _) =>
    <Layout_Buyer> {children} </Layout_Buyer>
  | _ => children
  }
}
