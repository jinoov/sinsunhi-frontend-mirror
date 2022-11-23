import SRP_Buyer from "src/pages/srp/SRP_Buyer.mjs";
export { getServerSideProps } from "src/pages/srp/SRP_Buyer.mjs";

export default function Index(props) {
  return <SRP_Buyer {...props} />;
}
