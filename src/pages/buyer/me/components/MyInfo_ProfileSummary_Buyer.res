module Fragment = %relay(`
  fragment MyInfoProfileSummaryBuyer_Fragment on User {
    name
    manager
    uid
    verifications {
      isValidBusinessRegistrationNumberByViewer
    }
    selfReportedBusinessSectors {
      label
    }
  }
`)
module PC = {
  @react.component
  let make = (~query) => {
    let {
      name: company,
      manager: name,
      uid: email,
      verifications,
      selfReportedBusinessSectors,
    } = Fragment.use(query)

    <div className=%twc("pb-5 flex items-center justify-between")>
      <div className=%twc("flex")>
        <MyInfo_ProfilePicture_Buyer content=company size=MyInfo_ProfilePicture_Buyer.Large />
        <div className=%twc("ml-3")>
          <MyInfo_ProfileTitle_Buyer
            name={name->Option.getWithDefault("")}
            company
            sectors={selfReportedBusinessSectors->Option.mapWithDefault([], d =>
              d->Array.map(({label}) => label)
            )}
            email
            isValid={verifications->Option.mapWithDefault(false, d =>
              d.isValidBusinessRegistrationNumberByViewer
            )}
          />
        </div>
      </div>
    </div>
  }
}

module Mobile = {
  @react.component
  let make = (~query) => {
    let {
      name: company,
      manager: name,
      uid: email,
      verifications,
      selfReportedBusinessSectors,
    } = Fragment.use(query)

    <Next.Link href="/buyer/me/profile">
      <a>
        <div className=%twc("flex justify-between")>
          <div className=%twc("flex items-center")>
            <MyInfo_ProfilePicture_Buyer content=company size=MyInfo_ProfilePicture_Buyer.Small />
            <div className=%twc("ml-3")>
              <MyInfo_ProfileTitle_Buyer
                name={name->Option.getWithDefault("")}
                company
                sectors={selfReportedBusinessSectors->Option.mapWithDefault([], d =>
                  d->Array.map(({label}) => label)
                )}
                email
                isValid={verifications->Option.mapWithDefault(false, d =>
                  d.isValidBusinessRegistrationNumberByViewer
                )}
              />
            </div>
          </div>
          <IconArrow height="24" width="24" fill="#B2B2B2" />
        </div>
      </a>
    </Next.Link>
  }
}
