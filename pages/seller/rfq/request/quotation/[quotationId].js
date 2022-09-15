import dynamic from "next/dynamic";
import { useRouter } from "next/router";

const RfqConfirmSeller = dynamic(
  () =>
    import("src/pages/seller/rfq/RfqConfirm_Seller.mjs").then(
      (mod) => mod.make
    ),
  { ssr: false }
);

export default function Index(props) {
  const router = useRouter();
  const { quotationId = "" } = router.query;

  if (!router.isReady) {
    return null;
  }

  return <RfqConfirmSeller {...props} quotationId={quotationId} />;
}
