import PDP_Buyer from "src/pages/buyer/pdp/PDP_Buyer.mjs";

export { getServerSideProps } from "src/pages/buyer/pdp/PDP_Buyer.mjs";

export default function Index(props) {
  return <PDP_Buyer {...props} />;
}
