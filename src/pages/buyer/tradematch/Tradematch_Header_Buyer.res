@react.component
let make = (~title=?, ~handleClickLeftButton=History.back) => {
  <>
    <div className=%twc("w-full fixed top-0 left-0 z-10")>
      <header className=%twc("w-full max-w-3xl mx-auto h-14 bg-white")>
        <div className=%twc("px-5 py-4 flex justify-between")>
          <button onClick={_ => handleClickLeftButton()}>
            <Formula.Icon.ArrowLeftLineRegular size=#xl />
          </button>
          <div>
            <span className=%twc("font-bold text-base")>
              {title->Option.mapWithDefault(``, x => x)->React.string}
            </span>
          </div>
          <div />
        </div>
      </header>
    </div>
    <div className=%twc("w-full h-14") />
  </>
}
