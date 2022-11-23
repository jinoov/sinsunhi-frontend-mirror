@react.component
let make = (~query, ~children=?) => {
  
  <div className=%twc("fixed w-full bottom-0 left-0")>
    <div className=%twc("w-full max-w-[768px] p-3 mx-auto border-t border-t-gray-100 bg-white ")>
      <div className=%twc("w-full h-14 flex gap-2")>
        <PDP_Like_Button_MO query />
        <PDP_CsChat_Button_MO />
        {children->Option.getWithDefault(React.null)}
      </div>
    </div>
  </div>
}
