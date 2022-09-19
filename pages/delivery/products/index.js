import { make as Delivery_PLP } from "src/pages/buyer/section/Delivery_PLP.mjs";
import { detectDeviceFromCtx } from "src/bindings/DeviceDetect.mjs";

export default function Index(props) {
  return <Delivery_PLP {...props} />;
}

export function getServerSideProps(ctx) {
  let initProps = { deviceType: detectDeviceFromCtx(ctx) }
  return { props: initProps }
}