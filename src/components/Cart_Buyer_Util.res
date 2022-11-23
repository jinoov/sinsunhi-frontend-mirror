open ReactHookForm
module Form = Cart_Buyer_Form

@module("../../public/assets/checkbox-checked.svg")
external checkboxCheckedIcon: string = "default"

@module("../../public/assets/checkbox-dim-unchecked.svg")
external checkboxUncheckedIcon: string = "default"

@module("../../public/assets/checkbox-disable.svg")
external checkboxDisableIcon: string = "default"

// React Hook Form에 데이터를 기록하기 위한 hidden input입니다.
module Hidden = {
  module Checkbox = {
    @react.component
    let make = (~checked, ~inputName) => {
      let {register, setValue} = Hooks.Context.use(.
        ~config=Hooks.Form.config(~mode=#all, ~shouldUnregister=true, ()),
        (),
      )

      let {ref, name} = register(. inputName, None)

      React.useEffect1(_ => {
        setValue(. inputName, Js.Json.boolean(checked))
        None
      }, [checked])

      <input type_="checkbox" id=name ref name checked />
    }
  }

  module NullableNumberInput = {
    @react.component
    let make = (~value, ~inputName) => {
      let {register, setValue} = Hooks.Context.use(.
        ~config=Hooks.Form.config(~mode=#all, ~shouldUnregister=true, ()),
        (),
      )

      let {ref, name} = register(.
        inputName,
        Some(Hooks.Register.config(~valueAsNumber=value->Option.isSome, ())),
      )

      // 1. React-Hook-Form에서 valueAsNumber 설정으로인해 ""(empty string)이 NaN으로 파싱됨을 방지합니다.
      // 2. React-Hook-Form에서 handleSubmit 등의 rerender과정을 거칠 때, input value가 undefined로 초기화됨을 방지합니다. (Json에 undefined가 존재할 수 없음)
      switch value->Option.isSome {
      | true => ()
      | false => setValue(. inputName, Js.Json.null)
      }

      <input type_="hidden" id=name ref name defaultValue=?value ?value />
    }
  }

  module NumberInput = {
    @react.component
    let make = (~value, ~inputName) => {
      let {register, setValue} = Hooks.Context.use(.
        ~config=Hooks.Form.config(~mode=#all, ~shouldUnregister=true, ()),
        (),
      )

      let {ref, name} = register(. inputName, Some(Hooks.Register.config(~valueAsNumber=true, ())))

      React.useEffect1(_ => {
        setValue(. inputName, Js.Json.string(value))
        None
      }, [value])

      <input type_="hidden" id=name ref name defaultValue=value value />
    }
  }

  @react.component
  let make = (~value, ~inputName) => {
    let {register, setValue} = Hooks.Context.use(.
      ~config=Hooks.Form.config(~mode=#all, ~shouldUnregister=true, ()),
      (),
    )
    let {ref, name} = register(. inputName, None)
    React.useEffect1(_ => {
      setValue(. inputName, Js.Json.string(value->Option.getWithDefault("")))
      None
    }, [value])

    <input type_="hidden" id=name ref name defaultValue=?value />
  }
}

module Checkbox = {
  @react.component
  let make = (~name, ~watchNames=[], ~targetNames=[], ~status) => {
    let {control, setValue} = Hooks.Context.use(.
      ~config=Hooks.Form.config(~mode=#onChange, ()),
      (),
    )

    let watchValues = Hooks.WatchValues.use(
      Hooks.WatchValues.Checkboxes,
      ~config=Hooks.WatchValues.config(~name=watchNames, ()),
      (),
    )

    let handleCheckBox = (changeFn, v) =>
      ReactEvents.interceptingHandler(_ => {
        v
        ->Js.Json.decodeBoolean
        ->Option.forEach(v' => {
          changeFn(Controller.OnChangeArg.value(!v'->Js.Json.boolean))
          targetNames->Array.forEach(targetName => setValue(. targetName, !v'->Js.Json.boolean))
        })
      })

    React.useEffect1(_ => {
      watchValues
      ->Option.map(watchValues' =>
        switch watchValues'->Array.length == watchNames->Array.length {
        | true =>
          watchValues'
          ->Array.keepMap(Garter.Fn.identity)
          ->Array.reduce(true, (acc, cur) => acc && cur)
        | false => true
        }
      )
      ->Option.forEach(b => setValue(. name, b->Js.Json.boolean))
      None
    }, [watchValues])

    <Controller
      control
      name
      defaultValue={true->Js.Json.boolean}
      render={({field: {onChange, value}}) => {
        switch (status->Form.soldable, targetNames) {
        | (false, _)
        | (_, []) =>
          <img
            src={checkboxDisableIcon}
            alt="check-diable-icon"
            className=%twc("w-6 h-6 min-w-max self-start")
          />
        | _ =>
          <button
            className=%twc("self-start w-6 h-6 min-w-max")
            onClick={handleCheckBox(onChange, value)}>
            <img
              src={value->Js.Json.decodeBoolean->Option.getWithDefault(false)
                ? checkboxCheckedIcon
                : checkboxUncheckedIcon}
              alt="check-icon"
              className=%twc("w-6 h-6 min-w-max")
            />
          </button>
        }
      }}
    />
  }
}
module SubmitDialog = {
  @react.component
  let make = (~_open, ~setOpen) =>
    <RadixUI.Dialog.Root _open>
      <RadixUI.Dialog.Portal>
        <RadixUI.Dialog.Overlay className=%twc("dialog-overlay") />
        <RadixUI.Dialog.Content
          className=%twc(
            "dialog-content p-7 bg-white rounded-xl w-[480px] flex flex-col gap-7 items-center justify-center"
          )
          onOpenAutoFocus={ReactEvent.Synthetic.preventDefault}>
          <span className=%twc("whitespace-pre text-center text-text-L1 pt-3")>
            {`주문하실 상품을
선택해주세요`->React.string}
          </span>
          <div className=%twc("flex w-full justify-center items-center gap-2")>
            <button
              className=%twc("w-1/2 rounded-xl h-13 bg-enabled-L5")
              onClick={ReactEvents.interceptingHandler(_ => setOpen(._ => false))}>
              {`확인`->React.string}
            </button>
          </div>
        </RadixUI.Dialog.Content>
      </RadixUI.Dialog.Portal>
    </RadixUI.Dialog.Root>
}

module HiddenInputs = {
  @react.component
  let make = (~data: array<Form.cartItem>, ~prefix) => {
    let parnetFormName = Form.names(prefix)

    {
      data
      ->Array.mapWithIndex((cartIndex, cartItem) => {
        let {productName, imageUrl, productId, productStatus, updatedAt, productOptions} = cartItem
        let formNames = Form.names(`${parnetFormName.cartItems}.${cartIndex->Int.toString}`)
        <div key=formNames.name className=%twc("hidden")>
          <Hidden.NumberInput inputName={formNames.productId} value={productId->Int.toString} />
          <Hidden inputName={formNames.productName} value={Some(productName)} />
          <Hidden.NumberInput inputName={formNames.checkedNumber} value={3->Int.toString} />
          <Hidden
            inputName={formNames.productStatus}
            value={productStatus->Form.productStatus_encode->Js.Json.decodeString}
          />
          <Hidden inputName={formNames.imageUrl} value={Some(imageUrl)} />
          <Hidden inputName={formNames.updatedAt} value={Some(updatedAt)} />
          {productOptions
          ->Array.mapWithIndex((optionIndex, productOption) => {
            let formNames2 = Form.names(`${formNames.productOptions}.${optionIndex->Int.toString}`)
            let {
              productOptionId,
              optionStatus,
              price,
              quantity,
              updatedAt,
              productOptionName,
              cartId,
              adhocStockIsLimited,
              adhocStockIsNumRemainingVisible,
              adhocStockNumRemaining,
            } = productOption
            <div key=formNames2.name>
              <Hidden.NumberInput inputName={formNames2.cartId} value={cartId->Int.toString} />
              <Hidden.NumberInput
                inputName={formNames2.productOptionId} value={productOptionId->Int.toString}
              />
              <Hidden
                inputName={formNames2.optionStatus}
                value={optionStatus->Form.productStatus_encode->Js.Json.decodeString}
              />
              <Hidden.NumberInput inputName=formNames2.price value={price->Int.toString} />
              <Hidden.NumberInput inputName=formNames2.quantity value={quantity->Int.toString} />
              <Hidden inputName=formNames2.updatedAt value={Some(updatedAt)} />
              <Hidden inputName=formNames2.productOptionName value={Some(productOptionName)} />
              <Hidden.Checkbox
                inputName=formNames2.adhocStockIsLimited checked={adhocStockIsLimited}
              />
              <Hidden.Checkbox
                inputName=formNames2.adhocStockIsNumRemainingVisible
                checked={adhocStockIsNumRemainingVisible}
              />
              <Hidden.NullableNumberInput
                inputName=formNames2.adhocStockNumRemaining
                value={adhocStockNumRemaining->Option.map(x => x->Int.toString)}
              />
            </div>
          })
          ->React.array}
        </div>
      })
      ->React.array
    }
  }
}

module RadioButton = {
  module PlaceHolder = {
    @react.component
    let make = () => {
      open Skeleton
      <Box className=%twc("w-32 xl:w-52 min-h-[2.75rem] rounded-xl") />
    }
  }
  module PC = {
    @react.component
    let make = (~watchValue, ~name, ~value) => {
      let checked = watchValue->Option.mapWithDefault(false, watch => watch == value)
      <div
        className={checked
          ? %twc(
              "w-full pt-7 pb-4 border border-x-0 border-t-0 text-lg text-center text-text-L1 font-bold border-border-active cursor-pointer "
            )
          : %twc(
              "w-full pt-7 pb-4 border border-x-0 border-t-0 text-lg text-center text-text-L2 font-bold border-border-default-L2 cursor-pointer"
            )}>
        {name->React.string}
      </div>
    }
  }

  module MO = {
    @react.component
    let make = (~watchValue, ~name, ~value) => {
      let checked = watchValue->Option.mapWithDefault(false, watch => watch == value)
      <div
        className={checked
          ? %twc(
              "w-full pt-4 pb-4 border border-x-0 border-t-0 text-base text-center text-text-L1 font-bold border-border-active cursor-pointer "
            )
          : %twc(
              "w-full pt-4 pb-4 border border-x-0 border-t-0 text-base text-center text-text-L2 font-bold border-border-default-L2 cursor-pointer"
            )}>
        {name->React.string}
      </div>
    }
  }
}
