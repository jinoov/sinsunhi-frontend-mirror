type rec valueType<_> = String: valueType<string> | Integer: valueType<int>

type error = {type_: string, message: string}
type validator<'a> = 'a => Result.t<'a, error>
type setState<'a> = ('a, ~shouldValidate: bool=?, unit) => unit
type validateState = {
  validate: unit => bool,
  error: option<error>,
}

let validate:
  type a. (valueType<a>, a, array<validator<a>>) => Result.t<a, error> =
  (_, value, vs) => {
    vs->Array.reduce(Result.Ok(value), (r, v) => {
      switch (r, value->v) {
      | (Ok(data), Ok(_)) => Ok(data)
      | (Ok(_), Error(err)) => Error(err)
      | (Error(err), _) => Error(err)
      }
    })
  }

let use:
  type a. (valueType<a>, a, ~validators: array<validator<a>>) => (a, setState<a>, validateState) =
  (type_, value, ~validators) => {
    let (value, setValue) = React.Uncurried.useState(_ => value)
    let (error, setError) = React.Uncurried.useState(_ => None)

    let setState = (newValue, ~shouldValidate=false, ()) => {
      setValue(._ => newValue)

      if shouldValidate {
        let newError = switch validate(type_, newValue, validators) {
        | Ok(_) => None
        | Error(err) => Some(err)
        }

        setError(._ => newError)
      }
    }

    let validateState = {
      validate: () => {
        let (newError, result) = switch validate(type_, value, validators) {
        | Ok(_) => (None, true)
        | Error(err) => (Some(err), false)
        }
        setError(._ => newError)

        result
      },
      error,
    }

    (value, setState, validateState)
  }
