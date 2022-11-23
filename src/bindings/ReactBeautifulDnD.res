type id = string

type draggableId = id
type droppableId = id
type contextId = id
type typeId = id
type elementId = id
type movementMode = [#FLUID | #SNAP]
type draggableLocation = {
  draggableId: draggableId,
  index: int,
}
type draggableRubric = {
  draggableId: draggableId,
  @as("type") type_: typeId,
  source: draggableLocation,
}
type combine = {
  draggableId: draggableId,
  droppableId: droppableId,
}
type position = {
  x: int,
  y: int,
}

module Responder = {
  type beforeCapture = {
    draggableId: draggableId,
    mode: movementMode,
  }

  type dragStart = {
    draggableId: draggableId,
    @as("type") type_: typeId,
    source: draggableLocation,
    mode: movementMode,
  }

  type dragUpdate = {
    draggableId: draggableId,
    @as("type") type_: typeId,
    source: draggableLocation,
    mode: movementMode,
    destination: Js.Nullable.t<draggableLocation>,
    combine: Js.Nullable.t<combine>,
  }

  type dropResult = {
    draggableId: draggableId,
    @as("type") type_: typeId,
    source: draggableLocation,
    mode: movementMode,
    destination: Js.Nullable.t<draggableLocation>,
    combine?: Js.Nullable.t<combine>,
    reason: [#DROP | #CANCEL],
  }

  type provided = {announce: (~message: string) => unit}

  type onBeforeCapture = beforeCapture => unit
  type onBeforeDragStart = dragStart => unit
  type onDragStart = (dragStart, provided) => unit
  type onDragUpdate = (dragUpdate, provided) => unit
  type onDragEnd = (dropResult, provided) => unit
}

module DragDropContext = {
  @module("react-beautiful-dnd") @react.component
  external make: (
    ~children: React.element,
    ~onDragEnd: Responder.onDragEnd,
    ~onBeforeCapture: Responder.onBeforeCapture=?,
    ~onBeforeDragStart: Responder.onBeforeDragStart=?,
    ~onDragStart: Responder.onDragStart=?,
    ~onDragUpdate: Responder.onDragUpdate=?,
    ~dragHandleUsageInstructions: string=?,
    ~nonce: string=?,
  ) => React.element = "DragDropContext"
}

module Droppable = {
  type props = {
    @as("data-rbd-droppable-context-id") contextId: contextId,
    @as("data-rbd-droppable-id") droppableId: droppableId,
  }
  type provided = {
    innerRef: ReactDOM.Ref.t,
    droppableProps: props,
    placeholder?: React.element,
  }

  type stateSnapshot = {
    isDraggingOver: bool,
    draggingOverWith?: draggableId,
    draggingFromThisWith?: draggableId,
    isUsingPlaceholder: bool,
  }

  @module("react-beautiful-dnd") @react.component
  external make: (
    ~children: (provided, stateSnapshot) => React.element,
    ~droppableId: droppableId,
    @as("type") ~type_: typeId=?,
    ~mode: [#standard | #vertical]=?,
    ~isDropDisabled: bool=?,
    ~isCombineEnabled: bool=?,
    ~direction: [#horizontal | #vertical]=?,
    ~ignoreContainerClipping: bool=?,
  ) => React.element = "Droppable"
}

module Draggable = {
  type transitionEvent
  type dragEvent

  type style = {
    position: [#fixed],
    top: int,
    left: int,
    boxSizing: [#"border-box"],
    width: int,
    height: int,
    transition: string,
    transform?: string,
    zIndex: int,
    opacity?: int,
    opsitionEvents: [#none],
  }

  type dropAnimation = {
    duration: int,
    curve: string,
    moveTo: position,
    opacity?: int,
    scale?: int,
  }

  type props = {
    style: style,
    @as("data-rbd-draggable-context-id") contextId: contextId,
    @as("data-rbd-draggable-id") draggableId: draggableId,
    onTransitionEnd?: transitionEvent => unit,
  }

  type dragHandleProps = {
    @as("data-rbd-drag-handle-draggable-id") draggableId: draggableId,
    @as("data-rbd-drag-handle-context-id") contextId: contextId,
    @as("arai-labelledby") ariaLabelledBy: elementId,
    tabIndex: int,
    draggable: bool,
    onDragStart: dragEvent => unit,
  }

  type provided = {
    innerRef: ReactDOM.Ref.t,
    draggableProps: props,
    dragHandleProps: dragHandleProps,
  }

  type stateSnapshot = {
    isDragging: bool,
    isDropAnimating: bool,
    dropAnimation?: dropAnimation,
    draggingOver?: draggableId,
    combineWith?: draggableId,
    combineTargetFor?: draggableId,
    mode?: movementMode,
  }

  @module("react-beautiful-dnd") @react.component
  external make: (
    ~children: (provided, stateSnapshot, draggableRubric) => React.element,
    ~index: int,
    ~draggableId: draggableId,
    ~isDragDisabled: bool=?,
    ~disableInteractiveElementBlocking: bool=?,
    ~shouldRespectForcePress: bool=?,
  ) => React.element = "Draggable"
}
