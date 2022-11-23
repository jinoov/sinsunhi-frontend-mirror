open RadixUI

module SearchAddress = SearchAddressEmbed

module Mutation = %relay(`
  mutation UpdateAddressBuyer_Mutation($input: UpdateUserInput!) {
    updateUser(input: $input) {
      ... on User {
        ...MyInfoAccountBuyer_Fragment
        ...MyInfoProfileSummaryBuyer_Fragment
        ...MyInfoProfileCompleteBuyer_Fragment
      }
      ... on Error {
        message
      }
    }
  }
`)

@react.component
let make = (~isOpen, ~onClose, ~popup=false) => {
  let (showSearch, setShowSearch) = React.Uncurried.useState(_ => false)
  let (address, setAddress) = React.Uncurried.useState(_ => "")
  let (zipCode, setZipCode) = React.Uncurried.useState(_ => "")
  let (detailAddress, setDetailAddress) = React.Uncurried.useState(_ => "")

  let (mutate, mutating) = Mutation.use()
  let {addToast} = ReactToastNotifications.useToasts()

  let handleAddressOnComplete = (data: DaumPostCode.oncompleteResponse) => {
    let {addressType, zonecode} = data
    // 정책 - 고객의 주소는 도로명주소 || 지번주소로 입력받는다.
    // daum post code의 autoRoadAddress가 empty string인 케이스에 한해 지번주소로 입력한다
    let address = switch addressType {
    | #R => data.address
    | #J =>
      switch data.autoRoadAddress->Js.String2.length > 0 {
      | true => data.autoRoadAddress
      | false => data.address
      }
    }

    setAddress(._ => address)
    setZipCode(._ => zonecode)
    setShowSearch(._ => false)
  }

  let handleOnclickSearchAddress = _ => {
    switch popup {
    | true => {
        open DaumPostCode
        let option = makeOption(~oncomplete=handleAddressOnComplete, ())

        let daumPostCode = make(option)

        let openOption = makeOpenOption(~popupName="주소검색", ~autoClose=true, ())
        daumPostCode->openPostCode(openOption)
      }

    | false => setShowSearch(._ => true)
    }
  }

  let handleDetailAddressOnChange = e => {
    let target = (e->ReactEvent.Synthetic.currentTarget)["value"]

    setDetailAddress(._ => target)
  }

  let reset = _ => {
    setShowSearch(._ => false)
    setAddress(._ => "")
    setDetailAddress(._ => "")
    setZipCode(._ => "")
  }

  let handleOnSumbit = (
    _ => {
      mutate(
        ~variables={
          input: Mutation.make_updateUserInput(
            ~address=address ++ `, ${detailAddress}`,
            ~zipCode,
            (),
          ),
        },
        ~onCompleted=({updateUser}, _) => {
          switch updateUser {
          | #User(_) => {
              addToast(.
                <div className=%twc("flex items-center")>
                  <IconCheck height="24" width="24" fill="#12B564" className=%twc("mr-2") />
                  {j`소재지가 저장되었습니다.`->React.string}
                </div>,
                {appearance: "success"},
              )

              reset()
              onClose()
            }

          | #Error(err) =>
            addToast(.
              <div className=%twc("flex items-center")>
                <IconError height="24" width="24" className=%twc("mr-2") />
                {j`오류가 발생하였습니다. 소재지를 확인하세요.`->React.string}
                {err.message->Option.getWithDefault("")->React.string}
              </div>,
              {appearance: "error"},
            )
          | #UnselectedUnionMember(_) =>
            addToast(.
              <div className=%twc("flex items-center")>
                <IconError height="24" width="24" className=%twc("mr-2") />
                {j`오류가 발생하였습니다. 소재지를 확인하세요.`->React.string}
              </div>,
              {appearance: "error"},
            )
          }
        },
        ~onError={
          err => {
            addToast(.
              <div className=%twc("flex items-center")>
                <IconError height="24" width="24" className=%twc("mr-2") />
                {j`오류가 발생하였습니다. 소재지를 확인하세요.`->React.string}
                {err.message->React.string}
              </div>,
              {appearance: "error"},
            )
          }
        },
        (),
      )->ignore
    }
  )->ReactEvents.interceptingHandler

  // mobile 에서 뒤로가기로 닫혔을 때, 상태초기화
  React.useEffect1(_ => {
    if !isOpen {
      reset()
    }
    None
  }, [isOpen])

  <Dialog.Root _open={isOpen}>
    <Dialog.Overlay className=%twc("dialog-overlay") />
    <Dialog.Content
      className=%twc(
        "dialog-content-plain bottom-0 left-0 xl:bottom-auto xl:left-auto xl:rounded-2xl xl:state-open:top-1/2 xl:state-open:left-1/2 xl:state-open:-translate-x-1/2 xl:state-open:-translate-y-1/2"
      )
      onOpenAutoFocus={ReactEvent.Synthetic.preventDefault}>
      <div
        className=%twc(
          "fixed top-0 left-0 h-full xl:static bg-white w-full max-w-3xl xl:min-h-fit xl:min-w-min xl:w-[90vh] xl:max-w-[480px] xl:max-h-[85vh]"
        )>
        <section className=%twc("h-14 w-full xl:h-auto xl:w-auto xl:mt-10")>
          <div
            className=%twc(
              "flex items-center justify-between px-5 w-full py-4 xl:h-14 xl:w-full xl:pb-10"
            )>
            <div className=%twc("w-6 xl:hidden") />
            <div>
              <span className=%twc("font-bold xl:text-2xl")>
                {`소재지 수정`->React.string}
              </span>
            </div>
            <Dialog.Close className=%twc("focus:outline-none") onClick={_ => onClose()}>
              <IconClose height="24" width="24" fill="#262626" />
            </Dialog.Close>
          </div>
        </section>
        {switch showSearch {
        | false =>
          <section className=%twc("pt-12 xl:pt-3 mb-6 px-4")>
            <form onSubmit={handleOnSumbit}>
              <div className=%twc("flex flex-col ")>
                <div className=%twc("flex flex-col mb-10")>
                  <div className=%twc("mb-2")>
                    <label className=%twc("font-bold")> {`소재지`->React.string} </label>
                  </div>
                  <div className=%twc("flex")>
                    <Input
                      type_="text"
                      name="address"
                      size=Input.Large
                      placeholder={`주소검색을 해주세요.`}
                      className=%twc("w-full text-disabled-L2")
                      value={address}
                      disabled={true}
                      error={None}
                      onChange={_ => ()}
                    />
                    <button
                      type_="button"
                      className=%twc("py-3 px-3 w-[120px] rounded-xl bg-blue-gray-700 ml-2 h-13")
                      onClick={handleOnclickSearchAddress}>
                      <span className=%twc("text-white")> {`주소검색`->React.string} </span>
                    </button>
                  </div>
                  <Input
                    type_="text"
                    name="address-detail"
                    size=Input.Large
                    placeholder={`상세주소를 입력해주세요.`}
                    className=%twc("w-full mt-2")
                    value={detailAddress}
                    disabled={address == ""}
                    error={None}
                    onChange={handleDetailAddressOnChange}
                  />
                </div>
                <button
                  className={cx([
                    %twc("rounded-xl w-full py-4"),
                    address == "" ? %twc("bg-disabled-L2") : %twc("bg-green-500"),
                  ])}
                  disabled={address == "" || mutating}
                  type_="submit">
                  <span className=%twc("text-white")> {`저장`->React.string} </span>
                </button>
              </div>
            </form>
          </section>
        | true => <SearchAddress isShow={true} onComplete={handleAddressOnComplete} />
        }}
      </div>
    </Dialog.Content>
  </Dialog.Root>
}
