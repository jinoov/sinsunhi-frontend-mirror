module Fragment = %relay(`
  fragment MyInfoAccountBuyer_Fragment on User {
    name
    manager
    uid
    verifications {
      phoneVerificationStatus
      isValidBusinessRegistrationNumberByViewer
    }
    businessRegistrationNumber
    address
    phone
    ...MyInfoMarketingTermSwitcherBuyer_Fragment
    ...UpdateMarketingTermBuyer_Fragment
    ...AccountSignoutBuyerMobile_Fragment
  }
`)

module LogoutDialog = {
  @react.component
  let make = (~isOpen, ~onCancel) => {
    let router = Next.Router.useRouter()
    let user = CustomHooks.Auth.use()

    let logOut = (
      _ => {
        CustomHooks.Auth.logOut()
        ChannelTalkHelper.logout()
        let role = user->CustomHooks.Auth.toOption->Option.map(user' => user'.role)
        switch role {
        | Some(Seller) => router->Next.Router.push("/seller/signin")
        | Some(Buyer) => router->Next.Router.push("/buyer/signin")
        | Some(Admin)
        | Some(ExternalStaff) =>
          router->Next.Router.push("/admin/signin")
        | None => ()
        }
      }
    )->ReactEvents.interceptingHandler

    <Dialog
      isShow={isOpen}
      onCancel={onCancel}
      onConfirm={logOut}
      textOnCancel={`닫기`}
      textOnConfirm={`로그아웃`}
      kindOfConfirm=Dialog.Negative
      boxStyle=%twc("rounded-xl")>
      <div className=%twc("text-center")> {`로그아웃 하시겠어요?`->React.string} </div>
    </Dialog>
  }
}

module PC = {
  @module("../../../../../public/assets/write.svg")
  external writeIcon: string = "default"

  type modal = Password | Company | Manager | Phone | BizNumber | Location | Logout

  @react.component
  let make = (~query) => {
    let router = Next.Router.useRouter()
    let (openModal, setOpenModal) = React.Uncurried.useState(_ => None)

    let {
      name: company,
      manager,
      uid: email,
      verifications,
      address,
      phone,
      businessRegistrationNumber: bizNumber,
      fragmentRefs,
    } = Fragment.use(query)

    let displayBizNumber =
      bizNumber->Option.mapWithDefault("", str =>
        str->Js.String2.replaceByRe(%re("/(^\d{3})(\d+)?(\d{5})$/"), "$1-$2-$3")
      )
    let displayPhone =
      phone->Js.String2.replaceByRe(
        %re("/(^1[0-9]{3}|^0[0-9]{2})([0-9]+)?([0-9]{4})$/"),
        "$1-$2-$3",
      )

    let oldUI =
      <>
        <MyInfo_Layout_Buyer query>
          <div className=%twc("p-7 bg-white ml-4 w-full")>
            <div className=%twc("font-bold text-2xl")> {`계정정보`->React.string} </div>
            <div className=%twc("py-7 flex flex-col")>
              <div className=%twc("mb-2")>
                <div className=%twc("flex py-5")>
                  <div className=%twc("min-w-[168px] w-1/6 font-bold")>
                    {`이메일`->React.string}
                  </div>
                  {email->React.string}
                </div>
                <div className=%twc("flex pt-3 pb-5 border-b border-gray-100 items-center")>
                  <div className=%twc("min-w-[168px] w-1/6 font-bold")>
                    {`비밀번호`->React.string}
                  </div>
                  <button
                    className=%twc("py-2 px-3 bg-gray-150 rounded-lg")
                    onClick={_ => setOpenModal(._ => Some(Password))}>
                    {`비밀번호 재설정`->React.string}
                  </button>
                </div>
              </div>
              <div className=%twc("mb-2")>
                <div className=%twc("flex py-5")>
                  <div className=%twc("min-w-[168px] w-1/6 font-bold")>
                    {`회사명`->React.string}
                  </div>
                  <div className=%twc("flex items-center")>
                    {company->React.string}
                    <button onClick={_ => setOpenModal(._ => Some(Company))}>
                      <img
                        src="/assets/write.svg" className=%twc("ml-2") width="16px" height="16px"
                      />
                    </button>
                  </div>
                </div>
                <div className=%twc("flex py-5")>
                  <div className=%twc("min-w-[168px] w-1/6 font-bold")>
                    {`담당자명`->React.string}
                  </div>
                  <div className=%twc("flex items-center")>
                    {manager->Option.getWithDefault("")->React.string}
                    <button onClick={_ => setOpenModal(._ => Some(Manager))}>
                      <img
                        src="/assets/write.svg" className=%twc("ml-2") width="16px" height="16px"
                      />
                    </button>
                  </div>
                </div>
                <div className=%twc("flex py-5")>
                  <div className=%twc("min-w-[168px] w-1/6 font-bold")>
                    {`휴대전화번호`->React.string}
                  </div>
                  <div className=%twc("flex items-center")>
                    {displayPhone->React.string}
                    <button onClick={_ => setOpenModal(._ => Some(Phone))}>
                      <img
                        src="/assets/write.svg" className=%twc("ml-2") width="16px" height="16px"
                      />
                    </button>
                    {switch verifications->Option.map(({phoneVerificationStatus: status}) =>
                      status
                    ) {
                    | Some(#VERIFIED) => React.null
                    | Some(#UNVERIFIED)
                    | Some(_)
                    | None =>
                      <span className=%twc("text-notice ml-2")>
                        {`인증 필요`->React.string}
                      </span>
                    }}
                  </div>
                </div>
                <div className=%twc("flex py-5")>
                  <div className=%twc("min-w-[168px] w-1/6 font-bold")>
                    {`사업자 등록번호`->React.string}
                  </div>
                  <div className=%twc("flex items-center")>
                    {displayBizNumber->React.string}
                    <button onClick={_ => setOpenModal(._ => Some(BizNumber))}>
                      <img
                        src="/assets/write.svg" className=%twc("ml-2") width="16px" height="16px"
                      />
                    </button>
                    {switch verifications->Option.map(({
                      isValidBusinessRegistrationNumberByViewer: valid,
                    }) => valid) {
                    | None
                    | Some(false) =>
                      <span className=%twc("text-notice ml-2")>
                        {`유효하지 않음`->React.string}
                      </span>
                    | Some(true) => React.null
                    }}
                  </div>
                </div>
                <div className=%twc("flex pt-3 pb-5 border-b border-gray-100")>
                  <div className=%twc("min-w-[168px] w-1/6 font-bold")>
                    {`소재지`->React.string}
                  </div>
                  <div className=%twc("flex items-center")>
                    <p
                      style={ReactDOM.Style.make(~wordBreak="keep-all", ())}
                      className=%twc("text-left")>
                      {address->Option.getWithDefault("")->React.string}
                    </p>
                    <button onClick={_ => setOpenModal(._ => Some(Location))}>
                      <img
                        src="/assets/write.svg" className=%twc("ml-2") width="16px" height="16px"
                      />
                    </button>
                    {switch address->Option.getWithDefault("") {
                    | str if str == "" =>
                      <span className=%twc("text-notice ml-2")>
                        {`입력 필요`->React.string}
                      </span>
                    | _ => React.null
                    }}
                  </div>
                </div>
              </div>
              <div className=%twc("mb-2")>
                <div className=%twc("flex py-5")>
                  <div className=%twc("min-w-[168px] w-1/6 font-bold")>
                    {`서비스 이용동의`->React.string}
                  </div>
                  <div className=%twc("flex-1")>
                    <div className=%twc("py-3")>
                      <Next.Link href=Env.termsUrl>
                        <a className=%twc("contents") target="_blank" rel="noopener">
                          <span className=%twc("font-bold")> {`필수약관1`->React.string} </span>
                          <span className=%twc("ml-2 text-sm text-text-L3 ")>
                            {`자세히 보기`->React.string}
                          </span>
                        </a>
                      </Next.Link>
                    </div>
                    <div className=%twc("py-3")>
                      <Next.Link href=Env.privacyPolicyUrl>
                        <a className=%twc("contents") target="_blank" rel="noopener">
                          <span className=%twc("font-bold")> {`필수약관2`->React.string} </span>
                          <span className=%twc("ml-2 text-sm text-text-L3 ")>
                            {`자세히 보기`->React.string}
                          </span>
                        </a>
                      </Next.Link>
                    </div>
                    <div className=%twc("py-3 flex items-center justify-between w-full")>
                      <Next.Link href=Env.privacyMarketing>
                        <a className=%twc("inline") target="_blank" rel="noopener">
                          <span className=%twc("font-bold")>
                            {`마케팅 이용동의(선택)`->React.string}
                          </span>
                          <span className=%twc("ml-2 text-sm text-text-L3 ")>
                            {`자세히 보기`->React.string}
                          </span>
                        </a>
                      </Next.Link>
                      <MyInfo_MarketingTerm_Switcher_Buyer query={fragmentRefs} />
                    </div>
                  </div>
                </div>
                <div className=%twc("flex py-5 items-center")>
                  <div className=%twc("min-w-[168px] w-1/6 font-bold")>
                    {`로그아웃`->React.string}
                  </div>
                  <button
                    className=%twc("py-2 px-3 bg-gray-150 rounded-lg")
                    onClick={_ => setOpenModal(._ => Some(Logout))}>
                    {`로그아웃`->React.string}
                  </button>
                </div>
                <div className=%twc("flex py-5 items-center")>
                  <div className=%twc("min-w-[168px] w-1/6 font-bold")>
                    {`회원탈퇴`->React.string}
                  </div>
                  <button
                    className=%twc("py-2 px-3 bg-gray-150 rounded-lg")
                    onClick={_ => router->Next.Router.push("/buyer/me/account/leave")}>
                    {`회원탈퇴`->React.string}
                  </button>
                </div>
              </div>
              <div />
              <div />
            </div>
          </div>
        </MyInfo_Layout_Buyer>
        <Update_Password_Buyer
          isOpen={openModal == Some(Password)} onClose={_ => setOpenModal(._ => None)} email
        />
        <Update_CompanyName_Buyer
          isOpen={openModal == Some(Company)}
          onClose={_ => setOpenModal(._ => None)}
          key=company
          defaultValue=company
        />
        <Update_Manager_Buyer
          isOpen={openModal == Some(Manager)}
          onClose={_ => setOpenModal(._ => None)}
          key=?manager
          defaultValue=?manager
        />
        <Update_PhoneNumber_Buyer
          isOpen={openModal == Some(Phone)} onClose={_ => setOpenModal(._ => None)}
        />
        <Update_BusinessNumber_Buyer
          isOpen={openModal == Some(BizNumber)}
          onClose={_ => setOpenModal(._ => None)}
          key=displayBizNumber
          defaultValue=displayBizNumber
        />
        <Update_Address_Buyer
          isOpen={openModal == Some(Location)} onClose={_ => setOpenModal(._ => None)} popup=true
        />
        <LogoutDialog
          isOpen={openModal == Some(Logout) ? Dialog.Show : Dialog.Hide}
          onCancel={_ => setOpenModal(._ => None)}
        />
      </>

    <FeatureFlagWrapper featureFlag=#HOME_UI_UX fallback=oldUI>
      {<>
        <MyInfo_Layout_Buyer query>
          <div
            className=%twc(
              "pt-10 px-[50px] w-full rounded-sm bg-white shadow-[0px_10px_40px_10px_rgba(0,0,0,0.03)]"
            )>
            <div className=%twc("font-bold text-2xl")> {`계정정보`->React.string} </div>
            <div className=%twc("py-7 flex flex-col")>
              <div className=%twc("mb-2")>
                <div className=%twc("flex py-5")>
                  <div className=%twc("min-w-[168px] w-1/6 font-bold")>
                    {`이메일`->React.string}
                  </div>
                  {email->React.string}
                </div>
                <div className=%twc("flex pt-3 pb-5 border-b border-gray-100 items-center")>
                  <div className=%twc("min-w-[168px] w-1/6 font-bold")>
                    {`비밀번호`->React.string}
                  </div>
                  <button
                    className=%twc("py-2 px-3 bg-gray-150 rounded-lg")
                    onClick={_ => setOpenModal(._ => Some(Password))}>
                    {`비밀번호 재설정`->React.string}
                  </button>
                </div>
              </div>
              <div className=%twc("mb-2")>
                <div className=%twc("flex py-5")>
                  <div className=%twc("min-w-[168px] w-1/6 font-bold")>
                    {`회사명`->React.string}
                  </div>
                  <div className=%twc("flex items-center")>
                    {company->React.string}
                    <button onClick={_ => setOpenModal(._ => Some(Company))}>
                      <img
                        src="/assets/write.svg" className=%twc("ml-2") width="16px" height="16px"
                      />
                    </button>
                  </div>
                </div>
                <div className=%twc("flex py-5")>
                  <div className=%twc("min-w-[168px] w-1/6 font-bold")>
                    {`담당자명`->React.string}
                  </div>
                  <div className=%twc("flex items-center")>
                    {manager->Option.getWithDefault("")->React.string}
                    <button onClick={_ => setOpenModal(._ => Some(Manager))}>
                      <img
                        src="/assets/write.svg" className=%twc("ml-2") width="16px" height="16px"
                      />
                    </button>
                  </div>
                </div>
                <div className=%twc("flex py-5")>
                  <div className=%twc("min-w-[168px] w-1/6 font-bold")>
                    {`휴대전화번호`->React.string}
                  </div>
                  <div className=%twc("flex items-center")>
                    {displayPhone->React.string}
                    <button onClick={_ => setOpenModal(._ => Some(Phone))}>
                      <img
                        src="/assets/write.svg" className=%twc("ml-2") width="16px" height="16px"
                      />
                    </button>
                    {switch verifications->Option.map(({phoneVerificationStatus: status}) =>
                      status
                    ) {
                    | Some(#VERIFIED) => React.null
                    | Some(#UNVERIFIED)
                    | Some(_)
                    | None =>
                      <span className=%twc("text-notice ml-2")>
                        {`인증 필요`->React.string}
                      </span>
                    }}
                  </div>
                </div>
                <div className=%twc("flex py-5")>
                  <div className=%twc("min-w-[168px] w-1/6 font-bold")>
                    {`사업자 등록번호`->React.string}
                  </div>
                  <div className=%twc("flex items-center")>
                    {displayBizNumber->React.string}
                    <button onClick={_ => setOpenModal(._ => Some(BizNumber))}>
                      <img
                        src="/assets/write.svg" className=%twc("ml-2") width="16px" height="16px"
                      />
                    </button>
                    {switch verifications->Option.map(({
                      isValidBusinessRegistrationNumberByViewer: valid,
                    }) => valid) {
                    | None
                    | Some(false) =>
                      <span className=%twc("text-notice ml-2")>
                        {`유효하지 않음`->React.string}
                      </span>
                    | Some(true) => React.null
                    }}
                  </div>
                </div>
                <div className=%twc("flex pt-3 pb-5 border-b border-gray-100")>
                  <div className=%twc("min-w-[168px] w-1/6 font-bold")>
                    {`소재지`->React.string}
                  </div>
                  <div className=%twc("flex items-center")>
                    <p
                      style={ReactDOM.Style.make(~wordBreak="keep-all", ())}
                      className=%twc("text-left")>
                      {address->Option.getWithDefault("")->React.string}
                    </p>
                    <button onClick={_ => setOpenModal(._ => Some(Location))}>
                      <img
                        src="/assets/write.svg" className=%twc("ml-2") width="16px" height="16px"
                      />
                    </button>
                    {switch address->Option.getWithDefault("") {
                    | str if str == "" =>
                      <span className=%twc("text-notice ml-2")>
                        {`입력 필요`->React.string}
                      </span>
                    | _ => React.null
                    }}
                  </div>
                </div>
              </div>
              <div className=%twc("mb-2")>
                <div className=%twc("flex py-5")>
                  <div className=%twc("min-w-[168px] w-1/6 font-bold")>
                    {`서비스 이용동의`->React.string}
                  </div>
                  <div className=%twc("flex-1")>
                    <div className=%twc("py-3")>
                      <Next.Link href=Env.termsUrl>
                        <a className=%twc("contents") target="_blank" rel="noopener">
                          <span className=%twc("font-bold")> {`필수약관1`->React.string} </span>
                          <span className=%twc("ml-2 text-sm text-text-L3 ")>
                            {`자세히 보기`->React.string}
                          </span>
                        </a>
                      </Next.Link>
                    </div>
                    <div className=%twc("py-3")>
                      <Next.Link href=Env.privacyPolicyUrl>
                        <a className=%twc("contents") target="_blank" rel="noopener">
                          <span className=%twc("font-bold")> {`필수약관2`->React.string} </span>
                          <span className=%twc("ml-2 text-sm text-text-L3 ")>
                            {`자세히 보기`->React.string}
                          </span>
                        </a>
                      </Next.Link>
                    </div>
                    <div className=%twc("py-3 flex items-center justify-between w-full")>
                      <Next.Link href=Env.privacyMarketing>
                        <a className=%twc("inline") target="_blank" rel="noopener">
                          <span className=%twc("font-bold")>
                            {`마케팅 이용동의(선택)`->React.string}
                          </span>
                          <span className=%twc("ml-2 text-sm text-text-L3 ")>
                            {`자세히 보기`->React.string}
                          </span>
                        </a>
                      </Next.Link>
                      <MyInfo_MarketingTerm_Switcher_Buyer query={fragmentRefs} />
                    </div>
                  </div>
                </div>
                <div className=%twc("flex py-5 items-center")>
                  <div className=%twc("min-w-[168px] w-1/6 font-bold")>
                    {`로그아웃`->React.string}
                  </div>
                  <button
                    className=%twc("py-2 px-3 bg-gray-150 rounded-lg")
                    onClick={_ => setOpenModal(._ => Some(Logout))}>
                    {`로그아웃`->React.string}
                  </button>
                </div>
                <div className=%twc("flex py-5 items-center")>
                  <div className=%twc("min-w-[168px] w-1/6 font-bold")>
                    {`회원탈퇴`->React.string}
                  </div>
                  <button
                    className=%twc("py-2 px-3 bg-gray-150 rounded-lg")
                    onClick={_ => router->Next.Router.push("/buyer/me/account/leave")}>
                    {`회원탈퇴`->React.string}
                  </button>
                </div>
              </div>
              <div />
              <div />
            </div>
          </div>
        </MyInfo_Layout_Buyer>
        <Update_Password_Buyer
          isOpen={openModal == Some(Password)} onClose={_ => setOpenModal(._ => None)} email
        />
        <Update_CompanyName_Buyer
          isOpen={openModal == Some(Company)}
          onClose={_ => setOpenModal(._ => None)}
          key=company
          defaultValue=company
        />
        <Update_Manager_Buyer
          isOpen={openModal == Some(Manager)}
          onClose={_ => setOpenModal(._ => None)}
          key=?manager
          defaultValue=?manager
        />
        <Update_PhoneNumber_Buyer
          isOpen={openModal == Some(Phone)} onClose={_ => setOpenModal(._ => None)}
        />
        <Update_BusinessNumber_Buyer
          isOpen={openModal == Some(BizNumber)}
          onClose={_ => setOpenModal(._ => None)}
          key=displayBizNumber
          defaultValue=displayBizNumber
        />
        <Update_Address_Buyer
          isOpen={openModal == Some(Location)} onClose={_ => setOpenModal(._ => None)} popup=true
        />
        <LogoutDialog
          isOpen={openModal == Some(Logout) ? Dialog.Show : Dialog.Hide}
          onCancel={_ => setOpenModal(._ => None)}
        />
      </>}
    </FeatureFlagWrapper>
  }
}

module Mobile = {
  type modal =
    Password | Company | Manager | Phone | BizNumber | Location | Terms | Logout | Signout

  let toFragment = modal =>
    switch modal {
    | Password => "#password"
    | Company => "#company"
    | Manager => "#manager"
    | Phone => "#phone"
    | BizNumber => "#biz-number"
    | Location => "#location"
    | Terms => "#terms"
    | Logout => "#logout"
    | Signout => "#signout"
    }

  @react.component
  let make = (~query) => {
    let router = Next.Router.useRouter()
    let (openModal, setOpenModal) = React.Uncurried.useState(_ => None)

    let {
      name: company,
      manager,
      uid: email,
      verifications,
      address,
      phone,
      businessRegistrationNumber: bizNumber,
      fragmentRefs,
    } = Fragment.use(query)

    let displayBizNumber =
      bizNumber->Option.mapWithDefault("", str =>
        str->Js.String2.replaceByRe(%re("/(^\d{3})(\d+)?(\d{5})$/"), "$1-$2-$3")
      )
    let displayPhone =
      phone->Js.String2.replaceByRe(
        %re("/(^1[0-9]{3}|^0[0-9]{2})([0-9]+)?([0-9]{4})$/"),
        "$1-$2-$3",
      )

    // only for mobile
    // related PR: #860 모달, 드로워에 대한 뒤로가기 처리 방법을 찾는 시도.
    // 모달이 열릴 때, fragment 를 추가하고 뒤로가기 하여 모달이 닫히게 한다.
    let open_ = (~modal: modal) => {
      if !(router.asPath->Js.String2.includes(toFragment(modal))) {
        router->Next.Router.push(`${router.asPath}${toFragment(modal)}`)
      }
      setOpenModal(._ => Some(modal))
    }

    // url에 fragment가 없으면 모달창 닫는다.
    // 모달 닫는 것을 직접 하지 않고 url이 변화할 때마다 side effect로 처리한다.
    React.useEffect1(() => {
      if !(router.asPath->Js.String2.includes("#")) && openModal->Option.isSome {
        setOpenModal(._ => None)
      }

      None
    }, [router.asPath])

    <div className=%twc("block w-full bg-white absolute top-0 pt-14 min-h-screen")>
      <div className=%twc("w-full max-w-3xl mx-auto bg-white h-full")>
        <section>
          <ol className=%twc("bg-white px-4")>
            <li className=%twc("py-5 flex items-center w-full justify-between")>
              <div className=%twc("flex")>
                <div className=%twc("min-w-[105px] mr-2")>
                  <span className=%twc("font-bold")> {`이메일`->React.string} </span>
                </div>
                <div> {email->React.string} </div>
              </div>
            </li>
            <button className=%twc("w-full flex") onClick={_ => open_(~modal=Password)}>
              <li
                className=%twc(
                  "py-5 flex items-center w-full border-t border-gray-100 justify-between"
                )>
                <div className=%twc("min-w-[105px] mr-2 text-left")>
                  <span className=%twc("font-bold")> {`비밀번호`->React.string} </span>
                </div>
                <div className=%twc("")>
                  <IconArrow height="16" width="16" fill="#B2B2B2" />
                </div>
              </li>
            </button>
          </ol>
          <div className=%twc("h-3 bg-gray-100") />
          <ol className=%twc("bg-white")>
            <button className=%twc("w-full flex") onClick={_ => open_(~modal=Company)}>
              <li className=%twc("py-5 px-4 flex items-center w-full justify-between")>
                <div className=%twc("flex")>
                  <div className=%twc("min-w-[105px] mr-2 text-left")>
                    <span className=%twc("font-bold")> {`회사명`->React.string} </span>
                  </div>
                  {company->React.string}
                </div>
                <div className=%twc("")>
                  <IconArrow height="16" width="16" fill="#B2B2B2" />
                </div>
              </li>
            </button>
            <button className=%twc("w-full flex") onClick={_ => open_(~modal=Manager)}>
              <li
                className=%twc(
                  "py-5 px-4 flex items-center w-full border-t border-gray-100 justify-between"
                )>
                <div className=%twc("flex")>
                  <div className=%twc("min-w-[105px] mr-2 text-left")>
                    <span className=%twc("font-bold")> {`담당자명`->React.string} </span>
                  </div>
                  <div> {manager->Option.getWithDefault("")->React.string} </div>
                </div>
                <div className=%twc("")>
                  <IconArrow height="16" width="16" fill="#B2B2B2" />
                </div>
              </li>
            </button>
            <button className=%twc("w-full flex") onClick={_ => open_(~modal=Phone)}>
              <li
                className=%twc(
                  "py-5 px-4 flex items-center w-full border-t border-gray-100 justify-between"
                )>
                <div className=%twc("flex")>
                  <div className=%twc("min-w-[105px] mr-2 text-left")>
                    <span className=%twc("font-bold")> {`휴대전화번호`->React.string} </span>
                  </div>
                  <div className=%twc("flex flex-wrap")>
                    {displayPhone->React.string}
                    {switch verifications->Option.map(({phoneVerificationStatus: status}) =>
                      status
                    ) {
                    | Some(#VERIFIED) => React.null
                    | Some(#UNVERIFIED)
                    | Some(_)
                    | None =>
                      <span className=%twc("text-notice ml-2")>
                        {`인증 필요`->React.string}
                      </span>
                    }}
                  </div>
                </div>
                <div className=%twc("")>
                  <IconArrow height="16" width="16" fill="#B2B2B2" />
                </div>
              </li>
            </button>
            <button className=%twc("w-full flex") onClick={_ => open_(~modal=BizNumber)}>
              <li
                className=%twc(
                  "py-5 px-4 flex items-center w-full border-t border-gray-100 justify-between"
                )>
                <div className=%twc("flex")>
                  <div className=%twc("min-w-[105px] mr-2 text-left")>
                    <span className=%twc("font-bold")>
                      {`사업자 등록번호`->React.string}
                    </span>
                  </div>
                  <div className=%twc("flex flex-wrap")>
                    {displayBizNumber->React.string}
                    {switch verifications->Option.map(({
                      isValidBusinessRegistrationNumberByViewer: valid,
                    }) => valid) {
                    | None
                    | Some(false) =>
                      <span className=%twc("text-notice ml-2")>
                        {`유효하지 않음`->React.string}
                      </span>
                    | Some(true) => React.null
                    }}
                  </div>
                </div>
                <div className=%twc("")>
                  <IconArrow height="16" width="16" fill="#B2B2B2" />
                </div>
              </li>
            </button>
            <button className=%twc("w-full flex") onClick={_ => open_(~modal=Location)}>
              <li
                className=%twc(
                  "py-5 px-4 flex items-center w-full border-t border-gray-100 justify-between"
                )>
                <div className=%twc("flex")>
                  <div className=%twc("min-w-[105px] mr-2 text-left")>
                    <span className=%twc("font-bold")> {`소재지`->React.string} </span>
                  </div>
                  <p
                    style={ReactDOM.Style.make(~wordBreak="keep-all", ())}
                    className=%twc("text-left")>
                    {switch address->Option.getWithDefault("") {
                    | str if str == "" =>
                      <span className=%twc("text-notice ml-2")>
                        {`입력 필요`->React.string}
                      </span>
                    | str => str->React.string
                    }}
                  </p>
                </div>
                <div className=%twc("")>
                  <IconArrow height="16" width="16" fill="#B2B2B2" />
                </div>
              </li>
            </button>
          </ol>
          <div className=%twc("h-3 bg-gray-100") />
          <ol className=%twc("bg-white px-4 mb-6")>
            <button className=%twc("w-full flex") onClick={_ => open_(~modal=Terms)}>
              <li className=%twc("py-5 flex items-center w-full justify-between")>
                <div className=%twc("min-w-[105px] mr-2 text-left")>
                  <span className=%twc("font-bold")>
                    {`서비스 이용동의`->React.string}
                  </span>
                </div>
                <div className=%twc("")>
                  <IconArrow height="16" width="16" fill="#B2B2B2" />
                </div>
              </li>
            </button>
            <button className=%twc("w-full flex") onClick={_ => open_(~modal=Logout)}>
              <li
                className=%twc(
                  "py-5 flex items-center w-full justify-between border-t border-gray-100"
                )>
                <div className=%twc("min-w-[105px] mr-2 text-left")>
                  <span className=%twc("font-bold")> {`로그아웃`->React.string} </span>
                </div>
                <div className=%twc("")>
                  <IconArrow height="16" width="16" fill="#B2B2B2" />
                </div>
              </li>
            </button>
            <button className=%twc("w-full flex") onClick={_ => open_(~modal=Signout)}>
              <li
                className=%twc(
                  "py-5 flex items-center w-full justify-between border-t border-gray-100"
                )>
                <div className=%twc("min-w-[105px] mr-2 text-left")>
                  <span className=%twc("font-bold")> {`회원탈퇴`->React.string} </span>
                </div>
                <div className=%twc("")>
                  <IconArrow height="16" width="16" fill="#B2B2B2" />
                </div>
              </li>
            </button>
          </ol>
        </section>
        <Update_Password_Buyer
          isOpen={openModal == Some(Password)} onClose={_ => router->Next.Router.back} email
        />
        <Update_CompanyName_Buyer
          isOpen={openModal == Some(Company)}
          onClose={_ => router->Next.Router.back}
          key={company}
          defaultValue={company}
        />
        <Update_Manager_Buyer
          isOpen={openModal == Some(Manager)}
          onClose={_ => router->Next.Router.back}
          key=?{manager}
          defaultValue=?{manager}
        />
        <Update_PhoneNumber_Buyer
          isOpen={openModal == Some(Phone)} onClose={_ => router->Next.Router.back}
        />
        <Update_BusinessNumber_Buyer
          isOpen={openModal == Some(BizNumber)}
          onClose={_ => router->Next.Router.back}
          key=displayBizNumber
          defaultValue=displayBizNumber
        />
        <Update_Address_Buyer
          isOpen={openModal == Some(Location)} onClose={_ => router->Next.Router.back}
        />
        <Update_MarketingTerm_Buyer
          isOpen={openModal == Some(Terms)}
          onClose={_ => router->Next.Router.back}
          query={fragmentRefs}
        />
        <LogoutDialog
          isOpen={openModal == Some(Logout) ? Dialog.Show : Dialog.Hide}
          onCancel={_ => router->Next.Router.back}
        />
        <Account_Signout_Buyer_Mobile
          isOpen={openModal == Some(Signout)}
          onClose={_ => router->Next.Router.back}
          query={fragmentRefs}
        />
      </div>
    </div>
  }
}
