import {default as AuctionPrice_Buyer} from "src/pages/buyer/AuctionPrice_Buyer.mjs"

export { getServerSideProps } from "src/pages/buyer/AuctionPrice_Buyer.mjs";

export default function Index(props) {
  return <AuctionPrice_Buyer {...props}/>
}
