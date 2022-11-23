/*
  1. 컴포넌트 위치
  바이어 센터 전시 매장 > PDP Page > 모달
  
  2. 역할
  {인증}/{단품 선택 여부}/{기능 제공 현황} 등을 고려한 메세지를 모달로 보여줍니다.
*/

type contentType =
  | Unauthorized(string) // 미인증 (message: string)
  | NoOption // 단품을 선택하지 않음
  | Confirm // 컨펌
  | ContentGuide // 법적 필수 표기정보 안내

type visible =
  | Show(contentType)
  | Hide

module ContentsGuide = {
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

  module ContentsGuideHeader = {
    @react.component
    let make = (~closeFn) => {
      <section className=%twc("w-full h-14 flex items-center px-4")>
        <div className=%twc("w-10 h-10") />
        <div className=%twc("flex flex-1 items-center justify-center")>
          <h1 className=%twc("font-bold text-gray-800 text-xl")>
            {`필수 표기정보`->React.string}
          </h1>
        </div>
        <button onClick=closeFn className=%twc("w-10 h-10 flex items-center justify-center ")>
          <IconClose width="24" height="24" fill="#262626" />
        </button>
      </section>
    }
  }

  @react.component
  let make = (~show, ~closeFn, ~query) => {
    let _open = switch show {
    | Show(ContentGuide) => true
    | _ => false
    }

    open RadixUI.Dialog
    <Root _open>
      <Portal>
        <Overlay className=%twc("dialog-overlay") />
        <Content className=%twc("dialog-content-base w-full max-w-[768px] min-h-screen")>
          <Scroll>
            <ContentsGuideHeader closeFn />
            <div className=%twc("w-full px-5 py-2")>
              <PDP_Normal_ContentsGuide_Buyer.MO query />
            </div>
          </Scroll>
        </Content>
      </Portal>
    </Root>
  }
}

module Unauthorized = {
  module PC = {
    @react.component
    let make = (~show, ~closeFn) => {
      let {useRouter, push} = module(Next.Router)
      let router = useRouter()

      let (isShow, message) = switch show {
      | Show(Unauthorized(message)) => (ShopDialog_Buyer.Show, message)
      | _ => (ShopDialog_Buyer.Hide, "")
      }

      <ShopDialog_Buyer
        isShow
        cancelText={`취소`}
        onCancel={_ => {
          closeFn()
        }}
        confirmText={`로그인`}
        onConfirm={_ => {
          let {makeWithDict, toString} = module(Webapi.Url.URLSearchParams)
          let redirectUrl = switch router.query->Js.Dict.get("redirect") {
          | Some(redirect) => [("redirect", redirect)]->Js.Dict.fromArray->makeWithDict->toString
          | None => [("redirect", router.asPath)]->Js.Dict.fromArray->makeWithDict->toString
          }
          router->push(`/buyer/signin?${redirectUrl}`)
        }}>
        <div
          className=%twc(
            "h-18 mt-8 px-8 py-6 flex flex-col items-center justify-center text-lg text-text-L1"
          )>
          <span className=%twc("text-center")> {message->ReactNl2br.nl2br} </span>
        </div>
      </ShopDialog_Buyer>
    }
  }

  module MO = {
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
        onCancel={_ => {
          closeFn()
        }}
        confirmText={`로그인`}
        onConfirm={_ => {
          let {makeWithDict, toString} = module(Webapi.Url.URLSearchParams)
          let redirectUrl = switch router.query->Js.Dict.get("redirect") {
          | Some(redirect) => [("redirect", redirect)]->Js.Dict.fromArray->makeWithDict->toString
          | None => [("redirect", router.asPath)]->Js.Dict.fromArray->makeWithDict->toString
          }
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
}

module Confirm = {
  module MO = {
    @react.component
    let make = (~show, ~closeFn, ~query, ~selectedOptions, ~setSelectedOptions) => {
      let isShow = switch show {
      | Show(Confirm) => true
      | _ => false
      }

      React.useEffect1(() => {
        switch selectedOptions->Map.String.toArray {
        | [] => closeFn() // 선택한 단품이 하나도 없으면 모달/바텀시트 close
        | _ => ()
        }
        None
      }, [selectedOptions])

      <DS_BottomDrawer.Root isShow onClose=closeFn>
        <DS_BottomDrawer.Header />
        <DS_BottomDrawer.Body>
          <div className=%twc("pb-9")>
            <React.Suspense fallback={<PDP_Normal_OrderSpecification_Buyer.Placeholder />}>
              <PDP_Normal_OrderSpecification_Buyer
                query selectedOptions setSelectedOptions closeFn
              />
            </React.Suspense>
          </div>
        </DS_BottomDrawer.Body>
      </DS_BottomDrawer.Root>
    }
  }

  module PC = {
    @react.component
    let make = (~show, ~closeFn, ~query, ~selectedOptions, ~setSelectedOptions) => {
      let _open = switch show {
      | Show(Confirm) => true
      | _ => false
      }

      React.useEffect1(() => {
        switch selectedOptions->Map.String.toArray {
        | [] => closeFn() // 선택한 단품이 하나도 없으면 모달/바텀시트 close
        | _ => ()
        }
        None
      }, [selectedOptions])

      <RadixUI.Dialog.Root _open>
        <RadixUI.Dialog.Portal>
          <RadixUI.Dialog.Overlay className=%twc("dialog-overlay") />
          <RadixUI.Dialog.Content
            className=%twc(
              "dialog-content-base bg-white rounded-xl w-[calc(100vw-40px)] max-w-[calc(768px-40px)]"
            )
            onPointerDownOutside={_ => closeFn()}
            onOpenAutoFocus={ReactEvent.Synthetic.preventDefault}>
            <div>
              <section className=%twc("w-full h-14 flex justify-end items-center px-4")>
                <button onClick={_ => closeFn()}>
                  <DS_Icon.Common.CloseLarge2 height="24" width="24" />
                </button>
              </section>
              <section className=%twc("mt-4")>
                <React.Suspense fallback={<PDP_Normal_OrderSpecification_Buyer.Placeholder />}>
                  <PDP_Normal_OrderSpecification_Buyer
                    query selectedOptions setSelectedOptions closeFn
                  />
                </React.Suspense>
              </section>
            </div>
          </RadixUI.Dialog.Content>
        </RadixUI.Dialog.Portal>
      </RadixUI.Dialog.Root>
    }
  }
}

module NoOption = {
  module PC = {
    @react.component
    let make = (~show, ~closeFn) => {
      let isShow = switch show {
      | Show(NoOption) => ShopDialog_Buyer.Show
      | _ => ShopDialog_Buyer.Hide
      }

      <ShopDialog_Buyer
        isShow
        cancelText={`확인`}
        onCancel={_ => {
          closeFn()
        }}>
        <div
          className=%twc(
            "h-18 mt-8 px-8 py-6 flex flex-col items-center justify-center text-lg text-text-L1"
          )>
          <span> {`단품을 선택해 주세요.`->React.string} </span>
        </div>
      </ShopDialog_Buyer>
    }
  }

  module MO = {
    @react.component
    let make = (~show, ~closeFn) => {
      let isShow = switch show {
      | Show(NoOption) => ShopDialog_Buyer.Show
      | _ => ShopDialog_Buyer.Hide
      }

      <ShopDialog_Buyer.Mo
        isShow
        cancelText={`확인`}
        onCancel={_ => {
          closeFn()
        }}>
        <div
          className=%twc(
            "h-18 mt-8 px-8 py-6 flex flex-col items-center justify-center text-lg text-text-L1"
          )>
          <span> {`단품을 선택해 주세요.`->React.string} </span>
        </div>
      </ShopDialog_Buyer.Mo>
    }
  }
}

module PC = {
  @react.component
  let make = (~show, ~setShow, ~selectedOptions, ~setSelectedOptions, ~query) => {
    let closeFn = _ => setShow(._ => Hide)

    <>
      <Confirm.PC show closeFn query selectedOptions setSelectedOptions />
      <Unauthorized.PC show closeFn />
      <NoOption.PC show closeFn />
    </>
  }
}

module MO = {
  @react.component
  let make = (~show, ~setShow, ~selectedOptions, ~setSelectedOptions, ~query) => {
    let closeFn = _ => setShow(._ => Hide)
    <>
      <Confirm.MO show closeFn query selectedOptions setSelectedOptions />
      <Unauthorized.MO show closeFn />
      <NoOption.MO show closeFn />
      <ContentsGuide show closeFn query />
    </>
  }
}
