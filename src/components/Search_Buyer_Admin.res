module FormFields = Query_Buyer_Form_Admin.FormFields
module Form = Query_Buyer_Form_Admin.Form

let stringToPhoneFormat = str => {
  str
  ->Js.String2.replaceByRe(%re("/[^0-9]/g"), "")
  ->Js.String2.replaceByRe(%re("/(^1[0-9]{3}|^0[0-9]{2})([0-9]+)?([0-9]{4})$/"), "$1-$2-$3")
  ->Js.String2.replace("--", "-")
}

@react.component
let make = () => {
  let router = Next.Router.useRouter()

  let onSubmit = ({state}: Form.onSubmitAPI) => {
    let name = state.values->FormFields.get(FormFields.Name)
    let email = state.values->FormFields.get(FormFields.Email)
    let phone =
      state.values
      ->FormFields.get(FormFields.Phone)
      ->Garter.String.replaceByRe(Js.Re.fromStringWithFlags("\\-", ~flags="g"), "")

    let {makeWithDict, toString} = module(Webapi.Url.URLSearchParams)

    router.query->Js.Dict.set("name", name)
    router.query->Js.Dict.set("email", email)
    router.query->Js.Dict.set("phone", phone)
    router.query->Js.Dict.set("offset", "0")

    router->Next.Router.push(`${router.pathname}?${router.query->makeWithDict->toString}`)

    None
  }

  let form: Form.api = Form.use(
    ~validationStrategy=Form.OnChange,
    ~onSubmit,
    ~initialState=Query_Buyer_Form_Admin.initialState,
    ~schema={
      open Form.Validation
      Schema([]->Array.concatMany)
    },
    (),
  )

  let handleOnSubmit = (
    _ => {
      form.submit()
    }
  )->ReactEvents.interceptingHandler

  React.useEffect1(_ => {
    form.resetForm()

    router.query
    ->Js.Dict.entries
    ->Garter.Array.forEach(entry => {
      let (k, v) = entry
      if k === "name" {
        FormFields.Name->form.setFieldValue(v, ~shouldValidate=false, ())
      } else if k === "email" {
        FormFields.Email->form.setFieldValue(v, ~shouldValidate=false, ())
      } else if k === "phone" {
        FormFields.Phone->form.setFieldValue(v->stringToPhoneFormat, ~shouldValidate=false, ())
      }
    })

    None
  }, [router.query])

  let handleOnReset = (
    _ => {
      FormFields.Name->form.setFieldValue("", ~shouldValidate=false, ())
      FormFields.Email->form.setFieldValue("", ~shouldValidate=false, ())
      FormFields.Phone->form.setFieldValue("", ~shouldValidate=false, ())
    }
  )->ReactEvents.interceptingHandler

  let handleOnChangePhone = e => {
    let newValue = (e->ReactEvent.Synthetic.currentTarget)["value"]->stringToPhoneFormat

    FormFields.Phone->form.setFieldValue(newValue, ~shouldValidate=true, ())
  }

  <div className=%twc("p-7 mt-4 bg-white rounded shadow-gl")>
    <form onSubmit={handleOnSubmit}>
      <div className=%twc("py-3 flex flex-col text-sm bg-gray-gl rounded-xl")>
        <div className=%twc("flex")>
          <div className=%twc("w-32 font-bold mt-2 pl-7 whitespace-nowrap")>
            {j`검색`->React.string}
          </div>
          <div className=%twc("flex-1")>
            <div className=%twc("flex gap-10")>
              <div
                className=%twc(
                  "flex-1 flex flex-col sm:flex-initial sm:w-64 sm:flex-row sm:items-center"
                )>
                <label htmlFor="name" className=%twc("whitespace-nowrap mr-2 w-18")>
                  {j`바이어명`->React.string}
                </label>
                <Input
                  type_="text"
                  name="name"
                  id="name"
                  placeholder={`바이어명 입력`}
                  value={form.values->FormFields.get(FormFields.Name)}
                  onChange={FormFields.Name->form.handleChange->ReForm.Helpers.handleChange}
                  error={FormFields.Name->Form.ReSchema.Field->form.getFieldError}
                  tabIndex=1
                />
              </div>
              <div className=%twc("min-w-1/2 flex items-center")>
                <label htmlFor="email" className=%twc("whitespace-nowrap mr-2")>
                  {j`이메일`->React.string}
                </label>
                <span className=%twc("flex-1")>
                  <Input
                    type_="text"
                    name="email"
                    id="email"
                    placeholder={`이메일 입력`}
                    value={form.values->FormFields.get(FormFields.Email)}
                    onChange={FormFields.Email->form.handleChange->ReForm.Helpers.handleChange}
                    error={FormFields.Email->Form.ReSchema.Field->form.getFieldError}
                    tabIndex=2
                  />
                </span>
              </div>
            </div>
            <div className=%twc("flex mt-4")>
              <div
                className=%twc(
                  "flex-1 flex flex-col sm:flex-initial sm:w-64 sm:flex-row sm:items-center"
                )>
                <label htmlFor="phone" className=%twc("whitespace-nowrap mr-2 w-18")>
                  {j`휴대전화번호`->React.string}
                </label>
                <Input
                  type_="text"
                  name="phone"
                  id="phone"
                  placeholder={`휴대전화번호 입력`}
                  value={form.values->FormFields.get(FormFields.Phone)}
                  onChange={handleOnChangePhone}
                  error={FormFields.Phone->Form.ReSchema.Field->form.getFieldError}
                  tabIndex=3
                />
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
