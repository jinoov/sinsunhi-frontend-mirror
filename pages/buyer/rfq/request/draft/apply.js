import { useRouter } from "next/router";

import { make as RfqApplyBuyer } from "src/pages/buyer/rfq/CreateRequest/RfqApply_Buyer.mjs";

export default function Index(props) {
  const router = useRouter();
  const { requestId = "", itemId = "" } = router.query;
  return (
    <RfqApplyBuyer
      {...props}
      requestId={requestId}
      itemId={itemId}
    />
  );
}
