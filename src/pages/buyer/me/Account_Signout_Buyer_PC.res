module Query = %relay(`
  query AccountSignoutBuyerPC_Query {
    viewer {
      ...AccountSignoutBuyerPC_Fragment
    }
  }
`)

module Fragment = %relay(`
  fragment AccountSignoutBuyerPC_Fragment on User {
    uid
    sinsunCashDeposit
    debtAmount
  }
`)
module Signout = {
  @react.component
  let make = (
    ~sinsunCashDeposit,
    ~selected,
    ~setSelected,
    ~etc,
    ~setEtc,
    ~loading,
    ~onClickSignout,
    ~debtAmount,
  ) => {
    let router = Next.Router.useRouter()
    let (agree, setAgree) = React.Uncurried.useState(_ => false)

    let isDebtor = debtAmount->Option.mapWithDefault(false, a => a > 0)
    let disabled = !agree || loading || selected->Set.String.isEmpty || isDebtor

    <div className=%twc("flex flex-col mt-10 max-w-[640px]")>
      <Account_Signout_Reason_Buyer.PC selected setSelected etc setEtc />
      <div className=%twc("mt-4 p-10 border border-[#DCDFE3]")>
        <div> {`회원탈퇴 전에 유의사항을 꼭 확인하세요.`->React.string} </div>
        <div className=%twc("border border-gray-100 mt-6 mb-4") />
        <Account_Signout_Term_Buyer className=%twc("mt-6 list-disc pl-4 text-sm") />
      </div>
      <div
        className=%twc(
          "mt-4 py-[22px] px-10 border border-[#DCDFE3] flex items-center justify-between"
        )>
        <div className=%twc("text-gray-600 text-sm")> {`신선캐시 잔액`->React.string} </div>
        <div className=%twc("font-bold text-text-L1 text-[15px]")>
          {`${sinsunCashDeposit->Float.fromInt->Locale.Float.show(~digits=0)}원`->React.string}
        </div>
      </div>
      {switch debtAmount {
      | Some(amount) =>
        <div
          className=%twc(
            "mt-4 py-[22px] px-10 border border-[#DCDFE3] flex items-center justify-between"
          )>
          <div className=%twc("text-gray-600 text-sm")>
            {`나중결제 미정산 금액`->React.string}
          </div>
          <div className=%twc("font-bold text-text-L1 text-[15px]")>
            {`${amount->Float.fromInt->Locale.Float.show(~digits=0)}원`->React.string}
          </div>
        </div>
      | None => React.null
      }}
      {isDebtor
        ? <div className=%twc("text-notice text-sm mt-1 text-right")>
            {`미정산 금액이 남아있기 때문에 탈퇴를 할 수 없습니다.`->React.string}
          </div>
        : React.null}
      <div className=%twc("mt-10 flex flex-col items-center mb-20")>
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
        <div className=%twc("flex mt-10")>
          <button
            className=%twc(
              "bg-gray-150 rounded-xl focus:outline-none w-full py-4 text-center mr-1 px-[70px]"
            )
            onClick={_ => router->Next.Router.push("/buyer/me/account")}
            disabled={loading}>
            <span className=%twc("font-bold")> {`취소`->React.string} </span>
          </button>
          <button
            className={cx([
              %twc("rounded-xl focus:outline-none w-full py-4 text-center ml-1 px-[70px]"),
              disabled ? %twc("bg-gray-150") : %twc("bg-[#FCF0E6]"),
            ])}
            onClick={_ => onClickSignout()}
            disabled>
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
    </div>
  }
}

type step = Confirm | Signout
module Content = {
  @react.component
  let make = (~query) => {
    let {addToast} = ReactToastNotifications.useToasts()
    let {uid: email, sinsunCashDeposit, debtAmount} = Fragment.use(query)

    let (step, setStep) = React.Uncurried.useState(_ => Confirm)
    let (password, setPassword) = React.Uncurried.useState(_ => "")
    let (selected, setSelected) = React.Uncurried.useState(_ => Set.String.empty)
    let (etc, setEtc) = React.Uncurried.useState(_ => "")

    let (loading, setLoading) = React.Uncurried.useState(_ => false)

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

    <div className=%twc("m-auto pt-10 flex flex-col min-w-[375px]")>
      <div className=%twc("text-center")>
        <span className=%twc("font-bold text-[26px]")> {`회원탈퇴`->React.string} </span>
      </div>
      {switch step {
      | Confirm =>
        <Account_Signout_ConfirmPassword_Buyer.PC
          email nextStep={_ => setStep(._ => Signout)} password setPassword
        />
      | Signout =>
        <Signout
          sinsunCashDeposit selected setSelected etc setEtc loading onClickSignout debtAmount
        />
      }}
    </div>
  }
}

type props = {
  gnbBanners: array<GnbBannerListBuyerQuery_graphql.Types.response_gnbBanners>,
  displayCategories: array<ShopCategorySelectBuyerQuery_graphql.Types.response_displayCategories>,
}
type params
type previewData

let default = ({gnbBanners, displayCategories}) => {
  let router = Next.Router.useRouter()
  let queryData = Query.use(~variables=(), ())

  <div className=%twc("w-full min-h-screen flex flex-col")>
    <div className=%twc("flex")>
      <Header_Buyer.PC key=router.asPath gnbBanners displayCategories />
    </div>
    <Authorization.Buyer title={`신선하이`}>
      <RescriptReactErrorBoundary
        fallback={_ =>
          <div> {`계정정보를 가져오는데 실패했습니다`->React.string} </div>}>
        <React.Suspense fallback={React.null}>
          {switch queryData.viewer {
          | Some(viewer) => <Content query={viewer.fragmentRefs} />
          | None =>
            <div> {`계정정보를 가져오는데 실패했습니다`->React.string} </div>
          }}
        </React.Suspense>
      </RescriptReactErrorBoundary>
    </Authorization.Buyer>
    <Footer_Buyer.PC />
  </div>
}

@unboxed
type rec result = Result(Js.Promise.t<{..}>): result

let getServerSideProps = ctx => {
  let deviceType = DeviceDetect.detectDeviceFromCtx(ctx)

  let gnb = () =>
    GnbBannerList_Buyer.Query.fetchPromised(
      ~environment=RelayEnv.envSinsunMarket,
      ~variables=(),
      (),
    )
  let displayCategories = () =>
    ShopCategorySelect_Buyer.Query.fetchPromised(
      ~environment=RelayEnv.envSinsunMarket,
      ~variables={onlyDisplayable: Some(true), types: Some([#NORMAL]), parentId: None},
      (),
    )

  switch deviceType {
  | DeviceDetect.PC =>
    Result(
      Js.Promise.all2((gnb(), displayCategories()))
      |> Js.Promise.then_(((
        gnb: GnbBannerListBuyerQuery_graphql.Types.response,
        displayCategories: ShopCategorySelectBuyerQuery_graphql.Types.response,
      )) => {
        Js.Promise.resolve({
          "props": {
            "gnbBanners": gnb.gnbBanners,
            "displayCategories": displayCategories.displayCategories,
          },
        })
      })
      |> Js.Promise.catch(_ => {
        Js.Promise.resolve({
          "props": {
            "gnbBanners": [],
            "displayCategories": [],
          },
        })
      }),
    )
  | DeviceDetect.Mobile
  | DeviceDetect.Unknown =>
    Result(
      Js.Promise.resolve({
        "redirect": {
          "permanent": true,
          "destination": "/buyer/me/account",
        },
        "props": Js.Obj.empty(),
      }),
    )
  }
}
