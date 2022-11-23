module Fragment = %relay(`
  fragment RfqTransactionDetailDialogFragment on RfqWosOrderDepositSchedule {
    id
    buyer {
      id
      name
    }
    factoring {
      id
    }
    details {
      id
      amount
      rfqWosOrderProduct {
        id
        rfqWosOrderProductNo
      }
    }
    depositDueDate
    status
    ...RfqTransactionOrderProductsInputFragment
  }
`)

module Mutation = %relay(`
  mutation RfqTransactionDetailDialogMutation(
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
    <div className={%twc("flex items-center w-full h-[42px] max-h-[42px]")}>
      <div className={%twc("bg-div-shape-L2 pl-3 py-2.5 text-text-L2 w-[100px]")}>
        {title->React.string}
      </div>
      {children}
    </div>
  }
}

module Form = Rfq_Transactions_Admin_Form.Form
module Inputs = Rfq_Transactions_Admin_Form.Inputs

@react.component
let make = (~query, ~children) => {
  let {id, buyer, details, depositDueDate, factoring, status, fragmentRefs} = Fragment.use(query)
  let (mutate, _) = Mutation.use()
  let {addToast} = ReactToastNotifications.useToasts()

  let initialDetails =
    details
    ->Array.keepMap(Garter_Fn.identity)
    ->Array.map(({id, amount, rfqWosOrderProduct: {rfqWosOrderProductNo}}) => (
      id,
      rfqWosOrderProductNo,
      amount,
    ))

  let searchedUser: Rfq_Transactions_Admin_Form.searchedUser = switch buyer {
  | Some(buyer) => #Searched({userId: buyer.id, userName: buyer.name})
  | None => #NoSearch
  }

  let makeOrderProduct: ((string, int, string)) => Rfq_Transactions_Admin_Form.orderProduct = ((
    id,
    productNo,
    amount,
  )) => {
    orderProductNumber: productNo->Int.toString,
    id,
    expectedPaymentAmount: amount,
  }

  let defaultValues: Rfq_Transactions_Admin_Form.fields = {
    paymentDueDate: depositDueDate->Option.mapWithDefault(Js.Date.make(), Js.Date.fromString),
    isFactoring: factoring->Option.isSome ? #Y : #N,
    factoringBank: factoring->Option.mapWithDefault("", f => f.id),
    orderProducts: initialDetails->Array.map(makeOrderProduct),
    depositConfirm: status == #DEPOSIT_COMPLETE,
    searchedUser,
  }

  let disabled = status !== #PENDING

  let form = Form.use(
    ~config={
      defaultValues,
      mode: #onChange,
    },
  )

  let reset = () => form->Form.reset(defaultValues)
  let isFactoring = form->Inputs.IsPactoring.watch

  let fieldArray = form->Inputs.OrderProducts.useFieldArray()
  let orderProducts = form->Inputs.OrderProducts.watch

  let totalExpectedPaymentAmount =
    orderProducts
    ->Array.map(p => p.expectedPaymentAmount)
    ->Array.reduce(0., (total, price) =>
      price->Float.fromString->Option.getWithDefault(0.) +. total
    )

  let orderProductToDetail: Rfq_Transactions_Admin_Form.orderProduct => option<
    RfqTransactionDetailDialogMutation_graphql.Types.updateRfqWosOrderDepositScheduleAmountInput,
  > = o => Some({
    amount: o.expectedPaymentAmount,
    id: Some(o.id),
    orderProductId: None, // TODO: orderProduct의 id를 알아올 수 없음 orderProductNo로 변경 되어야함
  })

  let onSucces = () =>
    addToast(.
      <div className=%twc("flex items-center")>
        <IconCheck height="24" width="24" fill="#12B564" className=%twc("mr-2") />
        {"스케쥴 저장에 성공하였습니다."->React.string}
      </div>,
      {appearance: "success"},
    )

  let onError = message =>
    addToast(.
      <div className=%twc("flex items-center")>
        <IconError height="24" width="24" className=%twc("mr-2") />
        {message->Option.getWithDefault("스케쥴 저장에 실패하였습니다.")->React.string}
      </div>,
      {appearance: "error"},
    )

  let handleOnSubmit = (data: Rfq_Transactions_Admin_Form.fields, _) => {
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
        id: Some(id),
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
                {"결제스케쥴 관리"->React.string}
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
                  <span className=%twc("p-3")>
                    {buyer
                    ->Option.mapWithDefault("자동 조회됩니다", b => b.name)
                    ->React.string}
                  </span>
                </Column>
                <Column title="결제예정일">
                  <Rfq_Transaction_PaymentDueDate_Input form disabled />
                </Column>
              </div>
              <div
                className=%twc(
                  "w-full flex items-center flex-auto text-[13px] border border-x-0 border-div-border-L2"
                )>
                <Column title="총결제예정금액">
                  <span className=%twc("p-3")>
                    {totalExpectedPaymentAmount->Locale.Float.show(~digits=3)->React.string}
                  </span>
                </Column>
                <Column title="팩토링여부">
                  <div className=%twc("p-3 flex items-center gap-2")>
                    <Rfq_Transaction_IsFactoring_Input form disabled />
                    {switch isFactoring == #Y {
                    | true =>
                      <React.Suspense fallback={<Rfq_Transaction_FactoringBank_Input.Skeleton />}>
                        <Rfq_Transaction_FactoringBank_Input form disabled />
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
                <Rfq_Transaction_OrderProducts_Input.InputArrayWithQuery
                  form fieldArray query=fragmentRefs disabled
                />
              </div>
            </div>
            <div className=%twc("mt-7 w-full flex items-center justify-between ")>
              <Rfq_Transaction_DepositConfirm_Input form disabled />
              {switch disabled {
              | true =>
                <button
                  disabled className=%twc("py-1.5 px-3 rounded-[10px] bg-gray-200 text-inverted")>
                  {"저장"->React.string}
                </button>
              | false =>
                <button
                  className=%twc(
                    "py-1.5 px-3 rounded-[10px] bg-primary text-inverted interactable"
                  )>
                  {"저장"->React.string}
                </button>
              }}
            </div>
          </div>
        </form>
      </Content>
    </Portal>
  </Root>
}
