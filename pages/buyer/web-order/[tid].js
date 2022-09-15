import Script from "next/script";
import WebOrderBuyer from "src/pages/buyer/web-order/Web_Order_Buyer.mjs";

export { getServerSideProps } from "src/pages/buyer/web-order/Web_Order_Buyer.mjs";

export default function Index(props) {
  return (
    <>
      <Script
        src="https://js.tosspayments.com/v1"
        onLoad={() => {
          if (window != undefined) {
            var clientKey = process.env.NEXT_PUBLIC_TOSS_PAYMENTS_CLIENT_KEY;
            window.tossPayments = TossPayments(clientKey); // 클라이언트 키로 초기화하기
          }
        }}
      />
      <WebOrderBuyer {...props} />
    </>
  );
}
