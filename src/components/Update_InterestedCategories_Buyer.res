open RadixUI

@react.component
let make = (~isOpen, ~onClose) => {
  let queryData = BuyerInformation_Buyer.Query.use(~variables=(), ())

  <Dialog.Root _open={isOpen}>
    <Dialog.Overlay className=%twc("dialog-overlay") />
    <Dialog.Content className=%twc("dialog-content-full overflow-y-auto sm:rounded-2xl")>
      <section className=%twc("text-text-L1")>
        <article className=%twc("flex")>
          <Dialog.Close
            className=%twc("p-2 m-3 mb-0 focus:outline-none ml-auto") onClick={_ => onClose()}>
            <IconClose height="24" width="24" fill="#262626" />
          </Dialog.Close>
        </article>
        <BuyerInformation_Buyer.InterestedCategories
          selected={queryData.viewer->Option.flatMap(v => v.interestedItemCategories)}
          close={onClose}
        />
      </section>
    </Dialog.Content>
  </Dialog.Root>
}
