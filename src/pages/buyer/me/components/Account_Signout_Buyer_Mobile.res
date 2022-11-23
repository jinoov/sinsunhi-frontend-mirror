open RadixUI

module Fragment = %relay(`
  fragment AccountSignoutBuyerMobile_Fragment on User {
    uid
    sinsunCashDeposit
    debtAmount
  }
`)

type step = Confirm | SelectReasons | Signout

module Signout = {
  @react.component
  let make = (~onClose, ~sinsunCashDeposit, ~onClickSignout, ~loading, ~debtAmount) => {
    let (agree, setAgree) = React.Uncurried.useState(_ => false)

    let isDebtor = debtAmount->Option.mapWithDefault(false, a => a > 0)
    let disabled = !agree || loading || isDebtor

    <section className=%twc("px-4 xl:mt-0 pb-6 max-h-[calc(100%-70px)] overflow-y-auto")>
      <div className=%twc("flex flex-col")>
        <div className=%twc("mb-5")>
          <p className=%twc("text-text-L1")>
            {`유의사항`->React.string}
            <br />
            {`회원탈퇴 전에 꼭 확인하세요.`->React.string}
          </p>
          <div className=%twc("my-6 border") />
          <Account_Signout_Term_Buyer className=%twc("list-disc px-4 mb-5") />
          <div
            className=%twc(
              "flex items-center justify-between border border-div-border-L3 rounded p-4 mb-1"
            )>
            <div>
              <span className=%twc("text-gray-600")> {`신선캐시 잔액`->React.string} </span>
            </div>
            <div>
              <span className=%twc("font-bold")>
                {`${sinsunCashDeposit
                  ->Float.fromInt
                  ->Locale.Float.show(~digits=0)}원`->React.string}
              </span>
            </div>
          </div>
          {switch debtAmount {
          | Some(amount) =>
            <div className=%twc("border border-div-border-L3 rounded p-4")>
              <div className=%twc("flex items-center justify-between ")>
                <div>
                  <span className=%twc("text-gray-600")>
                    {`나중결제 미정산 금액`->React.string}
                  </span>
                </div>
                <div>
                  <span className=%twc("font-bold")>
                    {`${amount->Float.fromInt->Locale.Float.show(~digits=0)}원`->React.string}
                  </span>
                </div>
              </div>
            </div>
          | None => React.null
          }}
          {isDebtor
            ? <div className=%twc("text-notice text-sm mt-1 px-4")>
                {`미정산 금액이 남아있기 때문에 탈퇴를 할 수 없습니다.`->React.string}
              </div>
            : React.null}
          <div className=%twc("my-6 border") />
          <div className=%twc("flex items-center")>
            <Checkbox
              id="agree"
              name="agree"
              checked={agree}
              onChange={_ => setAgree(._ => !agree)}
              disabled={isDebtor}
            />
            <label htmlFor="agree" className=%twc("ml-2")>
              {`유의사항을 모두 확인했습니다.`->React.string}
            </label>
          </div>
        </div>
        <div className=%twc("flex")>
          <button
            className=%twc("bg-gray-150 rounded-xl focus:outline-none w-full py-4 text-center mr-1")
            onClick={_ => onClose()}
            disabled={loading}>
            <span className=%twc("font-bold")> {`취소`->React.string} </span>
          </button>
          <button
            className={cx([
              %twc("rounded-xl focus:outline-none w-full py-4 text-center ml-1"),
              disabled ? %twc("bg-gray-150") : %twc("bg-[#FCF0E6]"),
            ])}
            onClick={_ => onClickSignout()}
            disabled={disabled}>
            <span
              className={cx([
                %twc("font-bold"),
                disabled ? %twc("text-gray-300") : %twc("text-[#FF7A38]"),
              ])}>
              {`탈퇴`->React.string}
            </span>
          </button>
        </div>
      </div>
    </section>
  }
}

@react.component
let make = (~query, ~isOpen, ~onClose) => {
  let {addToast} = ReactToastNotifications.useToasts()
  let {uid: email, sinsunCashDeposit, debtAmount} = Fragment.use(query)

  let (step, setStep) = React.Uncurried.useState(_ => Confirm)
  let (password, setPassword) = React.Uncurried.useState(_ => "")
  let (selected, setSelected) = React.Uncurried.useState(_ => Set.String.empty)
  let (etc, setEtc) = React.Uncurried.useState(_ => "")

  let (loading, setLoading) = React.Uncurried.useState(_ => false)

  let reset = _ => {
    setStep(._ => Confirm)
    setLoading(._ => false)
    setPassword(._ => "")
  }

  let handleClose = _ => {
    reset()
    onClose()
  }

  let onClickSignout = _ => {
    setLoading(._ => true)
    let reason =
      selected
      ->Set.String.toList
      ->List.map(reason =>
        switch reason {
        | str if str == `기타` => `기타(${etc})`
        | str => str
        }
      )
      ->List.reduce("", (acc, str) => acc ++ "|" ++ str)
      ->Garter.String.replaceByRe(Js.Re.fromStringWithFlags("^,", ~flags="g"), "")

    {
      "password": password,
      "reason": reason,
    }
    ->Js.Json.stringifyAny
    ->Option.map(body => {
      FetchHelper.requestWithRetry(
        ~fetcher=FetchHelper.postWithToken,
        ~url=`${Env.restApiUrl}/user/leave`,
        ~body,
        ~count=1,
        ~onSuccess={
          _ => {
            setLoading(._ => false)
            CustomHooks.Auth.logOut()
            ChannelTalkHelper.logout()
            Redirect.setHref("/")
          }
        },
        ~onFailure={
          _ => {
            addToast(.
              <div className=%twc("flex items-center")>
                <IconError height="24" width="24" className=%twc("mr-2") />
                {j`탈퇴 중 오류가 발생했습니다. 잠시후 다시 시도해주세요.`->React.string}
              </div>,
              {appearance: "error"},
            )
            setLoading(._ => false)
          }
        },
      )
    })
    ->ignore
  }

  // mobile 에서 뒤로가기로 닫혔을 때, 상태 초기화.
  React.useEffect1(_ => {
    if !isOpen {
      reset()
    }

    None
  }, [isOpen])

  <Dialog.Root _open={isOpen} onOpenChange={reset}>
    <Dialog.Overlay className=%twc("dialog-overlay") />
    <Dialog.Content
      className=%twc(
        "dialog-content-plain bottom-0 left-0 xl:bottom-auto xl:left-auto xl:rounded-2xl xl:state-open:top-1/2 xl:state-open:left-1/2 xl:state-open:-translate-x-1/2 xl:state-open:-translate-y-1/2"
      )
      onOpenAutoFocus={ReactEvent.Synthetic.preventDefault}>
      <RemoveScroll>
        <div
          className=%twc(
            "fixed top-0 left-0 h-full xl:static bg-white w-full max-w-3xl xl:min-h-fit xl:min-w-min xl:w-[90vh] xl:max-w-[480px] xl:max-h-[85vh] "
          )>
          <section className=%twc("h-14 w-full xl:h-auto xl:w-auto xl:mt-10")>
            <div
              className=%twc(
                "flex items-center justify-between px-5 w-full py-4 xl:h-14 xl:w-full xl:pb-10"
              )>
              <div className=%twc("w-6") />
              <div className=%twc("xl:hidden")>
                <span className=%twc("font-bold")> {`회원탈퇴`->React.string} </span>
              </div>
              <Dialog.Close className=%twc("focus:outline-none") onClick={_ => onClose()}>
                <IconClose height="24" width="24" fill="#262626" />
              </Dialog.Close>
            </div>
          </section>
          {switch step {
          | Confirm =>
            <Account_Signout_ConfirmPassword_Buyer.Mobile
              email nextStep={_ => setStep(._ => SelectReasons)} password setPassword
            />
          | SelectReasons =>
            <Account_Signout_Reason_Buyer.Mobile
              onClickNext={_ => setStep(._ => Signout)}
              onClose={handleClose}
              selected
              setSelected
              etc
              setEtc
            />
          | Signout =>
            <Signout onClose={handleClose} sinsunCashDeposit onClickSignout loading debtAmount />
          }}
        </div>
      </RemoveScroll>
    </Dialog.Content>
  </Dialog.Root>
}
