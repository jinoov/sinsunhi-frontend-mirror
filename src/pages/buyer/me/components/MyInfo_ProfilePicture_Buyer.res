type size = Small | Large | XLarge
@react.component
let make = (~content, ~size: size) => {
  let (size, fontSize) = switch size {
  | Small => (%twc("min-w-[54px] h-[54px]"), %twc("text-2xl"))
  | Large => (%twc("min-w-[72px] h-[72px]"), %twc("text-2xl"))
  | XLarge => (%twc("min-w-[98px] h-[98px]"), %twc("text-4xl"))
  }
  <div className={cx([%twc("bg-gray-50 rounded-full flex items-center justify-center"), size])}>
    <span className={cx([%twc("text-2xl text-enabled-L4 block"), fontSize])}>
      {content->Js.String2.charAt(_, 0)->React.string}
    </span>
  </div>
}
