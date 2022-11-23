module Mutation = %relay(`
  mutation TossPaymentsSuccessBuyerMutation(
    $amount: Int!
    $paymentId: Int!
    $orderId: String!
    $paymentKey: String!
    $tempOrderId: Int
  ) {
    requestPaymentApprovalTossPayments(
      input: {
        paymentId: $paymentId
        amount: $amount
        orderId: $orderId
        paymentKey: $paymentKey
        tempOrderId: $tempOrderId
      }
    ) {
      ... on RequestPaymentApprovalTossPaymentsResult {
        paymentId
        amount
        paymentKey
        status
      }
      ... on Error {
        code
        message
      }
    }
  }
`)

module Dialog = {
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
          )
          onOpenAutoFocus={ReactEvent.Synthetic.preventDefault}>
          children
          <button
            type_="button"
            onClick={_ => router->replace(href)}
            className=%twc(
              "flex w-full xl:w-1/2 h-13 mt-5 bg-surface rounded-lg justify-center items-center text-lg cursor-pointer text-enabled-L1"
            )>
            {`확인`->React.string}
          </button>
        </RadixUI.Dialog.Content>
      </RadixUI.Dialog.Portal>
    </RadixUI.Dialog.Root>
  }
}

type redirectUrl = {
  successUrl: string,
  failUrl: string,
}

@react.component
let make = () => {
  let router = Next.Router.useRouter()

  let initRedirectUrl = {
    successUrl: "/buyer",
    failUrl: "/buyer",
  }

  let {makeWithDict, get} = module(Webapi.Url.URLSearchParams)
  let (showSuccessDialog, setShowSuccessDialog) = React.Uncurried.useState(_ => false)
  let (showErrorDialog, setShowErrorDialog) = React.Uncurried.useState(_ => false)
  let (errorMsg, setErrorMsg) = React.Uncurried.useState(_ => None)
  let (redirectUrl, setRedirectUrl) = React.Uncurried.useState(_ => initRedirectUrl)
  let {successUrl, failUrl} = redirectUrl

  let (mutate, isMutating) = Mutation.use()

  let handleError = message => {
    setShowErrorDialog(._ => true)
    setErrorMsg(._ => message)
  }

  React.useEffect1(_ => {
    let params = router.query->makeWithDict
    // 토스페이먼츠에서 자동으로 생성해주는 쿼리 파라미터
    let orderId = params->get("orderId")
    let amount = params->get("amount")->Option.flatMap(Int.fromString)
    let paymentKey = params->get("paymentKey")
    // 우리가 생성해서 보내는 쿼리 파라미터
    let paymentId = params->get("payment-id")->Option.flatMap(Int.fromString)
    let tempOrderId = params->get("temp-order-id")->Option.flatMap(Int.fromString)
    let orderNo = params->get("order-no")

    // 웹주문서 가상계좌인 경우에만 order-{paymentId} 를 토스 결제 모듈로 쏴서 그것을 orderId로 받아 approval mutation에 쏜다.

    switch (orderId, orderNo, paymentKey, amount, paymentId, isMutating) {
    | (Some(orderId'), Some(orderNo'), Some(paymentKey'), Some(amount'), Some(paymentId'), false) =>
      {
        switch tempOrderId {
        | Some(tempOrderId') =>
          setRedirectUrl(._ => {
            successUrl: `/buyer/web-order/complete/${orderNo'}`,
            failUrl: `/buyer/web-order/${tempOrderId'->Int.toString}`,
          })
        | None =>
          setRedirectUrl(._ => {
            successUrl: `/buyer/transactions`,
            failUrl: `/buyer/transactions`,
          })
        }
        mutate(
          ~variables={
            paymentId: paymentId',
            amount: amount',
            orderId: orderId',
            paymentKey: paymentKey',
            tempOrderId,
          },
          ~onCompleted={
            ({requestPaymentApprovalTossPayments}, _error) => {
              switch requestPaymentApprovalTossPayments {
              | Some(result) =>
                switch result {
                | #RequestPaymentApprovalTossPaymentsResult(_requestPaymentApprovalTossPayments) =>
                  setShowSuccessDialog(._ => true)
                | #Error(error) => handleError(error.message)
                | _ => handleError(None)
                }
              | None => handleError(None)
              }
            }
          },
          ~onError={error => handleError(Some(error.message))},
          (),
        )
      }->ignore
    | _ => ()
    }

    None
  }, [router.query])

  <main className=%twc("bg-surface w-screen h-[560px]")>
    <Dialog show=showErrorDialog href=failUrl>
      <section className=%twc("flex flex-col items-center justify-center")>
        <span> {`결제가 실패하여`->React.string} </span>
        <span className=%twc("mb-5")>
          {`주문이 정상 처리되지 못했습니다.`->React.string}
        </span>
        <span> {`주문/결제하기 페이지에서`->React.string} </span>
        <span className=%twc("mb-5")> {`결제를 다시 시도해주세요.`->React.string} </span>
        <span className=%twc("text-notice")>
          {errorMsg->Option.getWithDefault("")->React.string}
        </span>
      </section>
    </Dialog>
    <Dialog show=showSuccessDialog href=successUrl>
      {<>
        <span> {`주문 요청이 성공했습니다.`->React.string} </span>
        <span> {`주문완료 페이지로 이동합니다.`->React.string} </span>
      </>}
    </Dialog>
  </main>
}
