/*
  1. 컴포넌트 위치
  PDP > 매칭 상품 > 모달
  
  2. 역할
  매칭상품의 여러 조건 등을 고려한 메세지를 모달로 보여줍니다.
*/

type contentType =
  | Unauthorized(string) // 미인증
  | GradeGuide // 등급 안내
  | ServiceGuide // 서비스 안내

type visible =
  | Show(contentType)
  | Hide

module Scroll = {
  @react.component
  let make = (~children) => {
    open RadixUI.ScrollArea
    <Root className=%twc("h-screen flex flex-col overflow-hidden")>
      <Viewport className=%twc("w-full h-full")> {children} </Viewport>
      <Scrollbar>
        <Thumb />
      </Scrollbar>
    </Root>
  }
}

module ModalHeader = {
  @react.component
  let make = (~title, ~closeFn) => {
    <section className=%twc("w-full h-14 flex items-center px-4")>
      <div className=%twc("w-10 h-10") />
      <div className=%twc("flex flex-1 items-center justify-center")>
        <h1 className=%twc("font-bold text-black")> {title->React.string} </h1>
      </div>
      <button onClick=closeFn className=%twc("w-10 h-10 flex items-center justify-center ")>
        <IconClose width="24" height="24" fill="#262626" />
      </button>
    </section>
  }
}

module ServiceGuide = {
  @react.component
  let make = (~show, ~closeFn) => {
    let _open = switch show {
    | Show(ServiceGuide) => true
    | _ => false
    }

    open RadixUI.Dialog
    <Root _open>
      <Portal>
        <Overlay className=%twc("dialog-overlay") />
        <Content
          onPointerDownOutside=closeFn
          className=%twc("dialog-content-base w-full max-w-[768px] min-h-screen")>
          <Scroll>
            <ModalHeader title={`신선하이 매칭 소개`} closeFn />
            <PDP_Matching_ServiceGuide_Buyer.Content />
          </Scroll>
        </Content>
      </Portal>
    </Root>
  }
}

module GradeGuide = {
  @react.component
  let make = (~show, ~closeFn, ~query) => {
    let _open = switch show {
    | Show(GradeGuide) => true
    | _ => false
    }

    open RadixUI.Dialog
    <Root _open>
      <Portal>
        <Overlay className=%twc("dialog-overlay") />
        <Content
          onPointerDownOutside=closeFn
          className=%twc("dialog-content-base w-full max-w-[768px] min-h-screen")>
          <Scroll>
            <ModalHeader title={`신선하이 등급`} closeFn />
            <PDP_Matching_GradeGuide_Buyer query />
          </Scroll>
        </Content>
      </Portal>
    </Root>
  }
}

module Unauthorized = {
  @react.component
  let make = (~show, ~closeFn) => {
    let {useRouter, push} = module(Next.Router)
    let router = useRouter()

    let (isShow, message) = switch show {
    | Show(Unauthorized(message)) => (ShopDialog_Buyer.Show, message)
    | _ => (ShopDialog_Buyer.Hide, "")
    }

    <ShopDialog_Buyer.Mo
      isShow
      cancelText={`취소`}
      onCancel={_ => closeFn()}
      confirmText={`로그인`}
      onConfirm={_ => {
        let {makeWithDict, toString} = module(Webapi.Url.URLSearchParams)
        let redirectUrl = [("redirect", router.asPath)]->Js.Dict.fromArray->makeWithDict->toString
        router->push(`/buyer/signin?${redirectUrl}`)
      }}>
      <div
        className=%twc(
          "h-18 mt-8 px-8 py-6 flex flex-col items-center justify-center text-lg text-text-L1"
        )>
        <span className=%twc("text-center")> {message->ReactNl2br.nl2br} </span>
      </div>
    </ShopDialog_Buyer.Mo>
  }
}

module MO = {
  @react.component
  let make = (~show, ~setShow, ~query) => {
    let closeFn = _ => setShow(._ => Hide)
    <>
      <Unauthorized show closeFn />
      <GradeGuide show closeFn query />
      <ServiceGuide show closeFn />
    </>
  }
}
