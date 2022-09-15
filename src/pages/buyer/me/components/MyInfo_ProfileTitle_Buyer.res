@module("../../../../../public/assets/circle-checked.svg")
external circleCheckedkIcon: string = "default"

@react.component
let make = (~name, ~company, ~email, ~isValid, ~sectors) => {
  <div className=%twc("flex flex-col")>
    <div className=%twc("flex flex-wrap items-center xl:block")>
      <div className=%twc("font-bold text-lg")> {name->React.string} </div>
      <div className=%twc("flex")>
        <div className=%twc("ml-1 xl:ml-0 mr-1")> {company->React.string} </div>
        {switch isValid {
        | true => <img src=circleCheckedkIcon width="16px" height="16px" />
        | false => React.null
        }}
      </div>
    </div>
    <p className=%twc("text-gray-600 text-sm max-w-[200px] break-all")> {email->React.string} </p>
    <div className=%twc("flex gap-1 mt-1")>
      {sectors
      ->Array.map(sec => {
        <MyInfo_Capsule_Buyer content=sec key={UniqueId.make(~prefix="sector", ())} />
      })
      ->React.array}
    </div>
  </div>
}
