@react.component
let make = (~pid: string) => {
  let router = Next.Router.useRouter()
  // FIXME
  /*
   * productType 을 쿼리파람으로 구분하는 것은 product query 에 필드가 추가되면 삭제 예정
   */
  let productType = router.query->Js.Dict.get("type")

  React.useEffect0(_ => {
    // Braze Push Notification Request
    Braze.PushNotificationRequestDialog.trigger()
    None
  })

  <Authorization.Buyer title={j`신청 완료`}>
    <div className=%twc("bg-gray-100")>
      <div className=%twc("relative container bg-white max-w-3xl mx-auto min-h-screen")>
        <div className=%twc("w-full fixed top-0 left-0 z-10")>
          <header className=%twc("w-full max-w-3xl mx-auto h-14 bg-white")>
            <div className=%twc("px-5 py-4 flex justify-between") />
          </header>
        </div>
        <div className=%twc("w-full h-14") />
        {switch (pid->Int.fromString, productType) {
        | (Some(_), Some(pType)) if pType == "farm" => <Tradematch_Buy_Farm_Product_Applied_Buyer />
        | (Some(_), Some(pType)) if pType == "aqua" => <Tradematch_Buy_Aqua_Product_Applied_Buyer />
        | (_, Some(_))
        | (_, None) => <>
            <Tradematch_Header_Buyer /> <Tradematch_Skeleton_Buyer /> <Tradematch_NotFound_Buyer />
          </>
        }}
      </div>
    </div>
  </Authorization.Buyer>
}
