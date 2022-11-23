module Fragment = %relay(`
  fragment RfqTransactionAdminFragment on RfqWosOrderDepositSchedule {
    id
    buyer {
      name
    }
    createdAt
    depositDueDate
    depositType
    status
    details {
      amount
    }
    ...RfqTransactionDetailDialogFragment
  }
`)

module Mutation = %relay(`
  mutation RfqTransactionAdminMutation($id: ID!) {
    cancelRfqWosOrderDepositSchedule(input: { id: $id }) {
      ... on RfqWosOrderDepositSchedule {
        id
      }
      ... on Error {
        code
        message
      }
    }
  }
`)

module CancelDialog = {
  @react.component
  let make = (~scheduleId) => {
    let (mutate, _) = Mutation.use()
    let {addToast} = ReactToastNotifications.useToasts()
    let onClick = _ => {
      mutate(
        ~variables={
          id: scheduleId,
        },
        ~onCompleted=({cancelRfqWosOrderDepositSchedule}, _) => {
          switch cancelRfqWosOrderDepositSchedule {
          | Some(#RfqWosOrderDepositSchedule(_)) =>
            addToast(.
              <div className=%twc("flex items-center")>
                <IconCheck height="24" width="24" fill="#12B564" className=%twc("mr-2") />
                {"스케쥴 취소에 성공하였습니다."->React.string}
              </div>,
              {appearance: "success"},
            )
          | Some(#Error({message})) => {
              Js.log(message)
              addToast(.
                <div className=%twc("flex items-center")>
                  <IconError height="24" width="24" className=%twc("mr-2") />
                  {message
                  ->Option.getWithDefault("스케쥴 취소에 실패하였습니다.")
                  ->React.string}
                </div>,
                {appearance: "error"},
              )
            }

          | _ =>
            addToast(.
              <div className=%twc("flex items-center")>
                <IconError height="24" width="24" className=%twc("mr-2") />
                {"스케쥴 취소에 실패하였습니다."->React.string}
              </div>,
              {appearance: "error"},
            )
          }
        },
        (),
      )->ignore
    }

    <RadixUI.Dialog.Root key=scheduleId>
      <RadixUI.Dialog.Trigger>
        <Formula.Icon.TrashLineRegular />
      </RadixUI.Dialog.Trigger>
      <RadixUI.Dialog.Portal>
        <RadixUI.Dialog.Overlay className=%twc("dialog-overlay") />
        <RadixUI.Dialog.Content
          className=%twc("dialog-content p-7 rounded-2xl")
          onOpenAutoFocus={ReactEvent.Synthetic.preventDefault}>
          <div className=%twc("p-8 text-center min-w-fit")>
            {"스케쥴을 취소 하시겠어요?"->React.string}
          </div>
          <div className=%twc("flex items-center justify-center gap-2")>
            <RadixUI.Dialog.Close
              className=%twc("w-full py-3 bg-enabled-L5 rounded-xl interactable")>
              {"닫기"->React.string}
            </RadixUI.Dialog.Close>
            <button
              type_="button"
              className=%twc("w-full py-3 bg-red-100 text-notice font-bold rounded-xl interactable")
              onClick>
              {"취소하기"->React.string}
            </button>
          </div>
        </RadixUI.Dialog.Content>
      </RadixUI.Dialog.Portal>
    </RadixUI.Dialog.Root>
  }
}

module Badge = {
  @react.component
  let make = (
    ~status: RfqTransactionAdminFragment_graphql.Types.enum_RfqWosDepositScheduleStatus,
  ) => {
    let (className, label) = switch status {
    | #DEPOSIT_COMPLETE => (%twc("text-primary bg-primary-light-variant"), "입금완료")
    | #CANCEL => (%twc("text-[#ED394B] bg-[#FCF4F4]"), "스케쥴 취소")
    | _ => (%twc("text-[#65666B] bg-[#F7F8FA]"), "입금전")
    }

    <div
      className={cx([
        %twc("h-6 max-w-fit px-2 flex items-center justify-center rounded-lg"),
        className,
      ])}>
      {label->React.string}
    </div>
  }
}

let formatDate = d => d->Js.Date.fromString->DateFns.format("yyyy/MM/dd")

@react.component
let make = (~query) => {
  let {id, depositDueDate, details, status, buyer, fragmentRefs} = Fragment.use(query)
  let amount =
    details
    ->Array.keepMap(Garter_Fn.identity)
    ->Array.keepMap(d => d.amount->Float.fromString)
    ->Garter.Math.sum_float

  <>
    <li className=%twc("grid grid-cols-6-admin-rfq-transaction text-gray-700")>
      <div className=%twc("h-full flex flex-col px-4 py-2")>
        <span className=%twc("block")>
          {buyer->Option.mapWithDefault("-", b => b.name)->React.string}
        </span>
      </div>
      <div className=%twc("px-4 py-2")>
        {depositDueDate->Option.mapWithDefault("-", formatDate)->React.string}
      </div>
      <div className=%twc("px-4 py-2")> {amount->Locale.Float.show(~digits=3)->React.string} </div>
      <div className=%twc("px-4 py-2")>
        <Rfq_Transaction_Detail_Dialog query=fragmentRefs>
          <div
            className=%twc(
              "h-6 px-2 flex items-center justify-center rounded-lg bg-[#F2F2F2] interactable"
            )>
            {"스케쥴 관리"->React.string}
          </div>
        </Rfq_Transaction_Detail_Dialog>
      </div>
      <div className=%twc("px-4 py-2")>
        <Badge status />
      </div>
      <div className=%twc("px-4 py-2 text-right")>
        {switch status {
        | #PENDING => <CancelDialog scheduleId=id />
        | _ => "-"->React.string
        }}
      </div>
    </li>
  </>
}
