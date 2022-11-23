import Like_Buyer from "src/pages/buyer/me/Like_Buyer.mjs";
export {getServerSideProps} from "src/pages/buyer/me/Like_Buyer.mjs"

export default function Index(props) {
  return <Like_Buyer {...props} />;
}
