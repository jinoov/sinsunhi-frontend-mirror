module FormFields = %lenses(
  type state = {
    producerName: string,
    productName: string,
    std: string,
    productNos: string,
    skuNos: string,
  }
)

module Form = ReForm.Make(FormFields)

let initialState: FormFields.state = {
  producerName: "",
  productName: "",
  std: "Crop",
  productNos: "",
  skuNos: "",
}
