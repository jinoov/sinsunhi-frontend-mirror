let submitEmail = (
  ~uid,
  ~role,
  ~onSuccess,
  ~addToast: (. React.element, ReactToastNotifications.addToast) => unit,
) => {
  {
    "uid": uid,
    "role": role,
  }
  ->Js.Json.stringifyAny
  ->Option.map(body => {
    FetchHelper.post(
      ~url=`${Env.restApiUrl}/user/dormant/send-email`,
      ~body,
      ~onSuccess={
        _ => onSuccess()
      },
      ~onFailure={
        err => {
          addToast(.
            <div className=%twc("flex items-center")>
              <IconError height="24" width="24" className=%twc("mr-2") />
              {`다시 시도해주세요`->React.string}
            </div>,
            {appearance: "error"},
          )
        }
      },
    )
  })
  ->ignore
}

@module("../../public/assets/email-container.svg")
external iconEmail: string = "default"

@module("../../public/assets/chat-container.svg")
external iconChat: string = "default"

@module("../../public/assets/chat-container.svg")
external iconChat: string = "default"

module SentEmail = {
  @react.component
  let make = (~email, ~uid, ~role) => {
    let {addToast} = ReactToastNotifications.useToasts()
    let _ = uid

    let onSuccess = () =>
      addToast(.
        <div className=%twc("flex items-center")>
          <IconCheck height="24" width="24" fill="#12B564" className=%twc("mr-2") />
          {`이메일을 다시 전송하였습니다`->React.string}
        </div>,
        {appearance: "success"},
      )

    <>
      <Next.Head>
        <title> {j`이메일로 휴면계정 해제`->React.string} </title>
      </Next.Head>
      <div
        className=%twc(
          "container mx-auto max-w-lg min-h-buyer relative flex flex-col justify-center pb-20"
        )
      >
        <div className=%twc("flex-auto flex flex-col xl:justify-center items-center")>
          <div className=%twc("w-full p-5 xl:py-12 sm:px-20")>
            <h2 className=%twc("text-xl font-bold whitespace-pre")>
              {`${email}로\n인증메일이 발송됐어요\n이메일을 확인해주세요`->React.string}
            </h2>
            <div className=%twc("mt-10")>
              <button
                onClick={_ => submitEmail(~uid, ~addToast, ~role, ~onSuccess)}
                className=%twc("w-full flex justify-between items-center")
              >
                <span className=%twc("flex items-center")>
                  <img src=iconEmail />
                  <span className=%twc("ml-3")> {`이메일 다시 보내기`->React.string} </span>
                </span>
                <IconArrow height="16" width="16" fill="#414347" />
              </button>
            </div>
            <div className=%twc("mt-8")>
              <button
                onClick={_ => ChannelTalk.showMessenger()}
                className=%twc("w-full flex justify-between items-center")
              >
                <span className=%twc("flex items-center")>
                  <img src=iconChat />
                  <span className=%twc("ml-3")>
                    {`고객센터로 1:1 문의하기`->React.string}
                  </span>
                </span>
                <IconArrow height="16" width="16" fill="#414347" />
              </button>
            </div>
          </div>
        </div>
      </div>
    </>
  }
}

module SendEmail = {
  @react.component
  let make = (~email, ~uid, ~role) => {
    let {addToast} = ReactToastNotifications.useToasts()
    let router = Next.Router.useRouter()

    <>
      <Next.Head>
        <title> {j`이메일로 휴면계정 해제`->React.string} </title>
      </Next.Head>
      <div
        className=%twc(
          "container mx-auto max-w-lg min-h-buyer relative flex flex-col justify-center pb-20"
        )
      >
        <div className=%twc("flex-auto flex flex-col xl:justify-center items-center")>
          <div className=%twc("w-full p-5 xl:py-12 text-text-L1")>
            <h2 className=%twc("text-xl font-bold whitespace-pre")>
              {`휴면 상태를 해제하시려면\n이메일 인증이 필요해요`->React.string}
            </h2>
            <div className=%twc("mt-12")>
              <span className=%twc("text-sm text-text-L2")>
                {`가입한 이메일`->React.string}
              </span>
            </div>
            <div className=%twc("mt-2")>
              <span className=%twc("text-lg font-bold")> {email->React.string} </span>
            </div>
            <div className=%twc("mt-10")>
              <button
                className=%twc(
                  "w-full bg-primary rounded-xl text-white font-bold whitespace-nowrap focus:outline-none focus:ring-2 focus:ring-gray-700 focus:ring-offset-1 h-14"
                )
                type_="button"
                onClick={_ =>
                  submitEmail(~uid, ~addToast, ~role, ~onSuccess=_ =>
                    router->Next.Router.push(router.asPath ++ "&sent-email=true")
                  )}
              >
                {`인증 메일 보내기`->React.string}
              </button>
            </div>
          </div>
        </div>
      </div>
    </>
  }
}

module Error = {
  @react.component
  let make = (~message) => {
    React.useEffect0(_ => {
      Global.jsAlert(message)

      None
    })

    <div
      className=%twc("container mx-auto max-w-lg min-h-buyer relative flex flex-col justify-center")
    >
      <Skeleton.Box className=%twc("h-10") />
    </div>
  }
}

@react.component
let make = (~uid=?, ~email=?, ~sentEmail=?, ~role=?) => {
  switch (email, uid, role, sentEmail) {
  | (Some(email), Some(uid), Some(role), None) => <SendEmail email uid role />
  | (Some(email), Some(uid), Some(role), Some(_)) => <SentEmail email uid role />
  | _ => <Error message={`잘못된 접근 입니다.`} />
  }
}
