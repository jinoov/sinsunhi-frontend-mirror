module PC = {
  module View = {
    @react.component
    let make = () => {
      <>
        <SectionMain_PC_Title title={`신선배송`} />
        <Delivery_Main_InfoBanner.PC />
        <Delivery_Main_Category.PC />
        <Delivery_Main_AllProducts.PC />
      </>
    }
  }

  module Skeleton = {
    @react.component
    let make = () => {
      <>
        <SectionMain_PC_Title.Skeleton />
        <Delivery_Main_InfoBanner.PC.Skeleton />
        <Delivery_Main_Category.PC.Skeleton />
        <Delivery_Main_AllProducts.PC.Skeleton />
      </>
    }
  }

  @react.component
  let make = () => {
    <View />
  }
}

module MO = {
  module View = {
    @react.component
    let make = () => {
      <>
        <Delivery_Main_InfoBanner.MO />
        <Delivery_Main_Category.MO />
        <Divider />
        <Delivery_Main_AllProducts.MO />
      </>
    }
  }

  module Skeleton = {
    @react.component
    let make = () => {
      <>
        <Delivery_Main_InfoBanner.MO.Skeleton />
        <Delivery_Main_Category.MO.Skeleton />
        <Divider />
        <Delivery_Main_Category.MO.Skeleton />
        <Delivery_Main_AllProducts.MO.Skeleton />
      </>
    }
  }

  @react.component
  let make = () => {
    <View />
  }
}

module Skeleton = {
  @react.component
  let make = (~deviceType) => {
    switch deviceType {
    | DeviceDetect.Unknown => React.null
    | DeviceDetect.PC => <PC.Skeleton />
    | DeviceDetect.Mobile => <MO.Skeleton />
    }
  }
}

module Container = {
  @react.component
  let make = (~deviceType) => {
    ChannelTalkHelper.Hook.use()
    switch deviceType {
    | DeviceDetect.Unknown => React.null
    | DeviceDetect.PC => <PC />
    | DeviceDetect.Mobile => <MO />
    }
  }
}

@react.component
let make = (~deviceType) => {
  let (isCsr, setIsCsr) = React.Uncurried.useState(_ => false)

  React.useEffect0(() => {
    setIsCsr(._ => true)
    None
  })

  <>
    <Next.Head> <title> {`신선하이 신선배송`->React.string} </title> </Next.Head>
    <RescriptReactErrorBoundary fallback={_ => <Skeleton deviceType />}>
      <React.Suspense fallback={<Skeleton deviceType />}>
        {switch isCsr {
        | true => <Container deviceType />
        | false => <Skeleton deviceType />
        }}
      </React.Suspense>
    </RescriptReactErrorBoundary>
  </>
}
