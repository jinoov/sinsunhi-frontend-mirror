import Menu from "src/pages/buyer/Menu.mjs"

export { getServerSideProps } from "src/pages/buyer/Menu.mjs";

export default function Index(props) {
  return <Menu {...props} />;
}

