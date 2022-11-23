type imgObj = {
  src: string,
  height: int,
  width: int,
  blurDataURL: string,
}
@module("../../../assets/rfq/rfq-index-bg.png")
external rfqBgImg: imgObj = "default"
@module("../../../assets/rfq/rfq-card-1.png")
external rfqCard1: imgObj = "default"
@module("../../../assets/rfq/rfq-card-2.png")
external rfqCard2: imgObj = "default"
@module("../../../assets/rfq/rfq-card-3.png")
external rfqCard3: imgObj = "default"
@module("../../../assets/rfq/rfq-box-img.png")
external rfqBox: imgObj = "default"
@module("../../../assets/rfq/rfq-card-img1.png")
external rfqCardImg1: imgObj = "default"
@module("../../../assets/rfq/rfq-card-img2.png")
external rfqCardImg2: imgObj = "default"
@module("../../../assets/rfq/rfq-card-m1.png")
external rfqCardM1: imgObj = "default"
@module("../../../assets/rfq/rfq-card-m2.png")
external rfqCardM2: imgObj = "default"
@module("../../../assets/rfq/rfq-card-m3.png")
external rfqCardM3: imgObj = "default"
@module("../../../assets/rfq/rfq-card-img-m1.png")
external rfqCardImgM1: imgObj = "default"
@module("../../../assets/rfq/rfq-card-img-m2.png")
external rfqCardImgM2: imgObj = "default"
@module("../../../assets/rfq/rfq-index-bg-m.png")
external rfqBgImgM: imgObj = "default"

module PC = {
  @react.component
  let make = () => {
    let buttonStyle = %twc(
      "mt-[30px] text-xl text-white tracking-tighter leading-6 px-8 py-5 bg-primary rounded-lg"
    )

    <>
      <Header_Buyer.PC />
      <div className=%twc("min-w-[1280px]")>
        <section className=%twc("relative w-full")>
          <img src={rfqBgImg.src} className=%twc("absolute object-cover h-full w-full -z-10") />
          <div className=%twc("py-[110px]")>
            <h2
              className=%twc(
                "text-center whitespace-pre-line text-white font-bold text-[44px] leading-[61.44px]"
              )>
              {`원하는 육류 가격만 알려주세요\n`->React.string}
              <span className=%twc("text-[#05FF00]")> {`원가 절감 100%`->React.string} </span>
              {` 보장합니다`->React.string}
            </h2>
            <div className=%twc("flex justify-center")>
              <RfqCreateRequestButton className=buttonStyle position={#top} />
            </div>
            <div className=%twc("flex justify-center gap-5 mt-[70px]")>
              <img src={rfqCard1.src} className=%twc("w-[333px]") />
              <img src={rfqCard2.src} className=%twc("w-[333px]") />
              <img src={rfqCard3.src} className=%twc("w-[333px]") />
            </div>
          </div>
        </section>
        <section className=%twc("relative w-full")>
          <div className=%twc("flex flex-col items-center py-[135px]")>
            <div className=%twc("w-full max-w-screen-lg bg-[#F6F9F6] rounded-[40px] py-20")>
              <div className=%twc("px-[72px]")>
                <div className=%twc("text-5xl font-bold")>
                  {`업계 `->React.string}
                  <span className=%twc("text-primary")> {`최저가로`->React.string} </span>
                  {` 공급`->React.string}
                </div>
                <div
                  className=%twc(
                    "mt-5 text-2xl leading-9 tracking-tighter whitespace-pre-line text-gray-700"
                  )>
                  {`30곳 이상의 대형 공급업체의 견적을 비교하여\n기존 공급업체보다 더 저렴한 가격을 보장해드립니다.`->React.string}
                </div>
              </div>
              <div className=%twc("flex mt-12 justify-end")>
                <img src={rfqCardImg1.src} className=%twc("max-w-[890px]") />
              </div>
            </div>
            <div
              className=%twc(
                "max-w-screen-lg w-full relative bg-[#F6F9F6] py-20 px-[72px] rounded-[40px] mt-5 mx-0"
              )>
              <div className=%twc("block justify-center items-center flex-col")>
                <div className=%twc("text-5xl font-bold")>
                  {`재거래 시에도 `->React.string}
                </div>
                <div className=%twc("text-5xl font-bold text-primary")>
                  {`매번 최저가로`->React.string}
                </div>
                <div
                  className=%twc(
                    "mt-5 whitespace-pre-line text-2xl leading-9 tracking-tighter text-gray-700"
                  )>
                  {`매 발주마다 최저가 견적만 자동 발송되어\n꾸준한 원가 절감효과를 누릴 수 있습니다.`->React.string}
                </div>
                <div className=%twc("block absolute right-0 top-0")>
                  <img src={rfqCardImg2.src} className=%twc("max-w-[475px]") />
                </div>
              </div>
            </div>
          </div>
        </section>
        <section className=%twc("flex justify-center py-[130px]")>
          <div className=%twc("flex justify-start gap-5 px-0")>
            <img src={rfqBox.src} className=%twc("w-[510px]") />
            <div className=%twc("flex justify-center flex-col pl-[70px] text-left")>
              <div className=%twc("text-5xl font-bold")>
                <span> {`한 박스도 `->React.string} </span>
                <span className=%twc("text-primary")> {`무료배송`->React.string} </span>
              </div>
              <div
                className=%twc(
                  "text-2xl leading-9 tracking-tighter text-gray-700 mt-5 whitespace-pre-line"
                )>
                {`한 박스 이상 주문 시 매장 앞으로\n배송비 0원에 배송해드립니다.`->React.string}
              </div>
            </div>
          </div>
        </section>
        // 첫거래시 추가할인 배너
        <section className=%twc("relative w-full bg-[#3F4C65] py-[110px]")>
          <div
            className=%twc(
              "flex justify-center items-center flex-col text-white font-bold leading-[62px] text-[44px]"
            )>
            <h2 className=%twc("whitespace-pre-line")>
              {`첫 거래 시 `->React.string}
              <span className=%twc("text-primary")> {`10만원 추가할인!`->React.string} </span>
              {`\n 1분만에 견적을 요청해보세요`->React.string}
            </h2>
            <h3
              className=%twc("text-2xl font-normal text-center leading-9 mt-5 whitespace-pre-line")>
              {`영업일 기준 견적요청 후 2시간 내로 견적서가 도착!\n`->React.string}
              <span className=%twc("text-gray-400")>
                {"(단, 16시 이후 견적요청 건은 다음 날 오전에 견적서를 발송해드려요)"->React.string}
              </span>
            </h3>
          </div>
          <div className=%twc("flex justify-center mt-2.5")>
            <RfqCreateRequestButton className=buttonStyle position={#bottom} />
          </div>
        </section>
      </div>
      <Footer_Buyer.PC />
    </>
  }
}

module MO = {
  @react.component
  let make = () => {
    let buttonStyle = %twc(
      "mt-[30px] text-xl text-white tracking-tighter leading-6 px-8 py-5 bg-primary rounded-lg"
    )

    <>
      <Header_Buyer.Mobile />
      <div className=%twc("min-w-[360px]")>
        <section className=%twc("relative")>
          <img src={rfqBgImgM.src} className=%twc("absolute object-cover h-full w-full -z-10") />
          <div className=%twc("py-20")>
            <h2
              className=%twc(
                "text-center text-[26px] leading-8 text-white font-bold whitespace-pre-line"
              )>
              {`원하는 육류 가격만 알려주세요\n`->React.string}
              <span className=%twc("text-[#05FF00]")> {`원가 절감 100%`->React.string} </span>
              {` 보장합니다`->React.string}
            </h2>
            <div className=%twc("flex justify-center")>
              <RfqCreateRequestButton className=buttonStyle position={#top} />
            </div>
            <div className=%twc("flex flex-col items-center mt-10 gap-4")>
              <img src={rfqCardM1.src} className=%twc("w-[280px]") />
              <img src={rfqCardM2.src} className=%twc("w-[280px]") />
              <img src={rfqCardM3.src} className=%twc("w-[280px]") />
            </div>
          </div>
        </section>
        <section className=%twc("relative")>
          <div className=%twc("container max-w-screen-lg mx-auto py-[60px]")>
            <div className=%twc("bg-[#F6F9F6]  rounded-[40px] py-10 mx-5")>
              <div className=%twc("flex justify-center items-center flex-col")>
                <div className=%twc("text-[26px] font-bold")>
                  <span> {`업계 `->React.string} </span>
                  <span className=%twc("text-primary")> {`최저가로 `->React.string} </span>
                  <span> {`공급`->React.string} </span>
                </div>
                <div
                  className=%twc(
                    "text-[17px] leading-6 tracking-tighter text-gray-700 mt-4 text-center whitespace-pre-line"
                  )>
                  {`30곳 이상의 대형 공급업체의\n견적을 비교하여 기존 공급업체보다\n더 저렴한 가격을 보장해드립니다.`->React.string}
                </div>
              </div>
              <div className=%twc(" mt-8 flex justify-center")>
                <img src={rfqCardImgM1.src} className=%twc("w-[280px]") />
              </div>
            </div>
            <div className=%twc("relative bg-[#F6F9F6] py-10 rounded-[40px] mt-5 mx-5")>
              <div className=%twc("flex justify-center items-center flex-col")>
                <div className=%twc("text-[26px] font-bold whitespace-pre-line")>
                  <span> {`재거래 시에도`->React.string} </span>
                  <span className=%twc("text-primary")>
                    {"\n매번 최저가로"->React.string}
                  </span>
                </div>
                <div
                  className=%twc(
                    "text-[17px] leading-6 tracking-tighter text-gray-700 mt-4 whitespace-pre-line"
                  )>
                  {`매 발주마다 최저가 견적만 자동 발송되어\n꾸준한 원가 절감효과를 누릴 수 있습니다.`->React.string}
                </div>
                <div className=%twc("flex justify-center items-center mt-10")>
                  <img src={rfqCardImgM2.src} className=%twc("w-[320px]") />
                </div>
              </div>
            </div>
          </div>
        </section>
        <section className=%twc("relative")>
          <div className=%twc("py-[60px]")>
            <div className=%twc("flex flex-col gap-[30px] px-5")>
              <div className=%twc("flex justify-center")>
                <img src={rfqBox.src} className=%twc("w-[410px]") />
              </div>
              <div className=%twc("flex justify-center flex-col text-center")>
                <div className=%twc("text-[26px] font-bold")>
                  <span> {`한 박스도 `->React.string} </span>
                  <span className=%twc("text-primary")> {`무료배송`->React.string} </span>
                </div>
                <div
                  className=%twc(
                    "text-[17px] leading-6 tracking-tighter text-gray-700 mt-4 whitespace-pre-line"
                  )>
                  {`한 박스 이상 주문 시 매장 앞으로\n배송비 0원에 배송해드립니다.`->React.string}
                </div>
              </div>
            </div>
          </div>
        </section>
        <section className=%twc("py-[110px] bg-[#3F4C65] ")>
          <div
            className=%twc(
              "flex justify-center items-center flex-col text-white font-bold leading-9 text-[26px]"
            )>
            <h2> {`첫 거래 시 `->React.string} </h2>
            <h2>
              <span className=%twc("text-primary")> {`10만원 추가할인!`->React.string} </span>
            </h2>
            <h2> {`1분만에`->React.string} </h2>
            <h2> {`견적을 요청해보세요`->React.string} </h2>
            <span
              className=%twc(
                "text-[17px] font-normal leading-6 mt-5 whitespace-pre-wrap text-center"
              )>
              {`영업일 기준 견적요청 후\n2시간 내로 견적서가 도착!`->React.string}
            </span>
            <span
              className=%twc(
                "text-[17px] font-normal leading-6 mt-2 whitespace-pre-wrap text-center text-gray-400"
              )>
              {`(단, 16시 이후 견적요청 건은\n다음 날 오전에 견적서를 발송해드려요)`->React.string}
            </span>
          </div>
          <div className=%twc("flex justify-center mt-2.5")>
            <RfqCreateRequestButton className=buttonStyle position={#bottom} />
          </div>
        </section>
      </div>
      <Footer_Buyer.MO />
    </>
  }
}

type props = {deviceType: DeviceDetect.deviceType}
type params
type previewData

let default = (~props) => {
  let {deviceType} = props

  <>
    <Next.Head>
      <title> {`신선하이 | 견적요청`->React.string} </title>
    </Next.Head>
    {switch deviceType {
    | PC => <PC />
    | Mobile => <MO />
    | Unknown => <PC />
    }}
  </>
}

let getServerSideProps = (ctx: Next.GetServerSideProps.context<props, _, _>) => {
  open ServerSideHelper
  let environment = SinsunMarket(Env.graphqlApiUrl)->RelayEnv.environment
  let gnbAndCategoryQuery = environment->gnbAndCategory

  let deviceType = DeviceDetect.detectDeviceFromCtx2(ctx.req)

  gnbAndCategoryQuery->makeResultWithQuery(~environment, ~extraProps={"deviceType": deviceType})
}
