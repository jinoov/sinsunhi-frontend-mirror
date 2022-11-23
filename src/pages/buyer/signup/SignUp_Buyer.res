module Form = SignUp_Buyer_Form.Form
module Inputs = SignUp_Buyer_Form.Inputs

type payload = {
  email: string,
  password: string,
  name: string,
  manager: string,
  phone: string,
  @as("business-registration-number") businessRegistrationNumber: string,
  terms: array<string>,
}

@react.component
let make = () => {
  let {useRouter, push} = module(Next.Router)
  let router = useRouter()
  let {addToast} = ReactToastNotifications.useToasts()

  let (showErr, setShowErr) = React.Uncurried.useState(_ => Dialog.Hide)
  let (isLoading, setLoading) = React.Uncurried.useState(_ => false)

  let form = Form.use(~config={defaultValues: SignUp_Buyer_Form.initial, mode: #onChange})

  let {isSubmitting} = form->Form.formState
  let (emailIsVerified, setEmailIsVerified) = React.Uncurried.useState(_ => false)
  let (phoneIsVerified, setPhoneIsVerified) = React.Uncurried.useState(_ => false)
  let (bizIsVerified, setBizIsVerified) = React.Uncurried.useState(_ => false)

  let signInWithTracking = (email, password, bizNumber, marketingTerm) => {
    let {makeWithArray, toString} = module(Webapi.Url.URLSearchParams)

    let urlSearchParams =
      [("grant-type", "password"), ("username", email), ("password", password)]
      ->makeWithArray
      ->toString

    FetchHelper.postWithURLSearchParams(
      ~url=`${Env.restApiUrl}/user/token`,
      ~urlSearchParams,
      ~onSuccess={
        res => {
          setLoading(._ => false)
          // 회원가입 -> 로그인 후 redirect 쿼리파라미터(redirect=...)가 있는 경우 이동 시킨다.
          let redirectUrlWithWelcome =
            router.query
            ->Js.Dict.get("redirect")
            ->Option.map(url => {
              if url->Js.String2.includes("?") {
                `${url}&welcome`
              } else {
                `${url}?welcome`
              }
            })
            ->Option.getWithDefault("/?welcome")

          switch FetchHelper.responseToken_decode(res) {
          | Ok(res) => {
              LocalStorageHooks.AccessToken.set(res.token)
              LocalStorageHooks.RefreshToken.set(res.refreshToken)
              ChannelTalkHelper.bootWithProfile()

              // 로그인 성공 시, 웹뷰에 Braze 푸시 기기 토큰 등록을 위한 userId를 postMessage 합니다.
              switch res.token->CustomHooks.Auth.decodeJwt->CustomHooks.Auth.user_decode {
              | Ok(user) =>
                Global.Window.ReactNativeWebView.PostMessage.signUp(user.id->Int.toString)
                Global.Window.ReactNativeWebView.PostMessage.signIn(user.id->Int.toString)

                // GTM
                DataGtm.push({
                  "event": "sign_up",
                  "user_id": user.id,
                  "method": "normal",
                  "business_number": bizNumber,
                  "marketing": marketingTerm,
                })
              | Error(_) => ()
              }

              // 회원가입 완료 -> 홈 진입 시에 서베이 출력용 쿼리 삽입
              Redirect.setHref(redirectUrlWithWelcome)
            }

          | Error(_) => router->push("/buyer/signin")
          }
        }
      },
      ~onFailure={_ => router->push("/buyer/signin")},
    )->ignore
  }

  let validateVerified = data => {
    let isValid = phoneIsVerified && emailIsVerified && bizIsVerified

    // 순서 중요. UI상 가장 위에 있는 에러 필드부터 포커싱 합니다.
    if !bizIsVerified {
      form->Inputs.BizNumber.setErrorWithOption(
        {type_: "verified", message: `사업자 번호를 인증해주세요.`},
        ~shouldFocus=true,
      )
    }

    if !phoneIsVerified {
      form->Inputs.PhoneNumber.setErrorWithOption(
        {type_: "verified", message: `휴대전화 번호를 인증해주세요.`},
        ~shouldFocus=true,
      )
    }

    if !emailIsVerified {
      form->Inputs.Email.setErrorWithOption(
        {type_: "verified", message: `이메일 중복확인을 해주세요.`},
        ~shouldFocus=true,
      )
    }

    isValid ? Some(data) : None
  }

  let onSubmit = (data: SignUp_Buyer_Form.fields) => {
    setLoading(._ => true)

    {
      email: data.email,
      password: data.password,
      name: data.name,
      manager: data.manager,
      phone: data.phoneNumber->Garter.String.replaceByRe(
        Js.Re.fromStringWithFlags("\\-", ~flags="g"),
        "",
      ),
      businessRegistrationNumber: data.bizNumber->Garter.String.replaceByRe(
        Js.Re.fromStringWithFlags("\\-", ~flags="g"),
        "",
      ),
      terms: data.marketingTerm ? ["marketing"] : [],
    }
    ->Js.Json.stringifyAny
    ->Option.map(body => {
      FetchHelper.post(
        ~url=`${Env.restApiUrl}/user/register/new-buyer`,
        ~body,
        ~onSuccess={
          _ => {
            // 토스트 메세지
            addToast(.
              <div className=%twc("flex items-center")>
                <IconCheck height="24" width="24" fill="#12B564" className=%twc("mr-2") />
                {`회원가입이 완료되었습니다.`->React.string}
              </div>,
              {appearance: "success"},
            )

            let {email, password, bizNumber, marketingTerm} = data
            // 회원가입 이후 자동 로그인 처리
            signInWithTracking(email, password, bizNumber, marketingTerm)
          }
        },
        ~onFailure={
          _ => {
            setLoading(._ => false)
            setShowErr(._ => Dialog.Show)
          }
        },
      )
    })
    ->ignore
  }

  let handleSubmit = (data, _) => {
    // 필드들의 인증이 완료된 후 submit을 진행합니다.
    data->validateVerified->Option.map(onSubmit)->ignore
  }

  // 이미 로그인 된 경우 redirect 하기
  let user = CustomHooks.Auth.use()
  React.useEffect1(_ => {
    switch user {
    | LoggedIn(user') =>
      switch user'.role {
      | Buyer => router->push("/")
      | Seller => router->push("/seller")
      | Admin => router->push("/admin")
      | ExternalStaff => router->push("/admin")
      }
    | NotLoggedIn | Unknown => ()
    }

    None
  }, [user])

  <>
    <Next.Head>
      <title> {`신선하이 | 사업자 회원가입`->React.string} </title>
      <meta
        name="description"
        content="농산물 소싱은 신선하이에서! 전국 70만 산지농가의 우수한 농산물을 싸고 편리하게 공급합니다. 국내 유일한 농산물 B2B 플랫폼 신선하이와 함께 매출을 올려보세요."
      />
    </Next.Head>
    <div
      className=%twc(
        "container mx-auto max-w-lg min-h-screen flex flex-col justify-center items-center pb-24 relative"
      )>
      <main className=%twc("w-full px-5 lg:mt-10")>
        // 타이틀
        // md, lg 사이즈
        <h2 className=%twc("hidden xl:block text-text-L1 text-[26px] font-bold text-center")>
          {`사업자 회원가입`->React.string}
        </h2>
        <form onSubmit={form->Form.handleSubmit(handleSubmit)} className=%twc("mt-10 divide-y")>
          <div>
            <SignUp_EmailInput_Buyer
              form isVerified=emailIsVerified setIsVerified={v => setEmailIsVerified(._ => v)}
            />
            <SignUp_PasswordInput_Buyer form />
          </div>
          <div className=%twc("mt-7")>
            <SignUp_PhoneNumberInput_Buyer
              form isVerified=phoneIsVerified setIsVerified={v => setPhoneIsVerified(._ => v)}
            />
          </div>
          <div className=%twc("mt-7")>
            <SignUp_CompanyInput_Buyer form />
            <SignUp_ManagerInput_Buyer form />
            <SignUp_BizNumberInput_Buyer
              form isVerified=bizIsVerified setIsVerified={v => setBizIsVerified(._ => v)}
            />
          </div>
          <div className=%twc("mt-7")>
            <SignUp_TermsInput_Buyer form />
            // Submit
            <span className=%twc("flex h-13 mt-10")>
              <button
                type_="submit"
                className={isSubmitting ? %twc("btn-level1-disabled") : %twc("btn-level1")}
                disabled={isSubmitting || isLoading}>
                {`회원가입`->React.string}
              </button>
            </span>
          </div>
        </form>
        {
          let {makeWithDict, toString} = module(Webapi.Url.URLSearchParams)
          let redirectUrl =
            router.query
            ->Js.Dict.get("redirect")
            ->Option.map(redirect =>
              [("redirect", redirect)]->Js.Dict.fromArray->makeWithDict->toString
            )
          let signInUrlWithRedirect = switch redirectUrl {
          | Some(redirectUrl) => "/buyer/signin?" ++ redirectUrl
          | None => "/buyer/signin"
          }

          <div className=%twc("text-text-L2 mt-9 text-center")>
            {j`이미 가입하셨나요? `->React.string}
            <Next.Link href=signInUrlWithRedirect>
              <a className=%twc("underline")> {`로그인하기`->React.string} </a>
            </Next.Link>
          </div>
        }
      </main>
    </div>
    <Dialog
      isShow=showErr
      onCancel={_ => setShowErr(._ => Dialog.Hide)}
      textOnCancel={`닫기`}
      boxStyle=%twc("rounded-xl")>
      <p className=%twc("text-text-L1 text-center whitespace-pre-wrap")>
        {`입력한 정보를 확인해주세요.\n\n이미 가입하신 경우\n비밀번호 찾기를 통해 로그인하실 수 있으며\n관련 문의사항은 채널톡으로 문의해주세요.`->React.string}
      </p>
    </Dialog>
  </>
}
