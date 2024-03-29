import dynamic from "next/dynamic";
import { useRouter } from "next/router";

const RfqItemDetailBuyer = dynamic(
  () =>
    import("src/pages/buyer/rfq/ConfirmRequest/RfqItemDetail_Buyer.mjs").then(
      (mod) => mod.make
    ),
  { ssr: false }
);

export default function Index(props) {
  const router = useRouter();
  const { itemId = "" } = router.query;

  if (!router.isReady) {
    return null;
  }

  return <RfqItemDetailBuyer {...props} itemId={itemId} />;
}
