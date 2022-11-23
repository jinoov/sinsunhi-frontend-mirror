import Recent_Buyer from "src/pages/buyer/me/Recent_Buyer.mjs";
export {getServerSideProps} from "src/pages/buyer/me/Recent_Buyer.mjs"

export default function Index(props) {
  return <Recent_Buyer {...props} />;
}
