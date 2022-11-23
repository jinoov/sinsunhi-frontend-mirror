open HookForm

type fields = {
  email: string,
  password: string,
  name: string,
  manager: string,
  @as("phone-number") phoneNumber: string,
  @as("business-number")
  bizNumber: string,
  @as("basic-term")
  basicTerm: bool,
  @as("privacy-term")
  privacyTerm: bool,
  @as("marketing-term")
  marketingTerm: bool,
}

let initial = {
  email: "",
  password: "",
  name: "",
  manager: "",
  phoneNumber: "",
  bizNumber: "",
  basicTerm: false,
  privacyTerm: false,
  marketingTerm: false,
}
module Form = HookForm.Make({
  type t = fields
})

let email = %re(
  "/^((([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+(\.([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+)*)|((\x22)((((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(([\x01-\x08\x0b\x0c\x0e-\x1f\x7f]|\x21|[\x23-\x5b]|[\x5d-\x7e]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(\\([\x01-\x09\x0b\x0c\x0d-\x7f]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))))*(((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(\x22)))@((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))$/i"
)

module Inputs = {
  module Email = Form.MakeInput({
    type t = string
    let name = "email"
    let config = Rules.makeWithErrorMessage({
      required: {value: true, message: `이메일을 입력해주세요.`},
      pattern: {value: email, message: `올바른 이메일 주소를 입력해주세요.`},
    })
  })
  module Password = Form.MakeInput({
    type t = string
    let name = "password"
    let config = Rules.makeWithErrorMessage({
      required: {value: true, message: `비밀번호를 입력해주세요.`},
      pattern: {
        value: %re("/^(?=.*\d)(?=.*[a-zA-Z]).{6,15}$/"),
        message: `영문, 숫자 조합 6~15자로 입력해 주세요.`,
      },
    })
  })
  module Name = Form.MakeInput({
    type t = string
    let name = "name"
    let config = Rules.makeWithErrorMessage({
      required: {
        value: true,
        message: `회사명을 입력해주세요.`,
      },
    })
  })
  module Manager = Form.MakeInput({
    type t = string
    let name = "manager"
    let config = Rules.makeWithErrorMessage({
      required: {
        value: true,
        message: `담당자명을 입력해주세요.`,
      },
    })
  })
  module PhoneNumber = Form.MakeInput({
    type t = string
    let name = "phone-number"
    let config = Rules.makeWithErrorMessage({
      required: {value: true, message: `휴대전화를 입력해주세요.`},
      pattern: {
        value: %re("/^\d{3}-\d{3,4}-\d{4}$/"),
        message: `휴대전화 번호를 다시 확인해주세요.`,
      },
    })
  })

  module BizNumber = Form.MakeInput({
    type t = string
    let name = "business-number"
    let config = Rules.makeWithErrorMessage({
      required: {value: true, message: `사업자 등록번호를 입력해주세요.`},
      pattern: {
        value: %re("/^\d{3}-\d{2}-\d{5}$/"),
        message: `사업자 등록번호 형식을 확인해주세요.`,
      },
    })
  })

  module BasicTerm = Form.MakeInput({
    type t = bool
    let name = "basic-term"
    let config = Rules.makeWithErrorMessage({
      required: {
        value: true,
        message: `필수 약관에 동의해주세요.`,
      },
    })
  })
  module PrivacyTerm = Form.MakeInput({
    type t = bool
    let name = "privacy-term"
    let config = Rules.makeWithErrorMessage({
      required: {
        value: true,
        message: `필수 약관에 동의해주세요.`,
      },
    })
  })

  module MarketingTerm = Form.MakeInput({
    type t = bool
    let name = "marketing-term"
    let config = Rules.empty()
  })
}
