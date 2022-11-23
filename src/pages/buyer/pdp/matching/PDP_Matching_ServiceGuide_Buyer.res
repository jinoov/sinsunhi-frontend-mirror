module Card = {
  @react.component
  let make = (~className=?, ~children=?) => {
    <div
      className={%twc("w-full bg-[#ECF6EC] rounded-xl py-10 px-7 flex flex-col items-center ") ++
      className->Option.getWithDefault("")}>
      {children->Option.getWithDefault(React.null)}
    </div>
  }
}

module PriceCard = {
  @react.component
  let make = () => {
    <Card>
      <span className=%twc("text-[26px] font-bold text-text-L1")>
        {`국내`->React.string}
        <span className=%twc("text-primary-variant")> {` 최저가 `->React.string} </span>
        {`도전`->React.string}
      </span>
      <p className=%twc("mt-4 max-w-[335px] text-gray-700 text-[17px] text-center")>
        {`신선하이는 생산자와 직접 매칭이 가능하여 중간 유통을 최소화할 수 있습니다.`->React.string}
      </p>
      <div className=%twc("mt-10 py-2")>
        <Image
          src={`/images/matching-card-price.png`}
          loading=Image.Loading.Lazy
          className=%twc("w-[280px] h-[144px] object-contain")
          alt={`신선하이 매칭 가격`}
        />
      </div>
    </Card>
  }
}

module GradeCard = {
  @react.component
  let make = () => {
    <Card className=%twc("mt-4")>
      <span className=%twc("text-[26px] font-bold text-text-L1")>
        {`신선하이 자체`->React.string}
      </span>
      <span className=%twc("text-[26px] font-bold text-primary-variant")>
        {`가격 분류 체계`->React.string}
      </span>
      <p className=%twc("mt-4 max-w-[335px] text-gray-700 text-[17px] text-center")>
        {`신선하이는 고객들의 직곽적으로 파악할 수 있도록 3가지 형태로 가격 분류 체계를 설계하였습니다.`->React.string}
      </p>
      <div className=%twc("mt-10 py-2")>
        <Image
          src={`/images/matching-card-grade.png`}
          loading=Image.Loading.Lazy
          className=%twc("w-[262px] h-[126px] object-contain")
          alt={`신선하이 매칭 가격 분류`}
        />
      </div>
    </Card>
  }
}

module DeliveryCard = {
  @react.component
  let make = () => {
    <Card className=%twc("mt-4")>
      <span className=%twc("text-[26px] font-bold text-text-L1")>
        {`당일 매칭,`->React.string}
      </span>
      <span className=%twc("text-[26px] font-bold text-primary-variant")>
        {`매칭 후일 바로 발송`->React.string}
      </span>
      <p className=%twc("mt-4 max-w-[335px] text-gray-700 text-[17px] text-center")>
        {`신선하이는 생산들에게 직접 견적을 발송받아 바이어와 빠르게 매칭을 해드립니다.`->React.string}
      </p>
      <div className=%twc("mt-10 py-2")>
        <Image
          src={`/images/matching-card-delivery.png`}
          loading=Image.Loading.Lazy
          className=%twc("w-[180px] h-[144px] object-contain")
          alt={`신선하이 매칭 배송`}
        />
      </div>
    </Card>
  }
}

module Banner = {
  @react.component
  let make = () => {
    <div className=%twc("w-full relative")>
      <picture>
        <source media="(max-width: 450px)" srcSet="/images/matching-guide-bg-mo.png" />
        <source media="(min-width: 451px)" srcSet="/images/matching-guide-bg-pc.png" />
        <Image
          src="/images/matching-guide-bg-pc.png"
          className=%twc("w-full h-[336px] object-cover")
          alt={`신선하이 매칭`}
        />
      </picture>
      <div className=%twc("absolute top-1/2 -translate-y-1/2 left-1/2 -translate-x-1/2")>
        <div className=%twc("w-[315px] flex flex-col items-center")>
          <div className=%twc("py-[6px] px-4 bg-white text-primary font-bold text-sm rounded-full")>
            {`최저가 견적받기`->React.string}
          </div>
          <div className=%twc("mt-4 text-white text-[26px] flex flex-col items-center")>
            <span className=%twc("font-bold")> {`신선하이 매칭`->React.string} </span>
            <span> {`서비스를 알려드릴게요`->React.string} </span>
          </div>
          <div className=%twc("mt-4")>
            <p className=%twc("text-center text-white")>
              {"팜모닝 70만 농가의 판매신청 데이터를 바탕으로 원하는 스펙의 상품을 쉽고 빠르게 전국도매시장 시세와 비교하여 구매할 수 있는 서비스입니다."->React.string}
            </p>
          </div>
        </div>
      </div>
    </div>
  }
}

module Footer = {
  @react.component
  let make = () => {
    <section className=%twc("py-[60px] px-[30px] bg-blue-gray-700")>
      <div className=%twc("flex flex-col items-center text-xl font-bold text-center")>
        <span className=%twc("hidden md:block text-white")>
          {`신선하이 전문 MD는 신선도, 모양, 짓무름, 당도 등`->ReactNl2br.nl2br}
        </span>
        <span className=%twc("block md:hidden text-white")>
          {`신선하이 전문 MD는\n신선도, 모양, 짓무름, 당도 등`->ReactNl2br.nl2br}
        </span>
        <span className=%twc("text-primary")>
          {`상품을 꼼꼼하게 확인합니다. 안심하고 구매하셔도 좋습니다.`->React.string}
        </span>
      </div>
    </section>
  }
}

module Content = {
  @react.component
  let make = () => {
    <>
      <Banner />
      <section className=%twc("px-5 pt-10 pb-[66px]")>
        <PriceCard />
        <GradeCard />
        <DeliveryCard />
      </section>
      <Footer />
    </>
  }
}

module Trigger = {
  @react.component
  let make = (~onClick) => {
    <button
      onClick
      className=%twc("w-full p-5 rounded-xl bg-[#EFF7FC] flex items-center justify-between")>
      <div className=%twc("flex flex-col items-start")>
        <span className=%twc("text-black text-base font-bold")>
          {`신선매칭이란?`->React.string}
        </span>
        <span className=%twc("mt-2 text-gray-600 text-sm text-left")>
          {`필요한 품종에 대해 견적요청하시면,\n최저가 상품을 연결해드립니다.`->ReactNl2br.nl2br}
        </span>
      </div>
      <Image className=%twc("w-[69px] object-contain") src="/images/matching-button.png" alt={""} />
    </button>
  }
}
