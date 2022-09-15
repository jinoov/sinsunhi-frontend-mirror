module Fragment = %relay(`
  fragment MyInfoCashRemainBuyer_Fragment on User {
    sinsunCashDeposit
  }
`)

module PC = {
  @react.component
  let make = (~query) => {
    let {sinsunCashDeposit: deposit} = Fragment.use(query)

    <div className=%twc("flex items-center justify-between p-7")>
      <span className=%twc("font-bold text-2xl")> {`신선캐시`->React.string} </span>
      <div className=%twc("flex items-center justify-between")>
        <span className=%twc("text-sm text-gray-600 mr-5")>
          {`신선캐시 잔액`->React.string}
        </span>
        <Next.Link href="/buyer/transactions">
          <a className=%twc("contents")>
            <span className=%twc("font-bold mr-2")>
              {`${deposit->Int.toFloat->Locale.Float.show(~digits=0)} 원`->React.string}
            </span>
            <IconArrow height="13" width="13" fill="#727272" />
          </a>
        </Next.Link>
      </div>
    </div>
  }
}

module Mobile = {
  @react.component
  let make = (~query) => {
    let {sinsunCashDeposit: deposit} = Fragment.use(query)

    <div className=%twc("p-4 flex items-center justify-between bg-surface rounded")>
      <div className=%twc("text-gray-600")> {`신선캐시 잔액`->React.string} </div>
      <Next.Link href="/buyer/transactions">
        <a>
          <div className=%twc("flex items-center")>
            <span className=%twc("font-bold mr-2")>
              {`${deposit->Int.toFloat->Locale.Float.show(~digits=0)} 원`->React.string}
            </span>
            <IconArrow height="13" width="13" fill="#727272" />
          </div>
        </a>
      </Next.Link>
    </div>
  }
}
