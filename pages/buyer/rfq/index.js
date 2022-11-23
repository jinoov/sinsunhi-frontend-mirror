import RfqBuyer from "src/pages/buyer/rfq/Rfq_Buyer.mjs";
export { getServerSideProps } from "src/pages/buyer/rfq/Rfq_Buyer.mjs";

export default function Index(props) {
  return <RfqBuyer {...props} />;
}
