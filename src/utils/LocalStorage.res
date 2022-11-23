let getFromLS = k =>
  %external(window)->Option.flatMap(_ => Dom_storage2.localStorage->Dom_storage2.getItem(k))
let setToLS = (k, v) =>
  %external(window)->Option.map(_ => Dom_storage2.localStorage->Dom_storage2.setItem(k, v))->ignore
let removeFromLS = k =>
  %external(window)->Option.map(_ => Dom_storage2.localStorage->Dom_storage2.removeItem(k))->ignore

module type Config = {
  type t
  let key: string
  let fromString: string => t
  let toString: t => string
}

module Make = (Config: Config) => {
  type t = Config.t

  let get = () => getFromLS(Config.key)->Option.map(Config.fromString)
  let set = value => setToLS(Config.key, value->Config.toString)
  let remove = () => removeFromLS(Config.key)
  let useLocalStorage = () => {
    let (state, setState) = React.Uncurried.useState(_ => None)

    React.useEffect0(() => {
      setState(._ => get())
      None
    })

    let setValue = value => {
      set(value)
      setState(._ => Some(value))
    }

    (state, setValue)
  }
}
