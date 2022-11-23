type t = {
  @as("contact-md") contactMd: SearchAdmin_Admin.Item.t,
  @as("sourcing-md-1") sourcingMd1: SearchAdmin_Admin.Item.t,
  @as("sourcing-md-2") sourcingMd2: SearchAdmin_Admin.Item.t,
  @as("sourcing-md-3") sourcingMd3: SearchAdmin_Admin.Item.t,
  address: string,
}

module FormHandler = HookForm.Make({
  type t = t
})

module ContactMd = {
  module Field = FormHandler.MakeInput({
    type t = SearchAdmin_Admin.Item.t
    let name = "contact-md"
    let config = HookForm.Rules.empty()
  })

  module Select = {
    @react.component
    let make = (~form) => {
      form->Field.renderController(({field: {value, onChange}}) => {
        let error = form->Field.error->Option.map(({message}) => message)
        <div className=%twc("relative w-full")>
          <SearchAdmin_Admin value onChange placeholder="담당자 검색" />
          {error->Option.mapWithDefault(React.null, errMsg =>
            <ErrorText className=%twc("absolute") errMsg />
          )}
        </div>
      }, ())
    }
  }
}

module SourcingMd1 = {
  module Field = FormHandler.MakeInput({
    type t = SearchAdmin_Admin.Item.t
    let name = "sourcing-md-1"
    let config = HookForm.Rules.empty()
  })

  module Select = {
    @react.component
    let make = (~form) => {
      form->Field.renderController(({field: {value, onChange}}) => {
        let error = form->Field.error->Option.map(({message}) => message)
        <div className=%twc("relative w-full")>
          <SearchAdmin_Admin value onChange placeholder="담당자 검색" />
          {error->Option.mapWithDefault(React.null, errMsg =>
            <ErrorText className=%twc("absolute") errMsg />
          )}
        </div>
      }, ())
    }
  }
}

module SourcingMd2 = {
  module Field = FormHandler.MakeInput({
    type t = SearchAdmin_Admin.Item.t
    let name = "sourcing-md-2"
    let config = HookForm.Rules.empty()
  })

  module Select = {
    @react.component
    let make = (~form) => {
      form->Field.renderController(({field: {value, onChange}}) => {
        let error = form->Field.error->Option.map(({message}) => message)
        <div className=%twc("relative w-full")>
          <SearchAdmin_Admin value onChange placeholder="담당자 검색" />
          {error->Option.mapWithDefault(React.null, errMsg =>
            <ErrorText className=%twc("absolute") errMsg />
          )}
        </div>
      }, ())
    }
  }
}

module SourcingMd3 = {
  module Field = FormHandler.MakeInput({
    type t = SearchAdmin_Admin.Item.t
    let name = "sourcing-md-3"
    let config = HookForm.Rules.empty()
  })

  module Select = {
    @react.component
    let make = (~form) => {
      form->Field.renderController(({field: {value, onChange}}) => {
        let error = form->Field.error->Option.map(({message}) => message)
        <div className=%twc("relative w-full")>
          <SearchAdmin_Admin value onChange placeholder="담당자 검색" />
          {error->Option.mapWithDefault(React.null, errMsg =>
            <ErrorText className=%twc("absolute") errMsg />
          )}
        </div>
      }, ())
    }
  }
}

module Address = {
  module Field = FormHandler.MakeInput({
    type t = string
    let name = "address"
    let config = HookForm.Rules.empty()
  })

  module Input = {
    @react.component
    let make = (~form) => {
      let {ref, name, onChange, onBlur} = form->Field.register()

      <textarea
        className=%twc(
          "p-3 w-full h-18 border border-border-default-L1 rounded-lg focus:outline-none focus:border-border-active resize-none text-sm"
        )
        ref
        name
        placeholder={`배송지를 입력해주세요.`}
        maxLength=400
        onChange
        onBlur
      />
    }
  }
}
