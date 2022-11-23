module SearchInput = {
  @module("/public/assets/search-bnb-disabled.svg")
  external searchIcon: string = "default"

  @module("/public/assets/close-input-gray.svg")
  external closeInput: string = "default"

  @react.component
  let make = (~query, ~onChange) => {
    let handleChange = e => {
      let value = (e->ReactEvent.Synthetic.target)["value"]

      onChange(value)
    }

    <div className=%twc("bg-[#F0F2F5] p-[14px] rounded-[10px]")>
      <div className=%twc("relative")>
        <img
          src={searchIcon}
          className=%twc("flex absolute inset-y-0 left-0 items-center pointer-events-none")
          alt=""
        />
        <input
          value={query}
          onChange={handleChange}
          type_="text"
          id="input-matching-product"
          placeholder="검색어를 입력하세요"
          className=%twc("w-full bg-[#F0F2F5] pl-7 pr-6 focus:outline-none")
        />
        {switch query == "" {
        | true => React.null
        | false =>
          <button
            type_="button" className=%twc("absolute right-0 top-0") onClick={_ => onChange("")}>
            <img src={closeInput} className=%twc("w-6 h-6") alt="검색어 초기화" />
          </button>
        }}
      </div>
    </div>
  }
}

@react.component
let make = (~isShow, ~onClose) => {
  let (checkedSet, setCheckedSet) = React.Uncurried.useState(_ => Set.String.empty)

  let handleOnChange = (id: string) => {
    switch checkedSet->Set.String.has(id) {
    | true => setCheckedSet(._ => checkedSet->Set.String.remove(id))
    | false => setCheckedSet(.prev => prev->Set.String.add(id))
    }
  }

  <RadixUI.Dialog.Root _open=isShow>
    <RadixUI.Dialog.Portal>
      <RadixUI.Dialog.Overlay className=%twc("dialog-overlay") />
      <RadixUI.Dialog.Content
        onOpenAutoFocus={ReactEvent.Synthetic.preventDefault}
        className=%twc(
          "w-[705px] max-w-[705px] dialog-content-base rounded-2xl overflow-hidden max-h-[calc(100%-140px)] min-h-[500px] h-full"
        )>
        <div className=%twc("p-6 flex flex-col h-full")>
          <div className=%twc("flex font-bold text-2xl mb-8")>
            <h2> {`관심 상품 추가`->React.string} </h2>
          </div>
          <RescriptReactErrorBoundary
            fallback={_ =>
              <div className=%twc("flex items-center justify-center")>
                <contents className=%twc("flex flex-col items-center justify-center")>
                  <IconNotFound width="160" height="160" />
                  <h1 className=%twc("mt-7 text-2xl text-gray-800 font-bold")>
                    {`처리중 오류가 발생하였습니다.`->React.string}
                  </h1>
                  <span className=%twc("mt-4 text-gray-800")>
                    {`페이지를 불러오는 중에 문제가 발생하였습니다.`->React.string}
                  </span>
                  <span className=%twc("text-gray-800")>
                    {`잠시 후 재시도해 주세요.`->React.string}
                  </span>
                </contents>
              </div>}>
            <PC_InterestedProduct_Add_Search_Buyer checkedSet onItemClick={handleOnChange} />
            <React.Suspense fallback={React.null}>
              <PC_InterestedProduct_Add_Button_Buyer checkedSet onClose />
            </React.Suspense>
          </RescriptReactErrorBoundary>
        </div>
      </RadixUI.Dialog.Content>
    </RadixUI.Dialog.Portal>
  </RadixUI.Dialog.Root>
}
