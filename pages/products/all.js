import ShopProducts_Buyer from "src/pages/buyer/ShopProducts_Buyer.mjs";

export { getServerSideProps } from "src/pages/buyer/ShopProducts_Buyer.mjs";

export default function Index(props) {
  return <ShopProducts_Buyer {...props} />;
}
