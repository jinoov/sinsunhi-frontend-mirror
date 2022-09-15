@react.component
let make = () => {
  let router = Next.Router.useRouter()

  <Next.Head>
    <meta property="al:ios:url" content={`sinsunhi://com.greenlabs.sinsunhi${router.asPath}`} />
    <meta property="al:ios:app_store_id" content="" /> // TODO: iOS 앱 출시 이후 추가
    <meta property="al:ios:app_name" content=`신선하이` />
    <meta property="al:android:url" content={`sinsunhi://com.greenlabs.sinsunhi${router.asPath}`} />
    <meta property="al:android:app_name" content=`신선하이` />
    <meta property="al:android:package" content="com.greenlabs.sinsunhi" />
    <meta property="al:web:url" content={`https://www.sinsunhi.com${router.asPath}`} />
  </Next.Head>
}
