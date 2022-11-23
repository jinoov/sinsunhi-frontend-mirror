@react.component
let make = (~children) => {
  let router = Next.Router.useRouter()
  let firstPathname = router.pathname->Js.String2.split("/")->Array.getBy(x => x !== "")
  let secondPathname =
    router.pathname->Js.String2.split("/")->Array.keep(x => x !== "")->Garter.Array.get(1)

  switch (firstPathname, secondPathname) {
  | (Some("admin"), Some("signin")) => children
  | (Some("admin"), _) => <Layout_Admin> {children} </Layout_Admin>
  | _ => children
  }
}
