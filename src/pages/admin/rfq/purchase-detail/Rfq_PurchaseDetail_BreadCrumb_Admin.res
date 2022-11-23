@module("../../../../../public/assets/arrow-right.svg")
external arrowRight: string = "default"

@react.component
let make = () => {
  <div className=%twc("flex items-center")>
    <Next.Link href={`/admin/matching/purchases`}>
      <a className=%twc("hover:underline")> {`구매 신청 조회`->React.string} </a>
    </Next.Link>
    <img src=arrowRight className=%twc("w-4 h-4") />
    {`구매 신청 상세`->React.string}
  </div>
}
