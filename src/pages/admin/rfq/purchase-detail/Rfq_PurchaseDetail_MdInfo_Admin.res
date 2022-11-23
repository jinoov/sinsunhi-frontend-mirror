module Form = Edit_Rfq_Form_Admin

module SelectContainer = {
  @react.component
  let make = (~fieldName, ~children) => {
    <div className=%twc("box-border flex items-center text-[13px]")>
      <div className=%twc("w-[76px] text-text-L2")> {fieldName->React.string} </div>
      <div className=%twc("flex flex-1 text-text-L1")> children </div>
    </div>
  }
}

@react.component
let make = (~className=%twc(""), ~form) => {
  <div className={cx([%twc("w-full px-8 py-7"), className])}>
    <h2 className=%twc("font-bold")> {`담당자 설정`->React.string} </h2>
    <div className=%twc("mt-8 grid grid-cols-1 gap-y-7")>
      <SelectContainer fieldName={`컨택 담당자`}>
        <Form.ContactMd.Select form />
      </SelectContainer>
      <SelectContainer fieldName={`소싱 담당자1`}>
        <Form.SourcingMd1.Select form />
      </SelectContainer>
      <SelectContainer fieldName={`소싱 담당자2`}>
        <Form.SourcingMd2.Select form />
      </SelectContainer>
      <SelectContainer fieldName={`소싱 담당자3`}>
        <Form.SourcingMd3.Select form />
      </SelectContainer>
    </div>
  </div>
}
