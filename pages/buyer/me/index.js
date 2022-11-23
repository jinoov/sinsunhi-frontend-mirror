import MyInfo_Buyer from "src/pages/buyer/me/MyInfo_Buyer.mjs"
export { getServerSideProps } from "src/pages/buyer/me/MyInfo_Buyer.mjs"

export default function Index(props) {
  return <MyInfo_Buyer {...props} />
}

