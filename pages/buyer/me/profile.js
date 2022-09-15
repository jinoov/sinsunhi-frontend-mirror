import Profile_Buyer from "src/pages/buyer/me/Profile_Buyer.mjs";
export { getServerSideProps } from "src/pages/buyer/me/Profile_Buyer.mjs";

export default function Index(props) {
  return <Profile_Buyer {...props} />;
}
