module PC = {
  @react.component
  let make = () => {
    let oldUI =
      <section className=%twc("flex-col bg-surface")>
        <div className=%twc("mx-auto py-20 max-w-7xl w-3/4")>
          <h2 className=%twc("font-bold ml-5 text-[32px]")>
            <Next.Link href="/buyer/me">
              <a> {`마이페이지`->React.string} </a>
            </Next.Link>
          </h2>
          <div className=%twc("mt-8 flex")>
            <div className=%twc("py-10 flex flex-col bg-white min-w-[260px] w-[460px] h-[760px]")>
              <div className=%twc("px-7 mb-9")>
                <div>
                  <div className=%twc("pb-5 flex items-center justify-between")>
                    <div className=%twc("flex")>
                      <div
                        className=%twc(
                          "bg-gray-50 rounded-full flex items-center justify-center w-[72px] h-[72px]"
                        )
                      />
                      <div className=%twc("ml-3")>
                        <Skeleton.Box className=%twc("w-full") />
                      </div>
                    </div>
                  </div>
                </div>
              </div>
              <div className=%twc("border-b border-gray-100 mb-[3px]") />
              <div className=%twc("flex flex-col")>
                <Next.Link href="/buyer/me/profile">
                  <a className=%twc("py-[18px] text-left px-7")>
                    <div className=%twc("w-fit")> {`프로필정보`->React.string} </div>
                  </a>
                </Next.Link>
                <Next.Link href="/buyer/me/account">
                  <a className=%twc("py-[18px] text-left px-7")>
                    <div className=%twc("w-fit")> {`계정정보`->React.string} </div>
                  </a>
                </Next.Link>
                <Next.Link href="/buyer/upload">
                  <a className=%twc("py-[18px] text-left px-7")>
                    {`주문서 업로드`->React.string}
                  </a>
                </Next.Link>
                <Next.Link href="/products/advanced-search">
                  <a className=%twc("py-[18px] text-left px-7")>
                    {`단품 확인`->React.string}
                  </a>
                </Next.Link>
                <Next.Link href="/buyer/me/like">
                  <a className=%twc("py-[18px] text-left px-7")>
                    {`찜한 상품`->React.string}
                  </a>
                </Next.Link>
                <Next.Link href="/buyer/me/recent-view">
                  <a className=%twc("py-[18px] text-left px-7")>
                    {`최근 본 상품`->React.string}
                  </a>
                </Next.Link>
                <Next.Link href="/buyer/download-center">
                  <a className=%twc("py-[18px] text-left px-7")>
                    {`다운로드 센터`->React.string}
                  </a>
                </Next.Link>
                <Next.Link
                  href="https://drive.google.com/drive/u/0/folders/1DbaGUxpkYnJMrl4RPKRzpCqTfTUH7bYN">
                  <a className=%twc("py-[18px] text-left px-7") target="_blank" rel="noopener">
                    {`판매자료 다운로드`->React.string}
                  </a>
                </Next.Link>
                <Next.Link href="https://shinsunmarket.co.kr/532">
                  <a className=%twc("py-[18px] text-left px-7")> {`공지사항`->React.string} </a>
                </Next.Link>
              </div>
            </div>
            <div className=%twc("w-full h-[640px] bg-white ml-4") />
          </div>
        </div>
      </section>

    <FeatureFlagWrapper featureFlag=#HOME_UI_UX fallback=oldUI>
      <section className=%twc("flex-col bg-[#F0F2F5]")>
        <div className=%twc("w-full max-w-[1920px] mx-auto bg-[#FAFBFC]")>
          <div className=%twc("flex ")>
            <PC_MyInfo_Sidebar />
            <div className=%twc("flex flex-col flex-1 max-w-[1280px]")>
              <div className=%twc("mt-10 ml-[80px] flex flex-col w-full mb-5")>
                <div
                  className=%twc(
                    "w-full rounded-sm bg-white shadow-[0px_10px_40px_10px_rgba(0,0,0,0.03)] mb-4 px-[50px] pt-10 pb-5 h-[205px]"
                  )
                />
              </div>
              <div className=%twc("mt-10 ml-[80px] flex flex-col w-full mb-4")>
                <div
                  className=%twc(
                    "w-full rounded-sm bg-white shadow-[0px_10px_40px_10px_rgba(0,0,0,0.03)] mb-4 px-[50px] pt-10 pb-5 h-[90px]"
                  )
                />
              </div>
              <div className=%twc("mt-10 ml-[80px] flex flex-col w-full mb-4")>
                <div
                  className=%twc(
                    "w-full rounded-sm bg-white shadow-[0px_10px_40px_10px_rgba(0,0,0,0.03)] mb-4 px-[50px] pt-10 pb-5 h-[164px]"
                  )
                />
              </div>
              <div className=%twc("mt-10 ml-[80px] flex flex-col w-full mb-4")>
                <div
                  className=%twc(
                    "w-full rounded-sm bg-white shadow-[0px_10px_40px_10px_rgba(0,0,0,0.03)] mb-4 px-[50px] pt-10 pb-5 h-[306px]"
                  )
                />
              </div>
            </div>
          </div>
        </div>
      </section>
    </FeatureFlagWrapper>
  }
}

module Mobile = {
  module Main = {
    @react.component
    let make = () => {
      <div className=%twc("w-full bg-white absolute top-0 pt-14 min-h-screen")>
        <div className=%twc("w-full max-w-3xl mx-auto bg-white h-full")>
          <div>
            <div className=%twc("flex flex-col")>
              <section>
                <div className=%twc("px-5 pt-5 pb-6")>
                  <div className=%twc("mb-10")>
                    <Next.Link href="/buyer/me/profile">
                      <a>
                        <div className=%twc("flex items-center justify-between")>
                          <div className=%twc("flex")>
                            <div
                              className=%twc(
                                "bg-gray-50 rounded-full flex items-center justify-center w-[54px] h-[54px]"
                              )
                            />
                            <div className=%twc("ml-3")>
                              <Skeleton.Box className=%twc("w-[120px]") />
                            </div>
                          </div>
                        </div>
                      </a>
                    </Next.Link>
                  </div>
                  <div className=%twc("mb-12")>
                    <div
                      className=%twc(
                        "p-4 flex items-center justify-between bg-surface rounded w-full"
                      )>
                      <div className=%twc("text-gray-600")>
                        {`신선캐시 잔액`->React.string}
                      </div>
                    </div>
                  </div>
                  <div className=%twc("mb-12")>
                    <div className=%twc("")>
                      <div className=%twc("mb-4 flex items-center justify-between")>
                        <div>
                          <span className=%twc("font-bold text-lg")>
                            {`진행중인 주문`->React.string}
                          </span>
                          <span className=%twc("ml-1 text-sm text-text-L3")>
                            {`(최근 1개월)`->React.string}
                          </span>
                        </div>
                        <Next.Link href="/buyer/orders">
                          <a>
                            <span className=%twc("text-sm mr-1")>
                              {`더보기`->React.string}
                            </span>
                            <IconArrow
                              height="10" width="10" fill="#262626" className=%twc("inline")
                            />
                          </a>
                        </Next.Link>
                      </div>
                      <div className=%twc("mb-4 flex divide-x")>
                        <div className=%twc("px-5 first:pl-4 last:pr-4 text-center min-w-fit grow")>
                          <div className=%twc("text-gray-600 text-sm")>
                            {`신규주문`->React.string}
                          </div>
                        </div>
                        <div className=%twc("px-5 first:pl-4 last:pr-4 text-center min-w-fit grow")>
                          <div className=%twc("text-gray-600 text-sm")>
                            {`상품준비중`->React.string}
                          </div>
                        </div>
                        <div className=%twc("px-5 first:pl-4 last:pr-4 text-center min-w-fit grow")>
                          <div className=%twc("text-gray-600 text-sm")>
                            {`배송중`->React.string}
                          </div>
                        </div>
                        <div className=%twc("px-5 first:pl-4 last:pr-4 text-center min-w-fit grow")>
                          <div className=%twc("text-gray-600 text-sm")>
                            {`배송완료`->React.string}
                          </div>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
                <div className=%twc("h-3 bg-gray-100") />
              </section>
              <section className=%twc("px-4 mb-[60px]")>
                <ol>
                  <Next.Link href="/buyer/me/account">
                    <li
                      className=%twc(
                        "py-5 flex justify-between items-center border-b border-gray-100"
                      )>
                      <span className=%twc("font-bold")> {`계정정보`->React.string} </span>
                      <IconArrow height="16" width="16" fill="#B2B2B2" />
                    </li>
                  </Next.Link>
                  <Next.Link href="/buyer/upload">
                    <li
                      className=%twc(
                        "py-5 flex justify-between items-center border-b border-gray-100"
                      )>
                      <span className=%twc("font-bold")>
                        {`주문서 업로드`->React.string}
                      </span>
                      <IconArrow height="16" width="16" fill="#B2B2B2" />
                    </li>
                  </Next.Link>
                  <Next.Link href="/products/advanced-search">
                    <li
                      className=%twc(
                        "py-5 flex justify-between items-center border-b border-gray-100"
                      )>
                      <span className=%twc("font-bold")> {`단품 확인`->React.string} </span>
                      <IconArrow height="16" width="16" fill="#B2B2B2" />
                    </li>
                  </Next.Link>
                  <Next.Link href="/buyer/download-center">
                    <li
                      className=%twc(
                        "py-5 flex justify-between items-center border-b border-gray-100"
                      )>
                      <span className=%twc("font-bold")>
                        {`다운로드 센터`->React.string}
                      </span>
                      <IconArrow height="16" width="16" fill="#B2B2B2" />
                    </li>
                  </Next.Link>
                  <Next.Link
                    href="https://drive.google.com/drive/u/0/folders/1DbaGUxpkYnJMrl4RPKRzpCqTfTUH7bYN">
                    <a target="_blank" rel="noopener">
                      <li
                        className=%twc(
                          "py-5 flex justify-between items-center border-b border-gray-100"
                        )>
                        <span className=%twc("font-bold")>
                          {`판매자료 다운로드`->React.string}
                        </span>
                        <IconArrow height="16" width="16" fill="#B2B2B2" />
                      </li>
                    </a>
                  </Next.Link>
                  <Next.Link href="https://shinsunmarket.co.kr/532">
                    <a target="_blank">
                      <li
                        className=%twc(
                          "py-5 flex justify-between items-center border-b border-gray-100"
                        )>
                        <span className=%twc("font-bold")> {`공지사항`->React.string} </span>
                        <IconArrow height="16" width="16" fill="#B2B2B2" />
                      </li>
                    </a>
                  </Next.Link>
                </ol>
              </section>
            </div>
          </div>
        </div>
      </div>
    }
  }

  module Account = {
    @react.component
    let make = () => {
      <div className=%twc("block w-full bg-white absolute top-0 pt-14 min-h-screen")>
        <div className=%twc("w-full max-w-3xl mx-auto bg-white h-full")>
          <section>
            <ol className=%twc("bg-white px-4")>
              <li className=%twc("py-5 flex items-center w-full justify-between")>
                <div className=%twc("flex")>
                  <div className=%twc("min-w-[105px] mr-2")>
                    <span className=%twc("font-bold")> {`이메일`->React.string} </span>
                  </div>
                  <Skeleton.Box className=%twc("w-32") />
                </div>
              </li>
              <button className=%twc("w-full flex")>
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
              <button className=%twc("w-full flex")>
                <li className=%twc("py-5 px-4 flex items-center w-full justify-between")>
                  <div className=%twc("flex")>
                    <div className=%twc("min-w-[105px] mr-2 text-left")>
                      <span className=%twc("font-bold")> {`회사명`->React.string} </span>
                    </div>
                    <Skeleton.Box className=%twc("w-32") />
                  </div>
                  <div className=%twc("")>
                    <IconArrow height="16" width="16" fill="#B2B2B2" />
                  </div>
                </li>
              </button>
              <button className=%twc("w-full flex")>
                <li
                  className=%twc(
                    "py-5 px-4 flex items-center w-full border-t border-gray-100 justify-between"
                  )>
                  <div className=%twc("flex")>
                    <div className=%twc("min-w-[105px] mr-2 text-left")>
                      <span className=%twc("font-bold")> {`담당자명`->React.string} </span>
                    </div>
                    <Skeleton.Box className=%twc("w-32") />
                  </div>
                  <div className=%twc("")>
                    <IconArrow height="16" width="16" fill="#B2B2B2" />
                  </div>
                </li>
              </button>
              <button className=%twc("w-full flex")>
                <li
                  className=%twc(
                    "py-5 px-4 flex items-center w-full border-t border-gray-100 justify-between"
                  )>
                  <div className=%twc("flex")>
                    <div className=%twc("min-w-[105px] mr-2 text-left")>
                      <span className=%twc("font-bold")>
                        {`휴대전화번호`->React.string}
                      </span>
                    </div>
                    <Skeleton.Box className=%twc("w-32") />
                  </div>
                  <div className=%twc("")>
                    <IconArrow height="16" width="16" fill="#B2B2B2" />
                  </div>
                </li>
              </button>
              <button className=%twc("w-full flex")>
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
                    <Skeleton.Box className=%twc("w-32") />
                  </div>
                  <div className=%twc("")>
                    <IconArrow height="16" width="16" fill="#B2B2B2" />
                  </div>
                </li>
              </button>
              <button className=%twc("w-full flex")>
                <li
                  className=%twc(
                    "py-5 px-4 flex items-center w-full border-t border-gray-100 justify-between"
                  )>
                  <div className=%twc("flex")>
                    <div className=%twc("min-w-[105px] mr-2 text-left")>
                      <span className=%twc("font-bold")> {`소재지`->React.string} </span>
                    </div>
                    <Skeleton.Box className=%twc("w-32") />
                  </div>
                  <div className=%twc("")>
                    <IconArrow height="16" width="16" fill="#B2B2B2" />
                  </div>
                </li>
              </button>
            </ol>
            <div className=%twc("h-3 bg-gray-100") />
            <ol className=%twc("bg-white px-4 mb-6")>
              <button className=%twc("w-full flex")>
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
              <button className=%twc("w-full flex")>
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
              <button className=%twc("w-full flex")>
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
        </div>
      </div>
    }
  }
}
