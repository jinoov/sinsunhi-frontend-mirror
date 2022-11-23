module Head = {
  @react.component
  let make = (~icon, ~selected, ~title) => {
    <div className={%twc("flex flex-row items-center w-full px-16 py-4")}>
      icon
      <div />
      <p className={selected ? %twc("ml-2 font-bold") : %twc("ml-2 font-normal")}>
        {title->React.string}
      </p>
    </div>
  }
}

let rec render = (
  t: Layout_Admin_Data.Item.t,
  pathname: string,
  openedAdminMenu,
  setOpenedAdminMenu,
  userRole,
) => {
  switch t {
  | Root({title, icon, children, anchor: {url, target}, role}) => {
      let headComponent = <Head title icon selected={t->Layout_Admin_Data.Item.hasUrl(pathname)} />

      let head = switch children {
      | [] =>
        <Next.Link href={url} passHref=true>
          <a target={(target :> string)}> headComponent </a>
        </Next.Link>
      | _ => headComponent
      }

      switch role->Garter.Array.some(roleOfItem => userRole == Some(roleOfItem)) {
      | true =>
        <Layout_Admin_Root
          key={url} accordianItemValue={url} head openedAdminMenu setOpenedAdminMenu>
          {children
          ->Array.map(d => d->render(pathname, openedAdminMenu, setOpenedAdminMenu, userRole))
          ->React.array}
        </Layout_Admin_Root>
      | false => React.null
      }
    }

  | Sub({anchor: {url, target}, title, role}) =>
    switch role->Garter.Array.some(roleOfItem => userRole == Some(roleOfItem)) {
    | true =>
      <Layout_Admin_Sub
        key={url} title href={url} selected={t->Layout_Admin_Data.Item.hasUrl(pathname)} target
      />
    | false => React.null
    }
  }
}

@react.component
let make = (~children) => {
  let router = Next.Router.useRouter()
  let user = CustomHooks.Auth.use()
  let role = switch user {
  | LoggedIn(user) => Some(user.role)
  | _ => None
  }
  let (openedAdminMenu, setOpenedAdminMenu) = LocalStorageHooks.AdminMenu.useLocalStorage()

  <div className=%twc("min-h-screen flex flex-col")>
    <Header.Admin />
    <main className="flex flex-row flex-1 bg-div-shape-L1">
      <aside className=%twc("mt-px min-h-full bg-white")>
        {Layout_Admin_Data.Item.items
        ->Array.map(t =>
          t->render(
            router.pathname,
            openedAdminMenu->Option.getWithDefault([]),
            setOpenedAdminMenu,
            role,
          )
        )
        ->React.array}
      </aside>
      <article className=%twc("w-[calc(100%-288px)] min-h-full")> children </article>
    </main>
  </div>
}
