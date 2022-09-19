import { make as SectionMain_Delivery } from "src/pages/buyer/section/SectionMain_Delivery.mjs";
import { detectDeviceFromCtx } from "src/bindings/DeviceDetect.mjs";

export default function Index(props) {
  return <SectionMain_Delivery {...props} />;
}

export function getServerSideProps(ctx) {
  let initProps = { deviceType: detectDeviceFromCtx(ctx) }
  return { props: initProps }
}