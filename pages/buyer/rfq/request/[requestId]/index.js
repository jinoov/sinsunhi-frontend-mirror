import dynamic from "next/dynamic";
import { useRouter } from "next/router";

const RfqRequestDetailBuyer = dynamic(
  () =>
    import(
      "src/pages/buyer/rfq/ConfirmRequest/RfqRequestDetail_Buyer.mjs"
    ).then((mod) => mod.make),
  { ssr: false }
);

export default function Index(props) {
  const router = useRouter();
  const { requestId = "" } = router.query;

  if (!router.isReady) {
    return null;
  }

  return <RfqRequestDetailBuyer {...props} requestId={requestId} />;
}
