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

module InterestedProductList = {
  @react.component
  let make = React.memo((
    ~interestedProducts: array<
      MOInterestedProductEditListBuyerFragment_graphql.Types.fragment_likedProducts_edges_node,
    >,
    ~handleOnClickDelete,
  ) => {
    interestedProducts
    ->Array.mapWithIndex((index, {id, displayName, image}) => {
      <MO_InterestedProduct_Edit_Item_Buyer
        key={id}
        index
        id={id}
        displayName={displayName}
        image={image.thumb400x400}
        representativeWeight=0.5
        delete={handleOnClickDelete(id)}
      />
    })
    ->React.array
  })
}

@react.component
let make = (
  ~likedProducts: MOInterestedProductEditListBuyerFragment_graphql.Types.fragment_likedProducts,
) => {
  let (interestedProducts, setInterestedProducts) = React.Uncurried.useState(_ =>
    likedProducts.edges->Array.map(({node}) => node)
  )
  let (showSubmit, setShowSubmit) = React.Uncurried.useState(_ => false)

  let handleOnDragEnd = (result: ReactBeautifulDnD.Responder.dropResult, _) => {
    switch result.destination->Js.Nullable.toOption {
    | None => ()
    | Some(destionation') if destionation'.index == result.source.index => ()
    | Some(destination') => {
        let orderedProducts = reorder(interestedProducts, result.source.index, destination'.index)

        setInterestedProducts(._ => orderedProducts)
        if !showSubmit {
          setShowSubmit(._ => true)
        }
      }
    }
  }

  let handleOnClickDelete = (nodeId, _) => {
    setInterestedProducts(._ => interestedProducts->Array.keep(({id}) => id !== nodeId))

    if !showSubmit {
      setShowSubmit(._ => true)
    }
  }

  <>
    <ReactBeautifulDnD.DragDropContext onDragEnd={handleOnDragEnd}>
      <ReactBeautifulDnD.Droppable droppableId="interestedProductList">
        {(provided, _) => {
          <ReactUtil.SpreadProps props={provided.droppableProps}>
            <ol ref={provided.innerRef} className=%twc("min-h-[calc(100vh-56px)]")>
              <InterestedProductList interestedProducts handleOnClickDelete />
              {provided.placeholder->Option.getWithDefault(React.null)}
            </ol>
          </ReactUtil.SpreadProps>
        }}
      </ReactBeautifulDnD.Droppable>
    </ReactBeautifulDnD.DragDropContext>
    <MO_InterestedProduct_Edit_Button_Buyer show={showSubmit} interestedProducts />
  </>
}
