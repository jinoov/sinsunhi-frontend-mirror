import ActivateUser from "src/pages/ActivateUser.mjs";

export { getServerSideProps } from "src/pages/ActivateUser.mjs";

export default function Index(props) {
  return <ActivateUser {...props} />;
}
