//mutation 추가 예정
let reorder = (arr, startIndex, endIndex) => {
  let removed = arr->Array.slice(~offset=startIndex, ~len=1)->Garter.Array.first

  let removedList = Array.concat(
    arr->Array.slice(~offset=0, ~len=startIndex),
    arr->Array.sliceToEnd(startIndex + 1),
  )

  removed->Option.mapWithDefault(arr, removed' => {
    Array.concatMany([
      removedList->Array.slice(~offset=0, ~len=endIndex),
      [removed'],
      removedList->Array.sliceToEnd(endIndex),
    ])
  })
}

@react.component
let make = (
  ~interestedProducts: array<
    PCInterestedProductEditListBuyerFragment_graphql.Types.fragment_likedProducts_edges_node,
  >,
  ~setInterestedProducts,
) => {
  let handleOnDragEnd = (result: ReactBeautifulDnD.Responder.dropResult, _) => {
    switch result.destination->Js.Nullable.toOption {
    | None => ()
    | Some(destionation') if destionation'.index == result.source.index => ()
    | Some(destination') => {
        let orderedProducts = reorder(interestedProducts, result.source.index, destination'.index)

        setInterestedProducts(._ => orderedProducts)
      }
    }
  }

  let handleOnClickDelete = (nodeId, _) => {
    setInterestedProducts(._ => interestedProducts->Array.keep(({id}) => id !== nodeId))
  }

  <>
    <ReactBeautifulDnD.DragDropContext onDragEnd={handleOnDragEnd}>
      <ReactBeautifulDnD.Droppable droppableId="interestedProductList">
        {(provided, _) => {
          <ReactUtil.SpreadProps props={provided.droppableProps}>
            <ol ref={provided.innerRef}>
              {interestedProducts
              ->Array.mapWithIndex((index, {id, displayName, image}) => {
                <PC_InterestedProduct_Edit_Item_Buyer
                  key={id}
                  index
                  id={id}
                  displayName={displayName}
                  image={image.thumb400x400}
                  representativeWeight=0.5
                  delete={handleOnClickDelete(id)}
                />
              })
              ->React.array}
              {provided.placeholder->Option.getWithDefault(React.null)}
            </ol>
          </ReactUtil.SpreadProps>
        }}
      </ReactBeautifulDnD.Droppable>
    </ReactBeautifulDnD.DragDropContext>
  </>
}
