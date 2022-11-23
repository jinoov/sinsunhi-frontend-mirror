open ReactHookForm
open Web_Order_Util_Component
module Form = Web_Order_Buyer_Form

module ReceiverNameInput = {
  @react.component
  let make = (~prefix) => {
    let formNames = Form.names(prefix)
    let {register, formState: {errors}} = Hooks.Context.use(.
      ~config=Hooks.Form.config(~mode=#onChange, ()),
      (),
    )
    let {ref, name, onChange, onBlur} = register(.
      formNames.receiverName,
      Some(Hooks.Register.config(~required=true, ~maxLength=50, ())),
    )

    <div className=%twc("flex flex-col gap-2 xl:gap-0 xl:flex-row xl:items-baseline")>
      <label htmlFor=name className=%twc("xl:w-1/4 block font-bold text-text-L1")>
        {`이름`->React.string}
      </label>
      <div className=%twc("w-full xl:w-3/4")>
        <input
          id=name
          ref
          name
          onChange
          onBlur
          className=%twc("w-full h-13 xl:h-9 px-3 border border-gray-300 rounded-lg")
          placeholder={`배송 받으실 분의 이름을 입력해주세요`}
        />
        <ErrorMessage
          name
          errors
          render={_ =>
            <span className=%twc("flex mt-1")>
              <IconError width="20" height="20" />
              <span className=%twc("text-sm text-notice ml-1")>
                {`배송 받으실 분의 이름을 입력해주세요`->React.string}
              </span>
            </span>}
        />
      </div>
    </div>
  }
}

module ReceiverPhoneInput = {
  @react.component
  let make = (~prefix) => {
    let formNames = Form.names(prefix)
    let {control, formState: {errors}} = Hooks.Context.use(.
      ~config=Hooks.Form.config(~mode=#onChange, ()),
      (),
    )

    let newValue = e =>
      (e->ReactEvent.Synthetic.currentTarget)["value"]
      ->Js.String2.slice(~from=0, ~to_=14)
      ->Js.String2.replaceByRe(%re("/[^0-9]/g"), "")
      ->(str =>
        switch str->Js.String.length == 12 {
        // length == 12는 안심번호로 간주 예시) 0502-0772-8543
        | true => str->Js.String2.replaceByRe(%re("/([0-9]{4})([0-9]{4})([0-9]{4})/"), "$1-$2-$3")
        | false =>
          str->Js.String2.replaceByRe(
            %re("/(^02.{0}|^01.{1}|[0-9]{3})([0-9]+)([0-9]{4})/"),
            "$1-$2-$3",
          )
        })
      ->Js.String2.replace("--", "-")

    let toPhoneFormat = (fn, e) => fn(Controller.OnChangeArg.value(e->newValue->Js.Json.string))

    <div
      className=%twc(
        "flex flex-col gap-2 xl:gap-0 xl:max-w-full xl:flex-row text-text-L1 xl:items-baseline"
      )>
      <label htmlFor=formNames.receiverPhone className=%twc("xl:w-1/4 block font-bold")>
        {`연락처`->React.string}
      </label>
      <div className=%twc("w-full xl:w-3/4")>
        <Controller
          name=formNames.receiverPhone
          defaultValue={Js.Json.string("")}
          rules={Rules.make(~required=true, ~minLength=10, ())}
          control
          render={({field: {name, ref, value, onChange}}) => <>
            <input
              ref
              value={value->Js.Json.decodeString->Option.getWithDefault("")}
              className=%twc("w-full h-13 xl:h-9 px-3 border border-gray-300 rounded-lg")
              placeholder={`배송 받으실 분의 연락처를 입력해주세요`}
              onChange={toPhoneFormat(onChange)}
            />
            <ErrorMessage
              name
              errors
              render={_ =>
                <span className=%twc("flex mt-1")>
                  <IconError width="20" height="20" />
                  <span className=%twc("text-sm text-notice ml-1")>
                    {`배송 받으실 분의 연락처를 입력해주세요`->React.string}
                  </span>
                </span>}
            />
          </>}
        />
      </div>
    </div>
  }
}

module ReceiverAddressInput = {
  @react.component
  let make = (~prefix, ~deviceType) => {
    let router = Next.Router.useRouter()

    let (isShowSearchAddress, setShowSearchAddress) = React.Uncurried.useState(_ => false)

    let formNames = Form.names(prefix)
    let {register, setValue, control, formState: {errors}} = Hooks.Context.use(.
      ~config=Hooks.Form.config(~mode=#all, ()),
      (),
    )
    let zipcodeRegister = register(.
      formNames.receiverZipCode,
      Some(Hooks.Register.config(~required=true, ())),
    )

    let addressRegister = register(. formNames.receiverAddress, None)

    let detailAdressRegister = register(.
      formNames.receiverDetailAddress,
      Some(Hooks.Register.config(~required=true, ~maxLength=50, ())),
    )

    let handleOnClickSearchAddress = changeFn =>
      {
        _ => {
          switch deviceType {
          | DeviceDetect.PC => {
              open DaumPostCode
              let option = makeOption(~oncomplete=data => {
                changeFn(Controller.OnChangeArg.value(Js.Json.string(data.zonecode)))
                setValue(. formNames.receiverAddress, Js.Json.string(data.address))
              }, ())
              let daumPostCode = option->make

              let openOption = makeOpenOption(~popupName="우편번호 검색", ())
              daumPostCode->openPostCode(openOption)
            }

          | DeviceDetect.Mobile | DeviceDetect.Unknown => {
              // #search-address-opened 해시를 이용해서 모달이 열렸을 때 history를 추가해준다.
              // 뒤로가기 했을 경우 모달을 닫는데 활용한다.
              if !(router.asPath->Js.String2.includes("#search-address-opened")) {
                router->Next.Router.push(`${router.asPath}#search-address-opened`)
              }
              setShowSearchAddress(._ => true)
            }
          }
        }
      }->ReactEvents.interceptingHandler

    let onCompleteSearchAddress = (changeFn, data: DaumPostCode.oncompleteResponse) => {
      changeFn(Controller.OnChangeArg.value(Js.Json.string(data.zonecode)))
      setValue(. formNames.receiverAddress, Js.Json.string(data.address))
      setShowSearchAddress(._ => false)
    }

    // #search-address-opened가 없는데(즉, 모달이 켜져있는 상태에서 뒤로 가기 했을 때)
    // isShowSearchAddress 상태값이 true이 경우, false로 변경하여 모달을 닫는다.
    // 반대의 경우는 고려하지 않는다. 즉, #search-address-opened가 있다고 해서 모달을 열지 않는다.
    React.useEffect1(_ => {
      if !(router.asPath->Js.String2.includes("#search-address-opened")) && isShowSearchAddress {
        setShowSearchAddress(._ => false)
      }

      None
    }, [router.asPath])

    <>
      <div className=%twc("flex flex-col gap-2 xl:flex-row xl:gap-0 xl:items-baseline")>
        <label className=%twc("block font-bold text-text-L1 xl:w-1/4")>
          {`주소`->React.string}
        </label>
        <div className=%twc("flex flex-col gap-2 w-full xl:w-3/4")>
          <div className=%twc("flex flex-col gap-1")>
            <Controller
              name=zipcodeRegister.name
              control
              shouldUnregister=true
              defaultValue={Js.Json.string("")}
              rules={Rules.make(~required=true, ())}
              render={({field: {onChange, value, name, ref}}) => <>
                <div className=%twc("flex gap-1")>
                  <input
                    readOnly=true
                    id=name
                    ref
                    value={value->Js.Json.decodeString->Option.getWithDefault("")}
                    name
                    onBlur=zipcodeRegister.onBlur
                    className=%twc(
                      "w-full xl:w-40 h-13 xl:h-9 px-3 border border-gray-300 rounded-lg bg-disabled-L3 text-disabled-L1"
                    )
                    placeholder={`우편번호`}
                  />
                  <button
                    type_="button"
                    className=%twc(
                      "px-3 min-w-max py-1.5 h-13 xl:h-9 text-white bg-blue-gray-700 rounded-lg"
                    )
                    onClick={handleOnClickSearchAddress(onChange)}>
                    {`주소검색`->React.string}
                  </button>
                </div>
                <ErrorMessage
                  name=formNames.receiverZipCode
                  errors
                  render={_ =>
                    <span className=%twc("flex")>
                      <IconError width="20" height="20" />
                      <span className=%twc("text-sm text-notice ml-1")>
                        {`'주소검색'을 통해 우편번호를 입력해주세요`->React.string}
                      </span>
                    </span>}
                />
                {
                  // 모바일의 경우 팝업을 이용한 방식에 이슈가 발생하여(특히, RN 웹뷰에서)
                  // iframe embed 방식으로 처리합니다.
                  open RadixUI
                  <Dialog.Root _open={isShowSearchAddress}>
                    <Dialog.Overlay className=%twc("dialog-overlay") />
                    <Dialog.Content
                      className=%twc("dialog-content-plain top-0 bottom-0 left-0 right-0")
                      onOpenAutoFocus={ReactEvent.Synthetic.preventDefault}>
                      <section className=%twc("h-14 w-full xl:h-auto xl:w-auto xl:mt-10")>
                        <div
                          className=%twc(
                            "flex items-center justify-between px-5 w-full py-4 xl:h-14 xl:w-full xl:pb-10"
                          )>
                          <div className=%twc("w-6 xl:hidden") />
                          <div>
                            <span className=%twc("font-bold xl:text-2xl")>
                              {`주소 검색`->React.string}
                            </span>
                          </div>
                          <Dialog.Close
                            className=%twc("focus:outline-none")
                            onClick={_ => router->Next.Router.back}>
                            <IconClose height="24" width="24" fill="#262626" />
                          </Dialog.Close>
                        </div>
                      </section>
                      <SearchAddressEmbed
                        isShow=true onComplete={onCompleteSearchAddress(onChange)}
                      />
                    </Dialog.Content>
                  </Dialog.Root>
                }
              </>}
            />
          </div>
          <input
            readOnly=true
            id=addressRegister.name
            ref=addressRegister.ref
            name=addressRegister.name
            onChange=addressRegister.onChange
            onBlur=addressRegister.onBlur
            className=%twc(
              "w-full h-13 xl:h-9 px-3 border border-gray-300 rounded-lg bg-disabled-L3 text-disabled-L1"
            )
            placeholder={`우편번호 찾기를 통해 주소입력이 가능합니다.`}
          />
          <input
            id=detailAdressRegister.name
            ref=detailAdressRegister.ref
            name=detailAdressRegister.name
            onChange=detailAdressRegister.onChange
            onBlur=detailAdressRegister.onBlur
            className=%twc("w-full h-13 xl:h-9 px-3 border border-gray-300 rounded-lg ")
            placeholder={`상세주소를 입력해주세요.`}
          />
          <ErrorMessage
            name=detailAdressRegister.name
            errors
            render={_ =>
              <span className=%twc("flex mt-1")>
                <IconError width="20" height="20" />
                <span className=%twc("text-sm text-notice ml-1")>
                  {`상세주소를 입력해주세요`->React.string}
                </span>
              </span>}
          />
        </div>
      </div>
    </>
  }
}

module DeliveryMessageInput = {
  @react.component
  let make = (~prefix, ~selfMode=false) => {
    let formNames = Form.names(prefix)
    let {register, formState: {errors}} = Hooks.Context.use(.
      ~config=Hooks.Form.config(~mode=#onChange, ()),
      (),
    )
    let {ref, name, onChange, onBlur} = register(.
      formNames.deliveryMessage,
      Some(Hooks.Register.config(~maxLength=100, ())),
    )

    <div
      className=%twc(
        "flex flex-col gap-2 xl:gap-0 xl:max-w-full xl:flex-row text-text-L1 xl:items-baseline"
      )>
      <label htmlFor=name className=%twc("xl:w-1/4 block font-bold")>
        {`${selfMode ? `수령시` : `배송`} 요청사항`->React.string}
      </label>
      <div className=%twc("w-full xl:w-3/4")>
        <input
          id=name
          ref
          name
          onChange
          onBlur
          className=%twc("w-full h-13 xl:h-9 px-3 border border-gray-300 rounded-lg")
          placeholder={`${selfMode
              ? `수령`
              : `배송`}시 요청사항을 입력해주세요 (최대 100자)`}
        />
        <ErrorMessage
          name
          errors
          render={_ =>
            <span className=%twc("flex mt-1")>
              <IconError width="20" height="20" />
              <span className=%twc("text-sm text-notice ml-1")>
                {`최대 100자 까지 입력해주세요`->React.string}
              </span>
            </span>}
        />
      </div>
    </div>
  }
}

module DeliveryDesiredDateSelection = {
  @react.component
  let make = (~prefix, ~selfMode=false) => {
    let formNames = Form.names(prefix)
    let {control} = Hooks.Context.use(. ~config=Hooks.Form.config(~mode=#onChange, ()), ())

    let handleOnChangeDate = (fn, e) => {
      let newDate = (e->DuetDatePicker.DuetOnChangeEvent.detail).value
      newDate->Js.Json.string->Controller.OnChangeArg.value->fn
    }

    // 현재 시각 < 09시 => D+1(내일)
    // 현재 시각 > 09시 => D+2(모레)
    // 주말 선택 불가
    let minDate =
      Js.Date.make()
      ->DateFns.addHours(39)
      ->(
        t =>
          switch t->Js.Date.getDay {
          | 0. => t->DateFns.addDays(1)
          | 6. => t->DateFns.addDays(2)
          | _ => t
          }
      )

    <div className=%twc("flex flex-col xl:flex-row gap-2 xl:gap-0 xl:w-full xl:items-baseline")>
      <label className=%twc("xl:w-1/4 block font-bold")>
        {`${selfMode ? `수령` : `배송`} 희망일`->React.string}
      </label>
      <div className=%twc("flex flex-col gap-1 w-full xl:w-3/4")>
        <div className=%twc("flex gap-2")>
          <Controller
            name={formNames.deliveryDesiredDate}
            control
            shouldUnregister=true
            defaultValue={Js.Json.string(minDate->DateFns.format("yyy-MM-dd"))}
            render={({field: {onChange}}) => {
              <DatePicker
                id="from"
                isDateDisabled={d => d->Js.Date.getDay == 0. || d->Js.Date.getDay == 6.}
                date={minDate}
                onChange={handleOnChangeDate(onChange)}
                minDate={minDate->DateFns.format("yyyy-MM-dd")}
                firstDayOfWeek=0
              />
            }}
          />
          {switch selfMode {
          | true => React.null
          | false => <FreightDeliveryCost_Table_Buyer />
          }}
        </div>
        <span className=%twc("text-sm text-text-L2")>
          {`* 원하시는 날짜에 맞춰 물량 확보 및 ${selfMode
              ? `수령`
              : `배송`}이 가능한지 확인 후 연락 드립니다.`->React.string}
        </span>
      </div>
    </div>
  }
}

module PaymentMethodSelection = {
  @react.component
  let make = (~prefix, ~deviceType) => {
    let formNames = Form.names(prefix)
    let {register, formState: {errors}} = Hooks.Context.use(.
      ~config=Hooks.Form.config(~mode=#onChange, ()),
      (),
    )
    let {ref, name, onChange, onBlur} = register(.
      formNames.paymentMethod,
      Some(Hooks.Register.config(~required=true, ())),
    )

    let watchValue = Hooks.WatchValues.use(
      Hooks.WatchValues.Text,
      ~config=Hooks.WatchValues.config(~name=formNames.paymentMethod, ()),
      (),
    )

    <section className=%twc("flex flex-col gap-5 bg-white text-enabled-L1")>
      <span className=%twc("text-lg xl:text-xl font-bold")>
        {`결제 수단 선택`->React.string}
      </span>
      <div className=%twc("flex gap-2")>
        {[("card", "카드결제"), ("transfer", "계좌이체"), ("virtual", "가상계좌")]
        ->Array.map(((value, n)) =>
          <label
            key=n
            className=%twc(
              "focus:outline-none focus-within:bg-primary-light focus-within:outline-none focus-within:rounded-xl"
            )>
            <input className=%twc("sr-only") type_="radio" id=name ref name onChange onBlur value />
            <RadioButton watchValue name=n value deviceType />
          </label>
        )
        ->React.array}
      </div>
      <ErrorMessage
        name
        errors
        render={_ =>
          <span className=%twc("flex")>
            <IconError width="20" height="20" />
            <span className=%twc("text-sm text-notice ml-1")>
              {`결제 수단을 선택해주세요`->React.string}
            </span>
          </span>}
      />
    </section>
  }
}
