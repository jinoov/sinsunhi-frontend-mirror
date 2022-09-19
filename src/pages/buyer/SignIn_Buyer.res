module FormFields = SignIn_Buyer_Form.FormFields
module Form = SignIn_Buyer_Form.Form

module SetPassword = SignIn_Buyer_Set_Password

let {useSetPassword} = module(CustomHooks)

type props = {query: Js.Dict.t<string>}
type params
type previewData

@spice
type info = {
  message: option<string>,
  @spice.key("activation-method") activationMethod: option<array<string>>,
  email: option<string>,
}

let default = (~props) => {
  let {addToast} = ReactToastNotifications.useToasts()

  let uid = props.query->Js.Dict.get("uid")
  let {useRouter, push} = module(Next.Router)
  let router = useRouter()

  let (isShowSetPassword, setShowSetPassword) = useSetPassword(router.query->Js.Dict.get("token"))
  let (isShowErrorSetPassword, setShowErrorSetPassword) = React.Uncurried.useState(_ => Dialog.Hide)
  let (isCheckedSaveEmail, setCheckedSaveEmail) = React.Uncurried.useState(_ => true)
  let (isShowForError, setShowForError) = React.Uncurried.useState(_ => Dialog.Hide)
  let (isShowForExisted, setShowForExisted) = React.Uncurried.useState(_ => Dialog.Hide)

  let inputPasswordRef = React.useRef(Js.Nullable.null)

  let onSubmit = ({state}: Form.onSubmitAPI) => {
    let email = state.values->FormFields.get(FormFields.Email)
    let password = state.values->FormFields.get(FormFields.Password)

    let {makeWithArray, makeWithDict, toString, get} = module(Webapi.Url.URLSearchParams)

    let redirectUrl = router.query->makeWithDict->get("redirect")->Option.getWithDefault("/")

    let urlSearchParams =
      [("grant-type", "password"), ("username", email), ("password", password)]
      ->makeWithArray
      ->toString

    FetchHelper.postWithURLSearchParams(
      ~url=`${Env.restApiUrl}/user/token`,
      ~urlSearchParams,
      ~onSuccess={
        res => {
          let result = FetchHelper.responseToken_decode(res)
          switch result {
          | Ok(res) => {
              LocalStorageHooks.AccessToken.set(res.token)
              LocalStorageHooks.RefreshToken.set(res.refreshToken)
              ChannelTalkHelper.bootWithProfile()

              // 로그인 성공 시, 웹뷰에 Braze 푸시 기기 토큰 등록을 위한 userId를 postMessage 합니다.
              switch res.token->CustomHooks.Auth.decodeJwt->CustomHooks.Auth.user_decode {
              | Ok(user) =>
                Global.Window.ReactNativeWebView.PostMessage.signIn(user.id->Int.toString)
                // GTM
                DataGtm.push({"event": "login", "user_id": user.id, "method": "normal"})
              | Error(_) => ()
              }

              // gtm 전송을 보장하기 위한 시간 차 페이지 이동
              let _ = Js.Global.setTimeout(_ => Redirect.setHref(redirectUrl), 1000)
            }

          | Error(_) => setShowForError(._ => Dialog.Show)
          }
        }
      },
      ~onFailure={
        err => {
          let customError = err->FetchHelper.convertFromJsPromiseError
          if customError.status == 401 {
            let mode = switch customError.info->info_decode {
            | Ok(info) =>
              info.activationMethod->Option.map(method => method->Js.Array2.joinWith(","))
            | Error(_) => None
            }->Option.map(methods => "mode=" ++ methods)
            let activationEmail = switch customError.info->info_decode {
            | Ok(info) => info.email
            | Error(_) => None
            }

            switch (mode, activationEmail) {
            | (Some(mode), Some(activationEmail)) =>
              router->Next.Router.push(
                `/buyer/activate-user?${mode}&uid=${email}&email=${activationEmail}&role=buyer`,
              )
            | (Some(mode), None) =>
              router->Next.Router.push(`/buyer/activate-user?${mode}&uid=${email}&role=buyer`)
            | (None, _) => router->Next.Router.push(`/buyer/activate-user?uid=${email}&role=buyer`)
            }
          } else if customError.status === 409 {
            setShowForExisted(._ => Dialog.Show)
            // 비밀번호 최초 설정이 필요한 유저의 경우, 비밀번호 재설정 유도 팝업을 띄우고,
            // 입력한 비밀번호는 지운다.
            ReactUtil.setValueElementByRef(inputPasswordRef, "")
            state.values->FormFields.set(FormFields.Password, "")->ignore
          } else {
            setShowForError(._ => Dialog.Show)
          }
        }
      },
    )->ignore

    None
  }

  let form: Form.api = Form.use(
    ~validationStrategy=Form.OnChange,
    ~onSubmit,
    ~initialState=SignIn_Buyer_Form.initialState,
    ~schema={
      open Form.Validation
      Schema(
        [
          email(Email, ~error=`이메일을 입력해주세요.`),
          nonEmpty(Password, ~error=`비밀번호를 입력해주세요.`),
        ]->Array.concatMany,
      )
    },
    (),
  )

  let handleOnSubmit = (
    _ => {
      let email = form.values->FormFields.get(FormFields.Email)
      isCheckedSaveEmail
        ? LocalStorageHooks.BuyerEmail.set(email)
        : LocalStorageHooks.BuyerEmail.remove()
      form.submit()
    }
  )->ReactEvents.interceptingHandler

  let _toggleDialogSetPassword = s =>
    (_ => setShowSetPassword(._ => s))->ReactEvents.interceptingHandler

  let toggleDialogForError = s => setShowForError(._ => s)

  let toggleDialogErrorPasswordReset = s => setShowErrorSetPassword(._ => s)

  let toggleDiglogForExisted = s => setShowForExisted(._ => s)

  let handleOnCheckSaveEmail = e => {
    let checked = (e->ReactEvent.Synthetic.target)["checked"]
    setCheckedSaveEmail(._ => checked)
  }

  // 저장된 휴대폰 번호 prefill
  React.useEffect1(_ => {
    // 쿼리 파라미터로 uid가 있다면 그 값을 prefill
    // 없는 경우 로컬 스토리지에 저장된 값이 있다면 prefill
    let email = switch uid {
    | Some(uid') => uid'
    | None => LocalStorageHooks.BuyerEmail.get()
    }
    if email != "" {
      setCheckedSaveEmail(._ => true)
      FormFields.Email->form.setFieldValue(email, ~shouldValidate=true, ())

      ReactUtil.focusElementByRef(inputPasswordRef)
    }

    None
  }, [uid])

  let isFormFilled = () => {
    let email = form.values->FormFields.get(FormFields.Email)
    let password = form.values->FormFields.get(FormFields.Password)
    email !== "" && password !== ""
  }

  // 이미 로그인 된 경우 redirect 하기
  let user = CustomHooks.Auth.use()
  React.useEffect1(_ => {
    switch user {
    | LoggedIn(user') =>
      switch user'.role {
      | Buyer => router->push("/")
      | Seller => router->push("/seller")
      | Admin | ExternalStaff => router->push("/admin")
      }
    | NotLoggedIn | Unknown => ()
    }

    None
  }, [user])

  // 휴면 계정 해제 토큰 처리
  React.useEffect1(_ => {
    let activationToken = router.query->Js.Dict.get("dormant_reset_token")
    let activate = (~token) => {
      {
        "dormant-reset-token": token,
      }
      ->Js.Json.stringifyAny
      ->Option.map(body => {
        FetchHelper.post(
          ~url=`${Env.restApiUrl}/user/dormant/reset-email`,
          ~body,
          ~onSuccess={
            _ =>
              addToast(.
                <div className=%twc("flex items-center")>
                  <IconCheck height="24" width="24" fill="#12B564" className=%twc("mr-2") />
                  {`휴면 계정이 해제되었어요!`->React.string}
                </div>,
                {appearance: "success"},
              )
          },
          ~onFailure={
            err => {
              addToast(.
                <div className=%twc("flex items-center")>
                  <IconError height="24" width="24" className=%twc("mr-2") />
                  {`휴면 계정 해제에 실패했어요`->React.string}
                </div>,
                {appearance: "error"},
              )
            }
          },
        )
      })
      ->ignore
    }
    switch activationToken {
    | Some(activationToken) => activate(~token=activationToken)
    | None => ()
    }

    None
  }, [router.query])

  // 채널톡 버튼 사용
  ChannelTalkHelper.Hook.use()

  <>
    <Next.Head>
      <title> {j`바이어 로그인 - 신선하이`->React.string} </title>
    </Next.Head>
    <div
      className=%twc(
        "container mx-auto max-w-lg min-h-buyer relative flex flex-col justify-center pb-20"
      )>
      <div className=%twc("flex-auto flex flex-col xl:justify-center items-center")>
        <div className=%twc("w-full px-5 xl:py-12 sm:px-20")>
          <h2 className=%twc("hidden text-[26px] font-bold text-center xl:block")>
            {`신선하이 로그인`->React.string}
          </h2>
          <form onSubmit={handleOnSubmit}>
            <Input
              type_="email"
              name="email"
              size=Input.Large
              placeholder={`이메일`}
              value={form.values->FormFields.get(FormFields.Email)}
              onChange={FormFields.Email->form.handleChange->ReForm.Helpers.handleChange}
              error={FormFields.Email->Form.ReSchema.Field->form.getFieldError}
              className=%twc("block mt-[60px]")
            />
            <Input
              id="input-password"
              type_="password"
              name="password"
              size=Input.Large
              placeholder={`비밀번호`}
              onChange={FormFields.Password->form.handleChange->ReForm.Helpers.handleChange}
              error={FormFields.Password->Form.ReSchema.Field->form.getFieldError}
              className=%twc("block mt-3")
              inputRef={ReactDOM.Ref.domRef(inputPasswordRef)}
            />
            <div className=%twc("flex justify-between items-center mt-4")>
              <span className=%twc("flex flex-1")>
                <Checkbox
                  id="auto-login" checked=isCheckedSaveEmail onChange=handleOnCheckSaveEmail
                />
                <span className=%twc("text-sm text-gray-700 ml-1")>
                  {`아이디 저장`->React.string}
                </span>
              </span>
              <span className=%twc("divide-x")>
                <Next.Link href="/buyer/signin/find-id-password?mode=find-id">
                  <span className="text-sm text-gray-700 p-1 m-1 cursor-pointer">
                    {`아이디 찾기`->React.string}
                  </span>
                </Next.Link>
                <Next.Link href="/buyer/signin/find-id-password?mode=reset-password">
                  <span className="text-sm text-gray-700 pl-2 mr-1 mt-1 mb-1 cursor-pointer">
                    {`비밀번호 재설정`->React.string}
                  </span>
                </Next.Link>
              </span>
            </div>
            <div>
              <button
                type_="submit"
                className={form.isSubmitting || !isFormFilled()
                  ? %twc(
                      "w-full mt-12 h-14 flex justify-center items-center bg-gray-300 rounded-xl text-white font-bold"
                    )
                  : %twc(
                      "w-full mt-12 h-14 flex justify-center items-center bg-black-gl rounded-xl text-white font-bold focus:outline-none focus:ring-2 focus:ring-offset-1 focus:ring-black"
                    )}
                disabled={form.isSubmitting || !isFormFilled()}>
                {`로그인`->React.string}
              </button>
            </div>
          </form>
          <RadixUI.Separator.Root className=%twc("h-px bg-div-border-L2 my-7") />
          <div>
            <button
              className={%twc(
                "w-full h-14 flex justify-center items-center rounded-xl border-[1px] border-green-500"
              )}
              onClick={_ => router->push("/buyer/signup")}>
              <span className=%twc("text-green-500 font-bold")>
                {`바이어 회원가입`->React.string}
              </span>
            </button>
          </div>
        </div>
      </div>
    </div>
    // 비밀번호 재설정 다이얼로그
    <Dialog isShow=isShowSetPassword boxStyle=%twc("overflow-auto")>
      <SetPassword onSuccess=setShowSetPassword onError=setShowErrorSetPassword />
    </Dialog>
    // 로그인 오류 다이얼로그
    <Dialog
      isShow=isShowForError
      onConfirm={_ => toggleDialogForError(Dialog.Hide)}
      confirmBg="#ECECEC"
      confirmTextColor="#262626">
      <p className=%twc("text-gray-500 text-center whitespace-pre-wrap")>
        {`로그인 정보가 일치하지 않거나 없는 계정입니다. 다시 한번 입력해주세요.`->React.string}
      </p>
    </Dialog>
    // 비밀번호 재설정 오류 다이얼로그
    <Dialog
      isShow=isShowErrorSetPassword onConfirm={_ => toggleDialogErrorPasswordReset(Dialog.Hide)}>
      <p className=%twc("text-gray-500 text-center whitespace-pre-wrap")>
        {`비밀번호 재설정에 실패하였습니다.\n다시 시도해주세요.`->React.string}
      </p>
    </Dialog>
    // 비밀번호 재설정 오류 다이얼로그
    <Dialog isShow=isShowForExisted onConfirm={_ => toggleDiglogForExisted(Dialog.Hide)}>
      <p className=%twc("text-gray-500 text-center whitespace-pre-wrap")>
        {`신선하이를 이용하시려면 비밀번호 재설정이 필요합니다. 이메일로 재설정 메일을 보내드렸습니다. 메일함을 확인해주세요.`->React.string}
      </p>
    </Dialog>
  </>
}

let getServerSideProps = ({query}: Next.GetServerSideProps.context<props, params, previewData>) => {
  Js.Promise.resolve({"props": {"query": query}})
}
