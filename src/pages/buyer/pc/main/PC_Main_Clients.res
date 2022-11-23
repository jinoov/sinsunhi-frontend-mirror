let companyLogoUrl = Env.s3PublicUrl ++ "/company"

module LogoItem = {
  @react.component
  let make = (~src, ~alt) => {
    <div className=%twc("bg-[#F7F8FA] rounded-2xl p-6")>
      <div className=%twc("flex justify-center items-center  aspect-[109/44] w-full relative")>
        <Next.Image src alt layout=#fill objectFit=#cover />
      </div>
    </div>
  }
}

type widthVariant = Narrow | Wide
module LogoGrid = {
  @react.component
  let make = (~widthVariant) => {
    let className = cx([
      switch widthVariant {
      | Narrow => %twc("grid-cols-3")
      | Wide => %twc("grid-cols-6")
      },
      %twc("w-full grid gap-6"),
    ])

    <div className>
      {[
        (companyLogoUrl ++ "/cj.png", "CJ 프레시웨어"),
        (companyLogoUrl ++ "/lotte.png", "롯데"),
        (companyLogoUrl ++ "/baemin.png", "배달의 민족"),
        (companyLogoUrl ++ "/coupang.png", "쿠팡"),
        (companyLogoUrl ++ "/auction.png", "옥션"),
        (companyLogoUrl ++ "/gmarket.png", "지마켓"),
        (companyLogoUrl ++ "/11st.png", "11번가"),
        (companyLogoUrl ++ "/interpark.png", "인터파크"),
      ]
      ->Array.map(((src, alt)) => <LogoItem src alt key=alt />)
      ->React.array}
    </div>
  }
}

@react.component
let make = (~widthVariant) => {
  <div className=%twc("flex flex-col flex-1 px-[50px] mb-[84px]")>
    <span className=%twc("mb-6 text-[19px] font-bold")> {`대표 고객사`->React.string} </span>
    <LogoGrid widthVariant />
  </div>
}
