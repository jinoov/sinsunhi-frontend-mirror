import WebOrderBuyer from "src/pages/buyer/web-order/Web_Order_Complete_Buyer.mjs";

export { getServerSideProps } from "src/pages/buyer/web-order/Web_Order_Complete_Buyer.mjs";

export default function Index(props) {
  return <WebOrderBuyer {...props} />;
}
