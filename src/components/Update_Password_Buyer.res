module DialogCmp = Dialog
open RadixUI

module Mutation = %relay(`
  mutation UpdatePasswordBuyer_Mutation($input: UpdateUserInput!) {
    updateUser(input: $input) {
      ... on User {
        ...MyInfoAccountBuyer_Fragment
        ...MyInfoProfileSummaryBuyer_Fragment
        ...MyInfoProfileCompleteBuyer_Fragment
      }
      ... on Error {
        message
      }
    }
  }
`)

module ConfirmView = {
  @react.component
  let make = (~email, ~handleCloseButton, ~nextStep) => {
    let (password, setPassword) = React.Uncurried.useState(_ => "")
    let (errorMessage, setErrorMessage) = React.Uncurried.useState(_ => None)
    let (loading, setLoading) = React.Uncurried.useState(_ => false)

    let handleNext = (
      _ => {
        setLoading(._ => true)

        {
          "password": password,
        }
        ->Js.Json.stringifyAny
        ->Option.map(body => {
          FetchHelper.requestWithRetry(
            ~fetcher=FetchHelper.postWithToken,
            ~url=`${Env.restApiUrl}/user/password/check`,
            ~body,
            ~count=3,
            ~onSuccess={
              _ => {
                nextStep()
                setLoading(._ => false)
                setErrorMessage(._ => None)
              }
            },
            ~onFailure={
              _ => {
                setErrorMessage(._ => Some(`비밀번호가 유효하지 않습니다.`))
                setLoading(._ => false)
              }
            },
          )
        })
        ->ignore
      }
    )->ReactEvents.interceptingHandler

    <form onSubmit={handleNext}>
      <section className=%twc("h-14 w-full xl:h-auto xl:w-auto xl:mt-10")>
        <div
          className=%twc(
            "flex items-center justify-between px-5 w-full py-4 xl:h-14 xl:w-full xl:pb-10"
          )>
          <div className=%twc("w-6") />
          <div className=%twc("xl:hidden")>
            <span className=%twc("font-bold")> {`비밀번호 재설정`->React.string} </span>
          </div>
          <button type_="button" className=%twc("focus:outline-none") onClick={handleCloseButton}>
            <IconClose height="24" width="24" fill="#262626" />
          </button>
        </div>
      </section>
      <section className=%twc("my-6 px-4 xl:mt-0 xl:mb-6")>
        <div className=%twc("flex flex-col")>
          <div className=%twc("mb-5")>
            <p className=%twc("text-text-L1 xl:font-bold xl:text-2xl")>
              {`소중한 정보 보호를 위해,`->React.string}
              <br />
              {`사용중인 계정의 비밀번호를 확인해주세요.`->React.string}
            </p>
          </div>
          <div className=%twc("flex flex-col mb-5")>
            <div className=%twc("mb-2")>
              <span className=%twc("font-bold")> {`이메일`->React.string} </span>
            </div>
            <div className=%twc("border border-border-default-L1 bg-disabled-L3 rounded-xl p-3")>
              {email->React.string}
            </div>
          </div>
          <div className=%twc("flex flex-col mb-10")>
            <div className=%twc("mb-2")>
              <span className=%twc("font-bold")> {`비밀번호`->React.string} </span>
            </div>
            <Input
              name="validate-password"
              size=Input.Large
              value={password}
              type_="password"
              placeholder={`비밀번호를 입력해주세요`}
              className=%twc("w-full border border-border-default-L1 p-3 rounded-xl")
              onChange={e => {
                let value = (e->ReactEvent.Synthetic.target)["value"]
                setPassword(._ => value)
                setErrorMessage(._ => None)
              }}
              error=errorMessage
              disabled={loading}
            />
          </div>
          <button
            className={cx([
              %twc("rounded-xl w-full py-4"),
              loading || password == "" ? %twc("bg-disabled-L2") : %twc("bg-green-500"),
            ])}
            type_="submit"
            disabled={password == ""}>
            <span className=%twc("text-white")> {`다음`->React.string} </span>
          </button>
        </div>
      </section>
    </form>
  }
}

module UpdateView = {
  let formatValidator: ValidatedState.validator<string> = password => {
    let exp = Js.Re.fromString("^(?=.*\\d)(?=.*[a-zA-Z]).{6,15}$")
    switch exp->Js.Re.test_(password) {
    | true => Result.Ok(password)
    | false =>
      Result.Error({
        type_: "format",
        message: `영문, 숫자 조합 6~15자로 입력해 주세요.`,
      })
    }
  }

  @react.component
  let make = (~handleCloseButton, ~close) => {
    let {addToast} = ReactToastNotifications.useToasts()
    let (showPassword, setShowPassword) = React.Uncurried.useState(_ => false)
    let (password, setPassword, state) = ValidatedState.use(
      ValidatedState.String,
      "",
      ~validators=[formatValidator],
    )

    let (mutate, mutating) = Mutation.use()

    let handlePasswordChange = e => {
      let newPassword = (e->ReactEvent.Synthetic.target)["value"]

      setPassword(newPassword, ~shouldValidate=true, ())
    }

    let handleOnSubmit = (
      _ => {
        mutate(
          ~variables={
            input: Mutation.make_updateUserInput(~password, ()),
          },
          ~onCompleted=({updateUser}, _) => {
            switch updateUser {
            | #User(_) => {
                addToast(.
                  <div className=%twc("flex items-center")>
                    <IconCheck height="24" width="24" fill="#12B564" className=%twc("mr-2") />
                    {j`비밀번호가 재설정 되었습니다.`->React.string}
                  </div>,
                  {appearance: "success"},
                )

                close()
              }

            | #Error(err) =>
              addToast(.
                <div className=%twc("flex items-center")>
                  <IconError height="24" width="24" className=%twc("mr-2") />
                  {j`오류가 발생하였습니다. 비밀번호를 확인하세요.`->React.string}
                  {err.message->Option.getWithDefault("")->React.string}
                </div>,
                {appearance: "error"},
              )
            | #UnselectedUnionMember(_) =>
              addToast(.
                <div className=%twc("flex items-center")>
                  <IconError height="24" width="24" className=%twc("mr-2") />
                  {j`오류가 발생하였습니다. 비밀번호를 확인하세요.`->React.string}
                </div>,
                {appearance: "error"},
              )
            }
          },
          ~onError={
            err => {
              addToast(.
                <div className=%twc("flex items-center")>
                  <IconError height="24" width="24" className=%twc("mr-2") />
                  {j`오류가 발생하였습니다. 비밀번호를 확인하세요.`->React.string}
                  {err.message->React.string}
                </div>,
                {appearance: "error"},
              )
            }
          },
          (),
        )->ignore
      }
    )->ReactEvents.interceptingHandler

    <form onSubmit={handleOnSubmit}>
      <section className=%twc("h-14 w-full xl:h-auto xl:w-auto xl:mt-10")>
        <div
          className=%twc(
            "flex items-center justify-between px-5 w-full py-4 xl:h-14 xl:w-full xl:pb-10"
          )>
          <div className=%twc("w-6 xl:hidden") />
          <div>
            <span className=%twc("font-bold xl:text-2xl")>
              {`비밀번호 재설정`->React.string}
            </span>
          </div>
          <button type_="button" className=%twc("focus:outline-none") onClick={handleCloseButton}>
            <IconClose height="24" width="24" fill="#262626" />
          </button>
        </div>
      </section>
      <section className=%twc("pt-12 xl:pt-3 mb-6 px-4")>
        <div className=%twc("flex flex-col")>
          <div className=%twc("flex flex-col mb-5")>
            <div className=%twc("mb-2")>
              <span className=%twc("font-bold")>
                {`새로운 비밀번호 입력`->React.string}
              </span>
            </div>
            <Input
              name="new-password"
              size=Input.Large
              type_={showPassword ? "text" : "password"}
              value={password}
              placeholder={`새로운 비밀번호(영문, 숫자 조합 6-15자리)`}
              onChange={handlePasswordChange}
              className=%twc(
                "w-full border border-border-default-L1 p-3 rounded-xl focus:outline-none"
              )
              error={state.error->Option.map(({message}) => message)}
              disabled={mutating}
            />
          </div>
          <div className=%twc("flex mb-10 items-center")>
            <Checkbox
              checked={showPassword}
              id="password-reveal"
              name="password-reveal"
              onChange={_ => setShowPassword(._ => !showPassword)}
            />
            <label className=%twc("ml-2 text-text-L1") htmlFor="password-reveal">
              {`비밀번호 표시`->React.string}
            </label>
          </div>
        </div>
        <button
          type_="submit"
          className=%twc("bg-green-500 rounded-xl w-full py-4")
          disabled={mutating || state.error->Option.isSome}>
          <span className=%twc("text-white")> {`재설정`->React.string} </span>
        </button>
      </section>
    </form>
  }
}

type step = Confirm | Update

@react.component
let make = (~isOpen, ~onClose, ~email) => {
  let (step, setStep) = React.Uncurried.useState(_ => Confirm)
  let (isShowNotice, setShowNotice) = React.Uncurried.useState(_ => DialogCmp.Hide)

  let handleCloseButton = _ => {
    setShowNotice(._ => DialogCmp.Show)
  }

  <>
    <Dialog.Root _open={isOpen}>
      <Dialog.Overlay className=%twc("dialog-overlay") />
      <Dialog.Content
        className=%twc(
          "dialog-content-plain bottom-0 left-0 xl:bottom-auto xl:left-auto xl:rounded-2xl xl:state-open:top-1/2 xl:state-open:left-1/2 xl:state-open:-translate-x-1/2 xl:state-open:-translate-y-1/2 dialog-content-z-15"
        )>
        <div
          className=%twc(
            "fixed top-0 left-0 h-full xl:static bg-white w-full max-w-3xl xl:min-h-fit xl:min-w-min xl:w-[90vh] xl:max-w-[480px] xl:max-h-[85vh] "
          )>
          {switch step {
          | Confirm => <ConfirmView email handleCloseButton nextStep={_ => setStep(._ => Update)} />
          | Update =>
            <UpdateView
              handleCloseButton
              close={_ => {
                setStep(._ => Confirm)
                onClose()
              }}
            />
          }}
        </div>
      </Dialog.Content>
    </Dialog.Root>
    <DialogCmp
      isShow=isShowNotice
      onCancel={_ => setShowNotice(._ => DialogCmp.Hide)}
      onConfirm={_ => {
        setShowNotice(._ => DialogCmp.Hide)
        setStep(._ => Confirm)
        onClose()
      }}
      kindOfConfirm=DialogCmp.Negative
      textOnCancel={`아니요`}
      textOnConfirm={`네`}
      boxStyle=%twc("border rounded-xl")>
      <div className=%twc("text-center")>
        {`비밀번호 재설정이 진행중입니다.`->React.string}
        <br />
        {`진행을 취소하시겠어요?`->React.string}
      </div>
    </DialogCmp>
  </>
}
