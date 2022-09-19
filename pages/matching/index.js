import { make as SectionMain_Matching } from "src/pages/buyer/section/SectionMain_Matching.mjs";
import { detectDeviceFromCtx } from "src/bindings/DeviceDetect.mjs";

export default function Index(props) {
  return <SectionMain_Matching {...props} />;
}

export function getServerSideProps(ctx) {
  let initProps = { deviceType: detectDeviceFromCtx(ctx) }
  return { props: initProps }
}