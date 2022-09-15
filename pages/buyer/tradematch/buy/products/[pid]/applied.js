import dynamic from "next/dynamic";
import Script from "next/script";
import { useRouter } from "next/router";

const TradematchAskToBuyApplyBuyer = dynamic(
  () =>
    import(
      "src/pages/buyer/tradematch/Tradematch_Buy_Product_Applied_Buyer.mjs"
    ).then((mod) => mod.make),
  { ssr: false }
);

export default function Index(props) {
  const router = useRouter();
  const { pid = "" } = router.query;
  return (
    <>
      <TradematchAskToBuyApplyBuyer {...props} pid={pid} />
    </>
  );
}
