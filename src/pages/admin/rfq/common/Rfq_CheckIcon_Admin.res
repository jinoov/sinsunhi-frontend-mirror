module Style = {
  let box = %twc("w-5 h-5 flex items-center justify-center rounded-[6px] border-[1.5px]")
  let selected = %twc("border-[#0BB25F] bg-[#0BB25F]")
  let unselected = %twc("border-[#C3C5C9]")
  let selectedDisabled = %twc("border-[#DCDFE3] bg-[#DCDFE3]")
  let unselectedDisabled = %twc("border-[#F0F2F5]")
}

@react.component
let make = (~value, ~disabled=false) => {
  switch (value, disabled) {
  | (true, false) =>
    <div className={cx([Style.box, Style.selected])}>
      <Formula.Icon.CheckLineRegular size={#sm} color={#white} />
    </div>

  | (true, true) =>
    <div className={cx([Style.box, Style.selectedDisabled])}>
      <Formula.Icon.CheckLineRegular size={#sm} color={#"gray-10"} />
    </div>

  | (false, false) =>
    <div className={cx([Style.box, Style.unselected])}>
      <Formula.Icon.CheckLineRegular size={#sm} color={#"gray-30"} />
    </div>

  | (false, true) =>
    <div className={cx([Style.box, Style.unselectedDisabled])}>
      <Formula.Icon.CheckLineRegular size={#sm} color={#"gray-30"} />
    </div>
  }
}
