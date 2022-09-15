@spice
type paymentMethod = [
  | @spice.as("card") #CREDIT_CARD
  | @spice.as("virtual") #VIRTUAL_ACCOUNT
  | @spice.as("transfer") #TRANSFER
]

type cashReceipt = {"type": string}

type tossRequest = {
  amount: int,
  orderId: string,
  orderName: string,
  taxFreeAmount: option<int>,
  customerName: string,
  successUrl: string,
  failUrl: string,
  validHours: option<int>,
  cashReceipt: option<cashReceipt>,
  appScheme: option<string>,
}

@val @scope(("window", "tossPayments"))
external requestTossPayment: (. string, tossRequest) => unit = "requestPayment"

let methodToKCPValue = c =>
  switch c {
  | #CREDIT_CARD => "100000000000"
  | #VIRTUAL_ACCOUNT => "001000000000"
  | #TRANSFER => "001000000000"
  }

let methodToTossValue = c =>
  switch c {
  | #CREDIT_CARD => `카드`
  | #VIRTUAL_ACCOUNT => `가상계좌`
  | #TRANSFER => `계좌이체`
  }

let tossPaymentsValidHours = c =>
  switch c {
  | #VIRTUAL_ACCOUNT => Some(24)
  | _ => None
  }

let tossPaymentsCashReceipt = c =>
  switch c {
  | #VIRTUAL_ACCOUNT => Some({"type": `미발행`})
  | _ => None
  }
