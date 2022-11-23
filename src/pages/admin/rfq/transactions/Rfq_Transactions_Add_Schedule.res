module Mutation = %relay(`
  mutation RfqTransactionsAddScheduleMutation(
    $buyer: ID
    $depositDueDate: DateTime
    $details: [UpdateRfqWosOrderDepositScheduleAmountInput]!
    $factoring: ID
    $id: ID
    $status: RfqWosDepositScheduleStatus
  ) {
    updateRfqWosOrderDepositScheduleIntegrated(
      input: {
        buyer: $buyer
        depositDueDate: $depositDueDate
        details: $details
        factoring: $factoring
        id: $id
        status: $status
      }
    ) {
      ... on RfqWosOrderDepositSchedule {
        ...RfqTransactionAdminFragment
      }
      ... on Error {
        message
      }
    }
  }
`)
module Column = {
  type size = Small | Large

  @react.component
  let make = (~title, ~children) => {
    <div className={%twc("flex items-center w-full h-[42px]")}>
      <div className={%twc("bg-div-shape-L2 pl-3 py-2.5 text-text-L2 w-[100px]")}>
        {title->React.string}
      </div>
      {children}
    </div>
  }
}

open Rfq_Transactions_Admin_Form

module Form = Rfq_Transactions_Admin_Form.Form
module Inputs = Rfq_Transactions_Admin_Form.Inputs

@react.component
let make = (~children) => {
  let (mutate, _) = Mutation.use()
  let {addToast} = ReactToastNotifications.useToasts()
  let form = Form.use(
    ~config={
      defaultValues: initial,
      mode: #onChange,
    },
  )
  let reset = () => form->Form.reset(initial)

  let isFactoring = form->Inputs.IsPactoring.watch

  let fieldArray = form->Inputs.OrderProducts.useFieldArray()
  let fields = fieldArray->Inputs.OrderProducts.fields
  let fieldArrayValues = form->Inputs.OrderProducts.watch

  let totalExpectedPaymentAmount =
    fieldArrayValues
    ->Array.keepMap(field => field.expectedPaymentAmount->Float.fromString)
    ->Garter_Math.sum_float

  let appendOrderProduct = _ =>
    fieldArray->Inputs.OrderProducts.append({
      orderProductNumber: "",
      id: "",
      expectedPaymentAmount: "",
    })

  let close = () => {
    open Webapi
    let buttonClose = Dom.document->Dom.Document.getElementById("btn-close")
    buttonClose
    ->Option.flatMap(buttonClose' => {
      buttonClose'->Dom.Element.asHtmlElement
    })
    ->Option.forEach(buttonClose' => {
      buttonClose'->Dom.HtmlElement.click
    })
  }

  let onSucces = () => {
    addToast(.
      <div className=%twc("flex items-center")>
        <IconCheck height="24" width="24" fill="#12B564" className=%twc("mr-2") />
        {"스케쥴 추가에 성공하였습니다."->React.string}
      </div>,
      {appearance: "success"},
    )
    close()
  }

  let onError = message =>
    addToast(.
      <div className=%twc("flex items-center")>
        <IconError height="24" width="24" className=%twc("mr-2") />
        {message->Option.getWithDefault("스케쥴 추가에 실패하였습니다.")->React.string}
      </div>,
      {appearance: "error"},
    )

  let orderProductToDetail: Rfq_Transactions_Admin_Form.orderProduct => option<
    RfqTransactionsAddScheduleMutation_graphql.Types.updateRfqWosOrderDepositScheduleAmountInput,
  > = o => Some({
    amount: o.expectedPaymentAmount,
    id: Some(o.id),
    orderProductId: o.orderProductNumber->Int.fromString,
  })

  let handleOnSubmit = (data: fields, _) => {
    Js.log(data)
    mutate(
      ~variables={
        buyer: switch data.searchedUser {
        | #Searched({userId}) => Some(userId)
        | #NoSearch => None
        },
        depositDueDate: Some(data.paymentDueDate->DateFns.startOfDay->Js.Date.toISOString),
        details: data.orderProducts->Array.map(orderProductToDetail),
        factoring: switch data.isFactoring {
        | #Y => Some(data.factoringBank)
        | _ => None
        },
        id: None,
        status: data.depositConfirm ? Some(#DEPOSIT_COMPLETE) : None,
      },
      ~onCompleted={
        ({updateRfqWosOrderDepositScheduleIntegrated}, _) =>
          switch updateRfqWosOrderDepositScheduleIntegrated {
          | Some(#RfqWosOrderDepositSchedule(_)) => onSucces()
          | Some(#Error({message})) => {
              message->Js.log
              message->onError
            }

          | _ => onError(None)
          }
      },
      ~onError={
        err => {
          Js.log(err)
          onError(Some(err.message))
        }
      },
      (),
    )->ignore
  }

  open RadixUI.Dialog
  <Root onOpenChange={_ => reset()}>
    <Trigger> children </Trigger>
    <Portal>
      <Overlay className=%twc("dialog-overlay") />
      <Content
        className=%twc("w-3/4 dialog-content-nosize max-w-fit")
        onOpenAutoFocus={ReactEvent.Synthetic.preventDefault}>
        <form onSubmit={form->Form.handleSubmit(handleOnSubmit)}>
          <div className=%twc("p-5 text-sm overflow-y-scroll min-h-[700px]")>
            <div className=%twc("flex items-center justify-between")>
              <h2 className=%twc("text-xl font-bold")>
                {"결제스케쥴 추가"->React.string}
              </h2>
              <Close className=%twc("inline-block p-1 focus:outline-none ml-auto")>
                <IconClose height="24" width="24" fill="#262626" />
              </Close>
            </div>
            <div>
              <h3 className=%twc("mt-4 mb-2.5 text-text-L1 font-bold")>
                {"스케쥴 정보"->React.string}
              </h3>
              <div
                className=%twc(
                  "w-full flex items-center flex-auto text-[13px] border border-b-0 border-x-0 border-div-border-L2"
                )>
                <Column title="바이어">
                  <Rfq_Transaction_Buyer_Input form />
                </Column>
                <Column title="결제예정일">
                  <Rfq_Transaction_PaymentDueDate_Input form />
                </Column>
              </div>
              <div
                className=%twc(
                  "w-full flex items-center flex-auto text-[13px] border border-x-0 border-div-border-L2"
                )>
                <Column title="총결제예정금액">
                  {switch totalExpectedPaymentAmount {
                  | 0. =>
                    <span className=%twc("p-3 text-[#8B8D94]")>
                      {"자동 조회됩니다"->React.string}
                    </span>
                  | amount =>
                    <span className=%twc("p-3")>
                      {amount->Locale.Float.show(~digits=3)->React.string}
                    </span>
                  }}
                </Column>
                <Column title="팩토링여부">
                  <div className=%twc("p-3 flex items-center gap-2")>
                    <Rfq_Transaction_IsFactoring_Input form />
                    {switch isFactoring == #Y {
                    | true =>
                      <React.Suspense fallback={<Rfq_Transaction_FactoringBank_Input.Skeleton />}>
                        <Rfq_Transaction_FactoringBank_Input form />
                      </React.Suspense>
                    | false => React.null
                    }}
                  </div>
                </Column>
              </div>
            </div>
            //
            <div className=%twc("mt-10")>
              <div className=%twc("mb-2.5 flex items-center justify-between")>
                <h3 className=%twc("text-text-L1 font-bold")>
                  {"주문상품 목록"->React.string}
                </h3>
                <button
                  type_="button"
                  onClick={_ => appendOrderProduct()}
                  className=%twc("py-[5px] px-3 border border-primary rounded-lg")>
                  <span className=%twc("text-primary text-sm")>
                    {"+ 주문상품 추가"->React.string}
                  </span>
                </button>
              </div>
            </div>
            <div className=%twc("w-full overflow-x-scroll")>
              <div className=%twc("min-w-max max-w-full text-sm divide-y divide-gray-100")>
                <div
                  className=%twc(
                    "grid grid-cods-8-admin-rfq-factoring px-2 py-3 bg-gray-50 text-[#8B8D94]"
                  )>
                  <span> {"주문상품번호"->React.string} </span>
                  <span> {"원주문금액"->React.string} </span>
                  <span> {"납품확정금액"->React.string} </span>
                  <span> {"누적결제금액"->React.string} </span>
                  <span> {"배송비"->React.string} </span>
                  <span> {"결제예정금액"->React.string} </span>
                  <span> {"잔여금액"->React.string} </span>
                </div>
                {switch fields->Garter.Array.isEmpty {
                | true =>
                  <div
                    className=%twc(
                      "flex items-center justify-center w-4/5 h-96 text-[#8B8D94] text-sm"
                    )>
                    {"주문상품을 추가해주세요"->React.string}
                  </div>
                | false => <Rfq_Transaction_OrderProducts_Input.InputArray form fieldArray />
                }}
              </div>
            </div>
            <div className=%twc("mt-7 w-full flex items-center justify-between ")>
              <Close>
                <button
                  id="btn-close"
                  type_="button"
                  className=%twc("py-1.5 px-3 rounded-[10px] bg-div-shape-L1 interactable")>
                  {"닫기"->React.string}
                </button>
              </Close>
              <button
                className=%twc("py-1.5 px-3 rounded-[10px] bg-primary text-inverted interactable")>
                {"저장"->React.string}
              </button>
            </div>
          </div>
        </form>
      </Content>
    </Portal>
  </Root>
}
