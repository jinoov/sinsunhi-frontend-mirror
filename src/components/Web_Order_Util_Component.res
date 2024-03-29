module Tooltip = {
  module PC = {
    @react.component
    let make = (~children, ~className="") => {
      <RadixUI.Tooltip.Root delayDuration=300 className=%twc("absolute")>
        <RadixUI.Tooltip.Trigger>
          <img
            onClick={e => e->ReactEvent.Synthetic.preventDefault}
            src="/icons/icon_common_tooltip_q_line_20.png"
            className={cx([%twc("w-5 h-5"), className])}
            alt=""
          />
        </RadixUI.Tooltip.Trigger>
        <RadixUI.Tooltip.Content side=#top sideOffset=10 avoidCollisions=false>
          <div className=%twc("relative w-96")>
            <div
              className=%twc(
                "absolute bottom-0 left-28 block min-w-min bg-white px-6 py-2 border-primary border rounded-xl text-sm font-bold text-primary-variant"
              )>
              {children}
              <div
                className=%twc(
                  "absolute left-20 h-3 w-3 -bottom-1.5 rounded-sm bg-white border-b border-r border-primary-variant transform -translate-x-1/2 rotate-45"
                )
              />
            </div>
          </div>
        </RadixUI.Tooltip.Content>
      </RadixUI.Tooltip.Root>
    }
  }

  module Mobile = {
    @react.component
    let make = (~children, ~className="") => {
      let (touch, setTouch) = React.useState(_ => false)

      React.useEffect1(_ => {
        if touch {
          Js.Global.setTimeout(() => setTouch(_ => false), 2000)->ignore
        }
        None
      }, [touch])

      <RadixUI.Tooltip.Root _open=touch delayDuration=300 className=%twc("absolute")>
        <RadixUI.Tooltip.Trigger>
          <img
            onClick={e => {
              e->ReactEvent.Synthetic.preventDefault
              setTouch(_ => !touch)
            }}
            src="/icons/icon_common_tooltip_q_line_20.png"
            className={cx([%twc("w-5 h-5"), className])}
            alt=""
          />
        </RadixUI.Tooltip.Trigger>
        <RadixUI.Tooltip.Content side=#top sideOffset=10 avoidCollisions=false>
          <div className=%twc("relative w-96")>
            <div
              className=%twc(
                "absolute bottom-0 left-28 block min-w-min bg-white px-6 py-2 border-primary border rounded-xl text-sm font-bold text-primary-variant"
              )>
              {children}
              <div
                className=%twc(
                  "absolute left-20 h-3 w-3 -bottom-1.5 rounded-sm bg-white border-b border-r border-primary-variant transform -translate-x-1/2 rotate-45"
                )
              />
            </div>
          </div>
        </RadixUI.Tooltip.Content>
      </RadixUI.Tooltip.Root>
    }
  }
}

module RadioButton = {
  module PlaceHolder = {
    open Skeleton
    module PC = {
      @react.component
      let make = () => {
        <Box className=%twc("w-32 min-h-[2.75rem] rounded-xl") />
      }
    }
    module MO = {
      @react.component
      let make = () => {
        <Box className=%twc("w-24 min-h-[2.75rem] rounded-xl") />
      }
    }
  }

  module PC = {
    @react.component
    let make = (~checked, ~name) => {
      <span
        className={checked
          ? %twc(
              "w-32 h-11 pl-1 flex justify-center items-center text-base text-primary font-bold border border-primary bg-primary-light rounded-xl cursor-pointer"
            )
          : %twc(
              "w-32 h-11 flex justify-center items-center text-base text-text-L1 border border-div-border-L2 rounded-xl cursor-pointer"
            )}>
        {name->React.string}
        {checked
          ? <IconCheck width="30" height="20" fill="#12b564" className=%twc("mb-1") />
          : React.null}
      </span>
    }
  }

  module MO = {
    @react.component
    let make = (~checked, ~name) => {
      <span
        className={checked
          ? %twc(
              "w-24 h-11 pl-1 flex justify-center items-center text-sm text-primary font-bold border border-primary bg-primary-light rounded-xl cursor-pointer"
            )
          : %twc(
              "w-24 h-11 flex justify-center items-center text-sm text-text-L1 border border-div-border-L2 rounded-xl cursor-pointer"
            )}>
        {name->React.string}
        {checked
          ? <IconCheck width="30" height="20" fill="#12b564" className=%twc("mb-1") />
          : React.null}
      </span>
    }
  }

  @react.component
  let make = (~watchValue, ~name, ~value, ~deviceType) => {
    let checked = watchValue->Option.mapWithDefault(false, watch => watch == value)

    {
      switch deviceType {
      | DeviceDetect.Unknown => React.null
      | DeviceDetect.PC => <PC checked name />
      | DeviceDetect.Mobile => <MO checked name />
      }
    }
  }
}
open ReactHookForm
module Hidden = {
  @react.component
  let make = (~value, ~inputName, ~isNumber=false) => {
    let {register} = Hooks.Context.use(. ~config=Hooks.Form.config(~mode=#all, ()), ())
    let {ref, name} = register(.
      inputName,
      isNumber ? Some(Hooks.Register.config(~valueAsNumber=true, ())) : None,
    )

    <input type_="hidden" id=name ref name defaultValue=?value />
  }
}
