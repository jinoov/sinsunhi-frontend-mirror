/** 
* App Header 는 해당 모듈에서 임포트 하는 방식으로 사용합니다.
* 특정 페이지만을 위한, 범용적이지 않은 Header를 추가한다면 이유를 PR에 적어주세요.
**/
module Header = {
  @react.component
  let make = (~left=<div />, ~center=<div />, ~right=<div />, ~className="") => {
    <div className={cx([%twc("w-full bg-white z-[5]"), className])}>
      <header className=%twc("w-full max-w-3xl mx-auto h-14 flex items-center px-4 bg-white")>
        <div
          className=%twc(
            "w-full flex items-center my-0 py-0 bg-white justify-between relative h-full"
          )>
          {left}
          {center}
          {right}
        </div>
      </header>
    </div>
  }
}

module Main = {
  @module("/public/assets/sinsunhi-logo-renewal.svg")
  external sinsunhiLogoRenewal: string = "default"

  @react.component
  let make = () => {
    <Header
      left={<Next.Link href="/">
        <img
          src=sinsunhiLogoRenewal
          className=%twc("w-[86px] object-contain h-14")
          alt="신선하이 로고"
        />
      </Next.Link>}
      right={<CartLinkIcon />}
    />
  }
}

/**
* 페이지가 쌓이는 인터페이스에 적합한 헤더입니다. 좌측 뒤로가기가 제공됩니다. 
**/
module Stack = {
  @module("/public/assets/arrow-left-line.svg")
  external arrowLeftLineIcon: string = "default"

  @react.component
  let make = (~title=" ", ~right=?, ~className=?) => {
    let router = Next.Router.useRouter()

    <Header
      className=?{className}
      left={<>
        <img
          src=arrowLeftLineIcon
          className=%twc("w-6 absolute top-0 left-0 h-14")
          alt="뒤로가기"
          onClick={_ => router->Next.Router.back}
        />
        <div />
      </>}
      center={<div className=%twc("font-bold text-[19px] whitespace-pre-wrap")>
        {title->React.string}
      </div>}
      right={<>
        <div className=%twc("absolute top-0 right-0 flex items-center h-14")>
          {right->Option.getWithDefault(React.null)}
        </div>
        <div />
      </>}
    />
  }
}
