import { useRouter } from "next/router";

import { make as RfqBasketBuyer } from "src/pages/buyer/rfq/CreateRequest/RfqBasket_Buyer.mjs";

export default function Index(props) {
  const router = useRouter();
  const { requestId = "" , from = ""} = router.query;
  return <RfqBasketBuyer {...props} requestId={requestId} from={from}/>;
}
