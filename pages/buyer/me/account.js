import Account_Buyer from "src/pages/buyer/me/Account_Buyer.mjs";
export { getServerSideProps } from "src/pages/buyer/me/Account_Buyer.mjs";

export default function Index(props) {
  return <Account_Buyer {...props} />;
}
