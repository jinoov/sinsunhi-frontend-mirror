@spice
type tossPaymentsErrorCode =
  | @spice.as("PAY_PROCESS_CANCELED") PAY_PROCESS_CANCELED
  | @spice.as("PAY_PROCESS_ABORTED") PAY_PROCESS_ABORTED
  | @spice.as("REJECT_CARD_COMPANY") REJECT_CARD_COMPANY

let codeToString = code =>
  switch code {
  | PAY_PROCESS_CANCELED => `사용자에 의해 결제가 취소되었습니다.`
  | PAY_PROCESS_ABORTED => `결제 진행 중 승인에 실패하여 결제가 중단되었습니다.`
  | REJECT_CARD_COMPANY => `결제 승인이 거절되었습니다.`
  }

module ErrorDialog = {
  @react.component
  let make = (~children, ~show, ~href) => {
    let {useRouter, replace} = module(Next.Router)
    let router = useRouter()
    <RadixUI.Dialog.Root _open=show>
      <RadixUI.Dialog.Portal>
        <RadixUI.Dialog.Overlay className=%twc("dialog-overlay") />
        <RadixUI.Dialog.Content
          className=%twc(
            "dialog-content p-7 bg-white rounded-xl w-[480px] flex flex-col items-center justify-center"
          )>
          children
          <button
            type_="button"
            onClick={_ => router->replace(href)}
            className=%twc(
              "flex w-full xl:w-1/2 h-13 bg-surface rounded-lg justify-center items-center text-lg cursor-pointer text-enabled-L1"
            )>
            {`닫기`->React.string}
          </button>
        </RadixUI.Dialog.Content>
      </RadixUI.Dialog.Portal>
    </RadixUI.Dialog.Root>
  }
}

@react.component
let make = () => {
  let {useRouter} = module(Next.Router)
  let router = useRouter()
  let {makeWithDict, get} = module(Webapi.Url.URLSearchParams)

  let (errMsg, setErrMsg) = React.Uncurried.useState(_ => `잘못된 접근`)
  let (showErr, setShowErr) = React.Uncurried.useState(_ => false)
  let (redirect, setRedirect) = React.Uncurried.useState(_ => "/buyer")

  React.useEffect1(_ => {
    let params = router.query->makeWithDict
    let code = params->get("code")->Option.map(c => c->Js.Json.string->tossPaymentsErrorCode_decode)
    let tempOrderId = params->get("temp-order-id")->Option.flatMap(Int.fromString)
    let from = params->get("from")

    switch tempOrderId {
    | Some(tempOrderId') => setRedirect(._ => `/buyer/web-order/${tempOrderId'->Int.toString}`)
    | _ => setRedirect(._ => "/buyer" ++ from->Option.getWithDefault(""))
    // 쿼리파라미터에 from이 있으면 해당 페이지로 없으면 메인 페이지로
    // 예) ~?from=/transactions -> /buyer/transactions 으로 이동시킴
    }

    switch code {
    | Some(Ok(decode')) => {
        setErrMsg(._ => decode'->codeToString)
        setShowErr(._ => true)
      }
    | _ => setShowErr(._ => true)
    }
    None
  }, [router.query])

  <ErrorDialog show=showErr href=redirect>
    <div className=%twc("flex flex-col items-center justify-center")>
      <span> {`결제가 실패하여`->React.string} </span>
      <span className=%twc("mb-5")>
        {`주문이 정상 처리되지 못했습니다.`->React.string}
      </span>
      <span> {`주문/결제하기 페이지에서`->React.string} </span>
      <span className=%twc("mb-5")> {`결제를 다시 시도해주세요.`->React.string} </span>
      <span className=%twc("mb-5 text-notice")> {errMsg->React.string} </span>
    </div>
  </ErrorDialog>
}
