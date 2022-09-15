module PC = {
  @react.component
  let make = () => {
    <div className=%twc("w-full flex flex-col gap-4")>
      <h1 className=%twc("text-text-L1 font-bold text-lg")> {`견적 안내`->React.string} </h1>
      <div className=%twc("w-full bg-surface p-4 rounded-lg")>
        <span className=%twc("text-text-L1 text-base whitespace-pre-line")>
          {`영업일 기준 2시간 내로 최저가 견적을 받아볼 수 있습니다.\n※ 단, 16시 이후 건은 다음 날 오전에 견적서를 발송해드립니다.`->React.string}
        </span>
      </div>
    </div>
  }
}

module MO = {
  @react.component
  let make = () => {
    <div className=%twc("w-full flex flex-col gap-4")>
      <h1 className=%twc("text-text-L1 font-bold text-lg")> {`견적 안내`->React.string} </h1>
      <div className=%twc("w-full bg-surface p-4 rounded-lg")>
        <span className=%twc("text-text-L1 whitespace-pre-line")>
          {`영업일 기준 2시간 내로 최저가 견적을 받아볼 수 있습니다.\n※ 단, 16시 이후 건은 다음 날 오전에 견적서를 발송해드립니다.`->React.string}
        </span>
      </div>
    </div>
  }
}
