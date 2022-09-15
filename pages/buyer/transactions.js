import Script from "next/script";
import { useEffect } from "react";
import { make as TransactionsBuyer } from "src/pages/buyer/Transactions_Buyer.mjs";

export default function Index(props) {
  useEffect(() => {
    const initPostscribe = async () => {
      // SSR 단계에서 postscribe import 만으로도 window undefined 에러가 발생하여
      // dynamic import로 구현
      const module = await import("postscribe");
      const postscribe = module.default;

      // Next.Script를 활용해서 kcp js 스크립트를 로드하려고 하면 document.write 때문에 로드에 실패합니다.
      // 그래서 postscribe를 이용하여 스크립트를 로드합니다.
      postscribe(
        "#order_info",
        `<script type="text/javascript" src="${process.env.NEXT_PUBLIC_KCP_SCRIPT_URL}"><\/script>`
      );
    };

    initPostscribe();
  }, []);

  return (
    <>
      <TransactionsBuyer {...props} />
      {/* KCP 결제를 위한 form */}
      <form id="order_info" name="order_info" method="post" action="">
        {/* KCP 결제를 처리할 숨겨진 주문정보 form
        우리 API에 주문을 생성을 요청하고 응답 데이터로 채울 input들 */}
        <input
          type="hidden"
          id="ordr_idxx"
          name="ordr_idxx"
          value="TEST12345"
          maxLength="40"
        />
        <input type="hidden" id="good_name" name="good_name" value="신선하이" />
        <input
          type="hidden"
          id="good_mny"
          name="good_mny"
          value="0"
          maxLength="12"
        />
        <input
          type="hidden"
          id="currency"
          name="currency"
          value="0"
          maxLength="9"
        />
        <input type="hidden" id="shop_user_id" name="shop_user_id" value="" />
        <input type="hidden" id="buyr_name" name="buyr_name" value="" />
        <input type="hidden" name="quotaopt" value="0" />{" "}
        {/* 최대 할부 개월수 */}
        {/* Optional 파라미터들
        <input type="hidden" id="buyr_tel1" name="buyr_tel1" value="02-0000-0000" />
        <input type="hidden" id="buyr_tel2" name="buyr_tel2" value="010-0000-0000" />
        <input type="hidden" id="buyr_mail" name="buyr_mail" value="test@test.co.kr" />
        신용카드 + 가상계좌
        신용카드 : 100000000000
        가상계좌 : 001000000000
        신용카드 + 가상계좌를 모두 표시하는 경우 101000000000 */}
        <input
          type="hidden"
          id="pay_method"
          name="pay_method"
          value="101000000000"
        />
        {/* 신선하이 KCP 정보 */}
        <input type="hidden" id="site_cd" name="site_cd" value="T0000" />
        <input
          type="hidden"
          id="site_name"
          name="site_name"
          value="Sinsun Market"
        />
        <input type="hidden" id="site_key" name="site_key" value="" />
        <input
          type="hidden"
          id="site_logo"
          name="site_logo"
          value={process.env.NEXT_PUBLIC_LOGO_150x50_URI}
        />
        {/* KCP의 GetField 함수가 데이터를 채울 input들 */}
        <input type="hidden" id="res_cd" name="res_cd" value="" />
        <input type="hidden" id="res_msg" name="res_msg" value="" />
        <input type="hidden" id="enc_info" name="enc_info" value="" />
        <input type="hidden" id="enc_data" name="enc_data" value="" />
        <input
          type="hidden"
          id="ret_pay_method"
          name="ret_pay_method"
          value=""
        />
        <input type="hidden" id="tran_cd" name="tran_cd" value="" />
        <input
          type="hidden"
          id="use_pay_method"
          name="use_pay_method"
          value=""
        />
      </form>
      <Script
        dangerouslySetInnerHTML={{
          __html: `
            /* KCP 인증완료시 호출 함수  */
            var closeEventKCP /* 결제창 닫는 함수를 담을 전역 변수 */
            function m_Completepayment(FormOrJson, closeEvent) {
              closeEventKCP = closeEvent;
              var frm = document.order_info;
              // FormOrJson 데이터를 form 엘리먼트의 hidden input value에 채워주는 함수
              GetField(frm, FormOrJson);
              if (frm.res_cd.value == "0000") {
                // 우리 API KCP 인증 정보를 mutate 한다.
                mutate_completepayment(frm);
              } else {
                alert("[" + frm.res_cd.value + "] " + frm.res_msg.value);
                closeEvent();
              }
            }
            /* KCP 결제창 실행 함수 */
            function jsf__pay(form) {
              try {
                KCP_Pay_Execute(form);
              } catch (e) {
                console.log(e);
              }
            }`,
        }}
      />
      <Script
        src="https://js.tosspayments.com/v1"
        onLoad={() => {
          if (window != undefined) {
            var clientKey = process.env.NEXT_PUBLIC_TOSS_PAYMENTS_CLIENT_KEY;
            window.tossPayments = TossPayments(clientKey); // 클라이언트 키로 초기화하기
          }
        }}
      />
    </>
  );
}
