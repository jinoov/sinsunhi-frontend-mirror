import Saved_Products from "src/pages/buyer/Saved_Products.mjs";

export { getServerSideProps } from "src/pages/buyer/Saved_Products.mjs";

export default function Index(props) {
  return <Saved_Products {...props} />;
}
