module FormFields = Query_Product_Form_Admin.FormFields
module Form = Query_Product_Form_Admin.Form
module Select = Select_Product_Option_Status
module Select_Crop_Std = Select_Crop_Search_Std

let set = (old, k, v) => {
  let new = old
  new->Js.Dict.set(k, v)
  new
}

@react.component
let make = () => {
  let router = Next.Router.useRouter()

  let (status, setStatus) = React.Uncurried.useState(_ => Select.parseStatus(router.query))
  let (selectedCrop, setSelectedCrop) = React.Uncurried.useState(_ => ReactSelect.NotSelected)

  let handleOnChageStatus = e => {
    let newStatus = (e->ReactEvent.Synthetic.target)["value"]
    setStatus(._ => newStatus->Select.decodeStatus->Option.getWithDefault(ALL))
  }

  let onSubmit = ({state}: Form.onSubmitAPI) => {
    let producerName = state.values->FormFields.get(FormFields.ProducerName)
    let productName = state.values->FormFields.get(FormFields.ProductName)
    let std = state.values->FormFields.get(FormFields.Std)
    let productNos =
      state.values
      ->FormFields.get(FormFields.ProductNos)
      ->Js.String2.replaceByRe(%re("/ /g"), "")
      ->Js.Global.encodeURIComponent
    let skuNos =
      state.values
      ->FormFields.get(FormFields.SkuNos)
      ->Js.String2.replaceByRe(%re("/ /g"), "")
      ->Js.Global.encodeURIComponent

    let (categoryId, label) =
      selectedCrop->ReactSelect.toOption->Option.mapWithDefault(("", ""), v => (v.value, v.label))

    let {makeWithDict, toString} = module(Webapi.Url.URLSearchParams)
    let newQueryString =
      router.query
      ->set("producer-name", producerName)
      ->set("product-name", productName)
      ->set("status", status->Select.encodeStatus)
      ->set("crop-search-std", std)
      ->set("category-id", categoryId)
      ->set("label", label)
      ->set("product-nos", productNos)
      ->set("sku-nos", skuNos)
      ->set("offset", "0") //offset 초기화
      ->makeWithDict
      ->toString

    router->Next.Router.push(`${router.pathname}?${newQueryString}`)
    None
  }

  let form: Form.api = Form.use(
    ~validationStrategy=Form.OnChange,
    ~onSubmit,
    ~initialState=Query_Product_Form_Admin.initialState,
    ~schema={
      open Form.Validation
      Schema(
        [
          regExp(
            ProductNos,
            ~matches="^([0-9]| |,){0,}$",
            ~error=`숫자(","로 구분 가능)만 입력해주세요`,
          ),
          regExp(
            SkuNos,
            ~matches="^([0-9]| |,){0,}$",
            ~error=`숫자(","로 구분 가능)만 입력해주세요`,
          ),
        ]->Array.concatMany,
      )
    },
    (),
  )

  let handleOnChangeCropOrCultivar = e => {
    FormFields.Std->form.handleChange->ReForm.Helpers.handleChange(e)
    setSelectedCrop(._ => ReactSelect.NotSelected)
  }

  React.useEffect1(_ => {
    form.resetForm()

    router.query
    ->Js.Dict.entries
    ->Garter.Array.forEach(entry => {
      let (k, v) = entry
      switch k {
      | "producer-name" => FormFields.ProducerName->form.setFieldValue(v, ~shouldValidate=false, ())

      | "product-name" => FormFields.ProductName->form.setFieldValue(v, ~shouldValidate=false, ())

      | "status" => setStatus(. _ => v->Select.decodeStatus->Option.getWithDefault(ALL))

      | "crop-search-std" => FormFields.Std->form.setFieldValue(v, ~shouldValidate=false, ())

      | "product-nos" =>
        FormFields.ProductNos->form.setFieldValue(
          v->Js.Global.decodeURIComponent->Js.String2.split(",")->Js.Array2.joinWith(", "),
          ~shouldValidate=false,
          (),
        )

      | "sku-nos" =>
        FormFields.SkuNos->form.setFieldValue(
          v->Js.Global.decodeURIComponent->Js.String2.split(",")->Js.Array2.joinWith(", "),
          ~shouldValidate=false,
          (),
        )

      | _ => ()
      }
    })

    Helper.Option.map2(router.query->Js.Dict.get("crop"), router.query->Js.Dict.get("label"), (
      value,
      label,
    ) => {
      if value !== "" && label !== "" {
        setSelectedCrop(. _ => ReactSelect.Selected({value, label}))
      }
    })->ignore

    None
  }, [router.query])

  let handleOnReset = ReactEvents.interceptingHandler(_ => {
    FormFields.ProducerName->form.setFieldValue("", ~shouldValidate=false, ())
    FormFields.ProductName->form.setFieldValue("", ~shouldValidate=false, ())
    FormFields.Std->form.setFieldValue("Crop", ~shouldValidate=false, ())
    setStatus(._ => ALL)
    setSelectedCrop(._ => ReactSelect.NotSelected)
    FormFields.ProductNos->form.setFieldValue("", ~shouldValidate=false, ())
    FormFields.SkuNos->form.setFieldValue("", ~shouldValidate=false, ())
  })

  let handleChangeCrop = selection => {
    setSelectedCrop(._ => selection)
  }

  <div className=%twc("p-7 mt-4 mx-4 bg-white rounded shadow-gl")>
    <form onSubmit={ReactEvents.interceptingHandler(_ => form.submit())}>
      <div className=%twc("py-3 flex flex-col text-sm bg-gray-gl rounded-xl")>
        <div className=%twc("flex")>
          <div className=%twc("w-32 font-bold mt-2 pl-7 whitespace-nowrap")>
            {j`검색`->React.string}
          </div>
          <div className=%twc("flex-1")>
            <div className=%twc("flex")>
              <div
                className=%twc(
                  "flex-1 flex flex-col sm:flex-initial sm:w-64 sm:flex-row sm:items-center mr-16"
                )>
                <label htmlFor="producer-name" className=%twc("whitespace-nowrap mr-2")>
                  {j`생산자명`->React.string}
                </label>
                <Input
                  type_="text"
                  name="producer-name"
                  placeholder={`생산자명 입력`}
                  value={form.values->FormFields.get(FormFields.ProducerName)}
                  onChange={FormFields.ProducerName->form.handleChange->ReForm.Helpers.handleChange}
                  error={FormFields.ProducerName->Form.ReSchema.Field->form.getFieldError}
                  tabIndex=1
                />
              </div>
              <div className=%twc("min-w-1/2 flex items-center")>
                <label htmlFor="product-name" className=%twc("whitespace-nowrap mr-2")>
                  {j`상품명`->React.string}
                </label>
                <span className=%twc("flex-1")>
                  <Input
                    type_="text"
                    name="product-name"
                    placeholder={`상품명 입력`}
                    value={form.values->FormFields.get(FormFields.ProductName)}
                    onChange={FormFields.ProductName
                    ->form.handleChange
                    ->ReForm.Helpers.handleChange}
                    error={FormFields.ProductName->Form.ReSchema.Field->form.getFieldError}
                    tabIndex=2
                  />
                </span>
              </div>
            </div>
            <div className=%twc("flex mt-3")>
              <div className=%twc("w-64 flex items-center")>
                <label htmlFor="crop-kind" className=%twc("whitespace-nowrap mr-2")>
                  {j`작물품종`->React.string}
                </label>
                <Select_Crop_Std
                  std={form.values
                  ->FormFields.get(FormFields.Std)
                  ->Select_Crop_Std.decodeStd
                  ->Option.getWithDefault(#Crop)}
                  onChange=handleOnChangeCropOrCultivar
                />
              </div>
              <div className=%twc("relative")>
                <div className=%twc("absolute w-96")>
                  <Search_Crop_Cultivar
                    type_={form.values
                    ->FormFields.get(FormFields.Std)
                    ->Select_Crop_Search_Std.decodeStd
                    ->Option.getWithDefault(#Crop)}
                    value=selectedCrop
                    onChange=handleChangeCrop
                  />
                </div>
              </div>
            </div>
            <div className=%twc("flex mt-3")>
              <div className=%twc("w-64 flex items-center mr-16")>
                <label htmlFor="product-status" className=%twc("whitespace-nowrap mr-2")>
                  {j`판매상태`->React.string}
                </label>
                <Select_Product_Option_Status status onChange=handleOnChageStatus />
              </div>
            </div>
            <div className=%twc("flex")>
              <div className=%twc("flex mt-3")>
                <div className=%twc("w-64 flex items-center mr-16")>
                  <label htmlFor="product-nos" className=%twc("whitespace-nowrap mr-2")>
                    {j`상품번호`->React.string}
                  </label>
                  <Input
                    type_="text"
                    name="product-nos"
                    placeholder={`상품번호 입력 (","로 구분 가능)`}
                    value={form.values->FormFields.get(FormFields.ProductNos)}
                    onChange={FormFields.ProductNos->form.handleChange->ReForm.Helpers.handleChange}
                    error={FormFields.ProductNos->Form.ReSchema.Field->form.getFieldError}
                    tabIndex=3
                  />
                </div>
              </div>
              <div className=%twc("flex mt-3")>
                <div className=%twc("w-64 flex items-center mr-16")>
                  <label htmlFor="sku-nos" className=%twc("whitespace-nowrap mr-2")>
                    {j`단품번호`->React.string}
                  </label>
                  <Input
                    type_="text"
                    name="sku-nos"
                    placeholder={`단품번호 입력 (","로 구분 가능)`}
                    value={form.values->FormFields.get(FormFields.SkuNos)}
                    onChange={FormFields.SkuNos->form.handleChange->ReForm.Helpers.handleChange}
                    error={FormFields.SkuNos->Form.ReSchema.Field->form.getFieldError}
                    tabIndex=4
                  />
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
      <div className=%twc("flex justify-center mt-5")>
        <input
          type_="button"
          className=%twc(
            "w-20 py-2 bg-gray-button-gl text-black-gl rounded-xl ml-2 hover:bg-gray-button-gl focus:outline-none focus:ring-2 focus:ring-offset-1 focus:ring-gray-gl focus:ring-opacity-100"
          )
          value={`초기화`}
          onClick={handleOnReset}
          tabIndex=5
        />
        <input
          type_="submit"
          className=%twc(
            "w-20 py-2 bg-green-gl text-white font-bold rounded-xl ml-2 hover:bg-green-gl-dark focus:outline-none focus:ring-2 focus:ring-offset-1 focus:ring-green-gl focus:ring-opacity-100"
          )
          value={`검색`}
          tabIndex=4
        />
      </div>
    </form>
  </div>
}
