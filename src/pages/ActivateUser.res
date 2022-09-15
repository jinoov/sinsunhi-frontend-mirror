type mode = ByPhone | ByEmail | HasNoMethod

module HasNoMethod = {
  @react.component
  let make = () => <>
    <Next.Head> <title> {j`휴면계정 해제`->React.string} </title> </Next.Head>
    <div
      className=%twc(
        "container mx-auto max-w-lg min-h-buyer relative flex flex-col justify-center pb-20"
      )>
      <div className=%twc("flex-auto flex flex-col xl:justify-center items-center")>
        <div className=%twc("w-full p-5 xl:py-12 sm:px-20 text-text-L1")>
          <h2 className=%twc("text-xl font-bold whitespace-pre")>
            {`회원님의 계정은\n이메일, 휴대폰 번호로\n휴면 상태를 해제할 수 없어요.`->React.string}
          </h2>
          <p className=%twc("mt-5 whitespace-pre-line text-sm text-text-L2")>
            {`1:1 문의를 통해 휴면 상태를 해제하고\n신선하이를 이용해주세요.`->React.string}
          </p>
          <div className=%twc("mt-40")>
            <button
              className=%twc(
                "w-full bg-primary rounded-xl text-white font-bold whitespace-nowrap focus:outline-none focus:ring-2 focus:ring-primary focus:ring-offset-1 h-14"
              )
              onClick={_ => ChannelTalk.showMessenger()}>
              {`1:1 문의하기`->React.string}
            </button>
          </div>
        </div>
      </div>
    </div>
  </>
}

type props = {query: Js.Dict.t<string>}
type params
type previewData

// 쿼리 파라미터
// 1. mode=phone,email -> 휴면 해제 가능 수단
// 2. uid -> 유저의 uid
// 3. email -> 휴면 해제 가능한 email
// 4. phone -> 휴대번호를 이용하여 휴면 해제 시도 시 인증 번호를 수신한 휴대번호
// 5. sent-email -> 휴면 해제 email 전송 여부
// 6. role
let default = (~props) => {
  let mode = props.query->Js.Dict.get("mode")->Option.map(mode => mode->Js.String2.split(","))
  // 해제 수단 중 phone이 있으면 무조건 phone 부터
  // phone이 없는 경우 email로 시작
  // 단, phone 만 가능한(email X) 경우 처리 필요
  // phone으로 시작한 경우, 10번 시도 실패 시 email 수단으로 넘어감
  let (start, skipEmail) = mode->Option.mapWithDefault((HasNoMethod, false), mode =>
    if mode->Array.some(x => x == "phone") {
      if mode->Array.some(x => x == "email") {
        (ByPhone, false)
      } else {
        // phone 만 있고, email은 없는 경우
        (ByPhone, true)
      }
    } else if mode->Array.some(x => x == "email") {
      (ByEmail, false)
    } else {
      (HasNoMethod, false)
    }
  )
  let uid = props.query->Js.Dict.get("uid")
  let email = props.query->Js.Dict.get("email")
  let phone = props.query->Js.Dict.get("phone")
  let sentEmail = props.query->Js.Dict.get("sent-email")
  let role = props.query->Js.Dict.get("role")

  switch start {
  | ByPhone => <ActivateUser_ByPhone skipEmail ?phone ?uid ?role />
  | ByEmail => <ActivateUser_ByEmail ?email ?uid ?sentEmail ?role />
  | HasNoMethod => <HasNoMethod />
  }
}

let getServerSideProps = ({query}: Next.GetServerSideProps.context<props, params, previewData>) => {
  Js.Promise.resolve({"props": {"query": query}})
}
