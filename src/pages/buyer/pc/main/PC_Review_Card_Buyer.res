module Star = {
  @module("/public/assets/star.svg")
  external starIcon: string = "default"

  @module("/public/assets/star-fill.svg")
  external starFillIcon: string = "default"

  @react.component
  let make = (~score: int) => {
    <div className=%twc("flex")>
      {Array.range(0, 4)
      ->Array.map(i =>
        <img
          src={i < score ? starFillIcon : starIcon}
          className=%twc("w-3 h-3")
          alt={i < score ? "채워진 별점" : "채워지지 않은 별점"}
          key={UniqueId.make(~prefix="star", ())}
        />
      )
      ->React.array}
    </div>
  }
}

@react.component
let make = (~title, ~profile, ~date, ~content, ~productScore, ~shippingScore, ~profileImage=?) => {
  <div className=%twc("py-5 px-4 bg-white rounded-2xl flex flex-col min-h-[190px]")>
    <div className=%twc("flex items-center justify-between")>
      <div>
        <div className=%twc("font-bold text-[17px] text-[#1F2024]")> {title->React.string} </div>
        <div className=%twc("text-[15px] text-[#8B8D94]")>
          {`${profile}, ${date}`->React.string}
        </div>
      </div>
      <img
        src={profileImage->Option.getWithDefault("")}
        alt="후기 프로필 사진"
        className=%twc("w-12 h-12")
      />
    </div>
    <div className=%twc("flex mt-[18px]")>
      <div className=%twc("flex items-center gap-1")>
        <span className=%twc("text-[13px] text-[#8B8D94]")> {"상품"->React.string} </span>
        <Star score=productScore />
      </div>
      <div className=%twc("ml-3 flex items-center gap-1")>
        <span className=%twc("text-[13px] text-[#8B8D94]")> {"유통"->React.string} </span>
        <Star score=shippingScore />
      </div>
    </div>
    <p className=%twc("mt-4")> {content->React.string} </p>
    <div />
  </div>
}
