module Skeleton = {
  @react.component
  let make = () => {
    <div className=%twc("flex flex-col")>
      <div className=%twc("flex w-full bg-[#FAFBFC]")>
        <PC_Saved_Products_Sidebar.Skeleton />
        <div
          className=%twc(
            "mx-16 bg-white shadow-[0px_10px_40px_10px_rgba(0,0,0,0.03)] min-w-[872px] max-w-[1280px] w-full h-[400px]"
          )
        />
      </div>
      <Footer_Buyer.PC />
    </div>
  }
}
