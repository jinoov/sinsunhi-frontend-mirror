open HookForm

@spice
type isFactoring = [
  | @spice.as("Y") #Y
  | @spice.as("N") #N
  | @spice.as("전체") #NOT_SELECTED
] // 추후 Y, N 값이 아니라 다른 값들도 추가된다고 해서 bool type이 아닌 폴리모픽 배리언트로 설정했습니다.

type user = {
  userId: string,
  userName: string,
}
type searchedUser = [
  | #NoSearch
  | #Searched(user)
]

type orderProduct = {
  @as("order-product-number") orderProductNumber: string,
  id: string,
  @as("expected-payment-amount") expectedPaymentAmount: string,
}

type fields = {
  @as("searched-user") searchedUser: searchedUser,
  @as("payment-due-date") paymentDueDate: Js.Date.t,
  @as("is-factoring") isFactoring: isFactoring,
  @as("factoring-bank") factoringBank: string,
  @as("order-products") orderProducts: array<orderProduct>,
  @as("deposit-confirm") depositConfirm: bool,
}

let initial = {
  searchedUser: #NoSearch,
  paymentDueDate: Js.Date.make(),
  isFactoring: #NOT_SELECTED,
  factoringBank: "",
  orderProducts: [],
  depositConfirm: false,
}

module Form = HookForm.Make({
  type t = fields
})

// TODO: 벨리데이터 작성
module Inputs = {
  module Buyer = Form.MakeInput({
    type t = searchedUser
    let name = "searched-user"
    let config = Rules.makeWithErrorMessage({
      required: {value: true, message: "바이어 검색을 해주세요."},
      pattern: {
        value: %re("/^((?!NoSearch).)*$/"),
        message: "바이어 검색을 해주세요.",
      },
    })
  })
  module OrderProducts = Form.MakeInputArray({
    type t = orderProduct
    let name = "order-products"
    let config = Rules.makeWithErrorMessage({
      required: {value: true, message: "바이어 검색을 해주세요"},
      pattern: {value: %re("/^[0-9]*$/"), message: "숫자만 입력해주세요"},
    })
  })

  module DepositConfirm = Form.MakeInput({
    type t = bool
    let name = "deposit-confirm"
    let config = Rules.empty()
  })
  module PaymentDueDate = Form.MakeInput({
    type t = Js.Date.t
    let name = "payment-due-date"
    let config = Rules.makeWithErrorMessage({
      required: {value: true, message: "결제예정일을 입력해주세요."},
    })
  })
  module IsPactoring = Form.MakeInput({
    type t = isFactoring
    let name = "is-factoring"
    let config = HookForm.Rules.makeWithErrorMessage({
      required: {value: true, message: "팩토링 여부를 입력해주세요."},
      pattern: {
        value: %re("/^((?!NOT_SELECTED).)*$/"),
        message: "팩토링 여부를 입력해주세요.",
      },
    })
  })
  module FactoringBank = Form.MakeInput({
    type t = string
    let name = "factoring-bank"
    let config = HookForm.Rules.makeWithErrorMessage({
      required: {value: true, message: "팩토링 은행을 입력해주세요."},
    })
  })
}
