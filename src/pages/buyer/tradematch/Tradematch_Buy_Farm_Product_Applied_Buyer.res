@react.component
let make = () => {
  let router = Next.Router.useRouter()

  React.useEffect0(_ => {
    // Braze Push Notification Request
    Braze.PushNotificationRequestDialog.trigger()
    None
  })

  <>
    <Tradematch_Buy_Farm_Apply_Steps_Buyer.Common.Title
      text={`24시간 안으로 담당자가\n연락을 드릴예정입니다`}
      subText={`'영업일' 기준 24시간 내 연락을 드려요\n견적신청서 내역은 카카오톡에서 확인하실 수 있어요`}
      label={<div className=%twc("inline-block rounded text-primary bg-primary-light px-2 py-1")>
        <span> {`요청서를 보냈어요!`->React.string} </span>
      </div>}
    />
    <div className=%twc("fixed bottom-0 max-w-3xl w-full gradient-cta-t tab-highlight-color")>
      <div className=%twc("w-full max-w-[768px] px-4 py-5 mx-auto")>
        <button
          onClick={_ => router->Next.Router.push(`/buyer`)}
          className={cx([
            %twc("h-14 w-full rounded-xl bg-primary text-white text-lg font-bold"),
            %twc("disabled:bg-disabled-L2 disabled:text-inverted disabled:text-opacity-50"),
          ])}>
          {`홈으로`->React.string}
        </button>
      </div>
    </div>
    <div className=%twc("h-24") />
  </>
}
