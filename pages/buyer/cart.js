import Cart_Buyer from "src/pages/buyer/Cart_Buyer.mjs";

export { getServerSideProps } from "src/pages/buyer/Cart_Buyer.mjs";

export default function Index(props) {
    return <Cart_Buyer {...props} />;
}
