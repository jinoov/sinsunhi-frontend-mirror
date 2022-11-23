module Mutation = %relay(`
  mutation DeleteRfqProductButtonAdminMutation($id: ID!, $connections: [ID!]!) {
    deleteRfqProduct(id: $id) {
      ... on DeleteRfqProductResult {
        deletedRfqProductId @deleteEdge(connections: $connections)
      }
  
      ... on Error {
        code
        message
      }
    }
  }
`)

module Toast = {
  type appearance =
    | Success
    | Failure

  let use = () => {
    let {addToast} = ReactToastNotifications.useToasts()

    (message, appearance) => {
      switch appearance {
      | Success =>
        addToast(.
          <div className=%twc("flex items-center")>
            <IconCheck height="24" width="24" fill="#12B564" className=%twc("mr-2") />
            {message->React.string}
          </div>,
          {appearance: "success"},
        )

      | Failure =>
        addToast(.
          <div className=%twc("flex items-center")>
            <IconError height="24" width="24" className=%twc("mr-2") />
            {message->React.string}
          </div>,
          {appearance: "error"},
        )
      }
    }
  }
}

module Modal = {
  @react.component
  let make = (~isVisible, ~setIsVisible, ~children) => {
    let closeModal = _ => setIsVisible(._ => false)
    <RadixUI.Dialog.Root _open={isVisible}>
      <RadixUI.Dialog.Portal>
        <RadixUI.Dialog.Overlay className=%twc("dialog-overlay") />
        <RadixUI.Dialog.Content
          className=%twc("dialog-content-base bg-white w-[320px] pt-8 pb-5 px-5 rounded-lg")
          onPointerDownOutside={closeModal}>
          children
        </RadixUI.Dialog.Content>
      </RadixUI.Dialog.Portal>
    </RadixUI.Dialog.Root>
  }
}

@react.component
let make = (~isDeletable, ~targetId, ~connectionId) => {
  let showToast = Toast.use()

  let (deleteRfqProduct, isDeleting) = Mutation.use()
  let (isModalVisible, setIsModalVisible) = React.Uncurried.useState(_ => false)

  let openConfirm = _ => setIsModalVisible(._ => true)
  let closeConfirm = _ => setIsModalVisible(._ => false)

  let delete = _ => {
    closeConfirm()
    deleteRfqProduct(
      ~variables=Mutation.makeVariables(
        ~id=targetId,
        ~connections=[connectionId->RescriptRelay.makeDataId],
      ),
      ~onCompleted={
        ({deleteRfqProduct}, _) => {
          switch deleteRfqProduct {
          | Some(#DeleteRfqProductResult(_)) =>
            `견적상품이 삭제되었습니다.`->showToast(Success)

          | _ => `견적상품 삭제에 실패하였습니다.`->showToast(Failure)
          }
        }
      },
      ~onError={
        _ => `견적상품 삭제에 실패하였습니다.`->showToast(Failure)
      },
      (),
    )->ignore
  }

  <>
    {switch (isDeletable, isDeleting) {
    | (true, false) =>
      <button type_="button" onClick={openConfirm}>
        <IconTrash width="24" height="24" fill="#262626" />
      </button>

    | _ =>
      <button type_="button" disabled=true>
        <IconTrash fill="#e5e5e5" />
      </button>
    }}
    <Modal isVisible=isModalVisible setIsVisible=setIsModalVisible>
      <div className=%twc("flex flex-col items-center justify-center")>
        <span> {`견적서에서`->React.string} </span>
        <span> {`견적상품을 삭제하시겠어요?`->React.string} </span>
        <div className=%twc("mt-4 w-full grid grid-cols-2 gap-x-2")>
          <button
            onClick={closeConfirm}
            type_="button"
            className=%twc("w-full h-13 flex items-center justify-center rounded-lg bg-gray-100")>
            {`취소`->React.string}
          </button>
          <button
            onClick={delete}
            type_="button"
            className=%twc(
              "w-full h-13 flex items-center justify-center rounded-lg bg-red-100 text-red-500 font-bold"
            )>
            {`삭제`->React.string}
          </button>
        </div>
      </div>
    </Modal>
  </>
}
