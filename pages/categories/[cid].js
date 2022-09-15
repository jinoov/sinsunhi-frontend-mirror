import PLP_Buyer from "src/pages/buyer/plp/PLP_Buyer.mjs";

export { getServerSideProps } from "src/pages/buyer/plp/PLP_Buyer.mjs";

export default function Index(props) {
  return <PLP_Buyer {...props} />;
}
