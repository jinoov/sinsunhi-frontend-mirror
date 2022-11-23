let companyLogoUrl = Env.s3PublicUrl ++ "/company"

module Company = {
  @react.component
  let make = (~src, ~alt) => {
    <div className=%twc("flex justify-center items-center w-full aspect-[109/44] relative")>
      <Next.Image src alt layout=#fill objectFit=#cover />
    </div>
  }
}

@react.component
let make = () => {
  <div className=%twc("w-full flex flex-col gap-6 px-6")>
    <div className=%twc("flex gap-6 items-center")>
      {[
        (companyLogoUrl ++ "/cj.png", "CJ 프레시웨어"),
        (companyLogoUrl ++ "/lotte.png", "롯데"),
        (companyLogoUrl ++ "/baemin.png", "배달의 민족"),
      ]
      ->Array.map(((src, alt)) => <Company src alt key=alt />)
      ->React.array}
    </div>
    <div className=%twc("flex gap-6 items-center")>
      {[
        (companyLogoUrl ++ "/coupang.png", "쿠팡"),
        (companyLogoUrl ++ "/auction.png", "옥션"),
        (companyLogoUrl ++ "/gmarket.png", "지마켓"),
      ]
      ->Array.map(((src, alt)) => <Company src alt key=alt />)
      ->React.array}
    </div>
    <div className=%twc("flex gap-6 items-center justify-center")>
      {[
        (companyLogoUrl ++ "/11st.png", "11번가"),
        (companyLogoUrl ++ "/interpark.png", "인터파크"),
      ]
      ->Array.map(((src, alt)) =>
        <div className=%twc("w-[33%]")>
          <Company src alt key=alt />
        </div>
      )
      ->React.array}
    </div>
  </div>
}
