type settled<'a> = {
  status: string,
  value?: 'a,
  reason?: Js.Promise.error,
}

@scope("Promise") @val
external allSettled: array<Js.Promise.t<'a>> => Js.Promise.t<array<settled<'a>>> = "allSettled"

@scope("Promise") @val
external allSettled2: ((Js.Promise.t<'a>, Js.Promise.t<'b>)) => Js.Promise.t<(
  settled<'a>,
  settled<'b>,
)> = "allSettled"

@scope("Promise") @val
external allSettled3: ((Js.Promise.t<'a>, Js.Promise.t<'b>, Js.Promise.t<'c>)) => Js.Promise.t<(
  settled<'a>,
  settled<'b>,
  settled<'c>,
)> = "allSettled"

@scope("Promise") @val
external allSettled4: (
  (Js.Promise.t<'a>, Js.Promise.t<'b>, Js.Promise.t<'c>, Js.Promise.t<'d>)
) => Js.Promise.t<(settled<'a>, settled<'b>, settled<'c>, settled<'d>)> = "allSettled"

@scope("Promise") @val
external allSettled5: (
  (Js.Promise.t<'a>, Js.Promise.t<'b>, Js.Promise.t<'c>, Js.Promise.t<'d>, Js.Promise.t<'e>)
) => Js.Promise.t<(settled<'a>, settled<'b>, settled<'c>, settled<'d>, settled<'e>)> = "allSettled"

@scope("Promise") @val
external allSettled6: (
  (
    Js.Promise.t<'a>,
    Js.Promise.t<'b>,
    Js.Promise.t<'c>,
    Js.Promise.t<'d>,
    Js.Promise.t<'e>,
    Js.Promise.t<'f>,
  )
) => Js.Promise.t<(settled<'a>, settled<'b>, settled<'c>, settled<'d>, settled<'e>, settled<'f>)> =
  "allSettled"
