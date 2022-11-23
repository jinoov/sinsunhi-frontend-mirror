// This type is based on the getInitialProps return value.
// If you are using getServerSideProps or getStaticProps, you probably
// will never need this
// See https://nextjs.org/docs/advanced-features/custom-app
type pageProps<'a> = {deviceType: DeviceDetect.deviceType, dehydrateStoreData: 'a}

@set external setNextRouterPush: (Global.window, string => unit) => unit = "nextRouterPush"

type service = Seller | Admin | Buyer

let useService = () => {
  let router = Next.Router.useRouter()
  let firstPathname = router.pathname->Js.String2.split("/")->Array.getBy(x => x !== "")

  {
    switch firstPathname {
    | Some("browser-guide")
    | Some("privacy")
    | Some("terms")
    | Some("seller") =>
      Some(Seller)
    | Some("admin") => Some(Admin)
    | Some("buyer")
    | Some("products")
    | Some("matching")
    | Some("delivery")
    | None =>
      Some(Buyer)
    | _ => None
    }
  }
}

let dynamicSeller = Next.Dynamic.dynamic(
  () =>
    Next.Dynamic.import_("src/pages/seller/Seller.mjs") |> Js.Promise.then_(mode => mode["make"]),
  Next.Dynamic.options(~ssr=true, ()),
)

let dynamicAdmin = Next.Dynamic.dynamic(
  () => Next.Dynamic.import_("src/pages/admin/Admin.mjs") |> Js.Promise.then_(mode => mode["make"]),
  Next.Dynamic.options(~ssr=true, ()),
)

let dynamicBuyer = Next.Dynamic.dynamic(
  () => Next.Dynamic.import_("src/pages/buyer/Buyer.mjs") |> Js.Promise.then_(mode => mode["make"]),
  Next.Dynamic.options(~ssr=true, ()),
)

module Container = {
  @react.component
  let make = (~service, ~content) => {
    let features = FeatureFlag.Query.use(~variables=(), ()).features

    <FeatureFlag.Context.Provider value=features>
      {switch service {
      | Some(Seller) => <ReactUtil.Component as_=dynamicSeller> content </ReactUtil.Component>
      | Some(Buyer) => <ReactUtil.Component as_=dynamicBuyer> content </ReactUtil.Component>
      | Some(Admin) => <ReactUtil.Component as_=dynamicAdmin> content </ReactUtil.Component>
      | None => content
      }}
    </FeatureFlag.Context.Provider>
  }
}

// We are not using `@react.component` since we will never
// use <App/> within our ReScript code.
// It's only used within `pages/_app.js`
let default = (props: Next.App.props<'a>): React.element => {
  let {component, pageProps} = props
  let router = Next.Router.useRouter()
  let service = useService()

  let content = React.createElement(component, pageProps)

  // IE로 접근 한 경우 /no-ie 로 리디렉션 시킨다.
  CustomHooks.NoIE.use(router)

  // CRM을 위한 유저 정보를 전역 객체로 추가한다.
  // window.user = { ... }
  CustomHooks.CRMUser.use()

  // 채널톡 Init
  // 아이콘 기본 invisible,
  // 각 페이지에서 ChannelTalk.use()를 통해 노출시킬 수 있다.
  ChannelTalkHelper.Hook.useBoot()

  // window 전역에 Next.js의 라우터를 심어서 모바일앱에서 활용한다.
  React.useEffect1(_ => {
    switch Global.window {
    | Some(window') =>
      window'->setNextRouterPush(url => router->Next.Router.push(url))
      switch Global.Window.Appboy.tOpt {
      | Some(appboy) => appboy->Global.Window.Appboy.setLogger(ignore)
      | None => ()
      }
    | _ => ()
    }

    None
  }, [router])

  let {dehydrateStoreData} = pageProps
  let environment = React.useMemo1(() => RelayEnv.environment(SinsunMarket(Env.graphqlApiUrl)), [])

  React.useMemo1(() => {
    dehydrateStoreData->Option.forEach(records => {
      environment
      ->RescriptRelay.Environment.getStore
      ->RescriptRelay.Store.publish(RescriptRelay.RecordSource.make(~records, ()))
    })
  }, [dehydrateStoreData])->ignore

  <RescriptReactErrorBoundary fallback={_ => <ErrorPage />}>
    <Sentry.ErrorBoundary fallback={<ErrorPage />}>
      <RescriptRelay.Context.Provider environment>
        <Braze.PushNotificationRequestDialog />
        <ReactToastNotifications.ToastProvider>
          <React.Suspense>
            <Container service content />
          </React.Suspense>
          <BuyerInformation_Buyer />
          <Maintenance />
        </ReactToastNotifications.ToastProvider>
      </RescriptRelay.Context.Provider>
    </Sentry.ErrorBoundary>
  </RescriptReactErrorBoundary>
}
