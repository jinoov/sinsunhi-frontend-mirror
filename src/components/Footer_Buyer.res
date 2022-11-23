@module("../../public/assets/kakao.svg")
external kakaoIcon: string = "default"

module PC = {
  type linkItem = {
    title: string,
    url: string,
    className: option<string>,
  }

  @react.component
  let make = () => {
    let enterprise = `주식회사 그린랩스`
    let representatives = `대표자 : 안동현, 최성우, 신상훈`
    let address = `서울시 송파구 정의로 8길 9 AJ 비전타워 3~6층`
    let businessId = `사업자 등록번호 : 320-88-00732`
    let businessLisenceId = `통신판매업신고 : 2017-서울송파-1843호`
    let businessLisenceUrl = "https://www.ftc.go.kr/bizCommPop.do?wrkr_no=3208800732"
    let businessHour = `월~금 : 09:30~17:30 (Break time 12:00~13:00)`
    let tel = `1670-5245`
    let kakaoLink = "https://pf.kakao.com/_JftIs"

    let oldUI =
      <footer className=%twc("w-full h-[324px] bg-[#FBFBFB] text-gray-800")>
        <div className=%twc("w-[1280px] mx-auto flex justify-between pt-20 pb-10 px-5")>
          <div className=%twc("flex")>
            <Next.Link href={"/buyer"}>
              <a>
                <img
                  src="/assets/sinsunhi-logo.svg"
                  className=%twc("w-[104px] h-7 object-contain")
                  alt="신선하이"
                />
              </a>
            </Next.Link>
            <div className=%twc("ml-14")>
              <ul className=%twc("flex items-center gap-2")>
                {[
                  {
                    title: `회사소개`,
                    url: "https://greenlabs.co.kr",
                    className: None,
                  },
                  {
                    title: `이용약관`,
                    url: Env.termsUrl,
                    className: None,
                  },
                  {
                    title: `개인정보 처리방침`,
                    url: Env.privacyPolicyUrl,
                    className: Some(%twc("font-bold")),
                  },
                  {
                    title: `저작권 보호 안내`,
                    url: Env.copyrightUrl,
                    className: None,
                  },
                ]
                ->Array.mapWithIndex((idx, {title, url, className}) => {
                  <li key={`footer-link-${idx->Int.toString}`}>
                    <Next.Link href=url>
                      <a target="_blank" ?className> {title->React.string} </a>
                    </Next.Link>
                  </li>
                })
                ->React.array}
              </ul>
              <div className=%twc("mt-10 flex flex-col text-sm")>
                <span> {enterprise->React.string} </span>
                <span> {representatives->React.string} </span>
                <span> {address->React.string} </span>
                <div>
                  <span> {businessId->React.string} </span>
                  <span className=%twc("ml-3")> {businessLisenceId->React.string} </span>
                </div>
                <Next.Link href=businessLisenceUrl>
                  <a target="_blank" className=%twc("flex")>
                    <span className=%twc("text-sm text-gray-800 underline")>
                      {`사업자 정보 확인`->React.string}
                    </span>
                    <img
                      src="/assets/arrow-right.svg"
                      className=%twc("w-[16px] h-[16px] mt-[2px]")
                      alt=""
                    />
                  </a>
                </Next.Link>
              </div>
            </div>
          </div>
          <div>
            <div className=%twc("flex")>
              <button
                onClick={_ => ChannelTalk.showMessenger()}
                className=%twc(
                  "h-12 bg-green-50 border-green-500 border rounded-lg flex items-center px-4"
                )>
                <img src="/icons/channeltalk.svg" className=%twc("w-[21px] h-[21px]") alt="" />
                <span className=%twc("text-green-500 font-bold ml-2")>
                  {`채널톡 문의`->React.string}
                </span>
              </button>
              <Next.Link href=kakaoLink>
                <a
                  target="_blank"
                  className=%twc("h-12 ml-3 bg-[#FADE33] rounded-lg flex items-center px-4")>
                  <img src=kakaoIcon alt="카카오톡 문의" className=%twc("w-6 h-6") />
                  <span className=%twc("font-bold ml-2")>
                    {`카카오톡 문의`->React.string}
                  </span>
                </a>
              </Next.Link>
            </div>
            <div className=%twc("flex flex-col mt-5 text-sm")>
              <span className=%twc("font-bold")> {`고객센터`->React.string} </span>
              <span> {`출고/배송 문의 및 입점 제안`->React.string} </span>
              <span> {`상품 CS 및 취소 문의`->React.string} </span>
              <span className=%twc("text-sm text-gray-800")> {businessHour->React.string} </span>
              <span> {tel->React.string} </span>
            </div>
          </div>
        </div>
      </footer>

    let newUI =
      <footer
        className=%twc(
          "w-full max-w-[1920px] min-w-[1280px] mx-auto bg-[#FAFBFC] text-gray-800 border-t-[1px] border-[#F0F2F5]"
        )>
        <div className=%twc("w-[1280px] mx-auto flex justify-between pb-[78px] pt-[68px]")>
          <div className=%twc("flex flex-col")>
            <span className=%twc("font-bold text-[15px] mb-2")>
              {`고객센터 ${tel}`->React.string}
            </span>
            <span className=%twc("text-[13px] text-[#8B8D94] mb-2")>
              {`출고/배송 문의 및 입점 제안, | ${businessHour}`->React.string}
            </span>
            <div className=%twc("flex text-[13px] text-[#8B8D94] mb-9")>
              <span>
                {`${enterprise} | ${representatives} | ${address} | ${businessId} | ${businessLisenceId}`->React.string}
              </span>
            </div>
            <ul className=%twc("flex items-center text-[15px]")>
              {[
                {
                  title: `회사소개`,
                  url: "https://greenlabs.co.kr",
                  className: None,
                },
                {
                  title: `이용안내`,
                  url: "https://shinsunmarket.co.kr/532",
                  className: None,
                },
                {
                  title: `이용약관`,
                  url: Env.termsUrl,
                  className: None,
                },
                {
                  title: `개인정보 처리방침`,
                  url: Env.privacyPolicyUrl,
                  className: Some(%twc("font-bold")),
                },
                {
                  title: `저작권 보호 안내`,
                  url: Env.copyrightUrl,
                  className: Some(%twc("font-bold")),
                },
              ]
              ->Array.mapWithIndex((idx, {title, url, className}) => {
                <li key={`footer-link-${idx->Int.toString}`} className=%twc("mr-8")>
                  <Next.Link href=url>
                    <a target="_blank" ?className> {title->React.string} </a>
                  </Next.Link>
                </li>
              })
              ->React.array}
            </ul>
          </div>
          <div>
            <div className=%twc("flex")>
              <button
                onClick={_ => ChannelTalk.showMessenger()}
                className=%twc("h-10 bg-[#F0F2F5] rounded-lg mr-2")>
                <span
                  className=%twc(
                    "text-[#1F2024] flex items-center px-4 hover:bg-[#1F20240A] active:bg-[#1F202414] h-full rounded-lg duration-200 ease-in-out"
                  )>
                  {`채널톡 문의`->React.string}
                </span>
              </button>
              <Next.Link href=kakaoLink>
                <a target="_blank" className=%twc("h-10 bg-[#F0F2F5] rounded-lg")>
                  <span
                    className=%twc(
                      "text-[#1F2024] flex items-center px-4 hover:bg-[#1F20240A] active:bg-[#1F202414] h-full rounded-lg duration-200 ease-in-out"
                    )>
                    {`카카오톡 문의`->React.string}
                  </span>
                </a>
              </Next.Link>
            </div>
          </div>
        </div>
      </footer>

    <FeatureFlagWrapper featureFlag=#HOME_UI_UX fallback=oldUI suspenseFallback=newUI>
      {newUI}
    </FeatureFlagWrapper>
  }
}

module MO = {
  type linkItem = {
    title: string,
    url: string,
  }

  @react.component
  let make = () => {
    let enterprise = `주식회사 그린랩스`
    let representatives = `대표자 : 안동현, 최성우, 신상훈`
    let address = `서울시 송파구 정의로 8길 9 AJ 비전타워 3~6층`
    let businessId = `사업자 등록번호 : 320-88-00732`
    let businessLisenceId = `통신판매업신고 : 2017-서울송파-1843호`
    let businessLisenceUrl = "https://www.ftc.go.kr/bizCommPop.do?wrkr_no=3208800732"
    let businessHour = `월~금 : 09:30~17:30 (Break time 12:00~13:00)`
    let tel = `tel : 1670-5245`
    let kakaoLink = "https://pf.kakao.com/_JftIs"

    let oldUI =
      <div className=%twc("w-full bg-[#FBFBFB]")>
        <footer
          className=%twc(
            "w-full max-w-3xl mx-auto bg-[#FBFBFB] pt-10 pb-[100px] px-5 text-gray-800"
          )>
          <section className=%twc("w-full")>
            <ol className=%twc("w-full flex flex-wrap gap-5 items-center")>
              {[
                {
                  title: `회사소개`,
                  url: "https://greenlabs.co.kr",
                },
                {
                  title: `이용약관`,
                  url: "https://sinsun-policy.oopy.io/396aeebb-c5b4-4f46-a6dd-7e3b5f94b33e",
                },
                {
                  title: `개인정보 처리방침`,
                  url: "https://sinsun-policy.oopy.io/79ea595a-335a-4fd1-bb40-f308af127fe7",
                },
                {
                  title: `저작권 보호 안내`,
                  url: "https://sinsun-policy.oopy.io/64882d1f-366d-4df8-9fc4-98f0b07c8a94",
                },
              ]
              ->Array.mapWithIndex((idx, {title, url}) => {
                <li key={`footer-link-${idx->Int.toString}`}>
                  <Next.Link href=url>
                    <a target="_blank" className=%twc("font-bold")> {title->React.string} </a>
                  </Next.Link>
                </li>
              })
              ->React.array}
            </ol>
          </section>
          <section className=%twc("mt-5")>
            <div className=%twc("flex flex-col text-sm")>
              <span> {enterprise->React.string} </span>
              <span> {representatives->React.string} </span>
              <span> {address->React.string} </span>
              <div>
                <span> {businessId->React.string} </span>
                <span className=%twc("ml-3")> {businessLisenceId->React.string} </span>
              </div>
              <Next.Link href=businessLisenceUrl>
                <a target="_blank" className=%twc("flex")>
                  <span className=%twc("underline")>
                    {`사업자 정보 확인`->React.string}
                  </span>
                  <img src="/assets/arrow-right.svg" className=%twc("w-3 h-3 mt-1") alt="" />
                </a>
              </Next.Link>
            </div>
          </section>
          <section className=%twc("mt-6")>
            <span className=%twc("text-sm font-bold")> {`고객센터`->React.string} </span>
            <div className=%twc("mt-2 flex flex-col text-sm")>
              <span> {`출고/배송 문의 및 입점 제안`->React.string} </span>
              <span> {`상품 CS 및 취소 문의`->React.string} </span>
              <span> {businessHour->React.string} </span>
              <span> {tel->React.string} </span>
            </div>
          </section>
          <section className=%twc("mt-5")>
            <div className=%twc("w-full h-12 flex gap-3")>
              <button
                onClick={_ => ChannelTalk.showMessenger()}
                className=%twc(
                  "px-4 flex flex-1 bg-green-50 border-green-500 border rounded-lg items-center justify-center"
                )>
                <img src="/icons/channeltalk.svg" className=%twc("w-[21px] h-[21px]") alt="" />
                <span className=%twc("text-green-500 font-bold ml-2 whitespace-nowrap")>
                  {`채널톡 문의`->React.string}
                </span>
              </button>
              <Next.Link href=kakaoLink>
                <a
                  target="_blank"
                  className=%twc(
                    "px-4 flex flex-1 bg-[#FADE33] rounded-lg items-center justify-center"
                  )>
                  <img src=kakaoIcon alt="" />
                  <span className=%twc("font-bold ml-2 whitespace-nowrap")>
                    {`카카오톡 문의`->React.string}
                  </span>
                </a>
              </Next.Link>
            </div>
          </section>
        </footer>
      </div>

    <FeatureFlagWrapper featureFlag=#HOME_UI_UX fallback=oldUI>
      <div className=%twc("w-full bg-[#FAFBFC] border-t-[1px] border-[#F0F2F5]")>
        <footer
          className=%twc(
            "w-full max-w-3xl mx-auto bg-[#FBFBFB] pt-11 pb-[60px] px-5 text-gray-800"
          )>
          <section className=%twc("flex justify-between items-center")>
            <span className=%twc("font-bold text-[15px] text-[#1f2024]")>
              {`고객센터 1670-5245`->React.string}
            </span>
          </section>
          <section className=%twc("flex mt-4")>
            <button
              onClick={_ => ChannelTalk.showMessenger()}
              className=%twc("h-10 bg-[#F0F2F5] rounded-lg mr-3")>
              <span
                className=%twc(
                  "text-[#1F2024] flex items-center px-4 hover:bg-[#1F20240A] active:bg-[#1F202414] h-full rounded-lg duration-200 ease-in-out"
                )>
                {`채널톡 문의`->React.string}
              </span>
            </button>
            <Next.Link href=kakaoLink>
              <a target="_blank" className=%twc("h-10 bg-[#F0F2F5] rounded-lg")>
                <span
                  className=%twc(
                    "text-[#1F2024] flex items-center px-4 hover:bg-[#1F20240A] active:bg-[#1F202414] h-full rounded-lg duration-200 ease-in-out"
                  )>
                  {`카카오톡 문의`->React.string}
                </span>
              </a>
            </Next.Link>
          </section>
          <section className=%twc("mt-4")>
            <div className=%twc("flex flex-col text-[13px] text-[#8B8D94]")>
              <span>
                {`출고/배송 문의 및 입점 제안, 상품 CS 및 취소 문의`->React.string}
              </span>
              <span> {businessHour->React.string} </span>
            </div>
          </section>
          <section className=%twc("mt-5")>
            <div className=%twc("flex flex-col text-[13px] text-[#8B8D94]")>
              <span>
                {`${enterprise} | ${representatives} | ${address} | ${businessId} | ${businessLisenceId}`->React.string}
              </span>
            </div>
          </section>
          <section className=%twc("w-full flex flex-col mt-[54px]")>
            <div className=%twc("flex")>
              <ol className=%twc("w-full flex flex-wrap gap-5 items-center")>
                {[
                  {
                    title: `회사소개`,
                    url: "https://greenlabs.co.kr",
                  },
                  {
                    title: `이용안내`,
                    url: "https://shinsunmarket.co.kr/532",
                  },
                  {
                    title: `이용약관`,
                    url: "https://sinsun-policy.oopy.io/396aeebb-c5b4-4f46-a6dd-7e3b5f94b33e",
                  },
                ]
                ->Array.mapWithIndex((idx, {title, url}) => {
                  <li key={`footer-link-${idx->Int.toString}`}>
                    <Next.Link href=url>
                      <a target="_blank"> {title->React.string} </a>
                    </Next.Link>
                  </li>
                })
                ->React.array}
              </ol>
            </div>
            <div className=%twc("flex mt-2")>
              <ol className=%twc("w-full flex flex-wrap gap-5 items-center")>
                {[
                  {
                    title: `개인정보 처리방침`,
                    url: "https://sinsun-policy.oopy.io/79ea595a-335a-4fd1-bb40-f308af127fe7",
                  },
                  {
                    title: `저작권 보호 안내`,
                    url: "https://sinsun-policy.oopy.io/64882d1f-366d-4df8-9fc4-98f0b07c8a94",
                  },
                ]
                ->Array.mapWithIndex((idx, {title, url}) => {
                  <li key={`footer-link-${idx->Int.toString}`}>
                    <Next.Link href=url>
                      <a target="_blank" className=%twc("font-bold")> {title->React.string} </a>
                    </Next.Link>
                  </li>
                })
                ->React.array}
              </ol>
            </div>
          </section>
        </footer>
      </div>
    </FeatureFlagWrapper>
  }
}
