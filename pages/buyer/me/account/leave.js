import Account_Signout_Buyer from "src/pages/buyer/me/Account_Signout_Buyer_PC.mjs";
export { getServerSideProps } from "src/pages/buyer/me/Account_Signout_Buyer_PC.mjs";

export default function Index(props) {
  return <Account_Signout_Buyer {...props} />;
}
