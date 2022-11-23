@module("../../../../../public/assets/arrow-right.svg")
external arrowRight: string = "default"

module Fragment = %relay(`
  fragment RfqPurchaseDetailBuyerInfoAdminFragment on Rfq {
    buyer {
      name
      manager
      address
      email
      phone
      selfReportedBusinessSectors {
        value
      }
    }
  }
`)

module Parser = {
  module SelfReportedBusinessSector = {
    let toLabel = v => {
      switch v {
      | #CAFE => `카페`->Some
      | #RESTAURANT => `식당`->Some
      | #MART => `마트`->Some
      | #SUPERMARKET => `슈퍼마켓`->Some
      | #BUCHER_SHOP => `정육점`->Some
      | #FRUIT_STORE => `청과매장`->Some
      | #CONSIGNMENT_SALES => `위탁 쇼핑몰`->Some
      | #PURCHASE_AND_SALES => `사입 쇼핑몰`->Some
      | #FOOD_PROCESSING => `식품 제조`->Some
      | #PREPROCESSING_FACTORY => `전처리 공장`->Some
      | #SUBSISTENCES => `급식 유통`->Some
      | #FRANCHISE => `프랜차이즈 본사`->Some
      | #WHOLESALE => `도매유통사`->Some
      | #ETC => `기타`->Some
      | _ => None
      }
    }
  }
}

module Info = {
  @react.component
  let make = (~fieldName, ~value) => {
    <div className=%twc("flex items-start text-[13px]")>
      <div className=%twc("w-[76px] text-text-L2")> {fieldName->React.string} </div>
      <div className=%twc("flex flex-1 text-text-L1")> {value->React.string} </div>
    </div>
  }
}

let nonEmptyStr = str => str != ""

@react.component
let make = (~query, ~className=%twc("")) => {
  let {buyer} = query->Fragment.use

  let name = {
    buyer->Option.mapWithDefault("-", ({name}) =>
      name->Some->Option.keep(nonEmptyStr)->Option.getWithDefault("-")
    )
  }

  let manager = {
    buyer->Option.mapWithDefault("-", ({manager}) =>
      manager->Option.keep(nonEmptyStr)->Option.getWithDefault("-")
    )
  }

  let address = {
    buyer->Option.mapWithDefault("-", ({address}) =>
      address->Option.keep(nonEmptyStr)->Option.getWithDefault("-")
    )
  }

  let email = {
    buyer->Option.mapWithDefault("-", ({email}) =>
      email->Option.keep(nonEmptyStr)->Option.getWithDefault("-")
    )
  }

  let phone = {
    buyer->Option.mapWithDefault("-", ({phone}) =>
      phone->Some->Option.keep(nonEmptyStr)->Option.getWithDefault("-")
    )
  }

  let selfReportedBusinessSectors = {
    buyer->Option.mapWithDefault("-", ({selfReportedBusinessSectors}) =>
      switch selfReportedBusinessSectors {
      | None | Some([]) => `-`
      | Some(nonEmptySectors) =>
        nonEmptySectors
        ->Array.keepMap(({value}) => value->Parser.SelfReportedBusinessSector.toLabel)
        ->Js.Array2.joinWith(`/`)
      }
    )
  }

  <div className={cx([%twc("w-full px-8 py-7"), className])}>
    <h2 className=%twc("font-bold")> {`바이어 정보`->React.string} </h2>
    <div className=%twc("mt-8 grid grid-cols-1 gap-y-3")>
      <Info fieldName={`상호명`} value={name} />
      <Info fieldName={`이름`} value={manager} />
      <Info fieldName={`연락처`} value={phone} />
      <Info fieldName={`이메일`} value={email} />
      <Info fieldName={`주소`} value={address} />
      <Info fieldName={`업종`} value={selfReportedBusinessSectors} />
    </div>
  </div>
}
