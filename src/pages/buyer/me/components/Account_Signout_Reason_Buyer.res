let options = {
  "1": `원하는 상품이 없어서`,
  "2": `상품 정보에 대해 충분히 알기 어려워서`,
  "3": `가격이 만족스럽지 않아서`,
  "4": `신선하이에 대한 신뢰도가 부족해서`,
  "5": `품질에 대한 확신이 부족해서`,
  "6": `전문가 상담이 어려워서`,
  "7": `주문 발수 시스템이 어려워서`,
  "8": `광고 메일, 문자가 자주와서`,
  "9": `기타`,
}

module PC = {
  @react.component
  let make = (~selected, ~setSelected, ~etc, ~setEtc) => {
    let handleOnChange = (reason, _) => {
      let newSet = switch selected->Set.String.has(reason) {
      | true => selected->Set.String.remove(reason)
      | false => selected->Set.String.add(reason)
      }

      setSelected(._ => newSet)
    }

    let handleEtcChange = e => {
      let target = (e->ReactEvent.Synthetic.target)["value"]

      setEtc(._ => target)
      setSelected(._ => selected->Set.String.add(options["9"]))
    }

    <div className=%twc("p-10 border border-[#DCDFE3]")>
      <div>
        {`신선하이 탈퇴사유를 알려주세요.(복수선택 가능)`->React.string}
      </div>
      <div className=%twc("border border-gray-100 mt-6 mb-4") />
      <ul className=%twc("flex flex-wrap")>
        <li className=%twc("flex items-center flex-1 basis-1/2 mt-6")>
          <Checkbox
            id="signout-1"
            name="signout-1"
            checked={selected->Set.String.has(options["1"])}
            onChange={handleOnChange(options["1"])}
          />
          <label htmlFor="signout-1" className=%twc("ml-2")> {options["1"]->React.string} </label>
        </li>
        <li className=%twc("flex items-center flex-1 basis-1/2 mt-6")>
          <Checkbox
            id="signout-2"
            name="signout-2"
            checked={selected->Set.String.has(options["2"])}
            onChange={handleOnChange(options["2"])}
          />
          <label htmlFor="signout-2" className=%twc("ml-2")> {options["2"]->React.string} </label>
        </li>
        <li className=%twc("flex items-center flex-1 basis-1/2 mt-6")>
          <Checkbox
            id="signout-3"
            name="signout-3"
            checked={selected->Set.String.has(options["3"])}
            onChange={handleOnChange(options["3"])}
          />
          <label htmlFor="signout-3" className=%twc("ml-2")> {options["3"]->React.string} </label>
        </li>
        <li className=%twc("flex items-center flex-1 basis-1/2 mt-6")>
          <Checkbox
            id="signout-4"
            name="signout-4"
            checked={selected->Set.String.has(options["4"])}
            onChange={handleOnChange(options["4"])}
          />
          <label htmlFor="signout-4" className=%twc("ml-2")> {options["4"]->React.string} </label>
        </li>
        <li className=%twc("flex items-center flex-1 basis-1/2 mt-6")>
          <Checkbox
            id="signout-5"
            name="signout-5"
            checked={selected->Set.String.has(options["5"])}
            onChange={handleOnChange(options["5"])}
          />
          <label htmlFor="signout-5" className=%twc("ml-2")> {options["5"]->React.string} </label>
        </li>
        <li className=%twc("flex items-center flex-1 basis-1/2 mt-6")>
          <Checkbox
            id="signout-6"
            name="signout-6"
            checked={selected->Set.String.has(options["6"])}
            onChange={handleOnChange(options["6"])}
          />
          <label htmlFor="signout-6" className=%twc("ml-2")> {options["6"]->React.string} </label>
        </li>
        <li className=%twc("flex items-center flex-1 basis-1/2 mt-6")>
          <Checkbox
            id="signout-7"
            name="signout-7"
            checked={selected->Set.String.has(options["7"])}
            onChange={handleOnChange(options["7"])}
          />
          <label htmlFor="signout-7" className=%twc("ml-2")> {options["7"]->React.string} </label>
        </li>
        <li className=%twc("flex items-center flex-1 basis-1/2 mt-6")>
          <Checkbox
            id="signout-8"
            name="signout-8"
            checked={selected->Set.String.has(options["8"])}
            onChange={handleOnChange(options["8"])}
          />
          <label htmlFor="signout-8" className=%twc("ml-2")> {options["8"]->React.string} </label>
        </li>
        <li className=%twc("flex items-center w-full mt-6 mb-2")>
          <Checkbox
            id="signout-9"
            name="signout-9"
            checked={selected->Set.String.has(options["9"])}
            onChange={handleOnChange(options["9"])}
          />
          <label htmlFor="signout-9" className=%twc("ml-2")> {options["9"]->React.string} </label>
        </li>
        <Input
          name="etc"
          type_="text"
          value={etc}
          onChange={handleEtcChange}
          size=Input.Large
          placeholder=`기타 탈퇴사유를 적어주세요.`
          className={%twc("w-full")}
          error={None}
        />
      </ul>
    </div>
  }
}

module Mobile = {
  @react.component
  let make = (~onClickNext, ~onClose, ~selected, ~setSelected, ~etc, ~setEtc) => {
    let handleOnChange = (reason, _) => {
      let newSet = switch selected->Set.String.has(reason) {
      | true => selected->Set.String.remove(reason)
      | false => selected->Set.String.add(reason)
      }

      setSelected(._ => newSet)
    }

    let handleEtcChange = e => {
      let target = (e->ReactEvent.Synthetic.target)["value"]

      setEtc(._ => target)
    }

    let handleSubmit = (
      _ => {
        onClickNext()
      }
    )->ReactEvents.interceptingHandler

    <section className=%twc("px-4 xl:mt-0 pb-6 max-h-[calc(100%-70px)] overflow-y-auto")>
      <form onSubmit={handleSubmit}>
        <div className=%twc("flex flex-col")>
          <div className=%twc("mb-5")>
            <p className=%twc("text-text-L1")>
              {`신선하이 탈퇴사유를 알려주세요.`->React.string}
              <br />
              {`(복수선택 가능)`->React.string}
            </p>
            <div className=%twc("my-6 border") />
            <div className=%twc("flex items-center mb-6")>
              <Checkbox
                id="signout-1"
                name="signout-1"
                checked={selected->Set.String.has(options["1"])}
                onChange={handleOnChange(options["1"])}
              />
              <label htmlFor="signout-1" className=%twc("ml-2")>
                {options["1"]->React.string}
              </label>
            </div>
            <div className=%twc("flex items-center mb-6")>
              <Checkbox
                id="signout-2"
                name="signout-2"
                checked={selected->Set.String.has(options["2"])}
                onChange={handleOnChange(options["2"])}
              />
              <label htmlFor="signout-2" className=%twc("ml-2")>
                {options["2"]->React.string}
              </label>
            </div>
            <div className=%twc("flex items-center mb-6")>
              <Checkbox
                id="signout-3"
                name="signout-3"
                checked={selected->Set.String.has(options["3"])}
                onChange={handleOnChange(options["3"])}
              />
              <label htmlFor="signout-3" className=%twc("ml-2")>
                {options["3"]->React.string}
              </label>
            </div>
            <div className=%twc("flex items-center mb-6")>
              <Checkbox
                id="signout-4"
                name="signout-4"
                checked={selected->Set.String.has(options["4"])}
                onChange={handleOnChange(options["4"])}
              />
              <label htmlFor="signout-4" className=%twc("ml-2")>
                {options["4"]->React.string}
              </label>
            </div>
            <div className=%twc("flex items-center mb-6")>
              <Checkbox
                id="signout-5"
                name="signout-5"
                checked={selected->Set.String.has(options["5"])}
                onChange={handleOnChange(options["5"])}
              />
              <label htmlFor="signout-5" className=%twc("ml-2")>
                {options["5"]->React.string}
              </label>
            </div>
            <div className=%twc("flex items-center mb-6")>
              <Checkbox
                id="signout-6"
                name="signout-6"
                checked={selected->Set.String.has(options["6"])}
                onChange={handleOnChange(options["6"])}
              />
              <label htmlFor="signout-6" className=%twc("ml-2")>
                {options["6"]->React.string}
              </label>
            </div>
            <div className=%twc("flex items-center mb-6")>
              <Checkbox
                id="signout-7"
                name="signout-7"
                checked={selected->Set.String.has(options["7"])}
                onChange={handleOnChange(options["7"])}
              />
              <label htmlFor="signout-7" className=%twc("ml-2")>
                {options["7"]->React.string}
              </label>
            </div>
            <div className=%twc("flex items-center mb-6")>
              <Checkbox
                id="signout-8"
                name="signout-8"
                checked={selected->Set.String.has(options["8"])}
                onChange={handleOnChange(options["8"])}
              />
              <label htmlFor="signout-8" className=%twc("ml-2")>
                {options["8"]->React.string}
              </label>
            </div>
            <div className=%twc("mb-6")>
              <div className=%twc("flex items-center mb-2")>
                <Checkbox
                  id="signout-9"
                  name="signout-9"
                  checked={selected->Set.String.has(options["9"])}
                  onChange={handleOnChange(options["9"])}
                />
                <label htmlFor="signout-9" className=%twc("ml-2")>
                  {options["9"]->React.string}
                </label>
              </div>
              {switch selected->Set.String.has(options["9"]) {
              | true =>
                <Input
                  name="etc"
                  type_="text"
                  value={etc}
                  onChange={handleEtcChange}
                  size=Input.Large
                  placeholder=`기타 탈퇴사유를 적어주세요.`
                  className=%twc("w-full")
                  error={None}
                />
              | false => React.null
              }}
            </div>
          </div>
          <div className=%twc("flex")>
            <button
              className=%twc(
                "bg-gray-150 rounded-xl focus:outline-none w-full py-4 text-center mr-1"
              )
              type_="button"
              onClick={_ => onClose()}>
              <span className=%twc("font-bold")> {`취소`->React.string} </span>
            </button>
            <button
              className={cx([
                %twc("rounded-xl focus:outline-none w-full py-4 text-center ml-1"),
                selected->Set.String.isEmpty ? %twc("bg-gray-150") : %twc("bg-[#FCF0E6]"),
              ])}
              type_="submit"
              disabled={selected->Set.String.isEmpty}>
              <span
                className={cx([
                  %twc("font-bold"),
                  selected->Set.String.isEmpty ? %twc("text-gray-300") : %twc("text-[#FF7A38]"),
                ])}>
                {`탈퇴`->React.string}
              </span>
            </button>
          </div>
        </div>
      </form>
    </section>
  }
}
