let checkPasswordRequest = (~successFn, ~failedFn, password) => {
  {
    "password": password,
  }
  ->Js.Json.stringifyAny
  ->Option.map(body => {
    FetchHelper.requestWithRetry(
      ~fetcher=FetchHelper.postWithToken,
      ~url=`${Env.restApiUrl}/user/password/check`,
      ~body,
      ~count=2,
      ~onSuccess={
        _ => successFn()
      },
      ~onFailure={
        _ => failedFn()
      },
    )
  })
  ->ignore
}

module PC = {
  @react.component
  let make = (~email, ~nextStep, ~password, ~setPassword) => {
    let (loading, setLoading) = React.Uncurried.useState(_ => false)
    let (errorMessage, setErrorMessage) = React.Uncurried.useState(_ => None)

    let successFn = _ => {
      nextStep()
      setLoading(._ => false)
      setErrorMessage(._ => None)
    }

    let failedFn = _ => {
      setErrorMessage(._ => Some(`비밀번호가 유효하지 않습니다.`))
      setLoading(._ => false)
    }

    let checkPassword = checkPasswordRequest(~successFn, ~failedFn)

    let handleNext = (
      _ => {
        setLoading(._ => true)
        checkPassword(password)
      }
    )->ReactEvents.interceptingHandler

    let disabled = loading || password == ""

    <div className=%twc("pt-10 pb-[110px]")>
      <p className=%twc("text-center text-text-L1")>
        {`소중한 정보 보호를 위해,`->React.string}
        <br />
        {`사용중인 계정의 비밀번호를 확인해주세요.`->React.string}
      </p>
      <div className=%twc("mt-7")>
        <div className=%twc("flex flex-col mb-5")>
          <div className=%twc("mb-2")>
            <span className=%twc("font-bold")> {`이메일`->React.string} </span>
          </div>
          <div className=%twc("border border-border-default-L1 bg-disabled-L3 rounded-xl p-3")>
            {email->React.string}
          </div>
        </div>
        <form onSubmit={handleNext}>
          <div className=%twc("flex flex-col mb-10")>
            <div className=%twc("mb-2")>
              <span className=%twc("font-bold")> {`비밀번호`->React.string} </span>
            </div>
            <Input
              name="validate-password"
              size=Input.Large
              value={password}
              type_="password"
              placeholder=`비밀번호를 입력해주세요`
              className=%twc("w-full border border-border-default-L1 p-3 rounded-xl")
              onChange={e => {
                ()
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
              disabled ? %twc("bg-disabled-L2") : %twc("bg-green-500"),
            ])}
            type_="submit"
            disabled>
            <span className=%twc("text-white")> {`다음`->React.string} </span>
          </button>
        </form>
      </div>
    </div>
  }
}

module Mobile = {
  @react.component
  let make = (~email, ~nextStep, ~password, ~setPassword) => {
    let (loading, setLoading) = React.Uncurried.useState(_ => false)
    let (errorMessage, setErrorMessage) = React.Uncurried.useState(_ => None)

    let successFn = _ => {
      nextStep()
      setLoading(._ => false)
      setErrorMessage(._ => None)
    }

    let failedFn = _ => {
      setErrorMessage(._ => Some(`비밀번호가 유효하지 않습니다.`))
      setLoading(._ => false)
    }

    let checkPassword = checkPasswordRequest(~successFn, ~failedFn)

    let handleNext = (
      _ => {
        setLoading(._ => true)
        checkPassword(password)
      }
    )->ReactEvents.interceptingHandler

    let disabled = loading || password == ""

    <section className=%twc("my-6 px-4 xl:mt-0 xl:mb-6 max-h-[calc(100vh-70px)] overflow-y-auto")>
      <form onSubmit={handleNext}>
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
              placeholder=`비밀번호를 입력해주세요`
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
              disabled ? %twc("bg-disabled-L2") : %twc("bg-green-500"),
            ])}
            type_="submit"
            disabled>
            <span className=%twc("text-white")> {`다음`->React.string} </span>
          </button>
        </div>
      </form>
    </section>
  }
}
