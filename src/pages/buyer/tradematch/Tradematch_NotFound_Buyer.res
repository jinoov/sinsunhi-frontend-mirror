@react.component
let make = () => {
  <DS_Dialog.Popup.Root _open=true>
    <DS_Dialog.Popup.Portal>
      <DS_Dialog.Popup.Overlay />
      <DS_Dialog.Popup.Content>
        <DS_Dialog.Popup.Title>
          {`상품 정보를 찾을 수 없습니다.`->React.string}
        </DS_Dialog.Popup.Title>
        <DS_Dialog.Popup.Description>
          {`해당 상품을 찾을 수 없습니다.`->React.string}
        </DS_Dialog.Popup.Description>
        <DS_Dialog.Popup.Buttons>
          <DS_Dialog.Popup.Close asChild=true>
            <DS_Button.Normal.Large1 label={`돌아가기`} onClick={_ => History.back()} />
          </DS_Dialog.Popup.Close>
        </DS_Dialog.Popup.Buttons>
      </DS_Dialog.Popup.Content>
    </DS_Dialog.Popup.Portal>
  </DS_Dialog.Popup.Root>
}
