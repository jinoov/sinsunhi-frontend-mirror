@react.component
let make = (
  ~checked=?,
  ~containerClassName="",
  ~thumbClassName="",
  ~onCheckedChange=?,
  ~disabled=?,
  ~defaultChecked=?,
  ~name=?,
  ~value=?,
) => {
  <RadixUI.Switch.Root
    className={cx([
      %twc("w-12 h-7 bg-disabled-L2 relative rounded-full state-checked:bg-primary"),
      containerClassName,
    ])}
    ?checked
    ?onCheckedChange
    ?disabled
    ?defaultChecked
    ?name
    ?value>
    <RadixUI.Switch.Thumb
      className={cx([
        %twc(
          "w-6 h-6 block bg-white rounded-full transition-transform translate-x-[2px] will-change-transform state-checked:translate-x-[22px]"
        ),
        thumbClassName,
      ])}
    />
  </RadixUI.Switch.Root>
}
