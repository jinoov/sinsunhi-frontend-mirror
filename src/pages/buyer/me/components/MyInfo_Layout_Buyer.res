@react.component
let make = (~query, ~children) => {
  let router = Next.Router.useRouter()

  <section className=%twc("flex-col bg-surface")>
    <div className=%twc("mx-auto py-20 max-w-7xl w-3/4")>
      <h2 className=%twc("font-bold ml-5 text-[32px]")>
        <Next.Link href="/buyer/me">
          <a> {`마이페이지`->React.string} </a>
        </Next.Link>
      </h2>
      <div className=%twc("mt-8 flex")>
        <div className=%twc("py-10 flex flex-col bg-white min-w-[260px] w-[460px] min-h-[640px]")>
          <div className=%twc("px-7 mb-9")>
            <MyInfo_ProfileSummary_Buyer.PC query />
          </div>
          <div className=%twc("border-b border-gray-100 mb-[3px]") />
          <div className=%twc("flex flex-col")>
            <Next.Link href="/buyer/me/profile">
              <a className=%twc("py-[18px] text-left px-7")>
                <div className=%twc("w-fit")>
                  {switch router.asPath {
                  | str if str->Js.String2.includes("/buyer/me/profile") =>
                    <>
                      <span className=%twc("font-bold")> {`프로필 정보`->React.string} </span>
                      <div className=%twc("border-b-2 border-[#1F2024]") />
                    </>
                  | _ => <span> {`프로필정보`->React.string} </span>
                  }}
                </div>
              </a>
            </Next.Link>
            <Next.Link href="/buyer/me/account">
              <a className=%twc("py-[18px] text-left px-7")>
                <div className=%twc("w-fit")>
                  {switch router.asPath {
                  | str if str->Js.String2.includes("/buyer/me/account") =>
                    <>
                      <span className=%twc("font-bold")> {`계정정보`->React.string} </span>
                      <div className=%twc("border-b-2 border-[#1F2024]") />
                    </>
                  | _ => <span> {`계정정보`->React.string} </span>
                  }}
                </div>
              </a>
            </Next.Link>
            <Next.Link href="/buyer/upload">
              <a className=%twc("py-[18px] text-left px-7")>
                {`주문서 업로드`->React.string}
              </a>
            </Next.Link>
            <Next.Link href="/buyer/orders">
              <a className=%twc("py-[18px] text-left px-7")> {`주문 내역`->React.string} </a>
            </Next.Link>
            <Next.Link href="/buyer/transactions">
              <a className=%twc("py-[18px] text-left px-7")> {`결제 내역`->React.string} </a>
            </Next.Link>
            <Next.Link href="/products/advanced-search">
              <a className=%twc("py-[18px] text-left px-7")> {`단품 확인`->React.string} </a>
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
        {children}
      </div>
    </div>
  </section>
}
