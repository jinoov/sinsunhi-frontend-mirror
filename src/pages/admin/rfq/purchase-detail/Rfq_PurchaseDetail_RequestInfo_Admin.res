module Form = Edit_Rfq_Form_Admin

module Fragment = %relay(`
  fragment RfqPurchaseDetailRequestInfoAdminFragment on Rfq {
    number
    requestedFrom
    createdAt
  }
`)

let requestFromToLabel = v => {
  switch v {
  | #RFQ => `농축수산 rfq를 통한 유입`
  | #FARMMORNING => `팜모닝 판로 개척`
  | #PAPERFORM => `페이퍼 폼`
  | #TELEPHONE => `전화 문의`
  | #KAKAOTALK => `카톡 문의`
  | #SALES => `영업 활동`
  | _ => `-`
  }
}

let formatDate = datetime => datetime->Js.Date.fromString->DateFns.format("yyyy. MM. dd / HH:mm")

module Info = {
  @react.component
  let make = (~fieldName, ~value) => {
    <div className=%twc("flex items-start text-[13px]")>
      <div className=%twc("w-[76px] text-text-L2")> {fieldName->React.string} </div>
      <div className=%twc("flex flex-1 text-text-L1")> {value->React.string} </div>
    </div>
  }
}

@react.component
let make = (~query, ~form, ~className=%twc("")) => {
  let {number, requestedFrom, createdAt} = query->Fragment.use
  <div className={cx([%twc("w-full px-8 py-7"), className])}>
    <h2 className=%twc("font-bold")> {`신청 정보`->React.string} </h2>
    <div className=%twc("mt-8 grid grid-cols-1 gap-y-3")>
      <Info fieldName={`ID`} value={number->Int.toString} />
      <Info fieldName={`경로`} value={requestedFrom->requestFromToLabel} />
      <Info fieldName={`신청 날짜`} value={createdAt->formatDate} />
      <div className=%twc("flex items-start text-[13px]")>
        <div className=%twc("mt-[6px] w-[76px] text-text-L2")> {"배송지"->React.string} </div>
        <div className=%twc("flex flex-1 text-text-L1")>
          <Form.Address.Input form />
        </div>
      </div>
    </div>
  </div>
}
