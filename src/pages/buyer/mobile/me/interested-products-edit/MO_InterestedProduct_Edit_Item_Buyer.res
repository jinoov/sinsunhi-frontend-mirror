@module("/public/assets/edit-hamburger.svg")
external hamburgerIcons: string = "default"

@react.component
let make = (~index, ~id, ~displayName, ~image, ~representativeWeight, ~delete) => {
  let draggingStyle = isDragging =>
    isDragging
      ? %twc(
          "before:content-[''] before:w-full before:h-full before:absolute before:top-0 before:left-0 before:pointer-events-none before:bg-[#242a30] before:opacity-5"
        )
      : ""

  <ReactBeautifulDnD.Draggable draggableId={id} index>
    {(provided, snapshot, _) => {
      <ReactUtil.SpreadProps props={provided.draggableProps}>
        <li
          className={cx([
            %twc("flex flex-row px-4 text-gray-800 py-4 bg-white"),
            draggingStyle(snapshot.isDragging),
          ])}
          ref={provided.innerRef}>
          <img src=image className=%twc("w-12 h-12 mr-3 rounded-full") />
          <div className=%twc("inline-flex flex-col flex-1")>
            {`${displayName}`->React.string}
            <span className=%twc("text-[15px] text-gray-500")>
              {`${representativeWeight->Locale.Float.toLocaleStringF(
                  ~locale="ko-KR",
                  (),
                )}kg`->React.string}
            </span>
          </div>
          <div className=%twc("inline-flex gap-3 text-[#8B8D94] items-center")>
            <ReactUtil.SpreadProps props={provided.dragHandleProps}>
              <div className=%twc("pl-5 pr-2 h-full flex items-center")>
                <img src=hamburgerIcons className=%twc("w-5 h-5") />
              </div>
            </ReactUtil.SpreadProps>
            <button type_="button" onClick={delete} className=%twc("font-medium text-[17px]")>
              {"삭제"->React.string}
            </button>
          </div>
        </li>
      </ReactUtil.SpreadProps>
    }}
  </ReactBeautifulDnD.Draggable>
}
