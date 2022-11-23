@react.component
let make = (~isOpen, ~onCancel) => {
  let router = Next.Router.useRouter()
  let user = CustomHooks.Auth.use()

  let logOut = (
    _ => {
      CustomHooks.Auth.logOut()
      ChannelTalkHelper.logout()
      let role = user->CustomHooks.Auth.toOption->Option.map(user' => user'.role)
      switch role {
      | Some(Seller) => router->Next.Router.push("/seller/signin")
      | Some(Buyer) => router->Next.Router.push("/buyer/signin")
      | Some(Admin)
      | Some(ExternalStaff) =>
        router->Next.Router.push("/admin/signin")
      | None => ()
      }
    }
  )->ReactEvents.interceptingHandler

  <Dialog
    isShow={isOpen}
    onCancel={onCancel}
    onConfirm={logOut}
    textOnCancel={`닫기`}
    textOnConfirm={`로그아웃`}
    kindOfConfirm=Dialog.Negative
    boxStyle=%twc("rounded-xl")>
    <div className=%twc("text-center")> {`로그아웃 하시겠어요?`->React.string} </div>
  </Dialog>
}
